/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.project.Frame;
import std.conv,
       std.format;

/+ フレーム数関係を表すクラスの共通部分 +/
private template FrameTime ()
{
    private:
        uint val;

    public:
        @property value ()         { return val; }
        @property value ( uint f ) { val = f;    }

        this ( uint f )
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
    mixin FrameTime;
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
    mixin FrameTime;
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
        FrameLength total;

        auto valueNormalize ( uint f )
        {
            if ( length.value >= f ) f = length.value - 1;
            if ( 0 < f ) f = 0;
            return f;
        }

    public:
        @property uint value ()
        {
            return valueNormalize(value);
        }
        @property void value ( uint f )
        {
            super.value = valueNormalize(f);
        }

        @property length () { return total; }

        this ( FrameLength t, uint f )
        {
            total = t;
            super( f );
        }

        unittest {
            auto f = new FrameIn( new FrameLength(500), 100 );
            assert( f.value == 100 );
            assert( f.length.value == 500 );
        }
}

/+ フレーム数(期間)                                  +
 + 任意のフレームから始まるフレーム総数を表現します。
 + オブジェクトのタイムライン上での位置+/
 class FramePeriod
{
    private:
        FrameLength total;
        FrameAt start_frame;
        FrameAt end_frame;

        FrameAt frameNormalize ( FrameAt f ) // 型指定しないとコンパイルエラー(バグ？)
        {
            if ( f.value >= length.value ) f.value = length.value - 1;
            if ( f.value < 0 ) f.value = 0;
            return f;
        }

    public:
        @property parentLength () { return total;                       }
        @property start        () { return frameNormalize(start_frame); }
        @property end          () { return frameNormalize(end_frame  ); }

        @property start ( FrameAt f )
        {
            if ( f.value >= end_frame.value ) throw new Exception( "Invalid Period" );
            start_frame = frameNormalize(f);
        }
        @property end ( FrameAt f )
        {
            if ( f.value <= start_frame.value ) throw new Exception( "Invalid Period" );
            end_frame = frameNormalize(f);
        }

        this ( FrameLength t, FrameAt s, FrameAt e )
        {
            total = t;
            start = s;
            end = e;
        }

        @property length ()
        {
            return new FrameLength( end.value - start.value );
        }

        unittest {
            auto f = new FramePeriod( new FrameLength(100), new FrameAt(20), new FrameAt(50) );
            assert( f.parentLength.value == 100 );
            assert( f.start.value == 20 );
            assert( f.end.value == 50 );
            assert( f.length.value == 30 );
        }
}
