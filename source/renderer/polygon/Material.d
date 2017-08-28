/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.renderer.polygon.Material;

debug = 0;

/+ マテリアルクラス +/
class Material
{
    private:
        MaterialProperty[string] props;

    public:
        @property properties () { return props; }

        this ( Material m )
        {
            props = m.properties;
        }

        this ()
        {
        }

        void set ( string id, MaterialProperty p )
        {
            props[id] = p;
        }

        void set (T) ( string id, T v )
        {
            set( id, MaterialProperty(v) );
        }

        /+ テンプレート引数にはデフォルトで返す値を指定          +
         + get!"hoge"( "osushi" ); // osushiが無ければhogeを返す +/
        auto get (alias T) ( string id )
        {
            if ( id in properties )
                return properties[id];
            else return MaterialProperty( T );
        }

        debug (1) unittest {
            auto hoge = new Material;
            hoge.set( "osushi", "tabetai" );
            assert( hoge.get!""( "osushi" ).str == "tabetai" );
            assert( hoge.get!1.0( "salmon" ).floating == 1.0 );
        }
}

/+ プロパティ用例外 +/
class IncompatibleTypeException : Exception
{
    this ( string file = __FILE__, uint line = __LINE__ )
    {
        super( "Incompatible Type", file, line );
    }
}

/+ プロパティ +/
struct MaterialProperty
{
    enum StoreType
    {
        Integer,
        Floating,
        String,
        Boolean
    }

    union Store
    {
        int    integer;
        float  floating;
        string str;
        bool   boolean;
    }

    private:
        StoreType store_type;
        Store     store;

    public:
        @property type () { return store_type; }

        this ( int i )
        {
            store_type = StoreType.Integer;
            store.integer = i;
        }

        this ( float f )
        {
            store_type = StoreType.Floating;
            store.floating = f;
        }

        this ( string v )
        {
            store_type = StoreType.String;
            store.str = v;
        }

        this ( bool b )
        {
            store_type = StoreType.Boolean;
            store.boolean = b;
        }

        @property integer ()
        {
            if ( type == StoreType.Integer )
                return store.integer;
            else throw new IncompatibleTypeException;
        }

        @property floating ()
        {
            if ( type == StoreType.Floating )
                return store.floating;
            else throw new IncompatibleTypeException;
        }

        @property str ()
        {
            if ( type == StoreType.String )
                return store.str;
            else throw new IncompatibleTypeException;
        }

        @property boolean ()
        {
            if ( type == StoreType.Boolean )
                return store.boolean;
            else throw new IncompatibleTypeException;
        }
}
