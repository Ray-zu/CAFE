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
       cafe.renderer.sound.PCM,
       cafe.renderer.sound.Sound,
       cafe.renderer.sound.SoundList,
       cafe.renderer.polygon.Ngon,
       cafe.renderer.polygon.PolygonData;
import derelict.opengl3.gl3;
import gl3n.linalg,
       gl3n.math;
import core.thread;
import std.stdio;
import std.string;
import std.conv;
import derelict.sdl2.sdl,
       derelict.sdl2.types;

debug = 0;

private template glenforce ( alias func )
{
    auto glenforce ( string file = __FILE__, int line = __LINE__, Args... ) ( Args args )
    {
        scope(success) checkError( __traits(identifier, func), file, line );
        return func( args );
    }
}
private void checkError ( string context, string file, int line )
{
    auto err = glGetError();
    if ( err )
        throw new Exception( "OpenGL Error (%s) : %d".format( context, err ), file, line );
}

/+ OpenGLを利用したレンダラ +/
class OpenGLRenderer : Renderer
{
    mixin register!OpenGLRenderer;

    static string glversion;

    static SDL_Window* window = null;
    static SDL_GLContext context;

    static uint program;

    static void initialize ()
    {
        import dlangui;

        auto createContext ( int major, int miner )
        {
            SDL_GL_SetAttribute( SDL_GL_CONTEXT_MAJOR_VERSION, major );
            SDL_GL_SetAttribute( SDL_GL_CONTEXT_MINOR_VERSION, miner );
            context = SDL_GL_CreateContext( window );
            return context != null;
        }

        if ( window == null ) {
            window = SDL_CreateWindow(
                    "", 0, 0, 100, 100, SDL_WINDOW_OPENGL | SDL_WINDOW_HIDDEN );
            // 動作確認の済んでいるバージョンのみ使用
            bool success =       createContext( 4, 5 );
            success = success || createContext( 3, 3 );
            success = success || createContext( 3, 0 );
            success = success || createContext( 2, 1 );
            if ( !success )
                throw new Exception( "CAFEditor needs OpenGL 3.0 or more" );
        }
        SDL_GL_MakeCurrent( window, context );
        glversion = DerelictGL3.reload().to!string;

        // シェーダー作るよ
        uint Vshader = glenforce!glCreateShader(GL_VERTEX_SHADER);
        uint Fshader = glenforce!glCreateShader(GL_FRAGMENT_SHADER);

        // シェーダーのソース読み込むよ
        enum VSSource = import("Vertex_Shader.vert");
        enum FSSource = import("Fragment_Shader.frag");

        // コンパイル関数に渡せる文字列にするよ
        auto vsstr = VSSource.toStringz;
        int vslen = cast(int)VSSource.length;
        auto fsstr = FSSource.toStringz;
        int fslen = cast(int)FSSource.length;

        // シェーダーとソースを結び付けてコンパイルするよ
        glenforce!glShaderSource(Vshader, 1, &vsstr, &vslen);
        glenforce!glShaderSource(Fshader, 1, &fsstr, &fslen);
        glenforce!glCompileShader(Vshader);
        glenforce!glCompileShader(Fshader);

        // プログラム作ってシェーダーを紐づけるよ
        program = glenforce!glCreateProgram();
        glenforce!glAttachShader(program, Vshader);
        glenforce!glAttachShader(program, Fshader);

        // 最後にリンクして使える状態にするよ
        glenforce!glLinkProgram(program);

        Log.i("OpenGL initialized : "~glGetError().to!string);
    }

    private:
        uint framebuffer;
        uint framebuffer_msaa;
        uint Renderbuffer;
        uint mtexid;
        uint width;
        uint height;
        uint samplenum = 4;
        uint vao;

    public:
        static @property name () { return "OpenGLRenderer"; }
        override @property string nameStr () { return name; }
        @property sample () { return samplenum; }
        @property sample (uint s) { samplenum = s; }

        this ( uint wi = 1920, uint he = 1080 ) {
            if ( window == null ) initialize;
            SDL_GL_MakeCurrent( window, context );

            // マルチサンプリング用のレンダーバッファを生成
            glenforce!glGenRenderbuffers(1, &Renderbuffer);
            glenforce!glBindRenderbuffer(GL_RENDERBUFFER, Renderbuffer);
            glenforce!glRenderbufferStorageMultisample(GL_RENDERBUFFER, samplenum, GL_RGBA, wi, he);

            // 描画バッファ取得用のテクスチャを生成
            glenforce!glGenTextures(1, &mtexid);
            glenforce!glBindTexture(GL_TEXTURE_2D, mtexid);
            glenforce!glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA,
                         wi, he, 0, GL_RGBA, GL_FLOAT, null);

            // レンダーバッファをMSAA用のフレームバッファに割り当て
            glenforce!glGenFramebuffers(1, &framebuffer_msaa);
            glenforce!glBindFramebuffer(GL_FRAMEBUFFER, framebuffer_msaa);
            glenforce!glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0,
                                   GL_RENDERBUFFER, Renderbuffer);

            // テクスチャを通常のフレームバッファに割り当て
            glenforce!glGenFramebuffers(1, &framebuffer);
            glenforce!glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);
            glenforce!glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0,
                                   GL_TEXTURE_2D, mtexid, 0);

            // VAO生成
            glenforce!glGenVertexArrays( 1, &vao );

            width = wi;
            height = he;

            // フレームバッファの割り当てを解除
            glenforce!glBindFramebuffer(GL_FRAMEBUFFER, 0);
        }

        override PCM soundRender ( SoundList w )
        {
            return new PCM( 2, 100, 0 );
        }

        override BMP bmpRender ( World w, Camera c, uint wi, uint he )
        {
            SDL_GL_MakeCurrent( window, context );

            glenforce!glEnable(GL_MULTISAMPLE);
            glenforce!glViewport(0, 0, wi, he);
            // 現在のテクスチャのサイズと指定されたサイズが合わない場合は再生成
            if ( width != wi || height != he ) {
                glenforce!glRenderbufferStorageMultisample(GL_RENDERBUFFER, samplenum, GL_RGBA, wi, he);
                glenforce!glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA,
                             wi, he, 0, GL_RGBA, GL_FLOAT, null);
            }
            BMP result_image = new BMP(wi, he);

            // 描画するバッファの指定とフレームバッファの割り当て
            glenforce!glBindFramebuffer(GL_FRAMEBUFFER, framebuffer_msaa);
            glenforce!glDrawBuffer(GL_COLOR_ATTACHMENT0);

            glenforce!glUseProgram(program);

            int posloc, uvloc;
            posloc = glenforce!glGetAttribLocation(program, "position".toStringz);
            uvloc  = glenforce!glGetAttribLocation(program, "uv".toStringz);

            glenforce!glClear(GL_COLOR_BUFFER_BIT);
            vec2 halfsize = vec2(wi/2, he/2);

            // VAOを割当
            glenforce!glBindVertexArray( vao );

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
                GLuint MatrixID = glenforce!glGetUniformLocation(program, "MVP".toStringz);
                glenforce!glUniformMatrix4fv(MatrixID,  1, GL_TRUE, &mvp[0][0]);

                // UV座標に乗算する画像サイズ-1の値を渡す(矩形テクスチャなのでUV座標をピクセル値にしないといけない)
                GLuint SizemID = glenforce!glGetUniformLocation(program, "sizemag".toStringz);
                glenforce!glUniform2fv(SizemID,  1, sizem.value_ptr);

                // ポリゴンに含まれるBMPからテクスチャを生成
                GLuint Texture_ID;
                glenforce!glGenTextures(1, &Texture_ID);
                glenforce!glBindTexture(GL_TEXTURE_RECTANGLE, Texture_ID);
                glenforce!glTexImage2D(GL_TEXTURE_RECTANGLE, 0, GL_RGBA,
                            Texture.width, Texture.height, 0,
                            GL_RGBA, GL_FLOAT, Texture.bitmap);
                glenforce!glTexParameteri(GL_TEXTURE_RECTANGLE, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
                glenforce!glTexParameteri(GL_TEXTURE_RECTANGLE, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
                GLuint Sampler_ID = glenforce!glGetUniformLocation(program, "sampler".toStringz);

                // サンプラーを生成
                GLuint sampler;
                glenforce!glGenSamplers       (1, &sampler);
                glenforce!glSamplerParameteri (sampler, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_BORDER);
                glenforce!glSamplerParameteri (sampler, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_BORDER);
                glenforce!glSamplerParameteri (sampler, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
                glenforce!glSamplerParameteri (sampler, GL_TEXTURE_MAG_FILTER, GL_LINEAR);

                // VBOを作成
                // 頂点座標のバッファ
                GLuint VertexBuffer;
                glenforce!glGenBuffers(1, &VertexBuffer);
                glenforce!glBindBuffer(GL_ARRAY_BUFFER, VertexBuffer);
                glenforce!glBufferData(GL_ARRAY_BUFFER, pos.length*vec3.sizeof, pos.ptr, GL_STATIC_DRAW);
                glenforce!glEnableVertexAttribArray(posloc);
                glenforce!glVertexAttribPointer(posloc, 3, GL_FLOAT, GL_FALSE, 0, null);

                // UV座標のバッファ
                GLuint UVBuffer;
                glenforce!glGenBuffers(1, &UVBuffer);
                glenforce!glBindBuffer(GL_ARRAY_BUFFER, UVBuffer);
                glenforce!glBufferData(GL_ARRAY_BUFFER, uv.length*vec2.sizeof, uv.ptr, GL_STATIC_DRAW);
                glenforce!glEnableVertexAttribArray(uvloc);
                glenforce!glVertexAttribPointer(uvloc, 2, GL_FLOAT, GL_FALSE, 0, null);

                // テクスチャを有効化し、サンプラーを渡す
                glenforce!glActiveTexture(GL_TEXTURE0);
                glenforce!glBindTexture(GL_TEXTURE_RECTANGLE, Texture_ID);
                glenforce!glBindSampler(0, sampler);
                glenforce!glUniform1i(Sampler_ID, 0);

                // 受け取った頂点座標を元にすべて描画
                glenforce!glDrawArrays(Polyobj.drawmode, 0, cast(int)Polyobj.vindex.length);
            }

            // 読み出すためにMSAA用のバッファから通常のバッファに転送
            glenforce!glBindFramebuffer(GL_DRAW_FRAMEBUFFER, framebuffer);
            glenforce!glBindFramebuffer(GL_READ_FRAMEBUFFER, framebuffer_msaa);
            glenforce!glBlitFramebuffer(0 ,0 , wi, he, 0, he, wi, 0, GL_COLOR_BUFFER_BIT,
                            GL_LINEAR);
            // 通常のフレームバッファを読みだすバッファに指定
            glenforce!glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);

            // フレームバッファの読み出し
            glenforce!glReadBuffer(GL_COLOR_ATTACHMENT0);
            glenforce!glReadPixels( 0, 0, wi, he, GL_RGBA, GL_FLOAT,
                        cast(void*)result_image.bitmap);

            // フレームバッファの割り当てを解除
            glenforce!glBindFramebuffer( GL_FRAMEBUFFER, 0 );

            return result_image;
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
