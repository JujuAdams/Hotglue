logTab = new ClassTabLog();

LogTrace("Interface created");

context = new ImGuiContext(0, 0, window_get_width(), window_get_height(),
                           ImGuiConfigFlags.DockingEnable);

LogTrace("ImGui context created");

welcomeTab   = new ClassTabWelcome();
projectTab   = new ClassTabImport();
channelsTab  = new ClassTabChannels();
inspectorTab = new ClassTabInspector();
settingsTab  = new ClassTabSettings();

LogTrace("Interface tabs created");

channelViewDict = {};
repositoryViewDict = {};

InterfaceSettingsReset();

if (file_exists("settings.json"))
{
    InterfaceSettingsLoad();
}
else
{
    InterfaceSettingsSave();
}

var _channel = HotglueEnsureRemoteChannel(HOTGLUE_CHANNEL_JSON, "Hotglue-Index", "https://raw.githubusercontent.com/JujuAdams/Hotglue-Index/refs/heads/main/github.json");
_channel.Refresh(function(_channel, _success)
{
    LogTraceAndStatus(_success? "Refreshed Hotglue-Index channel successfully" : "Failed to refresh Hotglue-Index channel");
});
        
var _channel = HotglueEnsureRemoteChannel(HOTGLUE_CHANNEL_GMK, "GameMaker Kitchen", "https://www.gamemakerkitchen.com/resource.json");
_channel.Refresh(function(_channel, _success)
{
    LogTraceAndStatus(_success? "Refreshed GameMaker Kitchen channel successfully" : "Failed to refresh GameMaker Kitchen channel");
});

statusBarHeight = 32;

popUpStruct = undefined;