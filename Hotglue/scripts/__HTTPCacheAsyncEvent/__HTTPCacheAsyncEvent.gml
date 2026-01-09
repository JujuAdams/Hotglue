// Feather disable all

function __HttpCacheAsyncEvent()
{
    static _system         = __HttpCacheSystem();
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
                    __HttpCacheTrace($"HTTP request successful (status={_status}, httpStatus={_httpStatus})");
                }
                
                var _struct = json_parse(json_encode(async_load));
                _struct.response_headers = json_parse(json_encode(_responseHeaders));
                
                if (HTTP_CACHE_DISK_AVAILABLE)
                {
                    __HttpCacheSaveString(__HttpCacheGetPath(__hash), json_stringify(_struct));
                }
                else
                {
                    _cachedValueMap[? __hash] = _struct;
                }
                
                __HttpCacheAdd(__hash, __cacheLifetime);
            }
            else
            {
                if (HTTP_CACHE_VERBOSE)
                {
                    __HttpCacheTrace($"HTTP request failed (status={_status}, httpStatus={_httpStatus})");
                    __HttpCacheTrace(_result);
                }
            }
            
            if (is_callable(__callback))
            {
                __callback(_success, _result, _responseHeaders, __callbackData, __url);
            }
            
            __finished = true;
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
                __HttpCacheTrace($"HTTP file get successful (status={_status}, httpStatus={_httpStatus})");
                
                if (HTTP_CACHE_DISK_AVAILABLE)
                {
                    var _cachePath = __HttpCacheGetPath(__hash);
                    
                    if ((_cachePath != __destinationPath)
                    &&  (_cachePath != string_replace(__destinationPath, game_save_id, ""))
                    &&  (string_replace(_cachePath, game_save_id, "") != __destinationPath))
                    {
                        file_copy(_cachePath, __destinationPath);
                    }
                    
                    __HttpCacheAdd(__hash, __cacheLifetime);
                }
            }
            else
            {
                __HttpCacheTrace($"HTTP file get failed (status={_status}, httpStatus={_httpStatus})");
            }
            
            if (is_callable(__callback))
            {
                __callback(_success, __destinationPath, __callbackData, __url);
            }
            
            __finished = true;
        }
    }
}