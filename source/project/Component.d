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
       cafe.renderer.World;
import std.algorithm;

debug = 1;

/+ プロジェクト内のコンポーネントデータ +
 + AULでいうシーン                      +/
class Component
{
    private:
        Timeline tl;

    public:
        @property timeline () { return tl; }

        this ()
        {
            tl = new Timeline;
        }

        /+ Worldを生成 +/
        World generate ( FrameAt f )
        {
            auto rinfo   = new RenderingInfo;
            auto objects = timeline.objectsAtFrame(f).sort!
                ( (a, b) => a.place.layer.value < b.place.layer.value );
            objects.each!( x => x.generate( rinfo ) );
            return rinfo.renderingStage;
        }

        /+ 画像を生成 +/
        BMP render ( FrameAt f )
        {
            throw new Exception( "Not Implemented" );
        }

        debug (1) unittest {
            auto hoge = new Component;
            assert( hoge.generate( new FrameAt(0) ).polygons.length == 0 );
            // hoge.render( new FrameAt(0) );
        }
}
