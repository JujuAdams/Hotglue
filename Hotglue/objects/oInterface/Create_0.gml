window_set_size(1280, 720);
window_center();

LogTrace("Interface created");

var _channel = HotglueEnsureRemoteChannel(HOTGLUE_CHANNEL_GITHUB_AUTH_USER, undefined, undefined, true);
_channel.Refresh();

context = new ImGuiContext(0, 0, window_get_width(), window_get_height(),
                           ImGuiConfigFlags.DockingEnable);

LogTrace("ImGui context created");

welcomeTab    = new ClassTabWelcome();
projectTab    = new ClassTabImport();
channelsTab   = new ClassTabChannels();
inspectorTab  = new ClassTabInspector();
automationTab = new ClassTabAutomation();
settingsTab   = new ClassTabSettings();

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

popUpStruct = InterfaceSettingGet("completedFTUX", false)? undefined : new ClassModalFTUX();

menuFocus = welcomeTab;
logOpen = InterfaceSettingGet("showLogOnBoot", false);

var _selectedTabName = InterfaceSettingGet("openOnTab", "Welcome");
if (welcomeTab.GetName()    == _selectedTabName) menuFocus = welcomeTab;
if (projectTab.GetName()    == _selectedTabName) menuFocus = projectTab;
if (channelsTab.GetName()   == _selectedTabName) menuFocus = channelsTab;
if (inspectorTab.GetName()  == _selectedTabName) menuFocus = inspectorTab;
if (automationTab.GetName() == _selectedTabName) menuFocus = automationTab;
if (settingsTab.GetName()   == _selectedTabName) menuFocus = settingsTab;

statusBarHeight = 32;