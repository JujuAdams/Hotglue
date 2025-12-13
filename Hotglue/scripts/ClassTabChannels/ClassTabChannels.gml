// Feather disable all

function ClassTabChannels() : ClassTab() constructor
{
    static TabItem = function()
    {
        if (ImGuiBeginTabItem($"Explore Channels"))
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