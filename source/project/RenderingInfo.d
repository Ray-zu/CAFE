/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.project.RenderingInfo;
import cafe.project.ObjectPlacingInfo,
       cafe.renderer.World,
       cafe.renderer.Camera;

debug = 0;

/+ レンダリング時に必要な情報をまとめたクラス +/
class RenderingInfo
{
    private:
        /+ Read Only プロパティ +/
        uint    size_width, size_height;  // レンダラに渡す画像サイズ

    public:
        /+ プロパティと同じように扱うので同じような命名規則にする +/
        World   effectStage;    // 通常のエフェクトの対象となるWorldクラス
        World   renderingStage; // レンダリングの対象となるWorldクラス
        Camera  camera;         // コンポーネントのカメラ
        FrameAt frame;          // レンダリング中のフレーム
        // TODO : 将来的に追加予定のスクリプトのグローバル変数など

        /+ Read Only プロパティのゲッター +/
        @property width  () { return size_width; }
        @property height () { return size_height; }

        this ( FrameAt f, uint w, uint h )
        {
            effectStage = new World;
            renderingStage = new World;
            camera = new Camera;
            frame = f;
            size_width = w;
            size_height = h;
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
            auto hoge = new RenderingInfo( new FrameAt(0), 1920, 1080, 30 );
        }
}
