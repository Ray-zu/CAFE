/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.project.timeline.effect.Effect;
import cafe.project.timeline.property.PropertyList,
       cafe.project.timeline.PropertyKeepableObject,
       cafe.project.ObjectPlacingInfo,
       cafe.renderer.World;
import std.json;

/+ エフェクトクラス                                +
 + 多重継承の予定が無いので抽象クラスを使用します。+/
abstract class Effect : PropertyKeepableObject
{
    private:
        PropertyList props;

    public:
        @property string name ();

        override @property PropertyList propertyList ()
        {
            return props;
        }

        @property Effect copy ();

        this ( Effect src )
        {
            props = new PropertyList( src.propertyList );
        }

        this ( FrameLength f )
        {
            initProperties(f);
        }

        this ( JSONValue j, FrameLength f )
        {
            props = new PropertyList( j["properties"], f );
        }

        override @property JSONValue json ()
        {
            auto j = JSONValue( null );
            j["name"]       = JSONValue(name);
            j["properties"] = JSONValue(propertyList.json);
            return j;
        }

        /+ Worldクラスにエフェクトをかける +/
        World apply ( World w )
        {
            return w;
        }

        /+ JSONからEffectを作成 +/
        static final Effect create ( JSONValue j, FrameLength f )
        {
            throw new Exception( "Not Implemented" );
        }
}
