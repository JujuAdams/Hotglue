// Feather disable all

/// @param directory

function __HotglueAssertGit(_directory)
{
    static _system = __HotglueSystem();
    
    if (directory_exists(_directory + "/.git"))
    {
        return true;
    }
    
    var _newDirectory = filename_dir(_directory);
    if (_newDirectory == _directory)
    {
        if (_system.__suppressGitAssert)
        {
            __HotglueTrace("Warning! No .git directory found");
        }
        else
        {
            __HotglueError("No .git directory found");
        }
        
        return false;
    }
    
    return __HotglueAssertGit(_newDirectory);
}