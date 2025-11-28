// Feather disable all

/// @param resourceStruct

function __HotglueResourceSequence(_resourceStruct) : __HotglueResourceCommon(_resourceStruct) constructor
{
    static resourceType = "sequence";
    static implemented  = true;
    
    static __CopySpecific = function(_destinationDirectory, _sourceDirectory)
    {
        // TODO - Pull in referenced assets too maybe?
        
        var _resourceName = filename_change_ext(filename_name(data.path), "");
        __HotglueCopyRelativePathArray(_destinationDirectory, _sourceDirectory, [ $"{_resourceName}.yy" ]);
    }
}