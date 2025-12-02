// Feather disable all

/// @param url

function HotglueEnsureRemoteChannel(_url)
{
    static _channelArray = __HotglueSystem().__channelArray;
    
    var _channel = HotglueGetChannelByURL(_url);
    if (_channel == undefined)
    {
        if (__HotglueGuessURLIsGitHub(_url))
        {
            _channel = new __HotglueChannelGitHub(_url);
        }
        else
        {
            _channel = new __HotglueChannelCommon(_url);
        }
        
        array_push(_channelArray, _channel);
    }
    
    return _channel;
}