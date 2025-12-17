// Feather disable all

function ClassTabChannels() : ClassTab() constructor
{
    static TabItem = function()
    {
        if (ImGuiBeginTabItem($"Explore Channels", undefined, (oInterface.forceSelectedTab == self)? ImGuiTabItemFlags.SetSelected : undefined))
        {
            ImGuiBeginChild("channelSelector");
            ImGuiBeginTabBar("tabBar");
            
            var _i = 0;
            repeat(HotglueGetChannelCount())
            {
                InterfaceEnsureChannelView(HotglueGetChannelByIndex(_i)).BuildForExplore();
                ++_i;
            }
            
            ImGuiEndTabBar();
            ImGuiEndChild();
            
            ImGuiEndTabItem();
        }
    }
}