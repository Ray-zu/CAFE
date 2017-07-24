/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.gui.controls.timeline.TimelineWidget;
import cafe.gui.controls.timeline.TimelineEditor,
       cafe.gui.controls.timeline.TimelineCanvas,
       cafe.project.timeline.custom.NullObject;
import std.algorithm;
import dlangui,
       dlangui.widgets.metadata;

mixin( registerWidgets!TimelineWidget );

/+ タイムラインウィジェット +/
class TimelineWidget : VerticalLayout
{
    enum WheelMag = 5;
    private:
        TimelineEditor tl_editor;
        TimelineCanvas tl_canvas;

        ScrollBar hscroll;
        ScrollBar vscroll;

        void wheel ( short delta, ushort key )
        {
            if ( key & KeyFlag.Control ) {
                hscroll.pageSize = hscroll.pageSize - delta;

            } else if ( key & KeyFlag.Shift ) {
                auto npos = vscroll.position - delta*WheelMag;
                npos = max( vscroll.minValue,
                        min( npos, vscroll.maxValue - vscroll.pageSize ) );
                vscroll.position = npos;

            } else {
                auto npos = hscroll.position - delta*WheelMag;
                npos = max( hscroll.minValue,
                       min( npos, hscroll.maxValue - hscroll.pageSize ) );
                hscroll.position = npos;
            }
            invalidate;
        }

        auto onMouseEvent ( Widget w, MouseEvent e )
        {
            auto m = cast(TimelineWidget)w;
            switch ( e.action )
            {
                case MouseAction.Wheel:
                    m.wheel( e.wheelDelta, e.keyFlags );
                    return true;

                default:
                    return false;
            }
        }

    public:
        @property editor () { return tl_editor; }

        this ( string id = "" )
        {
            super( id );
            mouseEvent = &onMouseEvent;
            layoutWidth  = FILL_PARENT;
            layoutHeight = FILL_PARENT;

            addChild( parseML( q{
                ScrollBar {
                    id:"hscroll";
                    orientation:Horizontal
                }
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

            tl_editor                  = new TimelineEditor( null );
            tl_canvas.timeline         = tl_editor;
            tl_canvas.verticalScroll   = vscroll;
            tl_canvas.horizontalScroll = hscroll;
        }
}
