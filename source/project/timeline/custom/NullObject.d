/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.project.timeline.custom.NullObject;
import cafe.project.RenderingInfo,
       cafe.project.ObjectPlacingInfo,
       cafe.project.timeline.PlaceableObject;

debug = 1;

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

        this ( ObjectPlacingInfo f )
        {
            super( f );
        }

        override void initProperties ()
        {
        }

        override void generate ( RenderingInfo rinfo )
        {
        }

        debug (1) unittest {
            auto hoge = new NullObject(
                    new ObjectPlacingInfo( new LayerId(0),
                        new FramePeriod( new FrameLength(5), new FrameAt(0), new FrameLength(1) ) ) );
        }
}
