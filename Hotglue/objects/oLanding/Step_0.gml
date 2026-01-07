// Feather disable all

if (is_struct(__automation))
{
    if (__automation.GetFinished())
    {
        game_end(__automation.GetError()? -1 : 0);
    }
}
else if (current_time >= __selfDestructTimer)
{
    game_end(__exitValue);
}