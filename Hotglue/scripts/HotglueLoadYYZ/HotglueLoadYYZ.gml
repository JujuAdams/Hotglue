// Feather disable all

/// Loads a .yyz file and returns an struct constructed by `__HotglueProject`. Please see
/// `HotglueLoadYYP()` for struct methods that you can use.
/// 
/// @param path

function HotglueLoadYYZ(_yyzPath)
{
    if (GM_is_sandboxed)
    {
        __HotglueError("Please disable sandboxing for this platform.");
    }
    
    if (not file_exists(_yyzPath))
    {
        __HotglueError($"\"{_yyzPath}\" doesn't exist");
    }
    
    var _hash = md5_string_unicode(_yyzPath);
    
    var _directory = game_save_id + $"temp-{_hash}/";
    directory_destroy(_directory)
    
    zip_unzip(_yyzPath, _directory);
    
    return HotglueLoadYYZUnpacked(_directory);
}