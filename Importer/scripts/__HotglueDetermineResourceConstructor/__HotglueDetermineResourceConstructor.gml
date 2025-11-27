// Feather disable all

/// @param relativePath

function __HotglueDetermineResourceConstructor(_relativePath)
{
    static _mapping = {
        "animcurves" : __HotglueResourceUnhandled,
        "extensions" : __HotglueResourceUnhandled,
        "fonts"      : __HotglueResourceUnhandled,
        "notes"      : __HotglueResourceNote,
        "objects"    : __HotglueResourceUnhandled,
        "particles"  : __HotglueResourceUnhandled,
        "paths"      : __HotglueResourceUnhandled,
        "rooms"      : __HotglueResourceUnhandled,
        "scripts"    : __HotglueResourceScript,
        "sequences"  : __HotglueResourceUnhandled,
        "shaders"    : __HotglueResourceUnhandled,
        "sounds"     : __HotglueResourceUnhandled,
        "sprites"    : __HotglueResourceUnhandled,
        "tilesets"   : __HotglueResourceUnhandled,
        "timelines"  : __HotglueResourceUnhandled,
    }
    
    var _pos = string_pos("/", _relativePath);
    if (_pos <= 0)
    {
        __HotglueError($"Resource type could not be determined for \"{_relativePath}\"");
    }
    
    var _directory = string_copy(_relativePath, 1, _pos-1);
    var _type = _mapping[$ _directory];
    
    if (_type == undefined)
    {
        __HotglueError($"Resource type could not be determined for \"{_relativePath}\"");
    }
    
    return _type;
}