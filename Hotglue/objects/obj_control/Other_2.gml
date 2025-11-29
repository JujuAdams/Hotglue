///
/// Game Start Event
///

/// @description KTF Tests Init
if os_get_config() == "Test" {
    if (global.ktf.enabled && (not instance_exists(obj_ktf_stepper))) {
        instance_create_depth(0,0,0,obj_ktf_stepper);
    }
}