// Feather disable all

function __InterfaceSystem()
{
    static _system = undefined;
    if (_system != undefined) return _system;
    
    _system = {};
    with(_system)
    {
        __recentArray = [];
    }
    
    return _system;
}