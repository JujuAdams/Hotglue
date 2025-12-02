// Feather disable all

__LogSystem();

function __LogSystem()
{
    static _system = undefined;
    if (_system != undefined) return _system;
    
    _system = {};
    with(_system)
    {
        __logArray = [];
        __newWarnings = false;
        __status = "";
        
        HotglueSetTraceHandler(LogTrace);
        HotglueSetWarningHandler(LogWarning);
    }
    
    return _system;
}