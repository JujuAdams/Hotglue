// Feather disable all

/// @param resourceStruct

function __HotglueResourceSound(_resourceStruct) : __HotglueResourceCommon(_resourceStruct) constructor
{
    static resourceType = "sound";
    
    static __GetFiles = function(_project, _array = [])
    {
        array_push(_array, data.path);
        
        var _soundFilePath = __GetYYJSON(_project).soundFile;
        if (_soundFilePath != "")
        {
            array_push(_array, filename_dir(data.path) + "/" + _soundFilePath);
        }
        
        return _array;
    }
    
    static __FixYYReferencesSpecial = function(_string, _json)
    {
        //Replace the audio group for this resource
        var _audioGroupStruct = _json[$ "audioGroupId"];
        if (is_struct(_audioGroupStruct))
        {
            var _name = _audioGroupStruct[$ "name"];
            var _path = _audioGroupStruct[$ "path"];
            
            var _find = $"  \"audioGroupId\":\{\n    \"name\":\"{_name}\",\n    \"path\":\"{_path}\",\n  \},";
            if (string_pos(_find, _string) <= 0)
            {
                __HotglueWarning($"Could not find audio group information for {GetPID()}");
            }
            else
            {
                var _replace = "  \"audioGroupId\":{\n    \"name\":\"audiogroup_default\",\n    \"path\":\"audiogroups/audiogroup_default\",\n  },";
                _string = string_replace(_string, _find, _replace);
            }
        }
        
        return _string;
    }
}