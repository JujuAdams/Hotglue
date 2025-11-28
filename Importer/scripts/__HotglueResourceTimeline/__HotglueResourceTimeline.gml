// Feather disable all

/// @param resourceStruct

function __HotglueResourceTimeline(_resourceStruct) : __HotglueResourceCommon(_resourceStruct) constructor
{
    static resourceType = "timeline";
    
    static __GetFiles = function(_project, _array = [])
    {
        var _localDirectory = filename_dir(data.path) + "/";
        
        array_push(_array, data.path);
        
        var _momentArray = __GetYYJSON(_project).momentList;
        var _i = 0;
        repeat(array_length(_momentArray))
        {
            array_push(_array, $"{_localDirectory}moment_{_momentArray[_i].moment}.gml");
            ++_i;
        }
        
        return _array;
    }
    
    static __GetExpandedAssetsSpecific = function(_project, _visitedArray, _visitedDict)
    {
        //Do nothing!
    }
}