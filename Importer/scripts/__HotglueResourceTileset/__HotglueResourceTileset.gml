// Feather disable all

/// @param resourceStruct

function __HotglueResourceTileset(_resourceStruct) : __HotglueResourceCommon(_resourceStruct) constructor
{
    static resourceType = "tileset";
    static implemented  = true;
    
    static __CopySpecific = function(_destinationDirectory, _sourceDirectory)
    {
        var _resourceName = filename_change_ext(filename_name(data.path), "");
        __HotglueCopyRelativePathArray(_destinationDirectory, _sourceDirectory, [ $"{_resourceName}.yy", "output_tileset.png" ]);
    }
    
    static __GetExpandedAssetsSpecific = function(_project, _visitedArray, _visitedDict)
    {
        var _json = __GetYYJSON(_project);
        
        var _spriteData = _json.spriteId;
        if (is_struct(_spriteData))
        {
            var _spriteAssetName = $"resource:{_spriteData.name}";
            if (not variable_struct_exists(_visitedDict, _spriteAssetName))
            {
                array_push(_visitedArray, _spriteAssetName);
                _visitedDict[$ _spriteAssetName] = true;
            }
        }
    }
}