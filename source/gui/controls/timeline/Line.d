/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.gui.controls.timeline.Line;
import dlangui;

class Line
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
}
