// Feather disable all

/// @param path

function InterfaceRecentPush(_path)
{
    static _array = __InterfaceSystem().__recentArray;
    
    var _index = array_get_index(_array, _path);
    if (_index >= 0) array_delete(_array, _index, 1);
    
    array_insert(_array, 0, _path);
    
    if (array_length(_array) >= 10)
    {
        array_pop(_array);
    }
    
    var _string = json_stringify(_array, true);
    var _buffer = buffer_create(string_byte_length(_string), buffer_fixed, 1);
    buffer_write(_buffer, buffer_text, _string);
    buffer_save(_buffer, INTERACE_DEFAULT_PATH_SAVEDATA + "recent.json");
    buffer_delete(_buffer);
    
    LogTrace($"Pushed \"{_path}\" to recent.json");
}