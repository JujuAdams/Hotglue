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
                array_push(_array, $"{_localDirectory}layers/{_frameName}/{_layerArray[_j].name}.png");
                ++_j;
            }
            
            ++_i;
        }
        
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
}