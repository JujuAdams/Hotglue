// Feather disable all

if ((os_type != os_windows) && (os_type != os_macosx))
{
    show_error(" \nThis platform is not supported\n ", true);
}

global.repoRoot = filename_dir(filename_dir(GM_project_filename)) + "/";

projectA = HotglueLoadYYMPS(global.repoRoot + "A/A.yymps");
//projectB = HotglueLoadYYMPS(global.repoRoot + "B/B.yymps");

projectDestination = new HotglueProject(global.repoRoot + "C/C.yyp");
projectDestination.ImportAllFrom(projectA);