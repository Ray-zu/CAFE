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
        TimelineCanvas tl_canvas;

        ScrollBar hscroll;
        ScrollBar vscroll;

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

            tl_canvas = cast(TimelineCanvas)childById( "canvas" );
            hscroll   = cast(ScrollBar)childById( "hscroll" );
            vscroll   = cast(ScrollBar)childById( "vscroll" );

            //テストコード
            import cafe.project.ObjectPlacingInfo,
                   cafe.project.timeline.Timeline;
            auto tl = new Timeline( new FrameLength(50) );

            tl_editor = new TimelineEditor(tl);
            tl_canvas.timeline = tl_editor;
            vscroll.scrollEvent =
                delegate ( AbstractSlider w, ScrollEvent e )
                {
                    tl_canvas.topLineIndex = e.position;
                    return true;
                };
        }
}
