/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.app;
import cafe.project.Project,
       cafe.gui.Action,
       cafe.gui.controls.MainFrame,
       cafe.gui.controls.BMPViewer,
       cafe.renderer.custom.OpenGLRenderer;
import dlangui;

class Cafe
{
    static __gshared Cafe instance = null;
    private:
        Project cur_project  = null;
        MainFrame main_frame = null;

        void loadLibraries ()
        {
            import derelict.opengl3.gl3;
            import derelict.openal.al;
            import derelict.glfw3.glfw3;
            DerelictGL3.load();
            DerelictGLFW3.load();
            DerelictAL.load();
            glfwInit();
            glfwWindowHint( GLFW_VISIBLE, GL_FALSE );
        }

        void setupGUI ()
        {
            embeddedResourceList.addResources(embedResourcesFromList!("resources.list")());

            Platform.instance.uiLanguage="en";
            Platform.instance.uiTheme="cafe";

            Log.setStdoutLogger;
            Log.setLogLevel( LogLevel.Info );

            auto bmp = (new OpenGLRenderer).renderTest;
            auto window = Platform.instance.createWindow(
                    "Hello dlang!",null,WindowFlag.Resizable,bmp.width,bmp.height);

            auto view = new BMPViewer( "test" );
            view.drawable( bmp );

            window.mainWidget = view;
            window.windowOrContentResizeMode = WindowOrContentResizeMode.shrinkWidgets;
            window.windowIcon = drawableCache.getImage( "cafe_logo" );
            window.show;
        }

    public:
        @property mainFrame  () { return main_frame; }

        @property curProject () { return cur_project; }
        @property curProject ( Project p )
        {
            cur_project = p;
            //handleAction( Action_ProjectRefresh );
        }

        this ( string[] args )
        {
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

mixin APP_ENTRY_POINT;
extern(C) int UIAppMain(string[] args)
{
    Cafe.instance = new Cafe( args );

    if ( args.length == 0 ) Cafe.instance.curProject = null;
    // TODO 引数ファイルのプロジェクト読み込み

    return Platform.instance.enterMessageLoop();
}
