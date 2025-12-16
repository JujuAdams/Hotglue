// Feather disable all

function HotglueGetProjectToolExists()
{
    static _system = __HotglueSystem();
    
    return file_exists(_system.__projectToolPath);
}