function InterfaceSettingsReset()
{
    with(oInterface)
    {
        settings = {
            channels: [
                {
                    url: "https://raw.githubusercontent.com/JujuAdams/Hotglue-Index/refs/heads/main/github.json",
                    type: "github",
                },
            ],
            localLinks: [],
            favoriteLinks: [],
        };
    }
    
    LogTrace("Settings reset");
}