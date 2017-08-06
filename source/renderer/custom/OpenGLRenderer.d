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
       cafe.renderer.graphics.Bitmap,
       cafe.renderer.graphics.Color,
       cafe.renderer.polygon.Material,
       cafe.renderer.polygon.Polygon,
       cafe.renderer.polygon.Vector,
       cafe.renderer.polygon.Vertex,
       cafe.renderer.sound.PCM,
       cafe.renderer.sound.Sound,
       cafe.renderer.sound.SoundList;
import derelict.opengl3.gl3;

debug = 1;

/+ OpenGLを利用したレンダラ +/
class OpenGLRenderer : Renderer
{
    private:
    public:
        this () {}

        override PCM soundRender ( SoundList w )
        {
            return new PCM( 2, 100, 0 );
        }

        override BMP bmpRender ( World w, Camera c, uint wi, uint he )
        {
            return new BMP( wi, he );
        }

        /+ レンダリングのテスト +/
        debug (1) auto renderTest ()
        {
            auto white_bmp = new BMP(1,1);
            white_bmp[0,0] = 0xffffff;
            auto polygon = new Polygon( white_bmp, [
                    Vertex( Vector3D(-50,-50,0), Vector2D(0,0) ),
                    Vertex( Vector3D( 50,-50,0), Vector2D(1,0) ),
                    Vertex( Vector3D( 50, 50,0), Vector2D(1,1) ),
                    Vertex( Vector3D(-50, 50,0), Vector2D(0,1) )
                ] );
            return render( new World([polygon]), new Camera, 640, 480 ).bitmap;
        }
}
