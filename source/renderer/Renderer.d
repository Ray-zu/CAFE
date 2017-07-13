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
       cafe.renderer.sound.PCM,
       cafe.renderer.sound.SoundList;

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
        PCM soundRender ( SoundList );
        BMP bmpRender   ( World, Camera, uint, uint );

        final RenderingResult render ( World w, Camera c, uint wi, uint he )
        {
            auto bmp = bmpRender( w, c, wi, he );
            auto pcm = soundRender( w.soundList );
            return new RenderingResult( bmp, pcm );
        }
}
