/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.project.Project;
import cafe.project.ObjectPlacingInfo,
       cafe.project.ComponentList,
       cafe.renderer.custom.OpenGLRenderer;
import std.conv,
       std.json;

debug = 0;

/+ プロジェクト全体のデータ +/
class Project
{
    enum DefaultSamplingRate = 44100;
    enum DefaultFPS          = 30;

    private:
        ComponentList component_list;

    public:
        string author;
        string copyright;
        uint   samplingRate;
        uint   fps;

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
            fps = j["fps"].uinteger.to!uint;
        }

        @property selectingObject ()
        {
            return componentList.selecting ?
                componentList.selecting.timeline.selecting :
                null ;
        }

        auto render ( FrameAt f = null )
        {
            auto root = componentList.root;
            auto frame = f ? f : new FrameAt( root.timeline.frame );
            auto w = root.width;
            auto h = root.height;
            return componentList.root.render( frame, new OpenGLRenderer );
        }

        /+ JSON出力 +/
        @property json ()
        {
            JSONValue j;
            j["components"]   = JSONValue(componentList.json);
            j["author"]       = JSONValue(author);
            j["copyright"]    = JSONValue(copyright);
            j["samplingRate"] = JSONValue(samplingRate);
            j["fps"]          = JSONValue( fps );
            return j;
        }

        debug (1) unittest {
            auto hoge = new Project;
            auto hoge2 = new Project(hoge.json);
            assert( hoge.json.to!string == hoge2.json.to!string );
        }
}
