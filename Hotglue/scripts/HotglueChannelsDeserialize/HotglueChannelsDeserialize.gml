// Feather disable all

/// @param array

function HotglueChannelsDeserialize(_array)
{
    static _channelArray = __HotglueSystem().__channelArray;
    
    var _i = 0;
    repeat(array_length(_channelArray))
    {
        var _channel = _channelArray[_i];
        if (not _channel.__protected)
        {
            array_delete(_array, _i, 1);
        }
        else
        {
            ++_i;
        }
    }
    
    var _i = 0;
    repeat(array_length(_array))
    {
        var _data = _array[_i];
        HotglueEnsureRemoteChannel(_data.type, _data.name, _data.url, false);
        ++_i;
    }
    
    return _array;
}