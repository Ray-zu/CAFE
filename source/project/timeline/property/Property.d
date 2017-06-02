/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.project.timeline.property.Property;
import cafe.project.ObjectPlacingInfo,
       cafe.project.timeline.property.Easing,
       cafe.project.timeline.property.MiddlePoint;
import std.algorithm,
       std.conv,
       std.traits;

debug = 1;

/+ プロパティデータのインターフェース +/
interface Property
{
    public:
        @property FrameLength   frame        ();
        @property MiddlePoint[] middlePoints ();

        /+ フレーム数から中間点クラスを返す +/
        MiddlePoint middlePointAtFrame ( FrameAt );

        /+ ユーザーの入力した文字列をプロパティに変換 +/
        void   set ( FrameAt, string );
        string get ( FrameAt );
}

/+ プロパティデータ +/
class PropertyBase (T) : Property
{
    private:
        alias MPoint = MiddlePointBase!T;

        FrameLength frame_len;
        MiddlePoint[]    middle_points;
        T           end_value;

        @property castedMiddlePoint ( ulong index )
        {
            return cast(MiddlePointBase!T)middlePoints[index];
        }

        @property nextValue ( MiddlePoint mp )
        {
            auto index = middlePoints.countUntil( mp );
            index++;
            if ( index < middlePoints.length )
                return castedMiddlePoint(index).value;
            else return end_value;
        }

    public:
        override @property FrameLength   frame        () { return frame_len;     }
        override @property MiddlePoint[] middlePoints () { return middle_points; }
                 @property T             endValue     () { return end_value;     }

        this ( FrameLength f, T v )
        {
            frame_len = f;
            middle_points = [new MPoint( v,
                    new FramePeriod( f, new FrameAt(0), new FrameLength(f.value) ) )];
            end_value = v;
        }

        override MiddlePoint middlePointAtFrame ( FrameAt f )
        {
            foreach ( mp; middlePoints )
                if ( mp.frame.isInRange(f) ) return mp;
            throw new Exception( "We can't find middle point at that frame." );
        }

        override void set ( FrameAt f, string v )
        {
            throw new Exception( "Not Implemented" );
        }

        override string get ( FrameAt f )
        {
            auto mp = middlePointAtFrame(f);
            auto st = (cast(MiddlePointBase!T)mp).value;

            static if ( !isNumeric!T ) return st.to!string;
            else {
                auto easing_type = mp.easing;
                if ( easing_type == EasingType.None ) return st.to!string;

                auto ed = nextValue(mp);
                auto easing = EasingFunction.create( easing_type, st.to!float, ed.to!float,
                        mp.frame.length );
                return easing.at( new FrameAt( f.value - mp.frame.start.value ) ).to!T.to!string;
            }
        }

        debug ( 1 ) unittest {
            auto hoge = new PropertyBase!float( new FrameLength(50), 20 );
            assert( hoge.middlePoints.length == 1 );
            assert( hoge.middlePointAtFrame(new FrameAt(10)).frame.start.value == 0 );
            assert( hoge.castedMiddlePoint(0).value == 20 );
            assert( hoge.nextValue(hoge.middlePoints[0]) == 20 );

            hoge.castedMiddlePoint(0).value = 40;
            hoge.castedMiddlePoint(0).easing = EasingType.Linear;
            assert( hoge.get( new FrameAt( 25 ) ) == "30" );
        }
}

/+ プロパティのプリセット +/
enum PropertyPreset
{
    Positioning2D
}

/+ プリセットに応じたプロパティ文字列連想配列を返す +/
@property loadPropertyPreset ( PropertyPreset p, FrameLength f )
{
    Property[string] result;
    switch ( p )
    {
        case PropertyPreset.Positioning2D:
            result["X"] = new PropertyBase!float( f, 0 );
            result["Y"] = new PropertyBase!float( f, 0 );
            break;

        default: throw new Exception( "It was unexpected.." );
    }
    return result;
}
