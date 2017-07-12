/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.gui.controls.timeline.ObjectEditor;
import cafe.project.ObjectPlacingInfo,
       cafe.project.timeline.Timeline,
       cafe.project.timeline.PlaceableObject,
       cafe.project.timeline.property.Property,
       cafe.project.timeline.property.MiddlePoint;
import std.algorithm,
       std.conv,
       std.exception;

/+ ObjectEditorインスタンスを作らずにobjをリサイズ +/
void resize ( PlaceableObject obj, int len )
{
    auto oe = new ObjectEditor( obj );
    oe.resize( len );
}

/+ 左端をリサイズ +/
void resizeStart ( PlaceableObject obj, FrameAt f )
{
    auto ed = obj.place.frame.end.value;
    f.value = f.value >= ed ? ed - 1 : f.value;

    auto new_len = ed - f.value;
    obj.resize( new_len );
    obj.place.frame.resizeStart( f );
}


/+ オブジェクトをリサイズ                    +
 + 当たり判定処理はTimelineEditorで行います。+/
class ObjectEditor
{
    private:
        PlaceableObject obj;

    public:
        this ( PlaceableObject o )
        {
            obj = o;
        }

        /+ 中間点を破壊しながらリサイズ                    +
         + 縮めた場合は後ろの中間点を消し、                +
         + 伸ばした場合は後ろの中間点からのみを伸ばします。+/
        void resizeDestroy ( int len )
        {
            enforce( len > 0, "Length must be 1 or more." );

            void proc ( Property prop )
            {
                auto cut_mp = prop.middlePoints.countUntil
                    !( x => x.frame.start.value >= len-1 );

                if ( cut_mp == -1 ) {
                    // 伸ばされたときは最後の中間点からを伸ばす
                    auto mp = prop.middlePoints[$-1];
                    mp.frame.length.value =
                        (len - mp.frame.start.value.to!int).to!uint;
                } else {
                    // 縮まされたときは余分な中間点を消す
                    auto mp = prop.middlePoints[cut_mp];
                    auto new_len = len - mp.frame.start.value.to!int;
                    if ( new_len > 0 )
                        mp.frame.length.value = new_len;
                    else cut_mp--;
                }

                /+ cut_mp以降の中間点を削除 +/
                if ( cut_mp > 0 ) {
                    foreach ( i; cut_mp .. prop.middlePoints.length )
                        prop.removeMiddlePoint( prop.middlePoints[$-1] );
                }
            }

            obj.propertyList.properties.values.each!proc;
        }

        /+ 現在の設定でリサイズ +/
        void resize ( int len )
        {
            resizeDestroy( len );
        }
}
