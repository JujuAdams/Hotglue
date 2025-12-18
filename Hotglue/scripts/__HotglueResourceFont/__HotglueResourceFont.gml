// Feather disable all

/// @param resourceStruct

function __HotglueResourceFont(_resourceStruct) : __HotglueResourceCommon(_resourceStruct) constructor
{
    static resourceType = "font";
    
    static __GetFiles = function(_project, _array = [])
    {
        array_push(_array, data.path);
        array_push(_array, filename_change_ext(data.path, ".png"));
        
        return _array;
    }
}