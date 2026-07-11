// Feather disable all

/// @param [releaseStruct]
/// @param directory
/// @param [sourceURL=path]
/// @param [inCache=false]

function __HotglueLoadYYMPSUnpacked(_releaseStruct, _directory, _sourceURL = undefined, _inCache = false)
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
    
    var _yympsVersion = undefined;
    var _metadataPath = _directory + "metadata.json";
    if (file_exists(_metadataPath))
    {
        __HotglueTrace($"Loading .yymps version from \"{_metadataPath}\"");
        
        var _buffer = buffer_load(_metadataPath);
        var _string = buffer_read(_buffer, buffer_text);
        buffer_delete(_buffer);
        var _json = json_parse(_string);
        
        _yympsVersion = _json.version;
    }
    else
    {
        var _prefabPath = _directory + "prefab.json";
        if (file_exists(_prefabPath))
        {
            __HotglueTrace($"Loading .yymps version from \"{_prefabPath}\"");
            
            var _buffer = buffer_load(_prefabPath);
            var _string = buffer_read(_buffer, buffer_text);
            buffer_delete(_buffer);
            var _json = json_parse(_string);
            
            _yympsVersion = _json.Version;
        }
        else
        {
            __HotglueWarning($"Could not find either \"metadata.json\" or \"prefab.json\". Please check this .yymps is valid (directory = \"{_directory}\")");
            return undefined;
        }
    }
    
    var _project = new __HotglueProject(_releaseStruct, _directory + _projectPath, true, _sourceURL, _inCache);
    _project.__VerifyFilesUnzipped();
    _project.__SetYYMPSVersion(_yympsVersion);
    
    return _project;
}