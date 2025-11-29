// Feather disable all

/// @param function

function HotglueSetTraceHandler(_function)
{
    static _system = __HotglueSystem();
    
    _system.__traceHandler = _function;
}