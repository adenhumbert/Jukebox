jukebox_init("master", 1.0, 1.0, 10);

jukebox_group("music", "master");
jukebox_group("sfx", "master");

jukebox_play(sndLoop1, "music", "loop", 0.3, true);