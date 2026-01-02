// Feather disable all

function __HTTPCacheAsyncEvent()
{
    static _system         = __HTTPCacheSystem();
    static _httpRequestMap = _system.__httpRequestMap;
    static _httpFileMap    = _system.__httpFileMap;
    static _cachedValueMap = _system.__cachedValueMap;
    
    var _id = async_load[? "id"];
    
    //http_get() and http_request()
    with(_httpRequestMap[? _id])
    {
        var _status = async_load[? "status"];
        if (_status == 0)
        {
            ds_map_delete(_httpRequestMap, _id);
            
            var _httpStatus      = async_load[? "http_status"];
            var _result          = async_load[? "result"];
            var _responseHeaders = async_load[? "response_headers"];
            
            var _success = __HTTPResponseIsSuccess(_httpStatus);
            if (_success)
            {
                if (HTTP_CACHE_VERBOSE)
                {
                    __HTTPCacheTrace($"HTTP request successful (status={_status}, httpStatus={_httpStatus})");
                }
                
                var _struct = json_parse(json_encode(async_load));
                _struct.response_headers = json_parse(json_encode(_responseHeaders));
                
                if (HTTP_CACHE_DISK_AVAILABLE)
                {
                    __HTTPCacheSaveString(__HTTPCacheGetPath(__hash), json_stringify(_struct));
                }
                else
                {
                    _cachedValueMap[? __hash] = _struct;
                }
                
                __HTTPCacheAdd(__hash, __durationMins);
            }
            else
            {
                if (HTTP_CACHE_VERBOSE)
                {
                    __HTTPCacheTrace($"HTTP request failed (status={_status}, httpStatus={_httpStatus})");
                    __HTTPCacheTrace(_result);
                }
            }
            
            if (is_callable(__callback))
            {
                __callback(_success, _result, _responseHeaders, __callbackData);
            }
        }
    }
    
    //http_get_file()
    with(_httpFileMap[? _id])
    {
        var _status = async_load[? "status"];
        if (_status == 0)
        {
            ds_map_delete(_httpRequestMap, _id);
            
            var _httpStatus = async_load[? "http_status"];
            var _success = __HTTPResponseIsSuccess(_httpStatus);
            if (_success)
            {
                __HTTPCacheTrace($"HTTP file get successful (status={_status}, httpStatus={_httpStatus})");
                
                if (HTTP_CACHE_DISK_AVAILABLE)
                {
                    if (__cachePath != __destinationPath)
                    {
                        file_copy(__cachePath, __destinationPath);
                    }
                    
                    __HTTPCacheAdd(__hash, __durationMins);
                }
            }
            else
            {
                __HTTPCacheTrace($"HTTP file get failed (status={_status}, httpStatus={_httpStatus})");
            }
            
            if (is_callable(__callback))
            {
                __callback(_success, __destinationPath, __callbackData);
            }
        }
    }
}