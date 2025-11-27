// Feather disable all

/// @param resourceStruct

function __HotglueResourcePartSys(_resourceStruct) : __HotglueResourceCommon(_resourceStruct) constructor
{
    static resourceType = "particle system";
    static implemented  = true;
    
    static __CopySpecific = function(_destinationDirectory, _sourceDirectory)
    {
        var _resourceName = filename_change_ext(filename_name(data.path), "");
        __HotglueCopyRelativePathArray(_destinationDirectory, _sourceDirectory, [ $"{_resourceName}.yy" ]);
    }
}