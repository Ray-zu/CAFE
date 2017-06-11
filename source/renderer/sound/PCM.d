/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.renderer.sound.PCM;
import std.algorithm,
       std.conv,
       std.exception,
       std.math,
       std.traits;

/+ 2以上を指定でカレントディレクトリにPCMデータのサンプルを出力 +/
debug = 2;

/+ 音声データ +/
class PCM
{
    private:
        float[]   sounds;
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

        /+ 指定した型の配列に変換 +/
        T[] normalize (T)()
            if ( isNumeric!T )
        {
            T[] r;
            pcm.each!( x => (r ~=
                        max( min( x.round, T.max ), T.min ).to!T) );
            return r;
        }

        /+ 16bit PCMに変換 +/
        short[] normalize16bit ()
        {
            return normalize!short;
        }

        /+ 32bit PCMに変換 +/
        int[] normalize32bit ()
        {
            return normalize!int;
        }

        /+ PCMデータの取得 +/
        float opIndex ( size_t i )
        {
            return pcm[i];
        }

        /+ PCMデータの設定 +/
        float opIndexAssign ( short v, size_t i )
        {
            return sounds[i] = v;
        }

        /+ PCMデータの合成 +/
        PCM opAdd ( PCM s )
        {
            // TODO
            throw new Exception( "Not Implemented" );
        }

        /+ PCMファイルとしてfileに出力 +
         + デバッグに使用します。      +/
        void save ( string file )
        {
            import std.stdio,
                   std.bitmanip;
            auto fp = File( file, "w" );
            normalize16bit.each!( x => fp.rawWrite( x.nativeToLittleEndian ) );
            fp.close;
        }

        debug (1) unittest {
            // SampleRate10000/モノラルの1分間のPCMデータ
            auto hoge = new PCM( 1, 10000, 60 );
            foreach ( i,v; hoge.pcm )
                hoge[i] = (i%2 == 0 ? 1 : -1) * short.max;
            // ピーという音のPCMデータが生成されれば成功
            // ffmpeg -f s16le -ar 10000 -ac 1 -i hoge.pcm hoge.wav
            debug (2) version ( Windows ) hoge.save( "./hoge.pcm" );
        }
}
