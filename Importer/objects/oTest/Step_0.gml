// Feather disable all

if (keyboard_check_pressed(ord("T")))
{
    var _filename = get_open_filename("*.yymps", "");
    if (_filename != "")
    {
        projectTest = HotglueLoadYYMPS(_filename);
        projectDestination.ImportAll(projectTest);
    }
}