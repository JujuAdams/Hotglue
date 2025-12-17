function InterfaceSettingsReset()
{
    with(oInterface)
    {
        settings = {
            savedataPath: INTERACE_DEFAULT_PATH_SAVEDATA,
            favorites: [],
            locals: [],
            channels: [],
        };
    }
    
    LogTrace("Settings reset");
}