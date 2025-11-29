// Feather disable all

function HttpRequestAsyncHTTPEvent()
{
    with(__HttpRequestSystem())
    {
        var _id = async_load[? "id"];
        
        var _httpRequestArray = __httpRequestArray;
        var _i = 0;
        repeat(array_length(_httpRequestArray))
        {
            with(_httpRequestArray[_i])
            {
                if (__requestID == _id)
                {
                    var _httpStatus = async_load[? "http_status"];
                    var _status     = async_load[? "status"];
                    var _result     = async_load[? "result"];
                    
                    if (_status == 0)
                    {
                        var _success = (floor(real(_httpStatus)/100) == 2);
                        __callback(self, _success, _result);
                        
                        array_delete(_httpRequestArray, _i, 1);
                        return;
                    }
                }
            }
            
            ++_i;
        }
    }
}