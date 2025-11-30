// Feather disable all

/// @param path

function HotglueLoadLooseFile(_path)
{
    if (GM_is_sandboxed)
    {
        __HotglueError("Please disable sandboxing for this platform.");
    }
    
    if (not file_exists(_path))
    {
        __HotglueError($"\"{_path}\" doesn't exist");
    }
    
    return new __HotglueLooseFile(_path);
}