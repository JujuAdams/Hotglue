// Feather disable all

/// @param channel

function InterfaceEnsureChannelView(_channel)
{
    with(oInterface)
    {
        var _channelView = channelViewDict[$ ptr(_channel)];
        if (_channelView == undefined)
        {
            var _channelView = new ClassInterfaceChannelView(_channel);
            channelViewDict[$ ptr(_channel)] = _channelView;
        }
        
        return _channelView;
    }
    
    return undefined;
}