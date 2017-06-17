/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.renderer.sound.SoundList;
import cafe.renderer.sound.Sound;

/+ Soundクラスのリスト +/
class SoundList
{
    private:
        Sound[] snds;

    public:
        @property sounds () { return snds; }

        this ()
        {
            snds = [];
        }

        void add ( Sound s )
        {
            snds ~= s;
        }

        SoundList opAddAssign ( Sound s )
        {
            add( s );
            return this;
        }
}
