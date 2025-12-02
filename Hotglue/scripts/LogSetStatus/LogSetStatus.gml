// Feather disable all

/// @param stringOrFunction

function LogSetStatus(_stringOrFunction)
{
    static _system = __LogSystem();
    
    _system.__status = _stringOrFunction;
}