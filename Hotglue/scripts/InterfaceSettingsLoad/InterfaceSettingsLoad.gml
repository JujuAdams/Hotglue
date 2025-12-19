function InterfaceSettingsLoad()
{
    if (not instance_exists(oInterface))
    {
        LogWarning("`oInterface` has not been created yet");
        return;
    }
    
    with(oInterface)
    {
        var _buffer = buffer_load(INTERACE_DEFAULT_PATH_SAVEDATA + "settings.json");
        var _string = buffer_read(_buffer, buffer_text);
        settings = json_parse(_string);
        buffer_delete(_buffer);
        
        InterfaceSettingsDeserialize();
    }
    
    LogTraceAndStatus("Settings loaded");
}