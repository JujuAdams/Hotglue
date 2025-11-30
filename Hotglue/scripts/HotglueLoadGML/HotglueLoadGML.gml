// Feather disable all

/// @param path

function HotglueLoadGML(_gmlPath)
{
    if (GM_is_sandboxed)
    {
        __HotglueError("Please disable sandboxing for this platform.");
    }
    
    if (not file_exists(_gmlPath))
    {
        __HotglueError($"\"{_gmlPath}\" doesn't exist");
    }
    
    return new __HotglueGML(_gmlPath);
}