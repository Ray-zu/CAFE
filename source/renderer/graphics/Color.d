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
 + RGBAの値はそれぞれfloatで保持し、劣化を防ぎます +/
struct RGBA
{
    public:
        float r,g,b;
        float a;

        this ( float r, float g, float b, float a = ubyte.max )
        {
            this.r = r; this.g = g; this.b = b; this.a = a;
        }

        /+ uint型に正規化して変換 +/
        @property @nogc uint toHex ()
        {
            return (cast(int)(r*ubyte.max) << 16) | (cast(int)(g*ubyte.max) << 8) |
                cast(int)(b*ubyte.max) | cast(int)(a*ubyte.max) << 24;
        }

        debug (1) unittest {
            auto hoge = RGBA( 1, 0, 0 );
            assert( hoge.toHex == 0xff0000 );
        }
}
