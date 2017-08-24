/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.renderer.sound.Sound;
import cafe.renderer.sound.PCM;
import gl3n.linalg;

/+ 音声データとその位置情報 +/
class Sound
{
    private:
        PCM pcm_data;
        vec3 pos;

    public:
        @property pcm () { return pcm_data; }
        @property position () { return pos; }

        this ( PCM pd, vec3 po )
        {
            pcm_data = pd;
            pos = po;
        }
}
