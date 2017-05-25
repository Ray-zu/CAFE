/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.project.timeline.property.Property;
import cafe.project.ObjectPlacingInfo,
       cafe.project.timeline.property.Easing;
import std.traits;

/+ 中間点データ +/
class MiddlePoint (T)
    if ( isScalarType!T )
{
    private:
        T st_value;
        FramePeriod frame_period;

    public:
        @property value  () { return st_value;        }
        @property frame  () { return frame_period;    }

        @property value ( T i ) { st_value = i; }

        /+ データ型が数値かどうかでイージング関連の処理を分岐させます +/
        static if ( isNumericType!T ) {
            private EasingType easing_func;
            @property easing ()               { return easing_func; }
            @property easing ( EasingType t ) { easing_func = t;    }
        } else {
            @property easing ()             { return EasingType.None; }
            @property easing ( EasingType ) {
                throw new Exception( "You can't do easing to this property." );
            }
        }

        this ( T s, FramePeriod f )
        {
            value = s;
            frame_period = f;
            static if ( isNumericType!T )
                easing_func = EasingType.None;
        }

        unittest {
            auto frame = new FramePeriod( new FrameLength( 100 ), new FrameAt( 50 ), new FrameLength( 20 ) );
            auto hoge = new MiddlePoint!string( "5000chouen hoshii", frame );
            assert( hoge.easing == EasingType.None );
            assert( hoge.value == "5000chouen hoshii" );

            hoge = new MiddlePoint!float( 114.514, frame );
            hoge.easing = EasingType.Linear;
            assert( hoge.easing == EasingType.Linear );
            assert( hoge.value == 114.514 );
        }
}
