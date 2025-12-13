// Feather disable all

function LogGetStatus()
{
    static _system = __LogSystem();
    
    return _system.__status;
}