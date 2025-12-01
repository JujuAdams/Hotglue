// Feather disable all

/// Loads a .yymps file and returns an struct constructed by `__HotglueProject`. Please see
/// `HotglueLoadYYP()` for struct methods that you can use.
/// 
/// @param path

function HotglueLoadYYMPS(_yympsPath)
{
    if (GM_is_sandboxed)
    {
        __HotglueError("Please disable sandboxing for this platform.");
    }
    
    if (not file_exists(_yympsPath))
    {
        __HotglueError($"\"{_yympsPath}\" doesn't exist");
    }
    
    var _hash = md5_string_unicode(_yympsPath);
    
    var _directory = game_save_id + $"temp-{_hash}/";
    directory_destroy(_directory)
    
    zip_unzip(_yympsPath, _directory);
    
    var _metadataPath = _directory + "metadata.json";
    if (not file_exists(_metadataPath))
    {
        __HotglueError($"\"{_metadataPath}\" doesn't exist");
    }
    
    var _buffer = buffer_load(_metadataPath);
    var _string = buffer_read(_buffer, buffer_text);
    buffer_delete(_buffer);
    var _metadataJSON = json_parse(_string);
    
    return HotglueLoadYYMPSUnpacked(_directory + _metadataJSON.display_name + ".yyp", _metadataJSON);
}