/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.renderer.graphics.Bitmap;
import cafe.renderer.graphics.Color;
import std.algorithm;

/+ T型の構造体を各ピクセルに持ったBMPクラス   +
 + 使用する際はBMPエイリアスを使ってください。+/
class Bitmap
{
    private:
        uint[] bmp; // y*width+xで指定座標にアクセス
        int bmp_width;
        int bmp_height;

    public:
        @property bitmap () { return bmp;        }
        @property width  () { return bmp_width;  }
        @property height () { return bmp_height; }

        this ( uint w, uint h )
        {
            resize( w, h );
        }

        /+ Bitmapをリサイズ +/
        void resize ( uint w, uint h )
        {
            w = max( w, 1 ); h = max( h, 1 );
            bmp.length = w*h;
            bmp_width  = w;
            bmp_height = h;
        }

        auto opIndex ( size_t x, size_t y )
        {
            return bmp[ y*width+x ];
        }

        auto opIndexAssign ( uint i, size_t x, size_t y )
        {
            return bmp[ y*width+x ] = i;
        }
}

alias BMP = Bitmap;             // BMPを使用してください
