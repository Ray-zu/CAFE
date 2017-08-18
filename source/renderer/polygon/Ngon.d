/+ ------------------------------------------------------------ +
 + Author : SEED264                                             +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.renderer.polygon.Ngon;
import cafe.renderer.graphics.Bitmap,
       cafe.renderer.polygon.Material,
       cafe.renderer.polygon.Polygon;
import derelict.opengl3.gl3;
import gl3n.linalg,
       gl3n.math;

/* 多角形用のラッパークラス */
class Ngon : Polygon
{
    public:
    this ( uint Polynum, float Size, BMP Tex )
    {
        Polynum = max(Polynum, 3);
        vec3[] vertpos = new vec3[Polynum+1];
        uint[] index = new uint[Polynum+2];
        vec2[] uvpos = new vec2[Polynum+2];

            vertpos[0] = vec3(0.0, 0.0, 0.0);
            vertpos[1] = vec3(0.0, Size, 0.0);
            vec4 tpos = vec4(0.0, Size, 0.0, 1.0);
            mat4 rot = mat4.rotation(radians(-360.0/Polynum), vec3(0.0, 0.0, 1.0));
            for(uint n = 1;n<Polynum;n++)
            {
                tpos = tpos * rot;
                vec3 p;
                p.x = tpos.x;
                p.y = tpos.y;
                p.z = tpos.z;
                vertpos[n+1] = p;
            }
            for(uint n = 1;n<Polynum+1;n++){
                index[n] = n;
            }
            index[$-1] = 1;


        super(Tex, vertpos, index, uvpos, GL_TRIANGLE_FAN);
    }
}

class Quadrangle : Polygon
{
    public:
    this ( vec3[] pos, BMP Tex, vec2[] uv = null )
    {
        uint[] index = [ 0, 3, 2 ,1 ];
        vec2[] uvpos;
        vec3[] vertpos = pos[0..4];
        if(uv==null)
        {
            uvpos = [
                vec2( 0.0, 0.0 ),
                vec2( 1.0, 0.0 ),
                vec2( 1.0, 1.0 ),
                vec2( 0.0, 1.0 )
            ];
        }else{
            uvpos = uv[0..4];
        }
        super( Tex, vertpos, index, uvpos, GL_TRIANGLE_FAN );
    }
}