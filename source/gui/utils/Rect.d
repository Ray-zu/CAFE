/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.gui.utils.Rect;
import std.algorithm;
import dlangui;

/+ r1をr2の中に収まるように削る +/
Rect shrinkRect ( Rect r1, Rect r2 )
{
    return Rect( 
            max( r1.left  , r2.left   ),
            max( r1.top   , r2.top    ),
            min( r1.right , r2.right  ),
            min( r1.bottom, r2.bottom ) );
}
