// Feather disable all

function __HttpCacheSystem()
{
    static _system = undefined;
    if (_system != undefined) return _system;
    
    _system = {};
    with(_system)
    {
        __HttpCacheTrace($"Welcome to HTTP Cache by Juju Adams! This is version {HTTP_CACHE_VERSION}, {HTTP_CACHE_DATE}");
        
        __cacheDirectory = game_save_id + "httpCache/";
        
        //We use ds_map to contain hash information because struct keys leak memory when deleting keys.
        __nullMap        = ds_map_create(); //Avoids occasional `ds_map_destroy()` bugs
        __httpRequestMap = ds_map_create();
        __httpFileMap    = ds_map_create();
        __cachedValueMap = ds_map_create(); //Only used when disk cache is unavailable
        
        __globalDurationMins = 5;
        
        if (HTTP_CACHE_VERBOSE)
        {
            __HttpCacheTrace($"Cache duration defaults to {__globalDurationMins} minutes");
        }
        
        __HttpCacheTrace($"HTTP_CACHE_DISK_AVAILABLE = {HTTP_CACHE_DISK_AVAILABLE? "true" : "false"}");
        
        if ((not HTTP_CACHE_DISK_AVAILABLE) || HTTP_CACHE_CLEAR_ON_BOOT)
        {
            __cacheTimeMap = ds_map_create();
            HttpCacheClear();
        }
        else
        {
            var _manifestPath = __HttpCacheGetPath("manifest.json");
            if (not file_exists(_manifestPath))
            {
                __HttpCacheTrace($"Could not find cache manifest \"{_manifestPath}\", clearing cache directory");
                
                __cacheTimeMap = ds_map_create();
                HttpCacheClear();
            }
            else
            {
                __cacheTimeMap = undefined;
                
                try
                {
                    var _buffer = buffer_load(_manifestPath);
                    var _jsonString = buffer_read(_buffer, buffer_text);
                    buffer_delete(_buffer);
                    
                    __cacheTimeMap = json_decode(_jsonString);
                    __HttpCacheTrace($"Loaded cache manifest successfully, {ds_map_size(__cacheTimeMap)} entries in cache");
                }
                catch(_error)
                {
                    show_debug_message(json_stringify(_error, true));
                    __HttpCacheTrace("Warning! Failed to load cache manifest");
                }
                
                if ((__cacheTimeMap == undefined) || (not ds_exists(__cacheTimeMap, ds_type_map)))
                {
                    __cacheTimeMap = ds_map_create();
                }
                
                HttpCachePrune();
            }
        }
    }
    
    return _system;
}