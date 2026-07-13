// Feather disable all

/// @param name

function HotglueGetChannelByName(_name)
{
    static _system = __HotglueSystem();
    static _channelArray = _system.__channelArray;
    
    if (_name == HOTGLUE_TEMPORARY_CHANNEL_URL)
    {
        return _system.__temporaryChannel;
    }
    
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