/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.gui.controls.CustomEditor;
import cafe.renderer.Renderer;
import std.algorithm,
       std.array,
       std.conv;
import dlangui,
       dlangui.widgets.metadata;

mixin( registerWidgets!RendererSelector );

/+ レンダラーセレクタ +/
class RendererSelector : ComboBox
{
    public:
        this ( string id = "" )
        {
            auto list = Renderer.registeredRenderers
                .map!( x => x.name.to!dstring ).array;
            super( id, list );
        }
}
