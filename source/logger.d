/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.logger;
import std.conv,
       std.format;

enum LogLevel
{
    Info,
    Warn,
    Error
}

struct Log
{
    static auto i (T)( T v, string f = __FILE__, ulong l = __LINE__ )
    {
        return this( v, LogLevel.Info );
    }

    static auto w (T)( T v, string f = __FILE__, ulong l = __LINE__ )
    {
        return this( v, LogLevel.Warn );
    }

    static auto e (T)( T v, string f = __FILE__, ulong l = __LINE__ )
    {
        return this( v, LogLevel.Error );
    }

    string file;
    ulong  line;
    LogLevel level;
    string   text;

    this (T)( T v, LogLevel l, string f = __FILE__, ulong l = __LINE__ )
    {
        file = f;
        line = l;
        level = l;
        text  = v.to!string;
    }

    @property content ()
    {
        auto lvl_str = level.to!string;
        return "%s at %d [%s] %s".format( file, line, lvl_str, text );
    }
}

class Logger
{
    __gshared static Logger instance;

    static initialize ()
    {
        instance = new Logger;
    }

    private:
        Log[] stack;

        this ()
        {
            stack = [];
        }

    public:
        void push ( Log l )
        {
            stack ~= l;
        }

        string pop ()
        {
            if ( stack.length == 0 ) return "";
            auto str = stack[$-1].content;
            stack = stack[1 .. $];
            return str;
        }
}
alias CafeLog = Logger.instance;
