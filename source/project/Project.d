/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.project.Project;
import cafe.project.ComponentList;
import std.conv,
       std.json;

debug = 1;

/+ プロジェクト全体のデータ +/
class Project
{
    private:
        ComponentList component_list;

    public:
        string author;
        string copyright;
        uint   samplingRate;

        @property componentList () { return component_list; }

        this ( Project src )
        {
            component_list = new ComponentList( src.componentList );
        }

        this ()
        {
            component_list = new ComponentList;
        }

        this ( JSONValue j )
        {
            component_list = new ComponentList( j["components"] );
            author = j["author"].str;
            copyright = j["copyright"].str;
            samplingRate = j["samplingRate"].uinteger.to!uint;
        }

        /+ JSON出力 +/
        @property json ()
        {
            JSONValue j;
            j["components"]   = JSONValue(componentList.json);
            j["author"]       = JSONValue(author);
            j["copyright"]    = JSONValue(copyright);
            j["samplingRate"] = JSONValue(samplingRate);
            return j;
        }

        debug (1) unittest {
            auto hoge = new Project;
            auto hoge2 = new Project(hoge.json);
            assert( hoge.json.to!string == hoge2.json.to!string );
        }
}
