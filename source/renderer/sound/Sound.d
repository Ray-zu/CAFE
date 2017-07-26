/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.renderer.sound.Sound;
import cafe.renderer.sound.PCM,
       cafe.renderer.polygon.Vector;

/+ 音声データとその位置情報 +/
class Sound
{
    private:
        PCM pcm_data;
        Vector3D pos;

    public:
        @property pcm () { return pcm_data; }
        @property position () { return pos; }

        this ( PCM pd, Vector3D po = Vector3D(0,0,0) )
        {
            pcm_data = pd;
            pos = po;
        }
}
