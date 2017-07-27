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
        DrawBuf bmp;

    public:
        @property bitmap () { return bmp; }
        @property bitmap ( DrawBuf bmp )
        {
            this.bmp = bmp;
            invalidate;
        }

        this ( string id = "" )
        {
            this( id, null );
        }

        this ( string id, BMP bmp )
        {
            super( id );
            bitmap = bmp ?
                new BitmapLight( bmp ) : null;
        }

        override void onDraw ( DrawBuf b )
        {
            if ( !bitmap ) return;
            auto src_rect = Rect( 0, 0, bitmap.width, bitmap.height );
            b.drawRescaled( pos, bitmap, src_rect );
        }
}
