// Feather disable all

function LogGetNewWarnings()
{
    static _system = __LogSystem();
    
    return _system.__newWarnings;
}