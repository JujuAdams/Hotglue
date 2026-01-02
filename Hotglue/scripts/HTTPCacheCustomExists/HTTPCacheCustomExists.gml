// Feather disable all

/// Returns if the cache contains valid information associated with the key.
/// 
/// @param key

function HTTPCacheCustomExists(_key)
{
    static _cachedValueMap = __HTTPCacheSystem().__cachedValueMap;
    
    var _hash = md5_string_utf8(_key);
    
    if (HTTP_CACHE_DISK_AVAILABLE)
    {
        return __HTTPCacheExists(_hash);
    }
    else
    {
        return ds_map_exists(_cachedValueMap, _hash);
    }
}