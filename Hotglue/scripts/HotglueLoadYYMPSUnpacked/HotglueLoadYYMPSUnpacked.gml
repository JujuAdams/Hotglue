// Feather disable all

/// @param path
/// @param [metadataJSON]

function HotglueLoadYYMPSUnpacked(_yypPath, _metadataJSON = undefined)
{
    if (GM_is_sandboxed)
    {
        __HotglueError("Please disable sandboxing for this platform.");
    }
    
    if (not file_exists(_yypPath))
    {
        __HotglueError($"\"{_yypPath}\" doesn't exist");
    }
    
    if (_metadataJSON == undefined)
    {
        var _metadataPath = filename_dir(_yypPath) + "metadata.json";
        if (not file_exists(_metadataPath))
        {
            __HotglueError($"\"{_metadataPath}\" doesn't exist");
        }
        
        var _buffer = buffer_load(_metadataPath);
        var _string = buffer_read(_buffer, buffer_text);
        buffer_delete(_buffer);
        _metadataJSON = json_parse(_string);
    }
    
    var _project = new __HotglueProject(_yypPath);
    _project.__VerifyFilesUnzipped();
    
    //TODO - Pull out .yymps data
    
    return _project;
}