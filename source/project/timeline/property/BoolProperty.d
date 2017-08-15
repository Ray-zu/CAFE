/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.project.timeline.property.BoolProperty;
import cafe.project.timeline.property.Property,
       cafe.project.ObjectPlacingInfo;
import std.algorithm,
       std.conv,
       std.exception,
       std.json,
       std.string;

debug = 0;

/+ Bool型のプロパティ +/
class BoolProperty : PropertyBase!bool
{
    public:
        override @property string typeToString ()
        {
            return "bool";
        }

        override @property Property copy ( FrameLength f )
        {
            return new BoolProperty( this, f );
        }

        this ( BoolProperty src, FrameLength f )
        {
            super( src, f );
        }

        this ( FrameLength f, bool v )
        {
            super( f, v );
        }

        this ( JSONValue[] j, FrameLength f, bool v )
        {
            super( j, f, v );
        }

        override void setString ( FrameAt f, string v )
        {
            if ( v.toLower != "true" ) v = "false";
            super.setString( f, v );
        }

        debug (1) unittest {
            auto hoge = new BoolProperty( new FrameLength(5), true );
            auto hoge2 = Property.create( hoge.json, hoge.frame );
            assert( hoge.json.to!string == hoge2.json.to!string );
        }
}
