// Feather disable all

/// @param path
/// @param sourceURL

function HotglueProjectRemoteEnsure(_path, _sourceURL)
{
    static _projectBySourceURLDict = __HotglueSystem().__projectBySourceURLDict;
    
    var _project = HotglueProjectRemoteGet(_sourceURL);
    if (_project != undefined)
    {
        return _project;
    }
    
    var _extension = filename_ext(_path);
    if (_extension == ".yyp")
    {
        _project = __HotglueLoadYYP(_path, true, _sourceURL);
    }
    else if (_extension == ".yyz")
    {
        _project = __HotglueLoadYYZ(_path, _sourceURL);
    }
    else if (_extension == ".yymps")
    {
        _project = __HotglueLoadYYMPS(_path, _sourceURL);
    }
    else
    {
        __HotglueWarning($"Extension \"{_extension}\" not supported ({_extension})");
        return undefined;
    }
    
    _projectBySourceURLDict[$ _sourceURL] = _project;
    return _project;
}