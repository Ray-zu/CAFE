/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.gui.controls.ConfigDialogs;
import cafe.app,
       cafe.project.Project;
import std.regex;
import dlangui,
       dlangui.dialogs.dialog,
       dlangui.dialogs.settingsdialog;

/+ プロジェクト設定 +/
class ProjectConfigDialog : Dialog
{
    enum DlgFlag = DialogFlag.Popup;
    enum Caption = "Project Configure";

    enum Layout = q{
        TableLayout {
            colCount:2;
            TextWidget { text:"author" }
            EditLine { id:author; minWidth:200 }
            TextWidget { text:"copyright" }
            EditLine { id:copyright; minWidth:200 }
            TextWidget { text:"samplingRate" }
            EditLine { id:sampling_rate }
            TextWidget { text:"FPS" }
            EditLine { id:fps }
        }
    };

    private:
        Project pro;

    public:
        @property project () { return pro; }

        this ( bool create, Window w = null )
        {
            super( UIString.fromRaw(Caption), w, DlgFlag );
            addChild( parseML( Layout ) );
            addChild( new TextWidget( "error" ) )
                .textColor( 0xff0000 ).alignment( Align.HCenter );
            addChild( createButtonsPanel(
                        [ACTION_CANCEL,ACTION_OK], 0, false ) );
            pro = create ? null : Cafe.instance.curProject;
        }

        override void initialize ()
        {
            if ( !project ) pro = new Project;
            childById("author"       ).text = project.author      .to!dstring;
            childById("copyright"    ).text = project.copyright   .to!dstring;
            childById("sampling_rate").text = project.samplingRate.to!dstring;
            childById("fps"          ).text = project.fps         .to!dstring;
        }

        override bool handleAction ( const Action a )
        {
            bool matchInteger ( string v )
            {
                enum IntegerRegex = `^\d+$`;
                return cast(bool)v.match( IntegerRegex );
            }

            if ( a.id == ACTION_OK.id ) {
                project.author       = childById("author"      ).text.to!string;
                project.copyright    = childById("copyright"   ).text.to!string;

                auto rate = childById("sampling_rate").text.to!string;
                auto fps  = childById("fps"          ).text.to!string;
                if ( matchInteger(rate) && matchInteger(fps) ) {
                    project.samplingRate = rate.to!uint;
                    project.fps          = fps .to!uint;
                } else {
                    childById("error").text = "Invalid Integer"d;
                    return false;
                }
                Cafe.instance.curProject = project;
            }
            return super.handleAction( a );
        }
}
