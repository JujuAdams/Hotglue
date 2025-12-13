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
        
        HotglueGetChannelByURL(HOTGLUE_FAVORITES_CHANNEL).Deserialize(InterfaceSettingGet("favorites", []));
        HotglueGetChannelByURL(HOTGLUE_LOCALS_CHANNEL).Deserialize(InterfaceSettingGet("locals", []));
    }
    
    LogTraceAndStatus("Settings loaded");
}