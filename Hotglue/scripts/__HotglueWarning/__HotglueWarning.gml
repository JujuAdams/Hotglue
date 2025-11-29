// Feather disable all

/// @param string

function __HotglueWarning(_string)
{
    static _system = __HotglueSystem();
    
    show_debug_message($"Hotglue: Warning! {_string}");
    
    _system.__warningHandler($"Hotglue: {_string}");
}