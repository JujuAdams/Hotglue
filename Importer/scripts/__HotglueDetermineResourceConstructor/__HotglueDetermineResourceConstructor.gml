// Feather disable all

/// @param relativePath

function __HotglueDetermineResourceConstructor(_relativePath)
{
    static _mapping = {
        "animcurves" : __HotglueResourceAnimCurve,
        "extensions" : __HotglueResourceExtension,
        "fonts"      : __HotglueResourceFont,
        "notes"      : __HotglueResourceNote,
        "objects"    : __HotglueResourceObject,
        "particles"  : __HotglueResourcePartSys,
        "paths"      : __HotglueResourcePath,
        "rooms"      : __HotglueResourceRoom,
        "roomui"     : __HotglueResourceRoomUI,
        "scripts"    : __HotglueResourceScript,
        "sequences"  : __HotglueResourceSequence,
        "shaders"    : __HotglueResourceShader,
        "sounds"     : __HotglueResourceSound,
        "sprites"    : __HotglueResourceSprite,
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