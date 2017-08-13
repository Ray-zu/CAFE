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
import derelict.glfw3.glfw3;
import std.stdio;
import std.string;
import std.conv;

debug = 1;

/+ OpenGLを利用したレンダラ +/
class OpenGLRenderer : Renderer
{
    mixin register!OpenGLRenderer;

    private:
    uint framebuffer;
    uint Renderbuffer;
    uint BufferWidth;
    uint BufferHeight;
    int ProgramID;
    public:
        static @property name () { return "OpenGLRenderer"; }
        override @property string nameStr () { return name; }

        this (uint wi, uint he) {
            glfwWindowHint(GLFW_SAMPLES, 4);
            GLFWwindow *Invisible_Window = glfwCreateWindow( 1280, 720, "Invisible Window", null, null );
            glfwMakeContextCurrent( Invisible_Window );

            ("    OpenGL version : "~(DerelictGL3.reload().to!string)).writeln();

            glGenRenderbuffers(1, &Renderbuffer);
            glBindRenderbuffer(GL_RENDERBUFFER, Renderbuffer);
            glNamedRenderbufferStorage(Renderbuffer, GL_RGBA, wi, he);

            glGenFramebuffers(1, &framebuffer);
            glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);
            glNamedFramebufferRenderbuffer(framebuffer, GL_COLOR_ATTACHMENT0,
                                           GL_RENDERBUFFER, Renderbuffer);
            glBindBuffer(GL_FRAMEBUFFER, 0);
            BufferWidth = wi;
            BufferHeight = he;
            // シェーダー作るよ
            uint Vshader = glCreateShader(GL_VERTEX_SHADER);
            uint Fshader = glCreateShader(GL_FRAGMENT_SHADER);
            // シェーダーのソース読み込むよ
            string VSSource = import("Vertex_Shader.vert");
            string FSSource = import("Fragment_Shader.frag");
            // コンパイル関数に渡せる文字列にするよ
            auto vsstr = VSSource.toStringz;
            int vslen = VSSource.length;
            auto fsstr = FSSource.toStringz;
            int fslen = FSSource.length;
            // シェーダーとソースを結び付けてコンパイルするよ
            glShaderSource(Vshader, 1, &vsstr, &vslen);
            glShaderSource(Fshader, 1, &fsstr, &fslen);
            glCompileShader(Vshader);
            glCompileShader(Fshader);
            // プログラム作ってシェーダーを紐づけるよ
            ProgramID = glCreateProgram();
            glAttachShader(ProgramID, Vshader);
            glAttachShader(ProgramID, Fshader);
            // 最後にリンクして使える状態にするよ
            glLinkProgram(ProgramID);

        }

        this () {
            this( 1920, 1080 );
        }

        override PCM soundRender ( SoundList w )
        {
            return new PCM( 2, 100, 0 );
        }

        override BMP bmpRender ( World w, Camera c, uint wi, uint he )
        {

            BMP ResultImage = new BMP(wi, he);
            glViewport(0, 0, wi, he);
            if (BufferWidth!=wi||BufferHeight!=he) {
                glNamedRenderbufferStorage(Renderbuffer, GL_RGBA, wi, he);
            }

            glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);


        glUseProgram(ProgramID);

        int[2] attloc;
        attloc[0] = glGetAttribLocation(ProgramID, "position");
        attloc[1] = glGetAttribLocation(ProgramID, "color");
        float[] position = [
            -0.5f, -0.5f,
            0.5f, -0.5f,
            0.0f, 0.5f
        ];

        float[] color = [
            1.0, 0.0, 0.0,1.0,
            0.0, 1.0, 0.0,0.5,
            0.0, 0.0, 1.0,0.0,
            0.0, 1.0, 1.0,1.0
        ];
        glClear(GL_COLOR_BUFFER_BIT);

        writeln(typeid(typeof(color)));

        //VBOを作成
        GLuint[2] vbo;
        glGenBuffers(1, &vbo[0]);
        glBindBuffer(GL_ARRAY_BUFFER, vbo[0]);
        glNamedBufferData(vbo[0], position.length*float.sizeof, position.ptr, GL_STATIC_DRAW);
        glEnableVertexAttribArray(attloc[0]);
        glVertexAttribPointer(attloc[0], 2, GL_FLOAT, GL_FALSE, 0, null);

        glGenBuffers(1, &vbo[1]);
        glBindBuffer(GL_ARRAY_BUFFER, vbo[1]);
        glNamedBufferData(vbo[1], color.length*float.sizeof, color.ptr, GL_STATIC_DRAW);
        glEnableVertexAttribArray(attloc[1]);
        glVertexAttribPointer(attloc[1], 4, GL_FLOAT, GL_FALSE, 0, null);
        glDrawArrays(GL_TRIANGLES, 0, 3);

        glReadBuffer(GL_COLOR_ATTACHMENT0);
        GLubyte[] bufferpixel = new GLubyte[wi*he*4];
        glReadPixels( 0, 0, wi, he, GL_RGBA, GL_UNSIGNED_BYTE,
                      cast(void*)bufferpixel);

        for (uint y; y<he; y++)
        {
            for (uint x; x<wi*4; x+=4)
            {
                uint readpos = (he-y-1) * wi*4 + x;
                RGBA col;
                col.r = bufferpixel[readpos];
                col.g = bufferpixel[readpos+1];
                col.b = bufferpixel[readpos+2];
                col.a = bufferpixel[readpos+3];
                ResultImage[x/4,y] = col;
            }
        }

            glBindFramebuffer( GL_FRAMEBUFFER, 0 );

            //Gradation(ResultImage);
            return ResultImage;
        }

        /+ レンダリングのテスト +/
        debug (1) auto renderTest ()
        {
            auto white_bmp = new BMP(1,1);
            white_bmp[0,0] = RGBA( 255, 255, 255 );
            auto polygon = new Polygon( white_bmp, [
                    Vertex( Vector3D(-50,-50,0), Vector2D(0,0) ),
                    Vertex( Vector3D( 50,-50,0), Vector2D(1,0) ),
                    Vertex( Vector3D( 50, 50,0), Vector2D(1,1) ),
                    Vertex( Vector3D(-50, 50,0), Vector2D(0,1) )
                ] );
            return render( new World([polygon]), new Camera, 640, 480 ).bitmap;
        }
}
