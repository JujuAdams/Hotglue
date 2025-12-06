// Feather disable all

/// Loads a .yyz file and returns an struct constructed by `__HotglueProject`. Please see
/// `__HotglueLoadYYP()` for struct methods that you can use.
/// 
/// @param path
/// @param [sourceURL=path]

function __HotglueLoadYYZ(_yyzPath, _sourceURL = _yyzPath)
{
    if (GM_is_sandboxed)
    {
        __HotglueError("Please disable sandboxing for this platform.");
    }
    
    if (not file_exists(_yyzPath))
    {
        __HotglueWarning($"\"{_yyzPath}\" doesn't exist");
        return undefined;
    }
    
    var _directory = $"{HOTGLUE_UNZIP_CACHE_DIRECTORY}{md5_string_unicode(_yyzPath)}/";
    directory_destroy(_directory);
    
    if (zip_unzip(_yyzPath, _directory) <= 0)
    {
        __HotglueWarning($"Failed to unzip \"{_yyzPath}\" to \"{_directory}\"");
        directory_destroy(_directory);
        
        return undefined;
    }
    else
    {
        return __HotglueLoadYYZUnpacked(_directory, _sourceURL);
    }
}