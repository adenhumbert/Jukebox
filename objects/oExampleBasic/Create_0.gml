jukebox_init("master", 1.0, 1.0, 10);

jukebox_group("music", "master", 0.3); //Play audio at 30% volume if they're in this group
jukebox_play(sndLoop1, "music", "loop", 1.0, true);

jukebox_group("sfx", "master");