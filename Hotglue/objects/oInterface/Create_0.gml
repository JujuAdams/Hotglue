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

InterfaceRecentLoad();
forceSelectedTab = InterfaceSettingGet("openOnTab", "Welcome");

statusBarHeight = 32;

popUpStruct = undefined;