/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.project.timeline.property.Easing;
import cafe.json,
       cafe.project.ObjectPlacingInfo;
import std.algorithm,
       std.conv,
       std.format;

debug = 0;

/+ イージング関数のベースクラス +/
abstract class EasingFunction
{
    private:
        float       st_value;
        float       ed_value;
        FrameLength dur;

    public:
        @property start    () { return st_value; }
        @property end      () { return ed_value; }
        @property duration () { return dur;      }

        @property start ( float s ) { st_value = s; }
        @property end   ( float e ) { ed_value = e; }

        this ( float s, float e, FrameLength d )
        {
            start = s;
            end = e;
            dur = d;
        }

        @property changeInValue ()
        {
            return end - start;
        }

        @property slope ()
        {
            return changeInValue/duration.value.to!float;
        }

        float at ( FrameAt f );


        /+ イージング登録用 +/
        struct RegisteredEasing
        {
            string name;
            string icon;
            EasingFunction delegate ( float s, float e, FrameLength d ) create;
        }
        static RegisteredEasing[] registeredEasings;

        template register ( T )
        {
            static this ()
            {
                RegisteredEasing r;
                r.name = T.name;
                r.icon = T.icon;
                r.create = delegate ( float s, float e, FrameLength d )
                {
                    return new T( s, e, d );
                };
                registeredEasings ~= r;
            }
        }

        static EasingFunction create ( string n, float s, float e, FrameLength d )
        {
            auto i = registeredEasings.countUntil
                !( x => x.name == n );
            if ( i == -1 ) throw new Exception( "Easing(%s) Undefined".format(n) );
            return registeredEasings[i].create( s, e, d );
        }
}

/+ イージング関数クラスの共通コンストラクタ +/
private template EasingFunctionConstructor ( alias NAME, alias ICON )
{
    public:
        static @property name () { return NAME; }
        static @property icon () { return ICON; }

        this ( float s, float e, FrameLength d )
        {
            super( s, e, d );
        }
}

/+ simple linear tweening +/
class LinearEasing : EasingFunction
{
    mixin register!LinearEasing;
    mixin EasingFunctionConstructor!("Linear","obj_ctg_others");
    public:
        override float at ( FrameAt current )
        {
            auto c = current.value;
            return slope*c + start;
        }
}

/+ quadratic easing in +/
class QuadraticEasingIn : EasingFunction
{
    mixin register!QuadraticEasingIn;
    mixin EasingFunctionConstructor!("QuadraticIn","obj_ctg_others");
    public:
        override float at ( FrameAt current )
        {
            auto c = current.value;
            auto t = c/duration.value.to!float;
            return changeInValue*t*t + start;
        }
}
