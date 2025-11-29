// Feather disable all

function __HttpRequestSystem()
{
    static _system = undefined;
    if (_system != undefined) return _system;
    
    _system = {};
    with(_system)
    {
        __currentHttpRequest = undefined;
        __httpRequestArray = [];
    }
    
    return _system;
}