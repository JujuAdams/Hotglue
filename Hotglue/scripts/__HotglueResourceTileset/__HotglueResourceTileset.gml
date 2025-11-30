// Feather disable all

/// @param resourceStruct

function __HotglueResourceTileset(_resourceStruct) : __HotglueResourceCommon(_resourceStruct) constructor
{
    static resourceType = "tileset";
    
    //TODO - Reset texture group on import
    
    static __GetFiles = function(_project, _array = [])
    {
        array_push(_array, data.path);
        array_push(_array, filename_dir(data.path) + "/output_tileset.png");
        
        return _array;
    }
    
    static __GetExpandedAssets = function(_project, _visitedArray, _visitedDict)
    {
        __HotglueTryExpandingAssetID(__GetYYJSON(_project).spriteId, _visitedArray, _visitedDict);
    }
}