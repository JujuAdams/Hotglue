// Feather disable all

/// @param resourceStruct

function __HotglueResourcePartSys(_resourceStruct) : __HotglueResourceCommon(_resourceStruct) constructor
{
    static resourceType = "particle system";
    
    static __GetFiles = function(_project, _array = [])
    {
        array_push(_array, data.path);
    }
    
    static __GetExpandedAssetsSpecific = function(_project, _visitedArray, _visitedDict)
    {
        var _json = __GetYYJSON(_project);
        
        var _emitterArray = _json.emitters;
        var _i = 0;
        repeat(array_length(_emitterArray))
        {
            __HotglueTryExpandingAssetID(_emitterArray[_i].spriteId, _visitedArray, _visitedDict);
            ++_i;
        }
    }
}