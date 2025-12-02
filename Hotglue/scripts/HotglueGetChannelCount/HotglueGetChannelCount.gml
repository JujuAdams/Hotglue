// Feather disable all

function HotglueGetChannel()
{
    static _channelArray = __HotglueSystem().__channelArray;
    
    return array_length(_channelArray);
}