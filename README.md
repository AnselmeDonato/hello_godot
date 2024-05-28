# hello_godot

Learning and testing Godot

## What is this mess of a project?

This "mess of a project" as i so nicely put it, is the result of an aggregation of several objectives of mine. Along the last few months/years, I'v wanted to do several things:

- dip my toes into the world of game development
- have a code side project to improve my coding skills
- have a code side project to make my CV shine brighter
- replicate cool videos I've seen around youtube (mainly from the goat [Sebastian Lague](https://www.youtube.com/@SebastianLague))
- prove myself that I have the self-discipline to work on a middle to long term project
- recreate an old mobile game of my childhood, no longer distributed, called [Trial by Survival](https://www.facebook.com/TrialBySurvival/)
- learn Godot to see what the fuss is about
- learn Godot to give myself an edge in the hypothetical Godot Game Jam that my friend group plan to do one day
- distract myself from my job
- distract myself from the fact that no matter the time I spend, I have not been able to get better at piano and drawing and video game.
- craft a plan to reach my dream job of technical artist in a video game studio
- ...

and many more. Rather than tackling each subject in a separate and managable way for optimal results like a normal human being, I decided to bundle everything together and run into that wall head first. The (only) benefit of this approach is that it's easier to find motivation to work on this project: as it's a response to many of my current aspirations, I can draw energy to put into it from any of said aspirations. The main risk is that it will probably grow into a kraken too big to manage in the next weeks, and end up in the graveyard that is my GitHub account. Time will tell.

For now, let's try to keep track of everything I've done so far.

## Trial by Survival - Rebirth

The over-arching theme of this projet is to re-create the game Trial by Survival. This game is, or rather was, a 2d top-down zombi shooter where you had to survive a given number of randomly generated levels (filled with zombis of course). There are several types of levels:

- forest
- road
- suburb
- town
- bunker

Each level has its own kind of terrain (the main difference being the ammount of buildlings they contain), and ammount of zombis. Each one also has a single randomly placed exit, to leave the level. A level can be completed in two ways: either find the exit or kill all the zombis.

The three typical kinds of zombis are here too:

- regular
- heavy, with more HP and damage but slower
- runners, with less HP but faster

As the game goes on, the difficulty ramp up too: each new level contains more and more zombies. To compensate that, between each level the player can spend XP points (obtained by killing zombis) to enhance its statistics. There is also a simple crafting system to build/enhance weapons with parts randomly scattered accross levels.

Ammunition and health packs are limited, and can be randomly found in levels. They can also be crafted.

There is a night/day cycle-like: each level correspond to one day. Between levels, the player is given the option to sleep and automatically go to the next day, or stay awake and explore the level at night time to try to find more ressources/XP. At night, the player field of view is reduced to its flashlight, and there are more zombis.

## Level Generation

As previously mentioned, each level is randomly generated. This is the occasion to explore an interesting way to randomly generate levels according to a set of constraints: wave-function collapse. This is heavily inspired by the video [Superpositions, Sudoku, the Wave Function Collapse algorithm](https://www.youtube.com/watch?v=2SuvO4Gi7uY) by [Martin Donald](https://www.youtube.com/@MartinDonald) on YouTube.

## Zombis behavior

From what I remember, the behavior of zombis in the original Trial by Survival was pretty straightforward: random movement until they spot the player (either by sight or by hearing, if the player shoots or break a window for example), and then move towards the player. But for this project, let's try to spice things up a little bit and add flock-like behavior. This is heavily inspired by the video [Coding Adventure: Boids](https://www.youtube.com/watch?v=bqtqltqcQhw) by [Sebastian Lague](https://www.youtube.com/@SebastianLague) on YouTube.

## How to run the project

Well, you shouldn't. But in case you want to give it a try:

- install [Godot](https://godotengine.org)
- download this repository
- open the godot project (`project.godot` file)
- run the project (little icon on the top right, or Cmd+B or Ctrl+B)
