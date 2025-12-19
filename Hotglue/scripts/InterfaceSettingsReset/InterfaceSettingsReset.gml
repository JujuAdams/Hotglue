function InterfaceSettingsReset()
{
    with(oInterface)
    {
        settings = {
            openOnTab: "Welcome",
            savedataPath: INTERACE_DEFAULT_PATH_SAVEDATA,
            favorites: [],
            locals: [],
            channels: [
                {
                    name: "Hotglue-Index",
                    url:  "https://raw.githubusercontent.com/JujuAdams/Hotglue-Index/refs/heads/main/github.json",
                    type: HOTGLUE_CHANNEL_JSON,
                },
                {
                    name: "GameMaker Kitchen",
                    url:  "https://www.gamemakerkitchen.com/resource.json",
                    type: HOTGLUE_CHANNEL_GMK,
                },
                {
                    name: "Juju Adams",
                    url:  "https://www.github.com/jujuadams/",
                    type: HOTGLUE_CHANNEL_GITHUB_USER,
                },
            ],
        };
    }
    
    LogTrace("Settings reset");
    
    InterfaceSettingsDeserialize();
}