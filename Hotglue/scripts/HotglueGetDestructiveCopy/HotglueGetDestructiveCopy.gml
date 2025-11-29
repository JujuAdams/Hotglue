// Feather disable all

/// @param value

function HotglueGetDestructiveCopy(_value)
{
    static _system = __HotglueSystem();
    
    return _system.__destructiveCopy;
}