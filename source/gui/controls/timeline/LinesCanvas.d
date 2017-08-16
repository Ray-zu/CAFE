/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.gui.controls.timeline.LinesCanvas;
import cafe.gui.Action,
       cafe.gui.utils.Rect,
       cafe.gui.controls.Chooser,
       cafe.gui.controls.PropertyEditor,
       cafe.gui.controls.timeline.Action,
       cafe.gui.controls.timeline.Cache,
       cafe.gui.controls.timeline.SnapCorrector,
       cafe.project.ObjectPlacingInfo;
import std.algorithm,
       std.conv,
       std.math;
import dlangui,
       dlangui.widgets.metadata,
       dlangui.dialogs.dialog;

mixin( registerWidgets!LinesCanvas );

/+ タイムラインの描画 +/
class LinesCanvas : CanvasWidget
{
    private:
        Cache cache;

        bool dragging = false;

        uint base_line_height = 30;

        @property topHiddenPx ()
        {
            auto top = cache.timeline.topLineIndex;
            auto index    = top.trunc.to!int;
            auto fraction = top - index;
            return (cache.lines[index].heightMag*baseLineHeight*fraction).to!int;
        }

        @property yToLineId ( int y )
        {
            auto ry = y - pos.top;
            auto i  = cache.timeline.topLineIndex.to!int;
            auto h  = -topHiddenPx;
            while ( h < ry && i < cache.lines.length )
                h += (cache.lines[i++].heightMag * baseLineHeight).to!int;
            return  h < ry ? -1 : i-1;
        }

        @property xToFrame ( int x )
        {
            auto st      = cache.timeline.leftFrame.to!int;
            auto ppf     = cache.pxPerFrame;
            auto f       = st + ((x-pos.left-cache.headerWidth.to!int)/ppf);
            return max( 0, min( f, cache.timeline.length.value-1 ) );
        }

    public:
        @property baseLineHeight () { return base_line_height; }
        @property baseLineHeight ( uint blh )
        {
            base_line_height = blh;
            invalidate;
        }

        this ( string id = "" )
        {
            super( id );
            styleId = "TIMELINE_LINES_CANVAS";
            trackHover = true;
            clickable = true;
        }

        auto setCache ( Cache c )
        {
            if ( cache )
                throw new Exception( "Can't redefine cache." );
            cache = c;
        }

        override uint getCursorType ( int x, int y )
        {
            auto header  = (x-pos.left) < cache.headerWidth;
            auto f = xToFrame( x );
            auto l = yToLineId( y );
            if ( l < -1 || l >= cache.lines.length )
                return cast(uint) CursorType.Arrow;
            else return cast(uint) header ?
                CursorType.Arrow : cache.lines[l].cursor( f );
        }

        override void measure ( int w, int h )
        {
            measuredContent( w, h, w, h );
        }

        override void onDraw ( DrawBuf b )
        {
            super.onDraw( b );
            if ( !cache.timeline ) return;

            /+ ライン描画 +/
            auto top = cache.timeline.topLineIndex.to!int;
            auto y   = -topHiddenPx;
            foreach ( l; cache.lines[top .. $] ) {
                if ( y >= pos.height ) break;
                auto h = (l.heightMag * baseLineHeight).to!int;
                auto b_space = l.needBorder ? 1 : 0;

                auto header_r = Rect( pos.left, pos.top + y + b_space,
                        pos.left + cache.headerWidth, pos.top + y + h );
                b.clipRect = header_r.shrinkRect( pos );
                l.drawHeader( b, header_r );

                auto content_r = Rect( pos.left+cache.headerWidth,
                        pos.top + y + b_space, pos.right, pos.top + y + h );
                b.clipRect = content_r.shrinkRect( pos );
                l.drawContent( b, content_r );

                b.resetClipping;
                if ( y >= 0 && b_space )
                    b.drawLine( Point(pos.left,pos.top+y),
                        Point(pos.right,pos.top+y), textColor );
                y += h;
            }
            b.drawLine( Point(pos.left,pos.top+y),
                    Point(pos.right,pos.top+y), textColor );

            /+ カレントフレーム表示 +/
            auto st  = cache.timeline.leftFrame;
            auto ed  = cache.timeline.rightFrame;
            auto ppf = cache.pxPerFrame;
            auto cf  = cache.timeline.frame.value;

            if ( cf >= st && cf < ed ) {
                auto x = pos.left + cache.headerWidth + ((cf-st)*ppf).to!int;
                auto col = style.customColor( "timeline_line_canvas_current_frame" );
                b.drawLine( Point(x,pos.top), Point(x,pos.bottom), col );
            }
        }

        override bool onMouseEvent ( MouseEvent e )
        {
            auto line_id = yToLineId( e.y );
            if ( line_id < 0 || line_id >= cache.lines.length ) return false;

            /+ 関連データ取得 +/
            auto line    = cache.lines[line_id];
            auto header  = (e.x-pos.left) < cache.headerWidth;
            auto left    = e.button == MouseButton.Left;
            auto right   = e.button == MouseButton.Right;
            auto f       = xToFrame( e.x );

            auto trans_ev   = dragging;
            auto redraw_obj = false;

            if ( left && e.action == MouseAction.ButtonDown ) {
                // 左クリック押し始め
                if ( header )
                    line.onHeaderLeftClicked;
                else {
                    line.onContentLeftClicked( f );
                }
                dragging   = true;
                trans_ev   = !cache.operation.isHandled;
                redraw_obj = cache.operation.isProcessing;

            } else if ( (left && e.action == MouseAction.ButtonUp) || e.action == MouseAction.Cancel ) {
                // 左クリック押し終わり
                dragging   = false;
                trans_ev   = !cache.operation.isHandled;
                redraw_obj = cache.operation.isHandled;
                cache.operation.release( cache.correct(f) );

            } else if ( e.action == MouseAction.Move ) {
                // カーソル動いた
                cache.operation.move( cache.correct(f), line_id );
                trans_ev   = !cache.operation.isHandled && dragging;
                redraw_obj = cache.operation.isProcessing;

            } else if ( right && e.action == MouseAction.ButtonDown ) {
                // 右クリック押し始め
                MenuItem menu = header ? line.headerMenu : line.contentMenu( f );
                if ( menu ) {
                    auto popup_menu = new PopupMenu( menu );
                    auto popup      = window.showPopup( popup_menu, this,
                            PopupAlign.Point | PopupAlign.Right, e.x, e.y );
                    popup_menu.menuItemAction = &handleMenuAction;
                    popup.flags = PopupFlags.CloseOnClickOutside;
                }
            }
            if ( trans_ev ) parent.childById( "grid" ).onMouseEvent( e );

            if ( redraw_obj ) window.mainWidget.handleAction( Action_ObjectRefresh );

            super.onMouseEvent( e );
            return true;
        }

        bool handleMenuAction ( const Action a )
        {
            switch ( a.id ) with ( TimelineActions ) {
                case LinesRefresh:
                    cache.updateLinesCache;
                    window.mainWidget.handleAction( Action_ObjectRefresh );
                    return true;

                case Dlg_AddObject:
                    auto ev = cast(Action_Dlg_AddObject) a;
                    new ObjectChooser( ev.frame, ev.line, cache.timeline, window ).show;
                    return true;

                case Dlg_AddEffect:
                    auto ev = cast(Action_Dlg_AddEffect) a;
                    auto obj = cache.timeline[new FrameAt(ev.frame),new LayerId(ev.line)];
                    if ( obj ) new EffectChooser( obj, window ).show;
                    return true;

                case Dlg_EaseMiddlePoint:
                    auto ev = cast(Action_Dlg_EaseMiddlePoint) a;
                    auto mp = ev.property.middlePoints[ev.mpIndex];
                    if ( ev.property.increasable )
                        new EasingChooser( mp, window ).show;
                    return true;

                case RmObject:
                    auto ev  = cast(Action_RmObject) a;
                    auto obj = cache.timeline[new FrameAt(ev.frame),new LayerId(ev.line)];
                    if ( obj ) {
                        cache.timeline.remove( obj );
                        if ( cache.timeline.selecting is obj )
                            cache.timeline.selecting = null;
                        cache.updateLinesCache;
                        window.mainWidget.handleAction( Action_ObjectRefresh );
                        return true;
                    }
                    return false;

                case RmMiddlePoint:
                    auto ev = cast(Action_RmMiddlePoint) a;
                    ev.property.removeMiddlePoint( ev.mpIndex );
                    return true;

                default: return false;
            }
        }
}
