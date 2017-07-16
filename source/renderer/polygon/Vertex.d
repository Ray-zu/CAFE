/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.renderer.polygon.Vertex;
import cafe.renderer.polygon.Vector;

/+ 頂点データ +/
struct Vertex
{
    public:
        Vector3D pos;
        Vector2D uv;

        this ( Vector3D p, Vector2D u )
        {
            pos = p;
            uv  = u;
        }
}
