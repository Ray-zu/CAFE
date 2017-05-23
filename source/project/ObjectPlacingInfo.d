/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.project.ObjectPlacingInfo;
import std.conv;

private template SingleValueProperty (T)
{
    private:
        T val;

    public:
        @property value ()      { return val; }
        @property value ( T f ) { val = f;    }

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
class FrameLength
{
    mixin SingleValueProperty!uint;
    unittest {
        auto t = new FrameLength( 500 );
        assert( t.value == 500 );
    }
}

/+ フレーム数(一点)             +
 + ある１フレームを表現します。 +
 + 例:再生中フレーム            +/
 class FrameAt
{
    mixin SingleValueProperty!uint;
    unittest {
        auto f = new FrameAt( 120 );
        assert( f.value == 120 );
    }
}

/+ フレーム数(一点)              +
 + ある一フレームを表現します。  +
 + FrameLength情報も保存します。 +/
 class FrameIn : FrameAt
{
    private:
        FrameLength parent_length;

    public:
        @property uint value ()
        {
            if ( val >= parentLength.value )
                val = parentLength.value - 1;
            return val;
        }
        @property parentLength () { return parent_length; }

        this ( FrameLength t, uint f )
        {
            parent_length = t;
            super( f );
        }

        unittest {
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
            if ( endframe >= parentLength.value ) frame_length.value = 1;
            return frame_length;
        }

        this ( FrameLength t, FrameAt s, FrameLength l )
        {
            parent_length = t;
            start_frame = s;
            frame_length = l;
        }

        unittest {
            auto f = new FramePeriod( new FrameLength(100), new FrameAt(50), new FrameLength(30) );
            assert( f.parentLength.value == 100 );
            assert( f.start.value == 50 );
            assert( f.end.value == 80 );
            assert( f.length.value == 30 );
        }
}

/+ レイヤID +/
class LayerId
{
    mixin SingleValueProperty!uint;
    unittest {
        auto i = new LayerId( 5 );
        assert( i.value == 5 );
    }
}


/+ オブジェクトの配置情報(レイヤ数/開始・終了フレーム数) +/
class ObjectPlacingData
{
    private:
        LayerId layer_id;
        FramePeriod frame_period;

    public:
        @property layer () { return layer_id;     }
        @property frame () { return frame_period; }

        this ( LayerId l, FramePeriod f )
        {
            layer_id = l;
            frame_period = f;
        }

        unittest {
            auto p = new FramePeriod( new FrameLength( 100 ),
                    new FrameAt( 50 ), new FrameLength( 20 ) );
            auto i = new ObjectPlacingData( new LayerId( 5 ), p );
        }
}
