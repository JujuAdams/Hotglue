// Feather disable all

/// @param resourceStruct

function __HotglueResourcePath(_resourceStruct) : __HotglueResourceCommon(_resourceStruct) constructor
{
    static resourceType = "path";
    
    static __GetFiles = function(_project, _array = [])
    {
        array_push(_array, data.path);
        
        return _array;
    }
}