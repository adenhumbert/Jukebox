jukebox_init("master", 1.0, 1.0, 10);

jukebox_group("music", "master", 1.0, false);
jukebox_group("sfx", "master", 1.0, false);

jukebox_group("queue example", "music", 0.0, false);
jukebox_fade("queue example", 1/17.5, 0.0);
jukebox_play(sndStart, "queue example", "queue");
jukebox_queue("queue", sndLoop1, true);

jukebox_group("parallel example", "music", 0.0, false);
jukebox_play(sndLoop1, "parallel example", "parallel 1", 1.0, true, false);
jukebox_play(sndLoop2, "parallel example", "parallel 2", 0.0, true, false);
jukebox_play(sndLoop3, "parallel example", "parallel 3", 0.0, true, false);

//jukebox_group("stem example", "music", 1.0, false);
//jukebox_set_max_weight("stem example", 1.0);
//jukebox_play(sndStem1, "stem example", "stem 1", 1.0, true, false);
//jukebox_set_weight_factor("stem 1", 2.0);
//jukebox_play(sndStem2, "stem example", "stem 2", 1.0, true, false);
//jukebox_play(sndStem3, "stem example", "stem 3", 1.0, true, false);
//jukebox_play(sndStem4, "stem example", "stem 4", 1.0, true, false);