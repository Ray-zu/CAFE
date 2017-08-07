/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.renderer.graphics.Bitmap;
import cafe.renderer.graphics.Color;
import std.algorithm;

debug = 0;

/+ T型の構造体を各ピクセルに持ったBMPクラス   +
 + 使用する際はBMPエイリアスを使ってください。+/
class Bitmap (T)
{
    private:
        T[] bmp;    // Y * width + X でアクセス
        uint bmp_width;
        uint bmp_height;

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
            bmp_width  = w;
            bmp_height = h;
            bmp.length = w*h;
        }

        /+ this[x,y]で指定座標のT構造体取得 +/
        T opIndex ( size_t x, size_t y )
        {
            return bmp[y*width+x];
        }

        /+ this[x,y] = vで指定座標のT構造体設定 +/
        T opIndexAssign ( T v, size_t x, size_t y )
        {
            return bmp[y*width+x] = v;
        }

        debug (1) unittest {
            auto hoge = new Bitmap!char( 100, 100 );
            assert( hoge.width == 100 );
            assert( hoge.height == 100 );
            hoge[50, 50] = 'a';
            assert( hoge[50,50] == 'a' );

            auto huge = new BMP( 100, 100 );
            huge[50,50] = RGBA( 100, 100, 100, 150 );
            assert( huge[50,50].r == 100 );
        }
}

alias BitmapRGBA = Bitmap!RGBA;     // RGBAをピクセルデータに持ったBMP
alias BMP = BitmapRGBA;             // BMPを使用してください
