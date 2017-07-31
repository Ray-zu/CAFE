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

        /+ ラインコンテンツをドラッグ中かどうか +/
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
                auto ry = e.y - pos.top - topHiddenPx;
                auto i  = cache.timeline.topLineIndex.trunc.to!uint;
                auto h  = 0;
                while ( h < ry && i < cache.lines.length )
                    h += (cache.lines[i++].heightMag * baseLineHeight).to!int;
                return h < ry ? -1 : i;
            }();

            auto st  = cache.timeline.leftFrame;
            auto ppf = cache.pxPerFrame;

            auto trans_ev = true;
            if ( line_id >= 0 ) {
                trans_ev = false;
                if ( e.x - pos.left < cache.headerWidth && !dragging )
                    cache.lines[line_id].onHeaderMouseEvent( e );

                else {
                    auto f = ((e.x-pos.left) / ppf).to!uint + st;
                    trans_ev = !cache.lines[line_id].onContentMouseEvent( f, e );
                    if ( e.button == MouseButton.Left ) {
                        if ( e.action == MouseAction.ButtonDown ) dragging = true;
                        if ( e.action == MouseAction.ButtonUp   ) dragging = false;
                    }
                }
            }
            if ( trans_ev )
                parent.childById( "grid" ).onMouseEvent( e );

            super.onMouseEvent( e );
            return true;
        }
}
