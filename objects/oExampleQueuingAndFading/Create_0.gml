jukebox_init("master", 1.0, 1.0, 10);

jukebox_play(sndStart, "master", "music", 0.0);
jukebox_fade("music", 1/17.5, 1.0);
jukebox_queue("music", sndLoop1, true);