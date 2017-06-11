/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.gui.controls.BMPViewer;
import cafe.renderer.graphics.Bitmap,
       cafe.renderer.graphics.Color;
import dlangui;

/+ BMPを表示するウィジェット                                    +
 + ピクセル操作してるのでウィジェット大きくするとやばい(やばい) +/
class BMPViewer : Widget
{
    private:
        BMP bmp;

    public:
        @property bitmap () { return bmp; }
        @property bitmap ( BMP bmp )
        {
            this.bmp = bmp;
            invalidate;
        }

        this ( string id, BMP bmp = null )
        {
            // テストコード
            bmp = new BMP( 10, 10 );
            bmp[5,5] = RGBA( 255, 255, 255 );

            super( id );
            bitmap = bmp;
        }

        override void onDraw ( DrawBuf b )
        {
            if ( !bitmap ) return;

            int dx, dy;
            int bx, by;
            auto bitw_per_pixelw = (bitmap.width.to!float/width.to!float);
            auto bith_per_pixelh = (bitmap.height.to!float/height.to!float);

            for ( dy=0; dy < height; dy++ )
                for ( dx=0; dx < width; dx++ ) {
                    bx = (bitw_per_pixelw * dx).to!int;
                    by = (bith_per_pixelh * dy).to!int;
                    b.drawPixel( dx, dy, bitmap[bx,by].toHex );
                }
        }
}
