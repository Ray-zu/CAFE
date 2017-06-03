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
       std.array,
       std.conv,
       std.traits;

debug = 0;

/+ プロパティデータのインターフェース +/
interface Property
{
    public:
        @property FrameLength   frame        ();
        @property MiddlePoint[] middlePoints ();

        /+ フレーム数から中間点クラスを返す +/
        MiddlePoint middlePointAtFrame ( FrameAt );

        /+ ユーザーの入力した文字列をプロパティに変換 +/
        void   setFromString ( FrameAt, string );
        string getFromString ( FrameAt );
}

/+ プロパティデータ +/
class PropertyBase (T) : Property
{
    private:
        alias MPoint = MiddlePointBase!T;

        FrameLength frame_len;
        MiddlePoint[]    middle_points;
        T           end_value;

        /+ 次の中間点を返す(最後の中間点だった場合はnullが返る) +/
        @property nextMiddlePoint ( MiddlePoint mp )
        {
            auto index = middlePoints.countUntil( mp );
            if ( index < 0 )
                throw new Exception( "The middle point isn't member of this property." );
            if ( ++index < middlePoints.length )
                return cast(MiddlePointBase!T)middlePoints[index];
            else return null;
        }

        /+ 次の中間点の開始値又はオブジェクトの終了値を返す +/
        @property nextValue ( MiddlePoint mp )
        {
            if ( auto m = nextMiddlePoint(mp) )
                return m.value;
            else return endValue;
        }

        /+ 次の中間点又は終端のフレーム数を返す +/
        @property nextFrame ( MiddlePoint mp )
        {
            if ( auto m = nextMiddlePoint(mp) )
                return m.frame.start;
            else return cast(FrameAt)frame;
        }

        /+ 中間点を指定されたものの次に追加 +/
        @property insertMiddlePoint ( MiddlePoint mp, MiddlePoint w )
        {
            w.frame.length.value = mp.frame.start.value - w.frame.start.value;
            middle_points.insertInPlace( middlePoints.countUntil(w)+1, mp );
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

        /+ 元の型でプロパティを設定 +/
        void set ( FrameAt f, T v )
        {
            if ( f.value == frame.value-1 ) { // オブジェクトの最終フレームが指定された場合
                end_value = v;
            } else {
                auto mp = middlePointAtFrame(f);

                if ( mp.frame.start.value == f.value ) { // 中間点の開始点を指定された場合
                    (cast(MiddlePointBase!T)mp).value = v;
                } else {                                 // 中間点の真ん中を指定された場合
                    auto flength = new FrameLength( nextFrame(mp).value - f.value );
                    auto fperiod = new FramePeriod( frame, f, flength );

                    auto mp_new = new MiddlePointBase!T( v, fperiod );
                    static if ( isNumeric!T ) mp_new.easing = mp.easing;
                    insertMiddlePoint( mp_new, mp );
                }
            }
        }

        override void setFromString ( FrameAt f, string v )
        {
            set( f, v.to!T );
        }

        /+ 元の型でプロパティを取得 +/
        T get ( FrameAt f )
        {
            auto mp = middlePointAtFrame(f);
            auto st = (cast(MiddlePointBase!T)mp).value;

            static if ( !isNumeric!T ) return st;
            else {
                auto easing_type = mp.easing;
                if ( easing_type == EasingType.None ) return st;

                auto ed = nextValue(mp);
                auto easing = EasingFunction.create( easing_type, st.to!float, ed.to!float,
                        mp.frame.length );
                return easing.at( new FrameAt( f.value - mp.frame.start.value ) );
            }
        }

        override string getFromString ( FrameAt f )
        {
            return get( f ).to!string;
        }

        debug ( 1 ) unittest {
            auto hoge = new PropertyBase!float( new FrameLength(50), 20 );
            assert( hoge.middlePoints.length == 1 );
            assert( hoge.middlePointAtFrame(new FrameAt(10)).frame.start.value == 0 );
            assert( hoge.nextValue(hoge.middlePoints[0]) == 20 );

            (cast(MiddlePointBase!T)hoge.middlePoints[0]).easing = EasingType.Linear;

            hoge.set( new FrameAt(25), 0 );
            assert( hoge.get( new FrameAt(5) ) == 16 ); // 20 to 0 with LinearEasing for 25 frames
            hoge.set( new FrameAt(25), 40 );
            assert( hoge.middlePoints.length == 2 );
            assert( hoge.get( new FrameAt(5) ) == 24 ); // 20 to 40 with LinearEasing for 25 frames
            hoge.set( new FrameAt(49), 60 );
            assert( hoge.middlePoints.length == 2 );
            assert( hoge.get( new FrameAt(30) ) == 44 ); // 40 to 60 with LinearEasing for 25 frames
        }
}
