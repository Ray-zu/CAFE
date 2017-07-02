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

        /+ 一番上のラインが上部に隠れているサイズ +/
        auto topHiddenPx ()
        {
            auto trunced = topLineIndex.trunc.to!int;
            return ((topLineIndex - trunced) *
                tl_editor.lineInfo( trunced ).height*lineHeight).to!uint;
        }

        /+ 表示中のライン情報の配列を返す +/
        auto showingLineInfo ()
        {
            Line[] result = [];
            auto i = topLineIndex.trunc.to!uint;
            auto h = 0;
            auto hidden_px = topHiddenPx;
            do {
                result ~= tl_editor.lineInfo( i++ );
                h += (result[$-1].height*lineHeight).to!int;
            } while ( h < height + hidden_px );
            return result;
        }

        /+ Y座標(キャンバス相対)からラインインデックスへ +/
        auto yToLineIndex ( int y )
        {
            auto i = topLineIndex.trunc.to!uint;
            auto h = 0;
            auto hidden_px = topHiddenPx;
            while ( h < y + hidden_px )
                h += (tl_editor.lineInfo( i++ ).height * lineHeight).to!int;
            return i;
        }


        /+ ラインの描画 +/
        void drawLine ( DrawBuf b, int y, Line l )
        {
            enum LayerSeparaterColor = 0x666666;

            auto height = (l.height * lineHeight).to!int;
            b.drawLine( Point(0,y+height),
                    Point(b.width,y+height), LayerSeparaterColor );
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
            lineHeight = 30;
        }

        override void measure ( int w, int h )
        {
            measuredContent( w, h, w, h );
        }

        override void onDraw ( DrawBuf b )
        {
            super.onDraw( b );
            if ( !tl_editor ) return;

            auto line_buf = new ColorDrawBuf( width, height );

            auto lindex = 0;
            auto y = -topHiddenPx;
            while ( y < height ) {
                auto line = tl_editor.lineInfo( lindex++ );
                drawLine( line_buf, y, line );
                y += (line.height * lineHeight).to!int;
            }

            b.drawImage( pos.left, pos.top, line_buf );
            object.destroy( line_buf );
        }
}
