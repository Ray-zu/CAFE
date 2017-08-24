/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.project.timeline.custom.Component;
import cafe.app,
       cafe.project.RenderingInfo,
       cafe.project.ObjectPlacingInfo,
       cafe.project.timeline.PlaceableObject,
       cafe.project.timeline.effect.EffectList,
       cafe.renderer.World,
       cafe.renderer.graphics.Bitmap,
       cafe.renderer.graphics.Color,
       cafe.renderer.polygon.Ngon,
       cafe.renderer.polygon.PolygonData;
import gl3n.linalg;
import std.algorithm,
       std.conv,
       std.format,
       std.json;

/+ コンポーネントオブジェクト +/
class Component : PlaceableObject
{
    mixin register!Component;

    public:
        static @property type ()
        {
            return "Component";
        }
        static @property icon ()
        {
            return "obj_ctg_others";
        }
        override @property string typeStr () { return type; }

        override @property string name ()
        {
            auto name = castedProperty!string
                ("Component").get(new FrameAt(0));
            return "%s (%s)".format( type, name );
        }

        override @property PlaceableObject copy ()
        {
            return new Component( this );
        }

        this ( Component src )
        {
            super( src );
        }

        this ( ObjectPlacingInfo f )
        {
            super( f );
        }

        this ( JSONValue j, FrameLength f )
        {
            super( j, f );
        }

        override void initProperties ( FrameLength f )
        {
            super.initProperties( f );

            import cafe.project.timeline.property.Property,
                   cafe.project.timeline.property.LimitedProperty;
            propertyList["Component"] = new PropertyBase!string( f, "" );
            propertyList["Frame"    ] = new LimitedProperty!int( f, 0, 1, 0 );
        }

        override World createWorld ( RenderingInfo r, FrameAt f )
        {
            World w = new World;

            auto name = castedProperty!string("Component").get(f);
            auto proj = Cafe.instance.curProject;

            if ( name !in proj.componentList.components ) return w;
            auto comp = proj.componentList[name];

            import cafe.project.timeline.property.LimitedProperty;
            (cast(LimitedProperty!int)propertyList["Frame"])
                .max = comp.timeline.length.value-1;

            auto rframe = new FrameAt( castedProperty!int("Frame").get(f) );
            rframe.value =  min( rframe.value, comp.timeline.length.value-1 );
            auto rend = comp.render( rframe );
            auto size = vec2( comp.width.to!float, comp.height.to!float );

            auto trans = Transform(
                    vec3( 0.0, 0.0, 0.0 ),
                    vec3( 0.0, 0.0, 0.0 ),
                    vec3( 1.0, 1.0, 1.0 )
            );

            w += new Rectangle( size, trans, rend.bitmap );
            //TODO : 音声の追加

            return w;
        }
}
