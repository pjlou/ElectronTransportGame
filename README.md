# CS499 Electron Transport Game

This game aims to teach the electron transport chain to introductory college level biology students.

## How to Run

### Windows 

Run ElectronTransportGame.exe

### Mac 

Mount biologyGame.dmg and run.  

Note that this project has not been notarized by Apple, which may cause Gatekeeper to not allow the program to run.  To temporarily allow un-notarized apps, follow the directions listed on this webpage: https://docs.godotengine.org/en/stable/tutorials/export/running_on_macos.html#doc-running-on-macos

Additionally, there is a bug currently present in the guided mode that prevents completing the game.

Alternatively, the project can be run in Godot as explained below.  This method avoids the two above issues.

### Run in Godot

Download Godot 4.6 and import the project.godot file. Then run within Godot by pressing F5 once the main scene has loaded.

## Features

This game has three modes that students can learn from.

### Guided mode 

This mode explains the electron transport chain step by step.  The user is able to drag and drop components to get a feel for what happens at each step in the chain.

### Unguided mode

This mode is a time attack game where the user uses their knowledge of the electron transport chain to generate ATP as quickly as possible.

### Flashcard mode

This mode allows users to practice their memory and recall of facts related to the electron transport chain.  Options to study by multiple choice or fill-in-the-blank are available.  It is also possible for the user to add their own questions, which will be retained in a customquestions.json file that can be found in the main directory upon exiting the program.  This file also retains information about how well the user has remembered the material, allowing for more efficient review sessions.

#### Note about flashcard questions:

While care has been taken to include high quality flashcard questions, it is currently recommended to replace the default questions as these were not created with the oversight of a licensed professional educator.  For biology teachers, the default flashcard questions can be replaced by placing a questions.json file in the main directory.  The program also supports creating custom flashcards from within the program, and these can replace the default questions by renaming the customquestions.json file to questions.json in the main directory.


This work was completed as part of a class at UAB, and it is a continuation of the work of another UAB class.  The previous group's work can be found here: https://github.com/Astrelle/UAB-Biology-ATP-Game 

