jukebox_init("master", 1.0, 1.0, 10);

jukebox_group("music", "master");
jukebox_play(sndLoop1, "music", "parallel 1", 1.0, true, false);
jukebox_play(sndLoop2, "music", "parallel 2", 0.0, true, false);
jukebox_play(sndLoop3, "music", "parallel 3", 0.0, true, false);