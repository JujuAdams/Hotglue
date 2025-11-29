// Feather disable all

function ClassTabSettings() : ClassTab() constructor
{
    static TabItem = function()
    {
        if (ImGuiBeginTabItem("Settings"))
        {
            ImGuiSetCursorPosY(ImGuiGetCursorPosY() + 3);
            ImGuiText("Settings");
            ImGuiEndTabItem();
        }
    }
}