/// @param key
/// @param [default]

function InterfaceSettingGet(_key, _default = undefined)
{
    var _value = _default;
    
    with(oInterface)
    {
        _value = settings[$ _key] ?? _default;
    }
    
    return _value;
}