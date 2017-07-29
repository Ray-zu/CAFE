/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.gui.controls.timeline.Grid;
import cafe.gui.controls.timeline.Cache;
import dlangui,
       dlangui.widgets.metadata;

mixin( registerWidgets!TimelineGrid );

/+ グリッドの描画 +/
class TimelineGrid : CanvasWidget
{
    private:
        Cache cache = null;

    public:
        this ( string id = "" )
        {
            super( id );
        }

        auto setCache ( Cache c )
        {
            if ( cache )
                throw new Exception( "Can't redefine cache." );
            else cache = c;
        }

        override void onDraw ( DrawBuf b )
        {
            super.onDraw( b );
            if ( !cache.timeline ) return;

            auto x     = pos.left.to!float;
            auto frame = cache.timeline.leftFrame*1.0;

            while ( x < pos.right ) {
                auto h = 15;
                frame += cache.framePerGrid;
                if ( frame.to!int%5 == 0 ) h = 20;

                b.drawLine( Point( x.to!int, pos.bottom - h ),
                        Point( x.to!int, pos.bottom ), textColor );
                x += cache.gridInterval;
            }
        }
}
