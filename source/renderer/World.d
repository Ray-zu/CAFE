/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.renderer.World;
import cafe.renderer.polygon.Polygon,
       cafe.renderer.polygon.Vector,
       cafe.renderer.graphics.Bitmap,
       cafe.renderer.sound.PCM;

debug = 0;

/+ ポリゴンのリスト                +
 + 1フレームの音声データも含みます +/
class World
{
    private:
        Polygon[] polies;
        PCM pcm;

    public:
        @property polygons () { return polies; }
        @property sound    () { return pcm; }

        this ( Polygon[] polies, PCM pcm = new PCM( 1, 10000, 0 ) )
        {
            this.polies = polies;
            this.pcm    = pcm;
        }

        // TODO : ポリゴン配列の追加演算子オーバーロード

        debug (1) unittest {
            auto v3d = Vector3D( 0, 0, 0 );
            auto hoge = new World ( [new Polygon( new BMP(5,5), v3d,v3d,v3d,v3d )] );
        }
}
