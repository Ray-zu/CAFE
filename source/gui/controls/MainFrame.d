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
                add( Action_FileNew    );
                add( Action_FileOpen   );
                add( Action_FileSave   );
                add( Action_FileSaveAs );
                add( Action_FileClose  );
            }
            top_menu.add( file );
            return new MainMenu( top_menu );
        }

    public:
        this ()
        {
            super();
        }
}
