/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.project.timeline.property.MiddlePoint;
import cafe.project.ObjectPlacingInfo,
       cafe.project.timeline.property.Easing;
import std.traits;

debug = 1;

/+ 中間点データのインターフェース +/
interface MiddlePoint
{
    public:
        @property FramePeriod frame ();

        @property EasingType easing ();
        @property void easing ( EasingType );
}

/+ 中間点データのベースクラス +/
class MiddlePointBase (T) : MiddlePoint
    if ( isScalarType!T || isSomeString!T )
{
    private:
        T st_value;
        FramePeriod frame_period;

    public:
                 @property             value () { return st_value;     }
        override @property FramePeriod frame () { return frame_period; }

        @property value ( T i ) { st_value = i; }

        /+ データ型が数値かどうかでイージング関連の処理を分岐させます +/
        static if ( isNumeric!T ) {
            private EasingType easing_func;
            override @property EasingType easing ()               { return easing_func; }
            override @property void       easing ( EasingType t ) { easing_func = t;    }
        } else {
            override @property EasingType easing ()             { return EasingType.None; }
            override @property void       easing ( EasingType ) {
                throw new Exception( "You can't do easing to this property." );
            }
        }

        this ( MiddlePointBase!T src )
        {
            st_value = src.value;
            frame_period = new FramePeriod( src.frame );
            static if ( isNumeric!T )
                easing_func = src.easing;
        }

        this ( T s, FramePeriod f )
        {
            value = s;
            frame_period = f;
            static if ( isNumeric!T )
                easing_func = EasingType.None;
        }

        debug (1) unittest {
            auto frame = new FramePeriod( new FrameLength( 100 ), new FrameAt( 50 ), new FrameLength( 20 ) );
            auto hoge = new MiddlePointBase!string( "5000chouen hoshii", frame );
            assert( hoge.easing == EasingType.None );
            assert( hoge.value == "5000chouen hoshii" );

            auto huge = new MiddlePointBase!float( 114.514, frame );
            huge.easing = EasingType.Linear;
            assert( huge.easing == EasingType.Linear );
            assert( huge.value == 114.514f );
        }
}
