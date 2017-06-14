/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.project.RenderingInfo;
import cafe.renderer.World,
       cafe.renderer.Camera;

debug = 0;

/+ レンダリング時に必要な情報をまとめたクラス +/
class RenderingInfo
{
    public:
        /+ プロパティと同じように扱うので同じような命名規則にする +/
        World effectStage;     // 通常のエフェクトの対象となるWorldクラス
        World renderingStage;  // レンダリングの対象となるWorldクラス
        // TODO : 将来的に追加予定のスクリプトのグローバル変数など

        this ()
        {
            effectStage = new World;
            renderingStage = new World;
        }

        /+ エフェクトステージの内容を破棄 +/
        void discardEffectStage ()
        {
            effectStage = new World;
        }

        /+ エフェクトステージの内容をレンダリングステージへ +/
        void pushEffectStage ()
        {
            renderingStage += effectStage;
            discardEffectStage;
        }

        debug (1) unittest {
            auto hoge = new RenderingInfo;
        }
}
