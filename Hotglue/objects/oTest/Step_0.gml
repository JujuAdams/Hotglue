// Feather disable all

if (keyboard_check_pressed(ord("T")))
{
    var _filename = get_open_filename("*.yyp", "");
    if (_filename != "")
    {
        projectTest = HotglueLoadYYP(_filename);
        
        var _destinationProject = HotglueLoadYYP(GM_project_filename);
        _destinationProject.ImportAllFrom(projectTest, "ImGM");
    }
}