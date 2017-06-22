/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.project.timeline.effect.EffectList;
import cafe.project.timeline.effect.Effect,
       cafe.renderer.World;
import std.algorithm,
       std.exception;

debug = 1;

/+ 複数のエフェクトを管理するクラス +/
class EffectList
{
    private:
        Effect[] effs;

    public:
        @property effects () { return effs; }

        this ( EffectList src )
        {
            src.effects.each!( x => effs ~= x.copy );
        }

        this ()
        {
            effs = [];
        }

        /+ エフェクト追加 +/
        void add ( Effect e )
        {
            enforce( e, "Effect must be not null." );
            effs ~= e;
        }

        /+ WorldクラスにEffectをかける +/
        World apply ( World w )
        {
            effects.each!( x => w = x.apply( w ) );
            return w;
        }

        /+ this += v : エフェクト追加演算子 +/
        auto opAddAssign ( Effect v )
        {
            add( v );
            return this;
        }

        debug (1) unittest {
            auto hoge = new EffectList;
            hoge += new EffectList;
        }
}
