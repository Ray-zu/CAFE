/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.gui.controls.timeline.TimelineWidget;
import cafe.project.Project,
       cafe.project.timeline.Timeline,
       cafe.gui.controls.timeline.Cache,
       cafe.gui.controls.timeline.Grid;
import dlangui;

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
            VerticalLayout {
                TimelineGrid { id:grid }
                HSpacer { id:canvas }
            }
            ScrollBar { id:vscroll; orientation:Vertical }
        }
    };

    private:
        Cache cache;

        ScrollBar hscroll;
        ScrollBar vscroll;
        TimelineGrid grid;

        auto scrolled ( AbstractSlider, ScrollEvent e )
        {
            cache.timeline.hscroll = hscroll.position;
            cache.timeline.vscroll = vscroll.position;
            cache.updateGridCache( grid.pos );
            grid.invalidate;
            return true;
        }

    public:
        this ( string id, Project p, Timeline t )
        {
            super( id );
            layoutWidth  = FILL_PARENT;
            layoutHeight = FILL_PARENT;

            cache = new Cache( p, t );

            addChild( parseML( HScrollLayout ) );
            addChild( parseML( MainLayout ) );

            hscroll = cast(ScrollBar)childById( "hscroll" );
            vscroll = cast(ScrollBar)childById( "vscroll" );
            grid = cast(TimelineGrid)childById( "grid" );

            hscroll.scrollEvent = &scrolled;
            vscroll.scrollEvent = &scrolled;

            grid.setCache( cache );
        }

        override void measure ( int w, int h )
        {
            grid.minHeight = 50;
            grid.minWidth  = w;
            childById("canvas").minHeight = h;

            super.measure( w, h );
            cache.updateGridCache( grid.pos );
        }
}
