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
            styleId = "TIMELINE_GRID";
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
            if ( !cache.timeline || pos.width < 0 ) return;

            auto left  = cache.timeline.leftFrame;
            auto right = cache.timeline.rightFrame;
            auto unit  = cache.framePerGrid;
            auto ppf   = cache.pxPerFrame;

            foreach ( f; left .. right ) {
                if ( f%unit != 0 ) continue;

                auto vframe = f - left;
                auto x = (vframe*ppf).to!int + pos.left;

                auto h = 15;
                if ( (f/unit)%5 == 0 ){
                    h = 20;
                }
                b.drawLine( Point( x, pos.bottom - h ),
                       Point( x, pos.bottom ), textColor );
            }
        }
}
