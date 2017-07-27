/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.renderer.polygon.Polygon;
import cafe.renderer.graphics.Bitmap,
       cafe.renderer.polygon.Material,
       cafe.renderer.polygon.Vector,
       cafe.renderer.polygon.Vertex;

/+ ポリゴンのデータ +/
class Polygon
{
    private:
        BMP       tex;
        Material  mat;
        Vertex[4] verts;    // 左上から時計回りに指定
        /+ TODO エフェクト情報 +/

    public:
        @property texture  () { return tex; }
        @property vertexes () { return verts; }
        @property material () { return mat; }

        this ( BMP t, Vertex[4] v )
        {
            tex = t;
            verts = v;
        }
}
