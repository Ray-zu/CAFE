/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.renderer.polygon.Polygon;
import cafe.renderer.graphics.Bitmap;

debug = 1;

/+ ポリゴンのデータ +/
class Polygon
{
    private:
        BMP bmp;
        Vector3D top_l,
                 top_r,
                 bottom_r,
                 bottom_l;
        // TODO : ポリゴンエフェクトリスト

    public:
        @property bitmap () { return bmp; }

        @property topLeft     () { return top_l;    }
        @property topRight    () { return top_r;    }
        @property bottomRight () { return bottom_r; }
        @property bottomLeft  () { return bottom_l; }

        /+ 座標は左上を始点に時計回りに指定します +/
        this ( BMP b, Vector3D tl, Vector3D tr, Vector3D br, Vector3D bl )
        {
            bmp = b;
            top_l = tl; top_r = tr;
            bottom_r = br; bottom_l = bl;
        }
}
