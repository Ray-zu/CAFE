/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.gui.controls.timeline.TimelineCanvas;
import cafe.gui.controls.timeline.TimelineEditor,
       cafe.gui.controls.timeline.Line,
       cafe.gui.utils.Font,
       cafe.project.timeline.PlaceableObject,
       cafe.project.timeline.property.Property;
import dlangui,
       dlangui.widgets.metadata;
import std.algorithm,
       std.conv,
       std.math;

mixin( registerWidgets!TimelineCanvas );

class TimelineCanvas : Widget
{
    enum VScrollMag   = 10;
    enum LayerRemnant = 20;
    enum FrameRemnant = 100;

    enum GridHeight       = 50;
    enum GridLineHeight   = 10;
    enum GridMinInterval  = 5;
    enum LongGridInterval = 5;

    enum ObjectMarginTopBtm = 3;
    enum ObjectPaddingLeft  = 5;
    enum PropertyRectSize   = 7;

    enum BackgroundColor       = 0x333333;
    enum LineSeparaterColor    = 0x666666;
    enum LineTextColor         = 0x555555;
    enum HeaderBackgroundColor = 0x222222;
    enum GridBackgroundColor   = 0x444444;
    enum GridForegroundColor   = 0x888888;

    enum CurFrameBarColor   = 0x883333;
    enum EndOfFrameBarColor = 0x555555;

    enum ObjectFrameColor  = 0x888888;
    enum ObjectNameColor   = 0xbbbbbb;
    enum PropertyRectColor = 0x888888;

    private:
        TimelineEditor tl_editor;
        AbstractSlider vscroll;
        AbstractSlider hscroll;

        uint header_width;
        uint  base_line_height;

        /+ 一番上のラインが上部に隠れているサイズ +/
        auto topHiddenPx ()
        {
            auto trunced = topLineIndex.trunc.to!int;
            return ((topLineIndex - trunced) *
                tl_editor.lineInfo( trunced ).height*lineHeight).to!int;
        }

        /+ 表示中のライン情報の配列を返す +/
        auto showingLineInfo ()
        {
            Line[] result = [];
            auto i = topLineIndex.trunc.to!uint;
            auto h = GridHeight;
            auto hidden_px = topHiddenPx;
            do {
                result ~= tl_editor.lineInfo( i++ );
                h += (result[$-1].height*lineHeight).to!int;
            } while ( h < height + hidden_px );
            return result;
        }

        /+ X座標(キャンバス相対)からフレーム数へ +/
        auto xToFrame ( int x )
        {
            auto unit  = (width - headerWidth) / pageWidth.to!float;
            return (x / unit).to!int + startFrame;
        }

        /+ フレーム数からX座標(キャンバス相対)へ +/
        auto frameToX ( uint f )
        {
            auto unit = (width - headerWidth) / pageWidth.to!float;
            return ((f.to!int-startFrame)*unit).to!int + headerWidth;
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


        /+ Timelineとプロパティを同期 +/
        void updateProperties ()
        {
            auto max_layer = tl_editor.timeline.
                layerLength.value + LayerRemnant;
            vscroll.minValue = 0;
            vscroll.maxValue = max_layer*VScrollMag;
            vscroll.pageSize = ((height-GridHeight) / lineHeight)*VScrollMag;

            auto max_frame = tl_editor.timeline.
                length.value + FrameRemnant;
            hscroll.minValue = 0;
            hscroll.maxValue = max_frame;
        }


        /+ グリッドの描画 +/
        void drawGrid ( DrawBuf b )
        {
            auto r = Rect( headerWidth,0,b.width,b.height );
            auto unit = delegate ()
            {
                auto result = 1;
                while ( r.width / (pageWidth/result) < GridMinInterval )
                    result++;
                return result;
            }();
            auto glen = pageWidth / unit;
            auto px_per_grid = width / glen.to!float;

            foreach ( i; 0 .. glen ) {
                auto f = i*unit + startFrame;
                auto x = frameToX(f);
                auto top = r.bottom - GridLineHeight;
                auto btm = r.bottom;

                if ( f%LongGridInterval == 0 ) {
                    top -= GridLineHeight;
                    auto y = (r.height - top) / 3 * 2;
                    font.drawCenteredText( b, x,y, f.to!string, GridForegroundColor );
                }

                b.drawLine( Point(x,top), Point(x,btm), GridForegroundColor );
            }
        }

        /+ ラインの描画 +/
        void drawLine ( DrawBuf b, int y, Line l )
        {
            auto height = (l.height * lineHeight).to!int;

            /+ オブジェクトの描画 +/
            void drawObject ( PlaceableObject obj )
            {
                auto st = frameToX(obj.place.frame.start.value);
                auto ed = frameToX(obj.place.frame.end.value);
                auto r = Rect( st, y+ObjectMarginTopBtm,
                        ed, y+height-ObjectMarginTopBtm );
                auto obj_buf = new ColorDrawBuf( r.width, r.height );
                obj.draw( obj_buf );
                font.drawLeftCenteredText( obj_buf,
                        ObjectPaddingLeft,r.height/2, obj.name, ObjectNameColor );

                b.drawImage( r.left, r.top, obj_buf );
                object.destroy( obj_buf );

                b.drawFrame( r, ObjectFrameColor, Rect(1,1,1,1) );
            }

            /+ プロパティレクトの描画 +/
            void drawPropertyRect ( uint f )
            {
                f += tl_editor.selectedObject.place.frame.start.value;
                enum prs = PropertyRectSize/2;
                auto x = frameToX(f);
                auto y = y + height/2;
                auto r = Rect( x-prs, y-prs, x+prs, y+prs );
                b.fillRect( r, PropertyRectColor );
            }

            if ( l.isLayer ) l.objects.each!drawObject;
            else {
                l.property.middlePoints.each!(
                    x => drawPropertyRect( x.frame.start.value ) );
                drawPropertyRect( l.property.frame.value );
            }

            // 上のラインの線と被るのでyに1足します。
            b.fillRect( Rect( 0,y+1, headerWidth,y+height ),
                    HeaderBackgroundColor );
            font.drawCenteredText( b, headerWidth/2, y+height/2,
                   l.lineName, LineTextColor );

            b.drawLine( Point(0,y+height), Point(b.width,y+height),
                    LineSeparaterColor );
        }

        /+ シークバーとかを描画 +/
        void drawBars ( DrawBuf b )
        {
            void draw ( uint f, uint col )
            {
                if ( f >= startFrame && f < startFrame + pageWidth ) {
                    auto x = frameToX( f );
                    b.drawLine( Point(x,pos.top), Point(x,pos.bottom), col );
                }
            }

            draw( tl_editor.timeline.length.value, EndOfFrameBarColor );    // 終端のあれ
            draw( tl_editor.currentFrame, CurFrameBarColor );               // シークバー
        }

    public:
        @property startFrame () { return hscroll.position; }
        @property startFrame ( uint f )
        {
            hscroll.position = f;
            invalidate;
        }

        @property pageWidth () { return hscroll.pageSize; }
        @property pageWidth ( uint w )
        {
            hscroll.position = w;
            invalidate;
        }

        @property headerWidth () { return header_width; }
        @property headerWidth ( uint h )
        {
            header_width = h;
            invalidate;
        }

        @property topLineIndex () { return vscroll.position/VScrollMag.to!float; }
        @property topLineIndex ( float t )
        {
            vscroll.position = (t*VScrollMag).to!int;
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

        @property verticalScroll ( AbstractSlider a )
        {
            vscroll = a;
            vscroll.position = 0;
            invalidate;
        }

        @property horizontalScroll ( AbstractSlider a )
        {
            hscroll = a;
            hscroll.position = 0;
            hscroll.pageSize = 10;
            invalidate;
        }

        this ( string id = "" )
        {
            super( id );
            mouseEvent = &onMouseEvent;
            tl_editor = null;

            headerWidth = 100;
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
            updateProperties;

            // グリッドの描画
            auto grid_r = Rect( pos.left,
                    pos.top, pos.right, pos.top + GridHeight );
            auto grid_buf = new ColorDrawBuf( grid_r.width, grid_r.height );
            grid_buf.fill( GridBackgroundColor );
            drawGrid( grid_buf );
            b.drawRescaled( grid_r, grid_buf,
                   Rect( 0, 0, grid_buf.width, grid_buf.height ) );
            object.destroy( grid_buf );

            // コンテンツの描画
            auto body_r = Rect( pos.left,
                    pos.top + GridHeight, pos.right, pos.bottom );
            auto body_buf = new ColorDrawBuf( body_r.width, body_r.height );
            body_buf.fill( BackgroundColor );

            auto lindex = topLineIndex.trunc.to!int;
            auto y = -topHiddenPx, i = 1;
            while ( y < height ) {
                auto line = tl_editor.lineInfo( lindex++ );
                drawLine( body_buf, y, line );
                y += (line.height * lineHeight).to!int;
                i++;
            }

            b.drawRescaled( body_r, body_buf,
                   Rect( 0, 0, body_buf.width, body_buf.height ) );
            object.destroy( body_buf );

            drawBars( b );
        }

        private auto onMouseEvent ( Widget w, MouseEvent e )
        {
            auto f = max( xToFrame( e.x - headerWidth ), 0 );
            auto l = max( yToLineIndex( e.y ), 0 );

            switch ( e.action ) {
                case MouseAction.ButtonDown:
                    invalidate;
                    if ( e.button & MouseButton.Left )
                        return tl_editor.onLeftDown(f,l);
                    break;

                case MouseAction.Move:
                    if ( tl_editor.onMouseMove(f,l) ) {
                        invalidate;
                        return true;
                    }
                    break;

                case MouseAction.ButtonUp:
                    invalidate;
                    if ( e.button & MouseButton.Left )
                        return tl_editor.onLeftUp(f,l);
                    break;

                default:
            }
            return false;
        }
}
