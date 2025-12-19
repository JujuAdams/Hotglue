// Feather disable all

function InterfaceSettingsDeserialize()
{
    var _channel = HotglueGetChannelByURL(HOTGLUE_FAVORITES_CHANNEL);
    _channel.DeserializeURLArray(InterfaceSettingGet("favorites", []));
    _channel.SortArray();
    
    var _channel = HotglueGetChannelByURL(HOTGLUE_LOCALS_CHANNEL);
    _channel.DeserializeURLArray(InterfaceSettingGet("locals", []));
    _channel.SortArray();
    
    HotglueChannelsDeserialize(InterfaceSettingGet("channels", []));
    
    LogTrace("Settings deserialized");
}