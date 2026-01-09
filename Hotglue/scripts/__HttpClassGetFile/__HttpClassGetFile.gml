// Feather disable all

/// @param url
/// @param destinationPath
/// @param callback
/// @param callbackData
/// @param forceRedownload
/// @param hashKey

function __HttpClassGetFile(_url, _destinationPath, _callback, _callbackData, _forceRedownload, _hashKey) constructor
{
    static _system = __HttpCacheSystem();
    static _httpFileMap = _system.__httpFileMap;
    
    __url                = _url;
    __destinationPath    = _destinationPath;
    __callback           = _callback;
    __callbackData       = _callbackData;
    __forceRedownload    = _forceRedownload;
    __hashKey            = _hashKey;
    
    __cacheLifetime = _system.__globalLifetimeMins;
    __hash = md5_string_utf8(__hashKey);
    
    if (is_string(__destinationPath))
    {
        if ((string_pos("/", __destinationPath) <= 0) && (string_pos("\\", __destinationPath) <= 0) && (string_pos(".", __destinationPath) > 0))
        {
            if (filename_change_ext(filename_name(__destinationPath), "") == "")
            {
                __hash += filename_ext(__destinationPath);
            }
        }
    }
    
    __cachePath = __HttpCacheGetPath(__hash);
    __destinationPath ??= __cachePath;
    
    __requestID = undefined;
    __started   = false;
    __finished  = false;
    
    
    
    static GetStarted = function()
    {
        return __started;
    }
    
    static GetFinished = function()
    {
        return __finished;
    }
    
    static GetDestinationPath = function()
    {
        return __destinationPath;
    }
    
    static GetCachePath = function()
    {
        return __cachePath;
    }
    
    static GetRequestID = function()
    {
        return __requestID;
    }
    
    static __Start = function()
    {
        __HTTPEnsureObject();
        
        __started = true;
        
        if (not HTTP_CACHE_DISK_AVAILABLE)
        {
            __requestID = http_get_file(__url, __destinationPath);
            if (__requestID < 0)
            {
                if (HTTP_CACHE_VERBOSE)
                {
                    __HttpCacheTrace($"`http_get_file()` failed for \"{__url}\"");
                }
                
                if (is_callable(__callback))
                {
                    call_later(1, time_source_units_frames, function()
                    {
                        __callback(false, __destinationPath, __callbackData, __url);
                        __finished = true;
                    });
                }
                else
                {
                    __finished = true;
                }
            }
            else
            {
                if (HTTP_CACHE_VERBOSE)
                {
                    __HttpCacheTrace($"Executed `http_get_file()` for \"{__url}\"");
                }
                
                _httpFileMap[? __requestID] = self;
            }
        }
        else
        {
            if ((not __forceRedownload) && __HttpCacheExists(__hash))
            {
                if (HTTP_CACHE_VERBOSE)
                {
                    __HttpCacheTrace($"File has been cached for \"{__url}\" ({__hash})");
                }
                
                file_copy(__cachePath, __destinationPath);
                
                if (is_callable(__callback))
                {
                    call_later(1, time_source_units_frames, function()
                    {
                        __callback(true, __destinationPath, __callbackData, __url);
                        __finished = true;
                    });
                }
                else
                {
                    __finished = true;
                }
            }
            else
            {
                __requestID = http_get_file(__url, __HttpCacheGetPath(__hash));
                if (__requestID < 0)
                {
                    if (HTTP_CACHE_VERBOSE)
                    {
                        __HttpCacheTrace($"`http_get_file()` failed for \"{__url}\" ({__hash})");
                    }
                    
                    if (is_callable(__callback))
                    {
                        call_later(1, time_source_units_frames, function()
                        {
                            __callback(false, __destinationPath, __callbackData, __url);
                            __finished = true;
                        });
                    }
                    else
                    {
                        __finished = true;
                    }
                }
                else
                {
                    if (HTTP_CACHE_VERBOSE)
                    {
                        __HttpCacheTrace($"Executed `http_get_file()` for \"{__url}\" ({__hash})");
                    }
                    
                    _httpFileMap[? __requestID] = self;
                }
            }
        }
    }
}