/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.project.Frame;
import std.conv;

/+ フレーム数を表します +/
class FrameLength
{
    public:
        uint frame;
        alias frame this;

        this ( uint i )
        {
            frame = i;
        }

        unittest {
            auto t = new FrameLength( 5 );
            assert( cast(uint)t == 5 );
        }
}

/+ ある1フレームを表します +/
class FrameCount
{
    private:
        FrameLength total;
        uint frame;

    public:
        @property value () { return frame; }
        @property value ( uint f )
        {
            if ( cast(uint)total >= f ) frame = f;
            else throw new
                Exception( "The time is over than total." );
        }

        @property valueRatio ()
        {
            return value.to!float / (cast(uint)total).to!float;
        }

        @property hasTotal ()
        {
            return total !is null;
        }

        this ( uint i )
        {
            total = null;
            frame = i;
        }

        this ( FrameLength t, uint i )
        {
            total = t;
            frame = i;
        }

        unittest {
            auto hoge = new FrameCount( new FrameLength( 100 ), 50 );
            assert( hoge.value == 50 );
            assert( hoge.valueRatio == 0.5 );
            hoge.value = 75;
            assert( hoge.valueRatio == 0.75 );
        }
}
