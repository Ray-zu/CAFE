/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.gui.controls.BMPViewer;
import cafe.gui.BitmapLight,
       cafe.renderer.graphics.Bitmap;
import core.sync.mutex,
       core.thread;
import dlangui,
       dlangui.widgets.metadata;

mixin( registerWidgets!BMPViewer );

/+ BMPを表示するウィジェット                           +
 + このウィジェットが複数ある際の動作は保証されません。+/
class BMPViewer : Widget
{
    __gshared BitmapLight converted = null;

    private:
        ThreadGroup convert_th;
        Mutex       mutex;

        BitmapLight buf;

    public:
        bool hoge = false;
        @property void drawable ( BMP b )
        {
            import cafe.renderer.graphics.Color;
            if ( hoge ) {
                auto bmp = b.bitmap;
                auto col = RGBA( 1.0,0.0,0.0,1.0 );
                for ( auto i = 0; i < 10000; i++ )
                    bmp[i] = col;
            }
            hoge = !hoge;

            convert_th.create( ()
            {
                auto temp = new BitmapLight( b );
                synchronized ( mutex ) {
                    converted = temp;
                    Log.i( "converted" );
                    window.invalidate;
                }
            } );
        }

        this ( string id = "" )
        {
            super( id );
            backgroundColor = 0x000000;

            convert_th = new ThreadGroup;
            mutex = new Mutex;
            buf = null;
        }

        ~this ()
        {
            convert_th.joinAll;
        }

        override void measure ( int pw, int ph )
        {
            if ( buf ) {
                auto w = buf.width;
                auto h = buf.height;
                auto z = minHeight / h.to!float;

                w = (w * z).to!int;
                h = (h * z).to!int;
                measuredContent( pw, ph, w, h );
            } else super.measure( pw, ph );
        }

        override void onDraw ( DrawBuf b )
        {
            super.onDraw( b );

            synchronized ( mutex ) {
                if ( converted ) {
                    buf = converted;
                    converted = null;
                }
            }
            if ( !buf ) return;
            b.drawRescaled( pos, buf, Rect( 0, 0, buf.width, buf.height ) );
        }
}
