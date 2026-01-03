// Feather disable all

if (GM_build_type == "run")
{
    show_error(" \nHttpCache:\n`__objHttpCache` must never be destroyed\n ", true);
}

__HTTPEnsureObject();