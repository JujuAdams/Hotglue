// Feather disable all

/// @param value

function HotglueGetSuppressGitAssert(_value)
{
    static _system = __HotglueSystem();
    
    return _system.__suppressGitAssert;
}