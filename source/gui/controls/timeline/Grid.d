/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.gui.controls.timeline.Grid;
import cafe.gui.Action,
       cafe.gui.utils.Font,
       cafe.gui.controls.timeline.Action,
       cafe.gui.controls.timeline.Cache;
import std.algorithm;
import dlangui,
       dlangui.widgets.metadata;

mixin( registerWidgets!TimelineGrid );

/+ グリッドの描画 +/
class TimelineGrid : CanvasWidget
{
    private:
        Cache cache = null;
        bool  dragging = false;

    public:
        this ( string id = "" )
        {
            super( id );
            styleId = "TIMELINE_GRID";
            trackHover = true;
            clickable  = true;
        }

        auto setCache ( Cache c )
        {
            if ( cache )
                throw new Exception( "Can't redefine cache." );
            else cache = c;
        }

        override void measure ( int w, int h )
        {
            measuredContent( w, h, w-cache.headerWidth, 50 );
        }

        override void onDraw ( DrawBuf b )
        {
            super.onDraw( b );
            if ( !cache.timeline || pos.width < 0 ) return;
            cache.updateGridCache( pos );

            auto left  = cache.timeline.leftFrame;
            auto right = cache.timeline.rightFrame;
            auto unit  = cache.framePerGrid;
            auto ppf   = cache.pxPerFrame;

            foreach ( f; left .. right ) {
                if ( f%unit != 0 ) continue;

                auto vframe = f - left;
                auto x = (vframe*ppf).to!int + pos.left;

                auto h = 15;
                if ( (f/unit)%5 == 0 ) {
                    h = 20;
                    font.drawCenteredText(b, x, pos.top+10, f.to!string, textColor );
                }
                b.drawLine( Point( x, pos.bottom - h ),
                        Point( x, pos.bottom ), textColor );
            }
        }

        override bool onMouseEvent ( MouseEvent e )
        {
            auto f = cache.xToFrame( e.x - pos.left );

            auto left ()
            {
                switch ( e.action ) with ( MouseAction ) {
                    case ButtonDown:
                        dragging = true;
                        break;
                    case ButtonUp:
                        dragging = false;
                        break;
                    case Cancel:
                        dragging = false;
                        break;
                    default:
                }
            }
            auto right ()
            {
                if ( e.action == MouseAction.ButtonDown ) {
                    auto root = new MenuItem;
                    root.add( new Action_SetLastFrame( f, 0 ) );
                    auto pmenu = new PopupMenu( root );
                    auto popup = window.showPopup( pmenu, this,
                            PopupAlign.Point | PopupAlign.Right, e.x, e.y );
                    pmenu.menuItemAction = &handleMenuAction;
                    popup.flags = PopupFlags.CloseOnClickOutside;
                }
            }
            switch ( e.button ) with ( MouseButton ) {
                case Left: left;
                    break;
                case Right: right;
                    break;
                default:
            }

            if ( dragging ) {
                auto temp = cache.timeline.frame.value;
                cache.timeline.frame.value = min( f, cache.timeline.length.value-1 );

                if ( temp != f )
                    window.mainWidget.handleAction( Action_ChangeFrame );
                invalidate;
            }
            return super.onMouseEvent( e );
        }

        bool handleMenuAction ( const Action a )
        {
            switch ( a.id ) with ( TimelineActions ) {
                case SetLastFrame:
                    auto ev = cast(Action_SetLastFrame) a;
                    auto vf = cache.timeline.objects.length > 0 ?
                        cache.timeline.objects.maxElement
                            !( x => x.place.frame.end.value ).place.frame.end.value : 0;
                    vf = max( vf, ev.frame, 1 );
                    cache.timeline.length.value = vf;
                    return true;

                default: return false;
            }
        }
}
