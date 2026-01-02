// Feather disable all

/// @param hash

function __HTTPCacheExists(_hash)
{
    static _cachedValueMap = __HTTPCacheSystem().__cachedValueMap;
    
    if (__HTTPGetUTCTime() > __HTTPCacheGetElapsedTime(_hash))
    {
        return false;
    }
    
    if (HTTP_CACHE_DISK_AVAILABLE)
    {
        return file_exists(__HTTPCacheGetPath(_hash));
    }
    else
    {
        return ds_map_exists(_cachedValueMap, _hash);
    }
}