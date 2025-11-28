// Feather disable all

/// @param resourceStruct

function __HotglueResourceNote(_resourceStruct) : __HotglueResourceCommon(_resourceStruct) constructor
{
    static resourceType = "note";
    
    static __GetFiles = function(_project, _array = [])
    {
        array_push(_array, data.path);
        array_push(_array, filename_change_ext(data.path, ".txt"));
        
        return _array;
    }
    
    static __GetExpandedAssets = function(_project, _visitedArray, _visitedDict)
    {
        //Do nothing!
    }
}