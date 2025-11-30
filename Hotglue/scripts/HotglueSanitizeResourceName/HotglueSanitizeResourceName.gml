// Feather disable all

/// @param name

function HotglueSanitizeResourceName(_name)
{
    static _filterMapStatic = (function()
    {
        var _map = ds_map_create();
        
        for(var _i = ord("0"); _i <= ord("9"); ++_i) _map[? _i] = true;
        for(var _i = ord("a"); _i <= ord("z"); ++_i) _map[? _i] = true;
        for(var _i = ord("A"); _i <= ord("Z"); ++_i) _map[? _i] = true;
        _map[? ord("_")] = true;
        
        return _map;
    })();
    
    static _bufferStatic = buffer_create(100, buffer_grow, 1);
    
    var _filterMap = _filterMapStatic;
    var _buffer = _bufferStatic;
    
    _name = filename_change_ext(string(_name), "");
    
    buffer_poke(_buffer, 0, buffer_string, _name);
    
    buffer_seek(_buffer, buffer_seek_start, 0);
    repeat(string_byte_length(_name))
    {
        var _byte = buffer_read(_buffer, buffer_u8);
        
        if (not ds_map_exists(_filterMap, _byte))
        {
            buffer_poke(_buffer, buffer_tell(_buffer)-1, buffer_u8, ord("_"));
        }
    }
    
    _name = buffer_peek(_buffer, 0, buffer_string);
    
    var _firstOrd = ord(string_char_at(_name, 1));
    if ((_firstOrd >= ord("0")) && (_firstOrd <= ord("9")))
    {
        _name = "_" + _name;
    }
    
    return _name;
}