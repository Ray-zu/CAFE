/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.app;
import cafe.project.Project,
       cafe.gui.controls.BMPViewer;
import dlangui;

class Cafe
{
    private:
        Project cur_project;

        void setupGUI ()
        {
            embeddedResourceList.addResources(embedResourcesFromList!("resources.list")());

            Platform.instance.uiLanguage="en";
            Platform.instance.uiTheme="cafe";

            import dlangui.core.logger;
            Log.setLogLevel( LogLevel.Fatal );

            // テストコード
            auto window = Platform.instance.createWindow("Hello dlang!",null);
            window.mainWidget = new BMPViewer( "test", (new OpenGLRenderer).renderTest() );
            window.show;
        }

    public:
        @property curProject () { return cur_project; }

        this ( string[] args )
        {
            cur_project = null;
            setupGUI;
        }
}

mixin APP_ENTRY_POINT;
extern(C) int UIAppMain(string[] args)
{
    new Cafe( args );
    return Platform.instance.enterMessageLoop();
}
