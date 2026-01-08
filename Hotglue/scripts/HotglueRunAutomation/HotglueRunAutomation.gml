// Feather disable all

/// @param string

function HotglueRunAutomation(_string)
{
    try
    {
        var _json = json_parse(_string);
    }
    catch(_error)
    {
        __HotglueWarning($"Failed to parse JSON for automation");
        return undefined;
    }
    
    return new __HotglueClassAutomation(_json);
}