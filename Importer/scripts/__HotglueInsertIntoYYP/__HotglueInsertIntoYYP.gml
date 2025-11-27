// Feather disable all

/// @param project
/// @param hotglueAsset

function __HotglueInsertIntoYYP(_project, _hotglueAsset)
{
    var _yypString = _project.__yypText;
    
    var _hotglueType = _hotglueAsset.type;
    if (_hotglueType == "resource")
    {
        if (_hotglueAsset.resourceType == "unknown")
        {
            __HotglueError($"Resource type \"{_hotglueAsset.resourceType}\" unhandled");
        }
        
        var _substring = "  \"resources\":[";
        var _pos = string_pos(_substring, _yypString);
        _pos += string_length(_substring);
        
        if (string_char_at(_yypString, _pos) == "\r")
        {
            ++_pos;
        }
        
        if (string_char_at(_yypString, _pos) == "\n")
        {
            ++_pos;
        }
        
        var _insertString = $"    \{\"id\":\{\"name\":\"{_hotglueAsset.data.name}\",\"path\":\"{_hotglueAsset.data.path}\",},},\n";
        _yypString = string_insert(_insertString, _yypString, _pos);
    }
    else if (_hotglueType == "folder")
    {
        //TODO
    }
    else if (_hotglueType == "included file")
    {
        //TODO
    }
    else
    {
        __HotglueError($"Hotglue type \"{_hotglueType}\" unhandled");
    }
    
    _project.__yypText = _yypString;
    _project.__AddAsset(_hotglueAsset);
}