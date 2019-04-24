var _string = "Jukebox " + __JUKEBOX_VERSION + "\n@jujuadams " + __JUKEBOX_DATE + "\nAudio: @jujuadams";
draw_text(10, 10, _string);

var _string = "";
_string += "1: Toggle stem \"sndStem1\"\n";
_string += "2: Toggle stem \"sndStem2\"\n";
_string += "3: Toggle stem \"sndStem3\"\n";
_string += "4: Toggle stem \"sndStem4\"\n";

draw_text(340, 10, _string);

draw_set_font(fDebug);
draw_text(10, 250, jukebox_debug_string());
draw_set_font(-1);