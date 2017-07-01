/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.gui.controls.timeline.TimelineEditor;
import cafe.project.ObjectPlacingInfo,
       cafe.project.timeline.Timeline,
       cafe.project.timeline.PlaceableObject;

debug = 1;

/+ Timelineのオブジェクトを移動/リサイズ +
 + 右クリック時の動作など                +/
class TimelineEditor
{
    private:
        enum Operation
        {
            None,
            Clicking,       // クリック中で操作されていない状態

            Move,           // 移動中
            ResizeStart,    // 左端をリサイズ中
            ResizeEnd       // 右端をリサイズ中
        }

        Timeline tl;
        uint     cur_frame;

        Operation op_type;
        int       op_offset_frame;
        int       op_offset_layer;

        PlaceableObject selecting;
        PlaceableObject operating;


        /+ オペレーション関連の変数を初期化 +/
        void clearOperationState ()
        {
            op_type = Operation.None;
            op_offset_frame = 0;
            op_offset_layer = 0;
            operating = null;
        }


        /+ プロパティレイヤの数 +/
        auto propertyLayerLength ()
        {
            return selecting ?
                selecting.propertyList.properties.length : 0;
        }

        /+ レイヤインデックスlがプロパティレイヤかどうか +/
        auto isPropertyLayer ( uint l )
        {
            auto sel_l = selecting.place.layer.value;

            if ( l <= sel_l )
                return false;
            else if ( l <= sel_l + propertyLayerLength )
                return true;
            else
                return false;
        }

        /+ レイヤインデックスからレイヤIDへ +/
        auto layerId ( uint l )
        {
            auto prop_len = propertyLayerLength;
            auto sel_l = selecting.place.layer.value;

            if ( l <= sel_l )
                return l;
            else if ( l <= sel_l + prop_len )
                return l - (sel_l + 1);
            else
                return l - prop_len;
        }

        /+ レイヤIDからレイヤインデックスへ +/
        auto layerIndex ( uint l, bool prop_layer )
        {
            auto sel_l = selecting.place.layer.value;
            if ( prop_layer )
                return l + sel_l + 1;
            else if ( l <= sel_l )
                return l;
            else
                return l + propertyLayerLength;
        }


        /+ タイムラインのオブジェクトがクリックされた時に呼ばれる +/
        auto onObjectLeftDown ( PlaceableObject obj, uint f, uint l )
        {
            op_offset_frame = f - obj.place.frame.start.value;
            op_offset_layer = l - obj.place.layer.value;
            return true;
        }

        /+ タイムラインのオブジェクトレイヤがクリックされた時に呼ばれる +/
        auto onObjectLayerLeftDown ( uint f, uint l )
        {
            auto obj = timeline[new FrameAt(f), new LayerId(l)];
            if ( obj )
                return onObjectLeftDown( obj, f, l );
            else
                return false;
        }

        /+ タイムラインのプロパティレイヤがクリックされた時に呼ばれる +/
        auto onPropertyLayerLeftDown ( uint f, uint l )
        {
            // TODO
            return true;
        }

    public:
        @property timeline () { return tl; }
        @property timeline ( Timeline tl )
        {
            if ( this.tl !is tl || !tl )
                clearOperationState;
            this.tl = tl;
        }
        @property currentFrame () { return cur_frame; }

        @property selectedObject () { return selecting; }
        @property operatedObject () { return operating; }

        this ( Timeline tl = null )
        {
            timeline = tl;
        }

        /+ タイムラインがクリックされたときに呼ばれる +/
        auto onLeftDown ( uint f, uint l )
        {
            clearOperationState;
            op_type = Operation.Clicking;

            auto result = isPropertyLayer(l) ?
                onPropertyLayerLeftDown( f, layerId(l) ):
                onObjectLayerLeftDown  ( f, layerId(l) );
            if ( !result ) cur_frame = f;

            return true;
        }

        /+ タイムラインがクリックされ終わった時に呼ばれる +/
        auto onLeftUp ( uint f, uint l )
        {
            if ( op_type == Operation.Clicking && operating )
                selecting = operating;
            clearOperationState;
            return true;
        }

        debug (1) unittest {
            auto hoge = new TimelineEditor();
        }
}
