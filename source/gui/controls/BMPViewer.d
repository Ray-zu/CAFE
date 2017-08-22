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
class BMPViewer : Widget
{
    private:
        BitmapLight buf = null;

    public:
        @property void drawable ( BMP b )
        {
            if ( buf ) object.destroy( buf );
            buf = new BitmapLight( b );
        }

        this ( string id = "" )
        {
            super( id );
            backgroundColor = 0x000000;
        }

        override void measure ( int pw, int ph )
        {
            if ( buf ) {
                auto w = buf.width;
                auto h = buf.height;
                auto z = minHeight / h.to!float;

                w = (w * z).to!int;
                h = (h * z).to!int;
                measuredContent( pw, ph, w, h );
            } else super.measure( pw, ph );
        }

        override void onDraw ( DrawBuf b )
        {
            super.onDraw( b );
            if ( !buf ) return;
            b.drawRescaled( pos, buf, Rect( 0, 0, buf.width, buf.height ) );
        }
}
