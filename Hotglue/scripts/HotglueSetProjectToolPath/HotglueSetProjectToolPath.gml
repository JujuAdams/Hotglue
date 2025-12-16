// Feather disable all

/// @param path

function HotglueSetProjectToolPath(_path)
{
    static _system = __HotglueSystem();
    
    _system.__projectToolPath = _path;
}