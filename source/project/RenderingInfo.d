/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.project.RenderingInfo;
import cafe.renderer.World,
       cafe.renderer.Camera;

debug = 1;

/+ レンダリング時に必要な情報をまとめたクラス +/
class RenderingInfo
{
    private:
        World effect_stage;     // 通常のエフェクトの対象となるWorldクラス
        World rendering_stage;  // レンダリングの対象となるWorldクラス
        // TODO : 将来的に追加予定のスクリプトのグローバル変数など

    public:
        @property effectStage    () { return effect_stage;    }
        @property renderingStage () { return rendering_stage; }

        this ()
        {
            effect_stage = new World;
            rendering_stage = new World;
        }

        void discardEffectStage ()
        {
            effect_stage = new World;
        }

        void pushEffectStage ()
        {
            rendering_stage += effect_stage;
            discardEffectStage;
        }

        debug (1) unittest {
            auto hoge = new RenderingInfo;
        }
}
