ImGuiSetNextWindowSize(context.GetRegion().width, context.GetRegion().height - staticBarHeight, ImGuiCond.Always);
ImGuiSetNextWindowPos(0, 0, ImGuiCond.Always);

var _return = ImGuiBegin("mainWindow", true, ImGuiWindowFlags.NoResize | ImGuiWindowFlags.NoTitleBar | ImGuiWindowFlags.NoMove);
if (_return & ImGuiReturnMask.Return)
{
    ImGuiBeginTabBar("windowTabBar");
    
    welcomeTab.TabItem();
    projectTab.TabItem();
    channelsTab.TabItem();
    settingsTab.TabItem();
    logTab.TabItem();
    
    ImGuiEndTabBar();
}
ImGuiEnd();

ImGuiSetNextWindowSize(context.GetRegion().width, staticBarHeight, ImGuiCond.Always);
ImGuiSetNextWindowPos(0, context.GetRegion().height, undefined, 0, 1, ImGuiCond.Always);
var _return = ImGuiBegin("statusBarWindow", true, ImGuiWindowFlags.NoResize | ImGuiWindowFlags.NoTitleBar | ImGuiWindowFlags.NoMove | ImGuiWindowFlags.NoScrollbar);
if (_return & ImGuiReturnMask.Return)
{
    if (status == undefined)
    {
        ImGuiText("Ready!");
    }
    else
    {
        status.Build();
    }
}

ImGuiEnd();