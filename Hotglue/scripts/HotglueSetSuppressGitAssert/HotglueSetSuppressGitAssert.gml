// Feather disable all

/// @param value

function HotglueSetSuppressGitAssert(_value)
{
    static _system = __HotglueSystem();
    
    _system.__suppressGitAssert = _value;
}