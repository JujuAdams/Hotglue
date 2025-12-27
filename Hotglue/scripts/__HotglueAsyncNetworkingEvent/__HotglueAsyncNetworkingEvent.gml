// Feather disable all

function __HotglueAsyncNetworkingEvent()
{
    static _system = __HotglueSystem();
    var _udpSocket = _system.__udpSocket;
    
    var _id     = async_load[? "id"];
    var _server = async_load[? "server"];
    var _socket = async_load[? "socket"];
    var _port   = async_load[? "port"];
    var _type   = async_load[? "type"];
    var _buffer = async_load[? "buffer"];
    
    LogTrace(json_encode(async_load, true));
    
    if (_id == _udpSocket)
    {
        var _string = buffer_read(_buffer, buffer_text);
        HotglueURIHandleString(_string);
    }
}