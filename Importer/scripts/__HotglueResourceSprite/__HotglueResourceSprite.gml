// Feather disable all

/// @param resourceStruct

function __HotglueResourceSprite(_resourceStruct) : __HotglueResourceCommon(_resourceStruct) constructor
{
    static resourceType = "sprite";
    
    static __GetFiles = function(_project, _array = [])
    {
        var _localDirectory = filename_dir(data.path) + "/";
        
        array_push(_array, data.path);
        
        var _yyJson = __GetYYJSON(_project);
        
        var _frameArray = _yyJson.frames;
        var _layerArray = _yyJson.layers;
        
        var _i = 0;
        repeat(array_length(_frameArray))
        {
            var _frameName = _frameArray[_i].name;
            
            array_push(_array, $"{_localDirectory}{_frameName}.png");
            
            var _j = 0;
            repeat(array_length(_layerArray))
            {
                array_push(_array, $"{_localDirectory}layers/{_frameName}/{_layerArray[_i].name}.png");
                ++_j;
            }
            
            ++_i;
        }
        
        return _array;
    }
    
    static __GetExpandedAssetsSpecific = function(_project, _visitedArray, _visitedDict)
    {
        //Do nothing!
    }
}