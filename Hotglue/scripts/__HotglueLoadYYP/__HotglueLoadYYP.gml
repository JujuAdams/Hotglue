// Feather disable all

/// @param path
/// @param [readOnly=false]
/// @param [sourceURL=path]
/// @param [inCache=false]

function __HotglueLoadYYP(_yypPath, _readOnly = false, _sourceURL = _yypPath, _inCache = false)
{
    if (GM_is_sandboxed)
    {
        __HotglueError("Please disable sandboxing for this platform.");
    }
    
    if (not file_exists(_yypPath))
    {
        __HotglueError($"\"{_yypPath}\" doesn't exist");
    }
    
    var _project = new __HotglueProject(_yypPath, _readOnly, _sourceURL, _inCache);
    _project.__VerifyIncludedFilesExist();
    
    return _project;
}