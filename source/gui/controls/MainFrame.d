/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.gui.controls.MainFrame;
import cafe.app,
       cafe.gui.Action,
       cafe.gui.controls.BMPViewer,
       cafe.gui.controls.ConfigTabs,
       cafe.gui.controls.PreviewPlayer,
       cafe.gui.controls.FragmentsExplorer,
       cafe.gui.controls.timeline.TimelineWidget;
import std.conv,
       std.format;
import dlangui;

class MainFrame : AppFrame
{
    enum AppName = "CAFEditor";
    enum AppVer  = "0.99 beta";
    enum AppText = "%s %s".format( AppName, AppVer );

    enum Layout = q{
        HorizontalLayout {
            VerticalLayout {
                HorizontalLayout {
                    PreviewPlayer { id:preview }
                    FragmentsExplorer { id:flagexp }
                }
                TimelineWidget { id:timeline }
            }
            ConfigTabs { id:tabs }
        }
    };

    private:
        struct LayoutInfo
        {
            float preview_height = 0.55;
            int   config_width   = 400;
        }
        LayoutInfo layout_info;

        MenuItem top_menu;

        PreviewPlayer     preview;
        TimelineWidget    timeline;
        ConfigTabs        tabs;
        FragmentsExplorer fragexp;

        /+ プロジェクトのインスタンスが変更された時に呼ばれる +/
        auto projectRefresh ()
        {
            auto p = Cafe.instance.curProject;
            Log.i( p is null );
            if ( p ) {
            } else {
                window.showMessageBox( "Hello", "start page" );
            }
            return true;
        }

    protected:
        override void initialize ()
        {
            _appName = AppText;
            super.initialize();
        }

        override Widget createBody ()
        {
            auto w = parseML( Layout );
            preview  = cast(PreviewPlayer)    w.childById( "preview" );
            timeline = cast(TimelineWidget)   w.childById( "timeline" );
            tabs     = cast(ConfigTabs)       w.childById( "tabs" );
            fragexp  = cast(FragmentsExplorer)w.childById( "flagexp" );
            return w;
        }

        override MainMenu createMainMenu ()
        {
            top_menu = new MenuItem;

            auto menu = new MenuItem( new Action( 1, "TopMenu_File" ) );
            with ( menu ) {
                add( Action_ProjectNew    );
                add( Action_ProjectOpen   );
                add( Action_ProjectSave   );
                add( Action_ProjectSaveAs );
                add( Action_ProjectClose  );
            }
            top_menu.add( menu );

            with ( menu = new MenuItem( new Action( 1, "TopMenu_Play" ) ) ) {
                add( Action_Play  );
                add( Action_Pause );
                add( Action_Stop  );

                add( Action_MoveBehind );
                add( Action_MoveAHead  );

                add( Action_ShiftBehind );
                add( Action_ShiftAHead  );
            }
            top_menu.add( menu );

            return new MainMenu( top_menu );
        }

        override ToolBarHost createToolbars ()
        {
            auto host = new ToolBarHost;
            auto bar  = host.getOrAddToolbar( "File" );
            with ( bar ) {
                addButtons( Action_ProjectSave   );
                addButtons( Action_ProjectSaveAs );
            }
            with ( bar = host.getOrAddToolbar( "Play" ) ) {
                addButtons( Action_Play  );
                addButtons( Action_Pause );
                addButtons( Action_Stop  );

                addButtons( Action_MoveBehind );
                addButtons( Action_MoveAHead  );

                addButtons( Action_ShiftBehind );
                addButtons( Action_ShiftAHead  );
            }
            return host;
        }

    public:
        this ()
        {
            super();
            statusLine.setStatusText( i18n.get( "Status_Boot" ) );
        }

        override void measure ( int w, int h )
        {
            preview.minHeight = (h * layout_info.preview_height).to!int;
            tabs.minWidth = layout_info.config_width;
            super.measure( w, h );
        }

        override bool handleAction ( const Action a )
        {
            import cafe.gui.Action;
            if ( a ) {
                switch ( a.id ) {
                    case EditorActions.ProjectRefresh:
                        return projectRefresh;
                    case EditorActions.PreviewRefresh:
                        return preview.handleAction( a );
                    case EditorActions.AddFrag:
                        return fragexp.handleAction( a );

                    default:
                        return super.handleAction( a );
                }
            }
            return false;
        }
}
