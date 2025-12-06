// Feather disable all

/// @param path

function HotglueProjectLocalEnsure(_path)
{
    static _projectByPathDict = __HotglueSystem().__projectByPathDict;
    
    var _project = HotglueProjectLocalGet(_path);
    if (_project != undefined)
    {
        return _project;
    }
    
    var _extension = filename_ext(_path);
    if (_extension == ".yyp")
    {
        _project = __HotglueLoadYYP(_path, true, _path);
    }
    else if (_extension == ".yyz")
    {
        _project = __HotglueLoadYYZ(_path, _path);
    }
    else if (_extension == ".yymps")
    {
        _project = __HotglueLoadYYMPS(_path, _path);
    }
    else
    {
        __HotglueWarning($"Extension \"{_extension}\" not supported ({_extension})");
        return undefined;
    }
    
    _projectByPathDict[$ _path] = _project;
    return _project;
}