/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.gui.controls.timeline.TimelineCanvas;
import cafe.gui.controls.timeline.TimelineEditor;
import dlangui,
       dlangui.widgets.metadata;

mixin( registerWidgets!TimelineCanvas );

class TimelineCanvas : Widget
{
    private:
        TimelineEditor tl_editor;

    public:
        uint  startFrame;
        uint  pageWidth;
        float topLayerIndex;

        @property timeline ( TimelineEditor tl )
        {
            tl_editor = tl;
        }

        this ( string id = "" )
        {
            super( id );
            tl_editor = null;

            startFrame = 0;
            pageWidth = 100;
            topLayerIndex = 0;
        }

        override void measure ( int w, int h )
        {
            measuredContent( w, h, w, h );
        }
}
