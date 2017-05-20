/+ ------------------------------------------------------------ +
+ Author : aoitofu <aoitofu@dr.com>                            +
+ This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
+ ------------------------------------------------------------ +
+ Please see /LICENSE.                                         +
+ ------------------------------------------------------------ +/
module cafe.project.timeline.PropertyKeepableObject;
import std.conv,
       std.traits;

/+ プロパティ情報 +/
class Property ( T )
    if ( isType!T )
{
    private:
        T val;

    public:
        this ( T init ) {
            val = init;
        }

        @property value () { return val; }

        void fromString ( string v )
        {
            throw new Exception( "Not Implemented" );
        }

        override @property string toString ()
        {
            return val.to!string;
        }
}

/+ プロパティを保持できるオブジェクトの共通部分 +/
template PropertyKeepableObject (  )
{
}
