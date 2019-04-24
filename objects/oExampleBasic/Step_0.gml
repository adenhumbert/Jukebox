jukebox_step();

if (keyboard_check_pressed(ord("S")))
{
    var _sfx = jukebox_play(choose(sndSfx1, sndSfx2, sndSfx3, sndSfx3, sndSfx4), "sfx");
    jukebox_set_weight_factor(_sfx, 2.0);
}

if (keyboard_check_pressed(ord("N"))) jukebox_set_mute("sfx", !jukebox_get_mute("sfx"));
if (keyboard_check_pressed(ord("M"))) jukebox_set_mute("music", !jukebox_get_mute("music"));