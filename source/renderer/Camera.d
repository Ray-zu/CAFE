/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.renderer.Camera;
import cafe.renderer.polygon.Vector;

debug = 0;

/+ カメラクラス +/
class Camera
{
    private:
        Vector3D pos;
        Vector3D tarpos;
        // TODO : カメラの付加情報(深度ボケ等)

    public:
        @property position () { return pos; }
        @property targetPosition () { return tarpos; }

        // TODO : コンストラクタ
}
