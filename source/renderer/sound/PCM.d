/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.renderer.sound.PCM;
import std.exception;

debug = 1;

/+ PCMデータ形式                                   +
 + PCMデータひとつの配列の長さを値として持ちます。 +/
enum PCMFormat
{
    None     = 0,
    Monaural = 1,
    Stereo   = 2
}

/+ 音声データ +/
class PCM
{
    private:
        short[]   sounds;
        PCMFormat pcm_format;
        uint      sampling_rate;

    public:
        @property pcm          () { return sounds; }
        @property format       () { return pcm_format; }
        @property samplingRate () { return sampling_rate; }

        /+ lにはpcmデータの数を指定します。                        +
         + 1を指定した場合、モノラルならば配列の長さは1に、        +
         +                  ステレオならば配列の長さは2になります。+/
        this ( PCMFormat f, uint r, uint l )
        {
            enforce( f != PCMFormat.None, "Illegal PCMFormat" );
            enforce( r > 0, "Sampling Rate must be one or more." );

            pcm_format = f;
            sampling_rate = r;

            sounds.length = format * sampling_rate * l;
        }

        /+ WindowsのWaveOutを使って出力します。(デバッグ用) +/
        debug (1) version ( Windows ) void testplay ()
        {
            // TODO : WaveOutの実行
        }

        debug (1) unittest {
            // 48000Hzの1分間のステレオ音声データ
            auto hoge = new PCM( PCMFormat.Stereo, 48000, 60 );
            version ( Windows ) hoge.testplay;
        }
}
