function InterfaceSettingsReset()
{
    with(oInterface)
    {
        settings = {
            favorites: [],
            locals: [],
            channels: [],
        };
    }
    
    LogTrace("Settings reset");
}