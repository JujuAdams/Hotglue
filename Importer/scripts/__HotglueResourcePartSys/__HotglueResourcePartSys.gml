// Feather disable all

/// @param resourceStruct

function __HotglueResourcePartSys(_resourceStruct) : __HotglueResourceCommon(_resourceStruct) constructor
{
    static resourceType = "particle system";
    static implemented  = true;
    
    static __CopySpecific = function(_destinationDirectory, _sourceDirectory)
    {
        // TODO - Pull in referenced assets too maybe?
        
        var _resourceName = filename_change_ext(filename_name(data.path), "");
        __HotglueCopyRelativePathArray(_destinationDirectory, _sourceDirectory, [ $"{_resourceName}.yy" ]);
    }
    
    static __GetExpandedAssetsSpecific = function(_project, _visitedArray, _visitedDict)
    {
        var _json = __GetYYJSON(_project);
        
        var _emitterArray = _json.emitters;
        var _i = 0;
        repeat(array_length(_emitterArray))
        {
            var _spriteData = _emitterArray[_i].spriteId;
            if (is_struct(_spriteData))
            {
                var _spriteAssetName = $"resource:{_spriteData.name}";
                if (not variable_struct_exists(_visitedDict, _spriteAssetName))
                {
                    array_push(_visitedArray, _spriteAssetName);
                    _visitedDict[$ _spriteAssetName] = true;
                }
            }
            
            ++_i;
        }
    }
}