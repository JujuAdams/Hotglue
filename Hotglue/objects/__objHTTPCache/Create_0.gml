// Feather disable all

time_source_start(time_source_create(time_source_global, 1, time_source_units_frames, function()
{
    if (not instance_exists(__objHttpCache))
    {
        instance_activate_object(__objHttpCache);
        
        if (GM_build_type == "run")
        {
            if (instance_exists(__objHttpCache))
            {
                show_error(" \nHttpCache:\n`__objHttpCache` must never be deactivated\n ", true);
            }
            else
            {
                show_error(" \nHttpCache:\n`__objHttpCache` must never be destroyed\n ", true);
            }
        }
    }
    else
    {
        if (instance_number(__objHttpCache) > 1)
        {
            show_error(" \nHttpCache:\nThere must only be one `__objHttpCache` instance at a time\n ", true);
        }
        
        if (not __objHttpCache.persistent)
        {
            show_error(" \nHttpCache:\n`__objHttpCache` must be persistent\n ", true);
        }
    }
},
[], -1));