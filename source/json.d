/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.json;
import std.conv,
       std.json;

@property getFloating ( JSONValue j )
{
    if ( j.type == JSON_TYPE.FLOAT )
        return j.floating;
    if ( j.type == JSON_TYPE.INTEGER )
        return j.integer.to!float;
    throw new Exception( "JSONValue is not a floating" );
}

@property getUInteger ( JSONValue j )
{
    if ( j.type == JSON_TYPE.INTEGER )
        return j.integer.to!uint;
    if ( j.type == JSON_TYPE.UINTEGER )
        return j.uinteger.to!uint;
    throw new Exception( "JSONValue is not an uinteger" );
}
