/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.gui.controls.timeline.TimelineCanvas;
import cafe.gui.controls.timeline.TimelineEditor,
       cafe.gui.controls.timeline.Line;
import dlangui,
       dlangui.widgets.metadata;
import std.conv,
       std.math;

mixin( registerWidgets!TimelineCanvas );

class TimelineCanvas : Widget
{
    private:
        TimelineEditor tl_editor;

        /+ 表示中のライン情報の配列を返す +/
        auto showingLineInfo ()
        {
            Line[] result = [];
            uint i = topLineIndex.trunc.to!uint;
            auto h = 0;
            do {
                result ~= tl_editor.lineInfo( i++ );
                h += (result[$-1].height * lineHeight).to!int;
            } while ( h < height );
            return result;
        }

    public:
        uint  startFrame;
        uint  pageWidth;

        float topLineIndex;
        uint  lineHeight;

        @property timeline ( TimelineEditor tl )
        {
            tl_editor = tl;
        }

        this ( string id = "" )
        {
            super( id );
            tl_editor = null;

            startFrame = 0;
            pageWidth = 100;
            topLineIndex = 0;
        }

        override void measure ( int w, int h )
        {
            measuredContent( w, h, w, h );
        }

        override void onDraw ( DrawBuf b )
        {
            super.onDraw( b );
        }
}
