ImGuiSetNextWindowSize(context.GetRegion().width, context.GetRegion().height - staticBarHeight, ImGuiCond.Always);
ImGuiSetNextWindowPos(0, 0, ImGuiCond.Always);

var _return = ImGuiBegin("mainWindow", true, ImGuiWindowFlags.NoResize | ImGuiWindowFlags.NoTitleBar | ImGuiWindowFlags.NoMove);
if (_return & ImGuiReturnMask.Return)
{
    ImGuiBeginTabBar("windowTabBar");
    
    welcomeTab.TabItem();
    projectTab.TabItem();
    
    var _i = 0;
    repeat(array_length(channelArray))
    {
        channelArray[_i].TabItem();
        ++_i;
    }
    
    settingsTab.TabItem();
    warningsTab.TabItem();
    
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

//if (_exitModal) ImGuiOpenPopup("Exit?");
//
//ImGuiSetNextWindowPos(window_get_width()/2, window_get_height ()/2, ImGuiCond.Appearing, 0.5, 0.5);
//if (ImGuiBeginPopupModal("Exit?", undefined, ImGuiWindowFlags.NoResize))
//{
//    ImGuiText("Are you sure you want to exit?");
//    ImGuiSeparator();
//    if (ImGuiButton("Yes")) game_end();
//    ImGuiSameLine();
//    if (ImGuiButton("Nevermind")) ImGuiCloseCurrentPopup();
//    ImGuiEndPopup();
//}