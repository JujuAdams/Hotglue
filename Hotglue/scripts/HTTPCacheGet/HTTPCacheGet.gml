// Feather disable all

/// Makes an HTTP GET request to the specified URL endpoint. If the request is successful, the
/// returned data (including response headers) are cached on disk. Subsequent calls to this
/// function for the same endpoint will attempt to use the cached value on disk if available.
/// 
/// You should specify a callback to execute when HttpCache receives a response. Your callback
/// should take four parameters:
/// - success
/// - result
/// - responseHeaders
/// - callbackData
/// 
/// Cached data will be considered valid for a limited time span, as determined by the duration set
/// by `HttpCacheSetLifetimeMins()` (the default timeout is 5 minutes). Cached data is stored on
/// disk and can persist for hours or days if you so choose.
/// 
/// @param url
/// @param callback
/// @param [callbackData]
/// @param [delay=0]
/// @param [forceRedownload=false]
/// @param [hashKey]

function HttpCacheGet(_url, _callback, _callbackData = undefined, _delay = 0, _forceRedownload = false, _hashKey = _url)
{
    __HTTPEnsureObject();
    
    var _struct = new __HttpClassGet(_url, _callback, _callbackData, _forceRedownload, _hashKey);
    
    if (_delay > 0)
    {
        call_later(max(1, _delay), time_source_units_frames, method(_struct, _struct.__Start));
    }
    else if (_delay == 0)
    {
        _struct.__Start();
    }
    else
    {
        __HttpCacheQueue(_struct);
    }
    
    return _struct;
}