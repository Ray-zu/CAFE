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
       cafe.gui.controls.timeline.Grid,
       cafe.gui.controls.timeline.LinesCanvas;
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
                HorizontalLayout {
                    HSpacer { id:grid_spacer }
                    TimelineGrid { id:grid }
                }
                LinesCanvas { id:canvas }
            }
            ScrollBar { id:vscroll; orientation:Vertical }
        }
    };

    private:
        Cache cache;

        ScrollBar    hscroll;
        ScrollBar    vscroll;
        TimelineGrid grid;
        LinesCanvas  canvas;

        auto hscrolled ( AbstractSlider = null, ScrollEvent e = null )
        {
            if ( !cache.timeline ) return false;
            cache.timeline.leftFrame  = hscroll.position;
            cache.timeline.rightFrame = cache.timeline.leftFrame + hscroll.pageSize;
            invalidate;
            return true;
        }
        auto vscrolled ( AbstractSlider = null, ScrollEvent e = null )
        {
            if ( !cache.timeline ) return false;
            cache.timeline.topLineIndex  = vscroll.position/100.0;
            invalidate;
            return true;
        }

    public:
        this ( string id, Project p, Timeline t )
        {
            super( id );
            styleId = "TIMELINE";
            layoutWidth  = FILL_PARENT;
            layoutHeight = FILL_PARENT;

            cache = new Cache( p, t );

            addChild( parseML( HScrollLayout ) );
            addChild( parseML( MainLayout ) );

            hscroll = cast(ScrollBar   )childById( "hscroll" );
            vscroll = cast(ScrollBar   )childById( "vscroll" );
            grid    = cast(TimelineGrid)childById( "grid" );
            canvas  = cast(LinesCanvas )childById( "canvas" );

            hscroll.scrollEvent = &hscrolled;
            vscroll.scrollEvent = &vscrolled;

            hscrolled; vscrolled;
            grid  .setCache( cache );
            canvas.setCache( cache );

            cache.updateLinesCache;
        }

        override void invalidate ()
        {
            super.invalidate;
            cache.updateGridCache( grid.pos );
            grid.invalidate;
        }

        override void measure ( int w, int h )
        {
            childById("grid_spacer").minWidth = 150;
            grid.minHeight = 50;
            grid.minWidth  = w - 150;
            canvas.minHeight = h;

            super.measure( w, h );
            cache.updateGridCache( grid.pos );
            cache.headerWidth = childById("grid_spacer").width;
        }
}
