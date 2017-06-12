/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.project.timeline.custom.NullObject;
import cafe.project.timeline.PlaceableObject;

debug = 0;

/+ デバッグ用の何もしないオブジェクト +/
class NullObject : PlaceableObject
{
    mixin EffectKeepableObjectCommon;
    public:
        override @property PlaceableObject copy ()
        {
            return new NullObject( this );
        }

        this ( NullObject src )
        {
            super( src );
            copyEffectFrom( src );
        }

        this ()
        {
            super();
        }

        override void initProperties ()
        {
        }

        debug (1) unittest {
            auto hoge = new NullObject;
        }
}
