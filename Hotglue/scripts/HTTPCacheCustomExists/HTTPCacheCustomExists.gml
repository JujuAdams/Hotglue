// Feather disable all

/// Returns if the cache contains valid information associated with the key.
/// 
/// @param key

function HttpCacheCustomExists(_key)
{
    static _cachedValueMap = __HttpCacheSystem().__cachedValueMap;
    
    var _hash = md5_string_utf8(_key);
    
    if (HTTP_CACHE_DISK_AVAILABLE)
    {
        return __HttpCacheExists(_hash);
    }
    else
    {
        return ds_map_exists(_cachedValueMap, _hash);
    }
}