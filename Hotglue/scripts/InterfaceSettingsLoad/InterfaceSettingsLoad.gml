function InterfaceSettingsLoad()
{
    if (not instance_exists(oInterface))
    {
        InterfaceWarning("`oInterface` has not been created yet");
        return;
    }
    
    with(oInterface)
    {
        var _buffer = buffer_load("settings.json");
        var _string = buffer_read(_buffer, buffer_text);
        settings = json_parse(_string);
        buffer_delete(_buffer);
        
        HotglueGetChannelByURL("@favorites").Deserialize(InterfaceSettingGet("favorites", []));
        HotglueGetChannelByURL("@locals").Deserialize(InterfaceSettingGet("locals", []));
    }
    
    InterfaceStatus("Settings loaded");
}