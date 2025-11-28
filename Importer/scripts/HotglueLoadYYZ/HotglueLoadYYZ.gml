// Feather disable all

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
    
    var _projectPath = undefined;
    var _path = file_find_first($"{_directory}/*.yyp", 0);
    while(_path != "")
    {
        if (_projectPath != undefined)
        {
            __HotglueError("Multiple .yyp files found inside archive");
        }
        
        _projectPath = _path;
        _path = file_find_next();
    }
    
    file_find_close();
    
    if (_projectPath == undefined)
    {
        __HotglueError("No .yyp file found inside archive");
    }
    
    var _project = new HotglueProject(_directory + _projectPath);
    _project.__VerifyFilesUnzipped();
    
    return _project;
}