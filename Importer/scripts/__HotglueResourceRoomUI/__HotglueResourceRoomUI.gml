// Feather disable all

/// @param resourceStruct

function __HotglueResourceRoomUI(_resourceStruct) : __HotglueResourceCommon(_resourceStruct) constructor
{
    static resourceType = "ui layer";
    
    static __GetFiles = function(_project, _array = [])
    {
        array_push(_array, data.path);
    }
    
    static __GetExpandedAssetsSpecific = function(_project, _visitedArray, _visitedDict)
    {
        // TODO
    }
}