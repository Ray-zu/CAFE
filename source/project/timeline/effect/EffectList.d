/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.project.timeline.effect.EffectList;
import cafe.project.timeline.effect.Effect,
       cafe.project.ObjectPlacingInfo,
       cafe.renderer.World;
import std.algorithm,
       std.json;

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

        this ( JSONValue j, FrameLength f )
        {
            this();
            j.array.each!( x => effs ~= Effect.create( x, f ) );
        }

        @property json ()
        {
            JSONValue[] j;
            effs.each!( x => j ~= JSONValue(x.json) );
            return JSONValue(j);
        }

        /+ WorldクラスにEffectをかける +/
        World apply ( World w )
        {
            effects.each!( x => w = x.apply( w ) );
            return w;
        }

        debug (1) unittest {
            auto hoge = new EffectList;
            auto hoge2 = new EffectList( hoge.json, new FrameLength(50) );
            assert( hoge.effects.length == hoge2.effects.length );
        }
}
