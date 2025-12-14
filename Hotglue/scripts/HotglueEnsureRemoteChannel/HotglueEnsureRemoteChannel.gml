// Feather disable all

/// @param type
/// @param name
/// @param url

function HotglueEnsureRemoteChannel(_type, _name, _url)
{
    static _channelArray = __HotglueSystem().__channelArray;
    
    var _channel = HotglueGetChannelByURL(_url);
    if (_channel == undefined)
    {
        if (_type == HOTGLUE_CHANNEL_JSON)
        {
            _channel = new __HotglueChannelGitHub(_name, _url);
        }
        else if (_type == HOTGLUE_CHANNEL_GMK)
        {
            _channel = new __HotglueChannelGMK(_name, _url);
        }
        else
        {
            _channel = new __HotglueChannelCommon(_name, _url);
        }
        
        array_push(_channelArray, _channel);
    }
    
    return _channel;
}