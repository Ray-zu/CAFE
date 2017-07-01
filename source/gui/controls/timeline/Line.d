/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.gui.controls.timeline.Line;
import cafe.project.timeline.PlaceableObject,
       cafe.project.timeline.property.Property;

/+ タイムラインのライン情報 +/
struct Line
{
    private:
        union Store
        {
            PlaceableObject[] objects;
            Property prop;
        }

        bool is_layer;  // true : Layer, false : property line
        Store store;

        string name;

    public:
        @property lineName () { return name; }

        this ( PlaceableObject[] objs, string n )
        {
            is_layer = true;
            store.objects = objs;
            name = n;
        }

        this ( Property prop, string n )
        {
            is_layer = false;
            store.prop = prop;
            name = n;
        }

        /+ オブジェクトレイヤかどうか +/
        @property isLayer ()
        {
            return is_layer;
        }

        /+ プロパティラインかどうか +/
        @property isPropertyLine ()
        {
            return !is_layer;
        }

        @property objects ()
        {
            if ( isLayer ) return store.objects;
            throw new Exception( "This line is not object layer." );
        }

        @property property ()
        {
            if ( isPropertyLine ) return store.prop;
            throw new Exception( "This line is not property line." );
        }
}
