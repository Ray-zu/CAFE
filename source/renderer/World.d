/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.renderer.World;
import cafe.renderer.polygon.Polygon,
       cafe.renderer.graphics.Bitmap,
       cafe.renderer.sound.SoundList;
import std.algorithm;

/+ ポリゴンのリスト                +
 + 1フレームの音声データも含みます +/
class World
{
    private:
        Polygon[] polies;
        SoundList sound_list;

    public:
        @property polygons  () { return polies; }
        @property soundList () { return sound_list; }

        this ( Polygon[] p = [], SoundList snds = new SoundList )
        {
            polies = p;
            sound_list = snds;
        }

        void clear ()
        {
            polies = [];
            sound_list.clear;
        }

        Polygon pop ( Polygon p )
        {
            polies = polies.remove!( x => x is p );
            return p;
        }

        World opAdd ( World rhs )
        {
            return new World( rhs.polygons~polygons, rhs.soundList+soundList ); // TODO : PCMデータのミックス
        }

        World opAddAssign ( World rhs )
        {
            polies ~= rhs.polygons;
            soundList += rhs.soundList;
            return this;
        }

        World opAddAssign ( Polygon rhs )
        {
            polies ~= rhs;
            return this;
        }
}
