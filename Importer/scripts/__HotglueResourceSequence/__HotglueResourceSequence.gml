// Feather disable all

/// @param resourceStruct

function __HotglueResourceSequence(_resourceStruct) : __HotglueResourceCommon(_resourceStruct) constructor
{
    static resourceType = "sequence";
    static implemented  = true;
    
    static __CopySpecific = function(_destinationDirectory, _sourceDirectory)
    {
        var _resourceName = filename_change_ext(filename_name(data.path), "");
        __HotglueCopyRelativePathArray(_destinationDirectory, _sourceDirectory, [ $"{_resourceName}.yy" ]);
    }
    
    static __GetExpandedAssetsSpecific = function(_project, _visitedArray, _visitedDict)
    {
        var _json = __GetYYJSON(_project);
        
        var _trackArray = _json.tracks;
        var _i = 0;
        repeat(array_length(_trackArray))
        {
            var _keyframeArray = _trackArray[_i].keyframes.Keyframes;
            var _j = 0;
            repeat(array_length(_keyframeArray))
            {
                var _channelArray = _keyframeArray[_j].Channels;
                var _k = 0;
                repeat(array_length(_channelArray))
                {
                    var _assetID = _channelArray[_k].Id;
                    if (is_struct(_assetID))
                    {
                        var _assetName = $"resource:{_assetID.name}";
                        if (not variable_struct_exists(_visitedDict, _assetName))
                        {
                            array_push(_visitedArray, _assetName);
                            _visitedDict[$ _assetName] = true;
                        }
                    }
                    
                    ++_k;
                }
                
                ++_j;
            }
            
            ++_i;
        }
    }
}