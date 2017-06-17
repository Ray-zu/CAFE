/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 +          SEED264                                             +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.renderer.custom.OpenGLRenderer;
import cafe.renderer.Renderer,
       cafe.renderer.World,
       cafe.renderer.Camera,
       cafe.renderer.graphics.Bitmap;
import derelict.opengl3.gl3;

/+ OpenGLを利用したレンダラ +/
class OpenGLRenderer
{
    private:
    public:
        this () {}

        BMP render ( World, Camera )
        {
            // TODO
            return new BMP( 1, 1 );
        }
}
