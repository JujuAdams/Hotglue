// Feather disable all

function HotglueGetLocalhostPort()
{
    static _system = __HotglueSystem();
    
    return _system.__localhostPort;
}