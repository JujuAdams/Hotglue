// Feather disable all

/// @param resourceStruct

function __HotglueResourceAnimCurve(_resourceStruct) : __HotglueResourceCommon(_resourceStruct) constructor
{
    static resourceType = "animation curve";
    
    static __GetFiles = function(_project, _array = [])
    {
        array_push(_array, data.path);
        
        return _array;
    }
    
    static __GetExpandedAssetsSpecific = function(_project, _visitedArray, _visitedDict)
    {
        //Do nothing!
    }
}