function InterfaceSettingsSave()
{
    with(oInterface)
    {
        var _string = json_stringify(settings, true);
        var _buffer = buffer_create(string_byte_length(_string), buffer_fixed, 1);
        buffer_write(_buffer, buffer_text, _string);
        buffer_save(_buffer, "settings.json");
        buffer_delete(_buffer);
    }
    
    InterfaceTrace("Settings saved");
}