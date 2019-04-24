jukebox_step();

if (keyboard_check_pressed(ord("1")))
{
    jukebox_fade("parallel 1", 1/3, 1.0);
    jukebox_fade("parallel 2", 1/3, 0.0);
    jukebox_fade("parallel 3", 1/3, 0.0);
}

if (keyboard_check_pressed(ord("2")))
{
    jukebox_fade("parallel 1", 1/3, 0.0);
    jukebox_fade("parallel 2", 1/3, 1.0);
    jukebox_fade("parallel 3", 1/3, 0.0);
}

if (keyboard_check_pressed(ord("3")))
{
    jukebox_fade("parallel 1", 1/3, 0.0);
    jukebox_fade("parallel 2", 1/3, 0.0);
    jukebox_fade("parallel 3", 1/3, 1.0);
}