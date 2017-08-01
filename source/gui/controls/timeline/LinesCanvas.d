/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.gui.controls.timeline.LinesCanvas;
import cafe.gui.utils.Rect,
       cafe.gui.controls.timeline.Cache;
import std.algorithm,
       std.conv,
       std.math;
import dlangui,
       dlangui.widgets.metadata;

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

        override void onDraw ( DrawBuf b )
        {
            super.onDraw( b );
            if ( !cache.timeline ) return;

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
        }

        override bool onMouseEvent ( MouseEvent e )
        {
            auto line_id = delegate ()
            {
                auto ry = e.y - pos.top;// - topHiddenPx;
                auto i  = cache.timeline.topLineIndex.to!int;
                auto h  = 0;
                while ( h < ry && i < cache.lines.length )
                    h += (cache.lines[i++].heightMag * baseLineHeight).to!int;
                return h < ry ? -1 : i-1;
            }();
            auto st   = cache.timeline.leftFrame;
            auto ppf  = cache.pxPerFrame;
            auto left = e.button == MouseButton.Left;

            auto trans_ev = dragging;
            if ( left && e.action == MouseAction.ButtonDown ) {
                // 左クリック押し始め
                auto header = (e.x-pos.left) < cache.headerWidth;
                auto line   = cache.lines[line_id];
                if ( header )
                    line.onHeaderLeftClicked;
                else {
                    auto f = st + ((e.x-pos.left)/ppf).to!int;
                    line.onContentLeftClicked( f );
                }
                trans_ev = !cache.operation.isOperating;
                dragging = true;

            } else if ( (left && e.action == MouseAction.ButtonUp) || e.action == MouseAction.Cancel ) {
                // 左クリック押し終わり
                trans_ev = !cache.operation.isOperating;
                dragging = false;
                cache.operation.clear;

            } else if ( e.action == MouseAction.Move ) {
                // カーソル動いた
                trans_ev = !cache.operation.isOperating && dragging;

            }
            if ( trans_ev ) parent.childById( "grid" ).onMouseEvent( e );

            super.onMouseEvent( e );
            return true;
        }
}
