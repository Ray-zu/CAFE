/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.media.encoder.Encoder;
import cafe.renderer.graphics.Bitmap;

interface Encoder
{
    public:
        bool encode ( BMP, PCM );
}
