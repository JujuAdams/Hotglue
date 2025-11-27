// Feather disable all

randomize();

if ((os_type != os_windows) && (os_type != os_macosx))
{
    show_error(" \nThis platform is not supported\n ", true);
}

global.repoRoot = filename_dir(filename_dir(GM_project_filename)) + "/";

projectA = HotglueLoadYYMPS(global.repoRoot + "A/A.yymps");
projectB = HotglueLoadYYMPS(global.repoRoot + "B/B.yymps");
projectC = new HotglueProject(global.repoRoot + "C/C.yyp");

show_debug_message(json_stringify(projectA.GetConflicting(projectB), true));
show_debug_message(json_stringify(projectA.GetConflicting(projectC), true));
show_debug_message(json_stringify(projectB.GetConflicting(projectC), true));

projectC.ImportAll(projectA);