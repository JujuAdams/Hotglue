// Feather disable all

if (GM_build_type == "run")
{
    show_error(" \nHTTPCache:\n`__objHTTPCache` must never be destroyed\n ", true);
}

__HTTPEnsureObject();