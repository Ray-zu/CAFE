/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.project.ComponentList;
import cafe.project.Component;
import std.algorithm;

debug = 0;

/+ コンポーネントのID型 +/
alias ComponentID = string;

/+ コンポーネントのリスト +/
class ComponentList
{
    private:
        Component[ComponentID] comps;

    public:
        @property components () { return comps; }

        this ()
        {
            comps["ROOT"] = new Component;
        }

        /+ コンポーネントの追加 +/
        void add ( Component c, ComponentID i )
        {
            if ( i in components )  // 間違って上書きしないように
                throw new Exception( "The component has already existed." );
            comps[i] = c;
        }

        /+ コンポーネントの削除 +/
        void remove ( Component c )
        {
            comps.remove( components.keys[
                    components.values.countUntil!"a is b"( c )] );
        }

        /+ コンポーネントの削除 +/
        void remove ( ComponentID i )
        {
            if ( i !in components ) // assoc.removeは例外を返さないのであらかじめの例外処理
                throw new Exception( "The component was not found." );
            comps.remove( i );
        }

        /+ this[i]; コンポーネントの参照 +/
        auto opIndex ( ComponentID i )
        {
            return components[i];
        }

        /+ this[i] = c; コンポーネントの追加 +/
        auto opIndexAssign ( Component c, ComponentID i )
        {
            add( c, i );
            return c;
        }

        debug (1) unittest {
            auto hoge = new ComponentList;
        }
}
