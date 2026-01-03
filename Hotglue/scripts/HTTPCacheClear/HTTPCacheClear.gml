// Feather disable all

/// Clears the cache on disk, freeing up disk space and forcing subsequent HttpCache functions to
/// redownload data.

function HttpCacheClear()
{
    static _system = __HttpCacheSystem();
    static _httpRequestMap = _system.__httpRequestMap;
    static _cachedValueMap = _system.__cachedValueMap;
    
    ds_map_clear(_httpRequestMap);
    ds_map_clear(_cachedValueMap);
    
    if (HTTP_CACHE_DISK_AVAILABLE)
    {
        directory_destroy(_system.__cacheDirectory);
        
        if (HTTP_CACHE_VERBOSE)
        {
            __HttpCacheTrace($"Cleared cache (deleted directory \"{_system.__cacheDirectory}\")");
        }
    }
    else
    {
        if (HTTP_CACHE_VERBOSE)
        {
            __HttpCacheTrace($"Cleared cache");
        }
    }
}