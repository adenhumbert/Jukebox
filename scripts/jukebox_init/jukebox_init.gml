/// @param masterName
/// @param masterGain
/// @param masterTrim
/// @param masterPriority

var _name     = argument0;
var _gain     = argument1;
var _trim     = argument2;
var _priority = argument3;

#macro __JUKEBOX_VERSION  "1.2.0"
#macro __JUKEBOX_DATE     "2019/04/24"

#macro __JUKEBOX_EXPECTED_FRAME_LENGTH  game_get_speed(gamespeed_microseconds)  //In microseconds
#macro __JUKEBOX_DEFAULT_STEP_SIZE      (delta_time/__JUKEBOX_EXPECTED_FRAME_LENGTH)

#macro __JUKEBOX_NOT_PLAYING  -1
#macro __JUKEBOX_TYPE_GROUP    0
#macro __JUKEBOX_TYPE_AUDIO    1

//Constants used for jukebox_get()
enum JUKEBOX
{
    GAIN,             // 0
    GAIN_INHERITED,   // 1
    
    AUDIO,            // 2
    LOOP,             // 3
    INSTANCE,         // 4
    TIME_REMAINING,   // 5
    QUEUED_AUDIO,     // 6
    QUEUED_LOOP,      // 7
    
    FADE_SPEED,       // 8
    FADE_TARGET_GAIN, // 9
    DESTROY_AT_ZERO,  //10
    
    MUTE,             //11
    MUTE_GAIN,        //12
    
    TRIM,             //13
    TRIM_TARGET,      //14
    
    WEIGHT_FACTOR,    //15
    WEIGHT,           //16
    WEIGHT_MAX,       //17
    WEIGHT_RATIO,     //18
    WEIGHT_GAIN,      //19
    
    NAME,             //20
    PARENT,           //21
    TYPE,             //22
    PRIORITY,         //23
    CHILDREN,         //24
    __INDEX,          //25
    __SIZE            //26
}

global.__jukebox_master_name  = _name;
global.__jukebox_trim         = ds_map_create();
global.__jukebox_names        = ds_map_create();
global.__jukebox_stack        = ds_list_create();
global.__jukebox_process_list = ds_list_create();

var _node = array_create(JUKEBOX.__SIZE);
_node[@ JUKEBOX.GAIN             ] = _gain;
_node[@ JUKEBOX.GAIN_INHERITED   ] = _gain;

_node[@ JUKEBOX.AUDIO            ] = -1;
_node[@ JUKEBOX.INSTANCE         ] = -1;
_node[@ JUKEBOX.TIME_REMAINING   ] =  0;
_node[@ JUKEBOX.QUEUED_AUDIO     ] = -1;
_node[@ JUKEBOX.QUEUED_LOOP      ] = false;

_node[@ JUKEBOX.FADE_SPEED       ] = 0;
_node[@ JUKEBOX.FADE_TARGET_GAIN ] = _gain;
_node[@ JUKEBOX.DESTROY_AT_ZERO  ] = false;

_node[@ JUKEBOX.MUTE             ] = false;
_node[@ JUKEBOX.MUTE_GAIN        ] = 1.0;

_node[@ JUKEBOX.TRIM             ] = _trim;
_node[@ JUKEBOX.TRIM_TARGET      ] = _trim;

_node[@ JUKEBOX.WEIGHT_FACTOR    ] =  1;
_node[@ JUKEBOX.WEIGHT           ] =  1;
_node[@ JUKEBOX.WEIGHT_MAX       ] = -1;
_node[@ JUKEBOX.WEIGHT_RATIO     ] =  1.0;
_node[@ JUKEBOX.WEIGHT_GAIN      ] =  1;

_node[@ JUKEBOX.NAME             ] = global.__jukebox_master_name;
_node[@ JUKEBOX.PARENT           ] = undefined;
_node[@ JUKEBOX.TYPE             ] = __JUKEBOX_TYPE_GROUP;
_node[@ JUKEBOX.PRIORITY         ] = _priority;
_node[@ JUKEBOX.CHILDREN         ] = [];
global.__jukebox_names[? global.__jukebox_master_name ] = _node;