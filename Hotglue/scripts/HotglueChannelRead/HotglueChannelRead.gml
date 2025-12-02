// Feather disable all

/// @param url
/// @param [callback]

function HotglueChannelRead(_url, _callback = undefined)
{
    var _channel = new __HotglueChannel(_url)
    _channel.Refresh(_callback);
    return _channel;
}