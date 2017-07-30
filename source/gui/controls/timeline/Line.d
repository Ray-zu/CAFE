/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.gui.controls.timeline.Line;
import cafe.project.timeline.PlaceableObject;
import std.format;
import dlangui;

abstract class Line
{
    enum HeaderStyle = "TIMELINE_LINE_HEADER";
    private:
        string line_name;

    public:
        @property name () { return line_name; }

        this ( string n )
        {
            line_name = n;
        }

        void drawHeader ( DrawBuf b, Rect r )
        {
            auto style = currentTheme.get( HeaderStyle );
            if ( style.backgroundDrawable )
                style.backgroundDrawable.drawTo( b, r );
        }

        void drawContent ( DrawBuf, Rect );
}

class LayerLine : Line
{
    enum TitleFormat = "Layer %d";

    private:
        PlaceableObject[] objs;

    public:
        this ( uint l, PlaceableObject[] o )
        {
            super( TitleFormat.format(l) );
            objs = o;
        }

        override void drawContent ( DrawBuf, Rect )
        {
        }
}
