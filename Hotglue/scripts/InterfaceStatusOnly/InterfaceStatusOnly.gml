// Feather disable all

function InterfaceStatusOnly(_string)
{
    with(oInterface)
    {
        status = new (function(_string) constructor
        {
            __string = _string;
            
            static Build = function()
            {
                ImGuiText(__string);
            }
        })(_string);
    }
}