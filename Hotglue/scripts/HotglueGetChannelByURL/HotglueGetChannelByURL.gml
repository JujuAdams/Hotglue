// Feather disable all

/// @param url

function HotglueGetChannelByURL(_url)
{
    static _channelArray = __HotglueSystem().__channelArray;
    
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