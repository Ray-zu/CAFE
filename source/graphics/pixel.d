/+ Copyright (C) 2017 aoitofu / Aodaruma / SEED264
   Author : aoitofu <aoitofu@dr.com>
   
   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 3 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>
+/

module cafe.graphics.pixel;
import std.algorithm,
       std.conv;

debug = 1;

/* ビット数値を正規化します。 */
@property auto normalize ( int n )
{
    return max( min( ubyte.max, n ), ubyte.min ).to!ubyte;
}

/+ 正規化のテスト +/
debug ( 1 ) unittest {
    assert( ( 114514).normalize == ubyte.max );
    assert( (-114514).normalize == ubyte.min );
}


/* ブレンドモードを表します。
   ブレンドモードは追加予定
*/
enum BlendType
{
    Normal,             // 通常
    Additional,         // 加算
    Subtraction,        // 減算
    Multiplication      // 乗算
}


/* 画素データを表します。
   RGBデータはそれぞれ2byte型ですが、画像化する際に255-0の間に正規化されます。
*/
struct Pixel
{
    public:
        short r, g, b, a;

        @property auto normalizedR ()
        {
            return r.normalize;
        }

        @property auto normalizedG ()
        {
            return g.normalize;
        }

        @property auto normalizedB ()
        {
            return b.normalize;
        }

        @property auto normalizedAlpha ()
        {
            return a.normalize;
        }
}
