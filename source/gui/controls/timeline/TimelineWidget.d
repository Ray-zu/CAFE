/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.gui.controls.timeline.TimelineWidget;
import cafe.gui.controls.timeline.TimelineEditor,
       cafe.gui.controls.timeline.TimelineCanvas;
import dlangui,
       dlangui.widgets.metadata;

mixin( registerWidgets!TimelineWidget );

/+ タイムラインウィジェット +/
class TimelineWidget : VerticalLayout
{
    private:
        TimelineEditor tl_editor;

    public:
        this ( string id = "" )
        {
            super( id );
            addChild( parseML( q{
                ScrollBar { id:"hscroll"; orientation:Horizontal }
            } ) );
            addChild( parseML( q{
                HorizontalLayout {
                    TimelineCanvas { id:"canvas" }
                    ScrollBar { id:"vscroll"; orientation:Vertical }
                }
            } ) );
        }
}
