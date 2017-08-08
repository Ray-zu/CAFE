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
    public:
        bool f = false;
        @property void drawable ( BMP b )
        {
            DrawBufRef bmp = new BitmapLight( b );

            if ( f ) bmp.fill( 0x00ffff );
            f = !f;

            super.drawable = new ImageDrawable( bmp );
        }

        this ( string id = "" )
        {
            super( id );
        }
}
