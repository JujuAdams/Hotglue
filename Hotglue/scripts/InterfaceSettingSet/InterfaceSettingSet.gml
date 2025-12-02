/// @param key
/// @param value

function InterfaceSettingSet(_key, _value)
{
    if (not instance_exists(oInterface))
    {
        InterfaceWarning("`oInterface` has not been created yet");
        return;
    }
    
    oInterface.settings[$ _key] = _value;
}