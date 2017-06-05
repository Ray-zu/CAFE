/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.project.timeline.effect.Effect;
import cafe.project.timeline.property.PropertyList,
       cafe.project.timeline.PropertyKeepableObject;

abstract class Effect : PropertyKeepableObject
{
    mixin PropertyKeepableObjectCommon;
    public:
        static @property string name ();

        this ()
        {
            initProperties;
        }

        //TODO : ポリゴンリストデータにエフェクトを適用するメソッドを追加
}