/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.renderer.Renderer;
import cafe.renderer.Camera,
       cafe.renderer.World,
       cafe.renderer.graphics.Bitmap;

/+ レンダラーインターフェース                      +
 + WorldクラスをCameraクラスを元にBMPに変換します。+/
interface Renderer
{
    public:
        BMP render ( World, Camera );
}
