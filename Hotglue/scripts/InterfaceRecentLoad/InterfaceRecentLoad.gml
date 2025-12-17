// Feather disable all

function InterfaceRecentLoad()
{
    static _recentArray = __InterfaceSystem().__recentArray;
    
    var _json = undefined;
    
    try
    {
        var _buffer = buffer_load(INTERACE_DEFAULT_PATH_SAVEDATA + "recent.json");
        var _string = buffer_read(_buffer, buffer_text);
        buffer_delete(_buffer);
        
        _json = json_parse(_string);
        
        LogTrace($"Loaded \"{INTERACE_DEFAULT_PATH_SAVEDATA + "recent.json"}\" successfully");
    }
    catch(_error)
    {
        LogWarning(json_stringify(_error, true));
        LogTrace($"Failed to load \"{INTERACE_DEFAULT_PATH_SAVEDATA + "recent.json"}\"");
    }
    
    if (is_array(_json))
    {
        array_copy(_recentArray, 0, _json, 0, array_length(_json));
    }
    else
    {
        array_resize(_recentArray, 0);
    }
}