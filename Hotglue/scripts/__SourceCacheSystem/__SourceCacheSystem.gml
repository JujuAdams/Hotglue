// Feather disable all

function __SourceCacheSystem()
{
    static _system = undefined;
    if (_system != undefined) return _system;
    
    _system = {};
    with(_system)
    {
        __dictionary = {};
        __array = [];
    }
    
    return _system;
}