// Feather disable all

function HotglueGetCachePath()
{
    static _system = __HotglueSystem();
    
    return _system.__cachePath;
}