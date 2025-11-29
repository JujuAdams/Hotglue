// Feather disable all

/// @param function

function HotglueSetWarningHandler(_function)
{
    static _system = __HotglueSystem();
    
    _system.__warningHandler = _function;
}