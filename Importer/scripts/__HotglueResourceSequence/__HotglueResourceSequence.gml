// Feather disable all

/// @param resourceStruct

function __HotglueResourceSequence(_resourceStruct) : __HotglueResourceCommon(_resourceStruct) constructor
{
    static resourceType = "sequence";
    
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
                    __HotglueTryExpandingAssetID(_channelArray[_k].Id, _visitedArray, _visitedDict);
                    ++_k;
                }
                
                ++_j;
            }
            
            ++_i;
        }
    }
}