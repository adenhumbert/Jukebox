jukebox_init("master", 1.0, 1.0, 10);

jukebox_group("group", "master");
jukebox_set_max_weight("group", 1.0);
jukebox_play(sndStem1, "group", "stem 1", 1.0, true, false);
jukebox_play(sndStem2, "group", "stem 2", 1.0, true, false);
jukebox_play(sndStem3, "group", "stem 3", 1.0, true, false);
jukebox_play(sndStem4, "group", "stem 4", 1.0, true, false);
jukebox_set_weight_factor("stem 1", 2.0);
jukebox_set_weight_factor("stem 2", 2.0);