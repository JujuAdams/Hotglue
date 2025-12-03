// Feather disable all

function HotglueGetChannelCount()
{
    static _channelArray = __HotglueSystem().__channelArray;
    
    return array_length(_channelArray);
}