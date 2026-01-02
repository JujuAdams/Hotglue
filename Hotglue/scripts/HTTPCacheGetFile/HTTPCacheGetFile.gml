// Feather disable all

/// Attempts to download a single file from the specified URL endpoint. If the request is
/// successful, a file will be saved at the destination path that you specified when calling the
/// function. Additionally, the downloaded file will be cached elsewhere on disk. Subsequent calls
/// to this function will use the cached file on disk as the source rather than redownloading a
/// file from the HTTP endpoint.
/// 
/// You should specify a callback to execute when HTTPCache receives a response. Your callback
/// should take three parameters:
/// - success
/// - destinationPath
/// - callbackData
/// 
/// Ordinarily, you'll want to save the downloaded file to a specific location. However, if you
/// want to only use cached files and don't care about where the files are stored then you may
/// pass `undefined` for the destination path.
/// 
/// Cached data will be considered valid for a limited time span, as determined by the duration set
/// by `HTTPCacheSetDurationMins()` (the default timeout is 5 minutes). Cached data is stored on
/// disk and can persist for hours or days if you so choose.
/// 
/// @param url
/// @param destinationPath
/// @param callback
/// @param [callbackData]
/// @param [cacheFileExtension]
/// @param [forceRedownload=false]

function HTTPCacheGetFile(_url, _destinationPath, _callback, _callbackData = undefined, _cacheFileExtension = undefined, _forceRedownload = false)
{
    static _system = __HTTPCacheSystem();
    static _httpFileMap = _system.__httpFileMap;
    
    __HTTPEnsureObject();
    
    var _hash = md5_string_utf8(_url);
    
    if (_cacheFileExtension != undefined)
    {
        _hash += _cacheFileExtension;
    }
    
    var _cachePath = __HTTPCacheGetPath(_hash);
    _destinationPath ??= _cachePath;
    
    var _requestID = -1;
    
    if (not HTTP_CACHE_DISK_AVAILABLE)
    {
        _requestID = http_get_file(_url, _destinationPath);
        if (_requestID < 0)
        {
            if (HTTP_CACHE_VERBOSE)
            {
                __HTTPCacheTrace($"`http_get_file()` failed for \"{_url}\"");
            }
            
            if (is_callable(__callback))
            {
                call_later(1, time_source_units_frames, method({
                    __cachePath:       _cachePath,
                    __destinationPath: _destinationPath,
                    __callback:        _callback,
                    __callbackData:    _callbackData,
                },
                function()
                {
                    __callback(false, __destinationPath, __callbackData);
                }), false);
            }
        }
        else
        {
            if (HTTP_CACHE_VERBOSE)
            {
                __HTTPCacheTrace($"Executed `http_get_file()` for \"{_url}\"");
            }
            
            _httpFileMap[? _requestID] = new __HTTPClassCacheFileGet(undefined, _destinationPath, _callback, _callbackData, _system.__globalDurationMins);
        }
    }
    else
    {
        if ((not _forceRedownload) && __HTTPCacheExists(_hash))
        {
            if (HTTP_CACHE_VERBOSE)
            {
                __HTTPCacheTrace($"File has been cached for \"{_url}\" ({_hash})");
            }
            
            file_copy(_cachePath, _destinationPath);
            
            if (is_callable(_callback))
            {
                call_later(1, time_source_units_frames, method({
                    __cachePath:       _cachePath,
                    __destinationPath: _destinationPath,
                    __callback:        _callback,
                    __callbackData:    _callbackData,
                },
                function()
                {
                    __callback(true, __destinationPath, __callbackData);
                }), false);
            }
        }
        else
        {
            _requestID = http_get_file(_url, __HTTPCacheGetPath(_hash));
            if (_requestID < 0)
            {
                if (HTTP_CACHE_VERBOSE)
                {
                    __HTTPCacheTrace($"`http_get_file()` failed for \"{_url}\" ({_hash})");
                }
                
                if (is_callable(__callback))
                {
                    call_later(1, time_source_units_frames, method({
                        __cachePath:       _cachePath,
                        __destinationPath: _destinationPath,
                        __callback:        _callback,
                        __callbackData:    _callbackData,
                    },
                    function()
                    {
                        __callback(false, __destinationPath, __callbackData);
                    }), false);
                }
            }
            else
            {
                if (HTTP_CACHE_VERBOSE)
                {
                    __HTTPCacheTrace($"Executed `http_get_file()` for \"{_url}\" ({_hash})");
                }
                
                _httpFileMap[? _requestID] = new __HTTPClassCacheFileGet(_hash, _destinationPath, _callback, _callbackData, _system.__globalDurationMins);
            }
        }
    }
    
    return _requestID;
}