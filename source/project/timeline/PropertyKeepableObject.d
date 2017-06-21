/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.project.timeline.PropertyKeepableObject;
import cafe.project.timeline.property.PropertyList,
       cafe.project.timeline.effect.EffectList;
import std.json;

/+ プロパティを持てるオブジェクトのインターフェース +/
interface PropertyKeepableObject
{
    public:
        @property PropertyList propertyList ();
        @property EffectList   effectList ();

        void initProperties ();

        @property JSONValue json ();
}
