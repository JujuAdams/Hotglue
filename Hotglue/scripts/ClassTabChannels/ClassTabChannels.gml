// Feather disable all

function ClassTabChannels() : ClassTab() constructor
{
    static __name = "Explore Channels";
    
    static TabItem = function()
    {
        if (ImGuiBeginTabItem(__name, undefined, (oInterface.forceSelectedTab == __name)? ImGuiTabItemFlags.SetSelected : undefined))
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