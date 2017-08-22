/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.app;
import cafe.config,
       cafe.project.Project,
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
            DerelictGL3.load();
            DerelictAL.load();

            import cafe.renderer.custom.OpenGLRenderer;
            OpenGLRenderer.initialize;
        }

        void setupGUI ()
        {
            embeddedResourceList.addResources(embedResourcesFromList!("resources.list")());

            Platform.instance.uiLanguage="en";
            Platform.instance.uiTheme="cafe";

            Log.setStdoutLogger;

            auto window = Platform.instance.createWindow(
                    AppText, null, WindowFlag.Resizable, 800,500 );
            window.mainWidget = main_frame = new MainFrame;
            window.windowOrContentResizeMode = WindowOrContentResizeMode.shrinkWidgets;
            window.windowIcon = drawableCache.getImage( "cafe_logo" );
            window.onCanClose = &mainFrame.canClose;
            window.show;
        }

    public:
        @property mainFrame  () { return main_frame; }

        @property curProject () { return cur_project; }
        @property curProject ( Project p )
        {
            cur_project = p;
            mainFrame.handleAction( Action_ProjectRefresh );
        }

        this ( string[] args )
        {
            loadLibraries;
            setupGUI;
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
