/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.renderer.Camera;
import gl3n.linalg;

debug = 0;

/+ カメラクラス +/
class Camera
{
    private:
        vec3 pos;
        vec3 tarpos;
        // TODO : カメラの付加情報(深度ボケ等)

    public:
        @property position () { return pos; }
        @property targetPosition () { return tarpos; }

        this ( vec3 p = vec3(0,0,-1024), vec3 t = vec3(0,0,0) )
        {
            pos = p; tarpos = t;
        }

        debug (1) unittest {
            auto hoge = new Camera;
        }
}
