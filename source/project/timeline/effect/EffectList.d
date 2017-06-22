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

        /+ WorldクラスにEffectをかける +/
        World apply ( World w )
        {
            effects.each!( x => w = x.apply( w ) );
            return w;
        }

        /+ this += v : エフェクト追加演算子 +/
        auto opAddAssign ( Effect v )
        {
            enforce( v, "Effect must be not null." );
            effs ~= v;
            return this;
        }

        /+ this += v : エフェクトリスト結合演算子 +/
        auto opAddAssign ( EffectList v )
        {
            enforce( v, "EffectList must be not null." );
            effs = v.effects;
            return this;
        }

        debug (1) unittest {
            auto hoge = new EffectList;
            hoge += new EffectList;
        }
}
