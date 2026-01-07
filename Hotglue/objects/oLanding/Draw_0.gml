// Feather disable all

draw_sprite(sJuju, 0, 0, 0);

if (__automation != undefined)
{
    draw_set_color(c_black);
    draw_text(10, 10, "Running automation, please wait...");
}