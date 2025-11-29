welcomeTab  = new ClassTabWelcome();
projectTab  = new ClassTabProject();
settingsTab = new ClassTabSettings();
warningsTab = new ClassTabWarnings();

channelArray = [];
array_push(channelArray, new ClassChannelGitHub().SetURL("https://raw.githubusercontent.com/JujuAdams/Hotglue-Index/refs/heads/main/github.json"));

context = new ImGuiContext(0, 0, window_get_width(), window_get_height(),
                           ImGuiConfigFlags.DockingEnable);

status = undefined;
staticBarHeight = 32;