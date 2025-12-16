// Feather disable all

function HotglueGetProjectToolPath()
{
    static _system = __HotglueSystem();
    
    return _system.__projectToolPath;
}