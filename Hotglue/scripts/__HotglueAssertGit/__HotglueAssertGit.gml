// Feather disable all

/// @param directory

function __HotglueAssertGit(_directory)
{
    static _system = __HotglueSystem();
    
    if (not HotglueDirectoryHasGit(_directory))
    {
        if (_system.__suppressGitAssert)
        {
            __HotglueWarning("No .git directory found");
        }
        else
        {
            __HotglueError("No .git directory found");
        }
        
        return false;
    }
    
    return true;
}