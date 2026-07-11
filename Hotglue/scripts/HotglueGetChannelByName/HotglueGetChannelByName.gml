// Feather disable all

/// @param name

function HotglueGetChannelByName(_name)
{
    static _channelArray = __HotglueSystem().__channelArray;
    
    var _i = 0;
    repeat(array_length(_channelArray))
    {
        if (_channelArray[_i].GetName() == _name)
        {
            return _channelArray[_i];
        }
        
        ++_i;
    }
    
    return undefined;
}