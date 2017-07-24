/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.app;
import cafe.project.Project,
       cafe.gui.Action,
       cafe.gui.controls.MainFrame;
import dlangui;

mixin APP_ENTRY_POINT;

class Cafe
{
    static Cafe instance = null;
    private:
        Project cur_project;
        MainFrame main_frame;

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

            Log.setStdoutLogger;
            Log.setLogLevel( LogLevel.Info );

            auto window = Platform.instance.createWindow("Hello dlang!",null,WindowFlag.Resizable,800,500);
            window.mainWidget = main_frame = new MainFrame;
            window.windowOrContentResizeMode = WindowOrContentResizeMode.shrinkWidgets;
            window.show;
        }

    public:
        @property mainFrame  () { return main_frame; }

        @property curProject () { return cur_project; }
        @property curProject ( Project p )
        {
            cur_project = p;
            handleAction( Action_ProjectRefresh );
        }

        this ( string[] args )
        {
            curProject = null;
            loadLibraries;
            setupGUI;
        }

        @property void setStatus ( dstring v )
        {
            mainFrame.statusLine.setStatusText( v );
        }

        @property bool handleAction ( const Action a )
        {
            return mainFrame.handleAction( a );
        }
}

extern(C) int UIAppMain(string[] args)
{
    Cafe.instance = new Cafe( args );
    return Platform.instance.enterMessageLoop();
}
