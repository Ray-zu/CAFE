/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.gui.controls.timeline.Line;
import cafe.project.timeline.PlaceableObject,
       cafe.project.timeline.property.Property,
       cafe.project.timeline.effect.Effect;

/+ タイムラインのライン情報 +/
struct Line
{
    enum LayerLine    = 0;
    enum PropertyLine = 1;
    enum EffectLine   = 2;

    private:
        union Store
        {
            PlaceableObject[] objects;
            Property prop;
            Effect eff;
        }

        byte  kind;
        Store store;

        string name;

    public:
        uint  index;    //ラインインデックス
        float height;   // 標準サイズの何倍か

        @property lineName () { return name; }
        @property lineKind () { return kind; }

        this ( uint i, PlaceableObject[] objs, string n, float h = 1 )
        {
            kind = Layer;
            store.objects = objs;
            name = n;
            index = i;
            height = h;
        }

        this ( uint i, Property prop, string n, float h = 1 )
        {
            kind = Property;
            store.prop = prop;
            name = n;
            index = i;
            height = h;
        }

        this ( uint i, Effect eff, string n, float h = 1 )
        {
            kind = Effect;
            store.eff = eff;
            name = n;
            index = i;
            height = h;
        }

        @property objects ()
        {
            if ( lineKind == Layer ) return store.objects;
            throw new Exception( "This line is not object layer." );
        }

        @property property ()
        {
            if ( lineKind == Property ) return store.prop;
            throw new Exception( "This line is not property line." );
        }

        @property effect ()
        {
            if ( lineKind == Effect ) return store.eff;
            throw new Exception( "This line is not effect line." );
        }
}
