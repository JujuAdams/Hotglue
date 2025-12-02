// Feather disable all

/// @param url

function HotglueEnsureChannel(_url)
{
    static _channelArray = __HotglueSystem().__channelArray;
    
    var _channel = HotglueGetChannelByURL(_url);
    
    if (_channel == undefined)
    {
        _channel = new __HotglueChannel(_url);
        array_push(_channelArray, _channel);
    }
    
    return _channel;
}