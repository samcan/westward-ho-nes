## Title Screen State
* Display title screen
* Once user presses Start:
  * Turn screen off
  * Load New Game screen
  * Set New Game State
  * Turn screen on
  
## New Game State
* Get occupation, which determines score multiplier, effect (if any), and starting cash.
* Get other party members' names.
* Get starting month.
* Go to General Store State.

## Traveling the Trail State
* Check for events on the trail, such as breaking a leg, breaking a wagon wheel, etc.
* Update distance traveled and distance remaining to landmark.
* Update date.
* Update food remaining.
* Update health status.
* Has player arrived at landmark? If so, go to Landmark Display State, and then return.
* Is landmark river crossing? Display river crossing options, and then update river crossing.
* Does landmark have General Store? If so, load General Store State.
* Read input from controller
  * Has player pressed Start? If so, go to Paused State.
* Update sprites.
* Go back to start of Traveling the Trail State.

## Landmark Display State
* Display graphic for landmark and play appropriate music.
* Read controller input.
  * Once button has been pressed, check if landmark the Willamette Valley? If so, go to End Game State, else return to Traveling the Trail State.
  * If no button has been pressed, loop back and read controller input.

## Paused State
* Display options for player:
  * Press Start to unpause.
  * View supplies status.
  * Display map.
  * Set pace: Steady, strenuous, grueling.
  * Set rations.
  * Rest.
  * Attempt to trade. (?)
  * Hunt for food.
  * Quit game.
  
## General Store State
* Display purchase options available. Allow user to select options.
* Ensure money is available.
* Return to Traveling the Trail State and update supplies and money.

## End Game State
* Calculate ending score based on score multiplier, party health, party members remaining, supplies remaining, and cash remaining.
* Display ending score information.
* Read controller input, looping back to display ending score information.
* Once user presses Start:
  * Turn screen off.
  * Load title screen
  * Turn screen on.
