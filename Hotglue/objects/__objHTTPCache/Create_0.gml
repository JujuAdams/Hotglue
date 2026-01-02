// Feather disable all

time_source_start(time_source_create(time_source_global, 1, time_source_units_frames, function()
{
    if (not instance_exists(__objHTTPCache))
    {
        instance_activate_object(__objHTTPCache);
        
        if (GM_build_type == "run")
        {
            if (instance_exists(__objHTTPCache))
            {
                show_error(" \nHTTPCache:\n`__objHTTPCache` must never be deactivated\n ", true);
            }
            else
            {
                show_error(" \nHTTPCache:\n`__objHTTPCache` must never be destroyed\n ", true);
            }
        }
    }
    else
    {
        if (instance_number(__objHTTPCache) > 1)
        {
            show_error(" \nHTTPCache:\nThere must only be one `__objHTTPCache` instance at a time\n ", true);
        }
        
        if (not __objHTTPCache.persistent)
        {
            show_error(" \nHTTPCache:\n`__objHTTPCache` must be persistent\n ", true);
        }
    }
},
[], -1));