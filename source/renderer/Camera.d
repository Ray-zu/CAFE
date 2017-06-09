/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.renderer.Camera;
import cafe.renderer.polygon.Vector;

debug = 0;

/+ カメラクラス                  +
 + WorldクラスをBMPに変換します。+/
class Camera
{
    private:
        Vector3D pos;
        Vector3D tarpos;

    public:
        @property position () { return pos; }
        @property targetPosition () { return tarpos; }

        // TODO : コンストラクタ
}
