/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.renderer.graphics.Color;
import std.algorithm,
       std.conv;

debug = 0;

/+ RGBA色情報                                     +
 + RGBの値はそれぞれshortで保持し、劣化を防ぎます +/
struct RGBA
{
    public:
        short r,g,b;
        ubyte a;

        this ( short r, short g, short b, ubyte a = 0 )
        {
            this.r = r; this.g = g; this.b = b; this.a = a;
        }

        /+ 正規化された色を返す +/
        @property normalizedColor ()
        {
            ubyte n ( short t ) {
                return max( min( t, ubyte.max ), ubyte.min ).to!ubyte;
            }

            auto r = n(this.r);
            auto g = n(this.g);
            auto b = n(this.b);
            return RGBA( r, g, b, a );
        }

        debug (1) unittest {
            auto hoge = RGBA( 300, 400, 500 );
            auto nhoge = hoge.normalizedColor;
            assert( nhoge.r == 255 );
            assert( nhoge.g == 255 );
            assert( nhoge.b == 255 );
            assert( nhoge.a == 0 );
        }
}
