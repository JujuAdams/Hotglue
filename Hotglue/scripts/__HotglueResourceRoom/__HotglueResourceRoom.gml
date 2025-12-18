// Feather disable all

/// @param resourceStruct

function __HotglueResourceRoom(_resourceStruct) : __HotglueResourceCommon(_resourceStruct) constructor
{
    static resourceType = "room";
    
    static __GetFiles = function(_project, _array = [])
    {
        array_push(_array, data.path);
        
        return _array;
    }
    
    static __GetExpandedAssetsSpecial = function(_project, _visitedArray, _visitedDict)
    {
        var _json = __GetYYJSON(_project);
        
        var _layerArray = _json.layers;
        var _i = 0;
        repeat(array_length(_layerArray))
        {
            __GetExpandedAssetsRecursive(_layerArray[_i], _visitedArray, _visitedDict);
            ++_i;
        }
    }
    
    static __GetExpandedAssetsRecursive = function(_layerData, _visitedArray, _visitedDict)
    {
        var _layerType = _layerData.resourceType;
        if (_layerType == "GMREffectLayer")
        {
            // TODO - Handle textures/sprites assigned to effect layers
        }
        else if (_layerType == "GMRAssetLayer")
        {
            var _assetArray = _layerData.assets;
            var _i = 0;
            repeat(array_length(_assetArray))
            {
                __HotglueTryExpandingAssetID(_assetArray[_i].spriteId, _visitedArray, _visitedDict);
                ++_i;
            }
        }
        else if (_layerType == "GMRTileLayer")
        {
            __HotglueTryExpandingAssetID(_layerData.tilesetId, _visitedArray, _visitedDict);
        }
        else if (_layerType == "GMRBackgroundLayer")
        {
            __HotglueTryExpandingAssetID(_layerData.spriteId, _visitedArray, _visitedDict);
        }
        else if (_layerType == "GMRInstanceLayer")
        {
            var _instanceArray = _layerData.instances;
            var _i = 0;
            repeat(array_length(_instanceArray))
            {
                __HotglueTryExpandingAssetID(_instanceArray[_i].objectId, _visitedArray, _visitedDict);
                
                // TODO - Handle textures/sprites assigned to instance variable definitions
                
                ++_i;
            }
        }
        else if (_layerType == "GMRLayer")
        {
            //Folder
        }
        
        var _layerArray = _layerData[$ "layers"];
        if (is_array(_layerArray))
        {
            var _i = 0;
            repeat(array_length(_layerArray))
            {
                __GetExpandedAssetsRecursive(_layerArray[_i], _visitedArray, _visitedDict);
                ++_i;
            }
        }
    }
}