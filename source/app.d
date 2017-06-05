/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.app;
import cafe.project.Project,
       cafe.gui.controls.PropertyGrid;
import dlangui;

mixin APP_ENTRY_POINT;

class Cafe
{
    private:
        Project cur_project;

        void setupGUI ()
        {
            Platform.instance.uiLanguage="en";
            Platform.instance.uiTheme="theme_dark";

            import dlangui.core.logger;
            Log.setLogLevel( LogLevel.Fatal );

            // テストコード
            auto window = Platform.instance.createWindow("Hello dlang!",null);
            window.mainWidget = new PropertyGrid;
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

extern(C) int UIAppMain(string[] args)
{
    new Cafe( args );
    return Platform.instance.enterMessageLoop();
}
