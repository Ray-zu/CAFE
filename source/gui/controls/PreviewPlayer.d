/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.gui.controls.PreviewPlayer;
import cafe.gui.Action,
       cafe.gui.BitmapLight,
       cafe.gui.controls.BMPViewer,
       cafe.project.Project,
       cafe.renderer.Renderer;
import std.format;
import core.memory,
       core.thread;
import dlangui,
       dlangui.widgets.metadata;

mixin( registerWidgets!PreviewPlayer );

/+ プレビューの再生制御と描画 +/
class PreviewPlayer : VerticalLayout
{
    enum Preview = q{
        HorizontalLayout {
            layoutWidth:FILL_PARENT;
            HSpacer {}
            BMPViewer { id:preview }
            HSpacer {}
        }
    };
    enum PlayControler = q{
        HorizontalLayout {
            id:controlers;
            layoutWidth:FILL_PARENT;
            HSpacer {}
            ImageButton { id:shift_behind; drawableId:shift_behind }
            ImageButton { id:move_behind; drawableId:move_behind }
            ImageButton { id:play; drawableId:play }
            ImageButton { id:pause; drawableId:pause }
            ImageButton { id:stop; drawableId:stop }
            ImageButton { id:move_ahead; drawableId:move_ahead }
            ImageButton { id:shift_ahead; drawableId:shift_ahead }
            HSpacer {}
        }
    };

    private:
        Project pro;

        BMPViewer preview;
        ImageButton shift_behind;
        ImageButton move_behind;
        ImageButton play;
        ImageButton pause;
        ImageButton stop;
        ImageButton move_ahead;
        ImageButton shift_ahead;

        ThreadGroup render_th;

        void frameChanged ()
        {
            if ( !project ) return;

            /+ 別スレッドから翻訳内容を取得できない為事前に取得 +/
            const rendering      = i18n.get("Status_Rendering");
            const rendered       = i18n.get("Status_Rendered");
            const rendering_fail = i18n.get( "Status_RenderingFailure" );

            void render () {
                synchronized {
                    try {
                        window.mainWidget.handleAction(
                                new Action_UpdateStatus( rendering ) );
                        auto r = project.render;
                        preview.drawable = r.bitmap;
                        window.invalidate;
                        window.mainWidget.handleAction(
                                new Action_UpdateStatus( rendered ) );
                    } catch ( Exception e ) {
                        auto mes = rendering_fail ~ e.msg.to!dstring;
                        window.mainWidget.handleAction(
                                new Action_UpdateStatus( mes ) );
                    }
                }
            }
            render_th.create( &render );
        }

    public:
        @property project () { return pro; }
        @property project ( Project p )
        {
            pro = p;
            handleAction( Action_PreviewRefresh );
        }

        this ( string id = "" )
        {
            super( id );
            styleId = "PREVIEW_PLAYER";
            minWidth = short.max;

            addChild( parseML( Preview ) );
            addChild( parseML( PlayControler ) );

            pro          = null;
            preview      = cast(BMPViewer)  childById( "preview" );

            /+ ボタンの取得とアクションの設定 +/
            shift_behind = cast(ImageButton)childById( "shift_behind" );
            move_behind  = cast(ImageButton)childById( "move_behind" );
            play         = cast(ImageButton)childById( "play" );
            pause        = cast(ImageButton)childById( "pause" );
            stop         = cast(ImageButton)childById( "stop" );
            move_ahead   = cast(ImageButton)childById( "move_ahead" );
            shift_ahead  = cast(ImageButton)childById( "shift_ahead" );
            shift_behind.action = Action_ShiftBehind;
            move_behind .action = Action_MoveBehind ;
            play        .action = Action_Play       ;
            pause       .action = Action_Pause      ;
            stop        .action = Action_Stop       ;
            move_ahead  .action = Action_MoveAHead  ;
            shift_ahead .action = Action_ShiftAHead ;

            render_th = new ThreadGroup;
        }

        ~this ()
        {
            render_th.joinAll;
        }

        override bool handleAction ( const Action a )
        {
            import cafe.gui.Action;
            switch ( a.id ) {
                case EditorActions.PreviewRefresh:
                    frameChanged;
                    return true;
                default:
            }
            return false;
        }

        override void measure ( int w, int h )
        {
            super.measure( w, h );
            preview.minHeight =
                measuredHeight - childById("controlers").measuredHeight;
        }
}
