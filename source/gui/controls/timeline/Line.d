/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.gui.controls.timeline.Line;
import cafe.gui.utils.Font,
       cafe.gui.controls.timeline.Cache,
       cafe.project.timeline.PlaceableObject;
import std.algorithm,
       std.conv,
       std.format;
import dlangui;

abstract class Line
{
    enum HeaderStyle = "TIMELINE_LINE_HEADER";

    protected:
        Cache cache;
        string line_name;

    public:
        @property name () { return line_name; }

        @property heightMag () { return 1.0; }

        this ( Cache c, string n )
        {
            cache = c;
            line_name = n;
        }

        void drawHeader ( DrawBuf b, Rect r )
        {
            auto style = currentTheme.get( HeaderStyle );
            if ( style.backgroundDrawable )
                style.backgroundDrawable.drawTo( b, r );

            auto x = r.left + (r.right -r.left)/2;
            auto y = r.top  + (r.bottom-r.top )/2;
            style.font.drawCenteredText( b, x, y, name, style.textColor );
        }

        void drawContent ( DrawBuf, Rect );
}

class LayerLine : Line
{
    enum TitleFormat = "Layer %d";
    enum ContentStyle = "TIMELINE_LAYER_LINE";

    private:
        PlaceableObject[] objs;

    public:
        this ( Cache c, uint l, PlaceableObject[] o )
        {
            super( c, TitleFormat.format(l) );
            objs = o;
        }

        override void drawContent ( DrawBuf b, Rect r )
        {
            auto style = currentTheme.get( ContentStyle );
            if ( style.backgroundDrawable )
                style.backgroundDrawable.drawTo( b, r );

            auto shrinkRect ( Rect rc )
            {
                return Rect(
                        max( r.left  , rc.left   ),
                        max( r.top   , rc.top    ),
                        min( r.right , rc.right  ),
                        min( r.bottom, rc.bottom ) );
            }
            auto st = cache.timeline.leftFrame;
            auto ed = cache.timeline.rightFrame;
            auto ppf = cache.pxPerFrame;
            auto pad = style.padding;

            foreach ( o; objs ) {
                auto ost = o.place.frame.start.value;
                auto oed = o.place.frame.end.value;

                if ( oed > st && ost < ed ) {
                    auto r_ost = ost.to!int - st.to!int;
                    auto r_oed = oed.to!int - st.to!int;

                    auto obj_r = Rect( r.left + (r_ost*ppf).to!int, r.top + pad.top,
                            r.left + (r_oed*ppf).to!int, r.bottom - pad.bottom );
                    b.clipRect = shrinkRect(obj_r);
                    o.draw( b, obj_r );
                    b.drawFrame( obj_r, style.textColor, Rect(1,1,1,1) );
                }
            }
        }
}
