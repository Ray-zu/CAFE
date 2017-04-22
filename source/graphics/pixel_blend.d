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

module cafe.graphics.pixel_blend;
import std.algorithm,
       std.conv;
import cafe.graphics.pixel;

debug = 1;

/+ ビット数値を正規化します。 +/
private @property auto normalize ( int n )
{
    return max( min( ubyte.max, n ), ubyte.min ).to!ubyte;
}

/+ 値を255で割り、ブレンド式用に正規化します。 +/
private @property auto floating ( int n )
{
    return (n*1.0) / (ubyte.max*1.0);
}

/+ 正規化のテスト +/
debug ( 1 ) unittest {
    assert( ( 114514).normalize == ubyte.max );
    assert( (-114514).normalize == ubyte.min );

    assert( (255).floating == 1.0 );
    assert( (  0).floating == 0.0 );
}


/+ 冗長なコードを避けるために共通部分を文字列化し、mixinできるようにします。 +/
enum CommonVars = q{
    auto result = Pixel();
    auto Fa = fg.a.floating;
    auto Fr = fg.r.floating;
    auto Fg = fg.g.floating;
    auto Fb = fg.b.floating;
    auto Ba = bg.a.floating;
    auto Br = bg.r.floating;
    auto Bg = bg.g.floating;
    auto Bb = bg.b.floating;
    auto Ca = Fa+(1-Fa)*Ba;
};


/+ 通常モードでブレンドします。 +/
Pixel blendNormal ( Pixel fg, Pixel bg )
{
    mixin( CommonVars );
    result.a = (Ca * 255).to!short;
    if ( Ca != 0 ) {
        result.r = ((( Fa * Ba * Fr + Fa * (1-Ba) * Fr + (1-Fa) * Ba * Br ) / Ca) * 255).to!short;
        result.g = ((( Fa * Ba * Fg + Fa * (1-Ba) * Fg + (1-Fa) * Ba * Bg ) / Ca) * 255).to!short;
        result.b = ((( Fa * Ba * Fb + Fa * (1-Ba) * Fb + (1-Fa) * Ba * Bb ) / Ca) * 255).to!short;
    }
    return result;
}

debug ( 1 ) unittest {
    Pixel bg = { r:255, g:0, b:0, a:255 };
    Pixel fg = { r:0, g:0, b:255, a:(0.5*ubyte.max).to!short };
    auto result = blendNormal( fg, bg );
    assert( result.r == 128 );
    assert( result.g == 0 );
    assert( result.b == 127 );
    assert( result.a == 255 );
}
