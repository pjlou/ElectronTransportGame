# CS499 Electron Transport Game

This game aims to teach the electron transport chain to introductory college level biology students.

## How to Run

The project contains a pre-bundled Windows executable, but to edit the project or run on other platforms, the most reliable method is to run the project in Godot. 

To run the project in Godot, download Godot 4.6 from godotengine.org and download the project from github https://github.com/pjlou/ElectronTransportGame.  Unzip both folders and launch the Godot executable.  At the top left, there will be an option to import a project (shortcut: Ctrl + I).  Locate the project folder and select to import the project.godot file found in the main directory.  Click import to add the project to the project list in Godot’s project manager, then right-click and select to run the project.  Alternatively, double-click to open the project in the editor, then at the top right select to run the project (shortcut: F5).

## Features

This game has three modes that students can learn from.

### Guided mode 

This mode explains the electron transport chain step by step.  The user is able to drag and drop components to get a feel for what happens at each step in the chain.

### Unguided mode

This mode is a time attack game where the user uses their knowledge of the electron transport chain to generate ATP as quickly as possible.

### Flashcard mode

This mode allows users to practice their memory and recall of facts related to the electron transport chain.  Options to study by multiple choice or fill-in-the-blank are available.  It is also possible for the user to add their own questions, which will be retained in a customquestions.json file that can be found in the main directory upon exiting the program.  This file also retains information about how well the user has remembered the material, allowing for more efficient review sessions.

#### Note about flashcard questions:

While care has been taken to include high quality flashcard questions, it is currently recommended to replace the default questions as these were not created with the oversight of a licensed professional educator.  For biology teachers, the default flashcard questions can be replaced by placing a questions.json file in the main directory.  The program also supports creating custom flashcards from within the program, and these can replace the default questions by renaming the customquestions.json file to questions.json in the main directory.  The in-game flashcard editor can be located after running the project by clicking Start > Flashcard Mode > Custom Flashcards.	


This work was completed as part of a class at UAB, and it is a continuation of the work of another UAB class.  The previous group's work can be found here: https://github.com/Astrelle/UAB-Biology-ATP-Game 

