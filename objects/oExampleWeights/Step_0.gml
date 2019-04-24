jukebox_step();

if (keyboard_check_pressed(ord("1")))
{
    jukebox_fade("stem 1", 0.5, (jukebox_get("stem 1", JUKEBOX.FADE_TARGET_GAIN) == 0.0)? 1.0 : 0.0, false);
}

if (keyboard_check_pressed(ord("2")))
{
    jukebox_fade("stem 2", 0.5, (jukebox_get("stem 2", JUKEBOX.FADE_TARGET_GAIN) == 0.0)? 1.0 : 0.0, false);
}

if (keyboard_check_pressed(ord("3")))
{
    jukebox_fade("stem 3", 0.5, (jukebox_get("stem 3", JUKEBOX.FADE_TARGET_GAIN) == 0.0)? 1.0 : 0.0, false);
}

if (keyboard_check_pressed(ord("4")))
{
    jukebox_fade("stem 4", 0.5, (jukebox_get("stem 4", JUKEBOX.FADE_TARGET_GAIN) == 0.0)? 1.0 : 0.0, false);
}