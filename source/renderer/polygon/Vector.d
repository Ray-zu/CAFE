/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.renderer.polygon.Vector;

/+ 3次元ベクトル +/
struct Vector3D
{
    public:
        float x, y, z;

        this ( float x, float y, float z )
        {
            this.x = x; this.y = y; this.z = z;
        }

        // TODO : ベクトルの算術演算子オーバーロード
}
