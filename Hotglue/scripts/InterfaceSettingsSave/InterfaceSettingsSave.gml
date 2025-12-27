function InterfaceSettingsSave()
{
    with(oInterface)
    {
        InterfaceSettingSet("favorites", HotglueGetChannelByURL(HOTGLUE_FAVORITES_CHANNEL).SerializeURLArray());
        InterfaceSettingSet("locals", HotglueGetChannelByURL(HOTGLUE_LOCALS_CHANNEL).SerializeURLArray());
        
        settings.channels = HotglueChannelsSerialize();
        
        var _string = json_stringify(settings, true);
        var _buffer = buffer_create(string_byte_length(_string), buffer_fixed, 1);
        buffer_write(_buffer, buffer_text, _string);
        buffer_save(_buffer, INTERACE_DEFAULT_PATH_SAVEDATA + "settings.json");
        buffer_delete(_buffer);
    }
    
    LogTrace("Settings saved");
}