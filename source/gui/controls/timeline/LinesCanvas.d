/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.gui.controls.timeline.LinesCanvas;
import cafe.gui.controls.timeline.Cache;
import dlangui,
       dlangui.widgets.metadata;

mixin( registerWidgets!LinesCanvas );

/+ タイムラインの描画 +/
class LinesCanvas : CanvasWidget
{
    private:
        Cache cache;

    public:
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
}
