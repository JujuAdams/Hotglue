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
    
    static __FixYYReferencesSpecial = function(_string, _json)
    {
        //Replace the texture group for this resource
        var _textureGroupStruct = _json[$ "textureGroupId"];
        if (is_struct(_textureGroupStruct))
        {
            var _name = _textureGroupStruct[$ "name"];
            var _path = _textureGroupStruct[$ "path"];
            
            var _find = $"  \"textureGroupId\":\{\n    \"name\":\"{_name}\",\n    \"path\":\"{_path}\",\n  \},";
            if (string_pos(_find, _string) <= 0)
            {
                __HotglueWarning($"Could not find audio group information for {GetPID()}");
            }
            else
            {
                var _replace = "  \"textureGroupId\":{\n    \"name\":\"Default\",\n    \"path\":\"texturegroups/Default\",\n  },";
                _string = string_replace(_string, _find, _replace);
            }
        }
        
        return _string;
    }
    
    static __GetExpandedAssetsSpecial = function(_project, _visitedArray, _visitedDict)
    {
        __HotglueTryExpandingAssetID(__GetYYJSON(_project).spriteId, _visitedArray, _visitedDict);
    }
}