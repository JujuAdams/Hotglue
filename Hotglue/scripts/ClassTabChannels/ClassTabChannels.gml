// Feather disable all

function ClassTabChannels() : ClassTab() constructor
{
    static TabItem = function()
    {
        if (ImGuiBeginTabItem($"Channels"))
        {
            ImGuiBeginChild("channelSelector");
            ImGuiBeginTabBar("tabBar");
            
            oInterface.favoritesTab.TabItem();
            oInterface.localTab.TabItem();
            
            var _channelArray = oInterface.channelArray;
            var _i = 0;
            repeat(array_length(_channelArray))
            {
                _channelArray[_i].TabItem();
                ++_i;
            }
            
            ImGuiEndTabBar();
            ImGuiEndChild();
            
            ImGuiEndTabItem();
        }
    }
}