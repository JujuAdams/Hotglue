// Feather disable all

/// Sets the absolute path to the cache directory. If the new path is different to the previous
/// path then the cache will be cleared.
/// 
/// N.B. The behaviour of this function is not dependent on whether local disk caching is
///      available.
/// 
/// @param path
/// @param [clearOnChange=true]

function HttpCacheSetDirectory(_path, _clearOnChange = true)
{
    static _system = __HttpCacheSystem();
    
    with(_system)
    {
        if (_path != __cacheDirectory)
        {
            if (_clearOnChange)
            {
                HttpCacheClear();
            }
        
            __HttpCacheTrace($"Set cache directory to \"{_path}\"");
            __cacheDirectory = _path;
        
            var _manifestPath = __HttpCacheGetPath("manifest.json");
            if (not file_exists(_manifestPath))
            {
                __HttpCacheTrace($"Could not find cache manifest \"{_manifestPath}\", clearing cache directory");
                
                __cacheTimeMap = ds_map_create();
                HttpCacheClear();
            }
            else
            {
                ds_map_destroy(__cacheTimeMap);
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
}