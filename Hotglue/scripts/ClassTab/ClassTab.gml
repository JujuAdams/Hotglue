// Feather disable all

function ClassTab() constructor
{
    static __name = "";
    
    static TabItem = function()
    {
        if (ImGuiBeginTabItem("Tab", undefined, (oInterface.forceSelectedTab == self)? ImGuiTabItemFlags.SetSelected : undefined))
        {
            ImGuiText("This tab is unimplemented.");
            ImGuiEndTabItem();
        }
    }
}