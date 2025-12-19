// Feather disable all

function HotglueGetDestructiveCopy()
{
    static _system = __HotglueSystem();
    
    return _system.__destructiveCopy;
}