ImGuiSetNextWindowSize(context.GetRegion().width, context.GetRegion().height - statusBarHeight, ImGuiCond.Always);
ImGuiSetNextWindowPos(0, 0, ImGuiCond.Always);

var _return = ImGuiBegin("mainWindow", true, ImGuiWindowFlags.NoResize | ImGuiWindowFlags.NoTitleBar | ImGuiWindowFlags.NoMove);
if (_return & ImGuiReturnMask.Return)
{
    ImGuiBeginTabBar("windowTabBar");
    
    welcomeTab.TabItem();
    projectTab.TabItem();
    channelsTab.TabItem();
    inspectorTab.TabItem();
    settingsTab.TabItem();
    logTab.TabItem();
    
    ImGuiEndTabBar();
}
ImGuiEnd();

ImGuiSetNextWindowSize(context.GetRegion().width, statusBarHeight, ImGuiCond.Always);
ImGuiSetNextWindowPos(0, context.GetRegion().height, undefined, 0, 1, ImGuiCond.Always);
var _return = ImGuiBegin("statusBarWindow", true, ImGuiWindowFlags.NoResize | ImGuiWindowFlags.NoTitleBar | ImGuiWindowFlags.NoMove | ImGuiWindowFlags.NoScrollbar);
if (_return & ImGuiReturnMask.Return)
{
    var _status = LogGetStatus();
    if (is_callable(_status))
    {
        _status();
    }
    else
    {
        ImGuiText(string(_status ?? "Ready!"));
    }
}

ImGuiEnd();

if (is_struct(popUpStruct))
{
    if (not popUpStruct.Build())
    {
        popUpStruct = undefined;
    }
}