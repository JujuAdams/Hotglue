// Feather disable all

/// @param directory
/// @param [sourceURL=path]

function __HotglueLoadYYMPSUnpacked(_directory, _sourceURL = undefined)
{
    if (GM_is_sandboxed)
    {
        __HotglueError("Please disable sandboxing for this platform.");
    }
    
    if (not directory_exists(_directory))
    {
        __HotglueError($"\"{_directory}\" doesn't exist");
    }
    
    var _projectPath = undefined;
    var _path = file_find_first($"{_directory}/*.yyp", 0);
    while(_path != "")
    {
        if (_projectPath != undefined)
        {
            __HotglueError("Multiple .yyp files found inside directory");
        }
        
        _projectPath = _path;
        _path = file_find_next();
    }
    
    file_find_close();
    
    var _metadataPath = _directory + "metadata.json";
    if (not file_exists(_metadataPath))
    {
        __HotglueError($"\"{_metadataPath}\" doesn't exist");
    }
    
    var _buffer = buffer_load(_metadataPath);
    var _string = buffer_read(_buffer, buffer_text);
    buffer_delete(_buffer);
    var _metadataJSON = json_parse(_string);
    
    var _project = new __HotglueProject(_directory + _projectPath, true, _sourceURL);
    _project.__VerifyFilesUnzipped();
    _project.__SetYYMPSMetadata(_metadataJSON);
    
    return _project;
}