/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.renderer.polygon.World;
import cafe.renderer.polygon.Polygon,
       cafe.renderer.polygon.Vector,
       cafe.renderer.graphics.Bitmap;

debug = 1;

/+ ポリゴンのリスト +/
class World
{
    private:
        Polygon[] polies;

    public:
        @property polygons () { return polies; }

        this ( Polygon[] p )
        {
            polies = p;
        }

        // TODO : ポリゴン配列の追加演算子オーバーロード

        debug (1) unittest {
            auto v3d = Vector3D( 0, 0, 0 );
            auto hoge = new World ( [new Polygon( new BMP(5,5), v3d,v3d,v3d,v3d )] );
        }
}
