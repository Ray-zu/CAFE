/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.gui.controls.timeline.TimelineWidget;
import dlangui,
       dlangui.widgets.metadata;

mixin( registerWidgets!TimelineWidget );

/+ タイムラインウィジェット +/
class TimelineWidget : VerticalLayout
{
    enum HScrollLayout = q{
        ScrollBar {
            id:hscroll;
            orientation:Horizontal
        }
    };
    enum MainLayout = q{
        HorizontalLayout {
            layoutWidth:FILL_PARENT;
            HSpacer { id:canvas }
            ScrollBar { id:vscroll; orientation:Vertical }
        }
    };

    private:
        ScrollBar hscroll;
        ScrollBar vscroll;

    public:
        this ( string id = "" )
        {
            super( id );
            layoutWidth  = FILL_PARENT;
            layoutHeight = FILL_PARENT;

            addChild( parseML( HScrollLayout ) );
            addChild( parseML( MainLayout ) );

            hscroll   = cast(ScrollBar)childById( "hscroll" );
            vscroll   = cast(ScrollBar)childById( "vscroll" );
        }

        override void measure ( int w, int h )
        {
            childById("canvas").minHeight = h;
            super.measure( w, h );
        }
}
