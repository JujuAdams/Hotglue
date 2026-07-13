// Feather disable all

function InterfaceSettingsDeserialize()
{
    var _channel = HotglueGetChannelByURL(HOTGLUE_FAVORITES_CHANNEL_URL);
    _channel.DeserializeURLArray(InterfaceSettingGet("favorites", []));
    _channel.SortArray();
    
    var _channel = HotglueGetChannelByURL(HOTGLUE_CUSTOM_CHANNEL_URL);
    _channel.DeserializeURLArray(InterfaceSettingGet("custom", []));
    _channel.SortArray();
    
    HotglueChannelsDeserialize(InterfaceSettingGet("channels", []));
    
    HotglueSetItchAPIKey(InterfaceSettingGet("itch", ""));
    
    LogTrace("Settings deserialized");
}