logTab = new ClassTabLog();
InterfaceTrace("Interface created");

welcomeTab  = new ClassTabWelcome();
projectTab  = new ClassTabProject();
channelsTab = new ClassTabChannels();
settingsTab = new ClassTabSettings();

favoritesTab = new ClassChannelFavorites();
localTab     = new ClassChannelLocal();
channelArray = [];
array_push(channelArray, new ClassChannelGitHub().SetURL("https://raw.githubusercontent.com/JujuAdams/Hotglue-Index/refs/heads/main/github.json"));

context = new ImGuiContext(0, 0, window_get_width(), window_get_height(),
                           ImGuiConfigFlags.DockingEnable);

status = undefined;
staticBarHeight = 32;