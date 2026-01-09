// Feather disable all

/// Attempts to download a single file from the specified URL endpoint. If the request is
/// successful, a file will be saved at the destination path that you specified when calling the
/// function. Additionally, the downloaded file will be cached elsewhere on disk. Subsequent calls
/// to this function will use the cached file on disk as the source rather than redownloading a
/// file from the HTTP endpoint.
/// 
/// You should specify a callback to execute when HttpCache receives a response. Your callback
/// should take three parameters:
/// - success
/// - destinationPath
/// - callbackData
/// - requestURL
/// 
/// Ordinarily, you'll want to save the downloaded file to a specific location. However, if you
/// want to only use cached files and don't care about where the files are stored then you may
/// pass `undefined` for the destination path.
/// 
/// Cached data will be considered valid for a limited time span, as determined by the duration set
/// by `HttpCacheSetLifetimeMins()` (the default timeout is 5 minutes). Cached data is stored on
/// disk and can persist for hours or days if you so choose.
/// 
/// You can choose to delay a request by specifying a value for the optional `delaySeconds`
/// parameter. If you don't specify a value, the request will be submitted instantly. If you set a
/// negative value then the request will be put into a queue for execution.
/// 
/// @param url
/// @param destinationPath
/// @param callback
/// @param [callbackData]
/// @param [forceRedownload=false]
/// @param [delaySeconds=0]
/// @param [hashKey]

function HttpCacheGetFile(_url, _destinationPath, _callback, _callbackData = undefined, _forceRedownload = false, _delaySeconds = 0, _hashKey = _url)
{
    __HTTPEnsureObject();
    
    var _struct = new __HttpClassGetFile(_url, _destinationPath, _callback, _callbackData, _forceRedownload, _hashKey);
    
    if (_delaySeconds > 0)
    {
        call_later(max(1, _delaySeconds), time_source_units_seconds, method(_struct, _struct.__Start));
    }
    else if (_delaySeconds == 0)
    {
        _struct.__Start();
    }
    else
    {
        __HttpCacheQueue(_struct);
    }
    
    return _struct;
}