# Date display while at landmarks

As landmarks will be fullscreen, I need to find some
efficient way to represent the date displayed while
visiting the landmark, keeping in mind sprite limitations.
I think I can store the landmark, its name, and the year
as background tiles, with the month and day then shown as
sprite tiles. I can represent the month as three chars, which
will help keep me under the 8 horizontal sprite limit, especially
if the player is still traveling the trail in November or
December.
