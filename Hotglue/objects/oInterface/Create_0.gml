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

githubChannel = HotglueEnsureRemoteChannel("GitHub", "https://raw.githubusercontent.com/JujuAdams/Hotglue-Index/refs/heads/main/github.json");
githubChannel.Refresh(function(_channel, _success)
{
    LogTraceAndStatus(_success? "Refreshed GitHub channel successfully" : "Failed to refresh GitHub channel");
});

statusBarHeight = 32;