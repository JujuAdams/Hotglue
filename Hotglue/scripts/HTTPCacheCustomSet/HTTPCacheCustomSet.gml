// Feather disable all

/// Caches a value associated with a key. You can later retrieve this value using
/// `HTTPCacheCustomGet()`.
/// 
/// N.B. The value set by this function must be one of the following datatypes:
///      - boolean (`true` / `false`)
///      - `undefined`
///      - real number
///      - string
///      - array
///      - struct
/// 
/// Cached data will be considered valid for a limited time span, as determined by the duration set
/// by `HTTPCacheSetDurationMins()` (the default timeout is 5 minutes). Cached data is stored on
/// disk and can persist for hours or days if you so choose.
/// 
/// @param key
/// @param value

function HTTPCacheCustomSet(_key, _value)
{
    static _system = __HTTPCacheSystem();
    static _cachedValueMap = _system.__cachedValueMap;
    
    var _hash = md5_string_utf8(_key);
    
    if (HTTP_CACHE_DISK_AVAILABLE)
    {
        __HTTPCacheSaveString(__HTTPCacheGetPath(_hash), json_stringify(_value));
        __HTTPCacheAdd(_hash, _system.__globalDurationMins);
    }
    else
    {
        _cachedValueMap[? _hash] = _value;
        __HTTPCacheAdd(_hash, _system.__globalDurationMins);
    }
}