// Feather disable all

/// Returns the cached value associated with the key. If no valid cache value is found, this
/// function will return the specified `default` value.
/// 
/// N.B. As per restrictions described in `HttpCacheCustomSet()`, a cached value will be one of the
///      following datatypes:
///      - boolean (`true` / `false`)
///      - `undefined`
///      - real number
///      - string
///      - array
///      - struct
/// 
/// @param key
/// @param [default=undefined]

function HttpCacheCustomGet(_key, _default = undefined)
{
    static _system = __HttpCacheSystem();
    static _cachedValueMap = _system.__cachedValueMap;
    
    var _value = _default;
    
    var _hash = md5_string_utf8(_key);
    
    if (not HTTP_CACHE_DISK_AVAILABLE)
    {
        return _cachedValueMap[? _hash] ?? _default;
    }
    else if (__HttpCacheExists(_hash))
    {
        try
        {
            var _buffer = buffer_load(__HttpCacheGetPath(_hash));
            var _jsonString = buffer_read(_buffer, buffer_text);
            buffer_delete(_buffer);
            
            _value = json_parse(_jsonString);
        }
        catch(_error)
        {
            show_debug_message(json_stringify(_error, true));
            __HttpCacheTrace($"Warning! Failed to parse cached data for \"{_key}\" ({_hash})");
        }
            
        if (_value != undefined)
        {
            if (HTTP_CACHE_VERBOSE)
            {
                __HttpCacheTrace($"Returning cached data for \"{_key}\" ({_hash})");
            }
            
            return _value;
        }
    }
    
    return _value;
}