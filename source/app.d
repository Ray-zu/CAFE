/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.app;
import cafe.project.Project,
       cafe.gui.controls.timeline.TimelineWidget;
import dlangui;

mixin APP_ENTRY_POINT;

class Cafe
{
    private:
        Project cur_project;

        void loadLibraries ()
        {
            import derelict.opengl3.gl3;
            import derelict.openal.al;
            DerelictGL3.load();
            DerelictAL.load();
        }

        void setupGUI ()
        {
            embeddedResourceList.addResources(embedResourcesFromList!("resources.list")());

            Platform.instance.uiLanguage="en";
            Platform.instance.uiTheme="cafe";

            // テストコード
            auto window = Platform.instance.createWindow("Hello dlang!",null);
            window.mainWidget = new TimelineWidget( "test" );
            window.show;
        }

    public:
        @property curProject () { return cur_project; }

        this ( string[] args )
        {
            cur_project = null;
            loadLibraries;
            setupGUI;
        }
}

extern(C) int UIAppMain(string[] args)
{
    new Cafe( args );
    return Platform.instance.enterMessageLoop();
}
