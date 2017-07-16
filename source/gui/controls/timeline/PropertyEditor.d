/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.gui.controls.timeline.PropertyEditor;
import cafe.project.ObjectPlacingInfo,
       cafe.project.timeline.Timeline,
       cafe.project.timeline.PlaceableObject,
       cafe.project.timeline.property.Property,
       cafe.project.timeline.property.MiddlePoint;
import std.algorithm,
       std.conv,
       std.exception;

/+ インスタンスを作成せずに中間点を移動 +/
void moveMP ( Property prop, int f, int n )
{
    (new PropertyEditor(prop)).moveMP( f, n );
}

/+ インスタンスを作成せずに破壊的リサイズ +/
void resizeDestroy ( Property prop, int len )
{
    (new PropertyEditor(prop)).resizeDestroy( len );
}

/+ プロパティを操作するクラス +/
class PropertyEditor
{
    private:
        Property prop;

    public:
        this ( Property p )
        {
            prop = p;
        }

        /+ n番目の中間点をフレームfに近づける +/
        void moveMP ( int f, int n )
        {
            auto mps = prop.middlePoints;
            enforce( n >= 0 && n < mps.length , "The middle point is undefined." );

            if ( n == 0 ) return;   // 0番目の中間点は動かせない

            auto curr = mps[n];
            auto prev = mps[n-1];
            auto next = n < mps.length-1 ? mps[n+1] : null;

            auto next_frame = next ? next.frame.start.value : prop.frame.value - 1;

            f = max( prev.frame.start.value + 1, min( f, next_frame - 1 ) );

            if ( prev ) prev.frame.length.value = f - prev.frame.start.value;
            curr.frame.start.value  = f;
            curr.frame.length.value = next_frame - f;
        }

        /+ 中間点を破壊してリサイズ +/
        void resizeDestroy ( int len )
        {
            auto cut_mp = prop.middlePoints.countUntil
                !( x => x.frame.start.value >= len-1 );

            if ( cut_mp == -1 || cut_mp == 0 ) {
                // 最後の中間点からを伸ばす
                auto mp = prop.middlePoints[$-1];
                mp.frame.length.value =
                    (len - mp.frame.start.value).to!uint;
            } else {
                // 余分な中間点を消す
                auto last_mp  = prop.middlePoints[cut_mp-1];
                auto new_len = len - last_mp.frame.start.value.to!int;
                if ( new_len > 0 )
                    last_mp.frame.length.value = new_len;
                else cut_mp--;
            }

            // cut_mp以降の中間点を削除
            if ( cut_mp >= 0 ) {
                if ( cut_mp == 0 ) cut_mp = 1;
                foreach ( i; cut_mp .. prop.middlePoints.length )
                    prop.removeMiddlePoint( prop.middlePoints[$-1] );
            }
        }
}
