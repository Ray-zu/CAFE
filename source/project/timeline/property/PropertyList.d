/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.project.timeline.property.PropertyList;
import cafe.project.timeline.property.Property,
       cafe.project.ObjectPlacingInfo;
import std.json;

debug = 1;

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

        /+ key名のプロパティを追加 +/
        void add ( string key, Property val )
        {
            if ( !val ) throw new Exception( "You can't add a null variable." );
            if ( key in props ) throw new Exception( "Property of the name is already exist." );
            props[key] = val;
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

        /+ this[key]でkey名のプロパティを返す +/
        Property opIndex ( string key )
        {
            return properties[key];
        }

        /+ this[key]=xでkey名のプロパティxを追加 +/
        PropertyList opIndexAssign ( Property val, string key )
        {
            add( key, val );
            return this;
        }

        /+ JSONで出力 +/
        @property json ()
        {
             JSONValue j = JSONValue( null );
             foreach( key,val; properties )
                 j[key] = JSONValue( val.json );
             return j;
        }

        debug ( 1 ) unittest {
            auto hoge = new PropertyList;
            hoge["X"] = new PropertyBase!float( new FrameLength(50), 20 );
            assert( hoge.casted!float("X").get( new FrameAt(0) ) == 20 );
            import std.stdio; hoge.json.writeln;
        }
}
