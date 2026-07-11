// Feather disable all

/// @param [releaseStruct]
/// @param path
/// @param [sourceURL=path]

function HotglueProjectLocalEnsure(_releaseStruct, _path, _sourceURL = _path)
{
    static _projectByPathDict = __HotglueSystem().__projectByPathDict;
    
    var _project = HotglueProjectLocalGet(_path);
    if (_project != undefined)
    {
        return _project;
    }
    
    __HotglueTrace($"Path \"{_path}\" has not been loaded before, origin = \"{_sourceURL}\"");
    
    var _extension = filename_ext(_path);
    if (_extension == ".yyp")
    {
        _project = __HotglueLoadYYP(_releaseStruct, _path, false, _sourceURL, false);
    }
    else if (_extension == ".yyz")
    {
        _project = __HotglueLoadYYZ(_releaseStruct, _path, _sourceURL);
    }
    else if (_extension == ".yymps")
    {
        _project = __HotglueLoadYYMPS(_releaseStruct, _path, _sourceURL);
    }
    else
    {
        __HotglueWarning($"Extension \"{_extension}\" not supported ({_extension})");
        return undefined;
    }
    
    _projectByPathDict[$ _path] = _project;
    return _project;
}