// Feather disable all

/// @param directory
/// @param [sourceURL]

function __HotglueLoadYYZUnpacked(_directory, _sourceURL = undefined)
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
    
    if (_projectPath == undefined)
    {
        __HotglueError("No .yyp file found inside directory");
    }
    
    var _project = new __HotglueProject(_directory + _projectPath, true, _sourceURL);
    _project.__VerifyFilesUnzipped();
    
    return _project;
}