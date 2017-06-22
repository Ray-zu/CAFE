/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.project.timeline.property.PropertyList;
import cafe.project.timeline.property.Property,
       cafe.project.ObjectPlacingInfo;
import std.exception;

debug = 0;

/+ プロパティの配列を管理するクラス +/
class PropertyList
{
    private:
        Property[string] props;

    public:
        @property properties () { return props; }

        this ( PropertyList src )
        {
            foreach ( key,val; src.properties )
                props[key] = val.copy;
        }

        this ()
        {
        }

        /+ key名のプロパティを指定された型のプロパティクラスにキャストされた状態で返す +/
        auto casted ( T ) ( string key )
        {
            return cast(PropertyBase!T)this[key];
        }

        /+ key名のプロパティを削除 +/
        void del ( string key )
        {
            if ( key !in props ) throw new Exception( "Property of the name is not exist." );
            props.remove( key );
        }

        /+ this[key] : key名のプロパティを返す +/
        Property opIndex ( string key )
        {
            return properties[key];
        }

        /+ this[key]=val : key名のプロパティxを追加 +/
        PropertyList opIndexAssign ( Property val, string key )
        {
            enforce( val, "Property must be not null." );
            enforce( key !in props, "Property name conflict." );
            props[key] = val;
            return this;
        }

        debug ( 1 ) unittest {
            auto hoge = new PropertyList;
            hoge["X"] = new PropertyBase!float( new FrameLength(50), 20 );
            assert( hoge.casted!float("X").get( new FrameAt(0) ) == 20 );
        }
}
