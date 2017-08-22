/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.project.timeline.PropertyKeepableObject;
import cafe.project.timeline.property.PropertyList,
       cafe.project.timeline.effect.EffectList,
       cafe.project.ObjectPlacingInfo;
import std.json;

/+ プロパティを持てるオブジェクトのインターフェース +/
interface PropertyKeepableObject
{
    public:
        @property PropertyList propertyList ();

        void initProperties ( FrameLength );

        @property JSONValue json ();

        final auto castedProperty (T) ( string id )
        {
            import cafe.project.timeline.property.Property;
            auto p = propertyList[id];
            return cast(PropertyBase!T)p;
        }
}
