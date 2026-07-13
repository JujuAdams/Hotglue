// Feather disable all

/// @param url

function HotglueGetChannelByURL(_url)
{
    static _system = __HotglueSystem();
    static _channelArray = _system.__channelArray;
    
    if (_url == HOTGLUE_TEMPORARY_CHANNEL_URL)
    {
        return _system.__temporaryChannel;
    }
    
    var _i = 0;
    repeat(array_length(_channelArray))
    {
        if (_channelArray[_i].GetURL() == _url)
        {
            return _channelArray[_i];
        }
        
        ++_i;
    }
    
    return undefined;
}