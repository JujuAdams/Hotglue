logTab = new ClassTabLog();

LogTrace("Interface created");

var _channel = HotglueEnsureRemoteChannel(HOTGLUE_CHANNEL_JSON, "Hotglue-Index", "https://raw.githubusercontent.com/JujuAdams/Hotglue-Index/refs/heads/main/github.json", true);
_channel.Refresh();
        
var _channel = HotglueEnsureRemoteChannel(HOTGLUE_CHANNEL_GMK, "GameMaker Kitchen", "https://www.gamemakerkitchen.com/resource.json", true);
_channel.Refresh();

context = new ImGuiContext(0, 0, window_get_width(), window_get_height(),
                           ImGuiConfigFlags.DockingEnable);

LogTrace("ImGui context created");

welcomeTab   = new ClassTabWelcome();
projectTab   = new ClassTabImport();
channelsTab  = new ClassTabChannels();
inspectorTab = new ClassTabInspector();
settingsTab  = new ClassTabSettings();

forceSelectedTab = projectTab;

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

InterfaceRecentLoad();

statusBarHeight = 32;

popUpStruct = undefined;