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

        this ( Sound[] s = [] )
        {
            snds = s;
        }

        void clear ()
        {
            snds = [];
        }

        void add ( Sound s )
        {
            snds ~= s;
        }

        SoundList opAddAssign ( Sound rhs )
        {
            add( rhs );
            return this;
        }

        SoundList opAdd ( SoundList rhs )
        {
            return new SoundList( sounds~rhs.sounds );
        }

        SoundList opAddAssign ( SoundList rhs )
        {
            snds ~= rhs.sounds;
            return this;
        }
}
