ds_list_clear(global.__jukebox_stack);

var _string = "";

var _name = global.__jukebox_master_name;
var _node = global.__jukebox_names[? _name ];

repeat(ds_list_size(global.__jukebox_stack)) _string += "    ";
_string += "\"" + _name + "\": "
        +  (_node[ JUKEBOX.MUTE ]? "[M] " : "")
        +  "trim=" + string_format(_node[ JUKEBOX.TRIM ], 1, 2)
        +  ", fade="+ string_format(_node[ JUKEBOX.GAIN ], 1, 2)
        +  ",   final=" + string_format(_node[ JUKEBOX.GAIN_INHERITED ], 1, 2)
        +  "\n";

ds_list_add(global.__jukebox_stack, 0);

repeat(999)
{
    if (ds_list_empty(global.__jukebox_stack)) break;
    
    var _parent_name = _name;
    var _node = global.__jukebox_names[? _name ];
    if (_node == undefined)
    {
        ds_list_delete(global.__jukebox_stack, 0);
        continue;
    }
    
    var _children = _node[ JUKEBOX.CHILDREN ];
    var _index = global.__jukebox_stack[| 0];
    if (_index >= array_length_1d(_children))
    {
        if (_index > 0) _string += "\n";
        _name = _node[ JUKEBOX.PARENT ];
        ds_list_delete(global.__jukebox_stack, 0);
        continue;
    }
    
    _name = _children[ _index ];
    global.__jukebox_stack[| 0]++;
    if (_name == undefined)
    {
        _name = _parent_name;
        continue;
    }
    
    _node = global.__jukebox_names[? _name ];
    if (_node == undefined)
    {
        _children[@ _index ] = undefined;
        _name = _parent_name;
        continue;
    }
    
    if (_node[ JUKEBOX.INSTANCE ] == undefined) continue;
    
    repeat(ds_list_size(global.__jukebox_stack)) _string += "    ";
    if (_node[JUKEBOX.TYPE] == __JUKEBOX_TYPE_AUDIO)
    {
        _string += "\"" + _name + "\": ";
        _string += (_node[ JUKEBOX.MUTE ]? "[M] " : "");
        _string += "trim=" + string_format(_node[ JUKEBOX.TRIM ], 1, 2);
        _string += ", fade=" +  string_format(_node[ JUKEBOX.GAIN ], 1, 2);
        
        if (_node[ JUKEBOX.WEIGHT_FACTOR ] != 1.0)
        {
            _string += ",   weight factor=" + string_format(_node[ JUKEBOX.WEIGHT_FACTOR ], 1, 2);
            _string += ", weight=" + string_format(_node[ JUKEBOX.WEIGHT ], 1, 2);
        }
        else
        {
            _string += ",   weight=" + string_format(_node[ JUKEBOX.WEIGHT ], 1, 2);
        }
        
        if (_node[ JUKEBOX.WEIGHT_MAX ] >= 0)
        {
            _string += ", max weight=" + string_format(_node[ JUKEBOX.WEIGHT_MAX ], 1, 2);
            _string += ", weight gain=" + string_format(_node[ JUKEBOX.WEIGHT_GAIN ], 1, 2);
        }
        
        _string += ",   final=" +  string_format(_node[ JUKEBOX.GAIN_INHERITED ], 1, 2);
        _string += ", \"" + string(audio_get_name(_node[ JUKEBOX.AUDIO ]));
        _string += "\"" + (_node[ JUKEBOX.LOOP ]? " [L]" : "");
        _string += " -> " + string_format(_node[ JUKEBOX.TIME_REMAINING ]/1000, 3, 2);
        _string += "s -> \"" + string(audio_get_name(_node[ JUKEBOX.QUEUED_AUDIO ]));
        _string += "\"" + (_node[ JUKEBOX.QUEUED_LOOP ]? " [L]" : "");
        _string += "\n";
    }
    else
    {
        _string += "\"" + _name + "\": ";
        _string += (_node[ JUKEBOX.MUTE ]? "[M] " : "");
        _string += "trim=" + string_format(_node[ JUKEBOX.TRIM ], 1, 2);
        _string += ", fade=" +  string_format(_node[ JUKEBOX.GAIN ], 1, 2);
        
        if (_node[ JUKEBOX.WEIGHT_FACTOR ] != 1.0)
        {
            _string += ",   weight factor=" + string_format(_node[ JUKEBOX.WEIGHT_FACTOR ], 1, 2);
            _string += ", weight=" + string_format(_node[ JUKEBOX.WEIGHT ], 1, 2);
        }
        else
        {
            _string += ",   weight=" + string_format(_node[ JUKEBOX.WEIGHT ], 1, 2);
        }
        
        if (_node[ JUKEBOX.WEIGHT_MAX ] >= 0)
        {
            _string += ", max weight=" + string_format(_node[ JUKEBOX.WEIGHT_MAX ], 1, 2);
            _string += ", weight gain=" + string_format(_node[ JUKEBOX.WEIGHT_GAIN ], 1, 2);
        }
        
        _string += ",   final=" +  string_format(_node[ JUKEBOX.GAIN_INHERITED ], 1, 2);
        _string += "\n";
    }
    
    ds_list_insert(global.__jukebox_stack, 0, 0);
}

_string = string_delete(_string, string_length(_string), 1); //Remove trailing newline

return _string;