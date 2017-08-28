/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.random;

/+ xorshiftを利用した乱数生成 +/
class Random ( T )
{
    private:
        T x,y,z,w;

    public:
        this ( T seed )
        {
            x = 12345 + seed;
            y = 67890 + seed;
            z = 98765 + seed;
            w = 43210 + seed;
        }

        T generate ( T min, T max )
        {
            if ( min >= max ) return min;
            auto t = (x^(x<<11));
            x = y; y = z; z = w;
            w = (w^(w>>19))^(t^(t>>8));
            return w%(max-min) + min;
        }
}
