/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.project.ComponentList;
import cafe.project.Component;
import std.algorithm,
       std.conv,
       std.exception,
       std.json;

debug = 1;

/+ コンポーネントのID型 +/
alias ComponentID = string;

/+ コンポーネントのリスト +/
class ComponentList
{
    private:
        Component[ComponentID] comps;

    public:
        @property components () { return comps; }

        this ( ComponentList src )
        {
            foreach ( key,val; src.components )
                comps[key] = new Component(val);
        }

        this ()
        {
            comps["ROOT"] = new Component;
        }

        this ( JSONValue j )
        {
            foreach ( string key,val; j )
                comps[key] = new Component( val );
        }

        /+ ルートコンポーネントを返す +/
        @property root ()
        {
            return this["ROOT"];
        }

        /+ コンポーネントの削除(参照から) +/
        void del ( Component c )
        {
            comps.remove( components.keys[
                    components.values.countUntil!"a is b"( c )] );
        }

        /+ コンポーネントの削除(IDから) +/
        void del ( ComponentID i )
        {
            enforce( i in components, "The component was not found." );
            comps.remove( i );
        }

        /+ this[i] : コンポーネントの参照 +/
        auto opIndex ( ComponentID i )
        {
            return components[i];
        }

        /+ this[i] = c : コンポーネントの追加 +/
        auto opIndexAssign ( Component c, ComponentID i )
        {
            enforce( i !in components, "Component name conflict." );
            comps[i] = c;
            return this;
        }

        /+ JSON出力 +/
        @property json ()
        {
            JSONValue j;
            foreach ( key,val; components )
                j[key] = JSONValue(val.json);
            return j;
        }

        debug (1) unittest {
            auto hoge = new ComponentList;
            auto hoge2 = new ComponentList( hoge.json );
            assert( hoge.json.to!string == hoge2.json.to!string );
        }
}
