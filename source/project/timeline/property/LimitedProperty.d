/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.project.timeline.property.LimitedProperty;
import cafe.project.timeline.property.Property,
       cafe.project.ObjectPlacingInfo;
import std.algorithm,
       std.conv,
       std.json,
       std.traits;

debug = 0;

/+ 値の範囲が制限されたプロパティ +/
class LimitedProperty (T) : PropertyBase!T
    if ( isNumeric!T )
{
    public:
        T max;
        T min;

        override @property Property copy ( FrameLength f )
        {
            return new LimitedProperty!T( this, f );
        }

        override @property float maxFloat () { return max.to!float; }
        override @property float minFloat () { return min.to!float; }

        this ( LimitedProperty!T src, FrameLength f )
        {
            super( src, f );
            max = src.max;
            min = src.min;
        }

        this ( FrameLength f, T v, T max, T min )
        {
            super( f, v );
            this.max = max;
            this.min = min;
        }

        this ( JSONValue[] j, FrameLength f, T v, T max, T min )
        {
            super( j, f, v );
            this.max = max;
            this.min = min;
        }

        override void set ( FrameAt f, T v )
        {
            super.set( f, std.algorithm.max( this.min, std.algorithm.min( v, this.max ) ) );
        }

        override T get ( FrameAt f )
        {
            return std.algorithm.max( this.min, std.algorithm.min( super.get(f), this.max ) );
        }

        override @property JSONValue json ()
        {
            auto j = super.json;
            j["max"] = JSONValue( max );
            j["min"] = JSONValue( min );
            j["type"].str = typeToString~"/LimitedProperty";
            return j;
        }

        debug (1) unittest {
            auto hoge = new LimitedProperty!int( new FrameLength(50), 0, 0, 10 );
            hoge.set( new FrameAt(0), 20 );
            assert( hoge.get( new FrameAt(0) ) == 10 );

            auto hoge2 = cast(LimitedProperty!int)Property.create( hoge.json, hoge.frame );
            assert( hoge2.get(new FrameAt(5)) == hoge.get(new FrameAt(5)) );
        }
}
