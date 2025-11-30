// Feather disable all

function ClassChannelFavorites() : ClassTab() constructor
{
    __linkArray = [];
    __selectedLink = undefined;
    
    static TabItem = function()
    {
        if (ImGuiBeginTabItem("*Favourites"))
        {
            Build();
            ImGuiEndTabItem();
        }
    }
    
    static Build = function()
    {
        ImGuiText("Favourites");
    }
}