// Feather disable all

/// Loads a .yymps file and returns an struct constructed by `__HotglueProject`. Please see
/// `HotglueLoadYYP()` for struct methods that you can use.
/// 
/// @param [releaseStruct]
/// @param path
/// @param [sourceURL=path]

function __HotglueLoadYYMPS(_releaseStruct, _yympsPath, _sourceURL = _yympsPath)
{
    if (GM_is_sandboxed)
    {
        __HotglueError("Please disable sandboxing for this platform.");
    }
    
    if (not file_exists(_yympsPath))
    {
        __HotglueWarning($"\"{_yympsPath}\" doesn't exist");
        return undefined;
    }
    
    __HotglueTrace($"Loading \"{_yympsPath}\" as a .yymps (extract then load)");
    
    var _directory = $"{HOTGLUE_UNZIP_CACHE_DIRECTORY}{md5_string_unicode(_yympsPath)}/";
    directory_destroy(_directory);
    
    if (zip_unzip(_yympsPath, _directory) <= 0)
    {
        __HotglueWarning($"Failed to unzip \"{_yympsPath}\" to \"{_directory}\"");
    }
    else
    {
        var _result = __HotglueLoadYYMPSUnpacked(_releaseStruct, _directory, _sourceURL, true);
    }
    
    if (_result == undefined)
    {
        __HotglueTrace($"Cleaning up \"{_directory}\"");
        directory_destroy(_directory);
    }
    
    return _result;
}