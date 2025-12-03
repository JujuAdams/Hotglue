logTab = new ClassTabLog();

LogTrace("Interface created");

context = new ImGuiContext(0, 0, window_get_width(), window_get_height(),
                           ImGuiConfigFlags.DockingEnable);

LogTrace("ImGui context created");

welcomeTab  = new ClassTabWelcome();
projectTab  = new ClassTabProject();
channelsTab = new ClassTabChannels();
settingsTab = new ClassTabSettings();

LogTrace("Interface tabs created");

channelViewDict = {};

InterfaceSettingsReset();

if (file_exists("settings.json"))
{
    InterfaceSettingsLoad();
}
else
{
    InterfaceSettingsSave();
}

HotglueEnsureRemoteChannel("GitHub", "https://raw.githubusercontent.com/JujuAdams/Hotglue-Index/refs/heads/main/github.json");

statusBarHeight = 32;