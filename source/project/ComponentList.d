/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.project.ComponentList;
import cafe.json,
       cafe.project.Component;
import std.algorithm,
       std.conv,
       std.exception,
       std.json;

debug = 0;

/+ コンポーネントのID型 +/
alias ComponentID = string;

/+ コンポーネントのリスト +/
class ComponentList
{
    enum RootId = "ROOT";
    private:
        Component[ComponentID] comps;

    public:
        /+ 編集情報 +/
        Component selecting = null; // 選択中のコンポーネント
        Component locked    = null; // 強制的にレンダリングされるコンポーネント

        @property components () { return comps; }

        this ( ComponentList src )
        {
            foreach ( key,val; src.components )
                comps[key] = new Component(val);
        }

        this ()
        {
            comps[RootId] = new Component;
        }

        this ( JSONValue j )
        {
            auto list = j["list"];
            foreach ( string key,val; list )
                comps[key] = new Component( val );

            auto locked_name = j["locked"].str;
            locked = locked_name == "" ? null : this[locked_name];
        }

        /+ ルートコンポーネントを返す +/
        @property root ()
        {
            return this[RootId];
        }

        /+ レンダリングするコンポーネントを返す +/
        @property renderTarget ( bool encoding = false )
        {
            if ( encoding ) return root;
            return locked ? locked : ( selecting ? selecting : root );
        }

        /+ コンポーネントの削除(参照から) +/
        void del ( Component c )
        {
            if ( c is root ) return;
            comps.remove( components.keys[
                    components.values.countUntil!"a is b"( c )] );
        }

        /+ コンポーネントの削除(IDから) +/
        void del ( ComponentID i )
        {
            if ( i == "ROOT" ) return;
            enforce( i in components, "The component was not found." );
            comps.remove( i );
        }

        /+ コンポーネントのリネーム +/
        void rename ( ComponentID from, ComponentID to )
        {
            if ( from == RootId || to == RootId ) return;
            this[to] = this[from];
            del( from );
        }

        /+ this[i] : コンポーネントの参照 +/
        auto opIndex ( ComponentID i )
        {
            return components[i];
        }

        /+ this[c] : コンポーネントの名前 +/
        auto opIndex ( Component c )
        {
            auto id = components.values.countUntil!( x => x is c );
            return id == -1 ? "" : components.keys[id];
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

            JSONValue list;
            foreach ( key,val; components )
                list[key] = JSONValue(val.json);

            j["list"  ] = list;
            j["locked"] = this[locked];
            return j;
        }

        debug (1) unittest {
            auto hoge = new ComponentList;
            auto hoge2 = new ComponentList( hoge.json );
            assert( hoge.json.to!string == hoge2.json.to!string );
        }
}
