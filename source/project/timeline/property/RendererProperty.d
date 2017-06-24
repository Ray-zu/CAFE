/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.project.timeline.property.RendererProperty;
import cafe.project.ObjectPlacingInfo,
       cafe.project.timeline.property.Property,
       cafe.renderer.Renderer;
import std.json;

debug = 0;

/+ レンダラの種類 +/
enum RendererType
{
    NoRendering = "NoRendering"     // レンダリングをせずポリゴン集合体をそのまま返す
}

/+ レンダリングプロパティ +/
class RendererProperty : PropertyBase!RendererType
{
    public:
        override @property string typeToString ()
        {
            return "string";
        }

    public:
        override @property Property copy ()
        {
            return new RendererProperty( this );
        }

        this ( RendererProperty src )
        {
            super( src );
        }

        this ( FrameLength f, RendererType r = RendererType.NoRendering )
        {
            super( f, r );
        }

        this ( JSONValue[] j, FrameLength f, RendererType r = RendererType.NoRendering )
        {
            super( j, f, r );
        }

        /+ レンダラのインスタンスを作成 +/
        Renderer createRenderer ( FrameAt f )
        {
            auto ev = get(f);
            switch ( ev )
            {
                case RendererType.NoRendering:
                    return null;

                default: throw new Exception( "Unknown Renderer" );
            }
        }

        override @property JSONValue json ()
        {
            auto j = super.json;
            j["type"] = "Renderer";
            return j;
        }

        debug (1) unittest {
            auto hoge = new RendererProperty( new FrameLength(50) );
            assert( hoge.get(new FrameAt(0)) == RendererType.NoRendering );

            auto hoge2 = cast(RendererProperty)Property.create( hoge.json, hoge.frame );
            assert( hoge2.get(new FrameAt(0)) == hoge.get(new FrameAt(0)) );
        }
}
