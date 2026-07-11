// Feather disable all

/// @param [releaseStruct]
/// @param sourceURL
/// @param cachePath

function HotglueProjectRemoteEnsure(_releaseStruct, _sourceURL, _cachePath)
{
    static _projectBySourceURLDict = __HotglueSystem().__projectBySourceURLDict;
    
    var _project = HotglueProjectRemoteGet(_sourceURL);
    if (_project != undefined)
    {
        return _project;
    }
    
    var _extension = filename_ext(_cachePath);
    if (_extension == ".yyp")
    {
        _project = __HotglueLoadYYP(_releaseStruct, _cachePath, true, _sourceURL, true);
    }
    else if (_extension == ".yyz")
    {
        _project = __HotglueLoadYYZ(_releaseStruct, _cachePath, _sourceURL);
    }
    else if (_extension == ".yymps")
    {
        _project = __HotglueLoadYYMPS(_releaseStruct, _cachePath, _sourceURL);
    }
    else
    {
        __HotglueWarning($"Extension \"{_extension}\" not supported ({_extension})");
        return undefined;
    }
    
    _projectBySourceURLDict[$ _sourceURL] = _project;
    return _project;
}