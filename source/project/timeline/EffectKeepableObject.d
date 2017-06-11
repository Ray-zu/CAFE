/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.project.timeline.EffectKeepableObject;
import cafe.project.timeline.effect.Effect;

/+ エフェクトデータを持てるオブジェクトのインターフェース +/
interface EffectKeepableObject
{
    public:
        @property Effect[] effects ();
}



/+ EffectableObjectの実体 +/
template EffectKeepableObjectCommon ()
{
    private:
        Effect[] obj_effects;

    public:
        override @property Effect[] effects ()
        {
            return obj_effects;
        }
}
