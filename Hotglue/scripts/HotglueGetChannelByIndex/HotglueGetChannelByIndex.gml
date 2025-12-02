// Feather disable all

/// @param index

function HotglueGetChannelByIndex(_index)
{
    static _channelArray = __HotglueSystem().__channelArray;
    
    return ((_index >= 0) && (_index <= array_length(_channelArray)-1))? _channelArray[_index] : undefined;
}