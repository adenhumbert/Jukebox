/// @param name
/// @param maxWeight
/// @param ratio

var _name       = argument0;
var _max_weight = argument1;
var _ratio      = argument2;

if (_max_weight == undefined) _max_weight = -1;

var _node = global.__jukebox_names[? _name ];
if (_node == undefined) return true;

_node[@ JUKEBOX.WEIGHT_MAX   ] = _max_weight;
_node[@ JUKEBOX.WEIGHT_RATIO ] = clamp(_ratio, 0, 1);