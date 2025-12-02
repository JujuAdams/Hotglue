// Feather disable all

function LogGetStatus(_stringOrFunction)
{
    static _system = __LogSystem();
    
    return _system.__status;
}