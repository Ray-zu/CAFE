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
       std.exception;

debug = 1;

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

        /+ 中間点を破壊しながらリサイズ                +
         + 縮めた場合は後ろの中間点を消し、            +
         + 伸ばした場合は後ろの中間点のみを伸ばします。+/
        void resizeDestroy ( int len )
        {
            enforce( len > 0, "Length must be 1 or more." );

            void proc ( Property prop )
            {
                auto cut_mp = prop.middlePoints.countUntil
                    !( x => x.frame.start.value >= len );
                // TODO
            }

            obj.propertyList.properties.values.each!proc;
        }

        debug (1) unittest {
            auto hoge = new ObjectEditor( null );
        }
}
