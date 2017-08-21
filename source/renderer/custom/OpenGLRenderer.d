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
       cafe.renderer.sound.SoundList,
       cafe.renderer.polygon.Ngon,
       cafe.renderer.polygon.PolygonData;
import derelict.opengl3.gl3;
import gl3n.linalg,
       gl3n.math;
import std.stdio;
import std.string;
import std.conv;
import derelict.sdl2.sdl,
       derelict.sdl2.types;

debug = 1;
/+ OpenGLを利用したレンダラ +/
class OpenGLRenderer : Renderer
{
    mixin register!OpenGLRenderer;

    __gshared SDL_Window* window = null;
    __gshared SDL_GLContext context;

    private:
    uint framebuffer;
    uint framebuffer_msaa;
    uint Renderbuffer;
    uint mtexid;
    uint BufferWidth;
    uint BufferHeight;
    uint samplenum = 4;
    int ProgramID;
    public:
        static @property name () { return "OpenGLRenderer"; }
        override @property string nameStr () { return name; }
        @property sample () { return samplenum; }
        @property sample (uint s) { samplenum = s; }

        this (uint wi, uint he) {
            // 非表示のウィンドウを生成(コンテキストの生成に必須のため)
            if ( window == null ) {
                window = SDL_CreateWindow(
                        "", 0, 0, 100, 100, SDL_WINDOW_OPENGL );
                context = SDL_GL_CreateContext( window );
            }
            SDL_GL_MakeCurrent( window, context );

            // DerelictGLのリロードのついでに読んだGLのバージョンを表示
            ("    OpenGL version : "~(DerelictGL3.reload().to!string)).writeln();

            // マルチサンプリング用のレンダーバッファを生成
            glGenRenderbuffers(1, &Renderbuffer);
            glBindRenderbuffer(GL_RENDERBUFFER, Renderbuffer);
            glRenderbufferStorageMultisample(GL_RENDERBUFFER, samplenum, GL_RGBA, wi, he);

            // 描画バッファ取得用のテクスチャを生成
            glGenTextures(1, &mtexid);
            glBindTexture(GL_TEXTURE_2D, mtexid);
            glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA,
                         wi, he, 0, GL_RGBA, GL_FLOAT, null);

            // レンダーバッファをMSAA用のフレームバッファに割り当て
            glGenFramebuffers(1, &framebuffer_msaa);
            glBindFramebuffer(GL_FRAMEBUFFER, framebuffer_msaa);
            glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0,
                                   GL_RENDERBUFFER, Renderbuffer);

            // テクスチャを通常のフレームバッファに割り当て
            glGenFramebuffers(1, &framebuffer);
            glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);
            glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0,
                                   GL_TEXTURE_2D, mtexid, 0);

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
            int vslen = cast(int)VSSource.length;
            auto fsstr = FSSource.toStringz;
            int fslen = cast(int)FSSource.length;

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

            // フレームバッファの割り当てを解除
            glBindFramebuffer(GL_FRAMEBUFFER, 0);
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
            SDL_GL_MakeCurrent( window, context );

            glEnable(GL_MULTISAMPLE);
            BMP ResultImage = new BMP(wi, he);
            glViewport(0, 0, wi, he);
            // 現在のテクスチャのサイズと指定されたサイズが合わない場合は再生成
            if (BufferWidth!=wi||BufferHeight!=he) {
            glRenderbufferStorageMultisample(GL_RENDERBUFFER, samplenum, GL_RGBA, wi, he);
            glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA,
                         wi, he, 0, GL_RGBA, GL_FLOAT, null);
            }

            // 描画するバッファの指定とフレームバッファの割り当て
            //glDrawBuffer(GL_COLOR_ATTACHMENT0);
            glBindFramebuffer(GL_FRAMEBUFFER, framebuffer_msaa);

            glUseProgram(ProgramID);

            int posloc, uvloc;
            posloc = glGetAttribLocation(ProgramID, "position");
            uvloc = glGetAttribLocation(ProgramID, "uv");

            glClear(GL_COLOR_BUFFER_BIT);
            vec2 halfsize = vec2(wi/2, he/2);

            // 並行投影用の行列
            mat4 orthmat = mat4.orthographic(-halfsize.x, halfsize.x, -halfsize.y, halfsize.y, 10000.0, -10000.0);

            // Worldに含まれるポリゴンオブジェクト分繰り返す
            for(uint n = 0;n<w.polygons.length;n++){
                Polygon Polyobj = w.polygons[n];
                BMP Texture = Polyobj.texture;
                vec2[] uv = Polyobj.uv;
                vec3[] pos;
                vec2 sizem;
                sizem.x = Texture.width-1;
                sizem.y = Texture.height-1;
                for(uint vn;vn<Polyobj.vindex.length;vn++){
                    pos ~= Polyobj.position[Polyobj.vindex[vn]];
                }

                // 平行投影用の行列を渡す
                mat4 mvp = orthmat * Polyobj.transform.mat;
                GLuint MatrixID = glGetUniformLocation(ProgramID, "MVP");
                glUniformMatrix4fv(MatrixID,  1, GL_TRUE, &mvp[0][0]);

                // UV座標に乗算する画像サイズ-1の値を渡す(矩形テクスチャなのでUV座標をピクセル値にしないといけない)
                GLuint SizemID = glGetUniformLocation(ProgramID, "sizemag");
                glUniform2fv(SizemID,  1, sizem.value_ptr);

                // ポリゴンに含まれるBMPからテクスチャを生成
                GLuint Texture_ID;
                glGenTextures(1, &Texture_ID);
                glBindTexture(GL_TEXTURE_RECTANGLE, Texture_ID);
                glTexImage2D(GL_TEXTURE_RECTANGLE, 0, GL_RGBA,
                            Texture.width, Texture.height, 0,
                            GL_RGBA, GL_FLOAT, Texture.bitmap);
                glTexParameteri(GL_TEXTURE_RECTANGLE, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
                glTexParameteri(GL_TEXTURE_RECTANGLE, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
                GLuint Sampler_ID = glGetUniformLocation(ProgramID, "sampler");

                // サンプラーを生成
                GLuint sampler;
                glGenSamplers       (1, &sampler);
                glSamplerParameteri (sampler, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_BORDER);
                glSamplerParameteri (sampler, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_BORDER);
                glSamplerParameteri (sampler, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
                glSamplerParameteri (sampler, GL_TEXTURE_MAG_FILTER, GL_LINEAR);


                // VBOを作成
                // 頂点座標のバッファ
                GLuint VertexBuffer;
                glGenBuffers(1, &VertexBuffer);
                glBindBuffer(GL_ARRAY_BUFFER, VertexBuffer);
                glBufferData(GL_ARRAY_BUFFER, pos.length*vec3.sizeof, pos.ptr, GL_STATIC_DRAW);
                glEnableVertexAttribArray(posloc);
                glVertexAttribPointer(posloc, 3, GL_FLOAT, GL_FALSE, 0, null);

                // UV座標のバッファ
                GLuint UVBuffer;
                glGenBuffers(1, &UVBuffer);
                glBindBuffer(GL_ARRAY_BUFFER, UVBuffer);
                glBufferData(GL_ARRAY_BUFFER, uv.length*vec2.sizeof, uv.ptr, GL_STATIC_DRAW);
                glEnableVertexAttribArray(uvloc);
                glVertexAttribPointer(uvloc, 2, GL_FLOAT, GL_FALSE, 0, null);

                // テクスチャを有効化し、サンプラーを渡す
                glActiveTexture(GL_TEXTURE0);
                glBindTexture(GL_TEXTURE_RECTANGLE, Texture_ID);
                glBindSampler(0, sampler);
                glUniform1i(Sampler_ID, 0);

                // 受け取った頂点座標を元にすべて描画
                glDrawArrays(Polyobj.drawmode, 0, cast(int)Polyobj.vindex.length);

            }

            // 読み出すためにMSAA用のバッファから通常のバッファに転送
            glBindFramebuffer(GL_DRAW_FRAMEBUFFER, framebuffer);
            glBindFramebuffer(GL_READ_FRAMEBUFFER, framebuffer_msaa);
            glBlitFramebuffer(0 ,0 , wi, he, 0, he, wi, 0, GL_COLOR_BUFFER_BIT,
                            GL_LINEAR);
            // 通常のフレームバッファを読みだすバッファに指定
            glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);

            // フレームバッファの読み出し
            glReadBuffer(GL_COLOR_ATTACHMENT0);
            float[] bufferpixel = new float[wi*he*4];
            glReadPixels( 0, 0, wi, he, GL_RGBA, GL_FLOAT,
                        cast(void*)ResultImage.bitmap);

            // フレームバッファの割り当てを解除
            glBindFramebuffer( GL_FRAMEBUFFER, 0 );

            { import dlangui; Log.i( glGetError() ); }
            //Gradation(ResultImage);
            return ResultImage;
        }

        /+ レンダリングのテスト +/
        debug (1) auto renderTest ()
        {
            auto white_bmp = new BMP(1,1);
            white_bmp[0,0] = RGBA( 255, 255, 255 );
            BMP color_bmp = new BMP(2, 2,[
                    RGBA(0.0, 1.0, 0.0, 1.0),
                    RGBA(1.0, 0.0, 0.0, 1.0),
                    RGBA(0.0, 1.0, 1.0, 1.0),
                    RGBA(1.0, 0.0, 1.0, 1.0)
                ]);

            // 普通のポリゴン
            auto polygon = new Polygon( white_bmp, [
                    vec3(-500,  200, 0),
                    vec3( 500,  200, 0),
                    vec3( 500, -200, 0),
                    vec3(-500, -200, 0)
                ], [
                    0,3,1,2
                ], [
                        vec2(0,0),
                        vec2(1,0),
                        vec2(1,1),
                        vec2(0,1)
                ],
                Transform(
                    vec3( 0.0, 0.0, 0.0 ),
                    vec3( 0.0, 0.0, 0.0 ),
                    vec3( 1.0, 1.0, 1.0 )
                ) );

            // 多角形クラス
            Ngon Ng = new Ngon( 5, 640, Transform(
                    vec3( 200.0, 150.0, -120.0 ),
                    vec3( 0.0, 0.0, -35.0 ),
                    vec3( 0.5, 0.3, 1.0 )
                ), color_bmp );

            // 四角形(頂点自由)
            Quadrangle Quad = new Quadrangle( [
                    vec3(-320,  320, 0),
                    vec3( 320,  320, 0),
                    vec3( 320, -320, 0),
                    vec3(-320, -320, 0)
                ], Transform(
                    vec3( 50.0, 45.0, 120.0 ),
                    vec3( 0.0, 0.0, 5.0 ),
                    vec3( 1.0, 1.0, 1.0 )
                ), color_bmp,[
                    vec2( 0.0, 0.0 ),
                    vec2( 1.0, 0.0 ),
                    vec2( 1.0, 1.0 ),
                    vec2( 0.0, 1.0 )
                ] );

            // 長方形(サイズ指定)
            Rectangle Rect = new Rectangle( vec2(-710, 500), Transform(
                    vec3( 0.0, 0.0, 0.0 ),
                    vec3( 0.0, 0.0, 0.0 ),
                    vec3( 1.0, 1.0, 1.0 )
                ), color_bmp );

            return render( new World([Quad, Rect, Ng]), new Camera, 720, 720 ).bitmap;
        }
}
