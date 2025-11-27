// Feather disable all

/// @param relativePath

function __HotglueDetermineResourceConstructor(_relativePath)
{
    static _mapping = {
        "animcurves" : __HotglueResourceScript,
        "extensions" : __HotglueResourceScript,
        "fonts"      : __HotglueResourceScript,
        "notes"      : __HotglueResourceScript,
        "objects"    : __HotglueResourceScript,
        "particles"  : __HotglueResourceScript,
        "paths"      : __HotglueResourceScript,
        "rooms"      : __HotglueResourceScript,
        "scripts"    : __HotglueResourceScript,
        "sequences"  : __HotglueResourceScript,
        "shaders"    : __HotglueResourceScript,
        "sounds"     : __HotglueResourceScript,
        "sprites"    : __HotglueResourceScript,
        "tilesets"   : __HotglueResourceScript,
        "timelines"  : __HotglueResourceScript,
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