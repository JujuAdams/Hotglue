function InterfaceSettingsLoad()
{
    if (not instance_exists(oInterface))
    {
        LogWarning("`oInterface` has not been created yet");
        return;
    }
    
    with(oInterface)
    {
        var _buffer = buffer_load("settings.json");
        var _string = buffer_read(_buffer, buffer_text);
        settings = json_parse(_string);
        buffer_delete(_buffer);
        
        var _channel = HotglueGetChannelByURL(HOTGLUE_FAVORITES_CHANNEL);
        _channel.DeserializeURLArray(InterfaceSettingGet("favorites", []));
        _channel.SortArray();
        
        var _channel = HotglueGetChannelByURL(HOTGLUE_LOCALS_CHANNEL);
        _channel.DeserializeURLArray(InterfaceSettingGet("locals", []));
        _channel.SortArray();
        
        HotglueChannelsDeserialize(InterfaceSettingGet("channels", []));
    }
    
    LogTraceAndStatus("Settings loaded");
}