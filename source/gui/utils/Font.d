/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.gui.utils.Font;
import std.conv;
import dlangui;

/+ 中央揃えで描画 +/
void drawCenteredText ( Font f, DrawBuf b, int x, int y, string text, uint col )
{
    auto dtext = text.to!dstring;
    auto sz = f.textSize( dtext );
    f.drawText( b, x-sz.x/2,y-sz.y/2, dtext, col );
}

/+ 横方向に左揃えで縦方向に中央揃えで描画 +/
void drawLeftCenteredText ( Font f, DrawBuf b, int x, int y, string text, uint col )
{
    auto dtext = text.to!dstring;
    auto sz = f.textSize( dtext );
    f.drawText( b, x,y-sz.y/2, dtext, col );
}
