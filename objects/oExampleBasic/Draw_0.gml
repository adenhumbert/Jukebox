var _string = "Jukebox " + __JUKEBOX_VERSION + "\n@jujuadams " + __JUKEBOX_DATE + "\nAudio: @slimefiend";
draw_text(10, 10, _string);

var _string = "";
_string += "S: Play sound effect\n";
_string += "N: Mute \"sfx\" group\n";
_string += "M: Mute \"music\" group";

draw_text(340, 10, _string);

draw_set_font(fDebug);
draw_text(10, 250, jukebox_debug_string());
draw_set_font(-1);