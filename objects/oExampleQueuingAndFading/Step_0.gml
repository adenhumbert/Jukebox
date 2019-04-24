jukebox_step();

if (keyboard_check_pressed(ord("1"))) jukebox_queue("music", sndLoop1, true);
if (keyboard_check_pressed(ord("2"))) jukebox_queue("music", sndLoop2, true);
if (keyboard_check_pressed(ord("3"))) jukebox_queue("music", sndLoop3, true);
if (keyboard_check_pressed(ord("F"))) jukebox_queue("music", sndEndBad, false);
if (keyboard_check_pressed(ord("G"))) jukebox_queue("music", sndEndGood, false);