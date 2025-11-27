// Feather disable all

/// @param folderPath

function __HotglueProcessFolderPath(_inFolderPath)
{
    //The root will reference a .yyp file
    if (filename_ext(_inFolderPath) == ".yyp")
    {
        return "<root>";
    }
    
    //Strip off whatever trailing extension we have (usually `.yy`)
    var _folderPath = filename_change_ext(_inFolderPath, "");
    
    if (string_copy(_folderPath, 1, 8) == "folders/")
    {
        //Strip off leading `folders/`
        _folderPath = string_delete(_folderPath, 1, 8);
    }
    
    return _folderPath;
}