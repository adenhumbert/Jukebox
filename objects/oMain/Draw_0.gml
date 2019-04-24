var _string = "Jukebox " + __JUKEBOX_VERSION + "\n@jujuadams " + __JUKEBOX_DATE + "\nAudio: @slimefiend + @jujuadams";
draw_text(10, 10, _string);

var _string = "";
_string += "1: Queue \"sndLoop1\"  /  Fade in parallel track \"sndLoop1\"\n";
_string += "2: Queue \"sndLoop2\"  /  Fade in parallel track \"sndLoop2\"\n";
_string += "3: Queue \"sndLoop3\"  /  Fade in parallel track \"sndLoop3\"\n";
_string += "F: Queue \"sndEndBad\"\n";
_string += "G: Queue \"sndEndGood\"\n";
_string += "E: Swap example\n";
_string += "M: Mute music\n";
_string += "S: Play sound effect\n";
_string += "N: Mute sound effects\n";

draw_text(340, 10, _string);

draw_set_font(fDebug);
draw_text(10, 250, jukebox_debug_string());
draw_set_font(-1);