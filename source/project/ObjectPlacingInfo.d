/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.project.ObjectPlacingInfo;
import std.algorithm,
       std.conv,
       std.exception,
       std.json;

debug = 0;

/+ ひとつの変数を持つプロパティクラスの雛形 +/
private template UIntSingleValueProperty (N)
{
    private:
        uint val;

    public:
        @property value ()      { return val; }
        @property value ( uint f ) { val = f;    }

        this ( N src )
        {
            value = src.value;
        }

        this ( int f )
        {
            value = max( min( f, uint.max ), uint.min );
        }

        override @property string toString ()
        {
            return value.to!string;
        }
}

/+ フレーム数(長さ)                      +
 + 0から始まるフレーム総数を表現します。 +
 + 例:シーン全体の長さ                   +/
class FrameLength {
    mixin UIntSingleValueProperty!FrameLength;
}

/+ フレーム数(一点)             +
 + ある１フレームを表現します。 +
 + 例:再生中フレーム            +/
class FrameAt {
    mixin UIntSingleValueProperty!FrameAt;
}

/+ フレーム数(期間)                                   +
 + 任意のフレームから始まるフレーム総数を表現します。 +
 + 例:オブジェクトのタイムライン上での位置と大きさ    +/
class FramePeriod
{
    private:
        FrameLength parent_length;
        FrameAt     start_frame;
        FrameLength frame_length;

    public:
        @property parentLength () { return parent_length; }

        @property start ()
        {
            if ( start_frame.value >= parent_length.value )
                start_frame.value = parent_length.value - 1;
            return start_frame;
        }

        @property end ()
        {
            return new FrameAt( start.value + length.value );
        }

        @property length ()
        {
            auto endframe = start.value + frame_length.value;
            if ( endframe > parentLength.value ) frame_length.value = 1;
            return frame_length;
        }

        this ( FramePeriod src )
        {
            parent_length = src.parentLength;
            start_frame = new FrameAt( src.start );
            frame_length = new FrameLength( src.length );
        }

        this ( FrameLength t, FrameAt s, FrameLength l )
        {
            parent_length = t;
            start_frame = s;
            frame_length = l;
        }

        this ( JSONValue j, FrameLength p )
        {
            start_frame  = new FrameAt    ( j["start"] .uinteger.to!uint );
            frame_length = new FrameLength( j["length"].uinteger.to!uint );
            parent_length = p;
        }

        /+ フレームfが期間内かどうか返す +/
        bool isInRange ( FrameAt f )
        {
            return f.value >= start.value && f.value < end.value;
        }

        /+ フレーム期間fが期間内かどうか返す +/
        bool isWhileRange ( FramePeriod f )
        {
            auto f_st = f.start.value;
            auto f_ed = f.end.value;
            return ( f_st >= start.value && f_st < end.value ) ||
                   ( f_ed < end.value && f_ed > start.value );
        }

        /+ 長さを保ったまま開始地点を移動 +/
        void move ( FrameAt f )
        {
            start.value = f.value;
        }

        /+ 終了地点を固定したまま開始地点を移動 +/
        void resizeStart ( FrameAt f )
        {
            auto end = end.value;
            auto fv = min( f.value, end-1 );
            length.value = end-fv;
            start.value = fv;
        }

        /+ 開始地点を固定したまま終了地点を移動 +/
        void resizeEnd ( FrameAt f )
        {
            auto start = start.value;
            auto fv = max( f.value, start+1 );
            length.value = fv-start;
        }

        /+ FrameAtをこのクラスを元にしたFrameAtに変換 +/
        auto relative ( FrameAt f )
        {
            return new FrameAt( f.value - start.value );
        }

        /+ FrameAtをparent_lengthを元にしたFrameAtに変換 +/
        auto absolute ( FrameAt f )
        {
            return new FrameAt( f.value + start.value );
        }

        /+ 期間内のFrameAtの割合を返す +/
        auto ratio ( FrameAt f, bool over = false )
        {
            enforce( isInRange(f) || over, "The frame is over period." );
            return (f.value-start.value).to!float / length.value;
        }

        /+ JSONで保存 +/
        @property json ()
        {
            auto j = `{}`.parseJSON;
            j["start"]  = JSONValue(start.value);
            j["length"] = JSONValue(length.value);
            return j;
        }

        debug (1) unittest {
            auto f = new FramePeriod( new FrameLength(100), new FrameAt(50), new FrameLength(30) );
            assert( f.parentLength.value == 100 );
            assert( f.start.value == 50 );
            assert( f.end.value == 80 );
            assert( f.length.value == 30 );
            assert( !f.isInRange( new FrameAt(20) ) );
            assert(  f.isInRange( new FrameAt(60) ) );
            assert(  f.ratio( new FrameAt(65) ) == 0.5 );

            auto f2 = new FramePeriod( f.json, f.parentLength );
            assert( f2.length.value == 30 );

            f.move( new FrameAt(0) );
            assert( f.start.value == 0 );
            assert( f.end.value == 30 );
            assert( f.length.value == 30 );

            f.resizeStart( new FrameAt(40) );
            assert( f.start.value == 29 );
            assert( f.end.value == 30 );
            assert( f.length.value == 1 );
        }
}

/+ レイヤID +/
class LayerId {
    mixin UIntSingleValueProperty!LayerId;
}

/+ オブジェクトの配置情報(レイヤ数/開始・終了フレーム数) +/
class ObjectPlacingInfo
{
    private:
        LayerId layer_id;
        FramePeriod frame_period;

    public:
        @property layer () { return layer_id;     }
        @property frame () { return frame_period; }

        this ( ObjectPlacingInfo src )
        {
            layer_id = new LayerId( src.layer );
            frame_period = new FramePeriod( src.frame );
        }

        this ( LayerId l, FramePeriod f )
        {
            layer_id = l;
            frame_period = f;
        }

        this ( JSONValue j, FrameLength f )
        {
            layer_id     = new LayerId( j["layer"].uinteger.to!uint );
            frame_period = new FramePeriod( j["frame"], f );
        }

        @property json ()
        {
            JSONValue j;
            j["layer"] = JSONValue(layer.value);
            j["frame"] = JSONValue(frame.json);
            return j;
        }

        debug (1) unittest {
            auto p = new FramePeriod( new FrameLength( 100 ),
                    new FrameAt( 50 ), new FrameLength( 20 ) );
            auto i = new ObjectPlacingInfo( new LayerId( 5 ), p );
            auto i2 = new ObjectPlacingInfo( i.json, p.parentLength );
        }
}
