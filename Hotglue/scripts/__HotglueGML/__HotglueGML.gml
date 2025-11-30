// Feather disable all

/// @param path

function __HotglueGML(_path) constructor
{
    __path = _path;
    __name = filename_change_ext(filename_name(_path), "");
    
    static GetPath = function()
    {
        return __path;
    }
    
    static GetName = function()
    {
        return __name;
    }
}