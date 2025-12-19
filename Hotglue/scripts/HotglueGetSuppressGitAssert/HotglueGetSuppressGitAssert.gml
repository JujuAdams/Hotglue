// Feather disable all

function HotglueGetSuppressGitAssert()
{
    static _system = __HotglueSystem();
    
    return _system.__suppressGitAssert;
}