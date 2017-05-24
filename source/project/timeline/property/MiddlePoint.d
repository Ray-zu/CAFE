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
        @property value  () { return st_value;     }
        @property frame  () { return frame_period; }

        @property value  ( T i )          { st_value = i;    }

        this ( T s, FramePeriod f )
        {
            value = s;
            frame_period = f;
        }

        unittest {
            auto frame = new FramePeriod( new FrameLength( 100 ), new FrameAt( 50 ), new FrameLength( 20 ) );
            auto hoge = new MiddlePoint!string( "5000chouen hoshii", frame );
            assert( hoge.value == "5000chouen hoshii" );

            hoge = new MiddlePoint!float( 114.514, frame );
            assert( hoge.value == 114.514 );
        }
}
