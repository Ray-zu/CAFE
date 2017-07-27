/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.gui.controls.StartPanel;
import cafe.app,
       cafe.gui.Action,
       cafe.gui.controls.MainFrame,
       cafe.project.Project;
import std.conv;
import dlangui,
       dlangui.dialogs.dialog;

/+ プロジェクトが開いてない時に表示されるダイアログ +/
class StartPanel : Dialog
{
    enum DlgFlag = DialogFlag.Popup;
    enum Layout  = q{
        VerticalLayout {
            HorizontalLayout {
                layoutWidth : FILL_PARENT;
                HSpacer {}
                TextWidget { id:header; fontSize:24 }
                HSpacer {}
            }
            MultilineTextWidget { id:releaseNote }
            HorizontalLayout {
                layoutWidth : FILL_PARENT;
                HSpacer {}
                Button { id:test; text:"test project"; fontSize:16; minWidth:300 }
                HSpacer {}
            }
            HorizontalLayout {
                layoutWidth : FILL_PARENT;
                HSpacer {}
                Button { id:create; text:ProjectNew; fontSize:16; minWidth:300 }
                HSpacer {}
            }
            HorizontalLayout {
                layoutWidth : FILL_PARENT;
                HSpacer {}
                Button { id:close; text:"Close"; fontSize:16; minWidth:300 }
                HSpacer {}
            }
        }
    };

    public:
        this ( Window w = null )
        {
            super( UIString.fromRaw(""), w, DlgFlag );
            show;
        }

        override void initialize ()
        {
            addChild( parseML(Layout) );
            childById( "header" ).text = MainFrame.AppText;
            childById( "releaseNote" ).text = import( "releaseNote.txt" );
            childById( "test" ).click = delegate ( Widget w )
            {
                // TODO test
                close( null );
                auto p = new Project;
                auto tl = p.componentList.root.timeline;
                tl.length.value = 100;
                import cafe.project.ObjectPlacingInfo;
                import cafe.project.timeline.custom.NullObject;
                tl += new NullObject( new ObjectPlacingInfo(new LayerId(0),
                        new FramePeriod( tl.length, new FrameAt(0), new FrameLength(50) )) );
                Cafe.instance.curProject = p;
                return true;
            };
            childById( "create" ).click = delegate ( Widget w )
            {
                close( null );
                Cafe.instance.handleAction( Action_ProjectNew );
                return true;
            };
            childById( "close" ).click = delegate ( Widget w )
            {
                close( null );
                return true;
            };
        }
}

/+ プロジェクト新規作成ダイアログ +/
class ProjectCreationPanel : Dialog
{
    enum DlgFlag = DialogFlag.Popup;
    enum Layout = q{
        VerticalLayout {
            minWidth : 400;
            TextWidget { id:error; textColor:0xff0000 }
            TableLayout {
                layoutWidth:FILL_PARENT;
                colCount:2;
                TextWidget { text:"Author" }
                EditLine { id:author }
                TextWidget { text:"Copyright" }
                EditLine { id:copyright }
                TextWidget { text:"SampleRate" }
                EditLine { id:sample_rate }
                TextWidget { text:"FPS" }
                EditLine { id:fps }
            }
        }
    };
    enum Caption = "New Project";

    public:
        this ( Window w = null )
        {
            super( UIString.fromRaw(Caption), w, DlgFlag );
            show;
        }

        override void initialize ()
        {
            addChild( parseML( Layout ) );
            addChild( createButtonsPanel(
                        [ACTION_OK,ACTION_CANCEL], 0, 0 ) );
            childById( "sample_rate" ).text = Project.DefaultSamplingRate.to!dstring;
            childById( "fps" )        .text = Project.DefaultFPS.to!dstring;

            dialogResult = delegate ( Dialog d, const Action a )
            {
                if ( a.id == ACTION_OK.id ) {
                    auto temp = new Project;
                    temp.author       = childById("author").text.to!string;
                    temp.copyright    = childById("copyright").text.to!string;
                    temp.samplingRate = childById( "sample_rate" ).text.to!uint;
                    temp.fps          = childById( "fps" ).text.to!uint;
                    Cafe.instance.curProject = temp;
                }
            };
        }

        override bool handleAction ( const Action a )
        {
            if ( a.id == ACTION_OK.id ) {
                try {
                    childById( "sample_rate" ).text.to!uint;
                    childById( "fps"         ).text.to!uint;
                } catch ( Exception e ) {
                    childById( "error" ).text = "Illegal Number"d;
                    return false;
                }
            }
            return super.handleAction( a );
        }
}
