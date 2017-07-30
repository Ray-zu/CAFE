/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.gui.controls.timeline.LineCollection;
import cafe.gui.controls.timeline.Cache,
       cafe.project.timeline.Timeline;
import dlangui,
       dlangui.widgets.metadata;

mixin( registerWidgets!LineCollection );

/+ ラインをまとめるウィジェット +/
class LineCollection : VerticalLayout
{
    private:
        Cache cache;

    public:
        this ( string id = "" )
        {
            super( id );
            trackHover = true;
            clickable  = true;
        }

        auto setCache ( Cache c )
        {
            if ( cache )
                throw new Exception( "Can't redefine cache." );
            else cache = c;
        }

        auto updateWidgets ()
        {
            removeAllChildren;
        }
}
