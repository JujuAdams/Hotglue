// Feather disable all

/// @param path

function __HotglueSanitizeFilePath(_path)
{
    _path = string_lower(_path);
    
    _path = string_replace_all(_path,  ":", "_");
    _path = string_replace_all(_path,  "*", "_");
    _path = string_replace_all(_path,  "?", "_");
    _path = string_replace_all(_path, "\"", "_");
    _path = string_replace_all(_path,  "<", "_");
    _path = string_replace_all(_path,  ">", "_");
    _path = string_replace_all(_path,  "|", "_");
    
    return _path;
}