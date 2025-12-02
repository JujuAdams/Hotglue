// Feather disable all

/// @param string

function __HotglueWarning(_string)
{
    static _system = __HotglueSystem();
    
    _system.__warningHandler(_string);
}