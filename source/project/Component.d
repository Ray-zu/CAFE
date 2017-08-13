/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.project.Component;
import cafe.json,
       cafe.project.timeline.Timeline,
       cafe.project.ObjectPlacingInfo,
       cafe.project.RenderingInfo,
       cafe.renderer.graphics.Bitmap,
       cafe.renderer.World,
       cafe.renderer.Renderer;
import std.algorithm,
       std.conv,
       std.json;

debug = 0;

/+ プロジェクト内のコンポーネントデータ +
 + AULでいうシーン                      +/
class Component
{
    enum DefaultWidth    = 1920;
    enum DefaultHeight   = 1080;
    enum DefaultRenderer = "OpenGLRenderer";
    private:
        Timeline tl;
        uint size_width, size_height;

        Renderer renderer;

    public:
        string author;

        @property timeline () { return tl; }
        @property width    () { return size_width; }
        @property height   () { return size_height; }

        @property rendererName () { return renderer.nameStr; }
        @property rendererName ( string n )
        {
            renderer = Renderer.create( n );
        }

        this ( Component src )
        {
            tl = new Timeline( src.timeline );
            resize( src.width, src.height );
            rendererName = src.rendererName;
        }

        this ( uint w = DefaultWidth, uint h = DefaultHeight )
        {
            tl = new Timeline;
            resize( w, h );
            rendererName = DefaultRenderer;
        }

        this ( JSONValue j )
        {
            tl = new Timeline( j["timeline"] );
            author = j["author"].str;
            size_width  = j["width"] .getUInteger;
            size_height = j["height"].getUInteger;
            rendererName = j["renderer"].str;
        }

        /+ コンポーネントの画像リサイズ +/
        void resize ( uint w, uint h )
        {
            if ( w == 0 || h == 0 )
                throw new Exception( "Image size must be 1px or more." );
            size_width = w;
            size_height = h;
        }

        /+ RenderingInfoを生成 +/
        auto generate ( FrameAt f )
        {
            auto rinfo   = new RenderingInfo( f, width, height );
            auto objects = timeline[f].sort!
                ( (a, b) => a.place.layer.value < b.place.layer.value );

            LayerId last_layer = new LayerId(0);
            foreach ( obj; objects )
            {
                if ( last_layer.value+1 < obj.place.layer.value )
                    rinfo.pushEffectStage; // 空白レイヤでレンダリングステージへプッシュ
                obj.apply( rinfo );
            }
            return rinfo;
        }

        /+ レンダリング +/
        RenderingResult render ( FrameAt f )
        {
            auto rinfo = generate(f);
            return renderer.render( rinfo.renderingStage, rinfo.camera,
                   rinfo.width, rinfo.height );
        }

        /+ JSON出力 +/
        @property json ()
        {
            JSONValue j;
            j["timeline"] = JSONValue(timeline.json);
            j["author"]   = JSONValue(author);
            j["width"]    = JSONValue(width);
            j["height"]   = JSONValue(height);
            j["renderer"] = JSONValue(rendererName);
            return j;
        }

        debug (1) unittest {
            auto hoge = new Component;
            assert( hoge.generate( new FrameAt(0) ).renderingStage.polygons.length == 0 );
            // hoge.render( new FrameAt(0) );

            auto hoge2 = new Component( hoge.json );
            assert( hoge.json.to!string == hoge2.json.to!string );
        }
}
