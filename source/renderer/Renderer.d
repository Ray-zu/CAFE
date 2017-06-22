/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.renderer.Renderer;
import cafe.renderer.Camera,
       cafe.renderer.World,
       cafe.renderer.graphics.Bitmap,
       cafe.renderer.sound.PCM;

/+ レンダリングの結果 +/
class RenderingResult
{
    public:
        BMP bitmap;
        PCM pcm;

        this ( BMP b, PCM p )
        {
            bitmap = b;
            pcm = p;
        }
}


/+ レンダラーインターフェース                      +
 + WorldクラスをCameraクラスを元にBMPに変換します。+/
interface Renderer
{
    public:
        RenderingResult render ( World, Camera, uint, uint );
}
