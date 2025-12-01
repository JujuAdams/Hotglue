logTab = new ClassTabLog();

InterfaceTrace("Interface created");

welcomeTab  = new ClassTabWelcome();
projectTab  = new ClassTabProject();
channelsTab = new ClassTabChannels();
settingsTab = new ClassTabSettings();

favoritesTab = new ClassChannelFavorites();
localTab     = new ClassChannelLocal();
channelArray = [];

InterfaceSettingsReset();

if (file_exists("settings.json"))
{
    InterfaceSettingsLoad();
}
else
{
    InterfaceSettingsSave();
}

var _settingsChannelArray = InterfaceSettingGet("channels", []);
var _i = 0;
repeat(array_length(_settingsChannelArray))
{
    var _settingsChannel = _settingsChannelArray[_i];
    
    if (_settingsChannel.type == "github")
    {
        array_push(channelArray, new ClassChannelGitHub().SetURL(_settingsChannel.url));
    }
    else
    {
        InterfaceWarning($"Channel could not be loaded    {json_stringify(_settingsChannel)}");
    }
    
    ++_i;
}

InterfaceStatus($"Loaded {array_length(channelArray)} channels");

context = new ImGuiContext(0, 0, window_get_width(), window_get_height(),
                           ImGuiConfigFlags.DockingEnable);

status = undefined;
staticBarHeight = 32;