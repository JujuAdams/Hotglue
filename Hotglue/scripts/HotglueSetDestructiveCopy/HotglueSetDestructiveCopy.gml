// Feather disable all

/// @param value

function HotglueSetDestructiveCopy(_value)
{
    static _system = __HotglueSystem();
    
    _system.__destructiveCopy = _value;
}