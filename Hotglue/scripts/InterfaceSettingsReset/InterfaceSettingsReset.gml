function InterfaceSettingsReset()
{
    with(oInterface)
    {
        settings = {
            openOnTab: "Welcome",
            savedataPath: INTERACE_DEFAULT_PATH_SAVEDATA,
            favorites: [],
            custom: [],
            channels: [
                {
                    name: "Hotglue Index",
                    url:  "https://raw.githubusercontent.com/JujuAdams/Hotglue-Index/refs/heads/main/github.json",
                    type: HOTGLUE_CHANNEL_JSON,
                },
                {
                    name: "GameMaker Kitchen",
                    url:  "https://www.gamemakerkitchen.com/resource.json",
                    type: HOTGLUE_CHANNEL_GMK,
                },
            ],
        };
    }
    
    LogTrace("Settings reset");
    
    InterfaceSettingsDeserialize();
}