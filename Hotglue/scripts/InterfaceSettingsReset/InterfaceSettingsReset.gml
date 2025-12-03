function InterfaceSettingsReset()
{
    with(oInterface)
    {
        settings = {
            localLinks: [],
            favoriteLinks: [],
        };
    }
    
    LogTrace("Settings reset");
}