welcomeTab  = new ClassTabWelcome();
projectTab  = new ClassTabProject();
settingsTab = new ClassTabSettings();
warningsTab = new ClassTabWarnings();

channelTabArray = [];
array_push(channelTabArray, new ClassTabGitHub());

context = new ImGuiContext(0, 0, window_get_width(), window_get_height(),
                           ImGuiConfigFlags.DockingEnable);

status = undefined;
staticBarHeight = 32;