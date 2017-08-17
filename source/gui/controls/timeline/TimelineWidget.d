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
import std.algorithm;
import dlangui;

/+ タイムラインウィジェット +/
class TimelineWidget : VerticalLayout
{
    enum WheelMag = 2.0;
    enum VScrollMag = 10.0;

    enum FrameRemnant = 0.3;

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
                layoutHeight:FILL_PARENT;
                HorizontalLayout {
                    layoutWidth:FILL_PARENT;
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

        void correctScroll ( ScrollBar s )
        {
            s.position = max( 0, min( s.maxValue - s.pageSize, s.position ) );
        }

        auto hscrolled ( AbstractSlider = null, ScrollEvent e = null )
        {
            if ( !cache.timeline ) return false;
            hscroll.setRange( 0, (cache.timeline.length.value+(hscroll.pageSize*FrameRemnant)).to!int );
            correctScroll( hscroll );
            cache.timeline.leftFrame  = hscroll.position;
            cache.timeline.rightFrame = cache.timeline.leftFrame + hscroll.pageSize;
            invalidate;
            return true;
        }
        auto vscrolled ( AbstractSlider = null, ScrollEvent e = null )
        {
            if ( !cache.timeline ) return false;
            vscroll.setRange( 0, (cache.lines.length*VScrollMag).to!int );
            correctScroll( vscroll );
            vscroll.pageSize = VScrollMag.to!int;
            cache.timeline.topLineIndex  = vscroll.position/VScrollMag;
            invalidate;
            return true;
        }

    protected:
        override bool onMouseEvent ( MouseEvent e )
        {
            auto delta = (-e.wheelDelta * WheelMag).to!int;
            void frameWheel ()
            {
                hscroll.position = hscroll.position + delta;
                hscrolled;
            }
            void lineWheel ()
            {
                vscroll.position = vscroll.position + delta;
                vscrolled;
            }
            void frameZoom ()
            {
                hscroll.pageSize = hscroll.pageSize + delta;
                hscrolled;
            }
            void lineZoom ()
            {
                vscroll.pageSize = vscroll.pageSize + delta;
                vscrolled;
            }

            switch ( e.action ) with ( MouseAction ) {
                case Wheel:
                    if      ( e.keyFlags & KeyFlag.LControl ) frameZoom;
                    else if ( e.keyFlags & KeyFlag.LShift   ) lineZoom;
                    else if ( e.keyFlags & KeyFlag.LAlt     ) lineWheel;
                    else                                      frameWheel;
                    return true;

                default: return false;
            }
        }

    public:
        this ( string id, Project p, Timeline t )
        {
            super( id );
            styleId = "TIMELINE";
            layoutWidth  = FILL_PARENT;
            layoutHeight = FILL_PARENT;

            cache = new Cache( p, t );
            cache.headerWidth = 150;

            addChild( parseML( HScrollLayout ) );
            addChild( parseML( MainLayout ) );

            hscroll = cast(ScrollBar   )childById( "hscroll" );
            vscroll = cast(ScrollBar   )childById( "vscroll" );
            grid    = cast(TimelineGrid)childById( "grid" );
            canvas  = cast(LinesCanvas )childById( "canvas" );

            hscroll.position = 0;
            vscroll.position = 0;
            hscroll.scrollEvent = &hscrolled;
            vscroll.scrollEvent = &vscrolled;

            grid  .setCache( cache );
            canvas.setCache( cache );

            cache.updateLinesCache;
            hscrolled; vscrolled;
        }

        void updateCache ()
        {
            cache.updateGridCache( grid.pos );
            cache.updateLinesCache;
        }
}
