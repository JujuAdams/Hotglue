// Feather disable all

/// @param resourceStruct

function __HotglueResourceScript(_resourceStruct) : __HotglueResourceCommon(_resourceStruct) constructor
{
    static resourceType = "script";
    static implemented  = true;
    
    static __CopySpecific = function(_destinationDirectory, _sourceDirectory)
    {
        var _resourceName = filename_change_ext(filename_name(data.path), "");
        __HotglueCopyRelativePathArray(_destinationDirectory, _sourceDirectory, [ $"{_resourceName}.yy", $"{_resourceName}.gml" ]);
    }
    
    static __GetExpandedAssetsSpecific = function(_project, _visitedArray, _visitedDict)
    {
        //Do nothing!
    }
}