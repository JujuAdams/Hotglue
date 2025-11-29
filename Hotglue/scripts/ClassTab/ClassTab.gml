// Feather disable all

function ClassTab() constructor
{
    static TabItem = function()
    {
        if (ImGuiBeginTabItem("Tab"))
        {
            ImGuiText("This tab is unimplemented.");
            ImGuiEndTabItem();
        }
    }
}