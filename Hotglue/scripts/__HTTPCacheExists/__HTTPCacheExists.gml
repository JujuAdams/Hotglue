// Feather disable all

/// @param hash

function __HttpCacheExists(_hash)
{
    static _cachedValueMap = __HttpCacheSystem().__cachedValueMap;
    
    if (__HTTPGetUTCTime() > __HttpCacheGetElapsedTime(_hash))
    {
        return false;
    }
    
    if (HTTP_CACHE_DISK_AVAILABLE)
    {
        return file_exists(__HttpCacheGetPath(_hash));
    }
    else
    {
        return ds_map_exists(_cachedValueMap, _hash);
    }
}