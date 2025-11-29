// Feather disable all

/// @param string

function __HotglueTrace(_string)
{
    static _system = __HotglueSystem();
    
    _string = $"Hotglue: {_string}";
    show_debug_message(_string);
    
    _system.__traceHandler(_string);
}