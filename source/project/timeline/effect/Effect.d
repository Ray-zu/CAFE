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
import std.algorithm,
       std.json;

debug = 0;

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

        @property Effect copy ( FrameLength );

        this ( Effect src, FrameLength f )
        {
            props = new PropertyList( src.propertyList, f );
        }

        this ( FrameLength f )
        {
            props = new PropertyList;
            initProperties(f);
        }

        this ( JSONValue j, FrameLength f )
        {
            props = new PropertyList( j["properties"], f );
        }

        override void initProperties ( FrameLength )
        {
            throw new Exception( "Not Implemented" );
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


        /+ エフェクト登録処理 +/

        struct RegisteredEffect
        {
            string name;
            Effect delegate ( JSONValue, FrameLength ) create;
        }
        static RegisteredEffect[] registeredEffects;

        /+ Effectを登録 +/
        template register ( T )
        {
            static this () {
                RegisteredEffect r;
                r.name = T.type;
                r.create = delegate ( JSONValue j, FrameLength f )
                {
                    return new T( j, f );
                };
                registeredEffects ~= r;
            }
        }

        /+ JSONからEffectを作成 +/
        static final Effect create ( JSONValue j, FrameLength f )
        {
            auto n = j["name"].str;
            auto i = registeredEffects.countUntil!( x => x.name == n );
            if ( i == -1 ) throw new Exception( "Undefined Effect" );
            return registeredEffects[i].create( j, f );
        }

        debug ( 1 ) unittest {
            import cafe.project.timeline.effect.custom.Position;
            auto hoge = new Position( new FrameLength(5) );
            assert(Effect.create(hoge.json, new FrameLength(7)).name == "Position");
        }
}
