ImGuiSetNextWindowSize(context.GetRegion().width, context.GetRegion().height - statusBarHeight, ImGuiCond.Always);
ImGuiSetNextWindowPos(0, 0, ImGuiCond.Always);

var _return = ImGuiBegin("mainWindow", true, ImGuiWindowFlags.NoResize | ImGuiWindowFlags.NoTitleBar | ImGuiWindowFlags.NoMove | ImGuiWindowFlags.MenuBar);
if (_return & ImGuiReturnMask.Return)
{
    if (ImGuiBeginMenuBar())
    {
        welcomeTab.MenuItem();
        projectTab.MenuItem();
        inspectorTab.MenuItem();
        channelsTab.MenuItem();
        automationTab.MenuItem();
        settingsTab.MenuItem();
        
        if (ImGuiMenuItem("Report Bug..."))
        {
            url_open("https://github.com/JujuAdams/Hotglue/issues/new");
        }
        
        ImGuiEndMenuBar();
    }
    
    if (logOpen)
    {
        InterfaceBuildLog();
    }
    else if (menuFocus != undefined)
    {
        menuFocus.Build();
    }
}
ImGuiEnd();

ImGuiSetNextWindowSize(context.GetRegion().width, statusBarHeight, ImGuiCond.Always);
ImGuiSetNextWindowPos(0, context.GetRegion().height, undefined, 0, 1, ImGuiCond.Always);
var _return = ImGuiBegin("statusBarWindow", true, ImGuiWindowFlags.NoResize | ImGuiWindowFlags.NoTitleBar | ImGuiWindowFlags.NoMove | ImGuiWindowFlags.NoScrollbar);
if (_return & ImGuiReturnMask.Return)
{
    if (LogGetNewWarnings())
    {
        ImGuiPushStyleColor(ImGuiCol.Button, INTERFACE_COLOR_RED_TEXT, 1);
    }
    
    if (ImGuiButton(logOpen? "Hide log" : "Show log"))
    {
        logOpen = not logOpen;
    }
    
    if (LogGetNewWarnings())
    {
        ImGuiPopStyleColor();
    }
    
    ImGuiSameLine(undefined, 30);
    
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