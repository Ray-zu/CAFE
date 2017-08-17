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
        @property void drawable ( BMP b )
        {
            buf = new BitmapLight( b );

            DrawBufRef bmp = buf;
            super.drawable = new ImageDrawable( bmp );
        }

        this ( string id = "" )
        {
            super( id );
            backgroundColor = 0x000000;
        }

        override void measure ( int pw, int ph )
        {
            if ( buf && buf.width != SIZE_UNSPECIFIED &&buf.height != SIZE_UNSPECIFIED ) {
                auto w = buf.width;
                auto h = buf.height;

                auto zoom = pw / w.to!float;
                if ( pw < w*zoom || ph < h*zoom )
                    zoom = ph / h.to!float;

                w = (w * zoom).to!int;
                h = (h * zoom).to!int;
                import std.format;Log.i( "%d:%d".format(w,h) );
                measuredContent( pw, ph, w, h );
            } else super.measure( pw, ph );
        }
}
