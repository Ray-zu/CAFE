/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.gui.controls.BMPViewer;
import cafe.gui.BitmapLight,
       cafe.renderer.graphics.Bitmap;
import dlangui;

/+ BMPを表示するウィジェット                                    +
 + ピクセル操作してるのでウィジェット大きくするとやばい(やばい) +/
class BMPViewer : Widget
{
    private:
        DrawBuf bmp;

    public:
        @property bitmap () { return bmp; }
        @property bitmap ( DrawBuf bmp )
        {
            this.bmp = bmp;
            invalidate;
        }

        this ( string id, DrawBuf bmp = null )
        {
            import cafe.renderer.graphics.Color;
            auto tempbmp = new BMP( 5, 5 );
            tempbmp[0,0] = RGBA( 255, 255, 255 );
            bmp = new BitmapLight( tempbmp );

            super( id );
            bitmap = bmp;
        }

        override void onDraw ( DrawBuf b )
        {
            if ( !bitmap ) return;
            auto dst_rect = Rect( 0, 0, width, height );
            auto src_rect = Rect( 0, 0, bitmap.width, bitmap.height );
            b.drawRescaled( dst_rect, bitmap, src_rect );
        }
}
