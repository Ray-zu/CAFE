/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.project.timeline.effect.EffectList;
import cafe.project.timeline.effect.Effect,
       cafe.project.ObjectPlacingInfo,
       cafe.project.RenderingInfo,
       cafe.renderer.World;
import std.algorithm,
       std.exception,
       std.json;

debug = 0;

/+ 複数のエフェクトを管理するクラス +/
class EffectList
{
    private:
        Effect[] effs;

    public:
        @property effects () { return effs; }

        this ( EffectList src, FrameLength f )
        {
            src.effects.each!( x => effs ~= x.copy(f) );
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

        void remove ( Effect e )
        {
            effs = effects.remove!( x => x is e );
        }

        void swap ( Effect l, Effect r )
        {
            effects.swapAt( effects.countUntil(l), effects.countUntil(r) );
        }

        void up ( Effect e )
        {
            auto i = effects.countUntil( e );
            if ( i >= 0 && 0 <= i-1 )
                effects.swapAt( i, i-1 );
        }

        void down ( Effect e )
        {
            auto i = effects.countUntil( e );
            if ( i >= 0 && effects.length > i+1 )
                effects.swapAt( i, i+1 );
        }

        @property json ()
        {
            JSONValue[] j;
            effs.each!( x => j ~= JSONValue(x.json) );
            return JSONValue(j);
        }

        /+ WorldクラスにEffectをかける +/
        void apply ( RenderingInfo r, FrameAt f )
        {
            effects
                .filter!( x => x.enable )
                .each!( x => x.apply( r, f ) );
        }

        /+ this += v : エフェクト追加演算子 +/
        auto opAddAssign ( Effect v )
        {
            enforce( v, "Effect must be not null." );
            effs ~= v;
            return this;
        }

        debug (1) unittest {
            auto hoge = new EffectList;
            auto hoge2 = new EffectList( hoge.json, new FrameLength(50) );
            assert( hoge.effects.length == hoge2.effects.length );
        }
}
