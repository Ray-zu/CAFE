/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.project.timeline.effect.EffectList;
import cafe.project.timeline.effect.Effect,
       cafe.renderer.World;
import std.algorithm;

debug = 0;

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

        debug (1) unittest {
            auto hoge = new EffectList;
        }
}
