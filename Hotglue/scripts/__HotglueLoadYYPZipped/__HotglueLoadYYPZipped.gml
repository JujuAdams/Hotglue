// Feather disable all

/// @param path
/// @param [sourceURL=path]

function __HotglueLoadYYPZipped(_zipPath, _sourceURL = _zipPath)
{
    if (GM_is_sandboxed)
    {
        __HotglueError("Please disable sandboxing for this platform.");
    }
    
    if (not file_exists(_zipPath))
    {
        __HotglueWarning($"\"{_zipPath}\" doesn't exist");
        return undefined;
    }
    
    var _directory = $"{HOTGLUE_UNZIP_CACHE_DIRECTORY}{md5_string_unicode(_zipPath)}/";
    directory_destroy(_directory)
    
    if (zip_unzip(_zipPath, _directory) <= 0)
    {
        __HotglueWarning($"Failed to unzip \"{_zipPath}\" to \"{_directory}\"");
        directory_destroy(_directory);
        
        return undefined;
    }
    else
    {
        return __HotglueLoadYYZUnpacked(_directory, _sourceURL, true);
    }
}