// Feather disable all

function ClassTabProject() : ClassTab() constructor
{
    static TabItem = function()
    {
        if (ImGuiBeginTabItem("Project"))
        {
            ImGuiSetCursorPosY(ImGuiGetCursorPosY() + 3);
            ImGuiTextWrapped("Project");
            ImGuiEndTabItem();
        }
    }
}