// Feather disable all

/// @param type
/// @param name
/// @param url
/// @param [protected=false]

function HotglueEnsureRemoteChannel(_type, _name, _url, _protected = false)
{
    static _channelArray = __HotglueSystem().__channelArray;
    
    var _channel = HotglueGetChannelByURL(_url);
    if (_channel == undefined)
    {
        if (_type == HOTGLUE_CHANNEL_JSON)
        {
            _channel = new __HotglueChannelGitHub(_name, _url, _protected);
        }
        else if (_type == HOTGLUE_CHANNEL_DIRECTORY)
        {
            _channel = new __HotglueChannelDirectory(_name, _url, _protected);
        }
        else if (_type == HOTGLUE_CHANNEL_GMK)
        {
            _channel = new __HotglueChannelGMK(_name, _url, _protected);
        }
        else if (_type == HOTGLUE_CHANNEL_GITHUB_USER)
        {
            _channel = new __HotglueChannelGitHubUser(_name, _url, _protected);
        }
        else
        {
            _channel = new __HotglueChannelCommon(_name, _url, _protected);
        }
        
        array_push(_channelArray, _channel);
    }
    
    return _channel;
}