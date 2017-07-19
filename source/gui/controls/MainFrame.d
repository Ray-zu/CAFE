/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.gui.controls.MainFrame;
import cafe.gui.Action;
import std.conv,
       std.format;
import dlangui;

class MainFrame : AppFrame
{
    enum AppName = "CAFEditor";
    enum AppVer  = "0.99 beta";
    enum AppText = "%s %s".format( AppName, AppVer );

    private:
        MenuItem top_menu;

    protected:
        override void initialize ()
        {
            _appName = AppText;
            super.initialize();
        }

        override MainMenu createMainMenu ()
        {
            top_menu = new MenuItem;
            auto file = new MenuItem( new Action( 1, "TopMenu_File" ) );
            with ( file ) {
                add( Action_ProjectNew    );
                add( Action_ProjectOpen   );
                add( Action_ProjectSave   );
                add( Action_ProjectSaveAs );
                add( Action_ProjectClose  );
            }
            top_menu.add( file );
            return new MainMenu( top_menu );
        }

        override ToolBarHost createToolbars ()
        {
            auto host = new ToolBarHost;
            auto bar  = host.getOrAddToolbar( "Standard" );
            with ( bar ) {
                addButtons( Action_ProjectSave   );
                addButtons( Action_ProjectSaveAs );
            }
            return host;
        }

    public:
        this ()
        {
            super();
        }
}
