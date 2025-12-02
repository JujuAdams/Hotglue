// Feather disable all

/// @param string

function __HotglueTrace(_string)
{
    static _system = __HotglueSystem();
    
    _system.__traceHandler(_string);
}