// Feather disable all

/// @param directory

function HotglueDirectoryHasGit(_directory)
{
    if (directory_exists(_directory + "/.git"))
    {
        return true;
    }
    
    var _newDirectory = filename_dir(_directory);
    if (_newDirectory == _directory)
    {
        return false;
    }
    
    return HotglueDirectoryHasGit(_newDirectory);
}