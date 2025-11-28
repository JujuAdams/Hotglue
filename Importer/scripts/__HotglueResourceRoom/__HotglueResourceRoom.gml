// Feather disable all

/// @param resourceStruct

function __HotglueResourceRoom(_resourceStruct) : __HotglueResourceCommon(_resourceStruct) constructor
{
    static resourceType = "room";
    static implemented  = true;
    
    static __CopySpecific = function(_destinationDirectory, _sourceDirectory)
    {
        // TODO - Handle room / instance GML code
        // TODO - Pull in referenced assets too maybe?
        
        var _resourceName = filename_change_ext(filename_name(data.path), "");
        __HotglueCopyRelativePathArray(_destinationDirectory, _sourceDirectory, [ $"{_resourceName}.yy" ]);
    }
    
    static __GetExpandedAssetsSpecific = function(_project, _visitedArray, _visitedDict)
    {
        //TODO
    }
}