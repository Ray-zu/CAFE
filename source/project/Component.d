/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.project.Component;
import cafe.project.timeline.Timeline,
       cafe.project.ObjectPlacingInfo,
       cafe.project.RenderingInfo,
       cafe.renderer.graphics.Bitmap,
       cafe.renderer.World,
       cafe.renderer.Renderer;
import std.algorithm;

debug = 0;

/+ プロジェクト内のコンポーネントデータ +
 + AULでいうシーン                      +/
class Component
{
    private:
        Timeline tl;
        uint size_width, size_height;

    public:
        @property timeline () { return tl; }
        @property width    () { return size_width; }
        @property height   () { return size_height; }

        this ( Component src )
        {
            tl = new Timeline( src.timeline );
            resize( src.width, src.height );
        }

        this ( uint w = 1920, uint h = 1080 )
        {
            tl = new Timeline;
            resize( w, h );
        }

        /+ コンポーネントのリサイズ +/
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
            auto objects = timeline.objectsAtFrame(f).sort!
                ( (a, b) => a.place.layer.value < b.place.layer.value );
            objects.each!( x => x.apply( rinfo ) );
            return rinfo;
        }

        /+ レンダリング +/
        RenderingResult render ( FrameAt f, Renderer r )
        {
            auto rinfo = generate(f);
            return r.render( rinfo.renderingStage, rinfo.camera,
                   rinfo.width, rinfo.height );
        }

        debug (1) unittest {
            auto hoge = new Component;
            assert( hoge.generate( new FrameAt(0) ).renderingStage.polygons.length == 0 );
            // hoge.render( new FrameAt(0) );
        }
}
