// Feather disable all

/// @param index

function HotglueDeleteChannel(_index)
{
    static _channelArray = __HotglueSystem().__channelArray;
    
    array_delete(_channelArray, _index, 1);
}