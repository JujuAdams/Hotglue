// Feather disable all

/// @param value

function HotglueSetItchAPIKey(_value)
{
    static _system = __HotglueSystem();
    
    _system.__itchAPIKey = _value;
}