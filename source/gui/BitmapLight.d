/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.gui.BitmapLight;
import cafe.renderer.graphics.Bitmap;
import std.conv;
import dlangui;

debug = 0;

/+ BMPViewerコンポーネントに直接渡せるBitmapクラス +/
class BitmapLight : ColorDrawBuf
{
    public:
        /+ 通常のBMPから生成 +/
        this ( BMP src )
        {
            super( src.width.to!int, src.height.to!int );
            foreach ( y; 0 .. src.height )
                foreach ( x; 0 .. src.width )
                    _buf[y*_dx+x] = src[x,y].normalizedColor.toHex;
        }
}
