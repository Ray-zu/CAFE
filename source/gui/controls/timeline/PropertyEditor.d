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
       std.exception;

/+ インスタンスを作成せずに中間点を移動 +/
void moveMP ( Property prop, int f, int n )
{
    (new PropertyEditor(prop)).moveMP( f, n );
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
            enforce( f >= 0 && f < prop.frame.value, "The frame is over than parent's." );
            enforce( n >= 0 && n < mps.length , "The middle point is undefined." );

            if ( n == 0 ) return;   // 0番目の中間点は動かせない

            auto curr = mps[n];
            auto prev = mps[n-1];
            auto next = n < mps.length-1 ? mps[n+1] : null;

            auto next_frame = next ? next.frame.start.value : prop.frame.value;

            f = max( prev.frame.start.value + 1, min( f, next_frame - 1 ) );

            if ( prev ) prev.frame.length.value = f - prev.frame.start.value;
            curr.frame.start.value  = f;
            curr.frame.length.value = next_frame - f;
        }
}
