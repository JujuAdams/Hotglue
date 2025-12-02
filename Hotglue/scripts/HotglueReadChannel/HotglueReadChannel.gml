// Feather disable all

/// @param url
/// @param [callback]

function HotglueReadChannel(_url, _callback = undefined)
{
    var _channel = new __HotglueChannel(_url)
    _channel.Refresh(_callback);
    return _channel;
}