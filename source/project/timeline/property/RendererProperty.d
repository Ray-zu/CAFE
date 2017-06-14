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

/+ レンダラの種類 +/
enum RendererType
{
    NoRendering = "NoRendering"     // レンダリングをせずポリゴン集合体をそのまま返す
}

/+ レンダリングプロパティ +/
class RendererProperty : PropertyBase!RendererType
{
    public:
        override @property Property copy ()
        {
            return new RendererProperty( this );
        }

        this ( RendererProperty src )
        {
            super( src );
        }

        this ( FrameLength f )
        {
            super( f, RendererType.NoRendering );
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
}
