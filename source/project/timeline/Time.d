/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.project.timeline.Time;
import std.conv;

/+ タイムライン上での時間の長さを表します +/
class TimeLength
{
    public:
        uint frame;
        alias frame this;

        this ( uint i )
        {
            frame = i;
        }

        unittest {
            auto t = new TimeLength( 5 );
            assert( cast(uint)t == 5 );
        }
}

/+ タイムライン上でのある1フレームを表します +/
class Time
{
    private:
        TimeLength total;
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

        this ( TimeLength t, uint i )
        {
            total = t;
            frame = i;
        }
}
