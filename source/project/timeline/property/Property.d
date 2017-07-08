/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.project.timeline.property.Property;
import cafe.project.ObjectPlacingInfo,
       cafe.project.timeline.property.Easing,
       cafe.project.timeline.property.MiddlePoint,
       cafe.project.timeline.property.LimitedProperty,
       cafe.project.timeline.property.RendererProperty,
       cafe.project.timeline.property.BoolProperty;
import std.algorithm,
       std.array,
       std.conv,
       std.json,
       std.traits;

debug = 0;

/+ プロパティデータのインターフェース +/
interface Property
{
    public:
        @property Property copy ();

        @property FrameLength   frame        ();
        @property MiddlePoint[] middlePoints ();

        /+ 値の最大値と最小値を返す +/
        @property float maxFloat ();
        @property float minFloat ();

        /+ フレーム数から中間点クラスを返す +/
        MiddlePoint middlePointAtFrame ( FrameAt );

        /+ ユーザーの入力した文字列をプロパティに変換 +/
        void   setString ( FrameAt, string );
        string getString ( FrameAt );

        /+ 強制的にfloatで取得&設定 +/
        void  setFloat ( FrameAt, float );
        float getFloat ( FrameAt );

        /+ プロパティが数値かどうか +/
        @property bool increasable ();
        /+ プロパティの文字列変換で、複数行文字列を許可するかどうか +/
        @property bool allowMultiline ();

        /+ JSON形式のデータを返す +/
        @property JSONValue json ();

        /+ JSONから生成 +/
        static final Property create ( JSONValue j, FrameLength f )
        {
            Property result;
            auto value = j["value"];
            auto mps   = j["middle_points"].array;
            switch ( j["type"].str )
            {
                case "int":
                    return new PropertyBase!int( mps, f, value.integer.to!int );
                case "float":
                    return new PropertyBase!float( mps, f, value.floating );
                case "string":
                    return new PropertyBase!string( mps, f, value.str );
                case "bool":
                    return new BoolProperty( mps, f, value.type==JSON_TYPE.TRUE );

                case "int/LimitedProperty":
                    return new LimitedProperty!int( mps, f, value.integer.to!int,
                            j["max"].integer.to!int, j["min"].integer.to!int );
                case "float/LimitedProperty":
                    return new LimitedProperty!float( mps, f, value.floating,
                            j["max"].floating, j["min"].floating );

                case "Renderer":
                    return new RendererProperty( mps, f, value.str.to!RendererType );

                default: throw new Exception( "The type is not supported." );
            }
        }
}

/+ プロパティデータ +/
class PropertyBase (T) : Property
{
    enum MaximumValue = 10000;
    enum MinimumValue = -10000;
    private:
        FrameLength         frame_len;
        MiddlePointBase!T[] middle_points; // MiddlePointBase!T型で取得したい場合はプロパティではなく変数を参照する
        T                   end_value;

        /+ 次の中間点を返す(最後の中間点だった場合はnullが返る) +/
        @property nextMiddlePoint ( MiddlePoint mp )
        {
            auto index = middlePoints.countUntil( mp );
            if ( index < 0 )
                throw new Exception( "The middle point isn't member of this property." );
            if ( ++index < middlePoints.length )
                return middle_points[index];
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
            else return new FrameAt(frame.value);
        }

        /+ 中間点を指定されたものの次に追加 +/
        @property insertMiddlePoint ( MiddlePointBase!T mp, MiddlePointBase!T w )
        {
            w.frame.length.value = mp.frame.start.value - w.frame.start.value;
            middle_points.insertInPlace( middle_points.countUntil(w)+1, mp );
        }

    protected:
        /+ 型名を文字列へ +/
        @property string typeToString ()
        {
            static if ( is(T == int) )
                return "int";
            else static if ( is(T == float) )
                return "float";
            else static if ( is(T == string) )
                return "string";
            else throw new Exception( "The type is not supported." );
        }

    public:
        override @property Property copy ()
        {
            return new PropertyBase!T( this );
        }

        override @property FrameLength   frame        () { return frame_len;     }
                 @property T             endValue     () { return end_value;     }

        override @property MiddlePoint[] middlePoints () {
            MiddlePoint[] result;
            foreach ( mp; middle_points ) result ~= mp;
            return result;
        }

        override @property float maxFloat ()
        {
            static if ( isNumeric!T )
                return MaximumValue;
            else throw new Exception( "The property isn't increasable." );
        }
        override @property float minFloat ()
        {
            static if ( isNumeric!T )
                return MinimumValue;
            else throw new Exception( "The property isn't increasable." );
        }

        this ( PropertyBase!T src )
        {
            frame_len = new FrameLength( src.frame );
            foreach ( mp; src.middle_points )
                middle_points ~= new MiddlePointBase!T( mp );
            end_value = src.endValue;
        }

        this ( FrameLength f, T v )
        {
            frame_len = f;
            middle_points ~= new MiddlePointBase!T( v,
                    new FramePeriod( f, new FrameAt(0), new FrameLength(f.value) ) );
            end_value = v;
        }

        /+ 中間点JSON配列から作成 +/
        this ( JSONValue[] mps, FrameLength f, T v )
        {
            frame_len = f;
            mps.each!( x =>
                        middle_points ~= cast(MiddlePointBase!T)
                            MiddlePoint.create( typeToString, x, f )
                     );
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
                    auto flength = new FrameLength( nextFrame(mp).value - f.value - 1 );
                    auto fperiod = new FramePeriod( frame, f, flength );

                    auto mp_new = new MiddlePointBase!T( v, fperiod );
                    static if ( isNumeric!T ) mp_new.easing = mp.easing;
                    insertMiddlePoint( mp_new, cast(MiddlePointBase!T)mp );
                }
            }
        }

        override void setString ( FrameAt f, string v )
        {
            set( f, v.to!T );
        }

        override void setFloat ( FrameAt f, float v )
        {
            static if ( isNumeric!T )
                set( f, v.to!T );
            else throw new Exception( "The property isn't increasable." );
        }

        /+ 元の型でプロパティを取得 +/
        T get ( FrameAt f )
        {
            if ( f.value == frame.value - 1 ) return endValue;

            auto mp = middlePointAtFrame(f);
            auto st = (cast(MiddlePointBase!T)mp).value;

            static if ( !isNumeric!T ) return st;
            else {
                auto easing_type = mp.easing;
                if ( easing_type == EasingType.None ) return st;

                auto ed = nextValue(mp);
                auto easing = EasingFunction.create( easing_type, st.to!float, ed.to!float,
                        mp.frame.length );
                return easing.at( new FrameAt( f.value - mp.frame.start.value ) ).to!T;
            }
        }

        override string getString ( FrameAt f )
        {
            return get( f ).to!string;
        }

        override float getFloat ( FrameAt f )
        {
            static if ( isNumeric!T )
                return get( f );
            else throw new Exception( "The property isn't increasable." );
        }

        override @property bool increasable ()
        {
            return isNumeric!T;
        }

        override @property bool allowMultiline ()
        {
            return isSomeString!T;
        }

        override @property JSONValue json ()
        {
            JSONValue j;
            j["frame"] = JSONValue( frame.value );
            static if ( isNumeric!T )
                j["value"] = JSONValue( endValue );
            else
                j["value"] = JSONValue( endValue.to!string );
            j["type"] = JSONValue( typeToString );

            JSONValue[] middle_points = [];
            middlePoints.each!( x => middle_points ~= x.json );
            j["middle_points"] = JSONValue( middle_points );
            return j;
        }

        debug ( 1 ) unittest {
            auto hoge = new PropertyBase!float( new FrameLength(50), 20 );
            assert( hoge.middlePoints.length == 1 );
            assert( hoge.middlePointAtFrame(new FrameAt(10)).frame.start.value == 0 );
            assert( hoge.nextValue(hoge.middlePoints[0]) == 20 );

            auto hoge2 = cast(PropertyBase!float)Property.create( hoge.json, hoge.frame );
            assert( hoge.middlePoints.length == hoge.middlePoints.length );
            assert( hoge.get(new FrameAt(5)) == hoge.get(new FrameAt(5)) );

            (cast(MiddlePointBase!float)hoge.middlePoints[0]).easing = EasingType.Linear;

            hoge.set( new FrameAt(25), 0 );
            assert( hoge.get( new FrameAt(5) ) == 16 ); // 20 to 0 with LinearEasing for 25 frames
            hoge.set( new FrameAt(25), 40 );
            assert( hoge.middlePoints.length == 2 );
            assert( hoge.get( new FrameAt(5) ) == 24 ); // 20 to 40 with LinearEasing for 25 frames
            hoge.set( new FrameAt(49), 60 );
            assert( hoge.middlePoints.length == 2 );
            assert( hoge.get( new FrameAt(30) ) == 44 ); // 40 to 60 with LinearEasing for 25 frames

            assert( hoge.increasable );
            assert( !hoge.allowMultiline );
        }
}
