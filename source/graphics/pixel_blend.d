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


/+  +/
