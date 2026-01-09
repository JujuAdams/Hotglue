// Feather disable all

/// @param url
/// @param method
/// @param headerMap
/// @param body
/// @param callback
/// @param callbackData
/// @param forceRedownload
/// @param hashKey

function __HttpClassRequest(_url, _method, _headerMap, _body, _callback, _callbackData, _forceRedownload, _hashKey) constructor
{
    static _system = __HttpCacheSystem();
    static _httpRequestMap = _system.__httpRequestMap;
    static _cachedValueMap = _system.__cachedValueMap;
    
    __url             = _url;
    __method          = _method;
    __headerMap       = _headerMap;
    __body            = _body;
    __callback        = _callback;
    __callbackData    = _callbackData;
    __forceRedownload = _forceRedownload;
    __hashKey         = _hashKey ?? $"{_url}::{_method}::{json_encode(_headerMap)}::{_body}";
    
    __cacheLifetime = _system.__globalLifetimeMins;
    __hash = md5_string_utf8(__hashKey);
    
    __asyncLoad = undefined;
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
    
    static GetRequestID = function()
    {
        return __requestID;
    }
    
    static __Start = function()
    {
        __HTTPEnsureObject();
        
        __started = true;
        
        if ((not __forceRedownload) && __HttpCacheExists(__hash))
        {
            if (not is_callable(__callback))
            {
                __requestID = -1;
                __finished  = true;
                
                return;
            }
            else
            {
                if (HTTP_CACHE_DISK_AVAILABLE)
                {
                    try
                    {
                        var _buffer = buffer_load(__HttpCacheGetPath(__hash));
                        var _jsonString = buffer_read(_buffer, buffer_text);
                        buffer_delete(_buffer);
                    
                        __asyncLoad = json_decode(_jsonString);
                    }
                    catch(_error)
                    {
                        show_debug_message(json_stringify(_error, true));
                        __HttpCacheTrace($"Warning! Failed to parse cached data for \"{__hashKey}\" ({__hash})");
                    }
                }
                else
                {
                    __asyncLoad = _cachedValueMap[? __hash];
                }
                
                if (__asyncLoad != undefined)
                {
                    if (HTTP_CACHE_VERBOSE)
                    {
                        __HttpCacheTrace($"Returning cached data for \"{__hashKey}\" ({__hash})");
                    }
                    
                    call_later(1, time_source_units_frames, function()
                    {
                        var _success         = __HTTPResponseIsSuccess(__asyncLoad[? "http_status"]);
                        var _result          = __asyncLoad[? "result"];
                        var _responseHeaders = __asyncLoad[? "response_headers"];
                    
                        __callback(_success, _result, _responseHeaders, __callbackData, __url);
                    
                        ds_map_destroy(__asyncLoad);
                        __finished = true;
                    });
                    
                    __requestID = -1;
                    
                    return;
                }
            }
        }
        
        __requestID = http_request(__url, __method, __headerMap, __body);
        if (__requestID < 0)
        {
            if (HTTP_CACHE_VERBOSE)
            {
                __HttpCacheTrace($"`http_request()` failed for \"{__hashKey}\" ({__hash})");
            }
            
            if (is_callable(__callback))
            {
                call_later(1, time_source_units_frames, function()
                {
                    var _responseHeaders = ds_map_create();
                    __callback(false, "", _responseHeaders, __callbackData, __url);
                    ds_map_destroy(_responseHeaders);
                    
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
                __HttpCacheTrace($"Executed `http_request()` for \"{__hashKey}\" ({__hash}, request={__requestID})");
            }
            
            _httpRequestMap[? __requestID] = self;
        }
    }
}