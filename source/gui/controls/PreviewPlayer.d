/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.gui.controls.PreviewPlayer;
import cafe.gui.Action,
       cafe.gui.controls.BMPViewer;
import dlangui,
       dlangui.widgets.metadata;

mixin( registerWidgets!PreviewPlayer );

/+ プレビューの再生制御と描画 +/
class PreviewPlayer : VerticalLayout
{
    enum Preview = q{
        BMPViewer { id:preview }
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
        BMPViewer preview;
        ImageButton shift_behind;
        ImageButton move_behind;
        ImageButton play;
        ImageButton pause;
        ImageButton stop;
        ImageButton move_ahead;
        ImageButton shift_ahead;

    public:
        this ( string id = "" )
        {
            super( id );
            styleId = "PREVIEW_PLAYER";
            minWidth = short.max;

            addChild( parseML( Preview ) );
            addChild( parseML( PlayControler ) );

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
        }

        override void measure ( int w, int h )
        {
            super.measure( w, h );
            preview.minHeight =
                measuredHeight - childById("controlers").measuredHeight;
        }
}
