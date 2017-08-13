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
       cafe.gui.controls.ConfigDialogs,
       cafe.gui.controls.ConfigTabs,
       cafe.gui.controls.PreviewPlayer,
       cafe.gui.controls.FragmentsExplorer,
       cafe.gui.controls.StartPanel,
       cafe.gui.controls.TimelineTabs,
       cafe.project.Project;
import std.conv,
       std.file,
       std.format,
       std.json;
import dlangui,
       dlangui.dialogs.dialog,
       dlangui.dialogs.filedlg;

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
                TimelineTabs { id:timeline }
            }
            ConfigTabs { id:tabs }
        }
    };

    private:
        struct LayoutInfo
        {
            int preview_height = 350;
            int config_width   = 400;
        }
        LayoutInfo layout_info;

        MenuItem top_menu;

        PreviewPlayer     preview;
        TimelineTabs      timeline;
        ConfigTabs        tabs;
        FragmentsExplorer fragexp;

        string last_saved_file;

        auto open ()
        {
            auto dlg = new FileDialog( UIString.fromRaw("Open project"),
                    window, null, FileDialogFlag.FileMustExist | FileDialogFlag.Open );
            dlg.dialogResult = delegate ( Dialog d, const Action a )
            {
                if ( a.id != ACTION_OPEN.id ) return;
                auto file = dlg.filename;
                auto text = file.readText;
                Cafe.instance.curProject = new Project( parseJSON(text) );
                last_saved_file = file;
            };
            dlg.show;
        }

        auto save ()
        {
            if ( last_saved_file.exists ) {
                auto text = Cafe.instance.curProject.json.to!string;
                last_saved_file.write( text );
            } else saveAs;
        }

        auto saveAs ()
        {
            auto dlg = new FileDialog( UIString.fromRaw("Save project"),
                    window, null, FileDialogFlag.ConfirmOverwrite | FileDialogFlag.Save );
            dlg.dialogResult = delegate ( Dialog d, const Action a )
            {
                if ( a.id != ACTION_SAVE.id ) return;
                auto file = dlg.filename;
                auto text = Cafe.instance.curProject.json.to!string;
                file.write( text );
                last_saved_file = file;
            };
            dlg.show;
        }

        /+ プロジェクトのインスタンスが変更された時 +/
        auto projectRefresh ()
        {
            auto p = Cafe.instance.curProject;
            preview.project = p;
            timeline.project = p;
            tabs.propertyEditor.project = p;
            tabs.componentTree .project = p;

            if ( p ) {
            } else {
                new StartPanel( window );
            }
            handleAction( Action_PreviewRefresh );
            handleAction( Action_ObjectRefresh  );
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
            timeline = cast(TimelineTabs)     w.childById( "timeline" );
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
            last_saved_file = "";
        }

        override void measure ( int w, int h )
        {
            preview.minHeight  = layout_info.preview_height;
            timeline.maxHeight = h - preview.minHeight;
            tabs.minWidth      = layout_info.config_width;
            super.measure( w, h );
        }

        override bool handleAction ( const Action a )
        {
            import cafe.gui.Action;
            if ( a ) {
                switch ( a.id ) with( EditorActions ) {
                    case ProjectNew:
                        new ProjectConfigDialog( true, window ).show;
                        return true;
                    case ProjectOpen:
                        open;
                        return true;
                    case ProjectSave:
                        save;
                        return true;
                    case ProjectSaveAs:
                        saveAs;
                        return true;

                    case ProjectRefresh:
                        return projectRefresh;
                    case PreviewRefresh:
                        return preview.handleAction( a );
                    case ObjectRefresh:
                        tabs.propertyEditor.updateWidgets;
                        return true;
                    case CompTreeRefresh:
                        return tabs.componentTree.handleAction( a );
                    case TimelineRefresh:
                        timeline.updateWidgets;
                        return true;

                    case ChangeFrame:
                        handleAction( Action_ObjectRefresh );
                        handleAction( Action_PreviewRefresh );
                        return true;

                    case CompTreeOpen:
                        timeline.addTab(
                                tabs.componentTree.items.selectedItem.id );
                        return true;

                    default:
                        return super.handleAction( a );
                }
            }
            return false;
        }
}
