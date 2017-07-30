/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.gui.controls.timeline.Line;
import cafe.gui.utils.Font,
       cafe.gui.controls.timeline.Cache;
import std.conv;
import dlangui;

abstract class Line : HorizontalLayout 
{
    enum HeaderWidth = 150;

    protected:
        Cache cache;
        LineHeader header;

        @property Widget lineContent ();

    public:
        float heightMag = 1;

        this ( string name, Cache c )
        {
            super();
            cache = c;
            header = cast(LineHeader)addChild( new LineHeader( "", name ) );
        }

        override void measure ( int w, int h )
        {
            header.minWidth = HeaderWidth;
            lineContent.minWidth = w - HeaderWidth;
            super.measure( w, h );
        }
}

class LineHeader : VerticalLayout
{
    enum Layout = q{
        HorizontalLayout {
            layoutWidth: FILL_PARENT;
            layoutHeight: FILL_PARENT;
            HSpacer {}
            TextWidget { id:title }
            HSpacer {}
        }
    };

    public:
        this ( string id, string name )
        {
            super( id );
            styleId = "TIMELINE_LINE_HEADER";
            layoutWidth  = FILL_PARENT;
            layoutHeight = FILL_PARENT;

            addChild( new VSpacer );
            addChild( parseML( Layout ) );
            addChild( new VSpacer );

            childById("title").text = name.to!dstring;
        }

        override void onDraw ( DrawBuf b )
        {
            super.onDraw( b );
        }
}
