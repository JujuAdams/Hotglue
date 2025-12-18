// Feather disable all

/// @param resourceStruct

function __HotglueResourceSound(_resourceStruct) : __HotglueResourceCommon(_resourceStruct) constructor
{
    static resourceType = "sound";
    
    //TODO - Reset audio group on import
    
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
}