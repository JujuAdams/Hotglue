// Feather disable all

function __HotglueSystem()
{
    static _system = undefined;
    if (_system != undefined) return _system;
    
    if (GM_is_sandboxed)
    {
        __HotglueError("Please disable sandboxing for this platform.");
    }
    
    _system = {};
    with(_system)
    {
        __suppressGitAssert = false;
        __destructiveCopy = true;
    }
    
    return _system;
}