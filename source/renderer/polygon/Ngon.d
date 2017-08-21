/+ ------------------------------------------------------------ +
 + Author : SEED264                                             +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.renderer.polygon.Ngon;
import cafe.renderer.graphics.Bitmap,
       cafe.renderer.polygon.Material,
       cafe.renderer.polygon.Polygon,
       cafe.renderer.polygon.PolygonData;
import derelict.opengl3.gl3;
import gl3n.linalg,
       gl3n.math;

/* 多角形用のラッパークラス */
class Ngon : Polygon
{
    public:
    this ( uint Polynum, float Size, Transform trans, BMP Tex )
    {
        Polynum = max(Polynum, 3);
        vec3[] vertpos = new vec3[Polynum+1];
        uint[] index = new uint[Polynum+2];
        vec2[] uvpos = new vec2[Polynum+2];

            // 頂点座標を自動生成
            vertpos[0] = vec3(0.0, 0.0, 0.0);
            vec4 tpos = vec4(0.0, Size/2.0, 0.0, 1.0);
            mat4 rot = mat4.rotation(radians(-360.0/Polynum), vec3(0.0, 0.0, 1.0));
            for(uint n = 1;n<Polynum+1;n++)
            {
                vec3 p;
                p.x = tpos.x;
                p.y = tpos.y;
                p.z = tpos.z;
                vertpos[n] = p;
                tpos = tpos * rot;
            }
            // Indexを自動生成
            for(uint n = 1;n<Polynum+1;n++){
                index[n] = n;
            }
            index[$-1] = 1;
            // UVを自動生成
            uvpos[0] = vec2(0.5, 0.5);
            vec4 tupos = vec4(0.0, -0.5, 0.0, 1.0);
            rot = mat4.rotation(radians(360.0/Polynum), vec3(0.0, 0.0, 1.0));
            for(uint n = 1;n<Polynum+2;n++)
            {
                vec2 u;
                u.x = tupos.x+0.5;
                u.y = tupos.y+0.5;
                uvpos[n] = u;
                tupos = tupos * rot;
            }




        super(Tex, vertpos, index, uvpos, trans, GL_TRIANGLE_FAN);
    }
}

/* 頂点を指定するタイプの四角形 */
class Quadrangle : Polygon
{
    public:
    this ( vec3[] pos, Transform trans, BMP Tex, vec2[] uv = null )
    {
        uint[] index = [ 0, 3, 2 ,1 ];
        vec2[] uvpos;
        vec3[] vertpos = pos[0..4];
        if(uv==null)
        {
            uvpos = [
                vec2( 0.0, 0.0 ),
                vec2( 0.0, 1.0 ),
                vec2( 1.0, 1.0 ),
                vec2( 1.0, 0.0 )
            ];
        }else{
            uvpos = [
                uv[0], uv[3], uv[2], uv[1]
            ];
        }
        super( Tex, vertpos, index, uvpos, trans, GL_TRIANGLE_FAN );
    }
}

/* サイズだけ渡せば座標を自動計算してくれる四角形 */
class Rectangle : Quadrangle
{
    public:
    this ( vec2 size, Transform trans, BMP Tex, vec2[] uv = null )
    {
        size /= 2;
        vec3[] vertpos = [
            vec3( -size.x,  size.y, 0 ),
            vec3(  size.x,  size.y, 0 ),
            vec3(  size.x, -size.y, 0 ),
            vec3( -size.x, -size.y, 0 )
        ];
        super( vertpos, trans, Tex, uv );
    }
}
