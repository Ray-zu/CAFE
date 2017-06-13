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
import std.algorithm;

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

        this ( Polygon[] polies = [], PCM pcm = new PCM( 1, 10000, 0 ) )
        {
            this.polies = polies;
            this.pcm    = pcm;
        }

        Polygon pop ( Polygon p )
        {
            polies = polies.remove!( x => x is p );
            return p;
        }

        World opAdd ( World rhs )
        {
            return new World( rhs.polygons~polygons ); // TODO : PCMデータのミックス
        }

        World opAddAssign ( World rhs )
        {
            polies ~= rhs.polygons;
            // TODO : PCMデータのミックス
            return this;
        }

        World opAdd ( Polygon rhs )
        {
            return new World( polygons~rhs );
        }

        World opAddAssign ( Polygon rhs )
        {
            polies ~= rhs;
            return this;
        }

        debug (1) unittest {
            auto v3d = Vector3D( 0, 0, 0 );
            auto poly = new Polygon( new BMP(5,5), v3d,v3d,v3d,v3d );
            auto hoge = new World ( [poly] );
            assert( (hoge+hoge).polygons.length == 2 );
            assert( hoge.pop( poly ) == poly );
            assert( hoge.polygons.length == 0 );
        }
}
