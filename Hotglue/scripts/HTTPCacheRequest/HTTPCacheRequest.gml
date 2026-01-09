// Feather disable all

/// Makes an HTTP request to the specified URL endpoint using a custom HTTP method, header map, and
/// body (please see documentation for `http_request()` for more information. If the request is
/// successful, the returned data (including response headers) are cached on disk. Subsequent calls
/// to this function for the same endpoint/method/headers/bddy will attempt to use the cached value
/// on disk if available.
/// 
/// You should specify a callback to execute when HttpCache receives a response. Your callback
/// should take four parameters:
/// - success
/// - result
/// - responseHeaders
/// - callbackData
/// - requestURL
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
/// @param method
/// @param headerMap
/// @param body
/// @param callback
/// @param [callbackData]
/// @param [forceRedownload=false]
/// @param [delaySeconds=0]
/// @param [hashKey]

function HttpCacheRequest(_url, _method, _headerMap, _body, _callback, _callbackData = undefined, _forceRedownload = false, _delaySeconds = 0, _hashKey = undefined)
{
    __HTTPEnsureObject();
    
    var _struct = new __HttpClassRequest(_url, _method, _headerMap, _body, _callback, _callbackData, _forceRedownload, _hashKey);
    
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