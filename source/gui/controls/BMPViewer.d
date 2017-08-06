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
        ColorDrawBuf bmp;

    public:
        @property bitmap () { return bmp; }
        @property bitmap ( BMP b )
        {
            if ( b ) {
                if ( bmp )
                    bmp.resize( b.width, b.height );
                else
                    bmp = new ColorDrawBuf( b.width, b.height );
                bmp._buf = b.bitmap;
            } else if ( bmp ) bmp.clear;
            invalidate;
        }

        this ( string id = "" )
        {
            this( id, null );
        }

        this ( string id, BMP b )
        {
            super( id );
            bmp = null;
            bitmap = b;
        }

        ~this ()
        {
            if ( this.bmp ) {
                this.bmp.releaseRef;
                object.destroy( this.bmp );
            }
        }

        override void onDraw ( DrawBuf b )
        {
            if ( !bitmap ) return;
            auto src_rect = Rect( 0, 0, bitmap.width, bitmap.height );
            b.drawRescaled( pos, bitmap, src_rect );
        }
}
