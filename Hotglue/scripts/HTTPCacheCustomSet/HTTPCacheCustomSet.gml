// Feather disable all

/// Caches a value associated with a key. You can later retrieve this value using
/// `HttpCacheCustomGet()`.
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
/// by `HttpCacheSetLifetimeMins()` (the default timeout is 5 minutes). Cached data is stored on
/// disk and can persist for hours or days if you so choose.
/// 
/// @param key
/// @param value

function HttpCacheCustomSet(_key, _value)
{
    static _system = __HttpCacheSystem();
    static _cachedValueMap = _system.__cachedValueMap;
    
    var _hash = md5_string_utf8(_key);
    
    if (HTTP_CACHE_DISK_AVAILABLE)
    {
        __HttpCacheSaveString(__HttpCacheGetPath(_hash), json_stringify(_value));
        __HttpCacheAdd(_hash, _system.__globalLifetimeMins);
    }
    else
    {
        _cachedValueMap[? _hash] = _value;
        __HttpCacheAdd(_hash, _system.__globalLifetimeMins);
    }
}