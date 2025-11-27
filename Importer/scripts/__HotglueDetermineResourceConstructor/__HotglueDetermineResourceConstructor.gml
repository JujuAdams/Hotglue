// Feather disable all

/// @param relativePath

function __HotglueDetermineResourceConstructor(_relativePath)
{
    static _mapping = {
        "animcurves" : __HotglueResourceAnimCurve,
        "extensions" : __HotglueResourceUnhandled,
        "fonts"      : __HotglueResourceFont,
        "notes"      : __HotglueResourceNote,
        "objects"    : __HotglueResourceUnhandled,
        "particles"  : __HotglueResourcePartSys,
        "paths"      : __HotglueResourcePath,
        "rooms"      : __HotglueResourceUnhandled,
        "scripts"    : __HotglueResourceScript,
        "sequences"  : __HotglueResourceSequence,
        "shaders"    : __HotglueResourceShader,
        "sounds"     : __HotglueResourceSound,
        "sprites"    : __HotglueResourceUnhandled,
        "tilesets"   : __HotglueResourceTileset,
        "timelines"  : __HotglueResourceTimeline,
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