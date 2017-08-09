/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.gui.ColorDrawBufNoGC;
import core.stdc.stdlib;
import dlangui;

/+ dlanguiのColorDrawBufクラスをデータをポインタにして +
 + リファクタリングしたもの                            +/
class ColorDrawBufNoGC : ColorDrawBufBase {
    //uint[] _buf;
    uint* _buf = null;

    /// create ARGB8888 draw buf of specified width and height
    this(int width, int height) {
        resize(width, height);
    }
    /// create copy of ColorDrawBuf
    this(ColorDrawBuf v) {
        this(v.width, v.height);
        //_buf.length = v._buf.length;
        foreach(i; 0 .. _dx*_dy)
            _buf[i] = v._buf[i];
    }
    /// create resized copy of ColorDrawBuf
    this(ColorDrawBuf v, int dx, int dy) {
        this(dx, dy);
        fill(0xFFFFFFFF);
        drawRescaled(Rect(0, 0, dx, dy), v, Rect(0, 0, v.width, v.height));
    }

    ~this ()
    {
        destroy;
    }

    void destroy ()
    {
        if ( _buf != null ) free( cast(void*) _buf );
        _buf = null;
        _dx = 0;
        _dy = 0;
    }

    void invertAndPreMultiplyAlpha() {
        //foreach(ref pixel; _buf) {
        auto len = _dx * _dy;
        for ( int i = 0; i < len; i++ ) {
            uint a = (_buf[i] >> 24) & 0xFF;
            uint r = (_buf[i] >> 16) & 0xFF;
            uint g = (_buf[i] >> 8) & 0xFF;
            uint b = (_buf[i] >> 0) & 0xFF;
            a ^= 0xFF;
            if (a > 0xFC) {
                r = ((r * a) >> 8) & 0xFF;
                g = ((g * a) >> 8) & 0xFF;
                b = ((b * a) >> 8) & 0xFF;
            }
            _buf[i] = (a << 24) | (r << 16) | (g << 8) | (b << 0);
        }
    }

    void invertAlpha() {
        //foreach(ref pixel; _buf)
        //    pixel ^= 0xFF000000;
        auto len = _dx * _dy;
        for ( auto i = 0; i < len; i++ )
            _buf[i] ^= 0xFF000000;
    }

    void invertByteOrder() {
        //foreach(ref pixel; _buf) {
        //    pixel = (pixel & 0xFF00FF00) |
        //        ((pixel & 0xFF0000) >> 16) |
        //        ((pixel & 0xFF) << 16);
        //}
        auto len = _dx * _dy;
        for ( auto i = 0; i < len; i++ ) {
            _buf[i] ^= (_buf[i] & 0xFF00FF00) |
                ((_buf[i] & 0xFF0000) >> 16) |
                ((_buf[i] & 0xFF) << 16);
        }
    }

    // for passing of image to OpenGL texture
    void invertAlphaAndByteOrder() {
        //foreach(ref pixel; _buf) {
        //    pixel = ((pixel & 0xFF00FF00) |
        //        ((pixel & 0xFF0000) >> 16) |
        //        ((pixel & 0xFF) << 16));
        //    pixel ^= 0xFF000000;
        //}
        auto len = _dx * _dy;
        for ( auto i = 0; i < len; i++ ) {
            _buf[i] = ((_buf[i] & 0xFF00FF00) |
                ((_buf[i] & 0xFF0000) >> 16) |
                ((_buf[i] & 0xFF) << 16));
            _buf[i] ^= 0xFF000000;
        }
    }
    override uint * scanLine(int y) {
        if (y >= 0 && y < _dy)
            return _buf + _dx * y;
        return null;
    }
    override void resize(int width, int height) {
        if (_dx == width && _dy == height)
            return;
        destroy;

        _dx = width;
        _dy = height;

        //_buf = _dx * _dy;
        if ( _dx*_dy > 0 )
            _buf = cast(uint*) malloc( _dx * _dy * uint.sizeof );

        resetClipping();
    }
    override void fill(uint color) {
        if (hasClipping) {
            fillRect(_clipRect, color);
            return;
        }
        int len = _dx * _dy;
        uint * p = _buf;
        foreach(i; 0 .. len)
            p[i] = color;
    }
    override DrawBuf transformColors(ref ColorTransform transform) {
        if (transform.empty)
            return this;
        bool skipFrame = hasNinePatch;
        ColorDrawBuf res = new ColorDrawBuf(_dx, _dy);
        if (hasNinePatch) {
            NinePatch * p = new NinePatch;
            *p = *_ninePatch;
            res.ninePatch = p;
        }
        foreach(int y; 0 .. _dy) {
            uint * srcline = scanLine(y);
            uint * dstline = res.scanLine(y);
            bool allowTransformY = !skipFrame || (y !=0 && y != _dy - 1);
            foreach(int x; 0 .. _dx) {
                bool allowTransformX = !skipFrame || (x !=0 && x != _dx - 1);
                if (!allowTransformX || !allowTransformY)
                    dstline[x] = srcline[x];
                else
                    dstline[x] = transform.transform(srcline[x]);
            }
        }
        return res;
    }
}
