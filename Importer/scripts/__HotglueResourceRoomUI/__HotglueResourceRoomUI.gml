// Feather disable all

/// @param resourceStruct

function __HotglueResourceRoomUI(_resourceStruct) : __HotglueResourceCommon(_resourceStruct) constructor
{
    static resourceType = "ui layer";
    
    static __CopySpecific = function(_destinationDirectory, _sourceDirectory)
    {
        var _resourceName = filename_change_ext(filename_name(data.path), "");
        __HotglueCopyRelativePathArray(_destinationDirectory, _sourceDirectory, [ $"{_resourceName}.yy" ]);
    }
    
    static __GetExpandedAssetsSpecific = function(_project, _visitedArray, _visitedDict)
    {
        // TODO
    }
}