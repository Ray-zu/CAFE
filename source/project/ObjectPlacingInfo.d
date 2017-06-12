/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.project.ObjectPlacingInfo;
import std.algorithm,
       std.conv;

debug = 0;

/+ ひとつの変数を持つプロパティクラスの雛形 +/
private class SingleValueProperty (T)
{
    private:
        T val;

    public:
        @property value ()      { return val; }
        @property value ( T f ) { val = f;    }

        this ( SingleValueProperty!T src )
        {
            value = src.value;
        }

        this ( T f )
        {
            value = f;
        }

        override @property string toString ()
        {
            return value.to!string;
        }
}

/+ フレーム数(長さ)                      +
 + 0から始まるフレーム総数を表現します。 +
 + 例:シーン全体の長さ                   +/
alias FrameLength = SingleValueProperty!uint;

/+ フレーム数(一点)             +
 + ある１フレームを表現します。 +
 + 例:再生中フレーム            +/
alias FrameAt = SingleValueProperty!uint;

/+ フレーム数(一点)              +
 + ある一フレームを表現します。  +
 + FrameLength情報も保存します。 +/
class FrameIn : FrameAt
{
    private:
        FrameLength parent_length;

    public:
        override @property uint value ()
        {
            if ( val >= parentLength.value )
                val = parentLength.value - 1;
            return val;
        }
        @property parentLength () { return parent_length; }

        this ( FrameIn src )
        {
            super( src );
            parent_length = new FrameLength( src.parentLength );
        }

        this ( FrameLength t, uint f )
        {
            parent_length = t;
            super( f );
        }

        debug (1) unittest {
            auto f = new FrameIn( new FrameLength(500), 100 );
            assert( f.value == 100 );
            assert( f.parentLength.value == 500 );
        }
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
            parent_length = new FrameLength( src.parentLength );
            start_frame = new FrameAt( src.start );
            frame_length = new FrameLength( src.length );
        }

        this ( FrameLength t, FrameAt s, FrameLength l )
        {
            parent_length = t;
            start_frame = s;
            frame_length = l;
        }

        bool isInRange ( FrameAt f )
        {
            return f.value >= start.value && f.value < end.value;
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
            length.value = start-fv;
        }

        /+ FrameAtをこのクラスを元にしたFrameInに変換 +/
        FrameIn relative ( FrameAt f )
        {
            return new FrameIn( length, f.value - start.value );
        }

        /+ FrameAtをparent_lengthを元にしたFrameInに変換 +/
        FrameIn absolute ( FrameAt f )
        {
            return new FrameIn( parent_length, f.value + start.value );
        }

        debug (1) unittest {
            auto f = new FramePeriod( new FrameLength(100), new FrameAt(50), new FrameLength(30) );
            assert( f.parentLength.value == 100 );
            assert( f.start.value == 50 );
            assert( f.end.value == 80 );
            assert( f.length.value == 30 );
            assert( !f.isInRange( new FrameAt(20) ) );
            assert(  f.isInRange( new FrameAt(60) ) );

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
alias LayerId = SingleValueProperty!uint;

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

        debug (1) unittest {
            auto p = new FramePeriod( new FrameLength( 100 ),
                    new FrameAt( 50 ), new FrameLength( 20 ) );
            auto i = new ObjectPlacingInfo( new LayerId( 5 ), p );
        }
}
