/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 +          SEED264                                             +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.renderer.polygon.Vertex;
import cafe.renderer.polygon.Vector;
import gl3n.linalg,
       gl3n.math;

/+ 頂点データ +/
struct Vertex
{
    public:
        vec3 pos;
        vec2 uv;

        this ( vec3 p, vec2 u )
        {
            pos = p;
            uv  = u;
        }
}
