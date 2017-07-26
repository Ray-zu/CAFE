/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.media.encoder.Encoder;
import cafe.renderer.graphics.Bitmap,
       cafe.renderer.sound.PCM;

abstract class Encoder
{
    private:
        string output_file;

    public:
        this ( string f )
        {
            output_file = f;
        }

        bool encode ( BMP, PCM );


        /+ エンコーダ登録用 +/
        struct RegisteredEncoder
        {
            string name;
            Encoder delegate ( string f ) create;
        }
        static RegisteredEncoder[] registeredEncoders;

        /+ エンコーダ登録 +/
        template register ( T )
        {
            static this ()
            {
                RegisteredEncoder r;
                r.name = T.name;
                r.create = delegate ( string f )
                {
                    return new T( f );
                };
                registeredEncoders ~= r;
            }
        }
}
