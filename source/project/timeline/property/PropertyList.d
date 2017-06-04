/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.project.timeline.property.PropertyList;
import cafe.project.timeline.property.Property,
       cafe.project.ObjectPlacingInfo;

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

        void add ( string key, Property val )
        {
            if ( !val ) throw new Exception( "You can't add a null variable." );
            if ( key in props ) throw new Exception( "Property of the name is already exist." );
            props[key] = val;
        }

        auto casted ( T ) ( string key )
        {
            return cast(PropertyBase!T)properties[key];
        }

        void del ( string key )
        {
            if ( key !in props ) throw new Exception( "Property of the name is not exist." );
            props.remove( key );
        }

        Property opIndex ( string key )
        {
            return properties[key];
        }

        PropertyList opIndexAssign ( Property val, string key )
        {
            add( key, val );
            return this;
        }

        debug ( 1 ) unittest {
            auto hoge = new PropertyList;
            hoge["X"] = new PropertyBase!float( new FrameLength(50), 20 );
            assert( hoge.casted!float("X").get( new FrameAt(0) ) == 20 );
        }
}
