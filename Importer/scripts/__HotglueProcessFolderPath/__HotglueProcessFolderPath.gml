// Feather disable all

/// @param folderPath

function __HotglueProcessFolderPath(_folderPath)
{
    if (string_copy(_folderPath, 1, 8) == "folders/")
    {
        //Strip off leading `folders/`
        _folderPath = string_delete(_folderPath, 1, 8);
    }
    
    //Strip off trailing `.yy`
    _folderPath = filename_change_ext(_folderPath, "");
    
    return _folderPath;
}