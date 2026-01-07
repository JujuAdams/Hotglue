// Feather disable all

/// @param value

function HotglueSetItchAPIKey(_value)
{
    static _system = __HotglueSystem();
    
    if (_value != _system.__itchAPIKey)
    {
        if (_value != "")
        {
            __HotglueTrace("Set itch.io API key (secret value)");
        }
        else
        {
            __HotglueTrace("Cleared itch.io API key");
        }
        
        _system.__itchAPIKey = _value;
    }
}