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

/+ BMPを表示するウィジェット +/
class BMPViewer : Widget
{
    private:
        BMP bmp;

    public:
        @property bitmap () { return bmp; }

        this ( string id, BMP bmp = null )
        {
            super( id );
            this.bmp = bmp;
        }

        override void onDraw ( DrawBuf b )
        {
        }
}
