// Feather disable all

/// @param destinationProjectPath
/// @param sourceProjectPath
/// @param hotglueAsset

function __HotglueCopyAsset(_destinationProjectPath, _sourceProjectPath, _hotglueAsset)
{
    static _system = __HotglueSystem();
    
    var _destinationProjectDirectory = filename_dir(_destinationProjectPath) + "/";
    var _sourceProjectDirectory = filename_dir(_sourceProjectPath) + "/";
    
    var _hotglueType = _hotglueAsset.type;
    if (_hotglueType == "resource")
    {
        var _resourceType = _hotglueAsset.resourceType;
        var _relativePath = _hotglueAsset.data.path;
        
        if (_resourceType == "unknown")
        {
            __HotglueError($"Resource type \"{_resourceType}\" unhandled");
        }
        
        var _destinationDirectory = _destinationProjectDirectory + filename_dir(_relativePath) + "/";
        var _sourceDirectory = _sourceProjectDirectory + filename_dir(_relativePath) + "/";
        
        if (_system.__destructiveCopy)
        {
            directory_destroy(_destinationDirectory);
        }
        
        directory_create(_destinationDirectory);
        
        if (_resourceType == "script")
        {
            var _resourceName = filename_change_ext(filename_name(_relativePath), "");
            __HotglueCopyRelativePathArray(_destinationDirectory, _sourceDirectory, [ $"{_resourceName}.yy", $"{_resourceName}.gml" ]);
        }
    }
    else if (_hotglueType == "included file")
    {
        var _destinationPath = _destinationProjectDirectory + _hotglueAsset.data.filePath + "/" + _hotglueAsset.data.name;
        var _sourcePath = _sourceProjectDirectory + _hotglueAsset.data.filePath + "/" + _hotglueAsset.data.name;
        
        file_copy(_sourcePath, _destinationPath);
    }
    else if (_hotglueType == "folder")
    {
        //Do nothing!
    }
    else
    {
        __HotglueError($"Hotglue type \"{_hotglueType}\" unhandled");
    }
}