/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.gui.controls.timeline.TimelineCanvas;
import cafe.gui.controls.timeline.TimelineEditor,
       cafe.gui.controls.timeline.Line,
       cafe.gui.utils.Font;
import dlangui,
       dlangui.widgets.metadata;
import std.conv,
       std.math;

mixin( registerWidgets!TimelineCanvas );

class TimelineCanvas : Widget
{
    enum GridHeight = 50;

    enum BackgroundColor       = 0x333333;
    enum LineSeparaterColor    = 0x666666;
    enum LineTextColor         = 0x555555;
    enum HeaderBackgroundColor = 0x222222;
    enum GridBackgroundColor   = 0x444444;

    private:
        TimelineEditor tl_editor;

        uint start_frame;
        uint page_width;
        uint header_width;

        float top_line_index;
        uint  base_line_height;

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


        /+ グリッドの描画 +/
        void drawGrid ( DrawBuf b )
        {
        }

        /+ ラインの描画 +/
        void drawLine ( DrawBuf b, int y, Line l )
        {
            auto height = (l.height * lineHeight).to!int;

            // TODO オブジェクト描画

            // 上のラインの線と被るのでyに1足します。
            b.fillRect( Rect( 0,y+1, headerWidth,y+height ),
                    HeaderBackgroundColor );
            font.drawCenteredText( b, headerWidth/2, y+height/2,
                   l.lineName, LineTextColor );

            b.drawLine( Point(0,y+height), Point(b.width,y+height),
                    LineSeparaterColor );
        }

    public:
        @property startFrame () { return start_frame; }
        @property startFrame ( uint f )
        {
            start_frame = f;
            invalidate;
        }

        @property pageWidth () { return page_width; }
        @property pageWidth ( uint w )
        {
            page_width = w;
            invalidate;
        }

        @property headerWidth () { return header_width; }
        @property headerWidth ( uint h )
        {
            header_width = h;
            invalidate;
        }

        @property topLineIndex () { return top_line_index; }
        @property topLineIndex ( float t )
        {
            top_line_index = t;
            invalidate;
        }

        @property lineHeight () { return base_line_height; }
        @property lineHeight ( uint l )
        {
            base_line_height = l;
            invalidate;
        }

        @property timeline ( TimelineEditor tl )
        {
            tl_editor = tl;
            invalidate;
        }

        this ( string id = "" )
        {
            super( id );
            tl_editor = null;

            startFrame = 0;
            pageWidth = 100;
            headerWidth = 100;
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

            // グリッドの描画
            auto grid_r = Rect( pos.left,
                    pos.top, pos.right, pos.top + GridHeight );
            auto grid_buf = new ColorDrawBuf( grid_r.width, grid_r.height );
            grid_buf.fill( GridBackgroundColor );

            b.drawRescaled( grid_r, grid_buf,
                   Rect( 0, 0, grid_buf.width, grid_buf.height ) );
            object.destroy( grid_buf );

            // コンテンツの描画
            auto body_r = Rect( pos.left,
                    pos.top + GridHeight, pos.right, pos.bottom );
            auto body_buf = new ColorDrawBuf( body_r.width, body_r.height );
            body_buf.fill( BackgroundColor );

            auto lindex = topLineIndex.trunc.to!int;
            auto y = -topHiddenPx;
            while ( y < height ) {
                auto line = tl_editor.lineInfo( lindex++ );
                drawLine( body_buf, y, line );
                y += (line.height * lineHeight).to!int;
            }

            b.drawRescaled( body_r, body_buf,
                   Rect( 0, 0, body_buf.width, body_buf.height ) );
            object.destroy( body_buf );
        }
}
