// Feather disable all

function HotglueChannelsSerialize()
{
    static _channelArray = __HotglueSystem().__channelArray;
    
    var _array = [];
    var _i = 0;
    repeat(array_length(_channelArray))
    {
        var _channel = _channelArray[_i];
        if (not _channel.__protected)
        {
            array_push(_array, _channel.Serialize());
        }
        
        ++_i;
    }
    
    return _array;
}