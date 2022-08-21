# New Super Mario Bros.Wii: The Prankster Comets
## Public Resources Release

### Information 

This repo includes some of the resources used to make the [**New Super Mario Bros. Wii: The Prankster Comets**](https://youtu.be/5QI8ACl1E9c) game mod, which is a mod of **New Super Mario Bros. Wii** based on [**Newer Super Mario Bros. Wii**](https://newerteam.com/wii/).

These resources include:
- The game's source code (`Kamek` folder)
- The game's code loader (`Loader` folder)
- An all-in-one toolbox to edit various of the custom file formats used in the game (`PranksterToolbox` folder)
- Miscellaneous tools used during development, including a **[Level Info Editor](https://github.com/RoadrunnerWMC/Level-Info-Editor) mod** (`Tools` folder)
- The game's [Reggie Next v4.8.0](https://github.com/CLF78/Reggie-Next/tree/v4.8.0) patch (`Reggie` folder)

This repo is (meant to be) a fork of the [/Newer-Team/NewerSMBW, clang-no-translations branch](https://github.com/Newer-Team/NewerSMBW/tree/clang-no-translations) repo since part of [**Newer Super Mario Bros. Wii**](https://newerteam.com/wii/)'s code was used in [**New Super Mario Bros. Wii: The Prankster Comets**](https://youtu.be/5QI8ACl1E9c).

Unfortunately, GitHub doesn't allow to fork the same repo more than once so this repo isn't marked as a fork.

### Using this code

This repo is meant as a public archive for people to take parts from to make their own **New Super Mario Bros. Wii** mods better. Feel free to use anything as long as credits are given (see Credits section below).

HOWEVER, please do NOT try to "finish" the [**New Super Mario Bros. Wii: The Prankster Comets**](https://youtu.be/5QI8ACl1E9c) game mod. It is CANCELLED and I do not wish for it to be revived by anyone.

While I can't really do anything to prevent people from doing so, if someone does try to revive the mod I will publicly state that it was done without my consent and that I encourage not to play said mod.

### Compiling / Assembling

#### Compiling the game's source code (`Kamek` folder)

* Install [Python 2.7](https://www.python.org/download/releases/2.7/) with the modules [`pyyaml`](https://github.com/yaml/pyyaml/tree/5.4.1.1) and [`pyelftools`](https://github.com/eliben/pyelftools) in your `C:\` directory, so the path `C:\Python27\python.exe` is valid.

* If you're struggling with that, [here's a direct link](https://drive.google.com/file/d/19SXhD7GiSNXLqYpC8_DKudwZ5et_RM6b/view?usp=sharing) to an installed Python 2.7 with said modules, though it's bad practice to download this kind of thing directly as it could contain malware.

* Download the tool binaries [here](https://drive.google.com/file/d/1v1Qg7yv8ss3fTHtvBvGh8plukPmq_ptB/view?usp=sharing), unzip them and place them in `Kamek`'s `tools` folder.

* Now, if you want to compile only the PALv1 region of the game for obvious playtesting and debugging purposes, run the `#makeNewerKP.bat` script. Otherwise, run the `#makeNewerKP-release.bat` script. You'll find your compiled code in the `Build` folder.

#### Assembling the game's code loader (`Loader` folder)

* In the `Loader` folder, run the `compile.bat` script and it'll assemble all `.S` files in the folder.

#### Compiling the Prankster Toolbox

* Install [`Visual Studio 2019`](https://visualstudio.microsoft.com/older-downloads/) (Only version 2019 has been tested, however newer versions should work just fine)

* Open the `PranksterToolbox.sln` solution file in the `PranksterToolbox` folder with Visual Studio and generate the whole solution, as Debug or Release depending of your needs.

* If you need the tool's `.exe` file without bothering with Visual Studio, you can find it in [`PranksterToolbox/PranksterToolbox/bin/Release`](https://github.com/Asu-chan/NSMBWThePranksterComets/tree/clang-no-translations/PranksterToolbox/PranksterToolbox/bin/Release)

### Game files

If you're looking for the game's files, you can find them [here](https://drive.google.com/file/d/11UPNLxT45MTsbRYdXjAEgHRMXuQ9SKNd/view?usp=sharing)

### Art & Project files

The following resources are available:

* [The game's Logo](https://horizon.miraheze.org/wiki/FD:NSMBW:TPC_Logo)
* [The game's Box Art](https://horizon.miraheze.org/wiki/FD:NSMBW:TPC_Box_Art)
* [The game's Disc Art](https://horizon.miraheze.org/wiki/FD:NSMBW:TPC_Disc_Art)
* [The game's (Unfinished) Manual](https://horizon.miraheze.org/wiki/FD:NSMBW:TPC_Manual)

If you're looking for other non-downscaled pieces of art made for the game, or any project files (art-related or not) for anything that may have been used during the mod's creation, please ask me on discord at Asu-chan#2929.

### Licensing

The [**New Super Mario Bros. Wii: The Prankster Comets**](https://youtu.be/5QI8ACl1E9c) source code, loader, Reggie Next patch, the "Prankster Toolbox" and [**Newer Super Mario Bros. Wii**](https://newerteam.com/wii/), are released under the MIT license.

See the `LICENSE` file in this repository for full details.

Copyright (c) 2021-2022 Asu-chan; 2010-2013 Treeki, Tempus, megazig


The [**Level Info Editor mod**](https://github.com/Asu-chan/NSMBWThePranksterComets/tree/clang-no-translations/Tools/Level%20Info%20Editor) source code is released under the GPL-3.0 license.

See the `LICENSE` file in the corresponding folder for full details.

Copyright (c) 2023-2021 RoadRunnerWMC; 2021-2022 Asu-chan

### Credits

While most of the credits goes to me (Asu-chan) and the [Newer Team](https://newerteam.com/), I've got quite some help from CLF78 and Nin0.

If you contributed to any of the work that is featured in this repo and you weren't credited, feel free to contact me on discord at Asu-chan#2929.


**Usage of any of the game's source code requires crediting [Asu-chan](https://github.com/Asu-chan), [Treeki](https://github.com/Treeki), [Tempus](https://github.com/Tempus), [megazig](https://github.com/Megazig), [CLF78](https://github.com/CLF78) and [Nin0](https://github.com/N-I-N-0).**

**Usage of any of the game's code loader's code requires crediting [Asu-chan](https://github.com/Asu-chan) and [CLF78](https://github.com/CLF78).**

**Usage of any of the Prankster Toolbox's source code requires crediting [Asu-chan](https://github.com/Asu-chan).**

**Usage of any of the Reggie Next v4.8.0 patch requires crediting [Asu-chan](https://github.com/Asu-chan) and the [Reggie Next Team](https://github.com/CLF78/Reggie-Next/tree/v4.8.0#reggie-team).**

**Usage of any of the Level Info Editor mod requires crediting [RoadrunnerWMC](https://github.com/RoadrunnerWMC) and [Asu-chan](https://github.com/Asu-chan).**
