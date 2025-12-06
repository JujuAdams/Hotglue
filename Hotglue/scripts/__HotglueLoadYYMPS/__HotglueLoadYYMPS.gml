// Feather disable all

/// Loads a .yymps file and returns an struct constructed by `__HotglueProject`. Please see
/// `HotglueLoadYYP()` for struct methods that you can use.
/// 
/// @param path
/// @param [sourceURL=path]

function __HotglueLoadYYMPS(_yympsPath, _sourceURL = _yympsPath)
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
    
    var _directory = $"{HOTGLUE_UNZIP_CACHE_DIRECTORY}{md5_string_unicode(_yympsPath)}/";
    directory_destroy(_directory);
    
    if (zip_unzip(_yympsPath, _directory) <= 0)
    {
        __HotglueWarning($"Failed to unzip \"{_yympsPath}\" to \"{_directory}\"");
        directory_destroy(_directory);
        
        return undefined;
    }
    
    var _metadataPath = _directory + "metadata.json";
    if (not file_exists(_metadataPath))
    {
        __HotglueWarning($"\"{_metadataPath}\" doesn't exist, aborting");
        directory_destroy(_directory);
        
        return undefined;
    }
    
    //FIXME - try..catch this
    
    var _buffer = buffer_load(_metadataPath);
    var _string = buffer_read(_buffer, buffer_text);
    buffer_delete(_buffer);
    var _metadataJSON = json_parse(_string);
    
    return HotglueLoadYYMPSUnpacked(_directory + _metadataJSON.display_name + ".yyp", _sourceURL, _metadataJSON);
}