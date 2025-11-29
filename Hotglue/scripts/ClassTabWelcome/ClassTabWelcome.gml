// Feather disable all

function ClassTabWelcome() : ClassTab() constructor
{
    static TabItem = function()
    {
        if (ImGuiBeginTabItem("Welcome"))
        {
            ImGuiSetCursorPosY(ImGuiGetCursorPosY() + 3);
            ImGuiTextWrapped("Welcome to Hotglue by Juju Adams. This is version 0.0.0, 2025-11-09.");
            ImGuiTextWrapped("ImGui is by Omar Cornut. ImGui implementation (ImGM) by knno, based on work by Nommiin.");
            ImGuiTextWrapped("GitHub.gml by Alub.");
            ImGuiNewLine();
            ImGuiTextWrapped("Hotglue is a GameMaker 2024.14 import tool. It will help you import and update libraries in your GameMaker games.");
            ImGuiEndTabItem();
        }
    }
}