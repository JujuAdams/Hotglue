/// @desc Test 1 - dynamic sprites button grid
/// Test 1 - ord("1")

button_grid_open = !button_grid_open;

if button_grid_open {
    if !button_grid_loaded {
        if !GM_is_sandboxed {
            button_sprites = load_sprites(filename_dir(GM_project_filename) + "/../../../tests/sprites", "*.png");
        } else {
            button_sprites = load_sprites(game_save_id + "\\tests\\sprites", "*.png");
        }
        button_grid_loaded = true;
    } else {
        show_debug_message($"load_sprites: already loaded in-memory.");
    }
}