// Feather disable all

/// @param resourceStruct

function __HotglueResourceRoom(_resourceStruct) : __HotglueResourceCommon(_resourceStruct) constructor
{
    static resourceType = "room";
    static implemented  = true;
    
    static __CopySpecific = function(_destinationDirectory, _sourceDirectory)
    {
        // TODO - Handle room / instance GML code
        
        var _resourceName = filename_change_ext(filename_name(data.path), "");
        var _copyArray = [ $"{_resourceName}.yy" ];
        
        var _sourcePath = _sourceDirectory + _copyArray[0];
        
        var _buffer = buffer_load(_sourcePath);
        var _yyString = buffer_read(_buffer, buffer_text);
        buffer_delete(_buffer);
        
        var _yyJson = json_parse(_yyString);
        
        var _resourceName = filename_change_ext(filename_name(data.path), "");
        __HotglueCopyRelativePathArray(_destinationDirectory, _sourceDirectory, [ $"{_resourceName}.yy" ]);
    }
    
    static __GetExpandedAssetsSpecific = function(_project, _visitedArray, _visitedDict)
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
            //TODO - Handle textures/sprites assigned to effect layers
        }
        else if (_layerType == "GMRAssetLayer")
        {
            var _assetArray = _layerData.assets;
            var _i = 0;
            repeat(array_length(_assetArray))
            {
                __HotglueTryAddingExpandedSpriteID(_assetArray[_i].spriteId, _visitedArray, _visitedDict);
                ++_i;
            }
        }
        else if (_layerType == "GMRTileLayer")
        {
            __HotglueTryAddingExpandedSpriteID(_layerData.tilesetId, _visitedArray, _visitedDict);
        }
        else if (_layerType == "GMRBackgroundLayer")
        {
            __HotglueTryAddingExpandedSpriteID(_layerData.spriteId, _visitedArray, _visitedDict);
        }
        else if (_layerType == "GMRInstanceLayer")
        {
            var _instanceArray = _layerData.instances;
            var _i = 0;
            repeat(array_length(_instanceArray))
            {
                __HotglueTryAddingExpandedSpriteID(_instanceArray[_i].objectId, _visitedArray, _visitedDict);
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