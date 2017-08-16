/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 +          SEED264                                             +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.renderer.polygon.Polygon;
import cafe.renderer.graphics.Bitmap,
       cafe.renderer.polygon.Material,
       cafe.renderer.polygon.Vertex;
import derelict.opengl3.gl3;
import gl3n.linalg;

/+ ポリゴンのデータ +/
class Polygon
{
    private:
        BMP       tex;
        Material  mat;
        vec3[]    pos;    // 三次元座標
        uint[]    vidx;   // 頂点インデックス
        vec2[]    uvpos;  // UV座標
        GLenum    dmode;  // ポリゴンの描画モード
        /+ TODO エフェクト情報 +/

    public:
        @property texture  () { return tex; }
        @property position () { return pos; }
        @property vindex () { return vidx; }
        @property uv () { return uvpos; }
        @property drawmode () { return dmode; }
        @property drawmode (GLenum a) { dmode = a; }
        @property material () { return mat; }

        this ( BMP t, vec3[] p, uint[] vi, vec2[] uv, GLenum m = GL_TRIANGLES )
        {
            tex = t;
            pos = p;
            vidx = vi;
            uvpos = uv;
            dmode = m;
        }
}
