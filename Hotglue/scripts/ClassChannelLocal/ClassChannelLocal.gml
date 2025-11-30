// Feather disable all

function ClassChannelLocal() : ClassTab() constructor
{
    __linkArray = [];
    __selectedLink = undefined;
    
    static TabItem = function()
    {
        if (ImGuiBeginTabItem("Local"))
        {
            Build();
            ImGuiEndTabItem();
        }
    }
    
    static Build = function()
    {
        ImGuiText("Local");
    }
}