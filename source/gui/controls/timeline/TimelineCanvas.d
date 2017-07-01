/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.gui.controls.timeline.TimelineCanvas;
import dlangui,
       dlangui.widgets.metadata;

mixin( registerWidgets!TimelineCanvas );

class TimelineCanvas : Widget
{
    private:
    public:
        this ( string id = "" )
        {
            super( id );
        }

        override void measure ( int w, int h )
        {
            measuredContent( w, h, w, h );
        }
}
