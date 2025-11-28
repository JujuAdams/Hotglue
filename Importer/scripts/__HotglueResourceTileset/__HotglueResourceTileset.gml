// Feather disable all

/// @param resourceStruct

function __HotglueResourceTileset(_resourceStruct) : __HotglueResourceCommon(_resourceStruct) constructor
{
    static resourceType = "tileset";
    
    static __GetFiles = function(_project, _array = [])
    {
        array_push(_array, data.path);
        array_push(_array, filename_dir(data.path) + "/output_tileset.png");
        
        return _array;
    }
    
    static __GetExpandedAssetsSpecific = function(_project, _visitedArray, _visitedDict)
    {
        __HotglueTryExpandingAssetID(__GetYYJSON(_project).spriteId, _visitedArray, _visitedDict);
    }
}