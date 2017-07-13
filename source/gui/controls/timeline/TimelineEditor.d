/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.gui.controls.timeline.TimelineEditor;
import cafe.project.ObjectPlacingInfo,
       cafe.project.timeline.Timeline,
       cafe.project.timeline.PlaceableObject,
       cafe.project.timeline.property.Property,
       cafe.gui.controls.timeline.Line,
       cafe.gui.controls.timeline.ObjectEditor;
import std.algorithm,
       std.conv,
       std.format;
import dlangui;

/+ Timelineのオブジェクトを移動/リサイズ +
 + 右クリック時の動作など                +/
class TimelineEditor
{
    enum PropertyLineHeightMag         = 0.8;
    enum SelectedPropertyLineHeightMag = 3;

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

        Property selecting_prop;
        Property operating_prop;
        uint op_mp_index;


        /+ オペレーション関連の変数を初期化 +/
        void clearOperationState ()
        {
            op_type = Operation.None;
            op_offset_frame = 0;
            op_offset_layer = 0;
            operating = null;
            operating_prop = null;
            op_mp_index = 0;
        }


        /+ プロパティラインの数 +/
        auto propertyLineLength ()
        {
            return selecting ?
                selecting.propertyList.properties.length : 0;
        }

        /+ ラインインデックスlがプロパティレイヤかどうか +/
        auto isPropertyLine ( uint l )
        {
            if ( !selecting ) return false;

            auto sel_l = selecting.place.layer.value;
            if ( l <= sel_l )
                return false;
            else if ( l <= sel_l + propertyLineLength )
                return true;
            else
                return false;
        }

        /+ ラインインデックスからレイヤIDへ +/
        auto layerId ( uint l )
        {
            auto prop_len = propertyLineLength;
            auto sel_l = selecting ? selecting.place.layer.value : 0;

            if ( l <= sel_l )
                return l;
            else if ( l <= sel_l + prop_len )
                return l - sel_l - 1;
            else
                return l - prop_len;
        }

        /+ レイヤIDからラインインデックスへ +/
        auto lineIndex ( uint l, bool prop_layer )
        {
            auto sel_l = selecting ? selecting.place.layer.value : 0;
            if ( prop_layer )
                return l + sel_l + 1;
            else if ( l <= sel_l )
                return l;
            else
                return l + propertyLineLength;
        }


        /+ タイムライン上のオブジェクトを移動させる +/
        void moveObject ( PlaceableObject obj, int f, int l )
        {
            if ( isPropertyLine(l) )
                moveObject( obj, f, selecting.place.layer.value + propertyLineLength + 1 );
            else {
                auto layer   = layerId(l);
                auto len     = obj.place.frame.length.value;
                auto max_len = timeline.length.value;

                if ( f < 0 || l < 0 ) {
                    moveObject( obj, f < 0 ? 0 : f, l < 0 ? 0 : l );
                } else {
                    auto colls = timeline[
                        new FrameAt(f), new FrameLength(len), new LayerId(layer) ]
                        .remove!( x => x is obj );

                    if ( colls.length ) {
                        // TODO ほかオブジェクトとぶつかった時の動作
                        moveObject( obj, colls[$-1].place.frame.end.value, l );
                    } else {
                        obj.place.frame.move( new FrameAt(f) );
                        obj.place.layer.value = l;
                    }
                }
            }
        }


        /+ タイムラインのオブジェクトがクリックされた時に呼ばれる +/
        auto onObjectLeftDown ( PlaceableObject obj, uint f, uint l )
        {
            operating = obj;
            if ( obj.place.frame.start.value == f )
                op_type = Operation.ResizeStart;
            else if ( obj.place.frame.end.value-1 == f )
                op_type = Operation.ResizeEnd;
            else {
                op_offset_frame = f - obj.place.frame.start.value;
                op_offset_layer = l - obj.place.layer.value;
            }
            return true;
        }

        /+ タイムラインのオブジェクトラインがクリックされた時に呼ばれる +/
        auto onObjectLineLeftDown ( uint f, uint l )
        {
            auto obj = timeline[new FrameAt(f), new LayerId(l)];
            return obj ? onObjectLeftDown(obj,f,l) : false;
        }

        /+ タイムラインのプロパティラインがクリックされた時に呼ばれる +/
        auto onPropertyLineLeftDown ( uint f, uint l )
        {
            if ( selectedObject.place.frame.isInRange( new FrameAt(f) ) ) {
                operating_prop = selectedObject.propertyList.properties.values[l];
                return true;
            }
            return false;
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
        @property currentFrame ( uint f )
        {
            cur_frame = min( f, timeline.length.value-1 );
        }

        @property selectedObject () { return selecting; }
        @property operatedObject () { return operating; }

        @property operatedProperty () { return operating_prop; }
        @property selectedProperty () { return selecting_prop; }

        this ( Timeline tl = null )
        {
            timeline = tl;

            //TODO : テストコード
            selecting = tl.objects[0];
        }

        /+ ラインインデックスlのライン情報を返す +/
        auto lineInfo ( uint l )
        {
            auto id = layerId( l );
            if ( isPropertyLine(l) ) {
                auto   prop = selecting.propertyList.properties.values[id];
                string name = selecting.propertyList.properties.keys[id];
                return Line( l, prop, name,
                        prop == selecting_prop ?
                            (SelectedPropertyLineHeightMag) :
                            (PropertyLineHeightMag) );
            } else
                return Line( l, timeline[new LayerId(id)], "layer %d".format(id) );
        }

        /+ ----------------------------------------------- +
         + イベントハンドラ                                +
         + ----------------------------------------------- +/
        /+ タイムラインがクリックされたときに呼ばれる +/
        auto onLeftDown ( int f, int l, MouseEvent )
        {
            clearOperationState;
            op_type = Operation.Clicking;

            if ( l < 0 )
                currentFrame = f;
            else {
                auto result = isPropertyLine(l) ?
                    onPropertyLineLeftDown( f, layerId(l) ):
                    onObjectLineLeftDown  ( f, layerId(l) );
                if ( !result ) currentFrame = f;
            }

            return true;
        }

        /+ タイムライン上でカーソルが動いた時に呼ばれる +/
        auto onMouseMove ( int f, int l, MouseEvent e )
        {
            if ( op_type == Operation.None ) return false;

            if ( op_type == Operation.Clicking ) {
                op_type = Operation.Move;
                if ( operating && (e.keyFlags & KeyFlag.Control) ) {
                    operating = operating.copy;
                    timeline += operating;
                } else if ( operating_prop ) {

                }
            }

            if ( operating ) {
                switch ( op_type ) {
                    case Operation.Move:
                        moveObject( operating, f-op_offset_frame, l-op_offset_layer );
                        break;
                    case Operation.ResizeStart:
                        operating.resizeStart( new FrameAt( f ) );
                        break;
                    case Operation.ResizeEnd:
                        operating.resizeEnd( new FrameAt( f ) );
                        break;
                    default:
                }
            } else if ( operating_prop ) {

            } else {
                currentFrame = f;
            }
            return true;
        }

        /+ タイムラインがクリックされ終わった時に呼ばれる +/
        auto onLeftUp ( int f, int l, MouseEvent )
        {
            if ( op_type == Operation.Clicking ) {
                if ( operating ) {
                    selecting = selecting is operating ?
                        null : operating;
                } else if ( operating_prop && operating_prop.increasable ) {
                    selecting_prop = operating_prop;
                } else {
                    currentFrame = f;
                }
            }
            clearOperationState;
            return true;
        }
}
