// Feather disable all

/// Makes an HTTP request to the specified URL endpoint using a custom HTTP method, header map, and
/// body (please see documentation for `http_request()` for more information. If the request is
/// successful, the returned data (including response headers) are cached on disk. Subsequent calls
/// to this function for the same endpoint/method/headers/bddy will attempt to use the cached value
/// on disk if available.
/// 
/// You should specify a callback to execute when HTTPCache receives a response. Your callback
/// should take four parameters:
/// - success
/// - result
/// - responseHeaders
/// - callbackData
/// 
/// Cached data will be considered valid for a limited time span, as determined by the duration set
/// by `HTTPCacheSetDurationMins()` (the default timeout is 5 minutes). Cached data is stored on
/// disk and can persist for hours or days if you so choose.
/// 
/// @param url
/// @param method
/// @param headerMap
/// @param body
/// @param callback
/// @param [callbackData]
/// @param [forceRedownload=false]

function HTTPCacheRequest(_url, _method, _headerMap, _body, _callback, _callbackData = undefined, _forceRedownload = false)
{
    static _system = __HTTPCacheSystem();
    static _requestDictionary = _system.__httpRequestMap;
    static _cachedValueMap = _system.__cachedValueMap;
    
    __HTTPEnsureObject();
    
    var _hashKey = $"{_url}::{_method}::{json_encode(_headerMap)}::{_body}";
    var _hash = md5_string_utf8(_hashKey);
    if ((not _forceRedownload) && __HTTPCacheExists(_hash))
    {
        if (not is_callable(_callback))
        {
            return;
        }
        else
        {
            if (HTTP_CACHE_DISK_AVAILABLE)
            {
                var _asyncLoad = undefined;
                try
                {
                    var _buffer = buffer_load(__HTTPCacheGetPath(_hash));
                    var _jsonString = buffer_read(_buffer, buffer_text);
                    buffer_delete(_buffer);
                    
                    _asyncLoad = json_decode(_jsonString);
                }
                catch(_error)
                {
                    show_debug_message(json_stringify(_error, true));
                    __HTTPCacheTrace($"Warning! Failed to parse cached data for \"{_hashKey}\" ({_hash})");
                }
            }
            else
            {
                var _asyncLoad = _cachedValueMap[? _hash];
            }
            
            if (_asyncLoad != undefined)
            {
                if (HTTP_CACHE_VERBOSE)
                {
                    __HTTPCacheTrace($"Returning cached data for \"{_hashKey}\" ({_hash})");
                }
                
                call_later(1, time_source_units_frames, method({
                    __asyncLoad:    _asyncLoad,
                    __callback:     _callback,
                    __callbackData: _callbackData,
                },
                function()
                {
                    var _success         = __HTTPResponseIsSuccess(__asyncLoad[? "http_status"]);
                    var _result          = __asyncLoad[? "result"];
                    var _responseHeaders = __asyncLoad[? "response_headers"];
                    
                    __callback(_success, _result, _responseHeaders, __callbackData);
                    
                    ds_map_destroy(__asyncLoad);
                }), false);
                
                return;
            }
        }
    }
    
    var _requestID = http_request(_url, _method, _headerMap, _body);
    if (_requestID < 0)
    {
        if (HTTP_CACHE_VERBOSE)
        {
            __HTTPCacheTrace($"`http_request()` failed for \"{_hashKey}\" ({_hash})");
        }
        
        if (is_callable(__callback))
        {
            call_later(1, time_source_units_frames, method({
                __callback:     _callback,
                __callbackData: _callbackData,
            },
            function()
            {
                var _responseHeaders = ds_map_create();
                __callback(false, "", _responseHeaders, __callbackData);
                ds_map_destroy(_responseHeaders);
            }), false);
        }
    }
    else
    {
        if (HTTP_CACHE_VERBOSE)
        {
            __HTTPCacheTrace($"Executed `http_request()` for \"{_hashKey}\" ({_hash})");
        }
        
        _requestDictionary[? _requestID] = new __HTTPClassCacheRequest(_hash, _callback, _callbackData, _system.__globalDurationMins);
    }
}