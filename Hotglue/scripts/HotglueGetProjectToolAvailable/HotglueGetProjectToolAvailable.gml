// Feather disable all

function HotglueGetProjectToolAvailable()
{
    static _system = __HotglueSystem();
    
    return HotglueGetProjectToolExists() && HotglueGetExecuteShellAvailable();
}