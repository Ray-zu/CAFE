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
import std.algorithm;

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


/+ レンダラ                                        +
 + WorldクラスをCameraクラスを元にBMPに変換します。+/
abstract class Renderer
{
    public:
        @property string nameStr ();

        PCM soundRender ( SoundList );
        BMP bmpRender   ( World, Camera, uint, uint );

        final RenderingResult render ( World w, Camera c, uint wi, uint he )
        {
            auto bmp = bmpRender( w, c, wi, he );
            auto pcm = soundRender( w.soundList );
            return new RenderingResult( bmp, pcm );
        }

        /+ 登録情報 +/
        struct RegisteredRenderer
        {
            string name;
            Renderer delegate () create;
        }
        static RegisteredRenderer[] registeredRenderers;

        template register (T)
        {
            static this ()
            {
                RegisteredRenderer r;
                r.name = T.name;
                r.create = delegate ()
                {
                    return new T;
                };
                registeredRenderers ~= r;
            }
        }

        static final create ( string name )
        {
            auto i = registeredRenderers.countUntil!
                ( x => x.name == name );
            if ( i == -1 ) throw new Exception( "Unregistered Renderer" );
            return registeredRenderers[i].create();
        }
}
