# [Arcade: SEGA System 1](https://www.system16.com/hardware.php?id=693) and [2](https://www.system16.com/hardware.php?id=694) for the [MiSTer](https://github.com/MiSTer-devel/Main_MiSTer/wiki)

by [MiSTer-X](https://twitter.com/mrx_8b)

## Specifications

* T80/T80s - Version : 0242
* Z80 compatible microprocessor core - Copyright (c) 2001-2002 Daniel Wallner (jesus@opencores.org)
* 2020/01/08  Impl. Trigger 3  (for SEGA Ninja)

## Supported Games

Currently supported System 1 titles:

* 4-D Warriors
* Block Gal
* Brain
* Bullfight
* Flicky
* Gardia
* Heavy Metal
* I'm Sorry
* Mister Viking
* My Hero
* Noboranka / Zippy Bug (bootleg)
* Pitfall II
* Rafflesia
* Regulus
* Sega Ninja
* Spatter
* Star Jacker
* SWAT
* TeddyBoy Blues
* Up'n Down
* Water Match
* Wonder Boy

Currently supported SEGA System 2 titles and versions of System 1 games:

* Choplifter
* DakkoChan House
* Wonder Boy
* Toki no Senshi - Chrono Soldier
* Ufo Senshi Yohko Chan
* Wonder Boy in Monster Land

Sega System 2 games currently **not yet** supported:

* 119
* Senryaku Game Bopeep
* Shooting Master
* Warball

## High score save/load

* To save your scores use the 'Save Settings' option in the OSD
* All games supported except Brain, Choplifter, Gardia, Heavy Metal, Water Match and Wonder Boy.

## Quirks

### UFO Senshi Yohko Chan

* All DIP Switches in DSW1 set to ON: Test Mode
* All DIP Switches in DSW0 set to ON: Inifinite Lifes

## ROM Files Instructions

**ROMs are not included!** In order to use this arcade core, you will need to provide the correct ROM file yourself.

Find this zip file somewhere. You need to find the file exactly as required. Check the .mra file in a text editor for more information.
Do not rename other zip files even if they also represent the same game - they are not compatible!
The name of zip is taken from M.A.M.E. project, so you can get more info about hashes and contained files there.

How to install:

1. Update MiSTer binary to v200106 or later
2. copy releases/\*.mra to /media/fat/\_Arcade
3. copy releases/\*.rbf to /media/fat/\_Arcade/cores
4. copy ROM zip files  to /media/fat/\_Arcade/mame

Be sure to use the MRA file in "releases" of this repository.
It does not guarantee the operation when using other MRA files.
