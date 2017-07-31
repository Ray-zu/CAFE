/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.gui.controls.timeline.LinesCanvas;
import cafe.gui.controls.timeline.Cache;
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

            /+ Rectのウィジェットからはみ出てる部分を削る +/
            auto shrinkRect ( Rect r )
            {
                return Rect(
                        max( r.left, pos.left ),
                        max( r.top, pos.top+1 ),
                        min( r.right, pos.right ),
                        min( r.bottom, pos.bottom ) );
            }

            b.drawLine( Point(pos.left,pos.top),
                    Point(pos.right,pos.top), textColor );

            auto top = cache.timeline.topLineIndex.to!int;
            auto y   = -topHiddenPx;
            foreach ( l; cache.lines[top .. $] ) {
                if ( y >= pos.height ) break;
                auto h = (l.heightMag * baseLineHeight).to!int;

                auto header_r = Rect( pos.left, pos.top+y+1,
                        pos.left + cache.headerWidth, pos.top + y + h );
                b.clipRect = shrinkRect( header_r );
                l.drawHeader( b, header_r );

                auto content_r = Rect( pos.left+cache.headerWidth, pos.top+y+1,
                       pos.right, pos.top + y + h );
                b.clipRect = shrinkRect( content_r );
                l.drawContent( b, content_r );

                y += h;
                b.resetClipping;
                b.drawLine( Point(pos.left,pos.top+y),
                        Point(pos.right,pos.top+y), textColor );
            }
        }
}
