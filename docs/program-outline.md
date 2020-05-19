## Title Screen State
* Display title screen
* Once user presses Start:
  * Turn screen off
  * Load New Game screen
  * Set New Game State
  * Turn screen on
  
## New Game State


## Traveling the Trail State
* Check for events on the trail, such as breaking a leg, breaking a wagon wheel, etc.
* Update distance traveled and distance remaining to landmark.
* Update date.
* Update food remaining.
* Update health status.
* Has player arrived at landmark? If so, go to Landmark Display State, and then return.
* Is landmark river crossing? Display river crossing options, and then update river crossing.
* Does landmark have General Store?
* Has player pressed Start? If so, go to Paused State.
* Update sprites.

## Landmark Display State
* Display graphic for landmark and play appropriate music.
* Return to Traveling the Trail State.

## Paused State
* Display options for player:
  * Set pace: Steady, strenuous, grueling.
  * Set rations.
  * Rest.
  * Hunt for food.
