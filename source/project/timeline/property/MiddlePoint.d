/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.project.timeline.property.MiddlePoint;
import cafe.json,
       cafe.project.ObjectPlacingInfo,
       cafe.project.timeline.property.Easing;
import std.conv,
       std.traits,
       std.json;

debug = 0;

/+ 中間点データのインターフェース +/
interface MiddlePoint
{
    enum DefaultEasing = "Linear";
    public:
        @property FramePeriod frame ();

        @property string easing ();
        @property void easing ( string );

        @property JSONValue json ();

        /+ JSONからMiddlePointを生成 +/
        static final MiddlePoint create ( string type, JSONValue j, FrameLength f )
        {
            auto value = j["value"];
            auto frame = new FramePeriod( j["frame"], f );
            auto easing = j["easing"].str;
            switch ( type )
            {
                case "int":
                    return new MiddlePointBase!int(
                            value.integer.to!int, frame, easing );
                case "float":
                    return new MiddlePointBase!float( value.getFloating, frame, easing );
                case "string":
                    return new MiddlePointBase!string( value.str, frame );
                case "bool":
                    return new MiddlePointBase!bool( value.type==JSON_TYPE.TRUE, frame );

                default: 
                    throw new Exception( "Undefined Type." );
            }
        }
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
            private string easing_func;
            override @property string easing ()           { return easing_func; }
            override @property void   easing ( string t ) { easing_func = t;    }
        } else {
            override @property string easing () { return DefaultEasing; }
            override @property void   easing ( string ) {
                throw new Exception( "This property is not increasable." );
            }
        }

        this ( MiddlePointBase!T src, FrameLength f )
        {
            value = src.value;
            frame_period = new FramePeriod( src.frame, f );
            static if ( isNumeric!T )
                easing_func = src.easing;
        }

        this ( T s, FramePeriod f, string e = DefaultEasing )
        {
            value = s;
            frame_period = f;
            static if ( isNumeric!T )
                easing_func = e;
        }

        override @property JSONValue json ()
        {
            JSONValue j;
            static if ( isNumeric!T )
                j["value"] = JSONValue(value);
            else
                j["value"] = JSONValue(value.to!string);
            j["frame"]  = JSONValue(frame.json);
            j["easing"] = JSONValue(easing);
            return j;
        }

        debug (1) unittest {
            auto frame = new FramePeriod( new FrameLength( 100 ), new FrameAt( 50 ), new FrameLength( 20 ) );
            auto hoge = new MiddlePointBase!string( "5000chouen hoshii", frame );
            assert( hoge.easing == DefaultEasing );
            assert( hoge.value == "5000chouen hoshii" );

            auto hoge2 = cast(MiddlePointBase!string)MiddlePoint.create( "string",
                    hoge.json, frame.parentLength );
            assert( hoge2.value == hoge.value );

            auto huge = new MiddlePointBase!float( 114.514, frame );
            huge.easing = "Linear";
            assert( huge.easing == "Linear" );
            assert( huge.value == 114.514f );
            huge.json;
        }
}
