/// @param name
/// @param weight

var _name   = argument0;
var _weight = argument1;

var _node = global.__jukebox_names[? _name ];
if (_node == undefined) return true;

_node[@ JUKEBOX.WEIGHT_FACTOR ] = _weight;