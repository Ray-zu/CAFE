/+ ------------------------------------------------------------ +
 + Author : SEED264                                             +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.renderer.polygon.PolygonData;
import gl3n.linalg,
       gl3n.math;

struct Transform
{
    private:
        vec3 Translate;
        vec3 Rotate;
        vec3 Scale;
    public:
        @property mat()
        {
            mat4 tm = mat4.identity;
            tm.scale(Scale.x, Scale.y, Scale.z);
            tm.rotate(radians(Rotate.z), vec3( 0.0, 0.0, 1.0));
            tm.rotate(radians(Rotate.y), vec3( 0.0, 1.0, 0.0));
            tm.rotate(radians(Rotate.x), vec3(-1.0, 0.0, 0.0));
            tm.translate(Translate);
            return tm;
        }

        this( vec3 t, vec3 r, vec3 s )
        {
            Translate = t;
            Rotate = r;
            Scale = s;
        }
        this() {}
}