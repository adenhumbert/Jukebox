/// @param [stepSize]

var _step_size = ((argument_count > 0) && (argument[0] != undefined))? argument[0] : __JUKEBOX_DEFAULT_STEP_SIZE;

var _per_second_factor = game_get_speed(gamespeed_microseconds)/1000000;



#region Build a list for order of operation

ds_list_clear(global.__jukebox_process_list);
var _name = global.__jukebox_master_name;
var _node = global.__jukebox_names[? _name ];
_node[@ JUKEBOX.__INDEX ] = 0;
ds_list_add(global.__jukebox_process_list, _name);
repeat(999)
{
    if (_name == undefined) break;
    
    var _parent_node = global.__jukebox_names[? _name ];
    var _parent_name = _name;
    var _children    = _parent_node[ JUKEBOX.CHILDREN ];
    
    var _index = _parent_node[@ JUKEBOX.__INDEX ];
    _parent_node[@ JUKEBOX.__INDEX ]++;
    if (_index >= array_length_1d(_children))
    {
        _name = _parent_node[ JUKEBOX.PARENT ];
        continue;
    }
    
    _name = _children[ _index ];
    if (_name == undefined)
    {
        _name = _parent_name;
        continue;
    }
    
    var _node = global.__jukebox_names[? _name ];
    if (_node == undefined)
    {
        _children[@ _index ] = undefined;
        _name = _parent_name;
        continue;
    }
    
    ds_list_add(global.__jukebox_process_list, _name);
    _node[@ JUKEBOX.__INDEX ] = 0;
}

#endregion



#region Handle per-node mute, trim, and fade; additionally, initalise weight

var _size = ds_list_size(global.__jukebox_process_list);
for(var _i = 0; _i < _size; _i++)
{
    var _name = global.__jukebox_process_list[| _i ];
    var _node = global.__jukebox_names[? _name ];
    
    //Handle mute gain
    var _mute      = _node[ JUKEBOX.MUTE      ];
    var _mute_gain = _node[ JUKEBOX.MUTE_GAIN ];
    if (_mute)
    {
        _mute_gain = max(0, _mute_gain - _step_size*JUKEBOX_MUTE_SPEED*_per_second_factor);
    }
    else
    {
        _mute_gain = min(1, _mute_gain + _step_size*JUKEBOX_MUTE_SPEED*_per_second_factor);
    }
    _node[@ JUKEBOX.MUTE_GAIN ] = _mute_gain;
    
    //Change trim value
    var _trim        = _node[ JUKEBOX.TRIM        ];
    var _trim_target = _node[ JUKEBOX.TRIM_TARGET ];
    if (_trim != _trim_target)
    {
        var _diff = clamp(_trim_target - _trim, -_per_second_factor*JUKEBOX_TRIM_SPEED, _per_second_factor*JUKEBOX_TRIM_SPEED);
        _trim = clamp(_trim + _step_size*_diff, 0, 1);
    }
    _node[@ JUKEBOX.TRIM ] = _trim;
    
    //Perform fade
    var _gain        = _node[ JUKEBOX.GAIN             ];
    var _fade_speed  = _node[ JUKEBOX.FADE_SPEED       ];
    var _fade_target = _node[ JUKEBOX.FADE_TARGET_GAIN ];
    if (_fade_speed > 0)
    {
        _gain = min(_fade_target, _gain + _fade_speed*_step_size);
    }
    else if (_fade_speed < 0)
    {
        _gain = max(_fade_target, _gain + _fade_speed*_step_size);
    }
    _node[@ JUKEBOX.GAIN ] = _gain;
    
    //Initialise weight
    _node[@ JUKEBOX.WEIGHT ] = 0;
}

#endregion



#region Find final gains (first pass)

var _size = ds_list_size(global.__jukebox_process_list);
for(var _i = 0; _i < _size; _i++)
{
    var _name = global.__jukebox_process_list[| _i ];
    var _node = global.__jukebox_names[? _name ];
    if (_node == undefined) continue;
    
    var _parent_name = _node[ JUKEBOX.PARENT ];
    var _parent_node = global.__jukebox_names[? _parent_name ];
    if (_parent_node == undefined) continue;
    var _parent_gain = _parent_node[ JUKEBOX.GAIN_INHERITED ];
    
    var _gain      = _node[ JUKEBOX.GAIN      ];
    var _mute_gain = _node[ JUKEBOX.MUTE_GAIN ];
    var _trim      = _node[ JUKEBOX.TRIM      ];
    
    var _final_gain = _trim*_mute_gain*_parent_gain*_gain;
    _node[@ JUKEBOX.GAIN_INHERITED ] = _final_gain;
    if (_node[ JUKEBOX.TYPE ] == __JUKEBOX_TYPE_AUDIO) _node[@ JUKEBOX.WEIGHT ] += _final_gain;
}

#endregion



#region Find weights

var _size = ds_list_size(global.__jukebox_process_list);
for(var _i = _size-1; _i >= 0; _i--)
{
    var _name = global.__jukebox_process_list[| _i ];
    var _node = global.__jukebox_names[? _name ];
    
    var _parent_name = _node[ JUKEBOX.PARENT ];
    var _parent_node = global.__jukebox_names[? _parent_name ];
    if (_parent_node == undefined) continue;
    
    var _weight = _node[ JUKEBOX.WEIGHT ]*_node[ JUKEBOX.WEIGHT_FACTOR ];
    _node[@ JUKEBOX.WEIGHT ] = _weight;
    
    var _weight_max = _node[ JUKEBOX.WEIGHT_MAX ];
    var _weight_gain = 1;
    if ((_weight > 0) && (_weight_max >= 0)) var _weight_gain = lerp(1.0, _weight_max / _weight, clamp(_node[ JUKEBOX.WEIGHT_RATIO ]*(_weight - _weight_max), 0.0, 1.0));
    _node[@ JUKEBOX.WEIGHT_GAIN ] = _weight_gain;
    
    _parent_node[@ JUKEBOX.WEIGHT ] += _weight_gain*_weight;
}

#endregion



#region Find final gains (second pass)

var _size = ds_list_size(global.__jukebox_process_list);
for(var _i = 0; _i < _size; _i++)
{
    var _name = global.__jukebox_process_list[| _i ];
    var _node = global.__jukebox_names[? _name ];
    if (_node == undefined) continue;
    
    var _parent_name = _node[ JUKEBOX.PARENT ];
    var _parent_node = global.__jukebox_names[? _parent_name ];
    if (_parent_node == undefined) continue;
    
    _node[@ JUKEBOX.GAIN_INHERITED ] *= _parent_node[ JUKEBOX.WEIGHT_GAIN ];
}

#endregion



#region Handle queuing, fades

var _size = ds_list_size(global.__jukebox_process_list);
for(var _i = 0; _i < _size; _i++)
{
    var _name = global.__jukebox_process_list[| _i ];
    var _node = global.__jukebox_names[? _name ];
    if (_node == undefined) continue;
    
    var _parent_name = _node[ JUKEBOX.PARENT ];
    var _parent_node = global.__jukebox_names[? _parent_name ];
    if (_parent_node == undefined) continue;
    var _parent_gain = _parent_node[ JUKEBOX.GAIN_INHERITED ];
    
    var _gain        = _node[ JUKEBOX.GAIN           ];
    var _final_gain  = _node[ JUKEBOX.GAIN_INHERITED ];
    var _instance    = _node[ JUKEBOX.INSTANCE       ];
    var _audio       = _node[ JUKEBOX.AUDIO          ];
    var _loop        = _node[ JUKEBOX.LOOP           ];
    var _next_audio  = _node[ JUKEBOX.QUEUED_AUDIO   ];
    var _next_loop   = _node[ JUKEBOX.QUEUED_LOOP    ];
    
    //If we're at our fade target, set the fade speed to 0
    if (_gain == _fade_target)
    {
        _node[@ JUKEBOX.FADE_SPEED ] = 0;
        
        if ((_fade_target <= 0) && _node[ JUKEBOX.DESTROY_AT_ZERO ])
        {
            if (JUKEBOX_DEBUG) show_debug_message("Jukebox: Node \"" + string(_name) + "\" has reached a final gain of zero");
            jukebox_stop(_name);
            continue;
        }
    }
    
    if (_node[ JUKEBOX.TYPE ] == __JUKEBOX_TYPE_AUDIO)
    {
        if (_instance == undefined)
        {
            _instance = audio_play_sound(_audio, _node[ JUKEBOX.PRIORITY ], _loop);
            audio_sound_gain(_instance, clamp(_final_gain, 0, JUKEBOX_MAX_GAIN), 0);
            _node[@ JUKEBOX.INSTANCE ] = _instance;
            
            if (JUKEBOX_DEBUG) show_debug_message("Jukebox: Playing \"" + string(audio_get_name(_audio)) + "\"" + (_loop? " (looped)" : "") + " on node \"" + _name + "\", child of \"" + string(_parent_name) + "\"");
        }
        else
        {
            //Handle the actual volume
            audio_sound_gain(_instance, clamp(_final_gain, 0, JUKEBOX_MAX_GAIN), JUKEBOX_FRAME_LEAD*__JUKEBOX_EXPECTED_FRAME_LENGTH/1000);
            
            //Handle queuing
            var _diff = 0;
            var _is_playing = audio_is_playing(_instance);
            if (_is_playing)
            {
                var _length   = audio_sound_length(_instance)*1000;
                var _position = audio_sound_get_track_position(_instance)*1000;
                _diff = _length - (_position mod _length);
            }
            
            _node[@ JUKEBOX.TIME_REMAINING ] = _diff;
            
            if (audio_exists(_next_audio))
            {
                var _play_queued = false;
                
                if (_diff <= JUKEBOX_FRAME_LEAD*__JUKEBOX_EXPECTED_FRAME_LENGTH/1000)
                {
                    _play_queued = true;
                }
                
                if (!_is_playing)
                {
                    show_debug_message("Jukebox: WARNING! Missed time-based cue to play next track");
                    _play_queued = true;
                }
                
                if (_play_queued)
                {
                    if ((_next_audio != _audio) || !_loop)
                    {
                        if (JUKEBOX_DEBUG) show_debug_message("Jukebox: Starting new instance of \"" + string(audio_get_name(_next_audio)) + "\" for node \"" + string(_name) + "\"");
                    
                        audio_stop_sound(_instance); //Positive destroy the old instance
                        _instance = audio_play_sound(_next_audio, _node[ JUKEBOX.PRIORITY ], _next_loop);
                        audio_sound_gain(_instance, clamp(_final_gain, 0, JUKEBOX_MAX_GAIN), 0);
                    
                        _node[@ JUKEBOX.AUDIO    ] = _next_audio;
                        _node[@ JUKEBOX.INSTANCE ] = _instance;
                        if (!_node[ JUKEBOX.QUEUED_LOOP ]) _node[@ JUKEBOX.QUEUED_AUDIO ] = -1;
                    }
                    
                    _node[@ JUKEBOX.LOOP ] = _node[@ JUKEBOX.QUEUED_LOOP ];
                }
            }
            else
            {
                if (!_is_playing)
                {
                    if (JUKEBOX_DEBUG) show_debug_message("Jukebox: Node \"" + string(_name) + "\" has ended");
                    jukebox_stop(_name);
                }
            }
        }
    }
}

#endregion



#region Clean up orphans

if (JUKEBOX_DEBUG_CLEAN_UP_ORPHANS)
{
    var _key = ds_map_find_first(global.__jukebox_names);
    while(_key != undefined)
    {
        var _node = global.__jukebox_names[? _key ];
        
        var _parent = _node[ JUKEBOX.PARENT ];
        if (_parent == undefined)
        {
            if (_key != global.__jukebox_master_name)
            {
                if (JUKEBOX_DEBUG) show_debug_message("Jukebox: \"" + string(_key) + "\" destroyed as it has an undefined parent");
                jukebox_stop(_key);
            }
            
            _key = ds_map_find_next(global.__jukebox_names, _key);
            continue;
        }
        
        var _parent_node = global.__jukebox_names[? _parent ];
        if (_parent_node == undefined)
        {
            if (JUKEBOX_DEBUG) show_debug_message("Jukebox: \"" + string(_key) + "\" destroyed as its parent \"" + string(_parent) + "\" does not exist");
            jukebox_stop(_key);
            
            _key = ds_map_find_next(global.__jukebox_names, _key);
            continue;
        }
        
        var _children = _parent_node[ JUKEBOX.CHILDREN ];
        var _size = array_length_1d(_children);
        for(var _i = 0; _i < _size; _i++) if (_children[ _i ] == _key) break;
        if (_i >= _size)
        {
            if (JUKEBOX_DEBUG) show_debug_message("Jukebox: \"" + string(_key) + "\" destroyed as its parent \"" + string(_parent) + "\" does have it as a child");
            jukebox_stop(_key);
        }
        
        _key = ds_map_find_next(global.__jukebox_names, _key);
    }
}

#endregion