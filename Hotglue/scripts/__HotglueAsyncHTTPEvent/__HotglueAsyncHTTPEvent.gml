// Feather disable all

function __HotglueAsyncHTTPEvent()
{
    static _httpRequestMap = __HotglueSystem().__httpRequestMap;
    
    var _id = async_load[? "id"];
    with(_httpRequestMap[? _id])
    {
        var _url        = async_load[? "url"];
        var _httpStatus = async_load[? "http_status"];
        var _status     = async_load[? "status"];
        var _result     = async_load[? "result"];
        
        if (_status == 0)
        {
            ds_map_delete(_httpRequestMap, _id);
            
            var _success = (floor(real(_httpStatus)/100) == 2);
            
            if (not _success)
            {
                __HotglueWarning($"\"{_url}\" HTTP request {_id} failed, status {_httpStatus}");
            }
            
            if (is_callable(__callback))
            {
                __callback(self, _success, _result);
            }
        }
    }
}