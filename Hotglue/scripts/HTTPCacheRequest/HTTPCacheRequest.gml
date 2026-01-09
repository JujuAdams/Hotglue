// Feather disable all

/// Makes an HTTP request to the specified URL endpoint using a custom HTTP method, header map, and
/// body (please see documentation for `http_request()` for more information. If the request is
/// successful, the returned data (including response headers) are cached on disk. Subsequent calls
/// to this function for the same endpoint/method/headers/bddy will attempt to use the cached value
/// on disk if available.
/// 
/// You should specify a callback to execute when HttpCache receives a response. Your callback
/// should take four parameters which are (in order):
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
/// @param method
/// @param headerMap
/// @param body
/// @param callback
/// @param [callbackData]
/// @param [delay=0]
/// @param [forceRedownload=false]
/// @param [hashKey]

function HttpCacheRequest(_url, _method, _headerMap, _body, _callback, _callbackData = undefined, _delay = 0, _forceRedownload = false, _hashKey = undefined)
{
    __HTTPEnsureObject();
    
    var _struct = new __HttpClassRequest(_url, _method, _headerMap, _body, _callback, _callbackData, _forceRedownload, _hashKey);
    
    if (_delay > 0)
    {
        call_later(max(1, _delay), time_source_units_seconds, method(_struct, _struct.__Start));
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