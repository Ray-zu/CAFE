/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.renderer.graphics.Bitmap;
import std.algorithm;

debug = 1;

/+ T型の構造体を各ピクセルに持ったBMPクラス +/
class Bitmap (T)
{
    private:
        T[][] bmp;

    public:
        @property bitmap () { return bmp;           }
        @property width  () { return bmp[0].length; }
        @property height () { return bmp.length;    }

        this ( uint w, uint h )
        {
            resize( w, h );
        }

        /+ Bitmapをリサイズ +/
        void resize ( uint w, uint h )
        {
            bmp.length = h;
            bmp.each!( x => x.length = w );
        }

        /+ this[x,y]で指定座標のT構造体取得 +/
        T opIndex ( size_t x, size_t y )
        {
            return bmp[x][y];
        }

        /+ this[x,y] = vで指定座標のT構造体設定 +/
        T opIndexAssign ( T v, size_t x, size_t y )
        {
            return bmp[x][y] = v;
        }

        debug (1) unittest {
            auto hoge = Bitmap!char( 100, 100 );
            hoge[50, 50] = 'a';
            assert( hoge.width == 100 );
            assert( hoge.height == 100 );
            assert( hoge[50,50] == 'a' );
        }
}
