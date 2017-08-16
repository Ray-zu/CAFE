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
       cafe.project.timeline.property.PropertyList,
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

/+ 右端をリサイズ +/
void resizeEnd ( PlaceableObject obj, FrameAt f )
{
    auto st = obj.place.frame.start.value;
    f.value = f.value <= st ? st + 1 : f.value;

    auto new_len = f.value - st;
    obj.resize( new_len );
    obj.place.frame.resizeEnd( f );
}


/+ オブジェクト操作するクラス +/
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

            void proc ( PropertyList ps )
            {
                ps.properties.values.each!( x => x.resizeDestroy(len) );
            }
            proc( obj.propertyList );
            obj.effectList.effects.each!( x => proc( x.propertyList ) );
        }

        /+ 現在の設定でリサイズ +/
        void resize ( int len )
        {
            resizeDestroy( len );
        }
}
