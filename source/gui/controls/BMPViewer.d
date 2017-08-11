/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.gui.controls.BMPViewer;
import cafe.gui.BitmapLight,
       cafe.renderer.graphics.Bitmap;
import dlangui,
       dlangui.widgets.metadata;

mixin( registerWidgets!BMPViewer );

/+ BMPを表示するウィジェット +/
class BMPViewer : ImageWidget
{
    private:
        BitmapLight buf = null;

    public:
        bool f = false;
        @property void drawable ( BMP b )
        {
            buf = new BitmapLight( b );

            if ( f ) buf.fill( 0x00ffff );
            f = !f;

            DrawBufRef bmp = buf;
            super.drawable = new ImageDrawable( bmp );
        }

        this ( string id = "" )
        {
            super( id );
            backgroundColor = 0x000000;
        }
}
