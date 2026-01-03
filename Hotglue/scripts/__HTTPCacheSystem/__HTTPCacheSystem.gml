// Feather disable all

function __HttpCacheSystem()
{
    static _system = undefined;
    if (_system != undefined) return _system;
    
    _system = {};
    with(_system)
    {
        __HttpCacheTrace($"Welcome to HTTP Cache by Juju Adams! This is version {HTTP_CACHE_VERSION}, {HTTP_CACHE_DATE}");
        
        
        //We use ds_map to contain hash information because struct keys leak memory when deleting keys.
        __nullMap        = ds_map_create(); //Avoids occasional `ds_map_destroy()` bugs
        __httpRequestMap = ds_map_create();
        __httpFileMap    = ds_map_create();
        __cachedValueMap = ds_map_create(); //Only used when disk cache is unavailable
        __cacheTimeMap   = ds_map_create();
        
        __globalDurationMins = 5;
        
        if (HTTP_CACHE_VERBOSE)
        {
            __HttpCacheTrace($"Cache duration defaults to {__globalDurationMins} minutes");
        }
        
        __HttpCacheTrace($"HTTP_CACHE_DISK_AVAILABLE = {HTTP_CACHE_DISK_AVAILABLE? "true" : "false"}");
        
        __cacheDirectory = undefined;
        HttpCacheSetDirectory(game_save_id + "httpCache/", (not HTTP_CACHE_DISK_AVAILABLE) || HTTP_CACHE_CLEAR_ON_BOOT);
    }
    
    return _system;
}