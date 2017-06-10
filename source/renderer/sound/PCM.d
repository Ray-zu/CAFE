/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.renderer.sound.PCM;
import std.exception;

debug = 1;

/+ 音声データ +/
class PCM
{
    private:
        short[]   sounds;
        uint      pcm_channels;
        uint      sampling_rate;

    public:
        @property pcm          () { return sounds; }
        @property channels     () { return pcm_channels; }
        @property samplingRate () { return sampling_rate; }

        /+ lにはpcmデータの数を指定します。                        +
         + 1を指定した場合、モノラルならば配列の長さは1に、        +
         +                  ステレオならば配列の長さは2になります。+/
        this ( uint c, uint r, uint l )
        {
            enforce( c > 0, "Channel must be one or more." );
            enforce( r > 0, "Sampling Rate must be one or more." );

            pcm_channels = c;
            sampling_rate = r;

            sounds.length = channels * sampling_rate * l;
        }

        /+ PCMファイルとしてfileに出力します。 +/
        debug (1) version ( Windows ) void testsave ( string file )
        {
            import std.stdio,
                   std.algorithm;
            auto fp = File( file, "w" );
            pcm.each!( x => fp.write(x) );
            fp.close;
        }

        debug (1) unittest {
            // 48000Hzの1分間のステレオ音声データ
            auto hoge = new PCM( 2, 48000, 60 );
            version ( Windows ) hoge.testsave( "./hoge.pcm" );
        }
}
