/* ------------------------------------------------------------ *
 * Author : aoitofu <aoitofu@dr.com>                            *
 * This is part of CAFE ( https://github.com/aoitofu/CAFE ).    *
 * ------------------------------------------------------------ *
 * Please see /LICENSE.                                         *
 * ------------------------------------------------------------ */
#ifndef CAFE_GUI_HEADER
#define CAFE_GUI_HEADER

/* gui_load時に渡す情報構造体 */
struct GUI_LoadInfo
{
    int argc;
    char ** argv;

    char * app;
    char * version;
};

/* 関数前宣言 */
extern "C"
{
    void hello_gui_cpp ();
    int gui_load ( GUI_LoadInfo * );
}

#endif
