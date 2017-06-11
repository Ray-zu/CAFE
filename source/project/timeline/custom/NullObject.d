/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.project.timeline.custom.NullObject;
import cafe.project.timeline.PlaceableObject,
       cafe.project.timeline.EffectKeepableObject,
       cafe.project.timeline.PropertyKeepableObject,
       cafe.project.timeline.property.Property;

/+ タイムライン表示等のテストに使用する何もしないオブジェクト +/
class NullObject : PlaceableObject, PropertyKeepableObject, EffectKeepableObject
{
    mixin PlaceableObjectCommon;
    mixin PropertyKeepableObjectCommon;
    mixin EffectKeepableObjectCommon;

    public:
        override @property string name ()
        {
            return "NullObject";
        }

        this () {}

        override void initProperties ()
        {
            auto len = place.frame.length;
            properties["int"]   = new PropertyBase!int( len, 0 );
            properties["float"] = new PropertyBase!float( len, 0 );
        }
}
