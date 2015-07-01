@echo off
setlocal
:top

chdir /d "%~dp0"
if not exist support cd..

::PUSHD "%cd%"
::::PUSHD "%~dp0"
::POPD

set currentversion=6.3.6
set currentversioncopy=%currentversion%
set agreedversion=

::remove setting path's with an & symbol and force default
if exist Support\settings.bat support\sfk filter -spat Support\settings.bat -!"\x26" -write -yes>nul
if exist Support\settings.bat call Support\settings.bat

set cygwin=nodosfilewarning
set ModMiiDrive=%cd:~0,2%

set PATH=%SystemRoot%\system32;%SystemRoot%\system32\wbem;%SystemRoot%;%homedrive%\ModMii\temp

chcp 437>nul
::chcp 850>nul
::chcp 1252>nul

if not exist temp mkdir temp

set UPDATENAME=ModMii
::set UPDATENAME=ModMii_IT_

if exist Updatetemp.bat attrib -h Updatetemp.bat
if exist Updatetemp.bat del updatetemp.bat>nul


::-------------------CMD LINE SUPPORT----------------------


::how to pass variables to ModMii via command line
::"ModMii" a b c d e f g h i
::equals
::"ModMii" %1 %2 %3 %4 %5 %6 %7 %8 %9
set one=%~1
set two=%~2
set three=%~3
set four=%~4
set five=%~5
set six=%~6
set seven=%~7
set eight=%~8
set nine=%~9
set cmdinput=%*



if "%one%"=="" (goto:notcmd)

set cmdinput=%cmdinput:"=%

set cmdlinemode=Y

if /i "%two%" EQU "Help" goto:specificCMDhelp
if /i "%one%" EQU "O" goto:cmdlineOPTIONShelp
if /i "%one%" EQU "W" goto:hardcodedoptions
if /i "%one%" EQU "HS" goto:hardcodedoptions
if /i "%one%" EQU "RC" goto:hardcodedoptions
if /i "%one%" EQU "S" goto:hardcodedoptions
if /i "%one%" EQU "SE" goto:hardcodedoptions
if /i "%one%" EQU "U" goto:hardcodedoptions
if /i "%one%" EQU "E" goto:hardcodedoptions
if /i "%one%" EQU "AW" goto:hardcodedoptions

if /i "%one%" EQU "L" goto:hardcodedoptions
if /i "%cmdinput:~-4%" EQU ".bat" (set one=L) & (set cmdlinemodeswitchoff=Y) & (goto:hardcodedoptions)

if /i "%one%" EQU "SU" goto:hardcodedoptions
if /i "%cmdinput:~-4%" EQU ".csv" (set one=SU) & (set cmdlinemodeswitchoff=Y) & (goto:hardcodedoptions)

if exist "%cmdinput%\title\00000001\00000002\content\title.tmd" set DRIVETEMP=%cmdinput%
if exist "%cmdinput%\title\00000001\00000002\content\title.tmd" (SET MENU1=S) & (set SNEEKSELECT=5) &(set one=EMUMOD) & (set cmdlinemodeswitchoff=Y) & (goto:go)

::drag and drop for file cleanup
if exist "%cmdinput%\apps" set DRIVEtemp=%cmdinput%
if exist "%cmdinput%\WAD" set DRIVEtemp=%cmdinput%
if exist "%cmdinput%\private" set DRIVEtemp=%cmdinput%
if not "%DRIVEtemp%"=="" (SET MENU1=FC) & (set cmdlinemodeswitchoff=Y) & (goto:go)


:specificCMDhelp
if /i "%one%" EQU "W" goto:cmdlinewizardhelp
if /i "%one%" EQU "RC" goto:cmdlineRegionChangehelp
if /i "%one%" EQU "HS" goto:cmdlineHMhelp
if /i "%one%" EQU "S" goto:cmdlineSNEEKhelp
if /i "%one%" EQU "SE" goto:cmdlineEMUNANDhelp
if /i "%one%" EQU "U" goto:cmdlineUSBhelp
if /i "%one%" EQU "E" goto:cmdlineEMUNANDhelp
if /i "%one%" EQU "L" goto:cmdlineDLQUEUEhelp
if /i "%one%" EQU "SU" goto:cmdlineSYSCHECKhelp
if /i "%one%" EQU "O" goto:cmdlineOPTIONShelp
if /i "%one%" EQU "AW" goto:cmdlineAWhelp

if not "%one%"=="" (goto:cmdlinehelp)



:cmdlinehelp
title ModMii Command Line Help

support\sfk echo [Red]ModMii %currentversion% - by XFlak
echo.
echo  Command Line Usage: ModMii [function] [parameters] [Options]
echo.
echo  Functions:
echo.
echo        W          Wizard
echo        AW         Abstinence Wizard
echo        U          USB-Loader Set-up
echo        HS         HackMii Solutions
echo        SU         sysCheck Updater
echo        RC         Region Change
echo        S          SNEEK Installation
echo        E          Emulated NAND Builder
echo        SE         SNEEK Installation + Emulated NAND Builder
echo        L          Load ModMii Download Queue
echo.
echo        O          ModMii Options: Options cannot be used by themselves
echo                   but they can be applied to other functions. Saved\default
echo                   settings will be restored after each command. If an
echo                   option is not defined saved\default settings are used.
echo.
echo       NOTE: Too see detailed descriptions and parameters for any of the above,
echo             use 'ModMii [function] Help'
echo.
echo Press Any Key to Close the Help Menu...
pause>nul
exit


:cmdlineRegionChangehelp
title ModMii Region Change Command Line Help

support\sfk echo [Red]ModMii Region Change Express Mode Usage
echo.
echo ModMii.exe RC DesiredSystemMenu Extras Options
echo.
echo DesiredSystemMenu: #.#X
echo    where; "#.#" can be "4.1", "4.2" or "4.3" and "X" can be "U", "E", "J", "K"
echo.
echo Extras:
echo         "Red" Red Theme [cannot be used simultaneously with other themes]
echo         "Green" Green Theme [cannot be used simultaneously with other themes]
echo         "Blue" Blue Theme [cannot be used simultaneously with other themes]
echo         "Orange" Orange Theme [cannot be used simultaneously with other themes]
echo.
echo         "Guide" Generate Guide ONLY
echo.
support\sfk echo [Blue]Examples:
echo ModMii.exe RC 4.1U
echo ModMii.exe RC 4.2E Red
echo ModMii.exe RC 4.3J Orange Guide
echo.
echo Press Any Key to Close the Help Menu...
pause>nul
exit


:cmdlinewizardhelp
title ModMii Wizard Command Line Help

support\sfk echo [Red]ModMii Wizard Express Mode Usage
echo.
echo ModMii.exe W CurrentFirm Region DesiredFirm Extras Options
echo.
echo ModMii.exe 1 2 3 4 5 Extras Options
echo.
echo 1) Wizard "W"
echo 2) CurrentSystemMenu: "4.3","4.2","4.1","4.0","3.X" [3.0-3.5], "O" [other ^<2.2]
echo 3) Region: "U","E","J","K"
echo.       If your Wii was Region Changed but not originally Korean,
echo        select the Region you are currently on
echo 4) DesiredSystemMenu (Optional): "4.1", "4.2", "4.3"
echo    Note: If DesiredSystemMenu not specified ModMii use recommended SystemMenu
echo.
echo Extras:
echo         "Red" Red Theme [cannot be used simultaneously with other themes]
echo         "Green" Green Theme [cannot be used simultaneously with other themes]
echo         "Blue" Blue Theme [cannot be used simultaneously with other themes]
echo         "Orange" Orange Theme [cannot be used simultaneously with other themes]
echo.
echo         "CH" All Wii Channels [ie. Photo, Weather, News, etc.]
echo             "PHOTO" Photo Channel
echo             "SHOP" Shopping Channel [and IOS56]
echo             "MII" Mii Channel
echo             "SPEAK" Wii Speak Channel [not applicable to Korean Wiis]
echo             "NEWS" News Channel [not applicable to Korean Wiis]
echo             "NET" Internet Channel [not applicable to Korean Wiis]
echo             "WEATHER" Weather Channel [not applicable to Korean Wiis]
echo.
echo         "USB" Set-up a USB-loader [choose no more than one of each A, B and C]
echo          A - "FAT32" Format HDD as FAT32 [default]
echo              "NTFS" Format HDD as NTFS
echo              "FAT32-NTFS" Partition HDD as part FAT32 and part NTFS
echo              "WBFS" HDD already formatted as WBFS
echo              "WBFS-FAT32" HDD already partitioned as part FAT32 and part WBFS
echo          B - "CFG" Use Configurable USB-Loader [default]
echo              "FLOW" Use WiiFlow
echo              "CFG-FLOW" Use both Configurable USB-Loader and WiiFlow
echo          C - "USBConfig" Save USB-Loader Config files to USB [default]
echo              "SDConfig" Save USB-Loader Config files to SD Card
echo.
echo          "Min" Minimal Update - Choose one or more of the following updates:
echo               "HBC" Homebrew Channel and\or BootMii
echo               "REC" Recommended cIOSs (and cMIOS if enabled in options)
echo               "YAWMM" Yet Another Wad Manager Mod
echo               "236" IOS236
echo               "Pri" Priiloader v0.7 and hacks_hash.ini
echo.
echo         "Guide" Generate Guide ONLY
echo.
echo         "MAC:aabbccddeeff" needed for 4.3 virgin Wii's to use Wilbrand exploit
echo.
echo         Force a disc based exploit for 4.3 and ^<2.2 Wii's
echo               "SmashStack"  Smash Stack (U\E\J\K)
echo               "IndianaPwns" IndianaPwns (U\E\J)
echo               "Bathaxx"     Bathaxx (U\E\J)
echo               "ROTJ"        Return of the Jodi (U\E\J)
echo               "YuGiOwned"   Yu-Gi Owned (U\E\J)
echo               "EriHakawai"  Eri Hakawai (U\E\J)
echo               "Twilight"    Twilight Hack (^<2.2 U\E\J\K)
echo               "AllExploits" All Disc Based Exploits
echo         Notes:
echo         Default for 4.3 Wii's is "AllExploits"
echo         Default for ^<2.2 Wii's is "AllExploits"
echo         Guides for 3.0-4.2 Wii's always use Bannerbomb
echo.
support\sfk echo [Blue]Examples:
echo ModMii.exe W 3.X U 4.1
echo ModMii.exe W 4.2 U 4.2 Blue CH USB
echo ModMii.exe W 4.1 J 4.1 Green USB NTFS Flow SDConfig
echo ModMii.exe W 4.3 E 4.3 Shop Speak Min 236 REC Green
echo ModMii.exe W o U AllExploits
echo.
echo Press Any Key to Close the Help Menu...
pause>nul
exit


:cmdlineAWhelp
title ModMii Abstinence Wizard Command Line Help

support\sfk echo [Red]ModMii Abstinence Wizard Express Mode Usage
echo.
echo ModMii.exe AW SystemMenu SNEEK-TYPE SNKSystemMenu SNKRegion Extras Options
echo.
echo ModMii.exe 1 2 3 4 5 Extras Options
echo.
echo 1) Abstinence Wizard "AW"
echo 2) SystemMenu: "4.3","4.2","4.1","4.0","3.X" [3.0-3.5], "O" [other ^<2.2]
echo 3) SNEEK-TYPE: "S" SNEEK, "U" UNEEK, "SD" SNEEK+DI, "UD" UNEEK+DI
echo 4) SNKSystemMenu: "4.1", "4.2", "4.3"
echo 5) SNKRegion: "U","E","J","K"
echo.
echo Extras:
echo         "Guide" Generate Guide ONLY
echo.
echo         "MAC:aabbccddeeff" needed for 4.3 virgin Wii's to use Wilbrand exploit
echo.
echo         Force a disc based exploit for 4.3 and ^<2.2 Wii's
echo               "SmashStack"  Smash Stack (U\E\J\K)
echo               "IndianaPwns" IndianaPwns (U\E\J)
echo               "Bathaxx"     Bathaxx (U\E\J)
echo               "ROTJ"        Return of the Jodi (U\E\J)
echo               "YuGiOwned"   Yu-Gi Owned (U\E\J)
echo               "EriHakawai"  Eri Hakawai (U\E\J)
echo               "Twilight"    Twilight Hack (^<2.2 U\E\J\K)
echo               "AllExploits" All Disc Based Exploits
echo         Notes:
echo         Default for 4.3 Wii's is "AllExploits"
echo         Default for ^<2.2 Wii's is "AllExploits"
echo         Guides for 3.0-4.2 Wii's always use Bannerbomb
echo.
echo         "Rev:#" Build a Specific Rev # of neek or neek2o
echo.
echo            Note: If a Rev # is not specified ModMii will build the
echo                  rev currently Featured on the google-code page
echo                  (or newest version saved locally if you are offline)
echo.
echo         "Red" Red Theme [cannot be used simultaneously with other themes]
echo         "Green" Green Theme [cannot be used simultaneously with other themes]
echo         "Blue" Blue Theme [cannot be used simultaneously with other themes]
echo         "Orange" Orange Theme [cannot be used simultaneously with other themes]
echo.
echo         "PLC" Post Loader Channel
echo         "249" cIOS249 rev14
echo         "Pri" Priiloader (and hacks)
echo         "FLOW" WiiFlow Forwarder and App
echo.
echo         "SN:Serial-Number" - default serial will be used if not specified
echo.
echo         "CH" All Wii Channels [ie. Photo, Weather, News, etc.]
echo             "PHOTO" Photo Channel
echo             "SHOP" Shopping Channel [and IOS56]
echo             "MII" Mii Channel
echo             "SPEAK" Wii Speak Channel [not applicable to Korean NANDs]
echo             "NEWS" News Channel [not applicable to Korean NANDs]
echo             "NET" Internet Channel [not applicable to Korean NANDs]
echo             "WEATHER" Weather Channel [not applicable to Korean NANDs]
echo.
echo          "WADdir:Path?" - Optionally specify custom folder of WADs to install.
echo                   Note: do not forget the "?" which marks the end of the path
echo.
support\sfk echo [Blue]Examples:
echo ModMii.exe AW 4.2 SD 4.3 U
echo ModMii.exe AW o SD 4.3 J SmashStack
echo ModMii.exe AW 4.1 UD 4.2 E Orange PLC 249 Pri FLOW CH Rev:64
echo.
echo Press Any Key to Close the Help Menu...
pause>nul
exit


:cmdlineUSBhelp
title ModMii USB-Loader Command Line Help

support\sfk echo [Red]ModMii USB-Loader Set-up Express Mode Usage
echo.
echo ModMii.exe U Extras Options
echo.
echo Extras:
echo         Choose no more than one of each A, B and C:
echo          A - "FAT32" Format HDD as FAT32 [default]
echo              "NTFS" Format HDD as NTFS
echo              "FAT32-NTFS" Partition HDD as part FAT32 and part NTFS
echo              "WBFS" HDD already formatted as WBFS
echo              "WBFS-FAT32" HDD already partitioned as part FAT32 and part WBFS
echo          B - "CFG" Use Configurable USB-Loader [default]
echo              "FLOW" Use WiiFlow
echo              "CFG-FLOW" Use both Configurable USB-Loader and WiiFlow
echo          C - "USBConfig" Save USB-Loader Config files to USB [default]
echo              "SDConfig" Save USB-Loader Config files to SD Card
echo.
echo         "Guide" Generate Guide ONLY
echo.
support\sfk echo [Blue]Examples:
echo ModMii.exe U
echo ModMii.exe U NTFS Flow
echo ModMii.exe U FAT32-NTFS CFG-Flow SDConfig
echo.
echo Press Any Key to Close the Help Menu...
pause>nul
exit

:cmdlineHMhelp
title ModMii HackMii Solutions Command Line Help

support\sfk echo [Red]ModMii HackMii Solutions Express Mode Usage
echo.
echo ModMii.exe HS SystemMenu Extras Options
echo.
echo ModMii.exe 1 2 Extras Options
echo.
echo 1) HackMii Solutions "HS"
echo 2) SystemMenu: "4.3","4.2","4.1","4.0","3.X" [3.0-3.5], "O" [other ^<2.2]
echo.
echo Extras:
echo         "Guide" Generate Guide ONLY
echo.
echo         "MAC:aabbccddeeff" needed for 4.3 virgin Wii's to use Wilbrand exploit
echo.
echo         Force a disc based exploit for 4.3 and ^<2.2 Wii's
echo               "SmashStack"  Smash Stack (U\E\J\K)
echo               "IndianaPwns" IndianaPwns (U\E\J)
echo               "Bathaxx"     Bathaxx (U\E\J)
echo               "ROTJ"        Return of the Jodi (U\E\J)
echo               "YuGiOwned"   Yu-Gi Owned (U\E\J)
echo               "EriHakawai"  Eri Hakawai (U\E\J)
echo               "Twilight"    Twilight Hack (^<2.2 U\E\J\K)
echo               "AllExploits" All Disc Based Exploits
echo         Notes:
echo         Default for 4.3 Wii's is "AllExploits"
echo         Default for ^<2.2 Wii's is "AllExploits"
echo         Guides for 3.0-4.2 Wii's always use Bannerbomb
echo.
support\sfk echo [Blue]Examples:
echo ModMii.exe HS 4.3
echo ModMii.exe HS 4.1
echo ModMii.exe HS 3.X
echo ModMii.exe HS o SmashStack
echo.
echo Press Any Key to Close the Help Menu...
pause>nul
exit

:cmdlineSYSCHECKhelp
title ModMii sysCheck Updater Command Line Help

support\sfk echo [Red]ModMii sysCheck Updater Express Mode Usage
echo.
echo ModMii.exe SU sysCheck.csv Extras Options
echo.
echo ModMii.exe 1 2 Extras Options
echo.
echo 1) sysCheck Updater "SU"
echo 2) sysCheck Log Path\Name
echo.
echo Extras:
echo         "Pri" Install Priiloader if unable to determine if already installed
echo                 otherwise it will not be installed
echo         "Guide" Generate Guide ONLY
echo.
support\sfk echo [Blue]Examples:
echo ModMii.exe SU sysCheck.csv
echo ModMii.exe SU X:\New Folder\syscheck.csv
echo ModMii.exe SU "XFlaks-sysCheck.csv" Pri Guide
echo.
echo Press Any Key to Close the Help Menu...
pause>nul
exit

:cmdlineSNEEKhelp
title ModMii SNEEK Installation Command Line Help
support\sfk echo [Red]ModMii SNEEK Installation Express Mode Usage
echo.
echo ModMii.exe S SNEEK-TYPE Extras Options
echo.
echo SNEEK-TYPE: "S" SNEEK, "U" UNEEK, "SD" SNEEK+DI, "UD" UNEEK+DI
echo.
echo Extras:
echo         "Rev:#" Build a Specific Rev # of neek or neek2o
echo.
echo            Note: If a Rev # is not specified ModMii will build the
echo                  rev currently Featured on the google-code page
echo                  (or newest version saved locally if you are offline)
echo.
support\sfk echo [Blue]Example:
echo ModMii.exe S UD
echo ModMii.exe S SD Rev:64
echo.
echo Note: You can install S\UNEEK and simultaneously build an emulated
echo       NAND using the Emulated NAND builder instructions below.
echo.


:cmdlineEMUNANDhelp
title ModMii Emulated NAND Builder Command Line Help
support\sfk echo [Red]ModMii Emulated NAND Builder Express Mode Usage
echo.
echo ModMii.exe E SNEEK-TYPE SystemMenu Region Extras Options
echo.
echo ModMii.exe 1 2 3 4 Extras Options
echo.
echo 1) Emulated NAND Builder "E" [or "SE" to install S\UNEEK AND build a NAND]
echo 2) SNEEK-TYPE: "S" SNEEK, "U" UNEEK, "SD" SNEEK+DI, "UD" UNEEK+DI
echo 3) SystemMenu: "4.1", "4.2", "4.3"
echo 4) Region: "U","E","J","K"
echo.
echo Extras:
echo         "Rev:#" Build a Specific Rev # of neek or neek2o
echo.
echo            Note: If a Rev # is not specified ModMii will build the
echo                  rev currently Featured on the google-code page
echo                  (or newest version saved locally if you are offline)
echo.
echo         "Red" Red Theme [cannot be used simultaneously with other themes]
echo         "Green" Green Theme [cannot be used simultaneously with other themes]
echo         "Blue" Blue Theme [cannot be used simultaneously with other themes]
echo         "Orange" Orange Theme [cannot be used simultaneously with other themes]
echo.
echo         "PLC" Post Loader Channel
echo         "249" cIOS249 rev14
echo         "S2U" Switch2Uneek [only for UNEEK or UNEEK+DI when neek2o disabled]
echo         "Pri" Priiloader (and hacks)
echo         "FLOW" WiiFlow Forwarder and App
echo         "NMM" No More Memory Cards [cannot be used simultaneously with DML]
echo         "DML" Dios Mios Lite [only for SNEEK+DI]
echo.
echo         "SN:Serial-Number" - default serial will be used if not specified
echo.
echo         "CH" All Wii Channels [ie. Photo, Weather, News, etc.]
echo             "PHOTO" Photo Channel
echo             "SHOP" Shopping Channel [and IOS56]
echo             "MII" Mii Channel
echo             "SPEAK" Wii Speak Channel [not applicable to Korean NANDs]
echo             "NEWS" News Channel [not applicable to Korean NANDs]
echo             "NET" Internet Channel [not applicable to Korean NANDs]
echo             "WEATHER" Weather Channel [not applicable to Korean NANDs]
echo.
echo          "WADdir:Path?" - Optionally specify custom folder of WADs to install.
echo                   Note: do not forget the "?" which marks the end of the path
echo.
support\sfk echo [Blue]Examples:
echo ModMii.exe E U 4.3 U
echo ModMii.exe SE UD 4.2 U Orange PLC 249 NMM S2U Pri FLOW CH Rev:64
echo.
echo Press Any Key to Close the Help Menu...
pause>nul
exit

:cmdlineDLQUEUEhelp
title ModMii Download Queue Command Line Help

support\sfk echo [Red]ModMii Download Queue Express Mode Usage
echo.
echo ModMii.exe L DownloadQueue Options
echo.
echo Note: Download Queue must exist and be saved in temp\DownloadQueues\
echo.
support\sfk echo [Blue]Examples:
echo ModMii.exe L cIOSs
echo ModMii.exe L My Fav Themes.bat
echo.
echo Press Any Key to Close the Help Menu...
pause>nul
exit

:cmdlineOPTIONShelp
title ModMii Options Command Line Help

support\sfk echo [Red]Options
echo.
echo Define ModMii's options using the following commands.
echo.
echo Note: If an option is not defined ModMii will use saved\default settings.
echo       Saved\default settings will be restored after each command.
echo       If you're unsure of what an option does, read the description
echo       in ModMii's options page.
echo.
support\sfk echo [Cyan]Drive Letter or Path setting for SD Card

echo ModMii.exe [base command] Drive:Path?
echo.
support\sfk echo [Blue]Examples:
echo ModMii.exe [base command] Drive:new folder?
echo ModMii.exe [base command] Drive:E:?
echo.
echo Note: do not forget the "?" which marks the end of the path
echo.
support\sfk echo [Cyan]Drive Letter or Path setting for USB Hard Drive

echo ModMii.exe [base command] DriveU:Path?
echo.
support\sfk echo [Blue]Examples:
echo ModMii.exe [base command] DriveU:new folder?
echo ModMii.exe [base command] DriveU:H:?
echo.
echo Note: do not forget the "?" which marks the end of the path
echo.
support\sfk echo [Cyan]PC Program Save Location

echo ModMii.exe [base command] PC:A
echo ModMii.exe [base command] PC:L
echo ModMii.exe [base command] PC:P
echo.
echo Where;
echo A = Auto, L = Local, and P = Portable
echo.
support\sfk echo [Cyan]Root Save

echo ModMii.exe [base command] RS:E
echo ModMii.exe [base command] RS:D
echo.
echo Where;
echo E = Enabled and D = Disabled
echo.

support\sfk echo [Cyan]Channel Effect
echo ModMii.exe [base command] CE:NS
echo ModMii.exe [base command] CE:S
echo ModMii.exe [base command] CE:FS
echo.
echo Where;
echo NS = No Spin, S = Spin and FS = Fast Spin
echo.

support\sfk echo [Cyan]Keep 00000001 Folder and\or NUS Folder

echo ModMii.exe [base command] 1:0
echo ModMii.exe [base command] 1:1
echo ModMii.exe [base command] 1:N
echo ModMii.exe [base command] 1:A
echo.
echo Where;
echo 0 = do not keep, 1 = keep 00000001, N = keep NUS and A = keep All
echo.
support\sfk echo [Cyan]Update Active IOSs

echo ModMii.exe [base command] UIOS:E
echo ModMii.exe [base command] UIOS:D
echo.
echo Where;
echo E = Enabled and D = Disabled
echo.
support\sfk echo [Cyan]Include IOS36v3608 in ModMii Wizard Downloads

echo ModMii.exe [base command] IOS36:E
echo ModMii.exe [base command] IOS36:D
echo.
echo Where;
echo E = Enabled and D = Disabled
echo.
support\sfk echo [Cyan]Include cMIOS in ModMii Wizard Downloads

echo ModMii.exe [base command] CMIOS:E
echo ModMii.exe [base command] CMIOS:D
echo.
echo Where;
echo E = Enabled and D = Disabled
echo.

support\sfk echo [Cyan]Play Sound at Finish

echo ModMii.exe [base command] SOUND:E
echo ModMii.exe [base command] SOUND:D
echo.
echo Where;
echo E = Enabled and D = Disabled
echo.

support\sfk echo [Cyan]Include USB-Loader Forwarder Channel in ModMii Wizard Downloads

echo ModMii.exe [base command] FWD:E
echo ModMii.exe [base command] FWD:D
echo.
echo Where;
echo E = Enabled and D = Disabled
echo.
support\sfk echo [Cyan]Verbose Output for wget and SNEEK Installer

echo ModMii.exe [base command] VERBOSE:E
echo ModMii.exe [base command] VERBOSE:D
echo.
echo Where;
echo E = Enabled and D = Disabled
echo.

support\sfk echo [Cyan]neek2o - build neek2o mod of s\uneek by OverjoY and obcd
echo ModMii.exe [base command] n2o:E
echo ModMii.exe [base command] n2o:D
echo.
echo Where;
echo E = Enabled and D = Disabled
echo.

support\sfk echo [Cyan]SNEEK and SNEEK+DI SD Access
echo ModMii.exe [base command] SSD:E
echo ModMii.exe [base command] SSD:D
echo.
echo Where;
echo E = Enabled and D = Disabled
echo.

support\sfk echo [Cyan]SNEEK Verbose Output
echo ModMii.exe [base command] SNKVERBOSE:E
echo ModMii.exe [base command] SNKVERBOSE:D
echo.
echo Where;
echo E = Enabled and D = Disabled
echo.
support\sfk echo [Cyan]Font.bin Colour for SNEEK+DI/UNEEK+DI

echo ModMii.exe [base command] Font:B
echo ModMii.exe [base command] Font:W
echo.
echo Where;
echo B = Black and W = White
echo.
echo.
echo Press Any Key to Close the Help Menu...
pause>nul
exit

::this will stop the batch file from opening, and keep the cmd box open
::cmd.exe



::-----------------------------------
:hardcodedoptions
echo %cmdinput%>temp\cmdinput.txt
findStr /I ":" temp\cmdinput.txt >nul
IF ERRORLEVEL 1 goto:hardcodedoptionsfinish

::backup current settings (in order to revert after cmd)
if not exist support\settings.bat echo ::ModMii Settings >support\settings.bat
copy /y support\settings.bat support\settings.bak>nul


::-----------DRIVE: (ie. DRIVE:whatever_ test?)---------------
findStr /I " Drive:" temp\cmdinput.txt >nul
IF ERRORLEVEL 1 (goto:nodrivecmd) else (copy /y temp\cmdinput.txt temp\cmdinput2.txt>nul)

::check if a ? was entered
findStr /I "?" temp\cmdinput.txt >nul
IF ERRORLEVEL 1 (echo Please mark the end of your Drive setting using a question mark "?", try again...) & (if exist support\settings.bak move /y support\settings.bak support\settings.bat>nul) & (@ping 127.0.0.1 -n 5 -w 1000> nul) & (exit)

support\sfk filter -spat temp\cmdinput2.txt -rep _"* DRIVE:"__ -rep _\x3f*__ -write -yes>nul

set /p DRIVE= <temp\cmdinput2.txt

:doublecheckcmd1
set fixslash=
if /i "%DRIVE:~-1%" EQU "\" set fixslash=yes
if /i "%DRIVE:~-1%" EQU "/" set fixslash=yes
if /i "%fixslash%" EQU "yes" set DRIVE=%DRIVE:~0,-1%
if /i "%fixslash%" EQU "yes" goto:doublecheckcmd1

::if second char is ":" check if drive exists
if /i "%DRIVE:~1,1%" NEQ ":" goto:skipcheck
if exist "%DRIVE:~0,2%" (goto:skipcheck) else (echo "%DRIVE:~0,2%" doesn't exist, please try again...)
if exist support\settings.bak move /y support\settings.bak support\settings.bat>nul
@ping 127.0.0.1 -n 5 -w 1000> nul
exit
:skipcheck

::overwrite option in settings.bat
support\sfk filter Support\settings.bat -!"Set Drive=" -write -yes>nul
echo Set Drive=%DRIVE%>>Support\settings.bat

::remove from temp\cmdinput.txt (compensate for _'s by replacing them with \x5f)
support\sfk -spat filter temp\cmdinput2.txt -rep _\x5f_\x22_ -write -yes>nul
support\sfk filter -quiet temp\cmdinput2.txt -rep _"""_\x5f_ -write -yes

::remove hard option from cmdinput.txt
set /p removeme= <temp\cmdinput2.txt
support\sfk -spat filter temp\cmdinput.txt -rep _" Drive:%removeme%?"__ -write -yes>nul
:nodrivecmd


::-----------DRIVEU: (ie. DRIVEU:whatever_ test?)---------------
findStr /I " DRIVEU:" temp\cmdinput.txt >nul
IF ERRORLEVEL 1 (goto:noDRIVEUcmd) else (copy /y temp\cmdinput.txt temp\cmdinput2.txt>nul)

::check if a ? was entered
findStr /I "?" temp\cmdinput.txt >nul
IF ERRORLEVEL 1 (echo Please mark the end of your DriveU setting using a question mark "?", try again...) & (if exist support\settings.bak move /y support\settings.bak support\settings.bat>nul) & (@ping 127.0.0.1 -n 5 -w 1000> nul) & (exit)

support\sfk filter -spat temp\cmdinput2.txt -rep _"* DRIVEU:"__ -rep _\x3f*__ -write -yes>nul

set /p DRIVEU= <temp\cmdinput2.txt

:doublecheckcmd
set fixslash=
if /i "%DRIVEU:~-1%" EQU "\" set fixslash=yes
if /i "%DRIVEU:~-1%" EQU "/" set fixslash=yes
if /i "%fixslash%" EQU "yes" set DRIVEU=%DRIVEU:~0,-1%
if /i "%fixslash%" EQU "yes" goto:doublecheckcmd

::if second char is ":" check if DRIVEU exists
if /i "%DRIVEU:~1,1%" NEQ ":" goto:skipcheck
if exist "%DRIVEU:~0,2%" (goto:skipcheck) else (echo "%DRIVEU:~0,2%" doesn't exist, please try again...)
if exist support\settings.bak move /y support\settings.bak support\settings.bat>nul
@ping 127.0.0.1 -n 5 -w 1000> nul
exit
:skipcheck

::overwrite option in settings.bat
support\sfk filter Support\settings.bat -!"Set DRIVEU=" -write -yes>nul
echo Set DRIVEU=%DRIVEU%>>Support\settings.bat

::remove from temp\cmdinput.txt (compensate for _'s by replacing them with \x5f)
support\sfk -spat filter temp\cmdinput2.txt -rep _\x5f_\x22_ -write -yes>nul
support\sfk filter -quiet temp\cmdinput2.txt -rep _"""_\x5f_ -write -yes

::remove hard option from cmdinput.txt
set /p removeme= <temp\cmdinput2.txt
support\sfk -spat filter temp\cmdinput.txt -rep _" DRIVEU:%removeme%?"__ -write -yes>nul
:noDRIVEUcmd



::-----------WADdir: (ie. WADdir:whatever_ test?)---------------
findStr /I " WADdir:" temp\cmdinput.txt >nul
IF ERRORLEVEL 1 (goto:noWADdircmd) else (copy /y temp\cmdinput.txt temp\cmdinput2.txt>nul)

::check if a ? was entered
findStr /I "?" temp\cmdinput.txt >nul
IF ERRORLEVEL 1 (echo Please mark the end of your WADdir setting using a question mark "?", try again...) & (if exist support\settings.bak move /y support\settings.bak support\settings.bat>nul) & (@ping 127.0.0.1 -n 5 -w 1000> nul) & (exit)

support\sfk filter -spat temp\cmdinput2.txt -rep _"* WADdir:"__ -rep _\x3f*__ -write -yes>nul

set /p addwadfolder= <temp\cmdinput2.txt

:doublecheckcmd2
set fixslash=
if /i "%addwadfolder:~-1%" EQU "\" set fixslash=yes
if /i "%addwadfolder:~-1%" EQU "/" set fixslash=yes
if /i "%fixslash%" EQU "yes" set addwadfolder=%addwadfolder:~0,-1%
if /i "%fixslash%" EQU "yes" goto:doublecheckcmd2

if not exist "%addwadfolder%" (echo %addwadfolder% doesn't exist, please try again...) & (if exist support\settings.bak move /y support\settings.bak support\settings.bat>nul) & (@ping 127.0.0.1 -n 2 -w 1000> nul) & (exit)

::make sure second char is ":"
if /i "%addwadfolder:~1,1%" NEQ ":" (echo Enter the full path including the drive letter, please try again...) & (if exist support\settings.bak move /y support\settings.bak support\settings.bat>nul) & (@ping 127.0.0.1 -n 2 -w 1000> nul) & (exit)

if not exist "%addwadfolder%\*.wad" (echo No Wads found in %addwadfolder%, please try a different folder...) & (if exist support\settings.bak move /y support\settings.bak support\settings.bat>nul) & (@ping 127.0.0.1 -n 2 -w 1000> nul) & (exit)

::remove from temp\cmdinput.txt (compensate for _'s by replacing them with \x5f)
support\sfk -spat filter temp\cmdinput2.txt -rep _\x5f_\x22_ -write -yes>nul
support\sfk filter -quiet temp\cmdinput2.txt -rep _"""_\x5f_ -write -yes

::remove hard option from cmdinput.txt
set /p removeme= <temp\cmdinput2.txt
support\sfk -spat filter temp\cmdinput.txt -rep _" WADdir:%removeme%?"__ -write -yes>nul
:noWADdircmd


::-----------PC: Option---------------
findStr /I " PC:" temp\cmdinput.txt >nul
IF ERRORLEVEL 1 (goto:noPCcmd) else (copy /y temp\cmdinput.txt temp\cmdinput2.txt>nul)

support\sfk filter -spat temp\cmdinput2.txt -rep _"* PC:"__ -rep _\x20*__ -write -yes>nul

set /p PCSAVEcmd= <temp\cmdinput2.txt

if /i "%PCSAVEcmd%" EQU "A" set PCSAVE=Auto
if /i "%PCSAVEcmd%" EQU "L" set PCSAVE=Local
if /i "%PCSAVEcmd%" EQU "P" set PCSAVE=Portable

::overwrite option in settings.bat
support\sfk filter Support\settings.bat -!"Set PCSAVE=" -write -yes>nul
echo Set PCSAVE=%PCSAVE%>>Support\settings.bat

::remove hard option from cmdinput.txt
set /p removeme= <temp\cmdinput2.txt
support\sfk filter temp\cmdinput.txt -rep _" PC:%removeme%"__ -write -yes>nul
:noPCcmd


::-----------RS: Option---------------
findStr /I " RS:" temp\cmdinput.txt >nul
IF ERRORLEVEL 1 (goto:noRScmd) else (copy /y temp\cmdinput.txt temp\cmdinput2.txt>nul)

support\sfk filter -spat temp\cmdinput2.txt -rep _"* RS:"__ -rep _\x20*__ -write -yes>nul

set /p ROOTSAVEcmd= <temp\cmdinput2.txt

if /i "%ROOTSAVEcmd%" EQU "E" set ROOTSAVE=ON
if /i "%ROOTSAVEcmd%" EQU "D" set ROOTSAVE=OFF

::overwrite option in settings.bat
support\sfk filter Support\settings.bat -!"Set ROOTSAVE=" -write -yes>nul
echo Set ROOTSAVE=%ROOTSAVE%>>Support\settings.bat

::remove hard option from cmdinput.txt
set /p removeme= <temp\cmdinput2.txt
support\sfk filter temp\cmdinput.txt -rep _" RS:%removeme%"__ -write -yes>nul
:noRScmd



::-----------CE: Option---------------
findStr /I " CE:" temp\cmdinput.txt >nul
IF ERRORLEVEL 1 (goto:noCEcmd) else (copy /y temp\cmdinput.txt temp\cmdinput2.txt>nul)

support\sfk filter -spat temp\cmdinput2.txt -rep _"* CE:"__ -rep _\x20*__ -write -yes>nul

set /p effectcmd= <temp\cmdinput2.txt

if /i "%effectcmd%" EQU "NS" set effect=no-spin
if /i "%effectcmd%" EQU "S" set effect=spin
if /i "%effectcmd%" EQU "FS" set effect=fast-spin

::overwrite option in settings.bat
support\sfk filter Support\settings.bat -!"Set effect=" -write -yes>nul
echo Set effect=%effect%>>Support\settings.bat

::remove hard option from cmdinput.txt
set /p removeme= <temp\cmdinput2.txt
support\sfk filter temp\cmdinput.txt -rep _" CE:%removeme%"__ -write -yes>nul
:noCEcmd


::-----------keep *01 or NUS Folders---------------
findStr /I " 1:" temp\cmdinput.txt >nul
IF ERRORLEVEL 1 (goto:no1cmd) else (copy /y temp\cmdinput.txt temp\cmdinput2.txt>nul)

support\sfk filter -spat temp\cmdinput2.txt -rep _"* 1:"__ -rep _\x20*__ -write -yes>nul

set /p Option1cmd= <temp\cmdinput2.txt

if /i "%Option1cmd%" EQU "0" set Option1=off
if /i "%Option1cmd%" EQU "1" set Option1=on
if /i "%Option1cmd%" EQU "N" set Option1=nus
if /i "%Option1cmd%" EQU "A" set Option1=all

::overwrite option in settings.bat
support\sfk filter Support\settings.bat -!"Set Option1=" -write -yes>nul
echo Set Option1=%Option1%>>Support\settings.bat

::remove hard option from cmdinput.txt
set /p removeme= <temp\cmdinput2.txt
support\sfk filter temp\cmdinput.txt -rep _" 1:%removeme%"__ -write -yes>nul
:no1cmd


::-----------UIOS: Option---------------
findStr /I " UIOS:" temp\cmdinput.txt >nul
IF ERRORLEVEL 1 (goto:noUIOScmd) else (copy /y temp\cmdinput.txt temp\cmdinput2.txt>nul)

support\sfk filter -spat temp\cmdinput2.txt -rep _"* UIOS:"__ -rep _\x20*__ -write -yes>nul

set /p ACTIVEIOScmd= <temp\cmdinput2.txt

if /i "%ACTIVEIOScmd%" EQU "E" set ACTIVEIOS=ON
if /i "%ACTIVEIOScmd%" EQU "D" set ACTIVEIOS=OFF

::overwrite option in settings.bat
support\sfk filter Support\settings.bat -!"Set ACTIVEIOS=" -write -yes>nul
echo Set ACTIVEIOS=%ACTIVEIOS%>>Support\settings.bat

::remove hard option from cmdinput.txt
set /p removeme= <temp\cmdinput2.txt
support\sfk filter temp\cmdinput.txt -rep _" UIOS:%removeme%"__ -write -yes>nul
:noUIOScmd


::-----------IOS36: Option---------------
findStr /I " IOS36:" temp\cmdinput.txt >nul
IF ERRORLEVEL 1 (goto:noIOS36cmd) else (copy /y temp\cmdinput.txt temp\cmdinput2.txt>nul)

support\sfk filter -spat temp\cmdinput2.txt -rep _"* IOS36:"__ -rep _\x20*__ -write -yes>nul

set /p Option36cmd= <temp\cmdinput2.txt

if /i "%Option36cmd%" EQU "E" set Option36=ON
if /i "%Option36cmd%" EQU "D" set Option36=OFF

::overwrite option in settings.bat
support\sfk filter Support\settings.bat -!"Set Option36=" -write -yes>nul
echo Set Option36=%Option36%>>Support\settings.bat

::remove hard option from cmdinput.txt
set /p removeme= <temp\cmdinput2.txt
support\sfk filter temp\cmdinput.txt -rep _" IOS36:%removeme%"__ -write -yes>nul
:noIOS36cmd



::-----------SOUND: Option---------------
findStr /I " SOUND:" temp\cmdinput.txt >nul
IF ERRORLEVEL 1 (goto:noSOUNDcmd) else (copy /y temp\cmdinput.txt temp\cmdinput2.txt>nul)

support\sfk filter -spat temp\cmdinput2.txt -rep _"* SOUND:"__ -rep _\x20*__ -write -yes>nul

set /p AudioOptioncmd= <temp\cmdinput2.txt

if /i "%AudioOptioncmd%" EQU "E" set AudioOption=ON
if /i "%AudioOptioncmd%" EQU "D" set AudioOption=OFF

::overwrite option in settings.bat
support\sfk filter Support\settings.bat -!"Set AudioOption=" -write -yes>nul
echo Set AudioOption=%AudioOption%>>Support\settings.bat

::remove hard option from cmdinput.txt
set /p removeme= <temp\cmdinput2.txt
support\sfk filter temp\cmdinput.txt -rep _" SOUND:%removeme%"__ -write -yes>nul
:noSOUNDcmd


::-----------CMIOS: Option---------------
findStr /I " CMIOS:" temp\cmdinput.txt >nul
IF ERRORLEVEL 1 (goto:noCMIOScmd) else (copy /y temp\cmdinput.txt temp\cmdinput2.txt>nul)

support\sfk filter -spat temp\cmdinput2.txt -rep _"* CMIOS:"__ -rep _\x20*__ -write -yes>nul

set /p CMIOSOPTIONcmd= <temp\cmdinput2.txt

if /i "%CMIOSOPTIONcmd%" EQU "E" set CMIOSOPTION=ON
if /i "%CMIOSOPTIONcmd%" EQU "D" set CMIOSOPTION=OFF

::overwrite option in settings.bat
support\sfk filter Support\settings.bat -!"Set CMIOSOPTION=" -write -yes>nul
echo Set CMIOSOPTION=%CMIOSOPTION%>>Support\settings.bat

::remove hard option from cmdinput.txt
set /p removeme= <temp\cmdinput2.txt
support\sfk filter temp\cmdinput.txt -rep _" CMIOS:%removeme%"__ -write -yes>nul
:noCMIOScmd


::-----------USB-Loader Forwarder: Option---------------
findStr /I " FWD:" temp\cmdinput.txt >nul
IF ERRORLEVEL 1 (goto:noFWDcmd) else (copy /y temp\cmdinput.txt temp\cmdinput2.txt>nul)

support\sfk filter -spat temp\cmdinput2.txt -rep _"* FWD:"__ -rep _\x20*__ -write -yes>nul

set /p FWDOPTIONcmd= <temp\cmdinput2.txt

if /i "%FWDOPTIONcmd%" EQU "E" set FWDOPTION=ON
if /i "%FWDOPTIONcmd%" EQU "D" set FWDOPTION=OFF

::overwrite option in settings.bat
support\sfk filter Support\settings.bat -!"Set FWDOPTION=" -write -yes>nul
echo Set FWDOPTION=%FWDOPTION%>>Support\settings.bat

::remove hard option from cmdinput.txt
set /p removeme= <temp\cmdinput2.txt
support\sfk filter temp\cmdinput.txt -rep _" FWD:%removeme%"__ -write -yes>nul
:noFWDcmd


::-----------VERBOSE: Option---------------
findStr /I " VERBOSE:" temp\cmdinput.txt >nul
IF ERRORLEVEL 1 (goto:noVERBOSEcmd) else (copy /y temp\cmdinput.txt temp\cmdinput2.txt>nul)

support\sfk filter -spat temp\cmdinput2.txt -rep _"* VERBOSE:"__ -rep _\x20*__ -write -yes>nul

set /p ModMiiverbosecmd= <temp\cmdinput2.txt

if /i "%ModMiiverbosecmd%" EQU "E" set ModMiiverbose=ON
if /i "%ModMiiverbosecmd%" EQU "D" set ModMiiverbose=OFF

::overwrite option in settings.bat
support\sfk filter Support\settings.bat -!"Set ModMiiverbose=" -write -yes>nul
echo Set ModMiiverbose=%ModMiiverbose%>>Support\settings.bat

::remove hard option from cmdinput.txt
set /p removeme= <temp\cmdinput2.txt
support\sfk filter temp\cmdinput.txt -rep _" VERBOSE:%removeme%"__ -write -yes>nul
:noVERBOSEcmd



::-----------n2o: Option---------------
findStr /I " n2o:" temp\cmdinput.txt >nul
IF ERRORLEVEL 1 (goto:non2ocmd) else (copy /y temp\cmdinput.txt temp\cmdinput2.txt>nul)

support\sfk filter -spat temp\cmdinput2.txt -rep _"* n2o:"__ -rep _\x20*__ -write -yes>nul

set /p NEEKcmd= <temp\cmdinput2.txt

if /i "%NEEKcmd%" EQU "E" set neek2o=ON
if /i "%NEEKcmd%" EQU "D" set neek2o=OFF

::overwrite option in settings.bat
support\sfk filter Support\settings.bat -!"Set neek2o=" -write -yes>nul
echo Set neek2o=%neek2o%>>Support\settings.bat

::remove hard option from cmdinput.txt
set /p removeme= <temp\cmdinput2.txt
support\sfk filter temp\cmdinput.txt -rep _" n2o:%removeme%"__ -write -yes>nul
:non2ocmd



::-----------SSD: Option---------------
findStr /I " SSD:" temp\cmdinput.txt >nul
IF ERRORLEVEL 1 (goto:noSSDcmd) else (copy /y temp\cmdinput.txt temp\cmdinput2.txt>nul)

support\sfk filter -spat temp\cmdinput2.txt -rep _"* SSD:"__ -rep _\x20*__ -write -yes>nul

set /p SSDcmd= <temp\cmdinput2.txt

if /i "%SSDcmd%" EQU "E" set SSD=ON
if /i "%SSDcmd%" EQU "D" set SSD=OFF

::overwrite option in settings.bat
support\sfk filter Support\settings.bat -!"Set SSD=" -write -yes>nul
echo Set SSD=%SSD%>>Support\settings.bat

::remove hard option from cmdinput.txt
set /p removeme= <temp\cmdinput2.txt
support\sfk filter temp\cmdinput.txt -rep _" SSD:%removeme%"__ -write -yes>nul
:noSSDcmd


::-----------snkverbose: Option---------------
findStr /I " snkverbose:" temp\cmdinput.txt >nul
IF ERRORLEVEL 1 (goto:nosnkverbosecmd) else (copy /y temp\cmdinput.txt temp\cmdinput2.txt>nul)

support\sfk filter -spat temp\cmdinput2.txt -rep _"* snkverbose:"__ -rep _\x20*__ -write -yes>nul

set /p sneekverbosecmd= <temp\cmdinput2.txt

if /i "%sneekverbosecmd%" EQU "E" set sneekverbose=ON
if /i "%sneekverbosecmd%" EQU "D" set sneekverbose=OFF

::overwrite option in settings.bat
support\sfk filter Support\settings.bat -!"Set sneekverbose=" -write -yes>nul
echo Set sneekverbose=%sneekverbose%>>Support\settings.bat

::remove hard option from cmdinput.txt
set /p removeme= <temp\cmdinput2.txt
support\sfk filter temp\cmdinput.txt -rep _" snkverbose:%removeme%"__ -write -yes>nul
:nosnkverbosecmd


::-----------Font: Option---------------
findStr /I " Font:" temp\cmdinput.txt >nul
IF ERRORLEVEL 1 (goto:noFontcmd) else (copy /y temp\cmdinput.txt temp\cmdinput2.txt>nul)

support\sfk filter -spat temp\cmdinput2.txt -rep _"* Font:"__ -rep _\x20*__ -write -yes>nul

set /p SNKFONTcmd= <temp\cmdinput2.txt

if /i "%SNKFONTcmd%" EQU "B" set SNKFONT=B
if /i "%SNKFONTcmd%" EQU "W" set SNKFONT=W

::overwrite option in settings.bat
support\sfk filter Support\settings.bat -!"Set SNKFONT=" -write -yes>nul
echo Set SNKFONT=%SNKFONT%>>Support\settings.bat

::remove hard option from cmdinput.txt
set /p removeme= <temp\cmdinput2.txt
support\sfk filter temp\cmdinput.txt -rep _" Font:%removeme%"__ -write -yes>nul
:noFontcmd


::-----------Skin: Option---------------
findStr /I " Skin:" temp\cmdinput.txt >nul

IF ERRORLEVEL 1 (goto:noSkincmd) else (copy /y temp\cmdinput.txt temp\cmdinput2.txt>nul)

support\sfk filter -spat temp\cmdinput2.txt -rep _"* Skin:"__ -rep _\x20*__ -write -yes>nul

set /p SkinModecmd= <temp\cmdinput2.txt

if /i "%SkinModecmd%" EQU "E" set SkinMode=Y
if /i "%SkinModecmd%" EQU "D" set SkinMode=

if /i "%SkinMode%" NEQ "Y" goto:noprogress

set watitle=ModMii Skin
set waico=support\icon.ico
set temp=temp
set wabat=%TEMP%\wabat.bat
set wasig=ModMii v%currentversion% by XFlak
set wabmp=support\bmp\CLASSIC.bmp
set watext=~~~ModMii Classic Working...
::support\nircmd.exe win activate ititle "ModMiiSkinCMD"
::support\nircmd.exe win hide ititle "ModMiiSkinCMD"
start support\wizapp PB OPEN




::------Check for old Windows Versions-------
::ver | findstr /i "5\.0\." > nul
::IF %ERRORLEVEL% EQU 0 set OSYS=2000

::ver | findstr /i "5\.1\." > nul
::IF %ERRORLEVEL% EQU 0 set OSYS=XP

::ver | findstr /i "5\.2\." > nul
::IF %ERRORLEVEL% EQU 0 set OSYS=2003

::::ver | findstr /i "6\.0\." > nul
::::IF %ERRORLEVEL% EQU 0 set OSYS=VISTA

::::ver | findstr /i "6\.1\." > nul
::::IF %ERRORLEVEL% EQU 0 set OSYS=SEVEN

::if not "%OSYS%"=="" title ModMii


:noprogress

::remove hard option from cmdinput.txt
set /p removeme= <temp\cmdinput2.txt
support\sfk filter temp\cmdinput.txt -rep _" Skin:%removeme%"__ -write -yes>nul
:noSkincmd


:hardcodedoptionsfinish


::remove hard options from %cmdinput% to avoid conflict
set /p cmdinput= <temp\cmdinput.txt

if /i "%one%" EQU "W" goto:cmdlinewizard
if /i "%one%" EQU "RC" goto:cmdlineRegionChange
if /i "%one%" EQU "HS" goto:cmdlinehackmiisolutions
if /i "%one%" EQU "S" goto:cmdlinesneekinstaller
if /i "%one%" EQU "U" goto:cmdlineUSBLoaderSetup
if /i "%one%" EQU "SE" goto:cmdlineemunandbuilder
if /i "%one%" EQU "E" goto:cmdlineemunandbuilder
if /i "%one%" EQU "L" goto:cmdlineloadqueue
if /i "%one%" EQU "SU" goto:cmdlinesyscheck
if /i "%one%" EQU "AW" goto:cmdlineabstinenceWizard
::-----------------------------------
:cmdlinewizard
set MENU1=%one%
set VIRGIN=Y


if /i "%two%" EQU "4.3" set FIRMSTART=%two%
if /i "%two%" EQU "4.2" set FIRMSTART=%two%
if /i "%two%" EQU "4.1" set FIRMSTART=%two%
if /i "%two%" EQU "4.0" set FIRMSTART=%two%
if /i "%two%" EQU "3.X" set FIRMSTART=%two%
if /i "%two%" EQU "o" set FIRMSTART=%two%
if "%firmstart%"=="" (echo "%two%" is not a valid input, try again...) & (if exist support\settings.bak move /y support\settings.bak support\settings.bat>nul) & (@ping 127.0.0.1 -n 5 -w 1000> nul) & (exit)

if /i "%three%" EQU "U" set REGION=%three%
if /i "%three%" EQU "E" set REGION=%three%
if /i "%three%" EQU "J" set REGION=%three%
if /i "%three%" EQU "K" set REGION=%three%
if "%region%"=="" (echo "%three%" is not a valid input, try again...) & (if exist support\settings.bak move /y support\settings.bak support\settings.bat>nul) & (@ping 127.0.0.1 -n 5 -w 1000> nul) & (exit)


if /i "%four%" EQU "4.3" set FIRM=%four%
if /i "%four%" EQU "4.2" set FIRM=%four%
if /i "%four%" EQU "4.1" set FIRM=%four%

if not "%firm%"=="" goto:nofirmdefaults
set FIRM=4.1
if /i "%FIRMSTART%" EQU "4.2" set FIRM=4.2
if /i "%FIRMSTART%" EQU "4.3" set FIRM=4.3
:nofirmdefaults


::----EXtras------
::set defaults
set ThemeSelection=N
set MIIQ=N
set PIC=N
set NET=N
set WEATHER=N
set NEWS=N
set SHOP=N
set SPEAK=N
set USBGUIDE=N

findStr /I " Guide" temp\cmdinput.txt >nul
IF ERRORLEVEL 1 (set cmdguide=) else (set cmdguide=G)
if /i "%cmdguide%" EQU "G" set settings=G


::----themes----
findStr /I " Red" temp\cmdinput.txt >nul
IF ERRORLEVEL 1 (set ThemeSelection=N) else (set ThemeSelection=R)
if /i "%ThemeSelection%" EQU "R" goto:donecmdthemes

findStr /I " Green" temp\cmdinput.txt >nul
IF ERRORLEVEL 1 (set ThemeSelection=N) else (set ThemeSelection=G)
if /i "%ThemeSelection%" EQU "G" goto:donecmdthemes

findStr /I " Blue" temp\cmdinput.txt >nul
IF ERRORLEVEL 1 (set ThemeSelection=N) else (set ThemeSelection=BL)
if /i "%ThemeSelection%" EQU "BL" goto:donecmdthemes

findStr /I " Orange" temp\cmdinput.txt >nul
IF ERRORLEVEL 1 (set ThemeSelection=N) else (set ThemeSelection=O)
if /i "%ThemeSelection%" EQU "O" goto:donecmdthemes
:donecmdthemes


findStr /I " CH" temp\cmdinput.txt >nul
IF ERRORLEVEL 1 (set MIIQ=N) else (set MIIQ=Y)
::if /i "%MIIQ%" EQU "Y" set MIIQ=Y
if /i "%MIIQ%" EQU "Y" set PIC=Y
if /i "%MIIQ%" EQU "Y" set SHOP=Y
if /i "%REGION%" EQU "K" goto:nomoreKchannels
if /i "%MIIQ%" EQU "Y" set NET=Y
if /i "%MIIQ%" EQU "Y" set WEATHER=Y
if /i "%MIIQ%" EQU "Y" set NEWS=Y
if /i "%MIIQ%" EQU "Y" set SPEAK=Y
:nomoreKchannels
if /i "%MIIQ%" EQU "Y" goto:alreadygotallchannels


findStr /I " PHOTO" temp\cmdinput.txt >nul
IF ERRORLEVEL 1 (set PIC=N) else (set PIC=Y)

findStr /I " SHOP" temp\cmdinput.txt >nul
IF ERRORLEVEL 1 (set SHOP=N) else (set SHOP=Y)

findStr /I " MII" temp\cmdinput.txt >nul
IF ERRORLEVEL 1 (set MIIQ=N) else (set MIIQ=Y)


if /i "%REGION%" EQU "K" goto:alreadygotallchannels

findStr /I " SPEAK" temp\cmdinput.txt >nul
IF ERRORLEVEL 1 (set SPEAK=N) else (set SPEAK=Y)

findStr /I " NEWS" temp\cmdinput.txt >nul
IF ERRORLEVEL 1 (set NEWS=N) else (set NEWS=Y)

findStr /I " NET" temp\cmdinput.txt >nul
IF ERRORLEVEL 1 (set NET=N) else (set NET=Y)

findStr /I " WEATHER" temp\cmdinput.txt >nul
IF ERRORLEVEL 1 (set WEATHER=N) else (set WEATHER=Y)
:alreadygotallchannels

findStr /I " USB" temp\cmdinput.txt >nul
IF ERRORLEVEL 1 (goto:noUSBcmd) else (set USBGUIDE=Y)

::FORMAT - FAT32 (or 1) is default
findStr /I " FAT32-NTFS" temp\cmdinput.txt >nul
IF ERRORLEVEL 1 (set FORMAT=1) else (set FORMAT=3)
if /i "%FORMAT%" NEQ "1" goto:donecmdformat

findStr /I " WBFS-FAT32" temp\cmdinput.txt >nul
IF ERRORLEVEL 1 (set FORMAT=1) else (set FORMAT=5)
if /i "%FORMAT%" NEQ "1" goto:donecmdformat

findStr /I " NTFS" temp\cmdinput.txt >nul
IF ERRORLEVEL 1 (set FORMAT=1) else (set FORMAT=2)
if /i "%FORMAT%" NEQ "1" goto:donecmdformat

findStr /I " WBFS" temp\cmdinput.txt >nul
IF ERRORLEVEL 1 (set FORMAT=1) else (set FORMAT=4)
:donecmdformat

::Loader - CFG (or 1) is default
findStr /I " CFG-FLOW" temp\cmdinput.txt >nul
IF ERRORLEVEL 1 (set LOADER=CFG) else (set LOADER=ALL)
if /i "%LOADER%" NEQ "CFG" goto:donecmdloader

findStr /I " FLOW" temp\cmdinput.txt >nul
IF ERRORLEVEL 1 (set LOADER=CFG) else (set LOADER=FLOW)
:donecmdloader

::USB-Loader Config files (USB is default)
findStr /I " SDConfig" temp\cmdinput.txt >nul
IF ERRORLEVEL 1 (set USBCONFIG=USB) else (set USBCONFIG=SD)
:noUSBcmd


findStr /I " Min" temp\cmdinput.txt >nul
IF ERRORLEVEL 1 (goto:notminupdate) else (set VIRGIN=N)

findStr /I " HBC" temp\cmdinput.txt >nul
IF ERRORLEVEL 1 (set HMInstaller=N) else (set HMInstaller=Y)

findStr /I " REC" temp\cmdinput.txt >nul
IF ERRORLEVEL 1 (set RECCIOS=N) else (set RECCIOS=Y)

findStr /I " YAWMM" temp\cmdinput.txt >nul
IF ERRORLEVEL 1 (set yawmQ=N) else (set yawmQ=Y)

findStr /I " 236" temp\cmdinput.txt >nul
IF ERRORLEVEL 1 (set IOS236InstallerQ=N) else (set IOS236InstallerQ=Y)

findStr /I " Pri" temp\cmdinput.txt >nul
IF ERRORLEVEL 1 (set PRIQ=N) else (set PRIQ=Y)
:notminupdate


goto:cmdlineExploitCheck




::---------------------------------
:cmdlinehackmiisolutions
set MENU1=H


if /i "%two%" EQU "4.3" set FIRMSTART=%two%
if /i "%two%" EQU "4.2" set FIRMSTART=%two%
if /i "%two%" EQU "4.1" set FIRMSTART=%two%
if /i "%two%" EQU "4.0" set FIRMSTART=%two%
if /i "%two%" EQU "3.X" set FIRMSTART=%two%
if /i "%two%" EQU "o" set FIRMSTART=%two%
if "%firmstart%"=="" (echo "%two%" is not a valid input, try again...) & (if exist support\settings.bak move /y support\settings.bak support\settings.bat>nul) & (@ping 127.0.0.1 -n 5 -w 1000> nul) & (exit)

findStr /I " Guide" temp\cmdinput.txt >nul
IF ERRORLEVEL 1 (set cmdguide=) else (set cmdguide=G)
if /i "%cmdguide%" EQU "G" set settings=G



:cmdlineExploitCheck
if /i "%FIRMSTART%" EQU "4.3" goto:cmdline4.3Exploits
if /i "%FIRMSTART%" EQU "o" goto:cmdlineDiscExploits
goto:nocmdlineDiscExploits


::-----------MAC:*---------------
:cmdline4.3Exploits
findStr /I " MAC:" temp\cmdinput.txt >nul
IF ERRORLEVEL 1 (goto:noMACcmd) else (copy /y temp\cmdinput.txt temp\cmdinput2.txt>nul)

set EXPLOIT=W

support\sfk filter -spat temp\cmdinput2.txt -rep _"* MAC:"__ -rep _\x20*__ -rep _"-"__ -rep _":"__ -write -yes>nul

set /p macaddress= <temp\cmdinput2.txt

::confirm 12 digits
if "%macaddress:~11%"=="" goto:badkey
if not "%macaddress:~12%"=="" goto:badkey

::confirm MAC addy is hex chars

set digit=0

:confirmMACaddycmd

if /i "%SkinMode%" EQU "Y" goto:quickskip

set /a digit=%digit%+1
set testme=
if /i "%digit%" EQU "1" set testme=%macaddress:~0,1%
if /i "%digit%" EQU "2" set testme=%macaddress:~1,1%
if /i "%digit%" EQU "3" set testme=%macaddress:~2,1%
if /i "%digit%" EQU "4" set testme=%macaddress:~3,1%
if /i "%digit%" EQU "5" set testme=%macaddress:~4,1%
if /i "%digit%" EQU "6" set testme=%macaddress:~5,1%
if /i "%digit%" EQU "7" set testme=%macaddress:~6,1%
if /i "%digit%" EQU "8" set testme=%macaddress:~7,1%
if /i "%digit%" EQU "9" set testme=%macaddress:~8,1%
if /i "%digit%" EQU "10" set testme=%macaddress:~9,1%
if /i "%digit%" EQU "11" set testme=%macaddress:~10,1%
if /i "%digit%" EQU "12" set testme=%macaddress:~11,1%

if "%testme%"=="" goto:quickskip

if /i "%testme%" EQU "0" goto:confirmMACaddycmd
if /i "%testme%" EQU "1" goto:confirmMACaddycmd
if /i "%testme%" EQU "2" goto:confirmMACaddycmd
if /i "%testme%" EQU "3" goto:confirmMACaddycmd
if /i "%testme%" EQU "4" goto:confirmMACaddycmd
if /i "%testme%" EQU "5" goto:confirmMACaddycmd
if /i "%testme%" EQU "6" goto:confirmMACaddycmd
if /i "%testme%" EQU "7" goto:confirmMACaddycmd
if /i "%testme%" EQU "8" goto:confirmMACaddycmd
if /i "%testme%" EQU "9" goto:confirmMACaddycmd
if /i "%testme%" EQU "a" goto:confirmMACaddycmd
if /i "%testme%" EQU "b" goto:confirmMACaddycmd
if /i "%testme%" EQU "c" goto:confirmMACaddycmd
if /i "%testme%" EQU "d" goto:confirmMACaddycmd
if /i "%testme%" EQU "e" goto:confirmMACaddycmd
if /i "%testme%" EQU "f" goto:confirmMACaddycmd

goto:badkey
:quickskip

::pass
goto:noMACcmd

:badkey
echo "%macaddress%" is not a valid MAC Address, try again...
if exist support\settings.bak move /y support\settings.bak support\settings.bat>nul
@ping 127.0.0.1 -n 5 -w 1000> nul
exit
:noMACcmd




:cmdlineDiscExploits
findStr /I /C:" IndianaPwns" temp\cmdinput.txt >nul
IF not ERRORLEVEL 1 set EXPLOIT=L

findStr /I /C:" Bathaxx" temp\cmdinput.txt >nul
IF not ERRORLEVEL 1 set EXPLOIT=LB

findStr /I /C:" ROTJ" temp\cmdinput.txt >nul
IF not ERRORLEVEL 1 set EXPLOIT=LS

findStr /I /C:" YuGiOwned" temp\cmdinput.txt >nul
IF not ERRORLEVEL 1 set EXPLOIT=Y

findStr /I /C:" SmashStack" temp\cmdinput.txt >nul
IF not ERRORLEVEL 1 set EXPLOIT=S

if /i "%FIRMSTART%" NEQ "o" goto:notwi
findStr /I /C:" Twilight" temp\cmdinput.txt >nul
IF not ERRORLEVEL 1 set EXPLOIT=T
:notwi

findStr /I /C:" AllExploits" temp\cmdinput.txt >nul
IF not ERRORLEVEL 1 set EXPLOIT=?

::apply default exploits
if not "%EXPLOIT%"=="" goto:nocmdlineDiscExploits
if /i "%firmstart%" EQU "4.3" set EXPLOIT=?
if /i "%firmstart%" EQU "o" set EXPLOIT=?
:nocmdlineDiscExploits

goto:go




::---------------------------------
:cmdlineRegionChange
set MENU1=%one%

set FIRMSTART=

if /i "%two:~0,3%" EQU "4.3" set FIRM=%two:~0,3%
if /i "%two:~0,3%" EQU "4.2" set FIRM=%two:~0,3%
if /i "%two:~0,3%" EQU "4.1" set FIRM=%two:~0,3%

if "%firm%"=="" (echo "%two:~0,3%" is not a valid input, try again...) & (if exist support\settings.bak move /y support\settings.bak support\settings.bat>nul) & (@ping 127.0.0.1 -n 5 -w 1000> nul) & (exit)


if /i "%two:~3,1%" EQU "U" set REGION=%two:~3,1%
if /i "%two:~3,1%" EQU "E" set REGION=%two:~3,1%
if /i "%two:~3,1%" EQU "J" set REGION=%two:~3,1%
if /i "%two:~3,1%" EQU "K" set REGION=%two:~3,1%

if "%region%"=="" (echo "%two:~3,1%" is not a valid input, try again...) & (if exist support\settings.bak move /y support\settings.bak support\settings.bat>nul) & (@ping 127.0.0.1 -n 5 -w 1000> nul) & (exit)


findStr /I " Guide" temp\cmdinput.txt >nul
IF ERRORLEVEL 1 (set cmdguide=) else (set cmdguide=G)
if /i "%cmdguide%" EQU "G" set settings=G


::----themes----
findStr /I " Red" temp\cmdinput.txt >nul
IF ERRORLEVEL 1 (set ThemeSelection=N) else (set ThemeSelection=R)
if /i "%ThemeSelection%" EQU "R" goto:donecmdthemes

findStr /I " Green" temp\cmdinput.txt >nul
IF ERRORLEVEL 1 (set ThemeSelection=N) else (set ThemeSelection=G)
if /i "%ThemeSelection%" EQU "G" goto:donecmdthemes

findStr /I " Blue" temp\cmdinput.txt >nul
IF ERRORLEVEL 1 (set ThemeSelection=N) else (set ThemeSelection=BL)
if /i "%ThemeSelection%" EQU "BL" goto:donecmdthemes

findStr /I " Orange" temp\cmdinput.txt >nul
IF ERRORLEVEL 1 (set ThemeSelection=N) else (set ThemeSelection=O)
if /i "%ThemeSelection%" EQU "O" goto:donecmdthemes
:donecmdthemes


goto:go



::---------------------------------
:cmdlineUSBLoaderSetup
set MENU1=%one%


::FORMAT - FAT32 (or 1) is default
findStr /I " FAT32-NTFS" temp\cmdinput.txt >nul
IF ERRORLEVEL 1 (set FORMAT=1) else (set FORMAT=3)
if /i "%FORMAT%" NEQ "1" goto:donecmdformat

findStr /I " WBFS-FAT32" temp\cmdinput.txt >nul
IF ERRORLEVEL 1 (set FORMAT=1) else (set FORMAT=5)
if /i "%FORMAT%" NEQ "1" goto:donecmdformat

findStr /I " NTFS" temp\cmdinput.txt >nul
IF ERRORLEVEL 1 (set FORMAT=1) else (set FORMAT=2)
if /i "%FORMAT%" NEQ "1" goto:donecmdformat

findStr /I " WBFS" temp\cmdinput.txt >nul
IF ERRORLEVEL 1 (set FORMAT=1) else (set FORMAT=4)
:donecmdformat

::Loader - CFG (or 1) is default
findStr /I " CFG-FLOW" temp\cmdinput.txt >nul
IF ERRORLEVEL 1 (set LOADER=CFG) else (set LOADER=ALL)
if /i "%LOADER%" NEQ "CFG" goto:donecmdloader

findStr /I " FLOW" temp\cmdinput.txt >nul
IF ERRORLEVEL 1 (set LOADER=CFG) else (set LOADER=FLOW)
:donecmdloader

::USB-Loader Config files (USB is default)
findStr /I " SDConfig" temp\cmdinput.txt >nul
IF ERRORLEVEL 1 (set USBCONFIG=USB) else (set USBCONFIG=SD)


findStr /I " Guide" temp\cmdinput.txt >nul
IF ERRORLEVEL 1 (set cmdguide=) else (set cmdguide=G)
if /i "%cmdguide%" EQU "G" set settings=G


goto:go


::---------------------------------
:cmdlinesyscheck

set MENU1=SU

findStr /I ".csv" temp\cmdinput.txt >nul
IF ERRORLEVEL 1 (echo A csv file was not identified, try again...) & (if exist support\settings.bak move /y support\settings.bak support\settings.bat>nul) & (@ping 127.0.0.1 -n 5 -w 1000> nul) & (exit)

copy /y temp\cmdinput.txt temp\cmdinput2.txt>nul

support\sfk filter -spat temp\cmdinput2.txt -rep _".csv*"_".csv"_ -write -yes>nul

set /p sysCheckName= <temp\cmdinput2.txt

if /i "%syscheckname:~0,3%" EQU "SU " set syscheckname=%syscheckname:~3%
::echo %sysCheckName%


if not exist "%sysCheckName%" (echo The csv file identified does not exist, try again...) & (if exist support\settings.bak move /y support\settings.bak support\settings.bat>nul) & (@ping 127.0.0.1 -n 5 -w 1000> nul) & (exit)

findStr /I /C:"syscheck" "%sysCheckName%" >nul
IF ERRORLEVEL 1 (echo This is not a valid syscheck log, try again...) & (if exist support\settings.bak move /y support\settings.bak support\settings.bat>nul) & (@ping 127.0.0.1 -n 5 -w 1000> nul) & (exit)

echo %syscheckname%>temp\cmdinput2.txt

::remove from temp\cmdinput.txt (compensate for _'s by replacing them with \x5f)
support\sfk -spat filter temp\cmdinput2.txt -rep _\x5f_\x22_ -write -yes>nul
support\sfk filter -quiet temp\cmdinput2.txt -rep _"""_\x5f_ -write -yes

::remove cmdinput.txt
set /p removeme= <temp\cmdinput2.txt
support\sfk -spat filter temp\cmdinput.txt -rep _" %removeme%"__ -write -yes>nul

del temp\cmdinput2.txt>nul


findStr /I " PRI" temp\cmdinput.txt >nul
IF ERRORLEVEL 1 (set PRICMD=) else (set PRICMD=Y)

findStr /I " Guide" temp\cmdinput.txt >nul
IF ERRORLEVEL 1 (set cmdguide=) else (set cmdguide=G)
if /i "%cmdguide%" EQU "G" set settings=G

::goto:sysCheckAnalyzer


goto:go

::---------------------------------
:cmdlineloadqueue

set MENU1=L


if /i "%cmdlinemodeswitchoff%" NEQ "Y" goto:notdragged
::dragged
findStr /I /C:":endofqueue" "%cmdinput%" >nul
IF ERRORLEVEL 1 (echo Not a valid ModMii Download Queue...) & (if exist support\settings.bak move /y support\settings.bak support\settings.bat>nul) & (@ping 127.0.0.1 -n 5 -w 1000> nul) & (exit)

support\sfk filter -spat temp\cmdinput.txt -rep _*\__ -write -yes>nul
set /p two= <temp\cmdinput.txt

if not exist "temp\DownloadQueues" mkdir "temp\DownloadQueues"
copy /y "%cmdinput%" "temp\DownloadQueues\%two%">nul

goto:skip

:notdragged
set two=%cmdinput:~2%
:skip

if "%two:~-4%" EQU ".bat" set two=%two:~0,-4%


if exist "temp\DownloadQueues\%two%.bat" set DLQUEUE=%two%
if "%DLQUEUE%"=="" (echo %two% does not exist, try again...) & (if exist support\settings.bak move /y support\settings.bak support\settings.bat>nul) & (@ping 127.0.0.1 -n 5 -w 1000> nul) & (exit)
set CurrentQueue=%DLQUEUE%.bat

goto:go


::---------------------------------
:cmdlineabstinenceWizard

set MENU1=S
set AbstinenceWiz=Y
set SNEEKSELECT=3

if /i "%two%" EQU "4.3" set FIRMSTART=%two%
if /i "%two%" EQU "4.2" set FIRMSTART=%two%
if /i "%two%" EQU "4.1" set FIRMSTART=%two%
if /i "%two%" EQU "4.0" set FIRMSTART=%two%
if /i "%two%" EQU "3.X" set FIRMSTART=%two%
if /i "%two%" EQU "o" set FIRMSTART=%two%
if "%firmstart%"=="" (echo "%two%" is not a valid input, try again...) & (if exist support\settings.bak move /y support\settings.bak support\settings.bat>nul) & (@ping 127.0.0.1 -n 5 -w 1000> nul) & (exit)



if /i "%three%" EQU "S" set SNEEKTYPE=%three%
if /i "%three%" EQU "U" set SNEEKTYPE=%three%
if /i "%three%" EQU "SD" set SNEEKTYPE=%three%
if /i "%three%" EQU "UD" set SNEEKTYPE=%three%
if "%SNEEKTYPE%"=="" (echo "%three%" is not a valid input, try again...) & (if exist support\settings.bak move /y support\settings.bak support\settings.bat>nul) & (@ping 127.0.0.1 -n 5 -w 1000> nul) & (exit)

set DITYPE=off
if /i "%SNEEKTYPE%" EQU "UD" set DITYPE=on
if /i "%SNEEKTYPE%" EQU "SD" set DITYPE=on


if /i "%four%" EQU "4.3" set SNKVERSION=%four%
if /i "%four%" EQU "4.2" set SNKVERSION=%four%
if /i "%four%" EQU "4.1" set SNKVERSION=%four%

if "%SNKVERSION%"=="" (echo "%four%" is not a valid input, try again...) & (if exist support\settings.bak move /y support\settings.bak support\settings.bat>nul) & (@ping 127.0.0.1 -n 5 -w 1000> nul) & (exit)

if /i "%five%" EQU "U" set SNKREGION=%five%
if /i "%five%" EQU "E" set SNKREGION=%five%
if /i "%five%" EQU "J" set SNKREGION=%five%
if /i "%five%" EQU "K" set SNKREGION=%five%

if "%SNKREGION%"=="" (echo "%five%" is not a valid input, try again...) & (if exist support\settings.bak move /y support\settings.bak support\settings.bat>nul) & (@ping 127.0.0.1 -n 5 -w 1000> nul) & (exit)


findStr /I " Guide" temp\cmdinput.txt >nul
IF ERRORLEVEL 1 (set cmdguide=) else (set cmdguide=G)
if /i "%cmdguide%" EQU "G" set settings=G

::parse other variables from other sections
goto:SNKserialCMD
::then after goto:cmdlineExploitCheck


::---------------------------------
:cmdlinesneekinstaller

::if not "%three%"=="" goto:cmdlineemunandbuilder

set MENU1=S
set SNEEKSELECT=1

if /i "%two%" EQU "S" set SNEEKTYPE=%two%
if /i "%two%" EQU "U" set SNEEKTYPE=%two%
if /i "%two%" EQU "SD" set SNEEKTYPE=%two%
if /i "%two%" EQU "UD" set SNEEKTYPE=%two%
if "%SNEEKTYPE%"=="" (echo "%two%" is not a valid input, try again...) & (if exist support\settings.bak move /y support\settings.bak support\settings.bat>nul) & (@ping 127.0.0.1 -n 5 -w 1000> nul) & (exit)


::-----------Rev:#---------------
set neekrev=1

findStr /I " Rev:" temp\cmdinput.txt >nul
IF ERRORLEVEL 1 (goto:noRevcmd) else (copy /y temp\cmdinput.txt temp\cmdinput2.txt>nul)

set neekrev=

support\sfk filter -spat temp\cmdinput2.txt -rep _"* Rev:"__ -rep _\x20*__ -write -yes>nul

set /p CurrentRev= <temp\cmdinput2.txt

::remove hard option from cmdinput.txt
set /p removeme= <temp\cmdinput2.txt
support\sfk -spat filter temp\cmdinput.txt -rep _" Rev:%removeme%"__ -write -yes>nul

if /i "%neek2o%" EQU "ON" (set googlecode=custom-di) & (set neekname=neek2o)
if /i "%neek2o%" NEQ "ON" (set googlecode=sneeky-compiler) & (set neekname=neek)


if exist "temp\%neekname%\%neekname%-rev%CurrentRev%.zip" goto:noRevcmd

start /min /wait support\wget --no-check-certificate -t 3 "http://%googlecode%.googlecode.com/files/%neekname%-rev%CurrentRev%.zip"
if not exist "%neekname%-rev%CurrentRev%.zip" (echo "%CurrentRev%" is not a valid input, try again...) & (echo check this URL for available versions: http://code.google.com/p/%googlecode%/downloads/list) & (if exist support\settings.bak move /y support\settings.bak support\settings.bat>nul) & (@ping 127.0.0.1 -n 5 -w 1000> nul) & (exit)

if not exist "temp\%neekname%" mkdir "temp\%neekname%"
move /y "%neekname%-rev%CurrentRev%.zip" "temp\%neekname%\%neekname%-rev%CurrentRev%.zip">nul

:noRevcmd



goto:go



::---------------------------------
:cmdlineemunandbuilder

set MENU1=S

if /i "%one%" EQU "E" set SNEEKSELECT=2
if /i "%one%" EQU "SE" set SNEEKSELECT=3


if /i "%two%" EQU "S" set SNEEKTYPE=%two%
if /i "%two%" EQU "U" set SNEEKTYPE=%two%
if /i "%two%" EQU "SD" set SNEEKTYPE=%two%
if /i "%two%" EQU "UD" set SNEEKTYPE=%two%
if "%SNEEKTYPE%"=="" (echo "%two%" is not a valid input, try again...) & (if exist support\settings.bak move /y support\settings.bak support\settings.bat>nul) & (@ping 127.0.0.1 -n 5 -w 1000> nul) & (exit)

set DITYPE=off
if /i "%SNEEKTYPE%" EQU "UD" set DITYPE=on
if /i "%SNEEKTYPE%" EQU "SD" set DITYPE=on


if /i "%three%" EQU "4.3" set SNKVERSION=%three%
if /i "%three%" EQU "4.2" set SNKVERSION=%three%
if /i "%three%" EQU "4.1" set SNKVERSION=%three%

if "%SNKVERSION%"=="" (echo "%three%" is not a valid input, try again...) & (if exist support\settings.bak move /y support\settings.bak support\settings.bat>nul) & (@ping 127.0.0.1 -n 5 -w 1000> nul) & (exit)

if /i "%four%" EQU "U" set SNKREGION=%four%
if /i "%four%" EQU "E" set SNKREGION=%four%
if /i "%four%" EQU "J" set SNKREGION=%four%
if /i "%four%" EQU "K" set SNKREGION=%four%

if "%SNKREGION%"=="" (echo "%four%" is not a valid input, try again...) & (if exist support\settings.bak move /y support\settings.bak support\settings.bat>nul) & (@ping 127.0.0.1 -n 5 -w 1000> nul) & (exit)


:SNKserialCMD
::-----------SN: (ie. SN:LU111111111)---------------
findStr /I " SN:" temp\cmdinput.txt >nul
if ERRORLEVEL 1 (goto:noSNcmd) else (copy /y temp\cmdinput.txt temp\cmdinput2.txt>nul)

support\sfk filter -spat temp\cmdinput2.txt -rep _"* SN:"__ -rep _\x20*__ -write -yes>nul

set /p SNKSERIAL= <temp\cmdinput2.txt

::remove hard option from cmdinput.txt
set /p removeme= <temp\cmdinput2.txt
support\sfk -spat filter temp\cmdinput.txt -rep _" SN:%removeme%"__ -write -yes>nul

::limit user input to X# of digits
if "%SNKSERIAL:~2%"=="" (goto:badsnkkey)
if "%SNKSERIAL:~3%"=="" (goto:badsnkkey)
if "%SNKSERIAL:~4%"=="" (goto:badsnkkey)
if "%SNKSERIAL:~5%"=="" (goto:badsnkkey)
if "%SNKSERIAL:~6%"=="" (goto:badsnkkey)
if "%SNKSERIAL:~7%"=="" (goto:badsnkkey)
if "%SNKSERIAL:~8%"=="" (goto:badsnkkey)
if "%SNKSERIAL:~9%"=="" (goto:badsnkkey)
if "%SNKSERIAL:~10%"=="" (goto:badsnkkey)

if /i "%SNKREGION%" EQU "U" goto:skip
::if "%SNKSERIAL:~11%"=="" (goto:badsnkkey)
:skip

if not "%SNKSERIAL:~12%"=="" (goto:badsnkkey)

::next page
goto:skipSNdefaults

:badsnkkey
echo "%SNKSERIAL%" is not a valid input, try again...
if exist support\settings.bak move /y support\settings.bak support\settings.bat>nul
@ping 127.0.0.1 -n 5 -w 1000> nul
exit

:noSNcmd

if /i "%SNKREGION%" EQU "U" set SNKSERIAL=LU521175683
if /i "%SNKREGION%" EQU "E" set SNKSERIAL=LEH133789940
if /i "%SNKREGION%" EQU "J" set SNKSERIAL=LJM101175683
if /i "%SNKREGION%" EQU "K" set SNKSERIAL=LJM101175683

:skipSNdefaults



::-----------Rev:#---------------
set neekrev=1

findStr /I " Rev:" temp\cmdinput.txt >nul
IF ERRORLEVEL 1 (goto:noRevcmd) else (copy /y temp\cmdinput.txt temp\cmdinput2.txt>nul)
set neekrev=

support\sfk filter -spat temp\cmdinput2.txt -rep _"* Rev:"__ -rep _\x20*__ -write -yes>nul

set /p CurrentRev= <temp\cmdinput2.txt

::remove hard option from cmdinput.txt
set /p removeme= <temp\cmdinput2.txt
support\sfk -spat filter temp\cmdinput.txt -rep _" Rev:%removeme%"__ -write -yes>nul

if /i "%neek2o%" EQU "ON" (set googlecode=custom-di) & (set neekname=neek2o)
if /i "%neek2o%" NEQ "ON" (set googlecode=sneeky-compiler) & (set neekname=neek)

::---------------SKIN MODE-------------
if /i "%SkinMode%" EQU "Y" goto:noRevcmd

if exist "temp\%neekname%\%neekname%-rev%CurrentRev%.zip" goto:noRevcmd

start /min /wait support\wget --no-check-certificate -t 3 "http://%googlecode%.googlecode.com/files/%neekname%-rev%CurrentRev%.zip"
if not exist "%neekname%-rev%CurrentRev%.zip" (echo "%CurrentRev%" is not a valid input, try again...) & (echo check this URL for available versions: http://code.google.com/p/%googlecode%/downloads/list) & (if exist support\settings.bak move /y support\settings.bak support\settings.bat>nul) & (@ping 127.0.0.1 -n 5 -w 1000> nul) & (exit)

if not exist "temp\%neekname%" mkdir "temp\%neekname%"
move /y "%neekname%-rev%CurrentRev%.zip" "temp\%neekname%\%neekname%-rev%CurrentRev%.zip">nul


:noRevcmd



::----------Other-----------
::set defaults

set ThemeSelection=N
set SNKPLC=N
set SNKCIOS=N
set SNKcBC=N
set SNKPRI=N
set SNKFLOW=N
set SNKS2U=N
set MIIQ=N
set PIC=N
set NET=N
set WEATHER=N
set NEWS=N
set SHOP=N
set SPEAK=N


if /i "%SNEEKTYPE:~0,1%" NEQ "U" goto:notUorUD
findStr /I " S2U" temp\cmdinput.txt >nul
IF ERRORLEVEL 1 (set SNKS2U=N) else (set SNKS2U=Y)
:notUorUD

findStr /I " CH" temp\cmdinput.txt >nul
IF ERRORLEVEL 1 (set MIIQ=N) else (set MIIQ=Y)
::if /i "%MIIQ%" EQU "Y" set MIIQ=Y
if /i "%MIIQ%" EQU "Y" set PIC=Y
if /i "%MIIQ%" EQU "Y" set SHOP=Y
if /i "%SNKREGION%" EQU "K" goto:nomoreKchannels
if /i "%MIIQ%" EQU "Y" set NET=Y
if /i "%MIIQ%" EQU "Y" set WEATHER=Y
if /i "%MIIQ%" EQU "Y" set NEWS=Y
if /i "%MIIQ%" EQU "Y" set SPEAK=Y
:nomoreKchannels
if /i "%MIIQ%" EQU "Y" goto:alreadygotallchannels


findStr /I " PHOTO" temp\cmdinput.txt >nul
IF ERRORLEVEL 1 (set PIC=N) else (set PIC=Y)

findStr /I " SHOP" temp\cmdinput.txt >nul
IF ERRORLEVEL 1 (set SHOP=N) else (set SHOP=Y)

findStr /I " MII" temp\cmdinput.txt >nul
IF ERRORLEVEL 1 (set MIIQ=N) else (set MIIQ=Y)


if /i "%SNKREGION%" EQU "K" goto:alreadygotallchannels

findStr /I " SPEAK" temp\cmdinput.txt >nul
IF ERRORLEVEL 1 (set SPEAK=N) else (set SPEAK=Y)

findStr /I " NEWS" temp\cmdinput.txt >nul
IF ERRORLEVEL 1 (set NEWS=N) else (set NEWS=Y)

findStr /I " NET" temp\cmdinput.txt >nul
IF ERRORLEVEL 1 (set NET=N) else (set NET=Y)

findStr /I " WEATHER" temp\cmdinput.txt >nul
IF ERRORLEVEL 1 (set WEATHER=N) else (set WEATHER=Y)
:alreadygotallchannels



findStr /I " PLC" temp\cmdinput.txt >nul
IF ERRORLEVEL 1 (set SNKPLC=N) else (set SNKPLC=Y)

findStr /I " 249" temp\cmdinput.txt >nul
IF ERRORLEVEL 1 (set SNKcIOS=N) else (set SNKcIOS=Y)

findStr /I " NMM" temp\cmdinput.txt >nul
IF ERRORLEVEL 1 (set SNKcBC=N) else (set SNKcBC=NMM)

::DML only if using SNEEK+DI and if NMM is not also selected
if /i "%SNKcBC%" EQU "NMM" goto:skipDMLcmd
if /i "%SNEEKTYPE%" NEQ "SD" goto:skipDMLcmd
findStr /I " DML" temp\cmdinput.txt >nul
IF ERRORLEVEL 1 (set SNKcBC=N) else (set SNKcBC=DML)
:skipDMLcmd

findStr /I " Pri" temp\cmdinput.txt >nul
IF ERRORLEVEL 1 (set SNKPRI=N) else (set SNKPRI=Y)


findStr /I " FLOW" temp\cmdinput.txt >nul
IF ERRORLEVEL 1 (set SNKFLOW=N) else (set SNKFLOW=Y)



::----themes----
findStr /I " Red" temp\cmdinput.txt >nul
IF ERRORLEVEL 1 (set ThemeSelection=N) else (set ThemeSelection=R)
if /i "%ThemeSelection%" EQU "R" goto:donecmdthemes

findStr /I " Green" temp\cmdinput.txt >nul
IF ERRORLEVEL 1 (set ThemeSelection=N) else (set ThemeSelection=G)
if /i "%ThemeSelection%" EQU "G" goto:donecmdthemes

findStr /I " Blue" temp\cmdinput.txt >nul
IF ERRORLEVEL 1 (set ThemeSelection=N) else (set ThemeSelection=BL)
if /i "%ThemeSelection%" EQU "BL" goto:donecmdthemes

findStr /I " Orange" temp\cmdinput.txt >nul
IF ERRORLEVEL 1 (set ThemeSelection=N) else (set ThemeSelection=O)
if /i "%ThemeSelection%" EQU "O" goto:donecmdthemes

:donecmdthemes


if /i "%AbstinenceWiz%" EQU "Y" goto:cmdlineExploitCheck


goto:go
::---------------------------------
:go
::title ModMii
if exist temp\cmdinput.txt del temp\cmdinput.txt>nul
if exist temp\cmdinput2.txt del temp\cmdinput2.txt>nul
mode con cols=85 lines=54
color 1f
goto:defaultsettings
:notcmd
::---------------------------------------------------------



::title ModMii
mode con cols=85 lines=54
color 1f

::SET FILENAME=%~nx0 //this returns the name of the batch file running (doesn't work when packaged in an exe)
::SET PATHNAME=%0 //this returns the filename but also with absolute path


::Bushing from Team Twizzers specifically requested ModMii include a scam warning

set warning=
echo                                        ModMii
echo                                       by XFlak
echo.
echo.
echo.
support\sfk echo -spat \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 [Red] THIS SOFTWARE IS NOT FOR SALE.
echo.

echo          IF YOU PAID FOR THIS SOFTWARE OR RECEIVED IT AS PART OF A "BUNDLE"
echo       YOU HAVE BEEN SCAMMED AND YOU SHOULD DEMAND YOUR MONEY BACK IMMEDIATELY
echo.
echo.

support\sfk echo -spat \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 [Red] USE THIS AT YOUR OWN RISK!
echo.
echo       THIS PACKAGE COMES WITH ABSOLUTELY NO WARRANTY, NEITHER STATED NOR IMPLIED.
echo       NO ONE BUT YOURSELF IS TO BE HELD RESPONSIBLE FOR ANY DAMAGE THIS MAY CAUSE
echo                             TO YOUR NINTENDO WII CONSOLE!
echo.

echo.

echo.
echo                 Please type the word "I" followed by the word "Agree"
echo                        with a space between those two words and
echo                             then press "Enter" to continue.
echo.

echo                          If you can't follow those instructions,
echo                        then you have no business modding anything.
echo.
echo.
echo.
echo.
echo.
echo.
echo.

set /p warning=     Enter Selection Here: 

if /i "%warning%" EQU "I Agree" goto:skip
echo.
echo                                Exiting ModMii...
@ping 127.0.0.1 -n 2 -w 1000> nul
Exit
:skip

::Save version agreed to
if exist Support\settings.bat support\sfk filter -quiet Support\settings.bat -ls!"set AGREEDVERSION=" -write -yes
echo set AGREEDVERSION=%currentversion%>> Support\settings.bat


:DefaultSettings

::----LOAD SETTINGS (if exist)----
if exist Support\settings.bat call Support\settings.bat

::-----default settings (default applies even if a single variable is missing from settings.bat)------
IF "%ROOTSAVE%"=="" set ROOTSAVE=off
IF "%effect%"=="" set effect=No-Spin
IF "%PCSAVE%"=="" set PCSAVE=Auto
IF "%OPTION1%"=="" set OPTION1=off
IF "%OPTION36%"=="" set OPTION36=on
IF "%AudioOption%"=="" set AudioOption=on
IF "%CMIOSOPTION%"=="" set CMIOSOPTION=off
IF "%FWDOPTION%"=="" set FWDOPTION=on
IF "%Drive%"=="" set Drive=COPY_TO_SD
IF "%DriveU%"=="" set DriveU=COPY_TO_USB
IF "%ACTIVEIOS%"=="" set ACTIVEIOS=on
IF "%AUTOUPDATE%"=="" set AUTOUPDATE=on
IF "%ModMiiverbose%"=="" set ModMiiverbose=off
IF "%sneekverbose%"=="" set sneekverbose=off
IF "%neek2o%"=="" set neek2o=on
IF "%SSD%"=="" set SSD=off
::IF "%discexverify%"=="" set discexverify=off
IF "%SNKFONT%"=="" set SNKFONT=B
IF "%overwritecodes%"=="" set overwritecodes=off
IF "%cheatregion%"=="" set cheatregion=All
IF "%cheatlocation%"=="" set cheatlocation=B

IF "%wiicheat%"=="" set wiicheat=ON
IF "%WiiWarecheat%"=="" set WiiWarecheat=ON
IF "%VCArcadecheat%"=="" set VCArcadecheat=OFF
IF "%WiiChannelscheat%"=="" set WiiChannelscheat=ON
IF "%Gamecubecheat%"=="" set Gamecubecheat=ON
IF "%NEScheat%"=="" set NEScheat=ON
IF "%SNEScheat%"=="" set SNEScheat=ON
IF "%N64cheat%"=="" set N64cheat=ON
IF "%SMScheat%"=="" set SMScheat=ON
IF "%Segacheat%"=="" set Segacheat=ON
IF "%NeoGeocheat%"=="" set NeoGeocheat=ON
IF "%Commodorecheat%"=="" set Commodorecheat=ON
IF "%MSXcheat%"=="" set MSXcheat=ON
IF "%TurboGraFX-16cheat%"=="" set TurboGraFX-16cheat=ON
IF "%TurboGraFX-CDcheat%"=="" set TurboGraFX-CDcheat=ON


::check if drive folder exists--if second char is ":" check if drive exists
if /i "%DRIVE%" EQU "%cd%\COPY_TO_SD" set DRIVE=COPY_TO_SD
if /i "%DRIVE:~1,1%" NEQ ":" goto:skipcheck
if exist "%DRIVE:~0,2%" (goto:skipcheck) else (set DRIVE=COPY_TO_SD)
:skipcheck

::check if DRIVEU folder exists--if second char is ":" check if DRIVEU exists
if /i "%DRIVEU%" EQU "%cd%\COPY_TO_USB" set DRIVEU=COPY_TO_USB
if /i "%DRIVEU:~1,1%" NEQ ":" goto:skipcheck
if exist "%DRIVEU:~0,2%" (goto:skipcheck) else (set DRIVEU=COPY_TO_USB)
:skipcheck


::.NET Framework 3.5 check+installation
if exist "%windir%\Microsoft.NET\Framework\v3.5" goto:skipframeworkinstallation

echo ModMii requires .NET Framework 3.5 be installed
echo.

set FrameworkAttempt=0
:NETFRAMEWORK

SET /a FrameworkAttempt=%FrameworkAttempt%+1

if exist "temp\dotNetFx35setup.exe" goto:semiskip
echo Downloading .NET Framework 3.5 Installer
echo.

start %ModMiimin%/wait support\wget --no-check-certificate -t 3 "http://download.microsoft.com/download/7/0/3/703455ee-a747-4cc8-bd3e-98a615c3aedb/dotNetFx35setup.exe"

::start %ModMiimin%/wait support\wget --no-check-certificate -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait "http://download.microsoft.com/download/7/0/3/703455ee-a747-4cc8-bd3e-98a615c3aedb/dotNetFx35setup.exe"


if exist dotNetFx35setup.exe move /y dotNetFx35setup.exe temp\dotNetFx35setup.exe
:semiskip

echo Launching installer and waiting for installation to finish...
echo.
start /wait temp\dotNetFx35setup.exe


if exist "%windir%\Microsoft.NET\Framework\v3.5" goto:skipframeworkinstallation

if /i "%FrameworkAttempt%" EQU "3" goto:GiveUpOnFramework

echo Installation Failed, retrying...
echo.
echo.
goto:NETFRAMEWORK


:GiveUpOnFramework
echo.
echo.
echo.
echo .NET Framework 3.5 Installation Failed Multiple Times
echo Alternatively, you can try installing .NET Framework 3.5 by performing a Windows Update
echo.
echo Some ModMii features may not work properly without .NET Framework 3.5 installed
echo Hit any key to use ModMii anyways
pause>nul

:skipframeworkinstallation

if /i "%ModMiiverbose%" EQU "off" (set ModMiimin=/min ) else (set ModMiimin=)


::check for supporting apps that AVs are known to remove
if not exist support\libWiiSharp.dll (echo One or more of ModMii's supporting files are missing, redownloading...) & (set currentversion=0.0.0) & (@ping 127.0.0.1 -n 2 -w 1000> nul) & (goto:UpdateModMii)
if not exist support\patchios.exe (echo One or more of ModMii's supporting files are missing, redownloading...) & (set currentversion=0.0.0) & (@ping 127.0.0.1 -n 2 -w 1000> nul) & (goto:UpdateModMii)
if not exist support\wadmii.exe (echo One or more of ModMii's supporting files are missing, redownloading...) & (set currentversion=0.0.0) & (@ping 127.0.0.1 -n 2 -w 1000> nul) & (goto:UpdateModMii)
if not exist support\hexalter.exe (echo One or more of ModMii's supporting files are missing, redownloading...) & (set currentversion=0.0.0) & (@ping 127.0.0.1 -n 2 -w 1000> nul) & (goto:UpdateModMii)
if not exist support\settings.exe (echo One or more of ModMii's supporting files are missing, redownloading...) & (set currentversion=0.0.0) & (@ping 127.0.0.1 -n 2 -w 1000> nul) & (goto:UpdateModMii)
if not exist support\nircmd.exe (echo One or more of ModMii's supporting files are missing, redownloading...) & (set currentversion=0.0.0) & (@ping 127.0.0.1 -n 2 -w 1000> nul) & (goto:UpdateModMii)
if not exist support\smw-mod.exe (echo One or more of ModMii's supporting files are missing, redownloading...) & (set currentversion=0.0.0) & (@ping 127.0.0.1 -n 2 -w 1000> nul) & (goto:UpdateModMii)
if not exist support\wit.exe (echo One or more of ModMii's supporting files are missing, redownloading...) & (set currentversion=0.0.0) & (@ping 127.0.0.1 -n 2 -w 1000> nul) & (goto:UpdateModMii)
if not exist support\fvc.exe (echo One or more of ModMii's supporting files are missing, redownloading...) & (set currentversion=0.0.0) & (@ping 127.0.0.1 -n 2 -w 1000> nul) & (goto:UpdateModMii)
if not exist support\sfk.exe (echo One or more of ModMii's supporting files are missing, redownloading...) & (set currentversion=0.0.0) & (@ping 127.0.0.1 -n 2 -w 1000> nul) & (goto:UpdateModMii)
if not exist support\nusd.exe (echo One or more of ModMii's supporting files are missing, redownloading...) & (set currentversion=0.0.0) & (@ping 127.0.0.1 -n 2 -w 1000> nul) & (goto:UpdateModMii)


::Special update
::if /i "%AGREEDVERSION%" GEQ "6.3.2" goto:nospecialupdate
:::nospecialupdate


if /i "%cmdlinemode%" EQU "Y" goto:noupdateincmdlinemode
if /i "%AUTOUPDATE%" EQU "on" goto:UpdateModMii
:noupdateincmdlinemode
::......................................................MAIN MENU..............................................

:MENU


if exist temp\ModMii_Log.bat del temp\ModMii_Log.bat>nul
if exist temp\DLgotos-copy.txt del temp\DLgotos-copy.txt>nul

::----restore settings if applicable (download queue and sneek nand builder)----
IF "%MENU1%"=="" goto:NOCLEAR
if /i "%MENU1%" NEQ "O" goto:Cleartempsettings
goto:NOCLEAR
:Cleartempsettings
Set ROOTSAVE=%ROOTSAVETEMP%
Set Option1=%Option1TEMP%
:NOCLEAR

::---SET TEMP SETTINGS FOR DL QUE---
Set ROOTSAVETEMP=%ROOTSAVE%
Set Option1TEMP=%Option1%


if /i "%ModMiiverbose%" EQU "off" (set ModMiimin=/min ) else (set ModMiimin=)


::variables that interfere with cmd line wizard
::---------------CMD LINE MODE-------------
if /i "%cmdlinemode%" EQU "Y" goto:MENUafterbadvars

SET VIRGIN=
set REGIONCHANGE=
SET FIRMSTART=
set STUB=
set PIC=
set NET=
set WEATHER=
set NEWS=
set SHOP=
set SPEAK=
set MIIQ=
set REGION=
set SNKREGION=
set UpdatesIOSQ=
set SNEEKTYPE=
set SNEEKSELECT=
set USBGUIDE=
set UPAGE1=
set LOADER=
set FORMAT=NONE
set cfgfullrelease=NONE
SET EXPLOIT=default
if /i "%USBCONFIG%" EQU "USB" set DRIVE=%DRIVETEMP%
set addwadfolder=
set AbstinenceWiz=
:MENUafterbadvars


mode con cols=85 lines=54
SET lines=54

set MORE=
SET DEC=
SET HEX=
SET VER=
SET CONFIRM=
set loadorgo=go
set SMAPP=


::SET EXPLOIT=default
set exploitselection=
set COPY=
set DLTOTAL=0
set OPTIONS=
set DB=N
::set FORMAT=NONE
::set cfgfullrelease=NONE

::if /i "%USBCONFIG%" EQU "USB" set DRIVE=%DRIVETEMP%
::set USBGUIDE=
::set UPAGE1=
::set LOADER=
::set SNEEKTYPE=
::set SNEEKSELECT=
set patchIOSnum=36 or 236

::--followup--
IF "%Drive%"=="" set Drive=COPY_TO_SD
IF "%DriveU%"=="" set DriveU=COPY_TO_USB

if /i "%cmdlinemode%" NEQ "Y" set USBCONFIG=
::set USBCONFIG=


::if second char is ":" check if drive exists
if /i "%DRIVE:~1,1%" NEQ ":" goto:skipcheck
if not exist "%DRIVE:~0,2%" set DRIVE=COPY_TO_SD
:skipcheck

::if second char is ":" check if driveU exists
if /i "%DRIVEU:~1,1%" NEQ ":" goto:skipcheck
if not exist "%DRIVEU:~0,2%" set DRIVE=COPY_TO_USB
:skipcheck

:CLEAR

set basewad=none
set basewadb=none

set AdvNumber=0
if exist temp\DLnamesADV.txt del temp\DLnamesADV.txt>nul
if exist temp\DLgotosADV.txt del temp\DLgotosADV.txt>nul

set EULAU=
set EULAE=
set EULAJ=
set EULAK=
set RSU=
set RSE=
set RSJ=
set RSK=
set BC=
set SM3.2U=
set SM4.1U=
set SM4.2U=
set SM4.3U=
set SM3.2E=
set SM4.1E=
set SM4.2E=
set SM4.3E=
set SM3.2J=
set SM4.1J=
set SM4.2J=
set SM4.3J=
set SM4.1K=
set SM4.2K=
set SM4.3K=
set SM4.3U-DWR=
set SM4.2U-DWR=
set SM4.1U-DWR=
set SM4.3E-DWR=
set SM4.2E-DWR=
set SM4.1E-DWR=
set SM4.3J-DWR=
set SM4.2J-DWR=
set SM4.1J-DWR=
set SM4.3K-DWR=
set SM4.2K-DWR=
set SM4.1K-DWR=

set SM4.3U-DWG=
set SM4.2U-DWG=
set SM4.1U-DWG=
set SM4.3E-DWG=
set SM4.2E-DWG=
set SM4.1E-DWG=
set SM4.3J-DWG=
set SM4.2J-DWG=
set SM4.1J-DWG=
set SM4.3K-DWG=
set SM4.2K-DWG=
set SM4.1K-DWG=

set SM4.3U-DWB=
set SM4.2U-DWB=
set SM4.1U-DWB=
set SM4.3E-DWB=
set SM4.2E-DWB=
set SM4.1E-DWB=
set SM4.3J-DWB=
set SM4.2J-DWB=
set SM4.1J-DWB=
set SM4.3K-DWB=
set SM4.2K-DWB=
set SM4.1K-DWB=

set SM4.3U-DWO=
set SM4.2U-DWO=
set SM4.1U-DWO=
set SM4.3E-DWO=
set SM4.2E-DWO=
set SM4.1E-DWO=
set SM4.3J-DWO=
set SM4.2J-DWO=
set SM4.1J-DWO=
set SM4.3K-DWO=
set SM4.2K-DWO=
set SM4.1K-DWO=

set IOS30=
set IOS30P=
set IOS30P60=
set IOS40P60=
set IOS20P60=
set IOS11P60=
set IOS50P=
set IOS52P=
set IOS60=
set IOS60P=
set IOS70=
set IOS70P=
set IOS80=
set IOS80P=
set IOS236=

set IOS70K=
set IOS80K=
set BB1=
set BB2=
set HM=
set IOS236Installer=
set SIP=
set dop=
set casper=
set Wilbrand=
set syscheck=
set locked=
set AccioHacks=
set MyM=
set HBB=
set WII64=
set WIISX=
set bootmiisd=
set pwns=
set twi=
set YUGI=
set Bathaxx=
set ROTJ=
set TOS=
set smash=
set mmm=
set wiimod=
set ARC=
set yawm=
set neogamma=
set usbfolder=
set WiiMC=
set fceugx=
set snes9xgx=
set vbagx=
set SGM=
set PL=
set WIIX=
set flow=
set wbm=
set CheatCodes=
set f32=
set WiiGSC=
set SMW=
set CM=
set USBX=
set FLOWF=
set S2U=
set nswitch=
set PLC=
set Pri=
set HAX=
set CM5=
set MP=
set MII=
set P=
set P0=
set PK=
set S=
set SK=
set IU=
set IE=
set IJ=
set WU=
set WE=
set WJ=
set NU=
set NE=
set NJ=
set WSU=
set WSE=
set WSJ=
set M10=
set IOS9=
set IOS12=
set IOS13=
set IOS14=
set IOS15=
set IOS17=
set IOS21=
set IOS22=
set IOS28=
set IOS31=
set IOS33=
set IOS34=
set IOS35=
set IOS36=
set IOS36v3608=
set IOS37=
set IOS38=
set IOS41=
set IOS48v4124=
set IOS43=
set IOS45=
set IOS46=
set IOS53=
set IOS55=
set IOS56=
set IOS57=
set IOS58=
set IOS61=
set IOS62=
set A0e=
set A0c=
set A0e_60=
set A0e_70=
set A01=
set A01_60=
set A01_70=
set A40=
set A42=
set A45=
set A70=
set A72=
set A75=
set A78=
set A7b=
set A7e=
set A84=
set A87=
set A8a=
set A94=
set A97=
set A9a=
set A81=
set A8d=
set A9d=
set RVL-cMIOS-v65535(v10)_WiiGator_WiiPower_v0.2=
set RVL-cmios-v4_WiiGator_GCBL_v0.2=
set RVL-cmios-v4_Waninkoko_rev5=
set DarkWii_Red_4.3U=
set DarkWii_Red_4.2U=
set DarkWii_Red_4.1U=
set DarkWii_Red_4.3E=
set DarkWii_Red_4.2E=
set DarkWii_Red_4.1E=
set DarkWii_Red_4.3J=
set DarkWii_Red_4.2J=
set DarkWii_Red_4.1J=
set DarkWii_Red_4.3K=
set DarkWii_Red_4.2K=
set DarkWii_Red_4.1K=

set DarkWii_Green_4.3U=
set DarkWii_Green_4.2U=
set DarkWii_Green_4.1U=
set DarkWii_Green_4.3E=
set DarkWii_Green_4.2E=
set DarkWii_Green_4.1E=
set DarkWii_Green_4.3J=
set DarkWii_Green_4.2J=
set DarkWii_Green_4.1J=
set DarkWii_Green_4.3K=
set DarkWii_Green_4.2K=
set DarkWii_Green_4.1K=

set DarkWii_Blue_4.3U=
set DarkWii_Blue_4.2U=
set DarkWii_Blue_4.1U=
set DarkWii_Blue_4.3E=
set DarkWii_Blue_4.2E=
set DarkWii_Blue_4.1E=
set DarkWii_Blue_4.3J=
set DarkWii_Blue_4.2J=
set DarkWii_Blue_4.1J=
set DarkWii_Blue_4.3K=
set DarkWii_Blue_4.2K=
set DarkWii_Blue_4.1K=

set darkwii_orange_4.3U=
set darkwii_orange_4.2U=
set darkwii_orange_4.1U=
set darkwii_orange_4.3E=
set darkwii_orange_4.2E=
set darkwii_orange_4.1E=
set darkwii_orange_4.3J=
set darkwii_orange_4.2J=
set darkwii_orange_4.1J=
set darkwii_orange_4.3K=
set darkwii_orange_4.2K=
set darkwii_orange_4.1K=
set cIOS222[38]-v4=
set cIOS223[37-38]-v4=
set cBC=
set DML=
set cIOS222[38]-v5=
set cIOS223[37]-v5=
set cIOS224[57]-v5=
set cIOS202[60]-v5.1R=
set cIOS222[38]-v5.1R=
set cIOS223[37]-v5.1R=
set cIOS224[57]-v5.1R=
set cIOS249[37]-v19=
set cIOS249[38]-v19=
set cIOS249[57]-v19=
set cIOS249[38]-v20=
set cIOS250[38]-v20=
set cIOS249[56]-v20=
set cIOS250[56]-v20=
set cIOS249[57]-v20=
set cIOS250[57]-v20=
set cIOS249-v17b=
set cIOS249-v14=
set cIOS250-v14=
set cIOS202[37]-v5=
set cIOS202[38]-v5=
set cIOS250[57]-v19=
set cIOS250-v17b=
set cIOS250[37]-v19=
set cIOS250[38]-v19=

set cIOS249[37]-v21=
set cIOS250[37]-v21=
set cIOS249[38]-v21=
set cIOS250[38]-v21=
set cIOS249[56]-v21=

set cIOS249[53]-v21=
set cIOS250[53]-v21=
set cIOS249[55]-v21=
set cIOS250[55]-v21=


set cIOS250[56]-v21=
set cIOS249[57]-v21=
set cIOS250[57]-v21=
set cIOS249[58]-v21=
set cIOS250[58]-v21=
set cIOS249[37]-d2x-v8-final=
set cIOS249[38]-d2x-v8-final=
set cIOS249[53]-d2x-v8-final=
set cIOS249[55]-d2x-v8-final=
set cIOS249[56]-d2x-v8-final=
set cIOS249[57]-d2x-v8-final=
set cIOS249[58]-d2x-v8-final=
set cIOS249[60]-d2x-v8-final=
set cIOS249[70]-d2x-v8-final=
set cIOS249[80]-d2x-v8-final=
set cIOS250[37]-d2x-v8-final=
set cIOS250[38]-d2x-v8-final=
set cIOS250[53]-d2x-v8-final=
set cIOS250[55]-d2x-v8-final=
set cIOS250[56]-d2x-v8-final=
set cIOS250[57]-d2x-v8-final=
set cIOS250[58]-d2x-v8-final=
set cIOS250[60]-d2x-v8-final=
set cIOS250[70]-d2x-v8-final=
set cIOS250[80]-d2x-v8-final=

if /i "%secondrun%" NEQ "Y" goto:miniskip
if /i "%cleardownloadsettings%" NEQ "yes" goto:miniskip
set nswitchFound=
set BCtype=
goto:DownloadSettings
:miniskip


if /i "%MENUREAL%" EQU "S" goto:finishsneekinstall2

set nswitchFound=
set BCtype=

if /i "%cleardownloadsettings%" EQU "yes" goto:DownloadSettings

if /i "%ADVPATCH%" EQU "B" goto:ADVANCED
if /i "%ADVSLOT%" EQU "B" goto:ADVANCED
if /i "%ADVVERSION%" EQU "B" goto:ADVANCED

if /i "%list%" EQU "C" goto:list
if /i "%oldlist%" EQU "C" goto:oldlist
if /i "%LIST3%" EQU "C" goto:LIST3
if /i "%LIST4%" EQU "C" goto:LIST4
if /i "%ADVLIST%" EQU "C" goto:ADVANCED

SET COUNT=1
SET COUNT2=1
SET COUNT3=1
SET COUNT4=1
SET COUNT5=1
SET COUNT6=1
SET COUNT7=1
SET COUNT8=1
SET CURRENTDL=0



:Clear simplelog
if exist temp\ModMii_Log.bat del temp\ModMii_Log.bat>nul

::---------------CMD LINE MODE-------------
if /i "%cmdlinemode%" NEQ "Y" goto:noextravars
if /i "%one%" EQU "W" goto:DOWNLOAD
if /i "%one%" EQU "RC" goto:DOWNLOAD
if /i "%one%" EQU "SU" goto:sysCheckAnalyzer
if /i "%one%" EQU "HS" goto:HACKMIISOLUTION
if /i "%one%" EQU "L" goto:forcmdlineL
if /i "%one%" EQU "U" goto:DLCOUNT
if /i "%one%" EQU "EMUMOD" goto:doublecheckNANDPATH

if /i "%MENU1%" EQU "FC" set DRIVE=%DRIVEtemp%
if /i "%MENU1%" EQU "FC" goto:FileCleanup

if /i "%AbstinenceWiz%" EQU "Y" goto:extravars
if /i "%one%" EQU "S" goto:extravars
if /i "%one%" EQU "E" goto:extravars
if /i "%one%" EQU "SE" goto:extravars
goto:noextravars
:extravars
::random vars required for everything to work
if /i "%SNEEKTYPE:~0,1%" EQU "S" set nandpath=%DRIVE%
if /i "%SNEEKTYPE:~0,1%" EQU "U" set nandpath=%DRIVEU%

if exist "%nandpath%"\title\00000001\00000002\data\setting.txt (set settingtxtExist=yes) else (set settingtxtExist=no)

set nandexist=no
if exist "%nandpath%"\title set nandexist=yes
if exist "%nandpath%"\ticket set nandexist=yes
if exist "%nandpath%"\sys set nandexist=yes
if exist "%nandpath%"\shared1 set nandexist=yes


if /i "%neek2o%" EQU "ON" goto:DOIT
if /i "%SNKS2U%" EQU "N" goto:quickskip
:DOIT
SET NANDcount=0
if /i "%SNKREGION%" EQU "U" set nandregion=us
if /i "%SNKREGION%" EQU "E" set nandregion=eu
if /i "%SNKREGION%" EQU "J" set nandregion=jp
if /i "%SNKREGION%" EQU "K" set nandregion=kr
if not exist "%nandpath%\nands\pl_%nandregion%" set nandpath=%nandpath%\nands\pl_%nandregion%
if not exist "%nandpath%\nands\pl_%nandregion%" goto:quickskip

:NANDnamecmd
SET /a NANDcount=%NANDcount%+1
if not exist "%nandpath%\nands\pl_%nandregion%%NANDcount%" set nandpath=%nandpath%\nands\pl_%nandregion%%NANDcount%
if not exist "%nandpath%\nands\pl_%nandregion%%NANDcount%" goto:quickskip
goto:NANDnamecmd
:quickskip

if /i "%AbstinenceWiz%" EQU "Y" goto:NEEKrevSelect
if /i "%one%" EQU "S" goto:NEEKrevSelect
if /i "%one%" EQU "SE" goto:NEEKrevSelect
if /i "%one%" EQU "E" goto:SNKNANDBUILDER
:noextravars
::---------------------------------------


set MENU1=

cls

echo                                        ModMii                                v%currentversion%
echo                                       by XFlak
echo.
support\sfk echo -spat \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 [Red] Choose an Activity:
echo.
echo           W = ModMii Wizard + Guide (Start Here to Mod Your Wii!)
echo.
echo          AW = Abstinence Wizard + Guide (Use Casper without modding your Wii)
echo.
echo           U = USB-Loader Setup + Guide
echo.
echo           H = HackMii Solutions (Upside-Down HBC\No Vulnerable IOS Fix) + Guide
echo.
echo          SU = sysCheck Updater (update only your outdated softmods) + Guide
echo.
echo          RC = Region Change + Guide
echo.
echo           S = SNEEK Installation, Nand Builder, Game Bulk Extractor
echo.
echo.
echo           1 = Download Page 1 (System Menu's, IOSs, MIOSs, Channels, etc.)
echo.
echo           2 = Download Page 2 (Apps, USB-Loader Files, CheatCodes, etc.)
echo.
echo           3 = Download Page 3 (System Menu Themes)
echo.
echo           4 = Download Page 4 (cIOSs and cMIOSs)
echo.
echo           A = Advanced Downloads and Forwarder DOL\ISO Builder
echo.
echo           L = Load Download Queue
echo.
echo.
echo           C = Build Config Files for BootMii, Wad Manager or Multi-Mod Manager
echo.
echo          FC = File Cleanup: Remove un-needed files after Modding
echo.
echo.
echo           O = Options            CR = Credits            E = Exit
echo.
echo           M = ModMii Skin Mode: use your mouse instead of your keyboard!
echo.
echo      *********MORE INFO*********
support\sfk echo -spat \x20 \x20 [RED] WWW = Open http://modmii.comuf.com to ask questions, provide feedback or vote
echo.
echo      Use the ModMii Wizard to set-up your SD card with all you need to softmod
echo      your Wii or up/downgrade it and much more. When using the ModMii Wizard,
echo      a custom guide is built based on your answers to a few simple questions.
echo.
echo      ***************************
echo.
set /p MENU1=     Enter Selection Here: 


if /i "%MENU1%" EQU "W" goto:LoadWizardSettings
if /i "%MENU1%" EQU "SU" goto:sysCheckName
if /i "%MENU1%" EQU "RC" goto:RCPAGE1
if /i "%MENU1%" EQU "U" goto:UPAGE1
if /i "%MENU1%" EQU "S" goto:SNKPAGE1
if /i "%MENU1%" EQU "1" goto:LIST
if /i "%MENU1%" EQU "2" goto:OLDLIST
if /i "%MENU1%" EQU "3" goto:LIST3
if /i "%MENU1%" EQU "4" goto:LIST4
if /i "%MENU1%" EQU "A" goto:ADVANCED
if /i "%MENU1%" EQU "E" EXIT
if /i "%MENU1%" EQU "O" goto:OPTIONS
if /i "%MENU1%" EQU "H" goto:WPAGE2
if /i "%MENU1%" EQU "FC" set BACKB4DRIVE=Menu
if /i "%MENU1%" EQU "FC" goto:DRIVECHANGE
if /i "%MENU1%" EQU "C" goto:CONFIGFILEMENU

if /i "%MENU1%" EQU "M" (start ModMiiSKin.exe) & (exit)

if /i "%MENU1%" EQU "AW" (set MENU1=S) & (set SNEEKSELECT=3) & (set AbstinenceWiz=Y) & (goto:WPAGE2)



if /i "%MENU1%" EQU "CR" (start http://modmii.comuf.com/credits.html) & (goto:MENU)

if /i "%MENU1%" EQU "WWW" (start http://89d89449.miniurls.co) & (goto:MENU)


::if not exist temp\DownloadQueues\*.bat goto:noload
if /i "%MENU1%" NEQ "L" goto:noload
if exist temp\DLnamesADV.txt del temp\DLnamesADV.txt>nul
if exist temp\DLgotosADV.txt del temp\DLgotosADV.txt>nul
set BACKB4QUEUE=Menu
goto:PICKDOWNLOADQUEUE
:noload


if /i "%MENU1%" EQU "help" echo Google is your friend

echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:MENU



::..................................................OPTIONS.................................................. 
.......
:OPTIONS

Set WLAST=
Set Options=
set cheatoption=
cls
echo                                        ModMii                                v%currentversion%
echo                                       by XFlak
echo.

support\sfk echo -spat \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 [Red]Enter the option # (or letter) to enable/disable it
echo.
echo           D = Change Drive letter (Current Setting: %Drive%)
echo.
echo          DU = Change Drive letter for USB (Current Setting: %DriveU%)
echo.
echo          CC = Cheat Code Options

echo.
echo          PC = PC Programs Save Location (Current Setting: %PCSAVE%)
if /i "%PCSAVE%" EQU "Local" echo               * PC Programs saved to %HomeDrive%
if /i "%PCSAVE%" EQU "Local" echo               * Shortcuts will be installed to Start Menu and Desktop

if /i "%PCSAVE%" EQU "Portable" echo               * PC programs saved portably to one of the above Drive Settings

if /i "%PCSAVE%" NEQ "Auto" goto:skip
echo               * PC programs saved to %homedrive% with shortcuts if running ModMii from %homedrive%
echo               * PC programs saved portably if not running ModMii from %homedrive%
:skip

echo.
if /i "%ROOTSAVE%" EQU "ON" echo          RS = Root Save: Save IOSs\MIOSs to Root instead of WAD Folder (Enabled)
if /i "%ROOTSAVE%" EQU "OFF" echo          RS = Root Save: Save IOSs\MIOSs to Root instead of WAD Folder (Disabled)
echo               * Does NOT affect ModMii Wizard and only applies to IOSs\MIOSs
echo               * Useful for Wii Apps that require IOSs\MIOSs saved to Root
echo.

::echo          CE = Channel Effect for custom system menu themes: %effect%
::echo               * Choose from 3 effects: No-Spin, Spin and Fast-Spin
::echo.



if /i "%OPTION1%" EQU "OFF" echo           1 = Do not Keep 00000001 or NUS Folders for IOSs\MIOSs\SMs etc
if /i "%OPTION1%" EQU "OFF" echo               * Folder sometimes required for offline usage of a few Wii Apps
if /i "%OPTION1%" EQU "ON" echo           1 = Keep 00000001 Folder for IOSs\MIOSs\SMs etc
if /i "%OPTION1%" EQU "ON" echo               * Useful for offline usage of Wii Apps like Dop-Mii

if /i "%OPTION1%" EQU "NUS" echo           1 = Keep NUS\00000001000000##v# Folder for IOSs\MIOSs\SMs etc
if /i "%OPTION1%" EQU "NUS" echo               * Useful for offline usage of Wii Apps like d2x\Hermes cIOS Installers

if /i "%OPTION1%" EQU "ALL" echo           1 = Keep NUS\00000001000000##v# and 00000001 Folder for IOSs\MIOSs\SMs etc
if /i "%OPTION1%" EQU "ALL" echo               * Useful for offline usage of a handful of Wii Apps
echo.

if /i "%ACTIVEIOS%" EQU "OFF" echo           U = Update IOSs. Wizard/sysCheck-Updater to update Active IOSs (Disabled)
if /i "%ACTIVEIOS%" EQU "ON" echo           U = Update IOSs. Wizard/sysCheck-Updater to update Active IOSs (Enabled)
echo.

if /i "%ACTIVEIOS%" EQU "OFF" goto:skip36
if /i "%OPTION36%" EQU "OFF" echo          36 = Install IOS36 when updating all Active IOS Downloads (Disabled)
if /i "%OPTION36%" EQU "ON" echo          36 = Install IOS36 when updating all Active IOS Downloads (Enabled)
echo               * Your existing IOS36 may be patched. The downloaded IOS36 is not
echo.
:skip36

if /i "%CMIOSOPTION%" EQU "OFF" echo          CM = cMIOS included in ModMii Wizard Guides (Disabled)
if /i "%CMIOSOPTION%" EQU "ON" echo          CM = cMIOS included in ModMii Wizard Guides (Enabled)
echo               * A cMIOS allows older non-chipped Wii's to play GameCube backup discs
echo.

if /i "%FWDOPTION%" EQU "OFF" echo         FWD = Install USB-Loader Forwarder in ModMii Wizard Guides (Disabled)
if /i "%FWDOPTION%" EQU "ON" echo         FWD = Install USB-Loader Forwarder in ModMii Wizard Guides (Enabled)
echo.

if /i "%AudioOption%" EQU "OFF" echo          SO = Play sound at at Finish (Disabled)
if /i "%AudioOption%" EQU "ON" echo          SO = Play sound at at Finish (Enabled)
echo.

if /i "%ModMiiverbose%" EQU "off" echo           V = Verbose Output maximized when using wget or Sneek Installer (Disabled)
if /i "%ModMiiverbose%" EQU "on" echo           V = Verbose Output maximized when using wget or Sneek Installer (Enabled)
echo.


if /i "%neek2o%" EQU "off" echo         n2o = neek2o - build mod of s\uneek instead of original (Disabled)
if /i "%neek2o%" EQU "on" echo         n2o = neek2o - build mod of s\uneek instead of original (Enabled)
echo.


if /i "%SSD%" EQU "off" echo         SSD = SNEEK and SNEEK+DI SD Access (Disabled)
if /i "%SSD%" EQU "on" echo         SSD = SNEEK and SNEEK+DI SD Access (Enabled)
echo.

if /i "%sneekverbose%" EQU "off" echo          SV = SNEEK Verbose Output (Disabled)
if /i "%sneekverbose%" EQU "on" echo          SV = SNEEK Verbose Output (Enabled)
echo.

if /i "%SNKFONT%" EQU "W" echo           F = Font.bin Colour for SNEEK+DI/UNEEK+DI (WHITE)
if /i "%SNKFONT%" EQU "B" echo           F = Font.bin Colour for SNEEK+DI/UNEEK+DI (BLACK)
echo.

if not exist "%DRIVE%" goto:nodrivefolder
echo           C = Create Custom.md5 file to verify all files in %DRIVE%
if exist Custom.md5 echo          C2 = Verify files in %DRIVE% against Custom.md5
:nodrivefolder
if exist Custom.md5 echo          C3 = Delete Custom.md5
echo.
if /i "%AUTOUPDATE%" EQU "OFF" echo           A = Auto-Update ModMii at program start (Disabled)
if /i "%AUTOUPDATE%" EQU "ON" echo           A = Auto-Update ModMii at program start (Enabled)
::echo.
echo           N = Check for New versions of ModMii right now
echo.
echo       S = Save Settings       R = Restore Default Settings       M = Main Menu
echo.
set /p OPTIONS=     Enter Selection Here: 


if /i "%OPTIONS%" EQU "RS" goto:ROOTSAVE
if /i "%OPTIONS%" EQU "PC" goto:PCSAVE
if /i "%OPTIONS%" EQU "1" goto:Option1
::if /i "%OPTIONS%" EQU "CE" goto:OptionCE
if /i "%OPTIONS%" EQU "N" goto:UpdateModMii
if /i "%OPTIONS%" EQU "A" goto:AutoUpdate
if /i "%OPTIONS%" EQU "36" goto:Option36
if /i "%OPTIONS%" EQU "SO" goto:AudioOption
if /i "%OPTIONS%" EQU "CM" goto:CMIOSOPTION
if /i "%OPTIONS%" EQU "FWD" goto:FWDOPTION
if /i "%OPTIONS%" EQU "sv" goto:OptionSneekverbose
if /i "%OPTIONS%" EQU "n2o" goto:Optionneek2o
if /i "%OPTIONS%" EQU "v" goto:OptionModMiiverbose
if /i "%OPTIONS%" EQU "SSD" goto:OptionSSD

if /i "%OPTIONS%" EQU "f" goto:Optionfont

if not exist "%DRIVE%" goto:nodrivefolder2
if /i "%OPTIONS%" EQU "C" echo ;;%DRIVE%>Custom.md5
::if /i "%OPTIONS%" EQU "C" support\sfk list "%DRIVE%" wad dol app elf +md5gento="%DRIVE%"\Custom.md5
if /i "%OPTIONS%" EQU "C" support\fvc -c -a MD5 -r "%DRIVE%"\*.*>>Custom.md5
if /i "%OPTIONS%" EQU "C" support\sfk filter Custom.md5 -unique -write -yes>nul
if /i "%OPTIONS%" EQU "C" goto:Options

if not exist Custom.md5 goto:nocustomMD5
if /i "%OPTIONS%" NEQ "C2" goto:nodrivefolder2
support\sfk filter custom.md5 -ls+;; -rep _";;"__ >temp\customMD5path.txt
support\sfk filter -spat temp\customMD5path.txt -rep _\x5f_?_ -write -yes>nul
set /p customdrive= <temp\customMD5path.txt
del temp\customMD5path.txt>nul

echo %drive% >temp\newMD5path.txt
support\sfk filter -spat temp\newMD5path.txt -rep _\x5f_?_ -write -yes>nul
set /p newdrive= <temp\newMD5path.txt
set newdrive=%newdrive:~0,-1%
del temp\newMD5path.txt>nul
support\sfk filter -spat custom.md5 -rep _\x5f_?_ -write -yes>nul
support\sfk filter custom.md5 -rep _"%customdrive%"_"%newDRIVE%"_ -write -yes>nul
support\sfk filter -spat custom.md5 -rep _\x3f_\x5f_ -write -yes>nul
Set DB=C
goto:Finish
:nodrivefolder2

if not exist Custom.md5 goto:nocustomMD5
if /i "%OPTIONS%" EQU "C3" del Custom.md5>nul
if /i "%OPTIONS%" EQU "C3" goto:Options
:nocustomMD5

if /i "%OPTIONS%" EQU "D" set BACKB4DRIVE=OPTIONS
if /i "%OPTIONS%" EQU "D" goto:DRIVECHANGE
if /i "%OPTIONS%" EQU "DU" set BACKB4DRIVEU=OPTIONS
if /i "%OPTIONS%" EQU "DU" goto:DRIVEUCHANGE
if /i "%OPTIONS%" EQU "CC" goto:cheatcodeoptions

if /i "%OPTIONS%" EQU "U" goto:ACTIVEIOS
if /i "%OPTIONS%" EQU "S" goto:SaveSettings
if /i "%OPTIONS%" EQU "R" goto:RestoreSettings
if /i "%OPTIONS%" EQU "M" goto:MENU


echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:OPTIONS








:RestoreSettings
set ROOTSAVE=off
set effect=No-Spin
set PCSAVE=Auto
set OPTION1=off
set OPTION36=on
set AudioOption=on
set CMIOSOPTION=off
set FWDOPTION=on
set Drive=COPY_TO_SD
set DriveU=COPY_TO_USB
set ACTIVEIOS=on
set AUTOUPDATE=on
Set ModMiiverbose=off
Set SSD=off
Set sneekverbose=off
Set neek2o=on
Set SNKFONT=B

:defaultcheatsettings
set overwritecodes=off
set cheatregion=All
set cheatlocation=B

:selectallcheats
set wiicheat=ON
set WiiWarecheat=ON
set VCArcadecheat=OFF
set WiiChannelscheat=ON
set Gamecubecheat=ON
set NEScheat=ON
set SNEScheat=ON
set N64cheat=ON
set SMScheat=ON
set Segacheat=ON
set NeoGeocheat=ON
set Commodorecheat=ON
set MSXcheat=ON
set TurboGraFX-16cheat=ON
set TurboGraFX-CDcheat=ON
if /i "%cheatoption%" EQU "A" goto:cheatcodeoptions
if /i "%cheatoption%" EQU "D" goto:cheatcodeoptions
goto:savesettingsnow




:SaveSettings
cls
echo                                        ModMii                                v%currentversion%
echo                                       by XFlak
echo.
:savesettingsnow
echo ::ModMii Settings > Support\settings.bat
echo ::ModMiiv%currentversion%>> Support\settings.bat
echo Set ROOTSAVE=%ROOTSAVE%>> Support\settings.bat
echo Set effect=%effect%>> Support\settings.bat
echo Set PCSAVE=%PCSAVE%>> Support\settings.bat
echo Set Option1=%Option1%>> Support\settings.bat
echo Set OPTION36=%OPTION36%>> Support\settings.bat
echo Set AudioOption=%AudioOption%>> Support\settings.bat
echo Set CMIOSOPTION=%CMIOSOPTION%>> Support\settings.bat
echo Set FWDOPTION=%FWDOPTION%>> Support\settings.bat
echo Set Drive=%DRIVE%>> Support\settings.bat
echo Set DriveU=%DRIVEU%>> Support\settings.bat
echo Set overwritecodes=%overwritecodes%>> Support\settings.bat
echo Set cheatregion=%cheatregion%>> Support\settings.bat
echo Set cheatlocation=%cheatlocation%>> Support\settings.bat
echo Set ACTIVEIOS=%ACTIVEIOS%>> Support\settings.bat
echo Set AUTOUPDATE=%AUTOUPDATE%>> Support\settings.bat
echo Set ModMiiverbose=%ModMiiverbose%>> Support\settings.bat
echo Set SSD=%SSD%>> Support\settings.bat
echo Set sneekverbose=%sneekverbose%>> Support\settings.bat
echo Set neek2o=%neek2o%>> Support\settings.bat
echo Set SNKFONT=%SNKFONT%>> Support\settings.bat
echo Set wiicheat=%wiicheat%>> Support\settings.bat
echo Set WiiWarecheat=%WiiWarecheat%>> Support\settings.bat
echo Set VCArcadecheat=%VCArcadecheat%>> Support\settings.bat
echo Set WiiChannelscheat=%WiiChannelscheat%>> Support\settings.bat
echo Set Gamecubecheat=%Gamecubecheat%>> Support\settings.bat
echo Set NEScheat=%NEScheat%>> Support\settings.bat
echo Set SNEScheat=%SNEScheat%>> Support\settings.bat
echo Set N64cheat=%N64cheat%>> Support\settings.bat
echo Set SMScheat=%SMScheat%>> Support\settings.bat
echo Set Segacheat=%Segacheat%>> Support\settings.bat
echo Set NeoGeocheat=%NeoGeocheat%>> Support\settings.bat
echo Set Commodorecheat=%Commodorecheat%>> Support\settings.bat
echo Set MSXcheat=%MSXcheat%>> Support\settings.bat
echo Set TurboGraFX-16cheat=%TurboGraFX-16cheat%>> Support\settings.bat
echo Set TurboGraFX-CDcheat=%TurboGraFX-CDcheat%>> Support\settings.bat
echo set AGREEDVERSION=%currentversion%>> Support\settings.bat
if /i "%OPTIONS%" EQU "R" goto:OPTIONS
if exist Support\settings.bat echo                                     Settings Saved.
echo.
@ping 127.0.0.1 -n 2 -w 1000> nul
if /i "%cheatoption%" EQU "S" goto:cheatcodeoptions
goto:OPTIONS






:ROOTSAVE
if /i "%ROOTSAVE%" EQU "ON" goto:ROOTSAVEoff
Set ROOTSAVE=ON
goto:OPTIONS

:ROOTSAVEoff
Set ROOTSAVE=OFF
goto:OPTIONS



:PCSAVE
if /i "%PCSAVE%" EQU "Auto" (set PCSAVE=Portable) & (goto:options)
if /i "%PCSAVE%" EQU "Portable" (set PCSAVE=Local) & (goto:options)
if /i "%PCSAVE%" EQU "Local" (set PCSAVE=Auto) & (goto:options)

:Option1
if /i "%OPTION1%" EQU "off" (set OPTION1=on) & (goto:options)
if /i "%OPTION1%" EQU "on" (set OPTION1=nus) & (goto:options)
if /i "%OPTION1%" EQU "nus" (set OPTION1=all) & (goto:options)
if /i "%OPTION1%" EQU "all" (set OPTION1=off) & (goto:options)

:OptionCE
if /i "%effect%" EQU "no-spin" (set effect=Spin) & (goto:options)
if /i "%effect%" EQU "spin" (set effect=Fast-Spin) & (goto:options)
if /i "%effect%" EQU "fast-spin" (set effect=No-Spin) & (goto:options)

:OPTION36
if /i "%OPTION36%" EQU "ON" goto:OPTION36off
Set OPTION36=ON
goto:OPTIONS

:OPTION36off
Set OPTION36=OFF
goto:OPTIONS


:AudioOption
if /i "%AudioOption%" EQU "ON" (set AudioOption=OFF) else (set AudioOption=ON)
goto:options


:CMIOSOPTION
if /i "%CMIOSOPTION%" EQU "ON" goto:CMIOSOPTIONoff
Set CMIOSOPTION=ON
goto:OPTIONS

:CMIOSOPTIONoff
Set CMIOSOPTION=OFF
goto:OPTIONS

:FWDOPTION
if /i "%FWDOPTION%" EQU "ON" goto:FWDOPTIONoff
Set FWDOPTION=ON
goto:OPTIONS

:FWDOPTIONoff
Set FWDOPTION=OFF
goto:OPTIONS

:OptionSneekverbose
if /i "%sneekverbose%" EQU "on" goto:OptionSneekverboseoff
Set sneekverbose=on
goto:OPTIONS

:OptionSneekverboseoff
Set sneekverbose=off
goto:OPTIONS

:Optionneek2o
if /i "%neek2o%" EQU "on" goto:Optionneek2ooff
Set neek2o=on
goto:OPTIONS

:Optionneek2ooff
Set neek2o=off
goto:OPTIONS

:OptionModMiiverbose
if /i "%ModMiiverbose%" EQU "on" goto:OptionModMiiverboseoff
Set ModMiiverbose=on
goto:OPTIONS

:OptionModMiiverboseoff
Set ModMiiverbose=off
goto:OPTIONS


:OptionSSD
if /i "%SSD%" EQU "on" goto:OptionSSDoff
Set SSD=on
goto:OPTIONS

:OptionSSDoff
Set SSD=off
goto:OPTIONS


:Optionfont
if /i "%SNKFONT%" EQU "W" goto:OptionfontB
Set SNKFONT=W
goto:OPTIONS

:OptionfontB
Set SNKFONT=B
goto:OPTIONS

:ACTIVEIOS
if /i "%ACTIVEIOS%" EQU "ON" goto:ACTIVEIOSoff
Set ACTIVEIOS=ON
goto:OPTIONS

:ACTIVEIOSoff
Set ACTIVEIOS=OFF
goto:OPTIONS

:AUTOUPDATE
if /i "%AUTOUPDATE%" EQU "ON" goto:AUTOUPDATEoff
Set AUTOUPDATE=ON
goto:OPTIONS

:AUTOUPDATEoff
Set AUTOUPDATE=OFF
goto:OPTIONS





:cheatcodeoptions
set cheatoption=
cls
echo                                        ModMii                                v%currentversion%
echo                                       by XFlak
echo.
echo.
echo                                  CHEAT CODE OPTIONS
echo.
echo.
echo           R = Region to download cheats for: (%cheatregion%)
echo.
if /i "%overwritecodes%" EQU "OFF" echo           O = Overwrite existing txtcodes (Disabled)
if /i "%overwritecodes%" EQU "ON" echo           O = Overwrite existing txtcodes (Enabled)
echo.
if /i "%cheatlocation%" EQU "B" echo           L = Location(s) to save cheats: (Both 1 and 2)
if /i "%cheatlocation%" EQU "T" echo           L = Location(s) to save cheats: (1: txtcodes)
if /i "%cheatlocation%" EQU "C" echo           L = Location(s) to save cheats: (2: codes\X\L)
echo               1: - txtcodes: location used by most apps, including CFG USB-Loader
echo               2: - codes\X\L\: location used by Accio Hacks
echo                        X = Console ID Letter (ie. Wii = R)
echo                        L = 1st letter of game title ('#' if it starts with a number)
echo.
echo.
echo                   Select or deselect consoles to download cheats for:
echo.
support\sfk echo -spat \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 Selected consoles are marked in [Green]Green
echo.
echo.
if /i "%wiicheat%" EQU "ON" (support\sfk echo -spat \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 [Green]1 = Wii) else (echo                 1 = Wii)
if /i "%WiiWarecheat%" EQU "ON" (support\sfk echo -spat \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 [Green]2 = WiiWare) else (echo                 2 = WiiWare)

::if /i "%VCArcadecheat%" EQU "ON" (support\sfk echo -spat \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 [Green]3 = VC Arcade)  else (echo                 3 = VC Arcade)
support\sfk echo -spat \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 [Red]3 = VC Arcade (Disabled due to geckocodes.org error)

if /i "%WiiChannelscheat%" EQU "ON" (support\sfk echo -spat \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 [Green]4 = Wii Channels)  else (echo                 4 = Wii Channels)
if /i "%Gamecubecheat%" EQU "ON" (support\sfk echo -spat \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 [Green]5 = Gamecube)  else (echo                 5 = Gamecube)
if /i "%NEScheat%" EQU "ON" (support\sfk echo -spat \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 [Green]6 = NES/Famicom VC)  else (echo                 6 = NES/Famicom VC)
if /i "%SNEScheat%" EQU "ON" (support\sfk echo -spat \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 [Green]7 = Super NES/Famicom VC)  else (echo                 7 = Super NES/Famicom VC)
if /i "%N64cheat%" EQU "ON" (support\sfk echo -spat \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 [Green]8 = Nintendo 64 VC)  else (echo                 8 = Nintendo 64 VC)
if /i "%SMScheat%" EQU "ON" (support\sfk echo -spat \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 [Green]9 = Sega Master System VC)  else (echo                 9 = Sega Master System VC)
if /i "%Segacheat%" EQU "ON" (support\sfk echo -spat \x20 \x20 \x20 \x20 \x20 \x20 \x20 [Green] 10 = Sega Genesis/Mega Drive VC)  else (echo                10 = Sega Genesis/Mega Drive VC)
if /i "%NeoGeocheat%" EQU "ON" (support\sfk echo -spat \x20 \x20 \x20 \x20 \x20 \x20 \x20 [Green] 11 = NeoGeo VC)  else (echo                11 = NeoGeo VC)
if /i "%Commodorecheat%" EQU "ON" (support\sfk echo -spat \x20 \x20 \x20 \x20 \x20 \x20 \x20 [Green] 12 = Commodore 64 VC)  else (echo                12 = Commodore 64 VC)
if /i "%MSXcheat%" EQU "ON" (support\sfk echo -spat \x20 \x20 \x20 \x20 \x20 \x20 \x20 [Green] 13 = MSX VC)  else (echo                13 = MSX VC)
if /i "%TurboGraFX-16cheat%" EQU "ON" (support\sfk echo -spat \x20 \x20 \x20 \x20 \x20 \x20 \x20 [Green] 14 = TurboGraFX-16 VC)  else (echo                14 = TurboGraFX-16 VC)
if /i "%TurboGraFX-CDcheat%" EQU "ON" (support\sfk echo -spat \x20 \x20 \x20 \x20 \x20 \x20 \x20 [Green] 15 = TurboGraFX-CD VC)  else (echo                15 = TurboGraFX-CD VC)
echo.
echo.
echo                 A = All
echo                 C = Clear
echo.
echo                 S = Save Settings
echo                 D = Default Cheat Settings
echo.
echo                 B = Back
echo                 M = Main Menu
echo.
echo.
echo.
set /p cheatoption=     Enter Selection Here: 



if /i "%cheatoption%" EQU "1" goto:wiicheat
if /i "%cheatoption%" EQU "2" goto:WiiWarecheat
::if /i "%cheatoption%" EQU "3" goto:VCArcadecheat
if /i "%cheatoption%" EQU "4" goto:WiiChannelscheat
if /i "%cheatoption%" EQU "5" goto:Gamecubecheat
if /i "%cheatoption%" EQU "6" goto:NEScheat
if /i "%cheatoption%" EQU "7" goto:SNEScheat
if /i "%cheatoption%" EQU "8" goto:N64cheat
if /i "%cheatoption%" EQU "9" goto:SMScheat
if /i "%cheatoption%" EQU "10" goto:Segacheat
if /i "%cheatoption%" EQU "11" goto:NeoGeocheat
if /i "%cheatoption%" EQU "12" goto:Commodorecheat
if /i "%cheatoption%" EQU "13" goto:MSXcheat
if /i "%cheatoption%" EQU "14" goto:TurboGraFX-16cheat
if /i "%cheatoption%" EQU "15" goto:TurboGraFX-CDcheat
if /i "%cheatoption%" EQU "A" goto:selectallcheats
if /i "%cheatoption%" EQU "C" goto:deselectallcheats
if /i "%cheatoption%" EQU "R" goto:cheatregion
if /i "%cheatoption%" EQU "l" goto:cheatlocation
if /i "%cheatoption%" EQU "O" goto:overwritecodes
if /i "%cheatoption%" EQU "B" goto:countconsoles
if /i "%cheatoption%" EQU "M" goto:countconsoles

if /i "%cheatoption%" EQU "S" goto:SaveSettings
if /i "%cheatoption%" EQU "D" goto:defaultcheatsettings


echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:cheatcodeoptions

:countconsoles
set countconsoles=0
if /i "%wiicheat%" EQU "ON" SET /a countconsoles=%countconsoles%+1
if /i "%WiiWarecheat%" EQU "ON" SET /a countconsoles=%countconsoles%+1
if /i "%VCArcadecheat%" EQU "ON" SET /a countconsoles=%countconsoles%+1
if /i "%WiiChannelscheat%" EQU "ON" SET /a countconsoles=%countconsoles%+1
if /i "%Gamecubecheat%" EQU "ON" SET /a countconsoles=%countconsoles%+1
if /i "%NEScheat%" EQU "ON" SET /a countconsoles=%countconsoles%+1
if /i "%SNEScheat%" EQU "ON" SET /a countconsoles=%countconsoles%+1
if /i "%N64cheat%" EQU "ON" SET /a countconsoles=%countconsoles%+1
if /i "%SMScheat%" EQU "ON" SET /a countconsoles=%countconsoles%+1
if /i "%Segacheat%" EQU "ON" SET /a countconsoles=%countconsoles%+1
if /i "%NeoGeocheat%" EQU "ON" SET /a countconsoles=%countconsoles%+1
if /i "%Commodorecheat%" EQU "ON" SET /a countconsoles=%countconsoles%+1
if /i "%MSXcheat%" EQU "ON" SET /a countconsoles=%countconsoles%+1
if /i "%TurboGraFX-16cheat%" EQU "ON" SET /a countconsoles=%countconsoles%+1
if /i "%TurboGraFX-CDcheat%" EQU "ON" SET /a countconsoles=%countconsoles%+1

if /i "%countconsoles%" EQU "0" echo Select at least one console to download cheats for
if /i "%countconsoles%" EQU "0" @ping 127.0.0.1 -n 3 -w 1000> nul
if /i "%countconsoles%" EQU "0" goto:cheatcodeoptions

if /i "%cheatoption%" EQU "B" goto:Options
if /i "%cheatoption%" EQU "M" goto:MENU



:overwritecodes
if /i "%overwritecodes%" EQU "ON" goto:overwritecodesoff
Set overwritecodes=ON
goto:cheatcodeoptions

:overwritecodesoff
Set overwritecodes=OFF
goto:cheatcodeoptions


:cheatregion
if /i "%cheatregion%" EQU "all" Set cheatregion=USA&&goto:cheatcodeoptions
if /i "%cheatregion%" EQU "USA" Set cheatregion=PAL&&goto:cheatcodeoptions
if /i "%cheatregion%" EQU "PAL" Set cheatregion=JAP&&goto:cheatcodeoptions
if /i "%cheatregion%" EQU "JAP" Set cheatregion=all&&goto:cheatcodeoptions


:cheatlocation
if /i "%cheatlocation%" EQU "B" Set cheatlocation=T&&goto:cheatcodeoptions
if /i "%cheatlocation%" EQU "T" Set cheatlocation=C&&goto:cheatcodeoptions
if /i "%cheatlocation%" EQU "C" Set cheatlocation=B&&goto:cheatcodeoptions




:wiicheat
if /i "%wiicheat%" EQU "OFF" (set wiicheat=ON) else (set wiicheat=OFF)
goto:cheatcodeoptions


:WiiWarecheat
if /i "%WiiWarecheat%" EQU "OFF" (set WiiWarecheat=ON) else (set WiiWarecheat=OFF)
goto:cheatcodeoptions

:VCArcadecheat
if /i "%VCArcadecheat%" EQU "OFF" (set VCArcadecheat=ON) else (set VCArcadecheat=OFF)
goto:cheatcodeoptions

:WiiChannelscheat
if /i "%WiiChannelscheat%" EQU "OFF" (set WiiChannelscheat=ON) else (set WiiChannelscheat=OFF)
goto:cheatcodeoptions

:Gamecubecheat
if /i "%Gamecubecheat%" EQU "OFF" (set Gamecubecheat=ON) else (set Gamecubecheat=OFF)
goto:cheatcodeoptions

:NEScheat
if /i "%NEScheat%" EQU "OFF" (set NEScheat=ON) else (set NEScheat=OFF)
goto:cheatcodeoptions

:SNEScheat
if /i "%SNEScheat%" EQU "OFF" (set SNEScheat=ON) else (set SNEScheat=OFF)
goto:cheatcodeoptions

:N64cheat
if /i "%N64cheat%" EQU "OFF" (set N64cheat=ON) else (set N64cheat=OFF)
goto:cheatcodeoptions

:SMScheat
if /i "%SMScheat%" EQU "OFF" (set SMScheat=ON) else (set SMScheat=OFF)
goto:cheatcodeoptions

:Segacheat
if /i "%Segacheat%" EQU "OFF" (set Segacheat=ON) else (set Segacheat=OFF)
goto:cheatcodeoptions

:NeoGeocheat
if /i "%NeoGeocheat%" EQU "OFF" (set NeoGeocheat=ON) else (set NeoGeocheat=OFF)
goto:cheatcodeoptions

:Commodorecheat
if /i "%Commodorecheat%" EQU "OFF" (set Commodorecheat=ON) else (set Commodorecheat=OFF)
goto:cheatcodeoptions

:MSXcheat
if /i "%MSXcheat%" EQU "OFF" (set MSXcheat=ON) else (set MSXcheat=OFF)
goto:cheatcodeoptions

:TurboGraFX-16cheat
if /i "%TurboGraFX-16cheat%" EQU "OFF" (set TurboGraFX-16cheat=ON) else (set TurboGraFX-16cheat=OFF)
goto:cheatcodeoptions

:TurboGraFX-CDcheat
if /i "%TurboGraFX-CDcheat%" EQU "OFF" (set TurboGraFX-CDcheat=ON) else (set TurboGraFX-CDcheat=OFF)
goto:cheatcodeoptions

:deselectallcheats
set wiicheat=OFF
set WiiWarecheat=OFF
set VCArcadecheat=OFF
set WiiChannelscheat=OFF
set Gamecubecheat=OFF
set NEScheat=OFF
set SNEScheat=OFF
set N64cheat=OFF
set SMScheat=OFF
set Segacheat=OFF
set NeoGeocheat=OFF
set Commodorecheat=OFF
set MSXcheat=OFF
set TurboGraFX-16cheat=OFF
set TurboGraFX-CDcheat=OFF
goto:cheatcodeoptions



:DRIVECHANGE
set drivetemp=%DRIVE%
cls
echo                                        ModMii                                v%currentversion%
echo                                       by XFlak
echo.
echo.
echo.
echo         Enter the drive letter (or Path) to save files for your SD Card
echo.
echo.
echo             Current Setting:   %Drive%
echo.
echo.
echo         Notes: * To continue using Current Settings
echo                  leave the selection blank and hit enter.
echo.
echo                * You can drag and drop the Drive/folder into this
echo                  window to save yourself having to manually type it
echo.
echo                * If you continue to experience errors, try using default settings
echo.
echo.
echo.
echo         EXAMPLES
echo.
echo.
echo            L:
echo.
echo            %%userprofile%%\Desktop\COPY_TO_SD
echo                  Note: %%userprofile%% shortcut doesn't work on Windows XP
echo.
echo            ModMii\4.2U
echo                  Note: this creates ModMii\4.2U folders where this program is Saved
echo.
echo            C:\Users\XFlak\Desktop\New Folder
echo.
echo.
echo.
echo         D = Default Setting: COPY_TO_SD
echo.
echo.
echo         B = Back
echo.
echo         M = Main Menu
echo.
echo.
set /p Drivetemp=     Enter Selection Here: 

::remove quotes from variable (if applicable)
echo "set DRIVETEMP=%DRIVETEMP%">temp\temp.txt
support\sfk filter -quiet temp\temp.txt -rep _""""__>temp\temp.bat
call temp\temp.bat
del temp\temp.bat>nul
del temp\temp.txt>nul



if /i "%DRIVETEMP%" EQU "M" goto:MENU
if /i "%DRIVETEMP%" EQU "B" goto:%BACKB4DRIVE%
if /i "%DRIVETEMP%" EQU "D" set DRIVETEMP=COPY_TO_SD


:doublecheck
set fixslash=
if /i "%DRIVETEMP:~-1%" EQU "\" set fixslash=yes
if /i "%DRIVETEMP:~-1%" EQU "/" set fixslash=yes
if /i "%fixslash%" EQU "yes" set DRIVETEMP=%DRIVETEMP:~0,-1%
if /i "%fixslash%" EQU "yes" goto:doublecheck


::if second char is ":" check if drive exists
if /i "%DRIVETEMP:~1,1%" NEQ ":" goto:skipcheck
if exist "%DRIVETEMP:~0,2%" (goto:skipcheck) else (echo.)
echo %DRIVETEMP:~0,2% doesn't exist, please try again...
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:DRIVECHANGE
:skipcheck


set DRIVE=%DRIVETEMP%
set REALDRIVE=%DRIVE%


::autosave drive setting to settings.bat
support\sfk filter Support\settings.bat -!"Set Drive=" -write -yes>nul
echo Set Drive=%DRIVE%>>Support\settings.bat

if /i "%MENU1%" EQU "FC" goto:FileCleanup
if /i "%MENU1%" EQU "U" set BACKB4QUEUE=DRIVECHANGE
if /i "%MENU1%" EQU "U" goto:DOWNLOADQUEUE


if /i "%MENU1%" NEQ "W" goto:skip
if /i "%USBCONFIG%" EQU "USB" (set BACKB4QUEUE=DRIVEUCHANGE) else (set BACKB4QUEUE=DRIVECHANGE)
if /i "%USBCONFIG%" EQU "USB" (goto:DRIVEUCHANGE) else (goto:download)
:skip

::if /i "%AbstinenceWiz%" EQU "Y" (set B4SNKPAGE3=DRIVECHANGE) & (goto:snkpage3)

if /i "%MENU1%" EQU "RC" (set BACKB4QUEUE=DRIVECHANGE) & (goto:download)

if /i "%SNEEKTYPE%" EQU "U" (set BACKB4DRIVEU=DRIVECHANGE) & (goto:DRIVEUCHANGE)

if /i "%SNEEKTYPE%" EQU "UD" (set BACKB4DRIVEU=DRIVECHANGE) & (goto:DRIVEUCHANGE)

if /i "%SNEEKSELECT%" EQU "2" (set B4SNKPAGE3=DRIVECHANGE) & (goto:snkpage3)

if /i "%SNEEKSELECT%" EQU "3" (set B4SNKPAGE3=DRIVECHANGE) & (goto:snkpage3)

if /i "%SNEEKSELECT%" EQU "1" (set B4SNKCONFIRM=DRIVECHANGE) & (goto:SNKNANDCONFIRM)

if /i "%MENU1%" EQU "O" goto:Options

goto:%BACKB4DRIVE%







:DRIVEUCHANGE
set driveUtemp=%DRIVEU%
cls
echo                                        ModMii                                v%currentversion%
echo                                       by XFlak
echo.
echo.
echo.
echo         Enter the drive letter (or Path) to save files for your USB Hard Drive
echo.
echo.
echo             Current Setting:   %DriveU%
echo.
echo.
echo         Notes: * To continue using Current Settings
echo                  leave the selection blank and hit enter.
echo.
echo                * You can drag and drop the Drive/folder into this
echo                  window to save yourself having to manually type it
echo.
echo                * If you continue to experience errors, try using default settings
echo.
echo.
echo.
echo         EXAMPLES
echo.
echo.
echo            L:
echo.
echo            %%userprofile%%\Desktop\COPY_TO_USB
echo                  Note: %%userprofile%% shortcut doesn't work on Windows XP
echo.
echo            ModMii\4.2U
echo                  Note: this creates ModMii\4.2U folders where this program is Saved
echo.
echo            C:\Users\XFlak\Desktop\New Folder
echo.
echo.
echo.
echo         D = Default Setting: COPY_TO_USB
echo.
echo.
echo         B = Back
echo.
echo         M = Main Menu
echo.
echo.
set /p DriveUtemp=     Enter Selection Here: 


::remove quotes from variable (if applicable)
echo "set DRIVEUTEMP=%DRIVEUTEMP%">temp\temp.txt
support\sfk filter -quiet temp\temp.txt -rep _""""__>temp\temp.bat
call temp\temp.bat
del temp\temp.bat>nul
del temp\temp.txt>nul


if /i "%DRIVEUTEMP%" EQU "M" goto:MENU

if /i "%DRIVEUTEMP%" EQU "B" goto:%BACKB4DRIVEU%

if /i "%DRIVEUTEMP%" EQU "D" set DRIVEUTEMP=COPY_TO_USB

:doublecheckU
set fixslash=
if /i "%DRIVEUTEMP:~-1%" EQU "\" set fixslash=yes
if /i "%DRIVEUTEMP:~-1%" EQU "/" set fixslash=yes
if /i "%fixslash%" EQU "yes" set DRIVEUTEMP=%DRIVEUTEMP:~0,-1%
if /i "%fixslash%" EQU "yes" goto:doublecheckU



::if second char is ":" check if drive exists
if /i "%DRIVEUTEMP:~1,1%" NEQ ":" goto:skipcheck
if exist "%DRIVEUTEMP:~0,2%" (goto:skipcheck) else (echo.)
echo %DRIVEUTEMP:~0,2% doesn't exist, please try again...
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:DRIVEUCHANGE
:skipcheck



set DRIVEU=%DRIVEUTEMP%

::autosave drive setting to settings.bat
support\sfk filter Support\settings.bat -!"Set DriveU=" -write -yes>nul
echo Set DriveU=%DRIVEU%>>Support\settings.bat

if /i "%AbstinenceWiz%" EQU "Y" (set B4SNKPAGE3=DRIVEUCHANGE) & (goto:snkpage3)

if /i "%SNEEKSELECT%" EQU "1" set B4SNKCONFIRM=DRIVEUCHANGE
if /i "%SNEEKSELECT%" EQU "1" goto:SNKNANDCONFIRM
if /i "%SNEEKSELECT%" EQU "2" set B4SNKPAGE3=DRIVEUCHANGE
if /i "%SNEEKSELECT%" EQU "3" set B4SNKPAGE3=DRIVEUCHANGE
if /i "%SNEEKSELECT%" EQU "2" goto:snkpage3
if /i "%SNEEKSELECT%" EQU "3" goto:snkpage3
if /i "%SNEEKSELECT%" EQU "4" goto:SNKDISCEX2

::if /i "%MENU1%" EQU "U" goto:DOWNLOADQUEUE
::if /i "%WLAST%" EQU "Y" goto:DOWNLOAD


if /i "%MENU1%" NEQ "U" goto:skip
if /i "%USBCONFIG%" EQU "USB" set DRIVE=%DRIVEU%
if /i "%USBCONFIG%" EQU "USB" set BACKB4QUEUE=DRIVEUCHANGE
if /i "%USBCONFIG%" EQU "USB" goto:DownloadQueue
:skip
if /i "%USBCONFIG%" EQU "USB" set BACKB4QUEUE=DRIVEUCHANGE
if /i "%USBCONFIG%" EQU "USB" goto:Download

goto:Options







:UpdateModMii

if exist "ModMiiSkin.bat@format=raw" del "ModMiiSkin.bat@format=raw">nul

cls
echo                                        ModMii                                v%currentversion%
echo                                       by XFlak
echo.
echo.
echo                                Current Version is %CurrentVersion%
echo.
echo                                 Checking for updates...
echo.

start %ModMiimin%/wait support\wget --no-check-certificate -N "https://sourceforge.net/p/modmii/code/HEAD/tree/trunk/ModMii English/ModMiiSkin.bat?format=raw"

if exist "ModMiiSkin.bat@format=raw" (move /y "ModMiiSkin.bat@format=raw" temp\list.txt>nul) else (goto:updatefail)

support\sfk filter -quiet "temp\list.txt" ++"set currentversion=" -rep _"set currentversion="__ -write -yes

set /p newversion= <temp\list.txt

del temp\list.txt>nul


if /i "%MENU1%" EQU "O" goto:skip

if %currentversion% GTR %newversion% (echo                  This version is newer than the latest public release) & (echo.) & (echo                           You got some crazy new beta shit!) & (@ping 127.0.0.1 -n 4 -w 1000> nul) & (goto:menu)

if %currentversion% EQU %newversion% (echo                              This version is up to date) & (@ping 127.0.0.1 -n 4 -w 1000> nul) & (goto:menu)

:skip
if %currentversion% GTR %newversion% (echo                  This version is newer than the latest public release) & (echo.) & (echo                           You got some crazy new beta shit!) & (@ping 127.0.0.1 -n 4 -w 1000> nul) & (goto:OPTIONS)

if %currentversion% EQU %newversion% (echo                              This version is up to date) & (@ping 127.0.0.1 -n 4 -w 1000> nul) & (goto:OPTIONS)


::openchangelog
start http://modmii.comuf.com/changelog.html


:updateconfirm
set updatenow=

cls
echo                                        ModMii                                v%currentversion%
echo                                       by XFlak
echo.
echo.
echo.
echo.
support\sfk echo -spat \x20 \x20 \x20 \x20 \x20 [Red] An Update is available, would you like to update to v%newversion% now?
echo.
echo.
echo.
echo    It is recommended you read the changelog that just opened in your browser.
echo.
echo.
echo.
support\sfk echo -spat \x20 \x20 \x20 \x20 \x20 \x20 \x20 [Green] Y = Yes - Perform Update Now! (RECOMMENDED)
echo.
echo                N = No, do not update
echo.
echo.
echo.
set /p updatenow=     Enter Selection Here: 


if /i "%updatenow%" NEQ "N" goto:skip
if /i "%MENU1%" EQU "O" (goto:OPTIONS) else (goto:MENU)
:skip

if /i "%updatenow%" EQU "Y" goto:updatenow

:badkey
echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:updateconfirm


:updatenow

cls
echo                                        ModMii                                v%currentversion%
echo                                       by XFlak
echo.
echo.
echo                            Updating from v%currentversion% to v%newversion%
echo.
echo.
echo                                     Please Wait...
echo.


if not exist "%UPDATENAME%%newversion%.zip" start %ModMiimin%/wait support\wget --no-check-certificate -t 3 http://sourceforge.net/projects/modmii/files/%UPDATENAME%%newversion%.zip

if not exist "%UPDATENAME%%newversion%.zip" goto:updatefail

copy /y support\7za.exe support\7za2.exe>nul

echo @echo off>Updatetemp.bat
echo mode con cols=85 lines=54 >>Updatetemp.bat
echo color 1f>>Updatetemp.bat
echo echo                                        ModMii                                v%currentversion%>>Updatetemp.bat
echo echo                                       by XFlak>>Updatetemp.bat
echo echo.>>Updatetemp.bat
echo echo.>>Updatetemp.bat
echo echo                            Updating from v%currentversion% to v%newversion%>>Updatetemp.bat
echo echo.>>Updatetemp.bat
echo echo.>>Updatetemp.bat
echo echo                                     Please Wait...>>Updatetemp.bat
echo echo.>>Updatetemp.bat


echo if exist "support\ModMii.bat" ren "support\ModMii.bat" "ModMii-v%currentversion%.bat">>Updatetemp.bat
echo if exist "support\ModMiiSkin.bat" ren "support\ModMiiSkin.bat" "ModMiiSkin-v%currentversion%.bat">>Updatetemp.bat
echo support\7za2 x %UPDATENAME%%newversion%.zip -aoa>>Updatetemp.bat
echo del %UPDATENAME%%newversion%.zip^>nul>>Updatetemp.bat
echo del support\7za2.exe^>nul>>Updatetemp.bat
echo Start ModMii.exe>>Updatetemp.bat
echo exit>>Updatetemp.bat
start Updatetemp.bat
exit


:updatefail
echo   Update check has failed, check your internet connection and firewall settings.
@ping 127.0.0.1 -n 4 -w 1000> nul
set currentversion=%currentversioncopy%

if /i "%MENU1%" EQU "O" (goto:OPTIONS) else (goto:menu)


::-------------------------------File Cleanup------------------------------------
:FileCleanup
cls

::---------------CMD LINE MODE-------------
if /i "%cmdlinemodeswitchoff%" EQU "Y" (set cmdlinemode=) & (set one=) & (set two=)

set cleanitems=0
if exist "%DRIVE%"\WAD SET /a cleanitems=%cleanitems%+1
if exist "%DRIVE%"\00000001 SET /a cleanitems=%cleanitems%+1
if exist "%DRIVE%"\00010008 SET /a cleanitems=%cleanitems%+1
if exist "%DRIVE%"\00010002 SET /a cleanitems=%cleanitems%+1
if exist "%DRIVE%"\00010001 SET /a cleanitems=%cleanitems%+1
if exist "%DRIVE%"\private\wii\title\aktn SET /a cleanitems=%cleanitems%+1
if exist "%DRIVE%"\apps\DOP-Mii SET /a cleanitems=%cleanitems%+1
if exist "%DRIVE%"\apps\MMM SET /a cleanitems=%cleanitems%+1
if exist "%DRIVE%"\apps\WiiMod SET /a cleanitems=%cleanitems%+1
if exist "%DRIVE%"\apps\ARCmod06_Offline SET /a cleanitems=%cleanitems%+1
if exist "%DRIVE%"\apps\MIOSPatcher SET /a cleanitems=%cleanitems%+1
if exist "%DRIVE%"\apps\Priiloader SET /a cleanitems=%cleanitems%+1
if exist "%DRIVE%"\apps\YAWMM SET /a cleanitems=%cleanitems%+1
if exist "%DRIVE%"\apps\HackMii_Installer SET /a cleanitems=%cleanitems%+1
if exist "%DRIVE%"\apps\IOS236-v5-Mod SET /a cleanitems=%cleanitems%+1
if exist "%DRIVE%"\apps\SIP SET /a cleanitems=%cleanitems%+1
if exist "%DRIVE%"\*.dol SET /a cleanitems=%cleanitems%+1
if exist "%DRIVE%"\*.elf SET /a cleanitems=%cleanitems%+1
if exist "%DRIVE%"\*.wad SET /a cleanitems=%cleanitems%+1
if exist "%DRIVE%"\*.md5 SET /a cleanitems=%cleanitems%+1


::smash stack USA check
set path2clean=%DRIVE%\private\wii\app\rsbe\st\st_080805_0933.bin
set md5=aa93aab9bfdd25883bbd826a62645033
set nextgoto=cleancheck1
goto:markmatch
:cleancheck1
set SmashCheck=off
if /i "%match%" EQU "YES" set SmashCheck=on
if /i "%match%" EQU "YES" SET /a cleanitems=%cleanitems%+1

::PWNS USA
set path2clean=%DRIVE%\private\wii\title\rlie\data.bin
set md5=b94f40d57a4b5577eb2479f63cbe79df
set nextgoto=cleancheck2
goto:markmatch
:cleancheck2
set PWNSU=off
if /i "%match%" EQU "YES" set PWNSU=on
if /i "%match%" EQU "YES" SET /a cleanitems=%cleanitems%+1

::PWNS JAP
set path2clean=%DRIVE%\private\wii\title\rlij\data.bin
set md5=1f7e42a30492d2fa116a2fe5ebc685d1
set nextgoto=cleancheck3
goto:markmatch
:cleancheck3
set PWNSJ=off
if /i "%match%" EQU "YES" set PWNSJ=on
if /i "%match%" EQU "YES" SET /a cleanitems=%cleanitems%+1

::PWNS EURO
set path2clean=%DRIVE%\private\wii\title\rlip\data.bin
set md5=a6b8f03f49baa471228dcd81d3fd623a
set nextgoto=cleancheck4
goto:markmatch
:cleancheck4
set PWNSE=off
if /i "%match%" EQU "YES" set PWNSE=on
if /i "%match%" EQU "YES" SET /a cleanitems=%cleanitems%+1

::TWILIGHT USA
set path2clean=%DRIVE%\private\wii\title\rzde\data.bin
set md5=02639bd145730269a98f69a4fd466225
set nextgoto=cleancheck5
goto:markmatch
:cleancheck5
set TWIU=off
if /i "%match%" EQU "YES" set TWIU=on
if /i "%match%" EQU "YES" SET /a cleanitems=%cleanitems%+1

::TWILIGHT JAP
set path2clean=%DRIVE%\private\wii\title\rzdj\data.bin
set md5=b51cd6a64bc911cc5c8e41ed5d9fd8ae
set nextgoto=cleancheck6
goto:markmatch
:cleancheck6
set TWIJ=off
if /i "%match%" EQU "YES" set TWIJ=on
if /i "%match%" EQU "YES" SET /a cleanitems=%cleanitems%+1

::TWILIGHT EURO
set path2clean=%DRIVE%\private\wii\title\rzdp\data.bin
set md5=704bd625ea5b42d7ac06fc937af74d38
set nextgoto=cleancheck7
goto:markmatch
:cleancheck7
set TWIE=off
if /i "%match%" EQU "YES" set TWIE=on
if /i "%match%" EQU "YES" SET /a cleanitems=%cleanitems%+1


::YUGI USA
set path2clean=%DRIVE%\private\wii\title\ryoe\data.bin
set md5=0319cb55ecb1caea34e4504aa56664ab
set nextgoto=cleancheck8
goto:markmatch
:cleancheck8
set YUGIU=off
if /i "%match%" EQU "YES" set YUGIU=on
if /i "%match%" EQU "YES" SET /a cleanitems=%cleanitems%+1

::YUGI EURO
set path2clean=%DRIVE%\private\wii\title\ryop\data.bin
set md5=8e8aca85b1106932db5ec564ac5c9f0b
set nextgoto=cleancheck9
goto:markmatch
:cleancheck9
set YUGIE=off
if /i "%match%" EQU "YES" set YUGIE=on
if /i "%match%" EQU "YES" SET /a cleanitems=%cleanitems%+1

::YUGI EURO 50hz
set path2clean=%DRIVE%\private\wii\title\ryop\data.bin
set md5=fd15710a20ec01d01324c18bf4bf3921
set nextgoto=cleancheck10
goto:markmatch
:cleancheck10
::set YUGIE=off
if /i "%match%" EQU "YES" set YUGIE=on
if /i "%match%" EQU "YES" SET /a cleanitems=%cleanitems%+1

::YUGI JAP
set path2clean=%DRIVE%\private\wii\title\ryoj\data.bin
set md5=2f7dfe45a01d01cbf7672afd70b252b4
set nextgoto=cleancheck11
goto:markmatch
:cleancheck11
set YUGIJ=off
if /i "%match%" EQU "YES" set YUGIJ=on
if /i "%match%" EQU "YES" SET /a cleanitems=%cleanitems%+1

::smash stack JAP check
set path2clean=%DRIVE%\private\wii\app\RSBJ\st\st_smashstackjp.bin
set md5=9a23e5543c65ea2090c5b66a9839216a
set nextgoto=cleancheck12
goto:markmatch
:cleancheck12
set SmashJCheck=off
if /i "%match%" EQU "YES" set SmashJCheck=on
if /i "%match%" EQU "YES" SET /a cleanitems=%cleanitems%+1

::Bathaxx USA
set path2clean=%DRIVE%\private\wii\title\rlbe\data.bin
set md5=5dac3152baabbc6ca17bedfd5b7350c9
set nextgoto=cleancheck13
goto:markmatch
:cleancheck13
set BathaxxU=off
if /i "%match%" EQU "YES" set BathaxxU=on
if /i "%match%" EQU "YES" SET /a cleanitems=%cleanitems%+1

::Bathaxx JAP
set path2clean=%DRIVE%\private\wii\title\rlbj\data.bin
set md5=8ce86646c463565798dda77ea93118eb
set nextgoto=cleancheck14
goto:markmatch
:cleancheck14
set BathaxxJ=off
if /i "%match%" EQU "YES" set BathaxxJ=on
if /i "%match%" EQU "YES" SET /a cleanitems=%cleanitems%+1

::Bathaxx EURO
set path2clean=%DRIVE%\private\wii\title\rlbp\data.bin
set md5=1f44f39d7aad36c7c93a7592e52fa217
set nextgoto=cleancheck15
goto:markmatch
:cleancheck15
set BathaxxE=off
if /i "%match%" EQU "YES" set BathaxxE=on
if /i "%match%" EQU "YES" SET /a cleanitems=%cleanitems%+1

::ROTJ USA
set path2clean=%DRIVE%\private\wii\title\rlge\data.bin
set md5=448a3e6bfb4b6d9fafd64c45575f9cb4
set nextgoto=cleancheck16
goto:markmatch
:cleancheck16
set ROTJU=off
if /i "%match%" EQU "YES" set ROTJU=on
if /i "%match%" EQU "YES" SET /a cleanitems=%cleanitems%+1

::ROTJ JAP
set path2clean=%DRIVE%\private\wii\title\rlgj\data.bin
set md5=b64e489f15dea67b4ab8dd5315064295
set nextgoto=cleancheck17
goto:markmatch
:cleancheck17
set ROTJJ=off
if /i "%match%" EQU "YES" set ROTJJ=on
if /i "%match%" EQU "YES" SET /a cleanitems=%cleanitems%+1

::ROTJ EURO
set path2clean=%DRIVE%\private\wii\title\rlgp\data.bin
set md5=6e225b61b74bd8529374086e476487d3
set nextgoto=cleancheck18
goto:markmatch
:cleancheck18
set ROTJE=off
if /i "%match%" EQU "YES" set ROTJE=on
if /i "%match%" EQU "YES" SET /a cleanitems=%cleanitems%+1


::smash stack PAL check
set path2clean=%DRIVE%\private\wii\app\RSBP\st\st_smashStackPK.bin
set md5=5ce0563bbdd394d8fd3947a413d234ab
set nextgoto=cleancheck19
goto:markmatch
:cleancheck19
set SmashPCheck=off
if /i "%match%" EQU "YES" set SmashPCheck=on
if /i "%match%" EQU "YES" SET /a cleanitems=%cleanitems%+1

::smash stack PAL - No Save - check
set path2clean=%DRIVE%\private\wii\app\RSBP\st\_st_smashStackPK_noSave.bin
set md5=208e1505a426aaa4b341921f271b2b12
set nextgoto=cleancheck20
goto:markmatch
:cleancheck20
set SmashP2Check=off
if /i "%match%" EQU "YES" set SmashP2Check=on
if /i "%match%" EQU "YES" SET /a cleanitems=%cleanitems%+1



::smash stack KOR check
set path2clean=%DRIVE%\private\wii\app\RSBK\st\st_smashStackPK.bin
set md5=5ce0563bbdd394d8fd3947a413d234ab
set nextgoto=cleancheck21
goto:markmatch
:cleancheck21
set SmashKCheck=off
if /i "%match%" EQU "YES" set SmashKCheck=on
if /i "%match%" EQU "YES" SET /a cleanitems=%cleanitems%+1

::smash stack KOR - No Save - check
set path2clean=%DRIVE%\private\wii\app\RSBK\st\_st_smashStackPK_noSave.bin
set md5=208e1505a426aaa4b341921f271b2b12
set nextgoto=cleancheck22
goto:markmatch
:cleancheck22
set SmashK2Check=off
if /i "%match%" EQU "YES" set SmashK2Check=on
if /i "%match%" EQU "YES" SET /a cleanitems=%cleanitems%+1


::Eri HaKawai USA
set path2clean=%DRIVE%\private\wii\title\rt4e\data.bin
set md5=4b62b5c6e00ee8943fec265c5d53ad19
set nextgoto=cleancheck23
goto:markmatch
:cleancheck23
set TOSU=off
if /i "%match%" EQU "YES" set TOSU=on
if /i "%match%" EQU "YES" SET /a cleanitems=%cleanitems%+1

::Eri HaKawai PAL
set path2clean=%DRIVE%\private\wii\title\rt4p\data.bin
set md5=08d01800a4703ec6349c3a8d454bf8e1
set nextgoto=cleancheck24
goto:markmatch
:cleancheck24
set TOSE=off
if /i "%match%" EQU "YES" set TOSE=on
if /i "%match%" EQU "YES" SET /a cleanitems=%cleanitems%+1

::Eri HaKawai JAP
set path2clean=%DRIVE%\private\wii\title\rt4j\data.bin
set md5=7884370e1b8960ed09ed61395007affd
set nextgoto=cleancheck25
goto:markmatch
:cleancheck25
set TOSJ=off
if /i "%match%" EQU "YES" set TOSJ=on
if /i "%match%" EQU "YES" SET /a cleanitems=%cleanitems%+1

goto:nextpage



::----mark matches-----
:markmatch
set match=
if exist "%path2clean%" (goto:checkexisting) else (goto:nocheckexisting)
:checkexisting
set match=yes
::assume match, if its not, it will change to 'no' further below
support\sfk md5 -quiet -verify %md5% "%path2clean%"
if errorlevel 1 set match=no
:nocheckexisting
goto:%nextgoto%


:nextpage

if /i "%cleanitems%" NEQ "0" goto:FileCleanup2

echo                                        ModMii                                v%currentversion%
echo                                       by XFlak
echo.
echo.
echo                                     FILE CLEANUP
echo.
echo.
echo                       No Unnecessary Files Exist in %DRIVE%
echo.
echo.
echo.
echo                               Returning to Main Menu...
echo.

@ping 127.0.0.1 -n 4 -w 1000> nul
goto:MENU





:FileCleanup2
set clean=
echo                                        ModMii                                v%currentversion%
echo                                       by XFlak
echo.
echo                                     FILE CLEANUP
echo.
echo                        After you are finished modding your Wii,
echo                     you can delete certain files to free up space
echo          and ensure no one can access potentially dangerous apps on your Wii.
echo.
echo          Note: Instead of deleting apps, you can move them to a Locked Folder
echo                in the HBC (downloadable via Download Page 2).
echo.
echo.
echo          Would you like to delete the following from %DRIVE%?
echo.
if exist "%DRIVE%"\WAD echo          * WAD Folder
if exist "%DRIVE%"\00000001 echo          * 00000001 Folder
if exist "%DRIVE%"\00010008 echo          * 00010008 Folder
if exist "%DRIVE%"\00010002 echo          * 00010002 Folder
if exist "%DRIVE%"\00010001 echo          * 00010001 Folder
if exist "%DRIVE%"\private\wii\title\aktn echo          * Bannerbomb
if /i "%SmashCheck%" EQU "on" echo          * Smash Stack (USA)
if /i "%SmashJCheck%" EQU "on" echo          * Smash Stack (JAP)

if /i "%SmashPCheck%" EQU "on" echo          * Smash Stack (EURO)
if /i "%SmashP2Check%" EQU "on" echo          * Smash Stack (EURO) - No Save

if /i "%SmashKCheck%" EQU "on" echo          * Smash Stack (KOR)
if /i "%SmashK2Check%" EQU "on" echo          * Smash Stack (KOR) - No Save


if /i "%PWNSU%" EQU "on" echo          * Indiana Pwns (USA)
if /i "%PWNSE%" EQU "on" echo          * Indiana Pwns (EURO)
if /i "%PWNSJ%" EQU "on" echo          * Indiana Pwns (JAP)

if /i "%BathaxxU%" EQU "on" echo          * Bathaxx (USA)
if /i "%BathaxxE%" EQU "on" echo          * Bathaxx (EURO)
if /i "%BathaxxJ%" EQU "on" echo          * Bathaxx (JAP)

if /i "%ROTJU%" EQU "on" echo          * Return of the Jodi (USA)
if /i "%ROTJE%" EQU "on" echo          * Return of the Jodi (EURO)
if /i "%ROTJJ%" EQU "on" echo          * Return of the Jodi (JAP)

if /i "%TOSU%" EQU "on" echo          * Eri HaKawai (USA)
if /i "%TOSE%" EQU "on" echo          * Eri HaKawai (EURO)
if /i "%TOSJ%" EQU "on" echo          * Eri HaKawai (JAP)

if /i "%TWIU%" EQU "on" echo          * Twilight Hack (USA)
if /i "%TWIE%" EQU "on" echo          * Twilight Hack (EURO)
if /i "%TWIJ%" EQU "on" echo          * Twilight Hack (JAP)
if /i "%YUGIU%" EQU "on" echo          * YU-GI-OWNED (USA)
if /i "%YUGIE%" EQU "on" echo          * YU-GI-OWNED (EURO)
if /i "%YUGIJ%" EQU "on" echo          * YU-GI-OWNED (JAP)
if exist "%DRIVE%"\apps\DOP-Mii echo          * apps\DOP-Mii
if exist "%DRIVE%"\apps\MMM echo          * apps\MMM
if exist "%DRIVE%"\apps\WiiMOd echo          * apps\WiiMod
if exist "%DRIVE%"\apps\ARCmod06_Offline echo          * apps\ARCmod06_Offline
if exist "%DRIVE%"\apps\MIOSPatcher echo          * apps\MIOSPatcher
if exist "%DRIVE%"\apps\Priiloader echo          * apps\Priiloader
if exist "%DRIVE%"\apps\YAWMM echo          * apps\YAWMM
if exist "%DRIVE%"\apps\HackMii_Installer echo          * apps\HackMii_Installer
if exist "%DRIVE%"\apps\IOS236-v5-Mod echo          * apps\IOS236-v5-Mod
if exist "%DRIVE%"\apps\SIP echo          * apps\SIP
if exist "%DRIVE%"\apps\WiiExplorer echo          * apps\WiiExplorer
if exist "%DRIVE%"\*.dol echo          * dol's from root of device
if exist "%DRIVE%"\*.elf echo          * elf's from root of device
if exist "%DRIVE%"\*.wad echo          * wad's from root of device
if exist "%DRIVE%"\*.md5 echo          * md5's from root of device
echo.
echo         Note: All the above files, with the exception of custom WADs,
echo               can be retrieved again later using ModMii
echo.
echo.
echo.
echo                Y = Yes, delete files now
echo                N = No
echo.
echo                B = Back
echo                M = Main Menu
echo.
echo.
echo.
set /p clean=     Enter Selection Here: 
if /i "%clean%" EQU "Y" goto:cleannow
if /i "%clean%" EQU "N" goto:MENU
if /i "%clean%" EQU "B" goto:MENU
if /i "%clean%" EQU "M" goto:MENU
echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:FileCleanup

:cleannow
set clean2=
echo.
echo.
echo.
echo          Are you sure you want to permanently delete the above files? (Y/N)
echo.
set /p clean2=     Enter Selection Here: 
if /i "%clean2%" EQU "Y" goto:cleannow3
if /i "%clean2%" EQU "N" goto:MENU
echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:FileCleanup

:cleannow3



cls
echo                                        ModMii                                v%currentversion%
echo                                       by XFlak
echo.
echo.
echo                                    CLEANING FILES...
echo.
if exist "%DRIVE%"\*.dol del "%DRIVE%"\*.dol> nul
if exist "%DRIVE%"\*.elf del "%DRIVE%"\*.elf> nul
if exist "%DRIVE%"\*.wad del "%DRIVE%"\*.wad> nul
if exist "%DRIVE%"\*.md5 del "%DRIVE%"\*.md5> nul
if exist "%DRIVE%"\WAD rd /s /q "%DRIVE%"\WAD> nul
if exist "%DRIVE%"\00000001 rd /s /q "%DRIVE%"\00000001> nul
if exist "%DRIVE%"\00010008 rd /s /q "%DRIVE%"\00010008> nul
if exist "%DRIVE%"\00010002 rd /s /q "%DRIVE%"\00010002> nul
if exist "%DRIVE%"\00010001 rd /s /q "%DRIVE%"\00010001> nul
if exist "%DRIVE%"\private\wii\title\aktn rd /s /q "%DRIVE%"\private\wii\title\aktn> nul
if exist "%DRIVE%"\apps\DOP-Mii rd /s /q "%DRIVE%"\apps\DOP-Mii> nul
if exist "%DRIVE%"\apps\MMM rd /s /q "%DRIVE%"\apps\MMM> nul
if exist "%DRIVE%"\apps\WiiMod rd /s /q "%DRIVE%"\apps\WiiMod> nul
if exist "%DRIVE%"\apps\ARCmod06_Offline rd /s /q "%DRIVE%"\apps\ARCmod06_Offline> nul
if exist "%DRIVE%"\apps\MIOSPatcher rd /s /q "%DRIVE%"\apps\MIOSPatcher> nul
if exist "%DRIVE%"\apps\Priiloader rd /s /q "%DRIVE%"\apps\Priiloader> nul
if exist "%DRIVE%"\apps\YAWMM rd /s /q "%DRIVE%"\apps\YAWMM> nul
if exist "%DRIVE%"\apps\HackMii_Installer rd /s /q "%DRIVE%"\apps\HackMii_Installer> nul
if exist "%DRIVE%"\apps\IOS236-v5-Mod rd /s /q "%DRIVE%"\apps\IOS236-v5-Mod> nul
if exist "%DRIVE%"\apps\SIP rd /s /q "%DRIVE%"\apps\SIP> nul
if exist "%DRIVE%"\apps\WiiExplorer rd /s /q "%DRIVE%"\apps\WiiExplorer> nul
if exist "%DRIVE%"\private\*.zip del "%DRIVE%"\private\*.zip> nul
if exist "%DRIVE%"\private\wii\title\RYOP-50hz rd /s /q "%DRIVE%"\private\wii\title\RYOP-50hz> nul

::advanced deletions
if /i "%SmashCheck%" EQU "on" del "%DRIVE%"\private\wii\app\rsbe\st\st_080805_0933.bin> nul
if /i "%SmashJCheck%" EQU "on" del "%DRIVE%"\private\wii\app\RSBJ\st\st_smashstackjp.bin> nul

if /i "%SmashPCheck%" EQU "on" del "%DRIVE%"\private\wii\app\RSBP\st\st_smashStackPK.bin> nul
if /i "%SmashP2Check%" EQU "on" del "%DRIVE%"\private\wii\app\RSBP\st\_st_smashStackPK_noSave.bin> nul

if /i "%SmashKCheck%" EQU "on" del "%DRIVE%"\private\wii\app\RSBK\st\st_smashStackPK.bin> nul
if /i "%SmashK2Check%" EQU "on" del "%DRIVE%"\private\wii\app\RSBK\st\_st_smashStackPK_noSave.bin> nul


if /i "%PWNSU%" EQU "on" rd /s /q "%DRIVE%"\private\wii\title\rlie> nul
if /i "%PWNSJ%" EQU "on" rd /s /q "%DRIVE%"\private\wii\title\rlij> nul
if /i "%PWNSE%" EQU "on" rd /s /q "%DRIVE%"\private\wii\title\rlip> nul

if /i "%BathaxxU%" EQU "on" rd /s /q "%DRIVE%"\private\wii\title\rlbe> nul
if /i "%BathaxxJ%" EQU "on" rd /s /q "%DRIVE%"\private\wii\title\rlbj> nul
if /i "%BathaxxE%" EQU "on" rd /s /q "%DRIVE%"\private\wii\title\rlbp> nul

if /i "%ROTJU%" EQU "on" rd /s /q "%DRIVE%"\private\wii\title\rlge> nul
if /i "%ROTJJ%" EQU "on" rd /s /q "%DRIVE%"\private\wii\title\rlgj> nul
if /i "%ROTJE%" EQU "on" rd /s /q "%DRIVE%"\private\wii\title\rlgp> nul

if /i "%TOSU%" EQU "on" rd /s /q "%DRIVE%"\private\wii\title\rt4e> nul
if /i "%TOSE%" EQU "on" rd /s /q "%DRIVE%"\private\wii\title\rt4p> nul
if /i "%TOSJ%" EQU "on" rd /s /q "%DRIVE%"\private\wii\title\rt4j> nul

if /i "%TWIU%" EQU "on" rd /s /q "%DRIVE%"\private\wii\title\rzde> nul
if /i "%TWIE%" EQU "on" rd /s /q "%DRIVE%"\private\wii\title\rzdp> nul
if /i "%TWIJ%" EQU "on" rd /s /q "%DRIVE%"\private\wii\title\rzdj> nul
if /i "%YUGIU%" EQU "on" rd /s /q "%DRIVE%"\private\wii\title\ryoe> nul
if /i "%YUGIE%" EQU "on" rd /s /q "%DRIVE%"\private\wii\title\ryop> nul
if /i "%YUGIJ%" EQU "on" rd /s /q "%DRIVE%"\private\wii\title\ryoj> nul


echo                                    FILES CLEANED
echo.
echo.
@ping 127.0.0.1 -n 3 -w 1000> nul
goto:MENU





::...................................Wizard Page1 - Virgin?...............................
:RCPAGE1
set REGIONCHANGE=


cls
echo                                        ModMii                                v%currentversion%
echo                                       by XFlak
echo.
echo.
echo         Are you sure you want to Region Change your Wii?
echo.
echo.
echo         Important Notes:
echo         ----------------
echo.
echo         * Region Changing is not necessary to play other region games.
echo           For example, you can play Jap games on a softmodded US Wii without
echo           region changing.
echo.
echo         * An alternative to region changing is to use SNEEK\UNEEK to emulate a
echo           different region System Menu.
echo.
echo.
echo         If you still want to region change your Wii, read the following
echo         warnings before continuing:
echo.
echo.
echo         Warnings:
echo         ---------
echo.
echo         * If you use the Wii Shopping Channel, you must start the channel and
echo           delete your account before starting this guide on your Wii.
echo           If you don't the Wii Shop Channel will error.
echo.
echo         * ModMii's region changing guide assumes your Wii is already softmodded
echo           with the Homebrew Channel, IOS236 and Bootmii. If you are missing any
echo           of those use the ModMii Wizard before continuing with this guide.
echo.
echo.
echo.
echo                Y = Yes
echo                N = No
echo.
echo                B = Back
echo                M = Main Menu
echo.
echo.
echo.
echo.
set /p REGIONCHANGE=     Enter Selection Here: 


if /i "%REGIONCHANGE%" EQU "B" goto:MENU
if /i "%REGIONCHANGE%" EQU "M" goto:MENU
if /i "%REGIONCHANGE%" EQU "N" goto:MENU

if /i "%REGIONCHANGE%" EQU "Y" goto:WPAGE3


echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:RCPAGE1




::--------------------Wizard Settings Detected----------------
:LoadWizardSettings
set LoadWizSettings=
if not exist Wizard_Settings.bat goto:WPAGE1

cls
echo                                        ModMii                                v%currentversion%
echo                                       by XFlak
echo.
echo.
support\sfk echo -spat \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 [Red] Wizard Saved Settings Detected!
echo.
echo.
echo               Would you like to load the Wizard's Saved Settings now?
echo.
echo.
echo.
echo         Note: You will be able to view and confirm the loaded settings
echo               before starting your download
echo.
echo.
echo.
echo                Y = Yes, Load Wizard_Settings.bat
echo                N = No, Continue with the Wizard
echo.
echo                D = Delete Wizard_Settings.bat to stop seeing this page
echo                    in the future then continue with the Wizard
echo.
echo                B = Back
echo                M = Main Menu
echo.
echo.
echo.
echo.
set /p LoadWizSettings=     Enter Selection Here: 


if /i "%LoadWizSettings%" EQU "B" goto:MENU
if /i "%LoadWizSettings%" EQU "M" goto:MENU

if /i "%LoadWizSettings%" NEQ "Y" goto:skip
call Wizard_Settings.bat
IF "%USBGUIDE%"=="" set USBGUIDE=n
if /i "%ThemeSelection%" EQU "Y" set ThemeSelection=r
if /i "%Mii%" EQU "Y" set MIIQ=Y
if /i "%pri%" EQU "Y" set PRIQ=Y
if /i "%H5%" EQU "Y" set RECCIOS=Y
if /i "%HM%" EQU "Y" set HMInstaller=Y
if /i "%yawmm%" EQU "Y" set yawmq=Y
if /i "%IOS236Installer%" EQU "Y" set IOS236InstallerQ=Y
goto:WPAGELAST
:skip

if /i "%LoadWizSettings%" EQU "D" del Wizard_Settings.bat>nul
if /i "%LoadWizSettings%" EQU "D" goto:WPAGE1
if /i "%LoadWizSettings%" EQU "N" goto:WPAGE1

echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:LoadWizardSettings






::...................................Wizard Page1 - Virgin?...............................
:WPAGE1
set VIRGIN=


set Advanced=
set HMInstaller=
set RECCIOS=
set yawmQ=
set PRIQ=
set ThemeSelection=N



cls
echo                                        ModMii                                v%currentversion%
echo                                       by XFlak
echo.
echo.
echo         Is this your first time softmodding your Wii?
echo                                         --
echo                                         OR
echo                                         --
echo         Would you like to update ALL your existing softmods (aka re-hack your Wii)
echo.
echo.
echo.
echo.
echo         Note: Only answer No if you know specifically what you want to update
echo.
echo.
echo.
echo                Y = Yes
echo                N = No
echo.
echo                B = Back
echo                M = Main Menu
echo.
echo.
echo.
echo.
set /p VIRGIN=     Enter Selection Here: 


if exist Wizard_Settings.bat goto:backtoloadwiz
if /i "%VIRGIN%" EQU "B" goto:MENU
:backtoloadwiz
if /i "%VIRGIN%" EQU "B" goto:LoadWizardSettings

if /i "%VIRGIN%" EQU "M" goto:MENU
if /i "%VIRGIN%" EQU "Y" goto:WPAGE2
if /i "%VIRGIN%" EQU "N" goto:WPAGE2

echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:WPAGE1

::...................................Wizard Page2 - Current SystemMenu...............................
:WPAGE2
set FIRMSTART=

set backb4HACKMIISOLUTION=WPAGE2

cls
echo                                        ModMii                                v%currentversion%
echo                                       by XFlak
echo.
echo.
if /i "%MENU1%" EQU "H" (echo                                  HackMii Solutions) & (echo.)

if /i "%AbstinenceWiz%" NEQ "Y" goto:notabstinence
echo                                  Abstinence Wizard
echo.
echo.
echo         This wizard allows you to enjoy many of the benefits of a softmodded Wii
echo         without installing any unofficial content (ie. should not void warranty)
echo.
echo.
echo.
echo.
:notabstinence


echo         What is your current System Menu Version?
echo.
echo.
echo     For an instructional video on checking your System Menu Version enter "Help"
echo.
echo         Note: to check this, turn on your wii, click the Wii button in the
echo               bottom left of the main system menu, click Wii Settings,
echo               then you should see the System Menu in the top right of the screen
echo               (ie. 4.2U, 4.1J, 3.2E, etc.)
echo.
echo.
echo.
echo.
echo.
echo                4.3 = 4.3
echo                4.2 = 4.2
echo                4.1 = 4.1
echo                4.0 = 4.0
echo                3.X = 3.0-3.5
echo                  O = Other (under 2.2)
echo.
echo.
echo.
echo.
echo                B = Back
echo                M = Main Menu
echo.
echo.
echo.
echo.

set /p FIRMSTART=     Enter Selection Here: 




if /i "%FIRMSTART%" EQU "M" goto:MENU

if /i "%FIRMSTART%" NEQ "Help" goto:nohelp
start /D SUPPORT SMver.html
goto:WPAGE2
:nohelp

if /i "%FIRMSTART%" EQU "3.x" set FIRMSTART=3.X

if /i "%AbstinenceWiz%" NEQ "Y" goto:NotAbstinenceWiz
if /i "%FIRMSTART%" EQU "4.3" goto:WPAGE3
if /i "%FIRMSTART%" EQU "O" goto:WPAGE3
if /i "%FIRMSTART%" EQU "4.2" goto:NEEKrevSelect
if /i "%FIRMSTART%" EQU "4.1" goto:NEEKrevSelect
if /i "%FIRMSTART%" EQU "4.0" goto:NEEKrevSelect
if /i "%FIRMSTART%" EQU "3.X" goto:NEEKrevSelect
:NotAbstinenceWiz


if /i "%FIRMSTART%" EQU "4.3" goto:WPAGE3
if /i "%FIRMSTART%" EQU "4.2" goto:WPAGE3
if /i "%FIRMSTART%" EQU "4.1" goto:WPAGE3
if /i "%FIRMSTART%" EQU "4.0" goto:WPAGE3
if /i "%FIRMSTART%" EQU "3.X" goto:WPAGE3
if /i "%FIRMSTART%" EQU "O" goto:WPAGE3



if /i "%FIRMSTART%" NEQ "B" goto:incorrectkey
if /i "%MENU1%" EQU "H" goto:MENU
if /i "%AbstinenceWiz%" EQU "Y" goto:MENU
goto:WPAGE1

:incorrectkey
echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:WPAGE2


::...................................Wizard Page3 - REGION...............................
:WPAGE3
if /i "%FIRMSTART%" EQU "4.3" goto:WPAGE3hard
if /i "%FIRMSTART%" EQU "o" goto:WPAGE3hard
if /i "%MENU1%" EQU "H" goto:HACKMIISOLUTION
:WPAGE3hard
set REGION=

cls
echo                                        ModMii                                v%currentversion%
echo                                       by XFlak
echo.
echo.

if /i "%MENU1%" EQU "RC" (echo         What Region would you like to change to?) & (goto:skiptext)
echo         What is your Region?
echo.
echo.
echo         For an instructional video on checking your System Menu enter "Help"
echo.
echo         Note: to check this, turn on your wii, click the Wii button in the
echo               bottom left of the main system menu, click Wii Settings,
echo               then you should see the System Menu in the top right of the screen
echo               (ie. 4.2U, 4.1J, 3.2E, etc.)
echo.
echo         Note: If your Wii was Region Changed choose the region you are currently on
:skiptext

echo.
echo.
echo                U = USA
echo                E = Euro (PAL)
echo                J = JAP
echo                K = Korean
echo.
echo.
echo.
echo.
echo                B = Back
echo                M = Main Menu
echo.
echo.

set /p REGION=     Enter Selection Here: 


if /i "%REGION%" EQU "M" goto:MENU

if /i "%REGION%" EQU "u" set REGION=U
if /i "%REGION%" EQU "e" set REGION=E
if /i "%REGION%" EQU "j" set REGION=J
if /i "%REGION%" EQU "k" set REGION=K


if /i "%MENU1%" NEQ "RC" goto:notRC
if /i "%REGION%" EQU "U" goto:WPAGE4
if /i "%REGION%" EQU "E" goto:WPAGE4
if /i "%REGION%" EQU "K" goto:WPAGE4
if /i "%REGION%" EQU "J" goto:WPAGE4
if /i "%REGION%" EQU "B" goto:RCPAGE1
goto:badkey
:notRC

::download page redirect for Wilbrand
if /i "%MENU1%" EQU "1" goto:Wilbrand
if /i "%MENU1%" EQU "2" goto:Wilbrand
if /i "%MENU1%" EQU "3" goto:Wilbrand
if /i "%MENU1%" EQU "4" goto:Wilbrand
if /i "%MENU1%" EQU "A" goto:Wilbrand
goto:notWilbrand
:Wilbrand
if /i "%REGION%" EQU "B" goto:macaddress
if /i "%REGION%" EQU "U" goto:OLDLIST
if /i "%REGION%" EQU "E" goto:OLDLIST
if /i "%REGION%" EQU "K" goto:OLDLIST
if /i "%REGION%" EQU "J" goto:OLDLIST
:notWilbrand


if /i "%REGION%" EQU "U" goto:WPAGE3C
if /i "%REGION%" EQU "E" goto:WPAGE3C
if /i "%REGION%" EQU "K" goto:WPAGE3C
if /i "%REGION%" EQU "J" goto:WPAGE3C
if /i "%REGION%" EQU "B" goto:WPAGE2


if /i "%REGION%" NEQ "Help" goto:nohelp
start /D SUPPORT SMver.html
goto:WPAGE3
:nohelp

:badkey
echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:WPAGE3



::...................................Wizard Page3C - Exploit...............................
:WPAGE3C

SET EXPLOIT=default
set exploitselection=
if /i "%VIRGIN%" EQU "N" goto:WPAGE3D

if /i "%FIRMSTART%" EQU "4.3" goto:WPAGE3Cnext
if /i "%FIRMSTART%" EQU "o" goto:WPAGE3Cnext


goto:WPAGE4


::Only virgin 4.3 U/E/J wii's or <2.2 U/E/J Wii's will make it this far
:WPAGE3Cnext

set backb4HACKMIISOLUTION=WPAGE3c


set exploitselection=yes

cls
echo                                        ModMii                                v%currentversion%
echo                                       by XFlak
echo.
echo.


echo      Select the Exploit you would like to use on your Wii.
echo.
echo.
if /i "%FIRMSTART%" EQU "o" goto:skipbomb
echo                W = Wilbrand (discless exploit)
echo.
echo.
echo      The following 4.3 exploits require you own one of the following games:
:skipbomb


echo.
echo                S = Super Smash Brothers Brawl
if /i "%REGION%" NEQ "K" echo                L = LEGO Indiana Jones
if /i "%REGION%" NEQ "K" echo               LB = LEGO Batman
if /i "%REGION%" NEQ "K" echo               LS = LEGO Star Wars
if /i "%REGION%" NEQ "K" echo                Y = Yu-Gi-Oh! 5D's
if /i "%REGION%" NEQ "K" echo              TOS = Tales of Symphonia: Dawn of the New World


if /i "%FIRMSTART%" EQU "o" echo                T = Twilight Princess: The Legend of Zelda
if /i "%FIRMSTART%" EQU "o" echo.
echo                ? = If you're not sure, download all of the above and decide later
echo.
echo.
echo.



if /i "%FIRMSTART%" NEQ "o" goto:skipOmsg
support\sfk echo -spat \x20 [Red] Important Notes:
echo.
echo    Alternatively, you can update your Wii to v3.0-4.3 then repeat the
echo    Wizard using your new System Menu in order to hack your
echo    Wii without requiring one of the above games
echo.
:skipOmsg

echo.
echo.
echo.
echo.
echo.
echo                B = Back
echo                M = Main Menu
echo.
echo.
echo.
echo.
set /p EXPLOIT=     Enter Selection Here: 

if /i "%EXPLOIT%" EQU "M" goto:MENU

if /i "%EXPLOIT%" EQU "B" goto:WPAGE3

if /i "%FIRMSTART%" NEQ "o" goto:twilightnotavailable
if /i "%EXPLOIT%" EQU "T" goto:WPAGE3D
:twilightnotavailable

::ALL except KOR
if /i "%REGION%" EQU "K" goto:skip

if /i "%EXPLOIT%" EQU "Y" goto:WPAGE3D
if /i "%EXPLOIT%" EQU "L" goto:WPAGE3D
if /i "%EXPLOIT%" EQU "LB" goto:WPAGE3D
if /i "%EXPLOIT%" EQU "LS" goto:WPAGE3D
if /i "%EXPLOIT%" EQU "TOS" goto:WPAGE3D
:skip
if /i "%EXPLOIT%" EQU "?" goto:WPAGE3D
if /i "%EXPLOIT%" EQU "S" goto:WPAGE3D

if /i "%FIRMSTART%" EQU "o" goto:notbomb
if /i "%EXPLOIT%" EQU "W" goto:macaddress
:notbomb

echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:WPAGE3C




::----------------------------------------MAC ADDRESS---------------------------------
:macaddress
::start http://please.hackmii.com
::start /D SUPPORT LetterBombFrames.html

set macaddress=


cls
echo                                        ModMii                                v%currentversion%
echo                                       by XFlak
echo.
echo.
echo    Enter your Wii's MAC address (required for Wilbrand exploit)
echo.
echo.
echo.
echo    Examples:
echo             AABBCCDDEEFF
echo             AA BB CC DD EE FF
echo             AA:BB:CC:DD:EE:FF
echo             11-22-33-44-55-66
echo.
echo.
echo.
echo         Note: to find your Wii's MAC address, turn on your Wii, click the
echo               Wii button in the bottom left of the main system menu,
echo               then click Wii Settings, then Internet, then Console Information.
echo.
echo.
echo.
echo     For an instructional video on checking your Wii's MAC address enter "Help"
echo.
echo.
echo.
echo.
echo                B = Back
echo                M = Main Menu
echo.
echo.
echo.
echo.

set /p macaddress=     Enter Selection Here: 

if /i "%macaddress%" EQU "M" goto:MENU

if /i "%macaddress%" NEQ "B" goto:notback
set Wilbrand=
if /i "%MENU1%" EQU "1" goto:OLDLIST
if /i "%MENU1%" EQU "2" goto:OLDLIST
if /i "%MENU1%" EQU "3" goto:OLDLIST
if /i "%MENU1%" EQU "4" goto:OLDLIST
if /i "%MENU1%" EQU "A" goto:OLDLIST
goto:WPAGE3C
:notback

if /i "%macaddress%" NEQ "Help" goto:nohelp
start /D SUPPORT MAC.html
goto:macaddress
:nohelp

echo %macaddress% >temp\temp.txt

support\sfk filter "temp\temp.txt" -rep _" "__ -rep _"-"__ -rep _":"__ -write -yes>nul

set /p macaddress= <temp\temp.txt

::confirm 12 digits
if "%macaddress:~11%"=="" goto:badkey
if not "%macaddress:~12%"=="" goto:badkey


::confirm MAC addy is hex chars

echo.
echo Validating MAC address...
echo.

set digit=0

:confirmMACaddy

set /a digit=%digit%+1
set testme=
if /i "%digit%" EQU "1" set testme=%macaddress:~0,1%
if /i "%digit%" EQU "2" set testme=%macaddress:~1,1%
if /i "%digit%" EQU "3" set testme=%macaddress:~2,1%
if /i "%digit%" EQU "4" set testme=%macaddress:~3,1%
if /i "%digit%" EQU "5" set testme=%macaddress:~4,1%
if /i "%digit%" EQU "6" set testme=%macaddress:~5,1%
if /i "%digit%" EQU "7" set testme=%macaddress:~6,1%
if /i "%digit%" EQU "8" set testme=%macaddress:~7,1%
if /i "%digit%" EQU "9" set testme=%macaddress:~8,1%
if /i "%digit%" EQU "10" set testme=%macaddress:~9,1%
if /i "%digit%" EQU "11" set testme=%macaddress:~10,1%
if /i "%digit%" EQU "12" set testme=%macaddress:~11,1%

if "%testme%"=="" goto:quickskip

if /i "%testme%" EQU "0" goto:confirmMACaddy
if /i "%testme%" EQU "1" goto:confirmMACaddy
if /i "%testme%" EQU "2" goto:confirmMACaddy
if /i "%testme%" EQU "3" goto:confirmMACaddy
if /i "%testme%" EQU "4" goto:confirmMACaddy
if /i "%testme%" EQU "5" goto:confirmMACaddy
if /i "%testme%" EQU "6" goto:confirmMACaddy
if /i "%testme%" EQU "7" goto:confirmMACaddy
if /i "%testme%" EQU "8" goto:confirmMACaddy
if /i "%testme%" EQU "9" goto:confirmMACaddy
if /i "%testme%" EQU "a" goto:confirmMACaddy
if /i "%testme%" EQU "b" goto:confirmMACaddy
if /i "%testme%" EQU "c" goto:confirmMACaddy
if /i "%testme%" EQU "d" goto:confirmMACaddy
if /i "%testme%" EQU "e" goto:confirmMACaddy
if /i "%testme%" EQU "f" goto:confirmMACaddy

goto:badkey
:quickskip


::echo %macaddress%

if /i "%MENU1%" EQU "1" goto:WPAGE3
if /i "%MENU1%" EQU "2" goto:WPAGE3
if /i "%MENU1%" EQU "3" goto:WPAGE3
if /i "%MENU1%" EQU "4" goto:WPAGE3
if /i "%MENU1%" EQU "A" goto:WPAGE3

goto:WPAGE3D


:badkey
echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:macaddress








::...................................Wizard Page3D - Active IOSs...............................
:WPAGE3D
if /i "%AbstinenceWiz%" EQU "Y" goto:NEEKrevSelect
if /i "%MENU1%" EQU "H" goto:HACKMIISOLUTION
SET UpdatesIOSQ=

if /i "%ACTIVEIOS%" EQU "off" goto:WPAGE4
if /i "%Virgin%" EQU "N" goto:forceQ
if /i "%FIRMSTART%" LSS "4.3" goto:WPAGE4
if /i "%FIRMSTART%" EQU "o" goto:WPAGE4


::Only 4.3 Wii's without active IOS "ON" will make it this far
:forceQ

cls
echo                                        ModMii                                v%currentversion%
echo                                       by XFlak
echo.
echo.

if /i "%Virgin%" EQU "N" echo    Download active IOSs and some extra brick protection (patched System Menu IOSs)?
if /i "%Virgin%" NEQ "N" echo      Would you like to download active IOSs?

echo.
echo.
echo.
echo      N = No
echo.
if /i "%Virgin%" EQU "N" echo      If you previously used ModMii to fully softmod your Wii you should already
if /i "%Virgin%" EQU "N" echo      have these installed.
if /i "%FirmStart%" EQU "4.3" echo      You're on System Menu 4.3, so you likely already have the latest IOSs.
if /i "%FirmStart%" EQU "4.3" echo      If your Wii has truly never been modified before, you can say No.

echo.
echo.
echo      Y = Yes
echo.
echo      If your Wii has DarkCorp/cIOSCorp installed, you can say Yes to overwrite it.
echo      If original Wii discs or WiiWare are not working properly, say Yes to fix it.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo                B = Back
echo                M = Main Menu
echo.
echo.
echo.
echo.
set /p UpdatesIOSQ=     Enter Selection Here: 

if /i "%UpdatesIOSQ%" EQU "M" goto:MENU
if /i "%UpdatesIOSQ%" EQU "Y" goto:WPAGE4
if /i "%UpdatesIOSQ%" EQU "N" goto:WPAGE4


if /i "%VIRGIN%" EQU "N" goto:backtowpage3
::if /i "%REGION%" EQU "K" goto:backtowpage3
if /i "%exploit%" NEQ "W" goto:backtowpage3c


if /i "%UpdatesIOSQ%" EQU "B" goto:macaddress

:backtowpage3
if /i "%UpdatesIOSQ%" EQU "B" goto:WPAGE3

:backtowpage3c
if /i "%UpdatesIOSQ%" EQU "B" goto:WPAGE3c


echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:WPAGE3D











::...................................Wizard Page4 - New System Menu...............................
:WPAGE4
if /i "%MENU1%" EQU "H" goto:HACKMIISOLUTION
set FIRM=
cls
echo                                        ModMii                                v%currentversion%
echo                                       by XFlak
echo.
echo.
echo         Select the new System Menu you would like to upgrade/downgrade to.

if /i "%MENU1%" NEQ "RC" (echo.) & (echo.) & (echo.) & (echo   Note: if current system menu = new system menu, a system menu is not downloaded)
echo.
echo.
echo.
echo.
echo.
echo.


if /i "%FIRMSTART%" EQU "4.3" (support\sfk echo -spat \x20 \x20 \x20 \x20 \x20 \x20 \x20 [Green] 4.3 = 4.3 [RECOMMENDED]) else (echo                4.3 = 4.3)

if /i "%FIRMSTART%" EQU "4.2" (support\sfk echo -spat \x20 \x20 \x20 \x20 \x20 \x20 \x20 [Green] 4.2 = 4.2 [RECOMMENDED]) else (echo                4.2 = 4.2)

if /i "%FIRMSTART%" EQU "4.3" goto:SkipGreen4.1
if /i "%FIRMSTART%" EQU "4.2" goto:SkipGreen4.1

support\sfk echo -spat \x20 \x20 \x20 \x20 \x20 \x20 \x20 [Green] 4.1 = 4.1 [RECOMMENDED]
goto:skipWhite4.1


:SkipGreen4.1
echo                4.1 = 4.1

:skipWhite4.1


echo.
echo                B = Back
echo                M = Main Menu
echo.
echo.
echo.
echo.
set /p FIRM=     Enter Selection Here: 

if /i "%FIRM%" EQU "M" goto:MENU

if /i "%MENU1%" NEQ "RC" goto:notRC
if /i "%FIRM%" EQU "4.2" goto:WPAGE20
if /i "%FIRM%" EQU "4.1" goto:WPAGE20
if /i "%FIRM%" EQU "4.3" goto:WPAGE20
if /i "%FIRM%" EQU "B" goto:WPAGE3
:notRC


if /i "%FIRM%" EQU "4.2" goto:WPAGE5
if /i "%FIRM%" EQU "4.1" goto:WPAGE5
if /i "%FIRM%" EQU "4.3" goto:WPAGE5

if /i "%FIRM%" NEQ "B" goto:notback
if /i "%VIRGIN%" EQU "N" goto:noexploits
if /i "%FIRMSTART%" EQU "o" goto:wpage3c
if /i "%FIRMSTART%" NEQ "4.3" goto:wpage3
if /i "%ACTIVEIOS%" EQU "off" (goto:wpage3c) else (goto:WPAGE3D)
:noexploits
if /i "%ACTIVEIOS%" EQU "off" (goto:wpage3) else (goto:WPAGE3D)
:notback


echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:WPAGE4

::...................................Wizard Page5 - MORE Channels?...............................
:WPAGE5
set MORE=
set PIC=
set NET=
set Weather=
set NEWS=
set MIIQ=
set Shop=
set Speak=


if /i "%MENU1%" EQU "S" (set REGIONTEMP=%SNKREGION%) else (set REGIONTEMP=%REGION%)


cls
echo                                        ModMii                                v%currentversion%
echo                                       by XFlak
echo.
echo.
echo      Would you like to install any of the following channels:
echo.
echo.
echo.
echo           * Photo
if /i "%REGIONTEMP%" NEQ "K" echo           * Internet
if /i "%REGIONTEMP%" NEQ "K" echo           * Weather
if /i "%REGIONTEMP%" NEQ "K" echo           * News
echo           * Mii
echo           * Shopping
if /i "%REGIONTEMP%" NEQ "K" echo           * Wii Speak
echo.
echo.
echo.
echo                A = All
echo                S = Some
echo                N = None
echo.
echo                B = Back
echo                M = Main Menu
echo.
echo.
echo.
echo.
set /p MORE=     Enter Selection Here: 

if /i "%MORE%" EQU "M" goto:MENU

if /i "%MENU1%" EQU "S" goto:forsneeknand
if /i "%MORE%" EQU "B" goto:WPAGE4
if /i "%MORE%" EQU "N" goto:WPAGE13

:forsneeknand
if /i "%MORE%" NEQ "B" goto:notback
if /i "%SNEEKSELECT%" NEQ "5" goto:WPAGE20
if "%SMTHEMEAPP%"=="" (goto:SNKPAGE4c) else (goto:WPAGE20)
:notback


if /i "%MORE%" EQU "A" set B4SNKCONFIRM=WPAGE5
if /i "%MORE%" EQU "N" set B4SNKCONFIRM=WPAGE5
if /i "%MORE%" EQU "N" goto:SNKNANDCONFIRM

if /i "%MORE%" EQU "S" goto:WPAGE6
if /i "%MORE%" EQU "A" goto:WPAGE6

echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:WPAGE5




::...................................Wizard Page6 - Photo Channel...............................
:WPAGE6

if /i "%MORE%" EQU "A" set PIC=Y
if /i "%MORE%" EQU "A" goto:WPAGE7

set PIC=
cls
echo                                        ModMii                                v%currentversion%
echo                                       by XFlak
echo.
echo.
echo      Install the Photo Channel?
echo.
echo.
echo.
echo                Y = Yes
echo                N = No
echo.
echo                B = Back
echo                M = Main Menu
echo.
echo.
echo.
echo.
set /p PIC=     Enter Selection Here: 

if /i "%PIC%" EQU "Y" goto:WPAGE7
if /i "%PIC%" EQU "N" goto:WPAGE7
if /i "%PIC%" EQU "M" goto:MENU
if /i "%PIC%" EQU "B" goto:WPAGE5

echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:WPAGE6



::...................................Wizard Page7 - Internet?...............................
:WPAGE7

if /i "%REGIONTEMP%" EQU "K" goto:WPAGE10

if /i "%MORE%" EQU "A" set NET=Y
if /i "%MORE%" EQU "A" goto:WPAGE8

set NET=
cls
echo                                        ModMii                                v%currentversion%
echo                                       by XFlak
echo.
echo.
echo      Install the Internet Channel?
echo.
echo.
echo.
echo                Y = Yes
echo                N = No
echo.
echo                B = Back
echo                M = Main Menu
echo.
echo.
echo.
echo.
set /p NET=     Enter Selection Here: 

if /i "%NET%" EQU "Y" goto:WPAGE8
if /i "%NET%" EQU "N" goto:WPAGE8
if /i "%NET%" EQU "M" goto:MENU
if /i "%NET%" EQU "B" goto:WPAGE6

echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:WPAGE7



::...................................Wizard Page8 - Weather...............................
:WPAGE8

if /i "%MORE%" EQU "A" set Weather=Y
if /i "%MORE%" EQU "A" goto:WPAGE9

set Weather=

cls

echo                                        ModMii                                v%currentversion%
echo                                       by XFlak
echo.
echo.
echo      Install the Weather Channel?
echo.
echo.
echo.
echo                Y = Yes
echo                N = No
echo.
echo                B = Back
echo                M = Main Menu
echo.
echo.
echo.
echo.
set /p WEATHER=     Enter Selection Here: 

if /i "%WEATHER%" EQU "Y" goto:WPAGE9
if /i "%WEATHER%" EQU "N" goto:WPAGE9
if /i "%WEATHER%" EQU "M" goto:MENU
if /i "%WEATHER%" EQU "B" goto:WPAGE7

echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:WPAGE8

::...................................Wizard Page9 - NEWS...............................
:WPAGE9

if /i "%MORE%" EQU "A" set NEWS=Y
if /i "%MORE%" EQU "A" goto:WPAGE10

set NEWS=

cls

echo                                        ModMii                                v%currentversion%
echo                                       by XFlak
echo.
echo.
echo      Install the News Channel?
echo.
echo.
echo.
echo                Y = Yes
echo                N = No
echo.
echo                B = Back
echo                M = Main Menu
echo.
echo.
echo.
echo.
set /p NEWS=     Enter Selection Here: 

if /i "%NEWS%" EQU "Y" goto:WPAGE10
if /i "%NEWS%" EQU "N" goto:WPAGE10
if /i "%NEWS%" EQU "M" goto:MENU
if /i "%NEWS%" EQU "B" goto:WPAGE8

echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:WPAGE9

::...................................Wizard Page10 - Mii...............................
:WPAGE10

if /i "%MORE%" EQU "A" set MIIQ=Y
if /i "%MORE%" EQU "A" goto:WPAGE11

set MIIQ=

cls

echo                                        ModMii                                v%currentversion%
echo                                       by XFlak
echo.
echo.
echo      Install the Mii Channel?
echo.
echo.
echo.
echo                Y = Yes
echo                N = No
echo.
echo                B = Back
echo                M = Main Menu
echo.
echo.
echo.
echo.
set /p MIIQ=     Enter Selection Here: 

if /i "%MIIQ%" EQU "Y" goto:WPAGE11
if /i "%MIIQ%" EQU "N" goto:WPAGE11
if /i "%MIIQ%" EQU "M" goto:MENU

if /i "%REGIONTEMP%" EQU "K" goto:Koreanbacktophoto
if /i "%MIIQ%" EQU "B" goto:WPAGE9

:Koreanbacktophoto
if /i "%MIIQ%" EQU "B" goto:WPAGE6

echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:WPAGE10

::...................................Wizard Page11 - Shop...............................
:WPAGE11

if /i "%MORE%" EQU "A" set Shop=Y
if /i "%MORE%" EQU "A" goto:WPAGE12

set Shop=

cls

echo                                        ModMii                                v%currentversion%
echo                                       by XFlak
echo.
echo.
echo      Install the Shopping Channel?
if /i "%MENU1%" NEQ "S" echo.
if /i "%MENU1%" NEQ "S" echo.
if /i "%MENU1%" NEQ "S" echo.
if /i "%MENU1%" NEQ "S" echo          Note: IOS56 will also be downloaded
echo.
echo.
echo.
echo                Y = Yes
echo                N = No
echo.
echo                B = Back
echo                M = Main Menu
echo.
echo.
echo.
echo.
set /p SHOP=     Enter Selection Here: 

if /i "%Shop%" EQU "Y" goto:WPAGE12
if /i "%Shop%" EQU "N" goto:WPAGE12
if /i "%Shop%" EQU "M" goto:MENU
if /i "%Shop%" EQU "B" goto:WPAGE10

echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:WPAGE11


::...................................Wizard Page12 - Speak...............................
:WPAGE12
if /i "%REGIONTEMP%" EQU "K" goto:WPAGE13

if /i "%MORE%" EQU "A" set Speak=Y
if /i "%MORE%" EQU "A" goto:WPAGE13

set Speak=

cls

echo                                        ModMii                                v%currentversion%
echo                                       by XFlak
echo.
echo.
echo      Install the Wii Speak Channel?
echo.
echo.
echo.
echo                Y = Yes
echo                N = No
echo.
echo                B = Back
echo                M = Main Menu
echo.
echo.
echo.
echo.
set /p Speak=     Enter Selection Here: 

if /i "%Speak%" EQU "Y" goto:WPAGE13
if /i "%Speak%" EQU "N" goto:WPAGE13
if /i "%Speak%" EQU "M" goto:MENU
if /i "%Speak%" EQU "B" goto:WPAGE11

echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:WPAGE12



::...................................Wizard Page13 - MORE Advanced Channels?...............................
:WPAGE13
if /i "%VIRGIN%" EQU "Y" goto:WPAGE20
if /i "%MENU1%" EQU "S" set B4SNKCONFIRM=WPAGE12
if /i "%MORE%" EQU "A" set B4SNKCONFIRM=WPAGE5
if /i "%MENU1%" EQU "S" goto:SNKNANDCONFIRM

set Advanced=
set HMInstaller=
set RECCIOS=
set yawmQ=
set PRIQ=
set IOS236InstallerQ=
set ThemeSelection=N
cls
echo                                        ModMii                                v%currentversion%
echo                                       by XFlak
echo.
echo.
echo      Would you like to install and\or update any of the following:
echo.
echo.
echo.
echo           * Homebrew Channel and\or BootMii
echo.

if /i "%CMIOSOPTION%" EQU "on" (echo           * Recommended cIOSs and cMIOS) else (echo           * Recommended cIOSs)


echo.
echo           * Yet Another Wad Manager Mod (YAWMM)
echo.
echo           * IOS236
echo.
echo           * Priiloader v0.7 (or system menu hacks)
echo.
echo           * A System Menu Theme
echo.
echo           * USB-Loader
echo.
echo.
echo                Y = Yes
echo                N = No
echo.
echo                B = Back
echo                M = Main Menu
echo.
echo.
echo.
echo.
set /p Advanced=     Enter Selection Here: 

if /i "%Advanced%" EQU "M" goto:MENU

if /i "%MORE%" EQU "N" goto:BACK2MORE
if /i "%MORE%" EQU "A" goto:BACK2MORE

if /i "%REGIONTEMP%" EQU "K" goto:BACK2WPAGE11
if /i "%Advanced%" EQU "B" goto:WPAGE12

:BACK2MORE
if /i "%Advanced%" EQU "B" goto:WPAGE5

:BACK2WPAGE11
if /i "%Advanced%" EQU "B" goto:WPAGE11

if /i "%Advanced%" EQU "Y" goto:WPAGE13B
if /i "%Advanced%" EQU "N" goto:WPAGELAST

echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:WPAGE13


::...................................Wizard Page13B - HAckMii Installer...............................
:WPAGE13B


set HMInstaller=

cls

echo                                        ModMii                                v%currentversion%
echo                                       by XFlak
echo.
echo.
echo      Would you like to install and\or update the Homebrew Channel and\or BootMii?
echo.
echo      Note: This will download the HackMii Installer and IOS58
echo.
echo.
echo.
echo      For an instructional video on checking your HBC version enter "Help"
echo.
echo.


::echo      This will download the following files:
::echo      ---------------------------------------
::echo.
::echo      * HackMii Installer
::if /i "%FIRMSTART%" EQU "o" echo      * All available exploits
::if /i "%FIRMSTART%" EQU "3.X" echo      * BannerBomb v1
::if /i "%FIRMSTART%" EQU "4.0" echo      * BannerBomb v1
::if /i "%FIRMSTART%" EQU "4.1" echo      * BannerBomb v1
::if /i "%FIRMSTART%" EQU "4.2" echo      * BannerBomb v2
::if /i "%FIRMSTART%" EQU "4.3" echo      * All available exploits
::echo      * IOS58
::if /i "%FIRMSTART%" EQU "4.3" (echo.) & (echo      Note: Letterbomb exploit available here - http://please.hackmii.com)

echo.
echo.
echo.
echo.
echo.
echo.
echo                Y = Yes
echo                N = No
echo.
echo                B = Back
echo                M = Main Menu
echo.
echo.
echo.
echo.
set /p HMInstaller=     Enter Selection Here: 

if /i "%HMInstaller%" EQU "Y" goto:WPAGE14
if /i "%HMInstaller%" EQU "N" goto:WPAGE14
if /i "%HMInstaller%" EQU "M" goto:MENU
if /i "%HMInstaller%" EQU "B" goto:WPAGE13


if /i "%HMInstaller%" NEQ "Help" goto:nohelp
start /D SUPPORT HBCIOS.html
goto:WPAGE13B
:nohelp


echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:WPAGE13B


::...................................Wizard Page14 - cIOSs and cMIOSs...............................
:WPAGE14
set RECCIOS=

set d2x-beta-rev=8-final
if exist support\d2x-beta\d2x-beta.bat call support\d2x-beta\d2x-beta.bat

cls

echo                                        ModMii                                v%currentversion%
echo                                       by XFlak
echo.
echo.
if /i "%CMIOSOPTION%" EQU "on" (echo      Would you like to update to the following recommended cIOSs and cMIOS?) else (echo      Would you like to update to the following recommended cIOSs?)
echo.
echo.
echo.
echo          *cIOS202[60]-v5.1R.wad
echo.
echo          *cIOS222[38]-v4.wad
echo.
echo          *cIOS223[37-38]-v4.wad
echo.
echo          *cIOS224[57]-v5.1R.wad
echo.
echo          *cIOS249[56]-d2x-v%d2x-beta-rev%.wad
echo.
echo          *cIOS250[57]-d2x-v%d2x-beta-rev%.wad
echo.
if /i "%CMIOSOPTION%" EQU "off" goto:quickskip
echo          *RVL-cMIOS-v65535(v10)_WiiGator_WiiPower_v0.2.wad
:quickskip
echo.
echo.
echo.
echo                Y = Yes
echo                N = No
echo.
echo                B = Back
echo                M = Main Menu
echo.
echo.
echo.
echo.
set /p RECCIOS=     Enter Selection Here: 

if /i "%RECCIOS%" EQU "Y" goto:WPAGE17
if /i "%RECCIOS%" EQU "N" goto:WPAGE17
if /i "%RECCIOS%" EQU "M" goto:MENU


if /i "%RECCIOS%" EQU "B" goto:WPAGE13B

echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:WPAGE14

::...................................Wizard Page15 and 16 removed...............................


::...................................Wizard Page17 - YAWMM...............................
:WPAGE17
set yawmQ=

cls

echo                                        ModMii                                v%currentversion%
echo                                       by XFlak
echo.
echo.
echo      Download Yet Another Wad Manager Mod (YAWMM)?
echo.
echo.
echo.
echo      Note: Other Wad Managers may not be compatible with cIOSs with non-IOS38 base
echo            If you're not using YAWMM as your main wad manager, you're missing out.
echo.
echo.
echo.
echo                Y = Yes
echo                N = No
echo.
echo                B = Back
echo                M = Main Menu
echo.
echo.
echo.
echo.
set /p yawmQ=     Enter Selection Here: 

if /i "%yawmQ%" EQU "Y" goto:WPAGE18
if /i "%yawmQ%" EQU "N" goto:WPAGE18
if /i "%yawmQ%" EQU "M" goto:MENU
if /i "%yawmQ%" EQU "B" goto:WPAGE14

echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:WPAGE17


::...................................Wizard Page18 - IOS236 Installer...............................
:WPAGE18
set IOS236InstallerQ=
cls
echo                                        ModMii                                v%currentversion%
echo                                       by XFlak
echo.
echo.
echo      Would you like to install IOS236?
echo.
echo.
echo.
echo.
echo      Note: IOS236 is used to install other things, like WADs, Priiloader, etc.
echo.
echo.
echo.
echo.
echo.
echo                Y = Yes
echo                N = No
echo.
echo                B = Back
echo                M = Main Menu
echo.
echo.
echo.
echo.
set /p IOS236InstallerQ=     Enter Selection Here: 

if /i "%IOS236InstallerQ%" EQU "Y" goto:WPAGE19
if /i "%IOS236InstallerQ%" EQU "N" goto:WPAGE19
if /i "%IOS236InstallerQ%" EQU "M" goto:MENU
if /i "%IOS236InstallerQ%" EQU "B" goto:WPAGE17



echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:WPAGE18

::...................................Wizard Page19 - Priiloader...............................
:WPAGE19
set PRIQ=

cls

echo                                        ModMii                                v%currentversion%
echo                                       by XFlak
echo.
echo.
echo      Would you like to install and\or update Priiloader (or system menu hacks)?
echo.
echo.
echo.
echo.
echo.
echo.
echo                Y = Yes
echo                N = No
echo.
echo                B = Back
echo                M = Main Menu
echo.
echo.
echo.
echo.

set /p PRIQ=     Enter Selection Here: 

if /i "%PRIQ%" EQU "Y" goto:WPAGE20
if /i "%PRIQ%" EQU "N" goto:WPAGE20
if /i "%PRIQ%" EQU "M" goto:MENU

if /i "%PRIQ%" EQU "B" goto:WPAGE18

echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:WPAGE19






::...................................Wizard Page20 - Theme Selection...............................
:WPAGE20
set ThemeSelection=

if /i "%SNEEKSELECT%" NEQ "5" goto:nocheck
if "%SMTHEMEAPP%"=="" goto:WPAGE5
:nocheck

cls

echo                                        ModMii                                v%currentversion%
echo                                       by XFlak
echo.
echo.

if /i "%MENU1%" NEQ "S" goto:quickskip
if /i "%SNEEKSELECT%" EQU "5" (echo                                EMULATED NAND MODIFIER) else (echo                                 EMULATED NAND BUILDER)
echo.
echo.
:quickskip

echo      Would you like to install a custom Theme on your Wii?
echo.
echo.
echo         WWW = View All Available Themes on Youtube
echo.
echo.
echo          CE = Channel Effect for custom system menu themes: %effect%
echo               * Choose from 3 effects: No-Spin, Spin and Fast-Spin
echo.
echo.
echo.
echo                R = DarkWii Red Theme - %effect%
echo.
echo                G = DarkWii Green Theme - %effect%
echo.
echo               BL = DarkWii Blue Theme - %effect%
echo.
echo                O = DarkWii Orange Theme - %effect%
echo.
echo.
if /i "%SNEEKSELECT%" EQU "5" (echo                N = No, do not change the theme) else (echo                N = No, I want the same old boring, boring System Menu)
echo.
if /i "%SNEEKSELECT%" EQU "5" echo.
if /i "%SNEEKSELECT%" EQU "5" echo                D = Default Theme (restore original theme to the Emulated NAND)
echo.
echo.
echo.
echo.
echo                B = Back
echo.
echo                M = Main Menu
echo.
echo.
echo.
echo.
set /p ThemeSelection=     Enter Selection Here: 

if /i "%ThemeSelection%" EQU "M" goto:MENU


if /i "%ThemeSelection%" NEQ "WWW" goto:novid
start /D SUPPORT WiiThemes.html
goto:WPAGE20
:novid


if /i "%ThemeSelection%" EQU "CE" goto:OptionCEwizard


if /i "%MENU1%" NEQ "RC" goto:notRC
set BACKB4DRIVE=WPAGE20
if /i "%ThemeSelection%" EQU "R" goto:DriveChange
if /i "%ThemeSelection%" EQU "G" goto:DriveChange
if /i "%ThemeSelection%" EQU "BL" goto:DriveChange
if /i "%ThemeSelection%" EQU "O" goto:DriveChange
if /i "%ThemeSelection%" EQU "N" goto:DriveChange
if /i "%ThemeSelection%" EQU "B" goto:WPAGE4
:notRC

if /i "%MENU1%" EQU "S" goto:forsneeknand
if /i "%ThemeSelection%" EQU "R" goto:WPAGE21
if /i "%ThemeSelection%" EQU "G" goto:WPAGE21
if /i "%ThemeSelection%" EQU "BL" goto:WPAGE21
if /i "%ThemeSelection%" EQU "O" goto:WPAGE21
if /i "%ThemeSelection%" EQU "N" goto:WPAGE21

:forsneeknand
::if /i "%SNEEKSELECT%" EQU "5" goto:quickskip
if /i "%MENU1%" NEQ "S" goto:quickskip
if /i "%ThemeSelection%" EQU "B" goto:SNKPAGE5
:quickskip

if /i "%ThemeSelection%" EQU "R" goto:WPAGE5
if /i "%ThemeSelection%" EQU "G" goto:WPAGE5
if /i "%ThemeSelection%" EQU "BL" goto:WPAGE5
if /i "%ThemeSelection%" EQU "O" goto:WPAGE5
if /i "%ThemeSelection%" EQU "N" goto:WPAGE5

if /i "%SNEEKSELECT%" NEQ "5" goto:miniskip
if /i "%ThemeSelection%" EQU "D" goto:WPAGE5
if /i "%ThemeSelection%" EQU "B" goto:SNKPAGE4c
:miniskip

if /i "%Advanced%" EQU "Y" goto:Back2PRI
if /i "%Advanced%" EQU "N" goto:Back2Advanced2
if /i "%MORE%" EQU "N" goto:Back2MORE2
if /i "%MORE%" EQU "A" goto:Back2MORE2
if /i "%REGIONTEMP%" EQU "K" goto:Back2SHOP2
if /i "%MORE%" EQU "S" goto:Back2Speak2


:BACK2PRI
if /i "%ThemeSelection%" EQU "B" goto:WPAGE19

:BACK2ADVANCED2
if /i "%ThemeSelection%" EQU "B" goto:WPAGE13

:BACK2SPEAK2
if /i "%ThemeSelection%" EQU "B" goto:WPAGE12

:Back2SHOP2
if /i "%ThemeSelection%" EQU "B" goto:WPAGE11

:BACK2MORE2
if /i "%ThemeSelection%" EQU "B" goto:WPAGE5


echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:WPAGE20

:OptionCEwizard
if /i "%effect%" EQU "no-spin" (set effect=Spin) & (support\sfk filter Support\settings.bat -!"Set effect=" -write -yes>nul) & (echo Set effect=Spin>>Support\settings.bat) & (goto:WPAGE20)
if /i "%effect%" EQU "spin" (set effect=Fast-Spin) & (support\sfk filter Support\settings.bat -!"Set effect=" -write -yes>nul) & (echo Set effect=Fast-Spin>>Support\settings.bat) & (goto:WPAGE20)
if /i "%effect%" EQU "fast-spin" (set effect=No-Spin) & (support\sfk filter Support\settings.bat -!"Set effect=" -write -yes>nul) & (echo Set effect=No-Spin>>Support\settings.bat) & (goto:WPAGE20)

::...................................Wizard Page21 - USB Loader Setup Q...............................
:WPAGE21
set USBGUIDE=

cls

echo                                        ModMii                                v%currentversion%
echo                                       by XFlak
echo.
echo.
echo      Would you like to set up a USB-Loader now?
echo.
echo.
echo      Notes
echo      =====
echo.
echo      * A USB-Loader allows the Wii to play games off an external Hard Drive.
echo.
echo      * This step can always be done by itself later on from ModMii's Main Menu.
echo.
echo.
echo.
echo.
echo.
echo                Y = Yes
echo                N = No
echo.
echo                B = Back
echo                M = Main Menu
echo.
echo.
echo.
echo.
set /p USBGUIDE=     Enter Selection Here: 

if /i "%USBGUIDE%" EQU "M" goto:MENU

if /i "%USBGUIDE%" EQU "B" goto:WPAGE20
if /i "%USBGUIDE%" EQU "Y" goto:UPAGE1
if /i "%USBGUIDE%" EQU "N" goto:WPAGELAST

echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:WPAGE21


::...................................Wizard Last Page - Confirmation...............................
:WPAGELAST

set WLAST=

cls
echo                                        ModMii                                v%currentversion%
echo                                       by XFlak
echo.
echo.
echo      Are these settings correct?
echo.
echo.
echo.
if /i "%VIRGIN%" EQU "Y" echo           * Install and\or update all recommended softmods
if /i "%FIRMSTART%" NEQ "o" echo           * Current System Menu is %FIRMSTART%%REGION%
if /i "%FIRMSTART%" EQU "o" echo           * Current System Menu is less than 2.2%REGION%

echo           * Desired System Menu is %FIRM%%REGION%

if /i "%Exploit%" EQU "W" (echo.) & (echo           * MAC Address: %macaddress%)

echo.
if /i "%PIC%" EQU "Y" echo           * Install the Photo Channel
if /i "%NET%" EQU "Y" echo           * Install the Internet Channel
if /i "%WEATHER%" EQU "Y" echo           * Install the Weather Channel
if /i "%NEWS%" EQU "Y" echo           * Install the News Channel
if /i "%MIIQ%" EQU "Y" echo           * Install the Mii Channel
if /i "%Shop%" EQU "Y" echo           * Install the Shopping Channel (and IOS56)
if /i "%Speak%" EQU "Y" echo           * Install the Wii Speak Channel
echo.

if /i "%HMInstaller%" EQU "Y" echo           * Install and\or update the Homebrew Channel and BootMii


if /i "%RECCIOS%" NEQ "Y" goto:smallskip
if /i "%CMIOSOPTION%" EQU "on" (echo           * Install and\or update recommended cIOSs and cMIOS) else (echo           * Install and\or update recommended cIOSs)
:smallskip

if /i "%yawmQ%" EQU "Y" echo           * Download Yet Another Wad Manager Mod (YAWMM)
if /i "%IOS236InstallerQ%" EQU "Y" echo           * Install IOS236


if /i "%PRIQ%" EQU "Y" echo           * Install and\or update Priiloader

if /i "%ThemeSelection%" EQU "R" echo           * Install Dark Wii Red Theme
if /i "%ThemeSelection%" EQU "G" echo           * Install Dark Wii Green Theme
if /i "%ThemeSelection%" EQU "BL" echo           * Install Dark Wii Blue Theme
if /i "%ThemeSelection%" EQU "O" echo           * Install Dark Wii Orange Theme
::---------
if /i "%USBGUIDE%" NEQ "Y" goto:skipusb
echo.

if /i "%FORMAT%" EQU "1" set FORMATNAME=FAT32
if /i "%FORMAT%" EQU "2" set FORMATNAME=NTFS
if /i "%FORMAT%" EQU "3" set FORMATNAME=Part FAT32 and Part NTFS
if /i "%FORMAT%" EQU "4" set FORMATNAME=WBFS
if /i "%FORMAT%" EQU "5" set FORMATNAME=Part FAT32 and Part WBFS

if /i "%FORMAT%" EQU "4" goto:skip
if /i "%FORMAT%" EQU "5" goto:skip
echo           * External Hard Drive to be Formatted as %FORMATNAME%
goto:skip2
:skip
echo           * External Hard Drive already Formatted as %FORMATNAME%
:skip2

if /i "%LOADER%" EQU "CFG" echo           * Download Configurable USB-Loader
if /i "%LOADER%" EQU "FLOW" echo           * Download WiiFlow
if /i "%LOADER%" EQU "ALL" echo           * Download Configurable USB-Loader and WiiFlow
if /i "%USBCONFIG%" EQU "USB" echo           * USB-Loader Settings and config files saved to USB Hard Drive
if /i "%USBCONFIG%" NEQ "USB" echo           * USB-Loader Settings and config files saved to SD Card


:skipusb


echo.
echo.
echo.
if /i "%LoadWizSettings%" EQU "Y" goto:skip
echo                S = Save Wizard Settings For Future Use
if exist Wizard_Settings.bat echo                    Existing Wizard_Settings.bat will be renamed
echo.
:skip
echo                Y = Yes
::echo                N = No \ Main Menu
echo.
echo                B = Back
echo                M = Main Menu
echo.
echo.
echo.
echo.
set /p WLAST=     Enter Selection Here: 

if /i "%LoadWizSettings%" EQU "Y" goto:skip
if /i "%WLAST%" EQU "S" goto:SaveWizardSettings
:skip
if /i "%WLAST%" EQU "Y" set BACKB4DRIVE=WPAGELAST
if /i "%WLAST%" EQU "Y" goto:DriveChange
::if /i "%WLAST%" EQU "N" goto:Menu
if /i "%WLAST%" EQU "M" goto:MENU

if /i "%Advanced%" EQU "N" goto:Back2Advanced
if /i "%Advanced%" EQU "Y" goto:Back2USB
if /i "%MORE%" EQU "N" goto:Back2USB
if /i "%MORE%" EQU "S" goto:Back2USB
if /i "%USBGUIDE%" EQU "Y" goto:backtoUpage2

:BACK2ADVANCED
if /i "%WLAST%" EQU "B" goto:WPAGE13

:BACK2SPEAK
if /i "%WLAST%" EQU "B" goto:WPAGE12

:Back2USB
if /i "%WLAST%" EQU "B" goto:WPAGE21

:backtoUpage2
if /i "%WLAST%" EQU "B" goto:UPAGE2

echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:WPAGELAST



::-------------Save Wizard Settings:-------------------
:SaveWizardSettings

cls
echo                                        ModMii                                v%currentversion%
echo                                       by XFlak
echo.

set countwiz=0

:renameWIZARDsettings
if not exist Wizard_Settings.bat goto:skip
SET /a countwiz=%countwiz%+1
if exist Wizard_Settings%countwiz%.bat goto:renameWIZARDsettings
move Wizard_Settings.bat Wizard_Settings%countwiz%.bat
:skip


echo ::ModMii v%currentversion% - Wizard Settings - %DATE% - %TIME% >> Wizard_Settings.bat
echo set VIRGIN=%VIRGIN%>> Wizard_Settings.bat
echo set REGION=%REGION%>> Wizard_Settings.bat
echo set FIRMSTART=%FIRMSTART%>> Wizard_Settings.bat
echo set FIRM=%FIRM%>> Wizard_Settings.bat
echo set PIC=%PIC%>> Wizard_Settings.bat
echo set NET=%NET%>> Wizard_Settings.bat
echo set WEATHER=%WEATHER%>> Wizard_Settings.bat
echo set NEWS=%NEWS%>> Wizard_Settings.bat
echo set MIIQ=%MIIQ%>> Wizard_Settings.bat
echo set Shop=%Shop%>> Wizard_Settings.bat
echo set Speak=%Speak%>> Wizard_Settings.bat
echo set HMInstaller=%HMInstaller%>> Wizard_Settings.bat
echo set yawmQ=%yawmQ%>> Wizard_Settings.bat
echo set IOS236InstallerQ=%IOS236InstallerQ%>> Wizard_Settings.bat
echo set PRIQ=%PRIQ%>> Wizard_Settings.bat
echo set ThemeSelection=%ThemeSelection%>> Wizard_Settings.bat
echo set EXPLOIT=%EXPLOIT%>> Wizard_Settings.bat
echo set MORE=%MORE%>> Wizard_Settings.bat
echo set ADVANCED=%ADVANCED%>> Wizard_Settings.bat
echo set UpdatesIOSQ=%UpdatesIOSQ%>> Wizard_Settings.bat
echo set RECCIOS=%RECCIOS%>> Wizard_Settings.bat

echo set USBGUIDE=%USBGUIDE%>> Wizard_Settings.bat
echo set UPAGE1=%UPAGE1%>> Wizard_Settings.bat
echo set LOADER=%LOADER%>> Wizard_Settings.bat
echo set USBCONFIG=%USBCONFIG%>> Wizard_Settings.bat



if exist Wizard_Settings.bat echo                                 Wizard Settings Saved.
@ping 127.0.0.1 -n 2 -w 1000> nul

goto:WPAGELAST

::...................................USB-Loader Setup Page1 - Format?...............................
:UPAGE1
set FORMAT=NONE
cls
echo                                        ModMii                                v%currentversion%
echo                                       by XFlak
echo.
echo         How would you like your external Hard Drive Formatted?
echo.



if /i "%AbstinenceWiz%" NEQ "Y" goto:NotAbstinenceWiz
echo.
echo        1 = FAT32
echo.
echo        2 = Partioned partially as FAT32 and partially as NTFS
echo.
goto:skip
:NotAbstinenceWiz



support\sfk echo -spat \x20 \x20 \x20 [Green] 1 = FAT32 (RECOMMENDED)
echo.
support\sfk echo -spat \x20 \x20 \x20 \x20 \x20 [Green] Pros:[def] The Wii can access apps, games, covers and music stored on FAT32
echo                  Ideal if you don't always have an SD card to launch the USB-Loader
echo                  Compatible with SNEEK/Triiforce Nand Emulation.
echo.
support\sfk echo -spat \x20 \x20 \x20 \x20 \x20 [Red] Cons:[def] Cannot store files greater than 4GBs. The limit does not apply
echo                  to Wii games, which can be split into parts. This will likely not
echo                  affect you unless the drive is also used to store high-def videos
echo.
echo.
echo        2 = NTFS
echo.
support\sfk echo -spat \x20 \x20 \x20 \x20 \x20 [Green] Pros:[def] Capable of storing files greater than 4GB
echo                  CFG USB-Loader can access games, covers and music stored on NTFS
echo.
support\sfk echo -spat \x20 \x20 \x20 \x20 \x20 [Red] Cons:[def] The Wii cannot access apps stored on NTFS, so an SD card
echo                  is required to run the USB-Loader (or a SM Channel)
echo                  Incompatible with SNEEK/Triiforce Nand Emulation.
echo.
echo.
echo        3 = Partioned partially as FAT32 and partially as NTFS
echo.
echo            Note: Small flash drives cannot be partitioned
echo.
support\sfk echo -spat \x20 \x20 \x20 \x20 \x20 [Green] Pros:[def] You can access Wii apps on the FAT32 partition while still
echo                  being able to save files greater than 4GBs on the NTFS partition
echo.
support\sfk echo -spat \x20 \x20 \x20 \x20 \x20 [Red] Cons:[def] A little more work to setup than the other options
echo.
echo.
echo        4 = Drive is currently formatted as WBFS and I don't want to change
echo.
support\sfk echo -spat \x20 \x20 \x20 \x20 \x20 [Red] Cons:[def] WBFS can ONLY be read by the Wii and ONLY used to store Wii Games
echo.
echo.
echo        5 = Drive is currently partitioned as FAT32/WBFS and I don't want to change
echo.
support\sfk echo -spat \x20 \x20 \x20 \x20 \x20 [Red] Cons:[def] WBFS can ONLY be read by the Wii and ONLY used to store Wii Games

:skip
echo.
echo.
echo         B = Back
echo.
echo         M = Main Menu
echo.
set /p FORMAT=     Enter Selection Here: 

if /i "%FORMAT%" EQU "M" goto:MENU



if /i "%AbstinenceWiz%" NEQ "Y" goto:NotAbstinenceWiz
if /i "%FORMAT%" EQU "B" goto:SNKPAGE2
if /i "%FORMAT%" EQU "1" (set BACKB4DRIVE=UPAGE1) & (goto:DriveChange)
if /i "%FORMAT%" EQU "2" (set FORMAT=3) & (set BACKB4DRIVE=UPAGE1) & (goto:DriveChange)
goto:badkey
:NotAbstinenceWiz


if /i "%MENU1%" EQU "W" goto:skip
if /i "%FORMAT%" EQU "B" goto:MENU
:skip
if /i "%FORMAT%" EQU "B" goto:WPAGE21

if /i "%FORMAT%" EQU "1" set f32=*
if /i "%FORMAT%" EQU "3" set f32=*

if /i "%FORMAT%" EQU "1" goto:UPAGE1b
if /i "%FORMAT%" EQU "2" goto:UPAGE1b
if /i "%FORMAT%" EQU "3" goto:UPAGE1b
if /i "%FORMAT%" EQU "4" goto:UPAGE1b
if /i "%FORMAT%" EQU "5" goto:UPAGE1b

:badkey
echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:UPAGE1



::...................................USB-Loader Setup Page1b - Loader?...............................
:UPAGE1b
set LOADER=
set usbfolder=
set FLOW=
cls
echo                                        ModMii                                v%currentversion%
echo                                       by XFlak
echo.
echo         What USB-Loader would you like to use?
echo.
echo.
echo.
support\sfk echo -spat \x20 \x20 \x20 [Green] 1 = Configurable USB-Loader (RECOMMENDED)
echo.
echo.
echo        2 = WiiFlow
echo.
echo.
echo        3 = Both
echo.
echo.
echo.
echo.
echo         B = Back
echo.
echo         M = Main Menu
echo.
echo.
echo.
set /p LOADER=     Enter Selection Here: 

if /i "%LOADER%" EQU "M" goto:MENU
if /i "%LOADER%" EQU "B" goto:UPAGE1

set wbm=*

if /i "%LOADER%" EQU "1" set LOADER=CFG
if /i "%LOADER%" EQU "2" set LOADER=FLOW
if /i "%LOADER%" EQU "3" set LOADER=ALL

if /i "%LOADER%" EQU "CFG" set usbfolder=*
if /i "%LOADER%" EQU "ALL" set usbfolder=*
if /i "%LOADER%" EQU "FLOW" set FLOW=*
if /i "%LOADER%" EQU "ALL" set FLOW=*

if /i "%LOADER%" EQU "CFG" goto:nextstep
if /i "%LOADER%" EQU "FLOW" goto:nextstep
if /i "%LOADER%" NEQ "ALL" goto:skip

:nextstep
if /i "%FORMAT%" EQU "1" goto:UPAGE2
if /i "%FORMAT%" EQU "2" set BACKB4DRIVE=UPAGE1b
if /i "%FORMAT%" EQU "2" goto:DriveChange
if /i "%FORMAT%" EQU "3" goto:UPAGE2
if /i "%FORMAT%" EQU "4" set BACKB4DRIVE=UPAGE1b
if /i "%FORMAT%" EQU "4" goto:DriveChange
if /i "%FORMAT%" EQU "5" goto:UPAGE2
:skip

echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:UPAGE1b



::...................................USB-Loader Setup Page2 - Config on USB vs SD?...............................
:UPAGE2
set USBCONFIG=
cls
echo                                        ModMii                                v%currentversion%
echo                                       by XFlak
echo.
echo.
echo        Where would you like to save your USB-Loader app, covers and config files?
echo.
echo.
support\sfk echo -spat \x20 \x20 \x20 [Green] USB = USB (RECOMMENDED)[def] (Files saved to "COPY_TO_USB")
echo.
support\sfk echo -spat \x20 \x20 \x20 \x20 \x20 [Green] Pros:[def] SD Card not required to launch USB-Loader
echo                  USB-Loader files take up a small %% of USB Hard Drive free space
echo.
support\sfk echo -spat \x20 \x20 \x20 \x20 \x20 [Red] Cons:[def] Slightly slower loading time (almost negligible)
echo.
echo.
echo.
echo         SD = SD (Files saved to "%DRIVE%")
echo.
support\sfk echo -spat \x20 \x20 \x20 \x20 \x20 [Green] Pros:[def] Slightly faster loading time (almost negligible)
echo.
support\sfk echo -spat \x20 \x20 \x20 \x20 \x20 [Red] Cons:[def] Cannot launch the USB-Loader without SD Card
echo                  USB-Loader files can take up a large %% of SD Card free space
echo.
echo.
echo.
echo.
echo         B = Back
echo.
echo         M = Main Menu
echo.
echo.
echo.
echo.
set /p USBCONFIG=     Enter Selection Here: 

if /i "%USBCONFIG%" EQU "B" goto:UPAGE1b
if /i "%USBCONFIG%" EQU "M" goto:MENU


::if using wizard+usb-loader setup, set up both drive letters
if /i "%MENU1%" NEQ "W" goto:skip
if /i "%USBCONFIG%" EQU "USB" set BACKB4DRIVE=WPAGELAST
if /i "%USBCONFIG%" EQU "USB" set BACKB4DRIVEU=DRIVECHANGE
if /i "%USBCONFIG%" EQU "USB" goto:WPAGELAST

if /i "%USBCONFIG%" EQU "SD" set BACKB4DRIVE=UPAGE2
if /i "%USBCONFIG%" EQU "SD" goto:WPAGELAST
:skip

if /i "%USBCONFIG%" EQU "USB" set DRIVETEMP=%DRIVE%
if /i "%USBCONFIG%" EQU "USB" set BACKB4DRIVEU=UPAGE2
if /i "%USBCONFIG%" EQU "USB" goto:DRIVEUCHANGE


if /i "%USBCONFIG%" EQU "SD" set BACKB4DRIVE=UPAGE2
if /i "%USBCONFIG%" EQU "SD" goto:DriveChange


echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:UPAGE2



::...................................SNEEK Page1 - SNEEK SELECT...............................
:SNKPAGE1
set SNEEKSELECT=
set SNKS2U=
set PRIIFOUND=
cls
echo                                        ModMii                                v%currentversion%
echo                                       by XFlak
echo.
echo.
echo         Which of the following SNEEK Actions would you like to perform?
echo.
echo.
echo.
echo                1 = SNEEK Installation
echo.
echo                2 = Emulated NAND Builder (for SNEEK)
echo.
echo                3 = All the above (Recommended for first time SNEEK users)
echo.
echo.
echo                4 = Game Bulk Extractor (for SNEEK)
echo                    * Supported formats include ISO, CISO and WBFS files
echo.
echo.
echo                5 = Emulated NAND Modifer
echo                    * Edit your existing Emulated NAND
echo.
echo   Requirements:
echo.
echo         * If you don't have BootMii installed in order to run SNEEK you will
echo           have to first use the ModMii Wizard or the Abstinence Wizard.
echo.
echo         * To optimize the speed of your SNEEK or SNEEK+DI emulated nand,
echo           your SD card should be formatted using 32KB sector sizes.
echo.
echo         * UNEEK and UNEEK+DI require the External Hard Drive be formatted 
echo           as FAT32 using cluster sizes 32KB or lower. If you don't know how to
echo           format your drive this way, run ModMii's USB-Loader Setup.
echo.
echo         * SNEEK+DI and UNEEK+DI always uses the 1st partition if multiple are found.
echo.
echo.

if /i "%neek2o%" EQU "on" (set neekURL=tinyurl.com/neeek2o) else (set neekURL=http://code.google.com/p/sneek)


support\sfk echo -spat \x20 \x20 \x20 \x20 [Red] WARNING: SNEEK is not directly supported by ModMii.
echo.
support\sfk echo -spat \x20 \x20 \x20 \x20 [Red] Any problems you have with SNEEK that are not a direct result
support\sfk echo -spat \x20 \x20 \x20 \x20 [Red] of ModMii should be reported here: %neekURL%
echo.
support\sfk echo -spat \x20 \x20 \x20 \x20 [Red] This is also a great place to learn more about SNEEK in general.
support\sfk echo -spat \x20 \x20 \x20 \x20 [Red] Another great resource is the guide here: tinyurl.com/SNEEK-DI
echo.
echo.
echo                B = Back
echo.
echo                M = Main Menu
echo.
echo.
set /p SNEEKSELECT=     Enter Selection Here: 

if /i "%SNEEKSELECT%" EQU "B" goto:MENU
if /i "%SNEEKSELECT%" EQU "M" goto:MENU
if /i "%SNEEKSELECT%" EQU "1" goto:NEEKrevSelect
if /i "%SNEEKSELECT%" EQU "2" goto:SNKPAGE2
if /i "%SNEEKSELECT%" EQU "3" goto:NEEKrevSelect
if /i "%SNEEKSELECT%" EQU "4" goto:SNKDISCEX
if /i "%SNEEKSELECT%" EQU "5" goto:SNKNANDSELECTOR

echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:SNKPAGE1


::...................................SNEEK Page - NEEK rev Selection...............................
:NEEKrevSelect

if exist temp\list.txt del temp\list.txt>nul
if exist temp\list2.txt del temp\list2.txt>nul

if /i "%neek2o%" EQU "ON" (set googlecode=neek2o) & (set neekname=neek2o)
if /i "%neek2o%" NEQ "ON" (set googlecode=sneeky-compiler-modmii) & (set neekname=neek)

::---------------SKIN MODE-------------
if /i "%SkinMode%" EQU "Y" goto:quickskip2

echo Checking which %neekname% versions are hosted online...


::get all list
start %ModMiimin%/wait support\wget --no-check-certificate -N "https://sourceforge.net/projects/%googlecode%/files/?source=navbar"

if exist index.html* (move /y index.html* temp\list.txt>nul) else (goto:nowifi)
::copy /y "temp\list.txt" "temp\list2.txt">nul

support\sfk filter -spat "temp\list.txt" ++"/download\x22" ++"%neekname%-rev" -rep _"/download\x22"__ -rep _*"/"__ -rep _".zip*"__ -rep _"*files/"__ -rep _%neekname%-rev__ -rep _\x2528_\x28_ -rep _\x2529_\x29_ -rep _\x2520_\x20_ -rep _\x253B_\x3B_ -rep _\x252C_\x2C_ -write -yes>nul

:nowifi

::get local list

if not exist "temp\%neekname%\*.zip" goto:nolocallist

dir "temp\%neekname%\*.zip" /b /O:-N>>temp\list.txt
support\sfk filter "temp\list.txt" -rep _"%neekname%-rev"__ -rep _".zip"__ -write -yes>nul
support\sfk filter "temp\list.txt" -unique -write -yes>nul
:nolocallist

::---------------CMD LINE MODE-------------
if /i "%cmdlinemode%" EQU "Y" goto:getcurrentrev



::------actual page start----------
:NEEKrevSelect2

::count # of folders in advance to set "mode"
setlocal ENABLEDELAYEDEXPANSION
SET neekTOTAL=0
if exist temp\list.txt for /f "delims=" %%i in (temp\list.txt) do set /a neekTOTAL=!neekTOTAL!+1
setlocal DISABLEDELAYEDEXPANSION

if /i "%neekTOTAL%" EQU "0" (echo Unable to connect to the internet and no %neekname% versions saved locally) & (@ping 127.0.0.1 -n 5 -w 1000> nul) & (set neekrev=B) & (goto:back)

SET /a LINES=%neekTOTAL%+21
if %LINES% LEQ 54 goto:noresize
mode con cols=85 lines=%LINES%
:noresize

Set neekrev=
cls
echo                                        ModMii                                v%currentversion%
echo                                       by XFlak
echo.
echo.
echo                 Select the version of %neekname% you would like to build:
echo.
echo.


set RevCount=0
set FeaturedTag=

::Loop through the the following once for EACH line in *.txt
for /F "tokens=*" %%A in (temp\list.txt) do call :processNEEKlist %%A
goto:quickskip
:processNEEKlist
set CurrentRev=%*
set /a RevCount=%RevCount%+1

if not exist temp\list2.txt goto:nofeaturedcheck
findStr /I /C:"%CurrentRev%" "temp\list2.txt" >nul
IF ERRORLEVEL 1 (set FeaturedTag=) else (set FeaturedTag= - Featured)
:nofeaturedcheck

if not exist "temp\%neekname%\%neekname%-rev%CurrentRev%.zip" echo       %RevCount% = %CurrentRev% (hosted online)%FeaturedTag%
if exist "temp\%neekname%\%neekname%-rev%CurrentRev%.zip" echo       %RevCount% = %CurrentRev%%FeaturedTag%

goto:EOF
:quickskip

echo.
echo.
echo                B = Back
echo.
echo                M = Main Menu
echo.
echo.
set /p neekrev=     Enter Selection Here: 

if /i "%neekrev%" EQU "M" (mode con cols=85 lines=54) & (goto:MENU)

:back

if /i "%AbstinenceWiz%" NEQ "Y" goto:NotAbstinenceWiz
if /i "%neekrev%" NEQ "B" goto:NotAbstinenceWiz
mode con cols=85 lines=54
if /i "%FIRMSTART%" EQU "4.3" goto:WPAGE3C
if /i "%FIRMSTART%" EQU "o" goto:WPAGE3C
goto:WPAGE2
:NotAbstinenceWiz

if /i "%neekrev%" EQU "B" (mode con cols=85 lines=54) & (goto:SNKPAGE1)

if "%neekrev%"=="" goto:badkey
if %neekrev% LSS 1 goto:badkey
if /i %neekrev% GTR %RevCount% goto:badkey


:getcurrentrev

::---------------CMD LINE MODE-------------
if /i "%cmdlinemode%" NEQ "Y" goto:cmdskip
if "%neekrev%"=="" goto:quickskip2
:cmdskip

::----get selected %currentrev%----
set RevCount2=0
::Loop through the the following once for EACH line in *.txt
for /F "tokens=*" %%A in (temp\list.txt) do call :processlist2 %%A
goto:quickskip2
:processlist2
set CurrentRev=%*
set /a RevCount2=%RevCount2%+1
if /i "%RevCount2%" EQU "%neekrev%" goto:quickskip2
goto:EOF
:quickskip2


::---------------CMD LINE MODE-------------
if /i "%cmdlinemode%" NEQ "Y" goto:cmdskip
if /i "%AbstinenceWiz%" EQU "Y" goto:DOWNLOAD
goto:SNEEKINSTALLER
:cmdskip

mode con cols=85 lines=54

goto:SNKPAGE2

:badkey
echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:NEEKrevSelect2



::...................................SNEEK Page - DML rev Selection...............................
:CurrentDMLRevSelect

::DISABLED
goto:%AfterDMLRevSelect%

if exist temp\list.txt del temp\list.txt>nul
if exist temp\list2.txt del temp\list2.txt>nul

::set googlecode=diosmioslite

::echo Checking which DML versions are hosted online...


::get all list
::start %ModMiimin%/wait support\wget --no-check-certificate -N "http://code.google.com/p/diosmioslite/downloads/list?can=1"

::if exist list* (move /y list* temp\list.txt>nul) else (goto:nowifi)
::copy /y "temp\list.txt" "temp\list2.txt">nul


::support\sfk filter -spat "temp\list.txt" ++"diosmioslite.googlecode.com/files/" ++"diosmioslitesv" ++".wad" -!zip -rep _*"/"__ -rep _".wad*"__ -rep _"*files/"__ -rep _diosmioslitesv__ -rep _\x2528_\x28_ -rep _\x2529_\x29_ -rep _\x2520_\x20_ -rep _\x253B_\x3B_ -rep _\x252C_\x2C_ -write -yes>nul


::get featured list
::support\sfk filter -spat "temp\list2.txt" ++"diosmioslite.googlecode.com/files/" ++"diosmioslitesv" ++".wad', 'Featured" -rep _*"/"__ -write -yes>nul


::support\sfk filter -spat "temp\list2.txt" -+"Featured" -!zip -!DMLST.wad -rep _".wad*"__ -rep _"*files/"__ -rep _diosmioslitesv__ -rep _\x2528_\x28_ -rep _\x2529_\x29_ -rep _\x2520_\x20_ -rep _\x253B_\x3B_ -rep _\x252C_\x2C_ -write -yes>nul

:nowifi

::get local list

if not exist "temp\DML\*.wad" goto:nolocallist

dir "temp\DML\*.wad" /b /O:-N>>temp\list.txt

::support\sfk filter "temp\list.txt" -rep _"diosmioslitesv"__ -rep _".wad"__ -write -yes>nul
support\sfk filter "temp\list.txt" -rep _".wad"__ -write -yes>nul
support\sfk filter "temp\list.txt" -unique -write -yes>nul
:nolocallist

::---------------CMD LINE MODE-------------
if /i "%cmdlinemode%" EQU "Y" goto:getCurrentDMLRev



::------actual page start----------
:CurrentDMLRevSelect2

::count # of folders in advance to set "mode"
setlocal ENABLEDELAYEDEXPANSION
SET DMLTOTAL=0
if exist temp\list.txt for /f "delims=" %%i in (temp\list.txt) do set /a DMLTOTAL=!DMLTOTAL!+1
setlocal DISABLEDELAYEDEXPANSION

::if /i "%DMLTOTAL%" EQU "0" (echo No DML versions saved locally) & (@ping 127.0.0.1 -n 5 -w 1000> nul) & (goto:%B4DMLRevSelect%)

SET /a LINES=%DMLTOTAL%+30
if %LINES% LEQ 54 goto:noresize
mode con cols=85 lines=%LINES%
:noresize

Set DMLrev=
cls
echo                                        ModMii                                v%currentversion%
echo                                       by XFlak
echo.
echo.
echo            Select the version of DML (or Dios Mios) you would like to install:
echo.
echo            To add versions to the below list, download them from here:
echo                  http://code.google.com/p/diosmios/wiki/Downloads
echo                   Then save them to ModMii's "temp\DML" folder
if not exist temp\DML mkdir temp\DML
echo.
echo.
echo          * DML requires either Sneek+DI r157+ or NeoGamma R9 beta 55+
echo.
::echo          * DML Debug Mode saves logs to the SD Card.
echo          * USB Gecko debug can only be enabled by compiling the source manually.
echo.
set RevCount=0

if not exist temp\list.txt goto:quickskip

::Loop through the the following once for EACH line in *.txt
for /F "tokens=*" %%A in (temp\list.txt) do call :processDMLlist %%A
goto:quickskip
:processDMLlist
set CurrentDMLRev=%*
set /a RevCount=%RevCount%+1

::if not exist temp\list2.txt goto:nofeaturedcheck
::findStr /I /C:"%CurrentDMLRev%" "temp\list2.txt" >nul
::IF ERRORLEVEL 1 (set FeaturedTag=) else (set FeaturedTag= - Featured)
:nofeaturedcheck

::if not exist "temp\DML\diosmioslitesv%CurrentDMLRev%.wad" echo       %RevCount% = diosmioslitesv%CurrentDMLRev% (hosted on google code)%FeaturedTag%
::if exist "temp\DML\diosmioslitesv%CurrentDMLRev%.wad" echo       %RevCount% = diosmioslitesv%CurrentDMLRev%%FeaturedTag%

echo       %RevCount% = %CurrentDMLRev%

goto:EOF
:quickskip

echo.
echo.
echo                B = Back
echo.
echo                M = Main Menu
echo.
echo.
set /p DMLrev=     Enter Selection Here: 



if /i "%DMLrev%" EQU "M" (mode con cols=85 lines=54) & (goto:MENU)
if /i "%DMLrev%" EQU "B" (mode con cols=85 lines=54) & (set DML=) & (set CurrentDMLRev=) & (goto:%B4DMLRevSelect%)

if "%DMLrev%"=="" goto:badkey
if %DMLrev% LSS 1 goto:badkey
if /i %DMLrev% GTR %RevCount% goto:badkey



:getCurrentDMLRev

::---------------CMD LINE MODE-------------
if /i "%cmdlinemode%" NEQ "Y" goto:cmdskip
if "%DMLrev%"=="" goto:quickskip
:cmdskip

::----get selected %CurrentDMLRev%----
set RevCount2=0
::Loop through the the following once for EACH line in *.txt
for /F "tokens=*" %%A in (temp\list.txt) do call :processlist3 %%A
goto:quickskip
:processlist3
set CurrentDMLRev=%*
set /a RevCount2=%RevCount2%+1
if /i "%RevCount2%" EQU "%DMLrev%" goto:quickskip
goto:EOF
:quickskip


::---------------CMD LINE MODE-------------
if /i "%cmdlinemode%" EQU "Y" goto:skipDMLcmd


mode con cols=85 lines=54


goto:%AfterDMLRevSelect%

:badkey
echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:CurrentDMLRevSelect2



::...................................SNEEK Page2 - SNEEK TYPE...............................
:SNKPAGE2
set SNEEKTYPE=
set FORMAT=
cls
echo                                        ModMii                                v%currentversion%
echo                                       by XFlak
echo.
echo.
if /i "%SNEEKSELECT%" NEQ "2" echo         What type of SNEEK would you like to install?
if /i "%SNEEKSELECT%" EQU "2" echo         What type of SNEEK would you like to build an emulated NAND for?
echo.
echo.
if /i "%SNEEKSELECT%" NEQ "1" echo   Note: NANDs built for any type of SNEEK work with any other type of SNEEK.
if /i "%SNEEKSELECT%" NEQ "1" echo           However, ANY region Wii can use ANY region emulated NAND
if /i "%SNEEKSELECT%" NEQ "1" echo.
echo.
echo         UD = UNEEK+DI
echo              * Emulated Wii nand/memory is on FAT32 External Hard Drive
echo              * Load Wii games off your FAT32 External Hard Drive
echo              * You can load apps off an SD Card via the Homebrew Channel
echo              * DVD-Drive access is disabled for games while running UNEEK+DI
echo                but can be used in apps (ie. WiiXplorer)
echo.
echo         SD = SNEEK+DI
echo              * Emulated Wii nand/memory is on SD Card
echo              * Load Wii games off your FAT32 External Hard Drive
echo              * Load GameCube games off your SD Card using DML
echo              * You can load apps off a FAT32 USB HDD via the Homebrew Channel
echo              * DVD-Drive access is disabled for games while running SNEEK+DI
echo                but can be used in apps (ie. WiiXplorer)
echo.
echo          U = UNEEK
echo              * Emulated Wii nand/memory is on FAT32 External Hard Drive
echo              * You cannot load any games off your Hard Drive
echo              * You can load apps off an SD Card via the Homebrew Channel
echo              * DVD-Drive access is enabled
echo              * Backup disc loading requires DarkCorp installed on emulated nand
echo                (Newer Wii's have a DVD-Drive that prevents backup disc loading)
echo.
echo          S = SNEEK
echo              * Emulated Wii nand/memory is on SD Card
::echo              * You can load ONE game at a time off your FAT32 External Hard Drive
echo              * You cannot load any games off your Hard Drive
echo              * You can load apps off a FAT32 USB HDD via the Homebrew Channel
echo              * DVD-Drive access is enabled
echo              * Backup disc loading requires DarkCorp installed on emulated nand
echo                (Newer Wii's have a DVD-Drive that prevents backup disc loading)
echo.
echo.
echo          B = Back
echo.
echo          M = Main Menu
echo.
echo.
set /p SNEEKTYPE=     Enter Selection Here: 

if /i "%SNEEKTYPE%" NEQ "B" goto:notback
if /i "%SNEEKSELECT%" EQU "1" goto:NEEKrevSelect2
if /i "%SNEEKSELECT%" EQU "3" goto:NEEKrevSelect2
if /i "%AbstinenceWiz%" EQU "Y" goto:NEEKrevSelect2
goto:SNKPAGE1
:notback


if /i "%SNEEKTYPE%" EQU "M" goto:MENU

if /i "%AbstinenceWiz%" NEQ "Y" goto:NotAbstinenceWiz
if /i "%SNEEKTYPE%" EQU "U" goto:UPAGE1
if /i "%SNEEKTYPE%" EQU "UD" goto:UPAGE1
:NotAbstinenceWiz


if /i "%SNEEKTYPE%" EQU "S" set BACKB4DRIVE=SNKPAGE2
if /i "%SNEEKTYPE%" EQU "SD" set BACKB4DRIVE=SNKPAGE2
if /i "%SNEEKTYPE%" EQU "U" set BACKB4DRIVE=SNKPAGE2
if /i "%SNEEKTYPE%" EQU "UD" set BACKB4DRIVE=SNKPAGE2

if /i "%SNEEKTYPE%" EQU "SD" goto:DRIVECHANGE
if /i "%SNEEKTYPE%" EQU "S" goto:DRIVECHANGE

::if only building nand, no need to set drive, only driveU
if /i "%SNEEKSELECT%" EQU "2" goto:skip
if /i "%SNEEKTYPE%" EQU "UD" goto:DRIVECHANGE
if /i "%SNEEKTYPE%" EQU "U" goto:DRIVECHANGE
goto:skip2
:skip
if /i "%SNEEKTYPE%" EQU "U" set BACKB4DRIVEU=SNKPAGE2
if /i "%SNEEKTYPE%" EQU "U" goto:DRIVEUCHANGE
if /i "%SNEEKTYPE%" EQU "UD" set BACKB4DRIVEU=SNKPAGE2
if /i "%SNEEKTYPE%" EQU "UD" goto:DRIVEUCHANGE
:skip2

echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:SNKPAGE2





::...................................SNEEK Page3 - SNEEK REGION...............................
:SNKPAGE3

if /i "%SNEEKTYPE:~0,1%" EQU "S" set nandpath=%DRIVE%
if /i "%SNEEKTYPE:~0,1%" EQU "U" set nandpath=%DRIVEU%

set DITYPE=off
if /i "%SNEEKTYPE%" EQU "UD" set DITYPE=on
if /i "%SNEEKTYPE%" EQU "SD" set DITYPE=on


set SNKREGION=
cls
echo                                        ModMii                                v%currentversion%
echo                                       by XFlak
echo.
echo.
if /i "%SNEEKSELECT%" EQU "5" (echo                                EMULATED NAND MODIFIER) else (echo                                 EMULATED NAND BUILDER)
echo.
echo.
echo         What Region would you like to make your emulated NAND?
echo.
echo.
echo.
echo         Note: If you want your wiimotes be synced up to your real NAND
echo               and your emulated NAND simultaneously, then you must choose
echo               the real region of your Wii
echo.
if /i "%neek2o%" EQU "ON" goto:skip
support\sfk echo -spat \x20 \x20 [Red] Warning:[def] JAP\Korean NANDs specifically do NOT have Region Free hacks
echo               enabled by default. This only applies to WiiWare/VC Games, 
echo               the DI/Game Menu can still play Wii Games of All Regions.
echo               However, you can still enable region free hacks using Priiloader.
:skip
echo.
echo.
echo                U = USA
echo                E = Euro (PAL)
echo                J = JAP
echo                K = Korean
echo.
echo.
echo.
echo                B = Back
echo.
echo                M = Main Menu
echo.
echo.
echo.
echo.
set /p SNKREGION=     Enter Selection Here: 


if /i "%SNKREGION%" EQU "B" goto:%B4SNKPAGE3%
if /i "%SNKREGION%" EQU "M" goto:MENU

if /i "%SNKREGION%" EQU "u" set SNKREGION=U
if /i "%SNKREGION%" EQU "e" set SNKREGION=E
if /i "%SNKREGION%" EQU "j" set SNKREGION=J
if /i "%SNKREGION%" EQU "k" set SNKREGION=K

if /i "%SNKREGION%" EQU "U" set defaultserial=LU521175683
if /i "%SNKREGION%" EQU "E" set defaultserial=LEH133789940
if /i "%SNKREGION%" EQU "J" set defaultserial=LJM101175683
if /i "%SNKREGION%" EQU "K" set defaultserial=LJM101175683

set serialdigits=11 or 12
::if /i "%SNKREGION%" EQU "U" (set serialdigits=11 or 12) else (set serialdigits=12)

if /i "%SNKREGION%" EQU "U" goto:SNKPAGE4
if /i "%SNKREGION%" EQU "E" goto:SNKPAGE4
if /i "%SNKREGION%" EQU "J" goto:SNKPAGE4
if /i "%SNKREGION%" EQU "K" goto:SNKPAGE4

echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:SNKPAGE3






::...................................SNEEK Page4 - SNEEK VERSION...............................
:SNKPAGE4
set SNKVERSION=


::If region is USA and building NAND for DI, force 4.2 and go to next page
::if /i "%DITYPE%" EQU "OFF" goto:skip
::if /i "%SNKREGION%" EQU "U" set SNKVERSION=4.2
::if /i "%SNKREGION%" EQU "U" goto:SNKPAGE5
:::skip


cls
echo                                        ModMii                                v%currentversion%
echo                                       by XFlak
echo.
echo.
if /i "%SNEEKSELECT%" EQU "5" (echo                                EMULATED NAND MODIFIER) else (echo                                 EMULATED NAND BUILDER)
echo.
echo.
echo         What System Menu Version would you like your SNEEK emulated NAND to be?
echo.
echo.
echo.
if /i "%neek2o%" EQU "ON" goto:skip
if /i "%SNKREGION%" EQU "U" support\sfk echo -spat \x20 \x20 [Red] Warning:[def] 4.2U/4.1U specifically do NOT have Region Free hacks enabled by
if /i "%SNKREGION%" EQU "U" echo               default. This only applies to WiiWare/VC Games (aka Channels),
if /i "%SNKREGION%" EQU "U" echo               the DI/Game Menu can still play Wii Games of All Regions.
if /i "%SNKREGION%" EQU "U" echo               However, you can still enable region free hacks using Priiloader.
:skip
echo.
echo.
echo.
echo                4.3 = 4.3
echo                4.2 = 4.2
echo                4.1 = 4.1
echo.
echo.
echo.
echo                B = Back
echo.
echo                M = Main Menu
echo.
echo.
echo.
echo.
set /p SNKVERSION=     Enter Selection Here: 


if /i "%SNKVERSION%" EQU "M" goto:MENU
if /i "%SNKVERSION%" EQU "B" goto:SNKPAGE3



if /i "%SNKVERSION%" EQU "4.3" goto:SNKPAGE4a
if /i "%SNKVERSION%" EQU "4.2" goto:SNKPAGE4a
if /i "%SNKVERSION%" EQU "4.1" goto:SNKPAGE4a

echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:SNKPAGE4





::...................................SNEEK Page4a - Post Loader Channel...............................
:SNKPAGE4a

set SNKPLC=

cls
echo                                        ModMii                                v%currentversion%
echo                                       by XFlak
echo.
echo.
if /i "%SNEEKSELECT%" EQU "5" (echo                                EMULATED NAND MODIFIER) else (echo                                 EMULATED NAND BUILDER)
echo.
echo.
echo         Would you like a Post Loader Forwarder Channel on your emulated NAND?
echo.
echo.
echo         Post Loader aims to replace the Homebrew Channel, Forwarders,
echo         USB-Loader with emulated NAND support, etc.
echo.
echo         It's not possible to install the latest version of the Homebrew Channel
echo         to emulated nands and this is a great alternative.
echo.
echo.
echo.
echo.
echo.
echo.
echo                Y = Yes
echo.
echo                N = No
echo.
echo.
echo.
echo                B = Back
echo.
echo                M = Main Menu
echo.
echo.
echo.
echo.
set /p SNKPLC=     Enter Selection Here: 


if /i "%SNKPLC%" NEQ "B" goto:miniskip
if /i "%SNEEKSELECT%" EQU "5" (goto:SNKNANDSELECTOR) else (goto:SNKPAGE4)
:miniskip

if /i "%SNKPLC%" EQU "M" goto:MENU
if /i "%SNKPLC%" EQU "Y" goto:SNKPAGE4a2
if /i "%SNKPLC%" EQU "N" goto:SNKPAGE4a2


echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:SNKPAGE4a




::...................................SNEEK Page4a2 - cIOS...............................
:SNKPAGE4a2

set SNKCIOS=

cls
echo                                        ModMii                                v%currentversion%
echo                                       by XFlak
echo.
echo.
if /i "%SNEEKSELECT%" EQU "5" (echo                                EMULATED NAND MODIFIER) else (echo                                 EMULATED NAND BUILDER)
echo.
echo.
echo         Would you like to install cIOS249 rev14 to your emulated NAND?
echo.
echo.
echo         Some apps that require a cIOS will only work on s\uneek with cIOS rev14.
echo         For example, SaveGame Manager GX will work on s\uneek with cIOS rev14.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo                Y = Yes
echo.
echo                N = No
echo.
echo.
echo.
echo                B = Back
echo.
echo                M = Main Menu
echo.
echo.
echo.
echo.
set /p SNKCIOS=     Enter Selection Here: 


if /i "%SNKCIOS%" EQU "B" goto:SNKPAGE4a
if /i "%SNKCIOS%" EQU "M" goto:MENU
if /i "%SNKCIOS%" EQU "Y" goto:SNKPAGE4a3
if /i "%SNKCIOS%" EQU "N" goto:SNKPAGE4a3


echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:SNKPAGE4a2


::...................................SNEEK Page4a3 - cBC...............................
:SNKPAGE4a3

set SNKcBC=

if /i "%AbstinenceWiz%" EQU "Y" goto:SNKPAGE4b

if /i "%SNEEKSELECT%" EQU "5" set sneektype=SD

cls
echo                                        ModMii                                v%currentversion%
echo                                       by XFlak
echo.
echo.
if /i "%SNEEKSELECT%" EQU "5" (echo                                EMULATED NAND MODIFIER) else (echo                                 EMULATED NAND BUILDER)
echo.
echo.

if /i "%SNEEKTYPE%" EQU "SD" (echo         Would you like DML or NMM on your emulated NAND?) else (echo         Would you like NMM on your emulated NAND?)
echo.
echo.

if /i "%SNEEKTYPE%" EQU "SD" echo.
if /i "%SNEEKTYPE%" EQU "SD" echo         DML is installed to real NAND and accessed via an emulated NAND.
if /i "%SNEEKTYPE%" EQU "SD" echo.
if /i "%SNEEKTYPE%" EQU "SD" echo         DML (Dios Mios Lite) is a tool which allows you to run Gamecube games
if /i "%SNEEKTYPE%" EQU "SD" echo         from an SD Card. Compatability is not 100% and it only works with
if /i "%SNEEKTYPE%" EQU "SD" echo         SNEEK+DI (for now). For best results your SD card should be formatted
if /i "%SNEEKTYPE%" EQU "SD" echo         using 64KB sector sizes when running DML.
if /i "%SNEEKTYPE%" EQU "SD" echo.
if /i "%SNEEKTYPE%" EQU "SD" echo         DML requires either Sneek+DI r157+ or NeoGamma R9 beta 55+
if /i "%SNEEKTYPE%" EQU "SD" echo.
if /i "%SNEEKTYPE%" EQU "SD" echo.
if /i "%SNEEKTYPE%" EQU "SD" echo.

echo         NMM (No More Memory-Cards) redirects all GameCube Memory Card access
echo         to the SD card. This allow saving\loading GameCube game saves
echo         without a GC Memory Card.
echo.
echo.
if /i "%SNEEKTYPE%" EQU "SD" echo         Note: NMM and DML cannot both be installed at the same time
echo.
if /i "%SNEEKSELECT%" EQU "5" echo         Note: DML currently only works when using SNEEK+DI
echo.
echo.

if /i "%SNEEKSELECT%" NEQ "5" goto:nowarning
if /i "%BCTYPE%" EQU "BC" goto:nowarning
if /i "%BCTYPE%" EQU "NONE" goto:nowarning
if /i "%BCTYPE%" EQU "NMM" support\sfk echo -spat \x20 \x20 [Yellow] WARNING: Answering anything other than %BCtype% will uninstall %BCtype%
if /i "%BCTYPE%" EQU "DML" support\sfk echo -spat \x20 \x20 [Yellow] Outdated DML will be uninstalled from the Emulated NAND
if /i "%BCTYPE%" EQU "DML" support\sfk echo -spat \x20 \x20 [Yellow] as newer versions need to be installed to the real NAND
:nowarning

echo.
echo.

if /i "%SNEEKTYPE%" EQU "SD" echo              DML = DML
if /i "%SNEEKTYPE%" EQU "SD" echo.
if /i "%SNEEKTYPE%" EQU "SD" (echo              NMM = NMM) else (echo                Y = Yes)
echo.
echo                N = No
echo.
echo.
echo.
echo                B = Back
echo.
echo                M = Main Menu
echo.
echo.
echo.
echo.
set /p SNKcBC=     Enter Selection Here: 


if /i "%SNKcBC%" EQU "B" goto:SNKPAGE4a2
if /i "%SNKcBC%" EQU "M" goto:MENU
if /i "%SNKcBC%" EQU "N" goto:SNKPAGE4b

if /i "%SNEEKTYPE%" EQU "SD" goto:skip
if /i "%SNKcBC%" EQU "Y" (set SNKcBC=NMM) & (goto:SNKPAGE4b)
:skip

if /i "%SNEEKTYPE%" NEQ "SD" goto:skip
if /i "%SNKcBC%" EQU "NMM" goto:SNKPAGE4b
if /i "%SNKcBC%" EQU "DML" (set B4DMLRevSelect=SNKPAGE4a3) & (set AfterDMLRevSelect=SNKPAGE4b) & (goto:CurrentDMLRevSelect)
::if /i "%SNKcBC%" EQU "DML" goto:SNKPAGE4b
:skip

echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:SNKPAGE4a3

::...................................SNEEK Page4b - Priiloader For SNEEK...............................
:SNKPAGE4b

set SNKPRI=

if /i "%SNEEKSELECT%" EQU "5" (set sneektype=) else (goto:nocheck)
if "%SMAPP%"=="" goto:SNKPAGE4c
:nocheck


cls
echo                                        ModMii                                v%currentversion%
echo                                       by XFlak
echo.
echo.
if /i "%SNEEKSELECT%" EQU "5" (echo                                EMULATED NAND MODIFIER) else (echo                                 EMULATED NAND BUILDER)
echo.
echo.
echo         Would you like Priiloader (and hacks) on your emulated NAND?
echo.
echo         Doing this will allow you to enable system menu hacks on your emulated NAND.
echo         It will also permit autobooting sneek to apps of your choice (ie. WiiFlow).
echo.
echo.
echo         Note: to access Priiloader on your emulated NAND, hold reset just as
echo               your emulated NAND is booting up.
echo.
echo.

if /i "%SNEEKSELECT%" NEQ "5" goto:tinyskip
if /i "%PRIIFOUND%" EQU "YES" support\sfk echo -spat \x20 \x20 [Yellow] WARNING: Answering No will remove Priiloader from the Emulated NAND.
if /i "%PRIIFOUND%" EQU "yes" echo.
:tinyskip


echo.
echo.
echo.
echo.
echo                Y = Yes
echo.
echo                N = No
echo.
echo.
echo.
echo                B = Back
echo.
echo                M = Main Menu
echo.
echo.
echo.
echo.
set /p SNKPRI=     Enter Selection Here: 


if /i "%SNKPRI%" NEQ "B" goto:notback
if /i "%AbstinenceWiz%" EQU "Y" goto:SNKPAGE4a2
goto:SNKPAGE4a3
:notback



if /i "%SNKPRI%" EQU "M" goto:MENU
if /i "%SNKPRI%" EQU "Y" goto:SNKPAGE4c
if /i "%SNKPRI%" EQU "N" goto:SNKPAGE4c


echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:SNKPAGE4b



::...................................SNEEK Page4c - WiiFlow...............................
:SNKPAGE4c
set SNKFLOW=

::if /i "%SNEEKSELECT%" EQU "5" goto:tinyskip
::::skip this page if sneektype not uneek or uneek+di
::if /i "%SNEEKTYPE:~0,1%" EQU "S" (set SNKFLOW=N) & (goto:SNKPAGE4d)
:::tinyskip

cls
echo                                        ModMii                                v%currentversion%
echo                                       by XFlak
echo.
echo.
if /i "%SNEEKSELECT%" EQU "5" (echo                                EMULATED NAND MODIFIER) else (echo                                 EMULATED NAND BUILDER)
echo.
echo.
echo         Would you like a WiiFlow Forwarder Channel on your emulated NAND?
echo.
echo.

if /i "%SNKPRI%" EQU "Y" echo         Note: WiiFlow Forwarder dol will also be added as priiloader's
if /i "%SNKPRI%" EQU "Y" echo               installed file. Priiloader's autoboot settings will still need
if /i "%SNKPRI%" EQU "Y" echo               to be changed if you would like your emulated nand to autoboot
if /i "%SNKPRI%" EQU "Y" echo               the installed file.
if /i "%SNKPRI%" EQU "Y" echo.
if /i "%SNKPRI%" EQU "Y" echo.

echo         *WiiFlow is USB-Loader NEEK that is a visually appealing alternative
echo          to loading Wii games\channels via the emulated System Menu
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo                Y = Yes
echo.
echo                N = No
echo.
echo.
echo.
echo                B = Back
echo.
echo                M = Main Menu
echo.
echo.
echo.
echo.
set /p SNKFLOW=     Enter Selection Here: 


if /i "%SNKFLOW%" NEQ "B" goto:notback
if /i "%SNEEKSELECT%" NEQ "5" goto:SNKPAGE4b
if "%SMAPP%"=="" (goto:SNKPAGE4a3) else (goto:SNKPAGE4b)
:notback

if /i "%SNKFLOW%" EQU "M" goto:MENU
if /i "%SNKFLOW%" EQU "Y" goto:SNKPAGE4d
if /i "%SNKFLOW%" EQU "N" goto:SNKPAGE4d


echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:SNKPAGE4c



::...................................SNEEK Page4d - Switch2UNEEK...............................
:SNKPAGE4d

set SNKS2U=


if /i "%AbstinenceWiz%" EQU "Y" (set SNKS2U=N) & (goto:SNKPAGE5)
if /i "%SNEEKSELECT%" EQU "5" (set SNKS2U=N) & (goto:SNKPAGE5)

::skip this page if neek2o is enabled
if /i "%neek2o%" EQU "on" (set SNKS2U=N) & (goto:SNKPAGE5)

::skip this page if sneektype not uneek or uneek+di
if /i "%SNEEKTYPE:~0,1%" EQU "S" (set SNKS2U=N) & (goto:SNKPAGE5)


cls
echo                                        ModMii                                v%currentversion%
echo                                       by XFlak
echo.
echo.
if /i "%SNEEKSELECT%" EQU "5" (echo                                EMULATED NAND MODIFIER) else (echo                                 EMULATED NAND BUILDER)
echo.
echo.
echo         Would you like to use Switch2Uneek?
echo.
echo.
echo         Switch2Uneek is a utility to help you easily switch between
echo         your Emulated Uneek Nand and your Real Nand.
echo.
echo.
echo         If you answer "Y", you must access UNEEK by launching switch2uneek
echo         from the Homebrew Channel. Alternatively, can use MMM to install
echo         the switch2uneek forwarder channel that will be saved to your SD card.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo                Y = Yes
echo.
echo                N = No
echo.
echo.
echo.
echo                B = Back
echo.
echo                M = Main Menu
echo.
echo.
echo.
echo.
set /p SNKS2U=     Enter Selection Here: 


if /i "%SNKS2U%" EQU "B" goto:SNKPAGE4c
if /i "%SNKS2U%" EQU "M" goto:MENU
if /i "%SNKS2U%" EQU "Y" goto:SNKPAGE5
if /i "%SNKS2U%" EQU "N" goto:SNKPAGE5


echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:SNKPAGE4d


::...................................SNEEK Page5 - SNEEK SERIAL...............................
:SNKPAGE5

if /i "%SNEEKSELECT%" NEQ "5" goto:nocheck
set SNKSERIAL=
if "%SMAPP%"=="" (goto:WPAGE20) else (goto:nonandcheck)
:nocheck


if /i "%SNEEKTYPE:~0,1%" EQU "S" set nandpath=%DRIVE%
if /i "%SNEEKTYPE:~0,1%" EQU "U" set nandpath=%DRIVEU%

if /i "%neek2o%" EQU "ON" goto:DOIT
if /i "%SNKS2U%" EQU "N" goto:quickskip
:DOIT
SET NANDcount=0
if /i "%SNKREGION%" EQU "U" set nandregion=us
if /i "%SNKREGION%" EQU "E" set nandregion=eu
if /i "%SNKREGION%" EQU "J" set nandregion=jp
if /i "%SNKREGION%" EQU "K" set nandregion=kr
if not exist "%nandpath%\nands\pl_%nandregion%" (set nandpath=%nandpath%\nands\pl_%nandregion%) & goto:quickskip

:NANDname
SET /a NANDcount=%NANDcount%+1
if not exist "%nandpath%\nands\pl_%nandregion%%NANDcount%" (set nandpath=%nandpath%\nands\pl_%nandregion%%NANDcount%) & goto:quickskip
goto:NANDname
:quickskip

set nandexist=no
if exist "%nandpath%"\title set nandexist=yes
if exist "%nandpath%"\ticket set nandexist=yes
if exist "%nandpath%"\sys set nandexist=yes
if exist "%nandpath%"\shared1 set nandexist=yes

:nonandcheck
if /i "%SNEEKSELECT%" EQU "5" set settingtxtExist=yes

cls
echo                                        ModMii                                v%currentversion%
echo                                       by XFlak
echo.
echo.
if /i "%SNEEKSELECT%" EQU "5" (echo                                EMULATED NAND MODIFIER) else (echo                                 EMULATED NAND BUILDER)
echo.
echo.
echo         What Serial Number Would you like to use to create setting.txt?
echo.
echo.
if /i "%settingtxtExist%" EQU "yes" support\sfk echo -spat \x20 [Red] setting.txt already exists in:
if /i "%settingtxtExist%" EQU "yes" echo    %nandpath%
if /i "%settingtxtExist%" EQU "yes" support\sfk echo -spat \x20 [Red] Leave the selection blank to keep using this setting.txt
echo.
echo.
echo         Enter your serial number now
echo.
echo               Example: %defaultserial%
echo.
echo.
echo.
echo                D = Default Serial %defaultserial%
echo.
echo.
echo.
echo.
echo         Note: If you want your emulated NAND to have internet access
echo               you should use the serial for your Wii
echo               (or use the setting.txt from your NAND Dump)
echo.
echo.
echo.
echo.
echo                B = Back
echo.
echo                M = Main Menu
echo.
echo.
echo.
echo.
set /p SNKSERIAL=     Enter Selection Here: 

if /i "%SNKSERIAL%" EQU "M" goto:MENU

if /i "%SNKSERIAL%" NEQ "B" goto:quickskip
if /i "%SNEEKSELECT%" EQU "5" goto:SNKPAGE4c
if /i "%SNEEKTYPE:~0,1%" EQU "S" goto:SNKPAGE4c
if /i "%AbstinenceWiz%" EQU "Y" goto:SNKPAGE4c
if /i "%neek2o%" EQU "ON" (goto:SNKPAGE4c) else (goto:SNKPAGE4d)
:quickskip


if /i "%SNKSERIAL%" EQU "D" set SNKSERIAL=%defaultserial%


if /i "%settingtxtExist%" EQU "yes" goto:settingsexist
IF "%SNKSERIAL%"=="" set SNKSERIAL=9999999999999
goto:skip

:settingsexist

IF "%SNKSERIAL%"=="" set SNKSERIAL=current
if /i "%SNKSERIAL%" EQU "current" goto:WPAGE20
:skip

::limit user input to X# of digits
if "%SNKSERIAL:~2%"=="" (goto:badkey)
if "%SNKSERIAL:~3%"=="" (goto:badkey)
if "%SNKSERIAL:~4%"=="" (goto:badkey)
if "%SNKSERIAL:~5%"=="" (goto:badkey)
if "%SNKSERIAL:~6%"=="" (goto:badkey)
if "%SNKSERIAL:~7%"=="" (goto:badkey)
if "%SNKSERIAL:~8%"=="" (goto:badkey)
if "%SNKSERIAL:~9%"=="" (goto:badkey)
if "%SNKSERIAL:~10%"=="" (goto:badkey)

if /i "%SNKREGION%" EQU "U" goto:skip
::if "%SNKSERIAL:~11%"=="" (goto:badkey)
:skip

if not "%SNKSERIAL:~12%"=="" (goto:badkey)

::next page
goto:WPAGE20

:badkey
echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:SNKPAGE5







::...................................SNEEK Nand Builder Confirmation...............................
:SNKNANDCONFIRM
set SNKNANDCONFIRM=

cls
echo                                        ModMii                                v%currentversion%
echo                                       by XFlak
echo.
echo.

if /i "%AbstinenceWiz%" NEQ "Y" goto:notabstinence
if /i "%FIRMSTART%" NEQ "o" echo                              Abstinence Wizard for %FIRMSTART%%REGION%
if /i "%FIRMSTART%" EQU "o" echo                              Abstinence Wizard for ^<2.2%REGION%
echo.
:notabstinence


if /i "%SNEEKSELECT%" EQU "5" echo      You are about to make the following changes to your Emulated NAND

if /i "%SNEEKSELECT%" NEQ "3" goto:notalsoinstalling
if /i "%SNEEKTYPE%" EQU "SD" echo      You are about to install %neekname%: SNEEK+DI Rev%CurrentRev% and build a %SNKVERSION%%SNKREGION% Emulated Nand
if /i "%SNEEKTYPE%" EQU "UD" echo      You are about to install %neekname%: UNEEK+DI Rev%CurrentRev% and build a %SNKVERSION%%SNKREGION% Emulated Nand
if /i "%SNEEKTYPE%" EQU "S" echo      You are about to install %neekname%: SNEEK Rev%CurrentRev% and build a %SNKVERSION%%SNKREGION% Emulated Nand
if /i "%SNEEKTYPE%" EQU "U" echo      You are about to install %neekname%: UNEEK Rev%CurrentRev% and build a %SNKVERSION%%SNKREGION% Emulated Nand

echo.
if /i "%neek2o%" EQU "on" echo      neek2o Enabled (can be changed in options)
if /i "%neek2o%" NEQ "on" echo      neek2o Disabled (can be changed in options)
if /i "%SSD%" EQU "on" echo      SNEEK and SNEEK+DI SD Access Enabled (can be changed in options)
if /i "%SSD%" NEQ "on" echo      SNEEK and SNEEK+DI SD Access Disabled (can be changed in options)
goto:skip

:notalsoinstalling

if /i "%SNEEKSELECT%" EQU "2" echo      You are about to build a %SNKVERSION%%SNKREGION% Emulated Nand

if /i "%SNEEKSELECT%" NEQ "1" goto:skip
if /i "%SNEEKTYPE%" EQU "SD" echo      You are about to build SNEEK+DI Rev%CurrentRev%
if /i "%SNEEKTYPE%" EQU "UD" echo      You are about to build UNEEK+DI Rev%CurrentRev%
if /i "%SNEEKTYPE%" EQU "U" echo      You are about to build UNEEK Rev%CurrentRev%
if /i "%SNEEKTYPE%" EQU "S" echo      You are about to build SNEEK Rev%CurrentRev%
echo.
if /i "%neek2o%" EQU "on" echo      neek2o Enabled (can be changed in options)
if /i "%neek2o%" NEQ "on" echo      neek2o Disabled (can be changed in options)
if /i "%SSD%" EQU "on" echo      SNEEK and SNEEK+DI SD Access Enabled (can be changed in options)
if /i "%SSD%" NEQ "on" echo      SNEEK and SNEEK+DI SD Access Disabled (can be changed in options)

echo.
echo.
echo.
echo.
goto:nonandinstallation

:skip

if not exist temp\WAD mkdir temp\WAD

echo.
echo.
echo    Install WADs from: temp\WAD\
echo     to Emulated Nand: %nandpath%\
echo.
IF not "%addwadfolder%"=="" echo    Install wads from custom folder: %addwadfolder%\
IF "%addwadfolder%"=="" (echo    A = Add custom folder of wads to install to the emulated NAND) else (echo    R = Remove custom folder of wads from emulated NAND)
echo.
echo.

IF "%addwadfolder%"=="" (set emuitems=0) else (set emuitems=1)
set emuwadcount=%emuitems%




::if /i "%SNEEKSELECT%" NEQ "5" goto:skipthis
if /i "%SNKSERIAL%" NEQ "current" SET /a emuitems=%emuitems%+1
if /i "%SNKSERIAL%" NEQ "current" (echo           * setting.txt will be created using this serial number: %SNKSERIAL%) else (echo           * Existing setting.txt will be kept)
echo.
:skipthis

if /i "%SNEEKSELECT%" NEQ "5" goto:skipthis
if /i "%nswitchFound%" EQU "No" (SET /a emuitems=%emuitems%+1) & (SET /a emuwadcount=%emuwadcount%+1)
if /i "%nswitchFound%" EQU "No" echo           * Install/Update nSwitch Channel
if /i "%nswitchFound%" EQU "No" echo.
:skipthis

if /i "%SNKPLC%" EQU "Y" (SET /a emuitems=%emuitems%+1) & (SET /a emuwadcount=%emuwadcount%+1)
if /i "%SNKPLC%" EQU "Y" echo           * Install Post Loader Channel
if /i "%SNKPLC%" EQU "Y" echo.

if /i "%SNKCIOS%" EQU "Y" (SET /a emuitems=%emuitems%+1) & (SET /a emuwadcount=%emuwadcount%+1)
if /i "%SNKCIOS%" EQU "Y" echo           * Install cIOS249 rev14
if /i "%SNKCIOS%" EQU "Y" echo.

if /i "%SNEEKSELECT%" NEQ "5" goto:skipthis
if /i "%BCtype%" EQU "BC" goto:skipthis
if /i "%BCtype%" EQU "NONE" goto:skipthis
if /i "%SNKcBC%" EQU "N" (SET /a emuitems=%emuitems%+1) & (SET /a emuwadcount=%emuwadcount%+1)
if /i "%SNKcBC%" EQU "N" echo           * Uninstall %BCTYPE%
if /i "%SNKcBC%" EQU "N" echo.
:skipthis

if /i "%BCtype%" EQU "NMM" goto:noNMM
if /i "%SNKcBC%" EQU "NMM" (SET /a emuitems=%emuitems%+1) & (SET /a emuwadcount=%emuwadcount%+1)
if /i "%SNKcBC%" EQU "NMM" echo           * Install NMM (No More Memory-Cards)
if /i "%SNKcBC%" EQU "NMM" echo.
:noNMM

if /i "%BCtype%" EQU "DML" goto:noDML
if /i "%SNKcBC%" EQU "DML" SET /a emuitems=%emuitems%+1
::if /i "%SNKcBC%" EQU "DML" (SET /a emuitems=%emuitems%+1) & (SET /a emuwadcount=%emuwadcount%+1)
if /i "%SNKcBC%" EQU "DML" echo           * Install DML (Dios Mios Lite) v%CurrentDMLRev% to Real NAND
if /i "%SNKcBC%" EQU "DML" echo.
:noDML

set uninstallprii=
if /i "%SNEEKSELECT%" NEQ "5" goto:not5
if /i "%PRIIFOUND%" EQU "YES" (goto:priifound) else (goto:not5)
:priifound
if /i "%SNKPRI%" EQU "Y" echo           * Priiloader already Installed
if /i "%SNKPRI%" EQU "Y" echo.
if /i "%SNKPRI%" EQU "N" SET /a emuitems=%emuitems%+1
if /i "%SNKPRI%" EQU "N" echo           * Uninstall Priiloader
if /i "%SNKPRI%" EQU "N" echo.
if /i "%SNKPRI%" EQU "N" set uninstallprii=yes
goto:miniskip
:not5

if /i "%SNKPRI%" EQU "Y" SET /a emuitems=%emuitems%+1
if /i "%SNKPRI%" EQU "Y" echo           * Install Priiloader
if /i "%SNKPRI%" EQU "Y" echo.
:miniskip

if /i "%SNKFLOW%" EQU "Y" (SET /a emuitems=%emuitems%+1) & (SET /a emuwadcount=%emuwadcount%+1)
if /i "%SNKFLOW%" EQU "Y" echo           * Install WiiFlow
if /i "%SNKFLOW%" EQU "Y" echo.

if /i "%SNKS2U%" EQU "Y" (SET /a emuitems=%emuitems%+1) & (SET /a emuwadcount=%emuwadcount%+1)
if /i "%SNKS2U%" EQU "Y" echo           * Install Switch2Uneek
if /i "%SNKS2U%" EQU "Y" echo.

if /i "%ThemeSelection%" NEQ "N" SET /a emuitems=%emuitems%+1
if /i "%ThemeSelection%" EQU "R" echo           * Install Dark Wii Red Theme
if /i "%ThemeSelection%" EQU "G" echo           * Install Dark Wii Green Theme
if /i "%ThemeSelection%" EQU "BL" echo           * Install Dark Wii Blue Theme
if /i "%ThemeSelection%" EQU "O" echo           * Install Dark Wii Orange Theme
if /i "%ThemeSelection%" EQU "D" echo           * Restore Original\Default Theme
if /i "%ThemeSelection%" NEQ "N" echo.

if /i "%PIC%" EQU "Y" (echo           * Install Photo Channel) & (SET /a emuitems=%emuitems%+1) & (SET /a emuwadcount=%emuwadcount%+1)
if /i "%NET%" EQU "Y" (echo           * Install Internet Channel) & (SET /a emuitems=%emuitems%+1) & (SET /a emuwadcount=%emuwadcount%+1)
if /i "%WEATHER%" EQU "Y" (echo           * Install Weather Channel) & (SET /a emuitems=%emuitems%+1) & (SET /a emuwadcount=%emuwadcount%+1)
if /i "%NEWS%" EQU "Y" (echo           * Install News Channel) & (SET /a emuitems=%emuitems%+1) & (SET /a emuwadcount=%emuwadcount%+1)
if /i "%MIIQ%" EQU "Y" (echo           * Install Mii Channel) & (SET /a emuitems=%emuitems%+1) & (SET /a emuwadcount=%emuwadcount%+1)
if /i "%Shop%" EQU "Y" (echo           * Install Shopping Channel) & (SET /a emuitems=%emuitems%+1) & (SET /a emuwadcount=%emuwadcount%+1)
if /i "%Speak%" EQU "Y" (echo           * Install Wii Speak Channel) & (SET /a emuitems=%emuitems%+1) & (SET /a emuwadcount=%emuwadcount%+1)



echo.
if /i "%nandexist%" EQU "yes" support\sfk echo -spat \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 [Red]WARNING: An emulated nand already exists in:
if /i "%nandexist%" EQU "yes" echo                   %nandpath%
if /i "%nandexist%" EQU "yes" support\sfk echo -spat \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 [Red]Existing emulated nand will be Deleted\Replaced
:nonandinstallation
echo.

if /i "%SNEEKSELECT%" NEQ "5" goto:skip5
if /i "%emuitems%" NEQ "0" goto:skip5
support\sfk echo -spat \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 [Yellow] No changes to the Emulated NAND have been selected.
echo.
echo.
goto:noyes
:skip5

if /i "%AbstinenceWiz%" EQU "Y" (echo                Y = Yes, Generate Guide and Begin Downloading) else (echo                Y = Yes, do it now!)
if /i "%AbstinenceWiz%" EQU "Y" echo                G = Generate Guide Only
:noyes

::echo.
::echo                N = No
echo.
echo.
echo                B = Back
echo.
echo                M = Main Menu
echo.
echo.
set /p SNKNANDCONFIRM=     Enter Selection Here: 


if /i "%SNKNANDCONFIRM%" EQU "B" goto:%B4SNKCONFIRM%
if /i "%SNKNANDCONFIRM%" EQU "M" goto:MENU
::if /i "%SNKNANDCONFIRM%" EQU "N" goto:MENU

if /i "%AbstinenceWiz%" NEQ "Y" goto:NotAbstinenceWiz
if /i "%SNKNANDCONFIRM%" EQU "G" (set secondrun=) & (set SETTINGS=G) & (goto:Download)
if /i "%SNKNANDCONFIRM%" EQU "Y" (set secondrun=) & (set SETTINGS=) & (goto:creditcheck)
:NotAbstinenceWiz

if /i "%SNEEKSELECT%" EQU "1" goto:skip5
if /i "%SNKNANDCONFIRM%" EQU "A" goto:addwadfolder
if /i "%SNKNANDCONFIRM%" EQU "R" (set addwadfolder=) & (goto:SNKNANDCONFIRM)

if /i "%SNEEKSELECT%" NEQ "5" goto:skip5
if /i "%emuitems%" EQU "0" goto:badkey
:skip5

if /i "%SNKNANDCONFIRM%" EQU "Y" goto:creditcheck


:badkey
echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:SNKNANDCONFIRM




:creditcheck
::credit check removed, enjoy!
if /i "%AbstinenceWiz%" EQU "Y" goto:Download
if /i "%SNEEKSELECT%" EQU "1" goto:SNEEKINSTALLER
if /i "%SNEEKSELECT%" EQU "3" goto:SNEEKINSTALLER
if /i "%SNEEKSELECT%" EQU "2" goto:SNKNANDBUILDER
if /i "%SNEEKSELECT%" EQU "5" goto:SNKNANDBUILDER
goto:DLSETTINGS


::-----------------------------------Add WAD Folder to Install to emunand----------------------------------
:addwadfolder
set addwadfolder=
cls
echo                                        ModMii                                v%currentversion%
echo                                       by XFlak
echo.
echo.
echo.
echo       Enter the full path\folder of WADs you'd like to install to your emulated NAND
echo.
echo.
echo                * You can drag and drop the folder into this
echo                  window to save yourself having to manually type it
echo.
echo.
echo.
echo.
echo.
echo         B = Back
echo.
echo         M = Main Menu
echo.
echo.
set /p addwadfolder=     Enter Selection Here: 


::remove quotes from variable (if applicable)
echo "set addwadfolder=%addwadfolder%">temp.txt
support\sfk filter -quiet temp.txt -rep _""""__>temp.bat
call temp.bat
del temp.bat>nul
del temp.txt>nul


if /i "%addwadfolder%" EQU "M" (set addwadfolder=) & (goto:MENU)

if /i "%addwadfolder%" EQU "B" (set addwadfolder=) & (goto:SNKNANDCONFIRM)

:doublecheckwad
set fixslash=
if /i "%addwadfolder:~-1%" EQU "\" set fixslash=yes
if /i "%addwadfolder:~-1%" EQU "/" set fixslash=yes
if /i "%fixslash%" EQU "yes" set addwadfolder=%addwadfolder:~0,-1%
if /i "%fixslash%" EQU "yes" goto:doublecheckwad


if not exist "%addwadfolder%" (echo.) & (echo %addwadfolder% doesn't exist, please try again...) & (@ping 127.0.0.1 -n 2 -w 1000> nul) & (goto:addwadfolder)

::make sure second char is ":"
if /i "%addwadfolder:~1,1%" NEQ ":" (echo.) & (echo Enter the full path including the drive letter, please try again...) & (@ping 127.0.0.1 -n 2 -w 1000> nul) & (goto:addwadfolder)

if not exist "%addwadfolder%\*.wad" (echo.) & (echo No Wads found, please try a different folder...) & (@ping 127.0.0.1 -n 2 -w 1000> nul) & (goto:addwadfolder)

goto:SNKNANDCONFIRM






::...................................SNEEK Nand Builder...............................
:SNKNANDBUILDER


::temporarily force wads to be saved to "root" of "temp" folder
::Set ROOTSAVE=on
::set DRIVE=temp//happens later

if not exist "%nandpath%" mkdir "%nandpath%"
::if not exist temp\WAD mkdir temp\WAD

if /i "%SNEEKSELECT%" EQU "5" goto:quickskip

::backup setting.txt if applicable
if /i "%SNKSERIAL%" EQU "current" move /y "%nandpath%"\title\00000001\00000002\data\setting.txt "%nandpath%"\setting.txt >nul

::delete existing nand if exists
if exist "%nandpath%"\title echo.
if exist "%nandpath%"\title echo Deleting existing emulated nand...
if exist "%nandpath%"\title rd /s /q "%nandpath%"\title
if exist "%nandpath%"\ticket rd /s /q "%nandpath%"\ticket
if exist "%nandpath%"\sys rd /s /q "%nandpath%"\sys
if exist "%nandpath%"\shared1 rd /s /q "%nandpath%"\shared1
::import, meta, shared2, tmp are deleted but will not be recreated by NAND Builder
if exist "%nandpath%"\import rd /s /q "%nandpath%"\import
if exist "%nandpath%"\meta rd /s /q "%nandpath%"\meta
if exist "%nandpath%"\shared2 rd /s /q "%nandpath%"\shared2
if exist "%nandpath%"\tmp rd /s /q "%nandpath%"\tmp
if exist "%nandpath%"\wfs rd /s /q "%nandpath%"\wfs
if exist "%nandpath%\nandinfo.txt" del "%nandpath%\nandinfo.txt">nul


::if user selects S2U but has emulated nand on root without nandslot.bin, move existing nand to nands folder
if /i "%SNKS2U%" EQU "N" goto:quickskip
if exist "%DRIVEU%"\nandslot.bin goto:quickskip

SET /a NANDcountPLUS1=%NANDcount%+1

if not exist "%DRIVEU%"\title goto:quickskip
echo.
echo Moving existing emulated nand to \nands\%NANDcountPLUS1% folder...

if not exist "%DRIVEU%\nands\nand%NANDcountPLUS1%" mkdir "%DRIVEU%\nands\nand%NANDcountPLUS1%"

if exist "%DRIVEU%"\title move /y "%DRIVEU%"\title "%DRIVEU%\nands\nand%NANDcountPLUS1%\title"
if exist "%DRIVEU%"\ticket move /y "%DRIVEU%"\ticket "%DRIVEU%\nands\nand%NANDcountPLUS1%\ticket"
if exist "%DRIVEU%"\sys move /y "%DRIVEU%"\sys "%DRIVEU%\nands\nand%NANDcountPLUS1%\sys"
if exist "%DRIVEU%"\shared1 move /y "%DRIVEU%"\shared1 "%DRIVEU%\nands\nand%NANDcountPLUS1%\shared1"
::import, meta, shared2, tmp are deleted but will not be recreated by NAND Builder
if exist "%DRIVEU%"\import move /y "%DRIVEU%"\import "%DRIVEU%\nands\nand%NANDcountPLUS1%\import"
if exist "%DRIVEU%"\meta move /y "%DRIVEU%"\meta "%DRIVEU%\nands\nand%NANDcountPLUS1%\meta"
if exist "%DRIVEU%"\shared2 move /y "%DRIVEU%"\shared2 "%DRIVEU%\nands\nand%NANDcountPLUS1%\shared2"
if exist "%DRIVEU%"\tmp move /y "%DRIVEU%"\tmp "%DRIVEU%\nands\nand%NANDcountPLUS1%\tmp"
if exist "%DRIVEU%"\wfs move /y "%DRIVEU%"\wfs "%DRIVEU%\nands\nand%NANDcountPLUS1%\wfs"

:quickskip



::all
if /i "%MIIQ%" EQU "Y" set MII=*

if /i "%SNKREGION%" EQU "U" goto:SNKU
if /i "%SNKREGION%" EQU "E" goto:SNKE
if /i "%SNKREGION%" EQU "J" goto:SNKJ
if /i "%SNKREGION%" EQU "K" goto:SNKK

:SNKU
if /i "%SNKVERSION%" EQU "4.3" set SM4.3U=*
if /i "%SNKVERSION%" EQU "4.2" set SM4.2U=*
if /i "%SNKVERSION%" EQU "4.1" set SM4.1U=*
if /i "%ThemeSelection%" EQU "N" goto:SKIPSM

if /i "%ThemeSelection%" NEQ "R" goto:skip
if /i "%SNKVERSION%" EQU "4.3" set DarkWii_Red_4.3U=*
if /i "%SNKVERSION%" EQU "4.2" set DarkWii_Red_4.2U=*
if /i "%SNKVERSION%" EQU "4.1" set DarkWii_Red_4.1U=*
goto:SKIPSM
:skip

if /i "%ThemeSelection%" NEQ "G" goto:skip
if /i "%SNKVERSION%" EQU "4.3" set DarkWii_Green_4.3U=*
if /i "%SNKVERSION%" EQU "4.2" set DarkWii_Green_4.2U=*
if /i "%SNKVERSION%" EQU "4.1" set DarkWii_Green_4.1U=*
goto:SKIPSM
:skip

if /i "%ThemeSelection%" NEQ "BL" goto:skip
if /i "%SNKVERSION%" EQU "4.3" set DarkWii_Blue_4.3U=*
if /i "%SNKVERSION%" EQU "4.2" set DarkWii_Blue_4.2U=*
if /i "%SNKVERSION%" EQU "4.1" set DarkWii_Blue_4.1U=*
goto:SKIPSM
:skip

if /i "%ThemeSelection%" NEQ "O" goto:skip
if /i "%SNKVERSION%" EQU "4.3" set darkwii_orange_4.3U=*
if /i "%SNKVERSION%" EQU "4.2" set darkwii_orange_4.2U=*
if /i "%SNKVERSION%" EQU "4.1" set darkwii_orange_4.1U=*
goto:SKIPSM
:skip

if /i "%ThemeSelection%" NEQ "D" goto:skip
if /i "%SNKVERSION%" EQU "4.3" set A97=*
if /i "%SNKVERSION%" EQU "4.2" set A87=*
if /i "%SNKVERSION%" EQU "4.1" set A7b=*
goto:SKIPSM
:skip

:SKIPSM

::SMAPP is patched for UNEEK+DI Support
if /i "%SNKVERSION%" EQU "4.3" set SMAPP=00000098
if /i "%SNKVERSION%" EQU "4.2" set SMAPP=00000088
if /i "%SNKVERSION%" EQU "4.1" set SMAPP=0000007c
if /i "%PIC%" EQU "Y" (set P=*) & (set P0=*)
if /i "%NET%" EQU "Y" set IU=*
if /i "%WEATHER%" EQU "Y" set WU=*
if /i "%NEWS%" EQU "Y" set NU=*
if /i "%SHOP%" EQU "Y" set S=*
if /i "%SPEAK%" EQU "Y" set WSU=*
goto:SNKBUGGEDSMIOS

:SNKE
if /i "%SNKVERSION%" EQU "4.3" set SM4.3E=*
if /i "%SNKVERSION%" EQU "4.2" set SM4.2E=*
if /i "%SNKVERSION%" EQU "4.1" set SM4.1E=*
if /i "%ThemeSelection%" EQU "N" goto:SKIPSM

if /i "%ThemeSelection%" NEQ "R" goto:skip
if /i "%SNKVERSION%" EQU "4.3" set DarkWii_Red_4.3E=*
if /i "%SNKVERSION%" EQU "4.2" set DarkWii_Red_4.2E=*
if /i "%SNKVERSION%" EQU "4.1" set DarkWii_Red_4.1E=*
goto:SKIPSM
:skip

if /i "%ThemeSelection%" NEQ "G" goto:skip
if /i "%SNKVERSION%" EQU "4.3" set DarkWii_Green_4.3E=*
if /i "%SNKVERSION%" EQU "4.2" set DarkWii_Green_4.2E=*
if /i "%SNKVERSION%" EQU "4.1" set DarkWii_Green_4.1E=*
goto:SKIPSM
:skip

if /i "%ThemeSelection%" NEQ "BL" goto:skip
if /i "%SNKVERSION%" EQU "4.3" set DarkWii_Blue_4.3E=*
if /i "%SNKVERSION%" EQU "4.2" set DarkWii_Blue_4.2E=*
if /i "%SNKVERSION%" EQU "4.1" set DarkWii_Blue_4.1E=*
goto:SKIPSM
:skip

if /i "%ThemeSelection%" NEQ "O" goto:skip
if /i "%SNKVERSION%" EQU "4.3" set darkwii_orange_4.3E=*
if /i "%SNKVERSION%" EQU "4.2" set darkwii_orange_4.2E=*
if /i "%SNKVERSION%" EQU "4.1" set darkwii_orange_4.1E=*
goto:SKIPSM
:skip

if /i "%ThemeSelection%" NEQ "D" goto:skip
if /i "%SNKVERSION%" EQU "4.3" set A9a=*
if /i "%SNKVERSION%" EQU "4.2" set A8a=*
if /i "%SNKVERSION%" EQU "4.1" set A7e=*
goto:SKIPSM
:skip

:SKIPSM
if /i "%SNKVERSION%" EQU "4.3" set SMAPP=0000009b
if /i "%SNKVERSION%" EQU "4.2" set SMAPP=0000008b
if /i "%SNKVERSION%" EQU "4.1" set SMAPP=0000007f
if /i "%PIC%" EQU "Y" (set P=*) & (set P0=*)
if /i "%NET%" EQU "Y" set IE=*
if /i "%WEATHER%" EQU "Y" set WE=*
if /i "%NEWS%" EQU "Y" set NE=*
if /i "%SHOP%" EQU "Y" set S=*
if /i "%SPEAK%" EQU "Y" set WSE=*
goto:SNKBUGGEDSMIOS

:SNKJ
if /i "%SNKVERSION%" EQU "4.3" set SM4.3J=*
if /i "%SNKVERSION%" EQU "4.2" set SM4.2J=*
if /i "%SNKVERSION%" EQU "4.1" set SM4.1J=*
if /i "%ThemeSelection%" EQU "N" goto:SKIPSM

if /i "%ThemeSelection%" NEQ "R" goto:skip
if /i "%SNKVERSION%" EQU "4.3" set DarkWii_Red_4.3J=*
if /i "%SNKVERSION%" EQU "4.2" set DarkWii_Red_4.2J=*
if /i "%SNKVERSION%" EQU "4.1" set DarkWii_Red_4.1J=*
goto:SKIPSM
:skip

if /i "%ThemeSelection%" NEQ "G" goto:skip
if /i "%SNKVERSION%" EQU "4.3" set DarkWii_Green_4.3J=*
if /i "%SNKVERSION%" EQU "4.2" set DarkWii_Green_4.2J=*
if /i "%SNKVERSION%" EQU "4.1" set DarkWii_Green_4.1J=*
goto:SKIPSM
:skip

if /i "%ThemeSelection%" NEQ "BL" goto:skip
if /i "%SNKVERSION%" EQU "4.3" set DarkWii_Blue_4.3J=*
if /i "%SNKVERSION%" EQU "4.2" set DarkWii_Blue_4.2J=*
if /i "%SNKVERSION%" EQU "4.1" set DarkWii_Blue_4.1J=*
goto:SKIPSM
:skip

if /i "%ThemeSelection%" NEQ "O" goto:skip
if /i "%SNKVERSION%" EQU "4.3" set darkwii_orange_4.3J=*
if /i "%SNKVERSION%" EQU "4.2" set darkwii_orange_4.2J=*
if /i "%SNKVERSION%" EQU "4.1" set darkwii_orange_4.1J=*
goto:SKIPSM
:skip

if /i "%ThemeSelection%" NEQ "D" goto:skip
if /i "%SNKVERSION%" EQU "4.3" set A94=*
if /i "%SNKVERSION%" EQU "4.2" set A84=*
if /i "%SNKVERSION%" EQU "4.1" set A78=*
goto:SKIPSM
:skip

:SKIPSM
if /i "%SNKVERSION%" EQU "4.3" set SMAPP=00000095
if /i "%SNKVERSION%" EQU "4.2" set SMAPP=00000085
if /i "%SNKVERSION%" EQU "4.1" set SMAPP=00000079
if /i "%PIC%" EQU "Y" (set P=*) & (set P0=*)
if /i "%NET%" EQU "Y" set IJ=*
if /i "%WEATHER%" EQU "Y" set WJ=*
if /i "%NEWS%" EQU "Y" set NJ=*
if /i "%SHOP%" EQU "Y" set S=*
if /i "%SPEAK%" EQU "Y" set WSJ=*
goto:SNKBUGGEDSMIOS

:SNKK
if /i "%SNKVERSION%" EQU "4.3" set SM4.3K=*
if /i "%SNKVERSION%" EQU "4.2" set SM4.2K=*
if /i "%SNKVERSION%" EQU "4.1" set SM4.1K=*
if /i "%ThemeSelection%" EQU "N" goto:SKIPSM

if /i "%ThemeSelection%" NEQ "R" goto:skip
if /i "%SNKVERSION%" EQU "4.3" set DarkWii_Red_4.3K=*
if /i "%SNKVERSION%" EQU "4.2" set DarkWii_Red_4.2K=*
if /i "%SNKVERSION%" EQU "4.1" set DarkWii_Red_4.1K=*
goto:SKIPSM
:skip

if /i "%ThemeSelection%" NEQ "G" goto:skip
if /i "%SNKVERSION%" EQU "4.3" set DarkWii_Green_4.3K=*
if /i "%SNKVERSION%" EQU "4.2" set DarkWii_Green_4.2K=*
if /i "%SNKVERSION%" EQU "4.1" set DarkWii_Green_4.1K=*
goto:SKIPSM
:skip

if /i "%ThemeSelection%" NEQ "BL" goto:skip
if /i "%SNKVERSION%" EQU "4.3" set DarkWii_Blue_4.3K=*
if /i "%SNKVERSION%" EQU "4.2" set DarkWii_Blue_4.2K=*
if /i "%SNKVERSION%" EQU "4.1" set DarkWii_Blue_4.1K=*
goto:SKIPSM
:skip

if /i "%ThemeSelection%" NEQ "O" goto:skip
if /i "%SNKVERSION%" EQU "4.3" set darkwii_orange_4.3K=*
if /i "%SNKVERSION%" EQU "4.2" set darkwii_orange_4.2K=*
if /i "%SNKVERSION%" EQU "4.1" set darkwii_orange_4.1K=*
goto:SKIPSM
:skip

if /i "%ThemeSelection%" NEQ "D" goto:skip
if /i "%SNKVERSION%" EQU "4.3" set A9d=*
if /i "%SNKVERSION%" EQU "4.2" set A8d=*
if /i "%SNKVERSION%" EQU "4.1" set A81=*
goto:SKIPSM
:skip

:SKIPSM
if /i "%SNKVERSION%" EQU "4.3" set SMAPP=0000009e
if /i "%SNKVERSION%" EQU "4.2" set SMAPP=0000008e
if /i "%SNKVERSION%" EQU "4.1" set SMAPP=00000082
if /i "%PIC%" EQU "Y" (set PK=*) & (set P0=*)
if /i "%SHOP%" EQU "Y" set SK=*


:SNKBUGGEDSMIOS
if /i "%SNEEKSELECT%" EQU "5" goto:skipthis

if /i "%SNKVERSION%" EQU "4.1" set IOS60P=*
if /i "%SNKVERSION%" EQU "4.2" set IOS70K=*
if /i "%SNKVERSION%" EQU "4.3" set IOS80K=*



::activeios
set M10=*
set IOS9=*
set IOS12=*
set IOS13=*
set IOS14=*
set IOS15=*
set IOS17=*
set IOS21=*
set IOS22=*
set IOS28=*
set IOS31=*
set IOS33=*
set IOS34=*
set IOS35=*
set IOS36v3608=*
set IOS37=*
set IOS38=*
set ios41=*
set ios43=*
set ios45=*
set ios46=*
set IOS48v4124=*
set IOS53=*
set IOS55=*
set IOS56=*
set IOS57=*
set IOS58=*
set IOS61=*
set IOS62=*
if /i "%SNKREGION%" EQU "U" set EULAU=*
if /i "%SNKREGION%" EQU "E" set EULAE=*
if /i "%SNKREGION%" EQU "J" set EULAJ=*
if /i "%SNKREGION%" EQU "K" set EULAK=*

:skipthis

if /i "%SHOP%" EQU "Y" set IOS56=*

if /i "%SNEEKSELECT%" EQU "5" (set SM4.3U=) & (set SM4.2U=) & (set SM4.1U=) & (set SM4.3E=) & (set SM4.2E=) & (set SM4.1E=) & (set SM4.3J=) & (set SM4.2J=) & (set SM4.1J=) & (set SM4.3K=) & (set SM4.2K=) & (set SM4.1K=)

set BC=*
::if /i "%SNKcBC%" EQU "NMM" set cBC=*
::::if /i "%SNKcBC%" EQU "DML" set DML=*
::if /i "%SNKcBC%" EQU "DML" set BC=*
::if /i "%SNKcBC%" EQU "N" set BC=*

if /i "%SNEEKSELECT%" NEQ "5" goto:skipdeselect
if /i "%BCtype%" EQU "BC" set BC=
if /i "%BCtype%" EQU "DML" set DML=
if /i "%BCtype%" EQU "NMM" set cBC=
:skipdeselect


if /i "%SNKCIOS%" EQU "Y" set cIOS249-v14=*

if /i "%PRIIFOUND%" EQU "Yes" goto:skip1line
if /i "%SNKPRI%" EQU "Y" set HAX=*
:skip1line

if /i "%SNKFLOW%" EQU "Y" set FLOWF=*
if /i "%SNKPLC%" EQU "Y" set PLC=*
if /i "%SNKS2U%" EQU "Y" set S2U=*
if /i "%SNKS2U%" NEQ "Y" set nSwitch=*
if /i "%nswitchFound%" EQU "Yes" set nSwitch=

IF "%SMAPP%"=="" goto:miniskip

::subract 1 from %SMAPP% to get %SMTHEMEAPP%
support\sfk dec %SMAPP%>dec.txt

::Loop through the the following once for EACH line in whatever.txt
for /F "tokens=*" %%A in (dec.txt) do call :processdec %%A
goto:nextstep

:processdec
set dec=%*
goto:EOF
:nextstep

del dec.txt>nul
SET /a dec=%dec%-1
support\sfk hex %dec% -digits=8 >hex.txt

::Loop through the the following once for EACH line in whatever.txt
for /F "tokens=*" %%A in (hex.txt) do call :processhex %%A
goto:nextstep

:processhex
::this is repeated for each line of the txt.file
::"%*" (no quotes) is the variable for each line as it passes through the loop
set SMTHEMEAPP=%*
goto:EOF
:nextstep

del hex.txt>nul

::change caps to lower case for hex numbers if applicable
if /i "%SMTHEMEAPP:~-1%" EQU "A" set SMTHEMEAPP=%SMTHEMEAPP:~0,-1%a
if /i "%SMTHEMEAPP:~-1%" EQU "B" set SMTHEMEAPP=%SMTHEMEAPP:~0,-1%b
if /i "%SMTHEMEAPP:~-1%" EQU "C" set SMTHEMEAPP=%SMTHEMEAPP:~0,-1%c
if /i "%SMTHEMEAPP:~-1%" EQU "D" set SMTHEMEAPP=%SMTHEMEAPP:~0,-1%d
if /i "%SMTHEMEAPP:~-1%" EQU "E" set SMTHEMEAPP=%SMTHEMEAPP:~0,-1%e
if /i "%SMTHEMEAPP:~-1%" EQU "F" set SMTHEMEAPP=%SMTHEMEAPP:~0,-1%f

:miniskip

if /i "%AbstinenceWiz%" EQU "Y" set nswitch=*

goto:DLCOUNT


::..............................Emulated NAND Modifer - SNK NAND Selector....................
:SNKNANDSELECTOR
set drivetemp=
set NANDPATH=
set SNKREGION=
set SMAPP=
set SMTHEMEAPP=
set SNKVERSION=
set PRIIFOUND=

cls
echo                                        ModMii                                v%currentversion%
echo                                       by XFlak
echo.
echo.
echo                                EMULATED NAND MODIFIER
echo.
echo.
echo.
echo          Enter the Path of your Emulated NAND
echo.
echo.
echo.
echo.
echo          Note: * You can drag and drop the Drive/folder into this
echo                  window to save yourself having to manually type it
echo.
echo.
echo.
echo         EXAMPLES
echo.
echo.
echo            L:
echo.
echo            H:\nands\nand1
echo.
echo.
echo.
echo.
echo         B = Back
echo.
echo         M = Main Menu
echo.
echo.
set /p DRIVETEMP=     Enter Selection Here: 


::remove quotes from variable (if applicable)
echo "set DRIVETEMP=%DRIVETEMP%">temp.txt
support\sfk filter -quiet temp.txt -rep _""""__>temp.bat
call temp.bat
del temp.bat>nul
del temp.txt>nul

if /i "%DRIVETEMP%" EQU "B" goto:SNKPAGE1
if /i "%DRIVETEMP%" EQU "M" goto:MENU



:doublecheckNANDPATH

::---------------CMD LINE MODE-------------
if /i "%cmdlinemodeswitchoff%" EQU "Y" (set cmdlinemode=) & (set one=) & (set two=)

set fixslash=
if /i "%DRIVETEMP:~-1%" EQU "\" set fixslash=yes
if /i "%DRIVETEMP:~-1%" EQU "/" set fixslash=yes
if /i "%fixslash%" EQU "yes" set DRIVETEMP=%DRIVETEMP:~0,-1%
if /i "%fixslash%" EQU "yes" goto:doublecheckNANDPATH

if not exist "%DRIVETEMP%" goto:notexist

if not exist "%DRIVETEMP%\title" goto:notexistnand
if not exist "%DRIVETEMP%\sys" goto:notexistnand
if not exist "%DRIVETEMP%\ticket" goto:notexistnand
if not exist "%DRIVETEMP%\shared1" goto:notexistnand


::Get NAND Info

if not exist "%DRIVETEMP%\title\00000001\00000002\content\title.tmd" goto:notitle

support\sfk hexdump -pure -nofile "%DRIVETEMP%\title\00000001\00000002\content\title.tmd">temp\hexdump.txt
FINDSTR /N . temp\hexdump.txt>temp\hexdump2.txt
del temp\hexdump.txt>nul
support\sfk filter -quiet "temp\hexdump2.txt" -+"49:" -write -yes
set /p SMAPP= <temp\hexdump2.txt
set SMAPP=%SMAPP:~11,8%
del temp\hexdump2.txt>nul
:notitle

if "%SMAPP%"=="" goto:miniskip
if /i "%SMAPP%" EQU "00000098" (set SNKREGION=U) & (set SNKVERSION=4.3)
if /i "%SMAPP%" EQU "00000088" (set SNKREGION=U) & (set SNKVERSION=4.2)
if /i "%SMAPP%" EQU "0000007c" (set SNKREGION=U) & (set SNKVERSION=4.1)
if /i "%SMAPP%" EQU "0000009b" (set SNKREGION=E) & (set SNKVERSION=4.3)
if /i "%SMAPP%" EQU "0000008b" (set SNKREGION=E) & (set SNKVERSION=4.2)
if /i "%SMAPP%" EQU "0000007f" (set SNKREGION=E) & (set SNKVERSION=4.1)
if /i "%SMAPP%" EQU "00000095" (set SNKREGION=J) & (set SNKVERSION=4.3)
if /i "%SMAPP%" EQU "00000085" (set SNKREGION=J) & (set SNKVERSION=4.2)
if /i "%SMAPP%" EQU "00000079" (set SNKREGION=J) & (set SNKVERSION=4.1)
if /i "%SMAPP%" EQU "0000009e" (set SNKREGION=K) & (set SNKVERSION=4.3)
if /i "%SMAPP%" EQU "0000008e" (set SNKREGION=K) & (set SNKVERSION=4.2)
if /i "%SMAPP%" EQU "00000082" (set SNKREGION=K) & (set SNKVERSION=4.1)

if /i "%SNKREGION%" EQU "U" set defaultserial=LU521175683
if /i "%SNKREGION%" EQU "E" set defaultserial=LEH133789940
if /i "%SNKREGION%" EQU "J" set defaultserial=LJM101175683
if /i "%SNKREGION%" EQU "K" set defaultserial=LJM101175683
:miniskip

::check for priiloader
if exist "%DRIVETEMP%\title\00000001\00000002\content\1%SMAPP:~1%.app" (set PRIIFOUND=YES) else (set PRIIFOUND=NO)


::check for current nswitch channel
set nSwitchFOUND=NO
set nswitchmd5=9f5ee8d0ea57c144c07d685ef0dee4da
::if exist "temp\DBUPDATE%currentversion%.bat" call "temp\DBUPDATE%currentversion%.bat"
if not exist "%DRIVETEMP%\title\00010001\4e4b324f\content\00000001.app" goto:nonswitchcheck
support\sfk md5 -quiet -verify %nswitchmd5% "%DRIVETEMP%\title\00010001\4e4b324f\content\00000001.app"
if not errorlevel 1 set nSwitchFOUND=YES
:nonswitchcheck




::check for BC, NMM or DML
set BCtype=
set BCmd5=eb1b69f3d747145651aa834078c2aacd
set DMLmd5=88720d0de8c7db7bf00f5053b76ae66b
set NMMmd5=8663c24ab33540af6a818920a3a47c4a
::if exist "temp\DBUPDATE%currentversion%.bat" call "temp\DBUPDATE%currentversion%.bat"

if not exist "%DRIVETEMP%\title\00000001\00000100\content\00000008.app" (set BCtype=None) & (goto:noBCcheck)


support\sfk md5 -quiet -verify %BCmd5% "%DRIVETEMP%\title\00000001\00000100\content\00000008.app"
if not errorlevel 1 set BCtype=BC


IF "%BCtype%"=="" set BCtype=DML


support\sfk md5 -quiet -verify %NMMmd5% "%DRIVETEMP%\title\00000001\00000100\content\00000008.app"
if not errorlevel 1 set BCtype=NMM

:noBCcheck




IF "%SMAPP%"=="" goto:miniskip

::subract 1 from %SMAPP% to get %SMTHEMEAPP%
support\sfk dec %SMAPP%>dec.txt

::Loop through the the following once for EACH line in whatever.txt
for /F "tokens=*" %%A in (dec.txt) do call :processdec %%A
goto:nextstep

:processdec
set dec=%*
goto:EOF
:nextstep

del dec.txt>nul
SET /a dec=%dec%-1
support\sfk hex %dec% -digits=8 >hex.txt

::Loop through the the following once for EACH line in whatever.txt
for /F "tokens=*" %%A in (hex.txt) do call :processhexapp %%A
goto:nextstep

:processhexapp
::this is repeated for each line of the txt.file
::"%*" (no quotes) is the variable for each line as it passes through the loop
set SMTHEMEAPP=%*
goto:EOF
:nextstep

del hex.txt>nul

::change caps to lower case for hex numbers if applicable
if /i "%SMTHEMEAPP:~-1%" EQU "A" set SMTHEMEAPP=%SMTHEMEAPP:~0,-1%a
if /i "%SMTHEMEAPP:~-1%" EQU "B" set SMTHEMEAPP=%SMTHEMEAPP:~0,-1%b
if /i "%SMTHEMEAPP:~-1%" EQU "C" set SMTHEMEAPP=%SMTHEMEAPP:~0,-1%c
if /i "%SMTHEMEAPP:~-1%" EQU "D" set SMTHEMEAPP=%SMTHEMEAPP:~0,-1%d
if /i "%SMTHEMEAPP:~-1%" EQU "E" set SMTHEMEAPP=%SMTHEMEAPP:~0,-1%e
if /i "%SMTHEMEAPP:~-1%" EQU "F" set SMTHEMEAPP=%SMTHEMEAPP:~0,-1%f

:miniskip


set NANDPATH=%DRIVETEMP%

::echo NANDPATH=%NANDPATH%
::echo SNKREGION=%SNKREGION%
::echo SMAPP=%SMAPP%
::echo SMTHEMEAPP=%SMTHEMEAPP%
::echo SNKVERSION=%SNKVERSION%
::echo PRIIFOUND=%PRIIFOUND%


if "%SNKREGION%"=="" (goto:FOLLOWUPQ) else (goto:SNKPAGE4a)

:notexist
echo The folder you selected does not exist
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:SNKNANDSELECTOR

:notexistnand
echo The folder you selected does not contain an Emulated NAND
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:SNKNANDSELECTOR

::-----Unable to determine region, ask user-----
::..............................Emulated NAND Modifer - SNK NAND Selector....................
:FOLLOWUPQ
set SNKREGION=

cls
echo                                        ModMii                                v%currentversion%
echo                                       by XFlak
echo.
echo.
echo                                EMULATED NAND MODIFIER
echo.
echo.
echo.
echo          ModMii is unable to determine the Region of your NAND.
echo.
echo          What Region is your Emulated NAND?
echo.
echo.
echo.
echo.
echo          Note: Theme modifiers are disabled for Emulated NANDs 4.0 or less
echo.
echo.
echo.
echo                U = USA
echo                E = Euro (PAL)
echo                J = JAP
echo                K = Korean
echo.
echo.
echo.
echo.
echo         B = Back
echo.
echo         M = Main Menu
echo.
echo.
set /p SNKREGION=     Enter Selection Here: 


if /i "%SNKREGION%" EQU "U" goto:SNKPAGE4a
if /i "%SNKREGION%" EQU "E" goto:SNKPAGE4a
if /i "%SNKREGION%" EQU "J" goto:SNKPAGE4a
if /i "%SNKREGION%" EQU "K" goto:SNKPAGE4a

if /i "%SNKREGION%" EQU "M" goto:MENU
if /i "%SNKREGION%" EQU "B" goto:SNKNANDSELECTOR

:badkey
echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:FOLLOWUPQ


::...................................SNEEK SNK DISC EXtractor...............................
:SNKDISCEX

IF "%ISOFOLDER%"=="" goto:checkwbfs
IF "%ISOFOLDER%"=="" set ISOFOLDER=%DRIVEU%\WBFS

goto:skip

:checkwbfs
if exist "A:\WBFS" set ISOFOLDER=A:\WBFS
if exist "B:\WBFS" set ISOFOLDER=B:\WBFS
if exist "C:\WBFS" set ISOFOLDER=C:\WBFS
if exist "D:\WBFS" set ISOFOLDER=D:\WBFS
if exist "E:\WBFS" set ISOFOLDER=E:\WBFS
if exist "F:\WBFS" set ISOFOLDER=F:\WBFS
if exist "G:\WBFS" set ISOFOLDER=G:\WBFS
if exist "H:\WBFS" set ISOFOLDER=H:\WBFS
if exist "I:\WBFS" set ISOFOLDER=I:\WBFS
if exist "J:\WBFS" set ISOFOLDER=J:\WBFS
if exist "K:\WBFS" set ISOFOLDER=K:\WBFS
if exist "L:\WBFS" set ISOFOLDER=L:\WBFS
if exist "M:\WBFS" set ISOFOLDER=M:\WBFS
if exist "N:\WBFS" set ISOFOLDER=N:\WBFS
if exist "O:\WBFS" set ISOFOLDER=O:\WBFS
if exist "P:\WBFS" set ISOFOLDER=P:\WBFS
if exist "Q:\WBFS" set ISOFOLDER=Q:\WBFS
if exist "R:\WBFS" set ISOFOLDER=R:\WBFS
if exist "S:\WBFS" set ISOFOLDER=S:\WBFS
if exist "T:\WBFS" set ISOFOLDER=T:\WBFS
if exist "U:\WBFS" set ISOFOLDER=U:\WBFS
if exist "V:\WBFS" set ISOFOLDER=V:\WBFS
if exist "W:\WBFS" set ISOFOLDER=W:\WBFS
if exist "X:\WBFS" set ISOFOLDER=X:\WBFS
if exist "Y:\WBFS" set ISOFOLDER=Y:\WBFS
if exist "Z:\WBFS" set ISOFOLDER=Z:\WBFS
IF "%ISOFOLDER%"=="" set ISOFOLDER=%DRIVEU%\WBFS
:skip


set drivetemp=%ISOFOLDER%

if exist gametotal.txt del gametotal.txt>nul

cls
echo                                        ModMii                                v%currentversion%
echo                                       by XFlak
echo.
echo.
echo                                  GAME BULK EXTRACTOR
echo                                      (FOR SNEEK)
echo.
echo.
echo         Enter the Path where your Wii or Gamecube Games are saved
echo.
echo                * Subfolders are also scanned
echo                * Supported formats include ISO, CISO and WBFS files
echo.
echo.
echo    Current Setting:
echo.
echo         %ISOFOLDER%
echo.
echo.
echo         Notes: * To continue using Current Settings
echo                  leave the selection blank and hit enter.
echo.
echo                * You can drag and drop the Drive/folder into this
echo                  window to save yourself having to manually type it
echo.
echo.
echo.
echo         EXAMPLES
echo.
echo.
echo            L:
echo.
echo            %%userprofile%%\Desktop\WiiGames
echo                  Note: %%userprofile%% shortcut doesn't work on Windows XP
echo.
echo            WiiGames\ISOs
echo                  Note: this checks the WiiGames\ISOs folder where ModMii is saved
echo.
echo            C:\Users\XFlak\Desktop\New Folder
echo.
echo.
echo.
echo         B = Back
echo.
echo         M = Main Menu
echo.
echo.
set /p DRIVETEMP=     Enter Selection Here: 


::remove quotes from variable (if applicable)
echo "set DRIVETEMP=%DRIVETEMP%">temp.txt
support\sfk filter -quiet temp.txt -rep _""""__>temp.bat
call temp.bat
del temp.bat>nul
del temp.txt>nul



if /i "%DRIVETEMP%" EQU "B" goto:SNKPAGE1
if /i "%DRIVETEMP%" EQU "M" goto:MENU



:doublecheckISOFOLDER
set fixslash=
if /i "%DRIVETEMP:~-1%" EQU "\" set fixslash=yes
if /i "%DRIVETEMP:~-1%" EQU "/" set fixslash=yes
if /i "%fixslash%" EQU "yes" set DRIVETEMP=%DRIVETEMP:~0,-1%
if /i "%fixslash%" EQU "yes" goto:doublecheckISOFOLDER



if not exist "%DRIVETEMP%" goto:notexist


::---get game list-------
echo.
echo Scanning directory for Wii Games...
::Support\wit list-l --unit GB --recurse "%DRIVETEMP%">gametotal.txt
Support\wit list-l --recurse "%DRIVETEMP%">gametotal.txt
copy /y gametotal.txt gametotal.bat >nul
support\sfk filter gametotal.bat -ls+Total -rep _"Total: "_"set gametotal="_ -rep _" discs*"__ -write -yes>nul
call gametotal.bat
del gametotal.bat>nul
if /i "%gametotal%" EQU "0" goto:notexistiso

set ISOFOLDER=%DRIVETEMP%
set BACKB4DRIVEU=SNKDISCEX
goto:DRIVEUCHANGE


:notexist
echo The folder you selected does not exist
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:SNKDISCEX

:notexistiso
del gamelist.txt>nul
echo The folder you selected does not contain any ISO, CISO or WBFS Files
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:SNKDISCEX


::...................................SNK DISC EXtractor2...............................
:SNKDISCEX2

echo.
echo Checking if enough free space exists...

::wit beta--> isosize command
::wit isosize --unit bytes -r "%ISOFOLDER%"

::---get required MB-------
copy /y gametotal.txt gametotal.bat >nul
::support\sfk filter gametotal.bat -ls+Total -rep _*"~ "_"set MegaBytesRequired="_ -rep _" MB*"__ -write -yes>nul
support\sfk filter gametotal.bat -ls+Total -rep _*", "_"set MegaBytesRequired="_ -rep _" MiB*"__ -write -yes>nul
call gametotal.bat
del gametotal.bat>nul

if %MegaBytesRequired% GEQ 1000 (set units=GB) else (set units=MB)


::echo Downloading hy.exe
if exist temp\hy.exe goto:AlreadyinTemp
if not exist hypatia.zip start %ModMiimin%/wait support\wget --no-check-certificate -t 3 http://www.milletre.net/software/hypatia/hypatia.zip
if exist hypatia.zip support\7za e -aoa hypatia.zip -otemp hy.exe -r
if exist hypatia.zip del hypatia.zip>nul
:AlreadyinTemp



::---get approx required GB-------
cd temp
hy %MegaBytesRequired% 1024 />nul
::above command stores output in a "hy" file
cd..

move /y temp\hy gigabytesrequired.txt>nul
support\sfk filter gigabytesrequired.txt -rep _".*"__ -write -yes>nul

::Loop through the the following once for EACH line in whatever.txt
for /F "tokens=*" %%A in (gigabytesrequired.txt) do call :process %%A
goto:nextstep

:process
::this is repeated for each line of the txt.file
::"%*" (no quotes) is the variable for each line as it passes through the loop
set GigaBytesRequired=%*
goto:EOF
:nextstep

del gigabytesrequired.txt>nul


::---check for free space (not 100% accurate-will catch most cases without enough free space)---

if not exist "%DRIVEU%" mkdir "%DRIVEU%"
dir "%DRIVEU%">freespace.bat


support\sfk filter freespace.bat -+"bytes " -+"octets " -+"Directory " -!"Directory of" -!"Directory di" -rep _" byte"*__ -rep _" octets"*__ -rep _,__ -rep _.__ -rep _" "__ -rep _*")"_"set freespace="_ -rep _*"dirs"_"set freespace="_ -rep _*"Directory"_"set freespace="_ -write -yes>nul
support\sfk filter freespace.bat -spat -rep _\xff__ -write -yes>nul

::Italian-dir cmd: 14 Directory  546.480.881.664 byte disponibili

call freespace.bat
del freespace.bat>nul

::Math in batch doesn't work with large numbers
::SET /a freespaceKB=%freespace%/1024

cd temp
hy %freespace% 1048576 />nul
::above command stores output in a "hy" file
cd..
move /y temp\hy megabytes.txt>nul
support\sfk filter megabytes.txt -rep _".*"__ -write -yes>nul

::Loop through the the following once for EACH line in whatever.txt
for /F "tokens=*" %%A in (megabytes.txt) do call :process %%A
goto:nextstep

:process
::this is repeated for each line of the txt.file
::"%*" (no quotes) is the variable for each line as it passes through the loop
set freespaceMB=%*
goto:EOF
:nextstep

del megabytes.txt>nul

::echo MegaBytesRequired is %MegaBytesRequired%
::echo GigaBytesRequired is %GigaBytesRequired%
::echo Total Free Space is approximately %freespaceMB% MB [%freespace% bytes]
::pause


if %MegaBytesRequired% GEQ %freespaceMB% (goto:needmorespace) else (goto:DISCEXCONFIRM)


::-------------------------------------DISCEX NEED MORE SPACE!!!---------------
:needmorespace
cls
set continue=

::resize window
set lines=
set gametotal=
SET /a LINES=%gametotal%+42
if %LINES% LEQ 54 set lines=54
mode con cols=85 lines=%LINES%

echo                                        ModMii                                v%currentversion%
echo                                       by XFlak
echo.
echo.
echo                                  GAME BULK EXTRACTOR
echo                                      (FOR SNEEK)
echo.
echo.
echo.
support\sfk echo -spat \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20[Red]WARNING: YOU DO NOT HAVE ENOUGH FREE SPACE
echo.
echo.
echo.
echo         You are attempting to convert %gametotal% Wii Games
echo.
echo     From Source Folder: %ISOFOLDER%
echo       To Target Folder: %DRIVEU%\games
echo.

::Loop through the the following once for EACH line in gamelist.txt and turn each line of gamelist.txt into a variable
for /F "tokens=*" %%A in (gametotal.txt) do call :process %%A
goto:nextstep

:process
::this is repeated for each line of the txt.file
::"%*" (no quotes) is the variable for each line as it passes through the loop
echo %*
goto:EOF
:nextstep

echo.
echo.
echo.
if /i "%units%" EQU "GB" support\sfk echo -spat \x20 \x20 \x20 \x20[Red]"%DRIVEU%" requires approx. %GigaBytesRequired%GB of free space
if /i "%units%" EQU "MB" support\sfk echo -spat \x20 \x20 \x20 \x20[Red]"%DRIVEU%" requires %MegaBytesRequired%MB of free space
echo.
support\sfk echo -spat \x20 \x20 \x20 \x20[Red]Create more free space or select a smaller source folder and try again
echo.
echo.
echo.


echo                C = Continue anyways
echo.
echo                M = Main Menu
echo.
echo.
echo.
set /p continue=     Enter Selection Here: 

if /i "%continue%" EQU "M" del gametotal.txt>nul
if /i "%continue%" EQU "M" goto:MENU
if /i "%continue%" EQU "C" goto:DISCEXCONFIRM

echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:needmorespace



::-------------------------------------DISCEX CONFIRM---------------
:DISCEXCONFIRM
cls
set DISCEXCONFIRM=

::resize window
set lines=
set gametotal=
SET /a LINES=%gametotal%+45
if %LINES% LEQ 54 set lines=54
mode con cols=85 lines=%LINES%

echo                                        ModMii                                v%currentversion%
echo                                       by XFlak
echo.
echo.
echo                                  GAME BULK EXTRACTOR
echo                                      (FOR SNEEK)
echo.
echo         You are about to convert the following %gametotal% Wii Games
echo.
echo     From Source Folder: %ISOFOLDER%
echo       To Target Folder: %DRIVEU%\games
echo.

::Loop through the the following once for EACH line in gamelist.txt and turn each line of gamelist.txt into a variable
for /F "tokens=*" %%A in (gametotal.txt) do call :process %%A
goto:nextstep

:process
::this is repeated for each line of the txt.file
::"%*" (no quotes) is the variable for each line as it passes through the loop
echo %*
goto:EOF
:nextstep


echo.
echo.
echo     Would you like to proceed?
echo.
echo.
::echo       Notes: * Each game could take approximately 5-15 minutes to convert
::echo.
::echo              * Make sure you have enough free space here: %DRIVEU%
::echo                otherwise extraction will fail when free space is depleted
echo.
echo.
echo.
echo                Y = Yes
echo.
echo                N = No
echo.
echo.
echo.
echo                B = Back
echo.
echo                M = Main Menu
echo.
echo.
echo.
set /p DISCEXCONFIRM=     Enter Selection Here: 


if /i "%DISCEXCONFIRM%" EQU "M" del gametotal.txt>nul
if /i "%DISCEXCONFIRM%" EQU "N" del gametotal.txt>nul
if /i "%DISCEXCONFIRM%" EQU "Y" del gametotal.txt>nul


if /i "%DISCEXCONFIRM%" EQU "M" goto:MENU
if /i "%DISCEXCONFIRM%" EQU "N" goto:MENU
if /i "%DISCEXCONFIRM%" EQU "Y" mode con cols=85 lines=54
if /i "%DISCEXCONFIRM%" EQU "Y" goto:DISCEXSTART
if /i "%DISCEXCONFIRM%" EQU "B" mode con cols=85 lines=54
if /i "%DISCEXCONFIRM%" EQU "B" goto:DRIVEUCHANGE

echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:DISCEXCONFIRM



::----------------Start WIT DISCEXTRACTION---------------
:DISCEXSTART
cls
echo                                        ModMii                                v%currentversion%
echo                                       by XFlak
echo.
echo.
echo                                  GAME BULK EXTRACTOR
echo                                      (FOR SNEEK)
echo.
echo.
echo Updating Wii Game Title Database (titles.txt)
echo.
echo.

::if exist Support\titles.txt move /y Support\titles.txt Support\titles_old.txt >nul
start %ModMiimin%/wait support\wget --no-check-certificate -t 3 www.wiitdb.com/titles.txt
if exist titles.txt move /y titles.txt Support\titles.txt>nul


::rename existing games to new standard
if not exist "%DRIVEU%"\games goto:nextstep
dir "%DRIVEU%"\games /A:D /b > GameTitleIDs.txt
for /F "tokens=*" %%A in (GameTitleIDs.txt) do call :processdir %%A
goto:nextstep
:processdir
set CurrentTitleID=%*
if /i "%CurrentTitleID:~-8,1%" EQU "[" rename "%DRIVEU%\games\%CurrentTitleID%" "%CurrentTitleID:~-7,6%">nul
goto:EOF
:nextstep

if exist GameTitleIDs.txt del GameTitleIDs.txt>nul


::reverse slashes for target folder %DRIVEU%\games which becomes %DRIVEUfix%/games
echo set DRIVEUfix=%DRIVEU%>temp.bat
support\sfk filter temp.bat -rep _\_/_ -write -yes>nul
call temp.bat
del temp.bat>nul

::IMPORTANT NOTE: destination directory must use "/" and not "\"
::target directory, including "games" folder, is creating automatically with the following wit command

::Support\wit x --sneek --recurse "%ISOFOLDER%" "%DRIVEUfix%/games/%%14T [%%I]" --progress
::Support\wit x --sneek --recurse "%ISOFOLDER%" --DEST "%DRIVEUfix%/games/%%14T [%%I]" --progress

Support\wit x --neek --recurse "%ISOFOLDER%" --DEST "%DRIVEUfix%/games/%%I" --progress

::an empty cygdrive folder may be created previous directory, so delete it!
if exist cygdrive rd /s /q cygdrive



::delete diconfig.bin if found (needs to be reconstructed on next boot to see new games)
if exist "%DriveU%\sneek\diconfig.bin" del "%DriveU%\sneek\diconfig.bin" >nul


::-----create csv list of all games in "%DRIVEU%"\games\ -----

echo @echo Off>"%DriveU%"\Game-List-Updater[ModMii].bat
echo if exist TitleID.txt del TitleID.txtredirectnul>>"%DriveU%"\Game-List-Updater[ModMii].bat
echo if exist GameTitleIDs.txt del GameTitleIDs.txtredirectnul>>"%DriveU%"\Game-List-Updater[ModMii].bat
echo if exist Gamelist.txt del Gamelist.txtredirectnul>>"%DriveU%"\Game-List-Updater[ModMii].bat
echo if exist Gamelist2.txt del Gamelist2.txtredirectnul>>"%DriveU%"\Game-List-Updater[ModMii].bat
echo if exist Gamelist-sorted.txt del Gamelist-sorted.txtredirectnul>>"%DriveU%"\Game-List-Updater[ModMii].bat


echo dir games /A:D /b redirect GameTitleIDs.txt >>"%DriveU%"\Game-List-Updater[ModMii].bat



echo for /F "tokens=*" @@@@A in (GameTitleIDs.txt) do call :processmii @@@@A>>"%DriveU%"\Game-List-Updater[ModMii].bat
echo goto:nextstep>>"%DriveU%"\Game-List-Updater[ModMii].bat

echo :processmii>>"%DriveU%"\Game-List-Updater[ModMii].bat
echo set CurrentTitleID=@@*>>"%DriveU%"\Game-List-Updater[ModMii].bat

echo if /i "@@CurrentTitleID:~-8,1@@" EQU "[" rename "games\@@CurrentTitleID@@" "@@CurrentTitleID:~-7,6@@"redirectnul>>"%DriveU%"\Game-List-Updater[ModMii].bat

echo if /i "@@CurrentTitleID:~-8,1@@" EQU "[" set CurrentTitleID=@@CurrentTitleID:~-7,6@@>>"%DriveU%"\Game-List-Updater[ModMii].bat

echo FINDSTR /B /C:"@@CurrentTitleID:~0,6@@" titles.txtredirectTitleID.txt>>"%DriveU%"\Game-List-Updater[ModMii].bat

::if title ID not in titles.txt just add title ID only
echo for /F @@@@A in ("TitleID.txt") do If @@@@~zA equ 0 (echo @@CurrentTitleID:~0,6@@redirectredirectGamelist.txt) else (FINDSTR /B /C:"@@CurrentTitleID:~0,6@@" titles.txtredirectredirectGamelist.txt)>>"%DriveU%"\Game-List-Updater[ModMii].bat

echo goto:EOF>>"%DriveU%"\Game-List-Updater[ModMii].bat
echo :nextstep>>"%DriveU%"\Game-List-Updater[ModMii].bat


echo if exist TitleID.txt del TitleID.txtredirectnul>>"%DriveU%"\Game-List-Updater[ModMii].bat
echo if exist GameTitleIDs.txt del GameTitleIDs.txtredirectnul>>"%DriveU%"\Game-List-Updater[ModMii].bat



echo for /F "tokens=*" @@@@A in (Gamelist.txt) do call :processmii2 @@@@A>>"%DriveU%"\Game-List-Updater[ModMii].bat
echo goto:nextstep>>"%DriveU%"\Game-List-Updater[ModMii].bat

echo :processmii2>>"%DriveU%"\Game-List-Updater[ModMii].bat
echo set Line=@@*>>"%DriveU%"\Game-List-Updater[ModMii].bat
echo echo @@Line:~9@@,@@Line:~0,6@@redirectredirectgamelist2.txt>>"%DriveU%"\Game-List-Updater[ModMii].bat

echo goto:EOF>>"%DriveU%"\Game-List-Updater[ModMii].bat
echo :nextstep>>"%DriveU%"\Game-List-Updater[ModMii].bat


echo if exist Gamelist.txt del Gamelist.txtredirectnul>>"%DriveU%"\Game-List-Updater[ModMii].bat
echo sort "Gamelist2.txt" redirect "Gamelist-sorted.txt">>"%DriveU%"\Game-List-Updater[ModMii].bat
echo if exist Gamelist2.txt del Gamelist2.txtredirectnul>>"%DriveU%"\Game-List-Updater[ModMii].bat


echo echo Number,Title,Title IDredirectGame-List[ModMii].csv>>"%DriveU%"\Game-List-Updater[ModMii].bat
echo echo ,,redirectredirectGame-List[ModMii].csv>>"%DriveU%"\Game-List-Updater[ModMii].bat
echo set countline=0 >>"%DriveU%"\Game-List-Updater[ModMii].bat

echo for /F "tokens=*" @@@@A in (Gamelist-sorted.txt) do call :processmii3 @@@@A>>"%DriveU%"\Game-List-Updater[ModMii].bat
echo goto:nextstep>>"%DriveU%"\Game-List-Updater[ModMii].bat

echo :processmii3>>"%DriveU%"\Game-List-Updater[ModMii].bat
echo set Line=@@*>>"%DriveU%"\Game-List-Updater[ModMii].bat
echo SET /a countline=@@countline@@+1>>"%DriveU%"\Game-List-Updater[ModMii].bat



echo echo @@countline@@,@@line@@redirectredirectGame-List[ModMii].csv>>"%DriveU%"\Game-List-Updater[ModMii].bat

echo goto:EOF>>"%DriveU%"\Game-List-Updater[ModMii].bat
echo :nextstep>>"%DriveU%"\Game-List-Updater[ModMii].bat

echo if exist Gamelist-sorted.txt del Gamelist-sorted.txtredirectnul>>"%DriveU%"\Game-List-Updater[ModMii].bat


support\sfk filter "%DriveU%"\Game-List-Updater[ModMii].bat -spat -rep _@@_%%_ -rep _"redirect"_">"_ -write -yes>nul
support\sfk filter -quiet support\titles.txt -spat -rep _,_;_ -rep _"  "_" "_ >%DriveU%\titles.txt

start /wait /D "%DriveU%" Game-List-Updater[ModMii].bat


echo.
support\sfk echo -spat \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20[Green]GAME BULK EXTRACTION FOR SNEEK COMPLETE
echo.
echo A list of your games can be found here: %DriveU%\Game-List[ModMii].csv
echo To update this list at any time, run %DriveU%\Game-List-Updater[ModMii].bat
echo.
echo Press any key to return to the Main Menu.
pause>nul
goto:MENU


::........................................LIST / BATCH.......................................
:LIST
Set List=
cls
echo                                        ModMii                                v%currentversion%
support\sfk echo -spat \x20 \x20 \x20 \x20 \x20[Red]DOWNLOAD PAGE 1 [def]\x20 \x20 \x20 \x20 \x20 \x20 \x20by XFlak
echo.
echo      Choose files to add/remove to download queue (Selected files marked with an *)
echo.
echo       D = Download Selected Files    1/2/3/4 = Page 1/2/3/4        M = Main Menu
echo       C = Clear Download Queue       (blank) = Cycle Pages        DR = Drive Menu
echo.
support\sfk echo -spat \x20Select Group: [Red](A)[def]ll, [Red](U)[def]SA, [Red](E)[def]URO, [Red](J)[def]AP, [Red](K)[def]OR, Active [Red](I)[def]OSs, Extra [Red](PR)[def]otection

echo.
support\sfk echo -spat \x20 \x20 [Red] System Menus \x20 \x20 \x20 \x20 \x20 Non-Fakesigned IOSs\MIOS \x20 \x20 \x20 \x20 Other WADs
echo.
echo    %SM3.2U% 3.2U = 3.2U SM             %IOS9% 9 = IOS9v1034         %RSU% RSU = Region Select v2(U)
echo    %SM4.1U% 4.1U = 4.1U SM	      %IOS12% 12 = IOS12v526         %RSE% RSE = Region Select v2(E)
echo    %SM4.2U% 4.2U = 4.2U SM	      %IOS13% 13 = IOS13v1032        %RSJ% RSJ = Region Select v2(J)
echo    %SM4.3U% 4.3U = 4.3U SM            %IOS14% 14 = IOS14v1032        %RSK% RSK = Region Select v2(K)
echo    %SM3.2E% 3.2E = 3.2E SM            %IOS15% 15 = IOS15v1032         %EULAU% EU = EULA v3(U)
echo    %SM4.1E% 4.1E = 4.1E SM            %IOS17% 17 = IOS17v1032         %EULAE% EE = EULA v3(E)
echo    %SM4.2E% 4.2E = 4.2E SM            %IOS21% 21 = IOS21v1039         %EULAJ% EJ = EULA v3(J)
echo    %SM4.3E% 4.3E = 4.3E SM            %IOS22% 22 = IOS22v1294         %EULAK% EK = EULA v3(K)
echo    %SM3.2J% 3.2J = 3.2J SM            %IOS28% 28 = IOS28v1807         %BC% BC = BC v6
echo    %SM4.1J% 4.1J = 4.1J SM          %IOS30% 30NP = IOS30v2576        %cBC% NMM = cBC-NMM
echo    %SM4.2J% 4.2J = 4.2J SM            %IOS31% 31 = IOS31v3608
echo    %SM4.3J% 4.3J = 4.3J SM            %IOS33% 33 = IOS33v3608

support\sfk echo -spat \x20 \x20%SM4.1K% 4.1K = 4.1K SM \x20 \x20 \x20 \x20 \x20 \x20 %IOS34% 34 = IOS34v3608\x20 \x20 \x20 \x20 \x20 \x20[Red]Fakesigned IOSs

echo    %SM4.2K% 4.2K = 4.2K SM	      %IOS35% 35 = IOS35v3608         %IOS11P60% 11 = IOS11(IOS60P)
echo    %SM4.3K% 4.3K = 4.3K SM           %IOS36% 36a = IOS36v3351         %IOS20P60% 20 = IOS20(IOS60P)
echo                               %IOS36v3608% 36 = IOS36v3608         %IOS30P60% 30 = IOS30(IOS60P)
support\sfk echo -spat \x20 \x20 \x20 \x20 [Red] Channels[def]\x20 \x20 \x20 \x20 \x20 \x20 \x20 %IOS37% 37 = IOS37v5663 \x20 \x20 \x20 \x20%IOS30P% 30P = IOS30-Patched
echo    %P0% P0 = Photo (U/E/J/K)      %IOS38% 38 = IOS38v4124         %IOS40P60% 40 = IOS40(IOS60P)
echo     %P% P = Photo 1.1(U/E/J)     %IOS41% 41 = IOS41v3607         %IOS50P% 50 = IOS50(IOS60P)
echo    %PK% PK = Photo 1.1 (KOR)      %IOS43% 43 = IOS43v3607         %IOS52P% 52 = IOS52(IOS60P)
echo    %S% SH = Shopping (U/E/J)     %IOS45% 45 = IOS45v3607         %IOS60P% 60 = IOS60-Patched
echo    %SK% SK = Shopping (KOR)       %IOS46% 46 = IOS46v3607        %IOS70K% 70K = IOS70(IOS60P)
echo    %IU% IU = Internet (USA)       %IOS48v4124% 48 = IOS48v4124         %IOS70P% 70 = IOS70-Patched
echo    %IE% IE = Internet (EUR)       %IOS53% 53 = IOS53v5663        %IOS80K% 80K = IOS80(IOS60P)
echo    %IJ% IJ = Internet (JAP)       %IOS55% 55 = IOS55v5663         %IOS80P% 80 = IOS80-Patched
echo    %WU% WU = Weather (USA)	      %IOS56% 56 = IOS56v5662        %IOS236% 236 = IOS236(IOS36P)
echo    %WE% WE = Weather (EUR)        %IOS57% 57 = IOS57v5919

support\sfk echo -spat \x20 \x20%WJ% WJ = Weather (JAP) \x20 \x20 \x20 \x20 %IOS58% 58 = IOS58v6176\x20 \x20 \x20 \x20 \x20 \x20[Red] (S)NEEK Files

echo    %NU% NU = News (USA)	    %IOS60% 60NP = IOS60v6174         
echo    %NE% NE = News (EUR)	      %IOS61% 61 = IOS61v5662         %A0e% 0e = 0e.app IOS80v6943
echo    %NJ% NJ = News (JAP)           %IOS62% 62 = IOS62v6430      %A0e_70% 0e_70 = 0e.app IOS70v6687
echo   %WSU% WSU = WiiSpeak(USA)      %IOS70% 70NP = IOS70v6687      %A0e_60% 0e_60 = 0e.app IOS60v6174
echo   %WSE% WSE = WiiSpeak(EUR)      %IOS80% 80NP = IOS80v6944         %A01% 01 = 01.app IOS80v6943
echo   %WSJ% WSJ = WiiSpeak(JAP)       %M10% M10 = MIOSv10         %A01_70% 01_70 = 01.app IOS70v6687
echo   %MII% Mii = Mii (RF)                                   %A01_60% 01_60 = 01.app IOS60v6174
echo                                                        %A0c% 0c = 0c.app MIOSv10
echo.
echo.
echo.
echo.
set /p LIST=     Enter Selection Here: 


if /i "%LIST%" EQU "M" goto:MENU
if /i "%LIST%" EQU "D" set loadorgo=go
if /i "%LIST%" EQU "D" set BACKB4QUEUE=LIST
if /i "%LIST%" EQU "D" goto:DOWNLOADQUEUE
if /i "%LIST%" EQU "DR" set BACKB4DRIVE=LIST
if /i "%LIST%" EQU "DR" goto:DRIVECHANGE
if /i "%LIST%" EQU "C" goto:CLEAR

if /i "%LIST%" EQU "1" goto:LIST
if /i "%LIST%" EQU "2" goto:OLDLIST
if /i "%LIST%" EQU "3" goto:LIST3
if /i "%LIST%" EQU "4" goto:LIST4
if /i "%LIST%" EQU "ADV" goto:Advanced
IF "%LIST%"=="" goto:OLDLIST

if /i "%LIST%" EQU "A" goto:SelectAll
if /i "%LIST%" EQU "U" goto:UALL
if /i "%LIST%" EQU "E" goto:EALL
if /i "%LIST%" EQU "J" goto:JALL
if /i "%LIST%" EQU "K" goto:KALL
if /i "%LIST%" EQU "I" goto:IOSACTIVE
if /i "%LIST%" EQU "PR" goto:PROTECTIONFILES
if /i "%LIST%" EQU "S" goto:allsneekfiles

if /i "%LIST%" EQU "4.3U" goto:Switch4.3U
if /i "%LIST%" EQU "4.3E" goto:Switch4.3E
if /i "%LIST%" EQU "4.3J" goto:Switch4.3J
if /i "%LIST%" EQU "4.3K" goto:Switch4.3K
if /i "%LIST%" EQU "3.2U" goto:Switch3.2U
if /i "%LIST%" EQU "4.1U" goto:Switch4.1U
if /i "%LIST%" EQU "4.2U" goto:Switch4.2U
if /i "%LIST%" EQU "3.2E" goto:Switch3.2E
if /i "%LIST%" EQU "4.1E" goto:Switch4.1E
if /i "%LIST%" EQU "4.2E" goto:Switch4.2E
if /i "%LIST%" EQU "3.2J" goto:Switch3.2J
if /i "%LIST%" EQU "4.1J" goto:Switch4.1J
if /i "%LIST%" EQU "4.2J" goto:Switch4.2J
if /i "%LIST%" EQU "4.1K" goto:Switch4.1K
if /i "%LIST%" EQU "4.2K" goto:Switch4.2K
if /i "%LIST%" EQU "MII" goto:SwitchMII
if /i "%LIST%" EQU "P" goto:SwitchP
if /i "%LIST%" EQU "PK" goto:SwitchPK
if /i "%LIST%" EQU "P0" goto:SwitchP0
if /i "%LIST%" EQU "SH" goto:SwitchS
if /i "%LIST%" EQU "SK" goto:SwitchSK
if /i "%LIST%" EQU "IU" goto:SwitchIU
if /i "%LIST%" EQU "IE" goto:SwitchIE
if /i "%LIST%" EQU "IJ" goto:SwitchIJ
if /i "%LIST%" EQU "WU" goto:SwitchWU
if /i "%LIST%" EQU "WE" goto:SwitchWE
if /i "%LIST%" EQU "WJ" goto:SwitchWJ
if /i "%LIST%" EQU "NU" goto:SwitchNU
if /i "%LIST%" EQU "NE" goto:SwitchNE
if /i "%LIST%" EQU "NJ" goto:SwitchNJ
if /i "%LIST%" EQU "WSU" goto:SwitchWSU
if /i "%LIST%" EQU "WSE" goto:SwitchWSE
if /i "%LIST%" EQU "WSJ" goto:SwitchWSJ
if /i "%LIST%" EQU "M10" goto:SwitchM10


if /i "%LIST%" EQU "9" goto:Switch9
if /i "%LIST%" EQU "12" goto:Switch12
if /i "%LIST%" EQU "13" goto:Switch13
if /i "%LIST%" EQU "14" goto:Switch14
if /i "%LIST%" EQU "15" goto:Switch15

if /i "%LIST%" EQU "17" goto:Switch17
if /i "%LIST%" EQU "20" goto:Switch20P60
if /i "%LIST%" EQU "11" goto:Switch11P60
if /i "%LIST%" EQU "21" goto:Switch21
if /i "%LIST%" EQU "22" goto:Switch22
if /i "%LIST%" EQU "28" goto:Switch28
if /i "%LIST%" EQU "30" goto:Switch30P60
if /i "%LIST%" EQU "30P" goto:Switch30P
if /i "%LIST%" EQU "31" goto:Switch31
if /i "%LIST%" EQU "33" goto:Switch33
if /i "%LIST%" EQU "34" goto:Switch34
if /i "%LIST%" EQU "35" goto:Switch35
if /i "%LIST%" EQU "36a" goto:Switch36
if /i "%LIST%" EQU "37" goto:Switch37
if /i "%LIST%" EQU "38" goto:Switch38
if /i "%LIST%" EQU "36" goto:Switch36v3608

if /i "%LIST%" EQU "40" goto:Switch40P60
if /i "%LIST%" EQU "41" goto:Switch41
if /i "%LIST%" EQU "43" goto:Switch43
if /i "%LIST%" EQU "45" goto:Switch45
if /i "%LIST%" EQU "46" goto:Switch46
if /i "%LIST%" EQU "50" goto:Switch50P
if /i "%LIST%" EQU "52" goto:Switch52P
if /i "%LIST%" EQU "53" goto:Switch53
if /i "%LIST%" EQU "55" goto:Switch55
if /i "%LIST%" EQU "56" goto:Switch56
if /i "%LIST%" EQU "57" goto:Switch57
if /i "%LIST%" EQU "58" goto:Switch58
if /i "%LIST%" EQU "60" goto:Switch60P
if /i "%LIST%" EQU "61" goto:Switch61
if /i "%LIST%" EQU "62" goto:Switch62
if /i "%LIST%" EQU "70" goto:Switch70P
if /i "%LIST%" EQU "70K" goto:Switch70K
if /i "%LIST%" EQU "80K" goto:Switch80K
if /i "%LIST%" EQU "80" goto:Switch80P
if /i "%LIST%" EQU "236" goto:SwitchIOS236
if /i "%LIST%" EQU "30NP" goto:SwitchIOS30
if /i "%LIST%" EQU "48" goto:SwitchIOS48v4124
if /i "%LIST%" EQU "60NP" goto:SwitchIOS60
if /i "%LIST%" EQU "70NP" goto:SwitchIOS70
if /i "%LIST%" EQU "80NP" goto:SwitchIOS80

if /i "%LIST%" EQU "RSU" goto:SwitchRSU
if /i "%LIST%" EQU "RSE" goto:SwitchRSE
if /i "%LIST%" EQU "RSJ" goto:SwitchRSJ
if /i "%LIST%" EQU "RSK" goto:SwitchRSK
if /i "%LIST%" EQU "EU" goto:SwitchEULAU
if /i "%LIST%" EQU "EE" goto:SwitchEULAE
if /i "%LIST%" EQU "EJ" goto:SwitchEULAJ
if /i "%LIST%" EQU "EK" goto:SwitchEULAK
if /i "%LIST%" EQU "BC" goto:SwitchBC
if /i "%LIST%" EQU "NMM" goto:SwitchcBC

if /i "%LIST%" EQU "0e" goto:SwitchA0e
if /i "%LIST%" EQU "01" goto:switchA01
if /i "%LIST%" EQU "0e_70" goto:SwitchA0e_70
if /i "%LIST%" EQU "01_70" goto:switchA01_70
if /i "%LIST%" EQU "0e_60" goto:SwitchA0e_60
if /i "%LIST%" EQU "01_60" goto:switchA01_60
if /i "%LIST%" EQU "0c" goto:SwitchA0c

echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:list

:Switch3.2U
if /i "%SM3.2U%" EQU "*" (set SM3.2U=) else (set SM3.2U=*)
goto:LIST

:Switch4.1U
if /i "%SM4.1U%" EQU "*" (set SM4.1U=) else (set SM4.1U=*)
goto:LIST

:Switch4.2U
if /i "%SM4.2U%" EQU "*" (set SM4.2U=) else (set SM4.2U=*)
goto:LIST

:Switch4.3U
if /i "%SM4.3U%" EQU "*" (set SM4.3U=) else (set SM4.3U=*)
goto:LIST

:Switch3.2E
if /i "%SM3.2E%" EQU "*" (set SM3.2E=) else (set SM3.2E=*)
goto:LIST

:Switch4.1E
if /i "%SM4.1E%" EQU "*" (set SM4.1E=) else (set SM4.1E=*)
goto:LIST

:Switch4.2E
if /i "%SM4.2E%" EQU "*" (set SM4.2E=) else (set SM4.2E=*)
goto:LIST

:Switch4.3E
if /i "%SM4.3E%" EQU "*" (set SM4.3E=) else (set SM4.3E=*)
goto:LIST

:Switch3.2J
if /i "%SM3.2J%" EQU "*" (set SM3.2J=) else (set SM3.2J=*)
goto:LIST

:Switch4.1J
if /i "%SM4.1J%" EQU "*" (set SM4.1J=) else (set SM4.1J=*)
goto:LIST

:Switch4.2J
if /i "%SM4.2J%" EQU "*" (set SM4.2J=) else (set SM4.2J=*)
goto:LIST

:Switch4.3J
if /i "%SM4.3J%" EQU "*" (set SM4.3J=) else (set SM4.3J=*)
goto:LIST

:Switch4.1K
if /i "%SM4.1K%" EQU "*" (set SM4.1K=) else (set SM4.1K=*)
goto:LIST

:Switch4.2K
if /i "%SM4.2K%" EQU "*" (set SM4.2K=) else (set SM4.2K=*)
goto:LIST

:Switch4.3K
if /i "%SM4.3K%" EQU "*" (set SM4.3K=) else (set SM4.3K=*)
goto:LIST

:SwitchMii
if /i "%Mii%" EQU "*" (set Mii=) else (set Mii=*)
goto:LIST

:SwitchP
if /i "%P%" EQU "*" (set P=) else (set P=*)
goto:LIST

:SwitchPK
if /i "%PK%" EQU "*" (set PK=) else (set PK=*)
goto:LIST

:SwitchP0
if /i "%P0%" EQU "*" (set P0=) else (set P0=*)
goto:LIST

:SwitchS
if /i "%S%" EQU "*" (set S=) else (set S=*)
goto:LIST

:SwitchSK
if /i "%SK%" EQU "*" (set SK=) else (set SK=*)
goto:LIST

:SwitchIU
if /i "%IU%" EQU "*" (set IU=) else (set IU=*)
goto:LIST

:SwitchIE
if /i "%IE%" EQU "*" (set IE=) else (set IE=*)
goto:LIST

:SwitchIJ
if /i "%IJ%" EQU "*" (set IJ=) else (set IJ=*)
goto:LIST

:SwitchWU
if /i "%WU%" EQU "*" (set WU=) else (set WU=*)
goto:LIST

:SwitchWE
if /i "%WE%" EQU "*" (set WE=) else (set WE=*)
goto:LIST

:SwitchWJ
if /i "%WJ%" EQU "*" (set WJ=) else (set WJ=*)
goto:LIST

:SwitchNU
if /i "%NU%" EQU "*" (set NU=) else (set NU=*)
goto:LIST

:SwitchNE
if /i "%NE%" EQU "*" (set NE=) else (set NE=*)
goto:LIST

:SwitchNJ
if /i "%NJ%" EQU "*" (set NJ=) else (set NJ=*)
goto:LIST

:SwitchWSU
if /i "%WSU%" EQU "*" (set WSU=) else (set WSU=*)
goto:LIST

:SwitchWSE
if /i "%WSE%" EQU "*" (set WSE=) else (set WSE=*)
goto:LIST

:SwitchWSJ
if /i "%WSJ%" EQU "*" (set WSJ=) else (set WSJ=*)
goto:LIST

:SwitchM10
if /i "%M10%" EQU "*" (set M10=) else (set M10=*)
goto:LIST

:Switch9
if /i "%IOS9%" EQU "*" (set IOS9=) else (set IOS9=*)
goto:LIST

:Switch12
if /i "%IOS12%" EQU "*" (set IOS12=) else (set IOS12=*)
goto:LIST

:Switch13
if /i "%IOS13%" EQU "*" (set IOS13=) else (set IOS13=*)
goto:LIST

:Switch14
if /i "%IOS14%" EQU "*" (set IOS14=) else (set IOS14=*)
goto:LIST

:Switch15
if /i "%IOS15%" EQU "*" (set IOS15=) else (set IOS15=*)
goto:LIST

:Switch17
if /i "%IOS17%" EQU "*" (set IOS17=) else (set IOS17=*)
goto:LIST

:Switch21
if /i "%IOS21%" EQU "*" (set IOS21=) else (set IOS21=*)
goto:LIST

:Switch22
if /i "%IOS22%" EQU "*" (set IOS22=) else (set IOS22=*)
goto:LIST

:Switch28
if /i "%IOS28%" EQU "*" (set IOS28=) else (set IOS28=*)
goto:LIST

:Switch40P60
if /i "%IOS40P60%" EQU "*" (set IOS40P60=) else (set IOS40P60=*)
goto:LIST

:Switch30P60
if /i "%IOS30P60%" EQU "*" (set IOS30P60=) else (set IOS30P60=*)
goto:LIST

:Switch30P
if /i "%IOS30P%" EQU "*" (set IOS30P=) else (set IOS30P=*)
goto:LIST

:Switch31
if /i "%IOS31%" EQU "*" (set IOS31=) else (set IOS31=*)
goto:LIST

:Switch33
if /i "%IOS33%" EQU "*" (set IOS33=) else (set IOS33=*)
goto:LIST

:Switch34
if /i "%IOS34%" EQU "*" (set IOS34=) else (set IOS34=*)
goto:LIST

:Switch35
if /i "%IOS35%" EQU "*" (set IOS35=) else (set IOS35=*)
goto:LIST

:Switch36
if /i "%IOS36%" EQU "*" (set IOS36=) else (set IOS36=*)
goto:LIST

:Switch37
if /i "%IOS37%" EQU "*" (set IOS37=) else (set IOS37=*)
goto:LIST

:Switch38
if /i "%IOS38%" EQU "*" (set IOS38=) else (set IOS38=*)
goto:LIST

:Switch41
if /i "%IOS41%" EQU "*" (set IOS41=) else (set IOS41=*)
goto:LIST

:Switch43
if /i "%IOS43%" EQU "*" (set IOS43=) else (set IOS43=*)
goto:LIST

:Switch45
if /i "%IOS45%" EQU "*" (set IOS45=) else (set IOS45=*)
goto:LIST

:Switch46
if /i "%IOS46%" EQU "*" (set IOS46=) else (set IOS46=*)
goto:LIST

:Switch50P
if /i "%IOS50P%" EQU "*" (set IOS50P=) else (set IOS50P=*)
goto:LIST

:Switch52P
if /i "%IOS52P%" EQU "*" (set IOS52P=) else (set IOS52P=*)
goto:LIST

:Switch11P60
if /i "%IOS11P60%" EQU "*" (set IOS11P60=) else (set IOS11P60=*)
goto:LIST

:Switch20P60
if /i "%IOS20P60%" EQU "*" (set IOS20P60=) else (set IOS20P60=*)
goto:LIST

:Switch53
if /i "%IOS53%" EQU "*" (set IOS53=) else (set IOS53=*)
goto:LIST

:Switch55
if /i "%IOS55%" EQU "*" (set IOS55=) else (set IOS55=*)
goto:LIST

:Switch56
if /i "%IOS56%" EQU "*" (set IOS56=) else (set IOS56=*)
goto:LIST

:Switch57
if /i "%IOS57%" EQU "*" (set IOS57=) else (set IOS57=*)
goto:LIST

:Switch58
if /i "%IOS58%" EQU "*" (set IOS58=) else (set IOS58=*)
goto:LIST

:Switch60P
if /i "%IOS60P%" EQU "*" (set IOS60P=) else (set IOS60P=*)
goto:LIST

:Switch61
if /i "%IOS61%" EQU "*" (set IOS61=) else (set IOS61=*)
goto:LIST

:Switch62
if /i "%IOS62%" EQU "*" (set IOS62=) else (set IOS62=*)
goto:LIST

:Switch70P
if /i "%IOS70P%" EQU "*" (set IOS70P=) else (set IOS70P=*)
goto:LIST

:Switch80P
if /i "%IOS80P%" EQU "*" (set IOS80P=) else (set IOS80P=*)
goto:LIST

:SwitchIOS236
if /i "%IOS236%" EQU "*" (set IOS236=) else (set IOS236=*)
goto:LIST

:Switch70K
if /i "%IOS70K%" EQU "*" (set IOS70K=) else (set IOS70K=*)
goto:LIST

:Switch80K
if /i "%IOS80K%" EQU "*" (set IOS80K=) else (set IOS80K=*)
goto:LIST

:SwitchIOS30
if /i "%IOS30%" EQU "*" (set IOS30=) else (set IOS30=*)
goto:LIST

:SwitchIOS9
if /i "%IOS9%" EQU "*" (set IOS9=) else (set IOS9=*)
goto:LIST

:SwitchIOS48v4124
if /i "%IOS48v4124%" EQU "*" (set IOS48v4124=) else (set IOS48v4124=*)
goto:LIST

:SwitchIOS60
if /i "%IOS60%" EQU "*" (set IOS60=) else (set IOS60=*)
goto:LIST

:SwitchIOS70
if /i "%IOS70%" EQU "*" (set IOS70=) else (set IOS70=*)
goto:LIST

:SwitchIOS80
if /i "%IOS80%" EQU "*" (set IOS80=) else (set IOS80=*)
goto:LIST

:Switch36v3608
if /i "%IOS36v3608%" EQU "*" (set IOS36v3608=) else (set IOS36v3608=*)
goto:LIST

:SwitchEULAU
if /i "%EULAU%" EQU "*" (set EULAU=) else (set EULAU=*)
goto:LIST

:SwitchEULAE
if /i "%EULAE%" EQU "*" (set EULAE=) else (set EULAE=*)
goto:LIST

:SwitchEULAJ
if /i "%EULAJ%" EQU "*" (set EULAJ=) else (set EULAJ=*)
goto:LIST

:SwitchEULAK
if /i "%EULAK%" EQU "*" (set EULAK=) else (set EULAK=*)
goto:LIST

:SwitchRSU
if /i "%RSU%" EQU "*" (set RSU=) else (set RSU=*)
goto:LIST

:SwitchRSE
if /i "%RSE%" EQU "*" (set RSE=) else (set RSE=*)
goto:LIST

:SwitchRSJ
if /i "%RSJ%" EQU "*" (set RSJ=) else (set RSJ=*)
goto:LIST

:SwitchRSK
if /i "%RSK%" EQU "*" (set RSK=) else (set RSK=*)
goto:LIST

:SwitchBC
if /i "%BC%" EQU "*" (set BC=) else (set BC=*)
goto:LIST

:SwitchcBC
if /i "%cBC%" EQU "*" (set cBC=) else (set cBC=*)
goto:LIST


:SwitchA0e
if /i "%A0e%" EQU "*" (set A0e=) else (set A0e=*)
goto:LIST

:SwitchA0e_70
if /i "%A0e_70%" EQU "*" (set A0e_70=) else (set A0e_70=*)
goto:LIST

:SwitchA0e_60
if /i "%A0e_60%" EQU "*" (set A0e_60=) else (set A0e_60=*)
goto:LIST

:SwitchA0c
if /i "%A0c%" EQU "*" (set A0c=) else (set A0c=*)
goto:LIST

:SwitchA01
if /i "%A01%" EQU "*" (set A01=) else (set A01=*)
goto:LIST

:SwitchA01_70
if /i "%A01_70%" EQU "*" (set A01_70=) else (set A01_70=*)
goto:LIST

:SwitchA01_60
if /i "%A01_60%" EQU "*" (set A01_60=) else (set A01_60=*)
goto:LIST

:SELECTALL

:PROTECTIONFILES
set IOS11P60=*
set IOS20P60=*
set IOS30P60=*
set IOS40P60=*
set IOS50P=*
set IOS52P=*
set IOS60P=*
set IOS70K=*
set IOS80K=*

if /i "%LIST%" EQU "PR" goto:list

:UALL
set MII=*
set P=*
set P0=*
set S=*
set IU=*
set WU=*
set NU=*
set WSU=*
if /i "%LIST%" EQU "U" goto:list

:EALL
set MII=*
set P=*
set P0=*
set S=*
set IE=*
set WE=*
set NE=*
set WSE=*
if /i "%LIST%" EQU "E" goto:list

:JALL
set MII=*
set P=*
set P0=*
set S=*
set IJ=*
set WJ=*
set NJ=*
set WSJ=*
if /i "%LIST%" EQU "J" goto:list

:KALL
set MII=*
set P0=*
set PK=*
set SK=*
::set IOS70K=*
set IOS80K=*

if /i "%LIST%" EQU "K" goto:list






:BASEWADS
set IOS37=*
set IOS38=*
set IOS57=*
if /i "%LIST%" EQU "B" goto:list

:IOSACTIVE
set M10=*
set IOS9=*
set IOS12=*
set IOS13=*
set IOS14=*
set IOS15=*
set IOS17=*
set IOS21=*
set IOS22=*
set IOS28=*
set IOS31=*
set IOS33=*
set IOS34=*
set IOS35=*
set IOS36v3608=*
set IOS37=*
set IOS38=*
set IOS53=*
set IOS55=*
set IOS56=*
set IOS57=*
set IOS58=*
set IOS61=*
set IOS62=*
set IOS80P=*
set IOS41=*
set IOS43=*
set IOS45=*
set IOS46=*
set IOS48v4124=*

if /i "%LIST%" EQU "I" goto:list

:allsneekfiles
set A0e=*
set A0c=*
set A01=*
set A0e_70=*
set A01_70=*
set A0e_60=*
set A01_60=*
if /i "%LIST%" EQU "S" goto:LIST

::not in any list

set SM3.2U=*
set SM4.1U=*
set SM4.2U=*
set SM4.3U=*
set SM3.2E=*
set SM4.1E=*
set SM4.2E=*
set SM4.3E=*
set SM3.2J=*
set SM4.1J=*
set SM4.2J=*
set SM4.3J=*
set SM4.1K=*
set SM4.2K=*
set SM4.3K=*
set IOS236=*
set IOS36=*
set IOS30P=*

set IOS70P=*
set ios30=*

set ios60=*
set ios70=*
set ios80=*
set IOS36=*



set EULAU=*
set EULAE=*
set EULAJ=*
set EULAK=*
set RSU=*
set RSE=*
set RSJ=*
set RSK=*
set BC=*
set cBC=*

goto:list



::........................................Additional OLDLIST / BATCH.......................................
:OLDLIST
Set OLDLIST=
cls
echo                                        ModMii                                v%currentversion%
support\sfk echo -spat \x20 \x20 \x20 \x20 \x20[Red]DOWNLOAD PAGE 2 [def]\x20 \x20 \x20 \x20 \x20 \x20 \x20by XFlak

echo.
echo      Choose files to add/remove to download queue (Selected files marked with an *)
echo.
echo       D = Download Selected Files    1/2/3/4 = Page 1/2/3/4        M = Main Menu
echo       C = Clear Download Queue       (blank) = Cycle Pages        DR = Drive Menu
echo.
support\sfk echo -spat \x20 \x20 \x20 \x20 \x20 Select Group: [Red](A)[def]ll, [Red](U)[def]SB-Loader, [Red](J)[def]ust for Fun, [Red](PC)[def] Programs,
support\sfk echo -spat \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 [Red](W)[def]ii Apps, [Red](E)[def]xploits
echo.
support\sfk echo -spat \x20 \x20 \x20 \x20 \x20 \x20 [Red] USB-Loader Files  \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 Just For Fun!
echo.
echo      %usbfolder% CFG = CFG-Loader Mod                 %WiiMC% WMC = WiiMC (Media Player)
echo     %FLOW% FLOW = WiiFlow                        %fceugx% NES = FCEUGX (NES Emulator)
echo     %USBX% USBX = USB-Loader Fwdr Channel       %snes9xgx% SNES = SNES9xGX (SNES Emulator)
echo      %neogamma% NEO = Neogamma Backup Disc Loader    %vbagx% VBA = VBAGX (GB/GBA Emulator)
echo       %CheatCodes% CC = %cheatregion% Region Cheat Codes        %WII64% W64 = Wii64 beta1.1 (N64 Emulator)
echo       %AccioHacks% AH = AccioHacks                     %WIISX% WSX = WiiSX beta2.1 (PS1 Emulator)
echo                                            %HBB% HBB = Homebrew Browser
echo                                            %SGM% SGM = SaveGame Manager GX
echo                                             %WIIX% WX = WiiXplorer
echo                                             %locked% LA = Locked HBC Folder (Pass: UDLRAB)

support\sfk echo -spat \x20 \x20 \x20 \x20 \x20 \x20 \x20 [Red]PC Programs [def]\x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20%FLOWF% FLOWF = WiiFlow Forwarder Channel/dol
echo                                            %S2U% S2U = Switch2Uneek
echo      %F32% F32 = FAT32 GUI Formatter             %nswitch% NS = nSwitch
echo      %wbm% WBM = WiiBackupManager
echo     %WiiGSC% WGSC = Wii Game Shortcut Creator
echo      %SMW% SMW = ShowMiiWads
echo       %CM% CM = Customize Mii
echo.

support\sfk echo -spat \x20 \x20 \x20 \x20 \x20 \x20 \x20 [Red] Wii Apps \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 Exploits
echo.
echo       %HM% HM = HackMii Installer             %BB1% BB1 = Bannerbomb v1
echo      %bootmiisd% BSD = BootMii SD Files              %BB2% BB2 = Bannerbomb v2
echo     %yawm% YAWM = Yet Another Wad Manager Mod   %Pwns% PWNS = Indiana Pwns (USA\EUR\JAP)
echo      %MMM% MMM = Multi-Mod Manager               %Smash% SS = Smash Stack (USA\EUR\JAP\KOR)
echo      %dop% DOP = Dop-Mii                         %YUGI% YU = YU-GI-OWNED (USA\EUR\JAP)
echo      %IOS236Installer% 236 = IOS236 Installer                %Bathaxx% BH = Bathaxx (USA\EUR\JAP)
echo      %SIP% SIP = Simple IOS Patcher              %ROTJ% RJ = Return of the Jodi (USA\EUR\JAP)
echo      %Pri% Pri = Priiloader v0.7 (236 Mod)      %Twi% Twi = Twilight Hack (USA\EUR\JAP)
echo      %HAX% HAX = Priiloader Hacks                %TOS% EH = Eri HaKawai (USA\EUR\JAP)
echo      %PLC% PLC = Post Loader Channel             %Wilbrand% WB = Wilbrand (4.3 USA\EUR\JAP\KOR)

if /i "%Wilbrand%" EQU "*" echo       %PL% PL = Postloader                             MAC:%macaddress%  Region:%REGION%
if /i "%Wilbrand%" NEQ "*" echo       %PL% PL = Postloader

echo       %syscheck% SC = sysCheck
echo       %WiiMod% WM = WiiMod
echo      %ARC% ARC = Any Region Changer (1.1b Mod06 Offline)
echo       %casper% CA = Casper
echo.
support\sfk echo -spat \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 [Red] LEGEND:[def] \x22=\x22 Auto-Updating Downloads
echo.
echo.
set /p OLDLIST=     Enter Selection Here: 

if /i "%OLDLIST%" EQU "M" goto:MENU
if /i "%OLDLIST%" EQU "D" set BACKB4QUEUE=OLDLIST
if /i "%OLDLIST%" EQU "D" set loadorgo=go
if /i "%OLDLIST%" EQU "D" goto:DOWNLOADQUEUE
if /i "%OLDLIST%" EQU "DR" set BACKB4DRIVE=OLDLIST
if /i "%OLDLIST%" EQU "DR" goto:DRIVECHANGE
if /i "%OLDLIST%" EQU "C" goto:CLEAR





if /i "%OLDLIST%" EQU "A" goto:SelectAllOLD
if /i "%OLDLIST%" EQU "J" goto:SelectJust4FunOLD
if /i "%OLDLIST%" EQU "U" goto:USBLOADERSELECT
if /i "%OLDLIST%" EQU "E" goto:ExploitsSELECT
if /i "%OLDLIST%" EQU "PC" goto:PCPROGRAMSSELECT
if /i "%OLDLIST%" EQU "W" goto:WIIAPPSELECT

if /i "%OLDLIST%" EQU "1" goto:LIST
if /i "%OLDLIST%" EQU "2" goto:OLDLIST
if /i "%OLDLIST%" EQU "3" goto:LIST3
if /i "%OLDLIST%" EQU "4" goto:LIST4
if /i "%OLDLIST%" EQU "ADV" goto:ADVANCED
IF "%OLDLIST%"=="" goto:LIST3

if /i "%OLDLIST%" EQU "AH" goto:SwitchAccioHacks
if /i "%OLDLIST%" EQU "BSD" goto:Switchbootmiisd


if /i "%OLDLIST%" EQU "BB1" goto:SwitchBB1
if /i "%OLDLIST%" EQU "BB2" goto:SwitchBB2
if /i "%OLDLIST%" EQU "HM" goto:SwitchHM
if /i "%OLDLIST%" EQU "LA" goto:Switchlocked
if /i "%OLDLIST%" EQU "dop" goto:Switchdop
if /i "%OLDLIST%" EQU "SC" goto:Switchsyscheck
if /i "%OLDLIST%" EQU "HBB" goto:SwitchHBB
if /i "%OLDLIST%" EQU "W64" goto:SwitchWII64
if /i "%OLDLIST%" EQU "CA" goto:SwitchCasper
if /i "%OLDLIST%" EQU "WB" goto:SwitchWilbrand
if /i "%OLDLIST%" EQU "WSX" goto:SwitchWIISX
if /i "%OLDLIST%" EQU "pwns" goto:Switchpwns
if /i "%OLDLIST%" EQU "Twi" goto:SwitchTwi
if /i "%OLDLIST%" EQU "Yu" goto:SwitchYUGI
if /i "%OLDLIST%" EQU "BH" goto:SwitchBathaxx
if /i "%OLDLIST%" EQU "RJ" goto:SwitchROTJ
if /i "%OLDLIST%" EQU "EH" goto:SwitchTOS
if /i "%OLDLIST%" EQU "ss" goto:Switchsmash
if /i "%OLDLIST%" EQU "mmm" goto:Switchmmm
if /i "%OLDLIST%" EQU "WM" goto:SwitchWiiMOd
if /i "%OLDLIST%" EQU "ARC" goto:SwitchARC
if /i "%OLDLIST%" EQU "236" goto:SwitchIOS236Installer
if /i "%OLDLIST%" EQU "SIP" goto:SwitchSIP
if /i "%OLDLIST%" EQU "yawm" goto:Switchyawm
if /i "%OLDLIST%" EQU "neo" goto:Switchneogamma
if /i "%OLDLIST%" EQU "cfg" goto:Switchusbfolder
if /i "%OLDLIST%" EQU "WMC" goto:SwitchWiiMC
if /i "%OLDLIST%" EQU "NES" goto:Switchfceugx
if /i "%OLDLIST%" EQU "SNES" goto:Switchsnes9xgx
if /i "%OLDLIST%" EQU "VBA" goto:Switchvbagx
if /i "%OLDLIST%" EQU "SGM" goto:SwitchSGM
if /i "%OLDLIST%" EQU "PL" goto:SwitchPL
if /i "%OLDLIST%" EQU "WX" goto:SwitchWIIX
if /i "%OLDLIST%" EQU "wbm" goto:Switchwbm
if /i "%OLDLIST%" EQU "cc" goto:SwitchCheatCodes

if /i "%OLDLIST%" EQU "WGSC" goto:SwitchWGSC
if /i "%OLDLIST%" EQU "SMW" goto:SwitchSMW
if /i "%OLDLIST%" EQU "CM" goto:SwitchCM
if /i "%OLDLIST%" EQU "f32" goto:Switchf32
if /i "%OLDLIST%" EQU "FLOW" goto:SwitchFLOW
if /i "%OLDLIST%" EQU "USBX" goto:SwitchUSBX
if /i "%OLDLIST%" EQU "FLOWF" goto:SwitchFLOWF
if /i "%OLDLIST%" EQU "S2U" goto:SwitchS2U
if /i "%OLDLIST%" EQU "NS" goto:SwitchnSwitch
if /i "%OLDLIST%" EQU "PLC" goto:SwitchPLC
if /i "%OLDLIST%" EQU "Pri" goto:SwitchPri
if /i "%OLDLIST%" EQU "HAX" goto:SwitchHAX

echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:OLDLIST

:SwitchAccioHacks
if /i "%AccioHacks%" EQU "*" (set AccioHacks=) else (set AccioHacks=*)
goto:OLDLIST

:Switchbootmiisd
if /i "%bootmiisd%" EQU "*" (set bootmiisd=) else (set bootmiisd=*)
goto:OLDLIST

:SwitchBB1
if /i "%BB1%" EQU "*" (set BB1=) else (set BB1=*)
goto:OLDLIST

:SwitchBB2
if /i "%BB2%" EQU "*" (set BB2=) else (set BB2=*)
goto:OLDLIST

:SwitchHM
if /i "%HM%" EQU "*" (set HM=) else (set HM=*)
goto:OLDLIST

:Switchpwns
if /i "%pwns%" EQU "*" (set pwns=) else (set pwns=*)
goto:OLDLIST

:SwitchTwi
if /i "%Twi%" EQU "*" (set Twi=) else (set Twi=*)
goto:OLDLIST

:SwitchYUGI
if /i "%YUGI%" EQU "*" (set YUGI=) else (set YUGI=*)
goto:OLDLIST

:SwitchBathaxx
if /i "%Bathaxx%" EQU "*" (set Bathaxx=) else (set Bathaxx=*)
goto:OLDLIST

:SwitchROTJ
if /i "%ROTJ%" EQU "*" (set ROTJ=) else (set ROTJ=*)
goto:OLDLIST

:SwitchTOS
if /i "%TOS%" EQU "*" (set TOS=) else (set TOS=*)
goto:OLDLIST

:Switchsmash
if /i "%smash%" EQU "*" (set smash=) else (set smash=*)
goto:OLDLIST

:Switchdop
if /i "%dop%" EQU "*" (set dop=) else (set dop=*)
goto:OLDLIST

:Switchsyscheck
if /i "%syscheck%" EQU "*" (set syscheck=) else (set syscheck=*)
goto:OLDLIST

:Switchlocked
if /i "%locked%" EQU "*" (set locked=) else (set locked=*)
goto:OLDLIST

:SwitchHBB
if /i "%HBB%" EQU "*" (set HBB=) else (set HBB=*)
goto:OLDLIST

:SwitchWII64
if /i "%WII64%" EQU "*" (set WII64=) else (set WII64=*)
goto:OLDLIST

:SwitchCasper
if /i "%Casper%" EQU "*" (set Casper=) else (set Casper=*)
goto:OLDLIST

:SwitchWilbrand
if /i "%Wilbrand%" EQU "*" (set Wilbrand=) else (set Wilbrand=*)
if /i "%Wilbrand%" EQU "*" goto:macaddress
goto:OLDLIST

:SwitchWIISX
if /i "%WIISX%" EQU "*" (set WIISX=) else (set WIISX=*)
goto:OLDLIST

:Switchmmm
if /i "%mmm%" EQU "*" (set mmm=) else (set mmm=*)
goto:OLDLIST

:SwitchWiiMod
if /i "%WiiMod%" EQU "*" (set WiiMod=) else (set WiiMod=*)
goto:OLDLIST

:SwitchARC
if /i "%ARC%" EQU "*" (set ARC=) else (set ARC=*)
goto:OLDLIST

:SwitchIOS236Installer
if /i "%IOS236Installer%" EQU "*" (set IOS236Installer=) else (set IOS236Installer=*)
goto:OLDLIST

:SwitchSIP
if /i "%SIP%" EQU "*" (set SIP=) else (set SIP=*)
goto:OLDLIST

:Switchyawm
if /i "%yawm%" EQU "*" (set yawm=) else (set yawm=*)
goto:OLDLIST

:Switchneogamma
if /i "%neogamma%" EQU "*" (set neogamma=) else (set neogamma=*)
goto:OLDLIST

:Switchwbm
if /i "%wbm%" EQU "*" (set wbm=) else (set wbm=*)
goto:OLDLIST

:SwitchCheatCodes
if /i "%CheatCodes%" EQU "*" (set CheatCodes=) else (set CheatCodes=*)
goto:OLDLIST

:SwitchF32
if /i "%F32%" EQU "*" (set F32=) else (set F32=*)
goto:OLDLIST

:SwitchWGSC
if /i "%WiiGSC%" EQU "*" (set WiiGSC=) else (set WiiGSC=*)
goto:OLDLIST

:SwitchCM
if /i "%CM%" EQU "*" (set CM=) else (set CM=*)
goto:OLDLIST

:SwitchSMW
if /i "%SMW%" EQU "*" (set SMW=) else (set SMW=*)
goto:OLDLIST

:SwitchFLOW
if /i "%FLOW%" EQU "*" (set FLOW=) else (set FLOW=*)
goto:OLDLIST

:SwitchUSBX
if /i "%USBX%" EQU "*" (set USBX=) else (set USBX=*)
goto:OLDLIST

:SwitchFLOWF
if /i "%FLOWF%" EQU "*" (set FLOWF=) else (set FLOWF=*)
goto:OLDLIST

:SwitchS2U
if /i "%S2U%" EQU "*" (set S2U=) else (set S2U=*)
goto:OLDLIST

:Switchnswitch
if /i "%nswitch%" EQU "*" (set nswitch=) else (set nswitch=*)
goto:OLDLIST

:SwitchPLC
if /i "%PLC%" EQU "*" (set PLC=) else (set PLC=*)
goto:OLDLIST

:Switchusbfolder
if /i "%usbfolder%" EQU "*" (set usbfolder=) else (set usbfolder=*)
goto:OLDLIST

:SwitchWiiMC
if /i "%WiiMC%" EQU "*" (set WiiMC=) else (set WiiMC=*)
goto:OLDLIST

:Switchfceugx
if /i "%fceugx%" EQU "*" (set fceugx=) else (set fceugx=*)
goto:OLDLIST

:Switchsnes9xgx
if /i "%snes9xgx%" EQU "*" (set snes9xgx=) else (set snes9xgx=*)
goto:OLDLIST

:Switchvbagx
if /i "%vbagx%" EQU "*" (set vbagx=) else (set vbagx=*)
goto:OLDLIST

:SwitchSGM
if /i "%SGM%" EQU "*" (set SGM=) else (set SGM=*)
goto:OLDLIST

:SwitchPL
if /i "%PL%" EQU "*" (set PL=) else (set PL=*)
goto:OLDLIST

:SwitchWIIX
if /i "%WIIX%" EQU "*" (set WIIX=) else (set WIIX=*)
goto:OLDLIST

:SwitchPri
if /i "%Pri%" EQU "*" (set Pri=) else (set Pri=*)
goto:OLDLIST

:SwitchHAX
if /i "%HAX%" EQU "*" (set HAX=) else (set HAX=*)
goto:OLDLIST


:SELECTALLOLD

:USBLOADERSELECT
set usbfolder=*
set neogamma=*
set CheatCodes=*
set AccioHacks=*
set FLOW=*
set USBX=*
if /i "%OLDLIST%" EQU "U" goto:OLDLIST

:PCPROGRAMSSELECT
set wbm=*
set f32=*
set SMW=*
set CM=*
set WiiGSC=*
if /i "%OLDLIST%" EQU "PC" goto:OLDLIST

:WiiAppSelect
set mmm=*
set WiiMod=*
set ARC=*
set HM=*
set dop=*
set syscheck=*
set yawm=*
set Pri=*
set HAX=*
set IOS236Installer=*
set SIP=*
set PLC=*
set bootmiisd=*
set PL=*
set Casper=*
if /i "%OLDLIST%" EQU "W" goto:OLDLIST

:SelectJust4FunOLD
set WiiMC=*
set fceugx=*
set snes9xgx=*
set vbagx=*
set SGM=*
set WIIX=*
set HBB=*
set WII64=*
set WIISX=*
set locked=*
set FLOWF=*
set S2U=*
set nswitch=*
if /i "%OLDLIST%" EQU "J" goto:OLDLIST


:ExploitsSELECT
set BB1=*
set BB2=*
set Twi=*
set YUGI=*
set Bathaxx=*
set ROTJ=*
set TOS=*
set smash=*
set pwns=*
if /i "%Wilbrand%" NEQ "*" (set Wilbrand=*) & (goto:macaddress)
if /i "%OLDLIST%" EQU "E" goto:OLDLIST

goto:OLDLIST




::........................................Additional LIST3 / BATCH.......................................
:LIST3
Set LIST3=
cls
echo                                        ModMii                                v%currentversion%
support\sfk echo -spat \x20 \x20 \x20 \x20 \x20[Red]DOWNLOAD PAGE 3 [def]\x20 \x20 \x20 \x20 \x20 \x20 \x20by XFlak

echo.
echo      Choose files to add/remove to download queue (Selected files marked with an *)
echo.
echo       D = Download Selected Files    1/2/3/4 = Page 1/2/3/4        M = Main Menu
echo       C = Clear Download Queue       (blank) = Cycle Pages        DR = Drive Menu
echo.
echo.
support\sfk echo -spat \x20 \x20[Red]DON'T INSTALL THEMES WITHOUT PROTECTION: BOOTMII, PRIILOADER AND NAND BACKUP
support\sfk echo -spat \x20 \x20[Red]ONLY INSTALL THEMES FOR YOUR SPECIFIC SYSTEM MENU VERSION AND REGION!
echo.
echo.
support\sfk echo -spat \x20 \x20 \x20 \x20 \x20Select Group: [Red](A)[def]ll, Themes for [Red](U)[def]SA, [Red](E)[def]uro, [Red](J)[def]ap, [Red](K)[def]orean
support\sfk echo -spat \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20System Menu's w/ Themes for [Red](US)[def]A, [Red](EU)[def]ro, [Red](JA)[def]p, [Red](KO)[def]rean
echo.
echo.
if "%selectedtheme%"=="" set selectedtheme=R

if /i "%selectedtheme%" EQU "R" echo       S = Switch Download List to View Another Theme: DarkWii Red
if /i "%selectedtheme%" EQU "G" echo       S = Switch Download List to View Another Theme: DarkWii Green
if /i "%selectedtheme%" EQU "B" echo       S = Switch Download List to View Another Theme: DarkWii Blue
if /i "%selectedtheme%" EQU "O" echo       S = Switch Download List to View Another Theme: DarkWii Orange

echo           Supported themes include: DarkWii Red\Green\Blue\Orange
echo.
echo      CE = Channel Effect for custom system menu themes: %effect%
echo           * Choose from 3 effects: No-Spin, Spin and Fast-Spin
echo.
echo    %MyM% MyM = MyMenuifyMod
echo.
echo     WWW = View All Available Themes on Youtube
echo.

if /i "%selectedtheme%" NEQ "R" goto:skipred
support\sfk echo -spat \x20 [Red]DarkWii Red CSMs \x20 \x20 \x20 \x20 \x20 DarkWii Red System Menus \x20 \x20 Original Wii Themes
echo.
echo    %DarkWii_Red_4.3U% 3U = 4.3U                    %SM4.3U-DWR% 4.3U = 4.3U            %A97% 97 = 97.app SM4.3U
echo    %DarkWii_Red_4.2U% 2U = 4.2U                    %SM4.2U-DWR% 4.2U = 4.2U            %A87% 87 = 87.app SM4.2U
echo    %DarkWii_Red_4.1U% 1U = 4.1U                    %SM4.1U-DWR% 4.1U = 4.1U            %A7b% 7b = 7b.app SM4.1U
echo                                                          %A72% 72 = 72.app SM4.0U
echo                                                          %A42% 42 = 42.app SM3.2U
echo.
echo    %DarkWii_Red_4.3E% 3E = 4.3E                    %SM4.3E-DWR% 4.3E = 4.3E            %A9a% 9a = 9a.app SM4.3E
echo    %DarkWii_Red_4.2E% 2E = 4.2E                    %SM4.2E-DWR% 4.2E = 4.2E            %A8a% 8a = 8a.app SM4.2E
echo    %DarkWii_Red_4.1E% 1E = 4.1E                    %SM4.1E-DWR% 4.1E = 4.1E            %A7e% 7e = 7e.app SM4.1E
echo                                                          %A75% 75 = 75.app SM4.0E
echo                                                          %A45% 45 = 45.app SM3.2E
echo.
echo    %DarkWii_Red_4.3J% 3J = 4.3J                    %SM4.3J-DWR% 4.3J = 4.3J            %A94% 94 = 94.app SM4.3J
echo    %DarkWii_Red_4.2J% 2J = 4.2J                    %SM4.2J-DWR% 4.2J = 4.2J            %A84% 84 = 84.app SM4.2J
echo    %DarkWii_Red_4.1J% 1J = 4.1J                    %SM4.1J-DWR% 4.1J = 4.1J            %A78% 78 = 78.app SM4.1J
echo                                                          %A70% 70 = 70.app SM4.0J
echo                                                          %A40% 40 = 40.app SM3.2J
echo.
echo    %DarkWii_Red_4.3K% 3K = 4.3K                    %SM4.3K-DWR% 4.3K = 4.3K            %A9d% 9d = 9d.app SM4.3K
echo    %DarkWii_Red_4.2K% 2K = 4.2K                    %SM4.2K-DWR% 4.2K = 4.2K            %A8d% 8d = 8d.app SM4.2K
echo    %DarkWii_Red_4.1K% 1K = 4.1K                    %SM4.1K-DWR% 4.1K = 4.1K            %A81% 81 = 81.app SM4.1K
:skipred


if /i "%selectedtheme%" NEQ "G" goto:skipgreen
support\sfk echo -spat \x20 [Red]DarkWii Green CSMs \x20 \x20 \x20 DarkWii Green System Menus \x20 \x20 Original Wii Themes
echo.
echo    %DarkWii_Green_4.3U% 3U = 4.3U                    %SM4.3U-DWG% 4.3U = 4.3U            %A97% 97 = 97.app SM4.3U
echo    %DarkWii_Green_4.2U% 2U = 4.2U                    %SM4.2U-DWG% 4.2U = 4.2U            %A87% 87 = 87.app SM4.2U
echo    %DarkWii_Green_4.1U% 1U = 4.1U                    %SM4.1U-DWG% 4.1U = 4.1U            %A7b% 7b = 7b.app SM4.1U
echo                                                          %A72% 72 = 72.app SM4.0U
echo                                                          %A42% 42 = 42.app SM3.2U
echo.
echo    %DarkWii_Green_4.3E% 3E = 4.3E                    %SM4.3E-DWG% 4.3E = 4.3E            %A9a% 9a = 9a.app SM4.3E
echo    %DarkWii_Green_4.2E% 2E = 4.2E                    %SM4.2E-DWG% 4.2E = 4.2E            %A8a% 8a = 8a.app SM4.2E
echo    %DarkWii_Green_4.1E% 1E = 4.1E                    %SM4.1E-DWG% 4.1E = 4.1E            %A7e% 7e = 7e.app SM4.1E
echo                                                          %A75% 75 = 75.app SM4.0E
echo                                                          %A45% 45 = 45.app SM3.2E
echo.
echo    %DarkWii_Green_4.3J% 3J = 4.3J                    %SM4.3J-DWG% 4.3J = 4.3J            %A94% 94 = 94.app SM4.3J
echo    %DarkWii_Green_4.2J% 2J = 4.2J                    %SM4.2J-DWG% 4.2J = 4.2J            %A84% 84 = 84.app SM4.2J
echo    %DarkWii_Green_4.1J% 1J = 4.1J                    %SM4.1J-DWG% 4.1J = 4.1J            %A78% 78 = 78.app SM4.1J
echo                                                          %A70% 70 = 70.app SM4.0J
echo                                                          %A40% 40 = 40.app SM3.2J
echo.
echo    %DarkWii_Green_4.3K% 3K = 4.3K                    %SM4.3K-DWG% 4.3K = 4.3K            %A9d% 9d = 9d.app SM4.3K
echo    %DarkWii_Green_4.2K% 2K = 4.2K                    %SM4.2K-DWG% 4.2K = 4.2K            %A8d% 8d = 8d.app SM4.2K
echo    %DarkWii_Green_4.1K% 1K = 4.1K                    %SM4.1K-DWG% 4.1K = 4.1K            %A81% 81 = 81.app SM4.1K
:skipgreen


if /i "%selectedtheme%" NEQ "B" goto:skipBlue
support\sfk echo -spat \x20 [Red]DarkWii Blue CSMs \x20 \x20 \x20 DarkWii Blue System Menus \x20 \x20 Original Wii Themes
echo.
echo    %DarkWii_Blue_4.3U% 3U = 4.3U                    %SM4.3U-DWB% 4.3U = 4.3U            %A97% 97 = 97.app SM4.3U
echo    %DarkWii_Blue_4.2U% 2U = 4.2U                    %SM4.2U-DWB% 4.2U = 4.2U            %A87% 87 = 87.app SM4.2U
echo    %DarkWii_Blue_4.1U% 1U = 4.1U                    %SM4.1U-DWB% 4.1U = 4.1U            %A7b% 7b = 7b.app SM4.1U
echo                                                          %A72% 72 = 72.app SM4.0U
echo                                                          %A42% 42 = 42.app SM3.2U
echo.
echo    %DarkWii_Blue_4.3E% 3E = 4.3E                    %SM4.3E-DWB% 4.3E = 4.3E            %A9a% 9a = 9a.app SM4.3E
echo    %DarkWii_Blue_4.2E% 2E = 4.2E                    %SM4.2E-DWB% 4.2E = 4.2E            %A8a% 8a = 8a.app SM4.2E
echo    %DarkWii_Blue_4.1E% 1E = 4.1E                    %SM4.1E-DWB% 4.1E = 4.1E            %A7e% 7e = 7e.app SM4.1E
echo                                                          %A75% 75 = 75.app SM4.0E
echo                                                          %A45% 45 = 45.app SM3.2E
echo.
echo    %DarkWii_Blue_4.3J% 3J = 4.3J                    %SM4.3J-DWB% 4.3J = 4.3J            %A94% 94 = 94.app SM4.3J
echo    %DarkWii_Blue_4.2J% 2J = 4.2J                    %SM4.2J-DWB% 4.2J = 4.2J            %A84% 84 = 84.app SM4.2J
echo    %DarkWii_Blue_4.1J% 1J = 4.1J                    %SM4.1J-DWB% 4.1J = 4.1J            %A78% 78 = 78.app SM4.1J
echo                                                          %A70% 70 = 70.app SM4.0J
echo                                                          %A40% 40 = 40.app SM3.2J
echo.
echo    %DarkWii_Blue_4.3K% 3K = 4.3K                    %SM4.3K-DWB% 4.3K = 4.3K            %A9d% 9d = 9d.app SM4.3K
echo    %DarkWii_Blue_4.2K% 2K = 4.2K                    %SM4.2K-DWB% 4.2K = 4.2K            %A8d% 8d = 8d.app SM4.2K
echo    %DarkWii_Blue_4.1K% 1K = 4.1K                    %SM4.1K-DWB% 4.1K = 4.1K            %A81% 81 = 81.app SM4.1K
:skipBlue


if /i "%selectedtheme%" NEQ "O" goto:skipOrange
support\sfk echo -spat \x20 [Red]DarkWii Orange CSMs \x20 \x20 \x20 DarkWii Orange System Menus \x20 \x20 Original Wii Themes
echo.
echo    %darkwii_orange_4.3U% 3U = 4.3U                    %SM4.3U-DWO% 4.3U = 4.3U            %A97% 97 = 97.app SM4.3U
echo    %darkwii_orange_4.2U% 2U = 4.2U                    %SM4.2U-DWO% 4.2U = 4.2U            %A87% 87 = 87.app SM4.2U
echo    %darkwii_orange_4.1U% 1U = 4.1U                    %SM4.1U-DWO% 4.1U = 4.1U            %A7b% 7b = 7b.app SM4.1U
echo                                                          %A72% 72 = 72.app SM4.0U
echo                                                          %A42% 42 = 42.app SM3.2U
echo.
echo    %darkwii_orange_4.3E% 3E = 4.3E                    %SM4.3E-DWO% 4.3E = 4.3E            %A9a% 9a = 9a.app SM4.3E
echo    %darkwii_orange_4.2E% 2E = 4.2E                    %SM4.2E-DWO% 4.2E = 4.2E            %A8a% 8a = 8a.app SM4.2E
echo    %darkwii_orange_4.1E% 1E = 4.1E                    %SM4.1E-DWO% 4.1E = 4.1E            %A7e% 7e = 7e.app SM4.1E
echo                                                          %A75% 75 = 75.app SM4.0E
echo                                                          %A45% 45 = 45.app SM3.2E
echo.
echo    %darkwii_orange_4.3J% 3J = 4.3J                    %SM4.3J-DWO% 4.3J = 4.3J            %A94% 94 = 94.app SM4.3J
echo    %darkwii_orange_4.2J% 2J = 4.2J                    %SM4.2J-DWO% 4.2J = 4.2J            %A84% 84 = 84.app SM4.2J
echo    %darkwii_orange_4.1J% 1J = 4.1J                    %SM4.1J-DWO% 4.1J = 4.1J            %A78% 78 = 78.app SM4.1J
echo                                                          %A70% 70 = 70.app SM4.0J
echo                                                          %A40% 40 = 40.app SM3.2J
echo.
echo    %darkwii_orange_4.3K% 3K = 4.3K                    %SM4.3K-DWO% 4.3K = 4.3K            %A9d% 9d = 9d.app SM4.3K
echo    %darkwii_orange_4.2K% 2K = 4.2K                    %SM4.2K-DWO% 4.2K = 4.2K            %A8d% 8d = 8d.app SM4.2K
echo    %darkwii_orange_4.1K% 1K = 4.1K                    %SM4.1K-DWO% 4.1K = 4.1K            %A81% 81 = 81.app SM4.1K
:skipOrange


echo.
echo.

set /p LIST3=     Enter Selection Here: 

if /i "%LIST3%" EQU "M" goto:MENU
if /i "%LIST3%" EQU "D" set BACKB4QUEUE=LIST3
if /i "%LIST3%" EQU "D" set loadorgo=go
if /i "%LIST3%" EQU "D" goto:DOWNLOADQUEUE
if /i "%LIST3%" EQU "DR" set BACKB4DRIVE=LIST3
if /i "%LIST3%" EQU "DR" goto:DRIVECHANGE
if /i "%LIST3%" EQU "C" goto:CLEAR


if /i "%LIST3%" EQU "1" goto:LIST
if /i "%LIST3%" EQU "2" goto:OLDLIST
if /i "%LIST3%" EQU "3" goto:LIST3
if /i "%LIST3%" EQU "4" goto:LIST4
if /i "%LIST3%" EQU "ADV" goto:ADVANCED
IF "%LIST3%"=="" goto:LIST4

::common

if /i "%LIST3%" NEQ "WWW" goto:novid
start /D SUPPORT WiiThemes.html
goto:LIST3
:novid



if /i "%LIST3%" EQU "CE" goto:OptionCEp3
if /i "%LIST3%" EQU "A" goto:SelectAll4
if /i "%LIST3%" EQU "U" goto:UTHEMES
if /i "%LIST3%" EQU "E" goto:ETHEMES
if /i "%LIST3%" EQU "J" goto:JTHEMES
if /i "%LIST3%" EQU "k" goto:KTHEMES
if /i "%LIST3%" EQU "US" goto:SMUTHEMES
if /i "%LIST3%" EQU "EU" goto:SMETHEMES
if /i "%LIST3%" EQU "JA" goto:SMJTHEMES
if /i "%LIST3%" EQU "KO" goto:SMKTHEMES
if /i "%LIST3%" EQU "MyM" goto:SwitchMyM
if /i "%LIST3%" EQU "70" goto:switchA70
if /i "%LIST3%" EQU "42" goto:switchA42
if /i "%LIST3%" EQU "45" goto:switchA45
if /i "%LIST3%" EQU "40" goto:switchA40
if /i "%LIST3%" EQU "72" goto:switchA72
if /i "%LIST3%" EQU "75" goto:switchA75
if /i "%LIST3%" EQU "78" goto:switchA78
if /i "%LIST3%" EQU "7b" goto:switchA7b
if /i "%LIST3%" EQU "7e" goto:switchA7e
if /i "%LIST3%" EQU "84" goto:switchA84
if /i "%LIST3%" EQU "87" goto:switchA87
if /i "%LIST3%" EQU "8a" goto:switchA8a
if /i "%LIST3%" EQU "94" goto:switchA94
if /i "%LIST3%" EQU "97" goto:switchA97
if /i "%LIST3%" EQU "9a" goto:switchA9a
if /i "%LIST3%" EQU "81" goto:switchA81
if /i "%LIST3%" EQU "8d" goto:switchA8d
if /i "%LIST3%" EQU "9d" goto:switchA9d

::Red
if /i "%selectedtheme%" NEQ "R" goto:skipred
if /i "%LIST3%" EQU "S" (set selectedtheme=G)&&(goto:LIST3)
if /i "%LIST3%" EQU "3U" goto:SwitchDarkWii_Red_4.3U
if /i "%LIST3%" EQU "2U" goto:SwitchDarkWii_Red_4.2U
if /i "%LIST3%" EQU "1U" goto:SwitchDarkWii_Red_4.1U
if /i "%LIST3%" EQU "3E" goto:SwitchDarkWii_Red_4.3E
if /i "%LIST3%" EQU "2E" goto:SwitchDarkWii_Red_4.2E
if /i "%LIST3%" EQU "1E" goto:SwitchDarkWii_Red_4.1E
if /i "%LIST3%" EQU "3J" goto:SwitchDarkWii_Red_4.3J
if /i "%LIST3%" EQU "2J" goto:SwitchDarkWii_Red_4.2J
if /i "%LIST3%" EQU "1J" goto:SwitchDarkWii_Red_4.1J
if /i "%LIST3%" EQU "3K" goto:SwitchDarkWii_Red_4.3K
if /i "%LIST3%" EQU "2K" goto:SwitchDarkWii_Red_4.2K
if /i "%LIST3%" EQU "1K" goto:SwitchDarkWii_Red_4.1K
if /i "%LIST3%" EQU "4.3U" goto:SwitchSM4.3U-DWR
if /i "%LIST3%" EQU "4.2U" goto:SwitchSM4.2U-DWR
if /i "%LIST3%" EQU "4.1U" goto:SwitchSM4.1U-DWR
if /i "%LIST3%" EQU "4.3E" goto:SwitchSM4.3E-DWR
if /i "%LIST3%" EQU "4.2E" goto:SwitchSM4.2E-DWR
if /i "%LIST3%" EQU "4.1E" goto:SwitchSM4.1E-DWR
if /i "%LIST3%" EQU "4.3J" goto:SwitchSM4.3J-DWR
if /i "%LIST3%" EQU "4.2J" goto:SwitchSM4.2J-DWR
if /i "%LIST3%" EQU "4.1J" goto:SwitchSM4.1J-DWR
if /i "%LIST3%" EQU "4.3K" goto:SwitchSM4.3K-DWR
if /i "%LIST3%" EQU "4.2K" goto:SwitchSM4.2K-DWR
if /i "%LIST3%" EQU "4.1K" goto:SwitchSM4.1K-DWR
:skipred


::Green
if /i "%selectedtheme%" NEQ "G" goto:skipgreen
if /i "%LIST3%" EQU "S" (set selectedtheme=B)&&(goto:LIST3)
if /i "%LIST3%" EQU "WWW" (start www.youtube.com/watch?v=Rn0CnTo5kRI)&&(goto:LIST3)
if /i "%LIST3%" EQU "3U" goto:SwitchDarkWii_Green_4.3U
if /i "%LIST3%" EQU "2U" goto:SwitchDarkWii_Green_4.2U
if /i "%LIST3%" EQU "1U" goto:SwitchDarkWii_Green_4.1U
if /i "%LIST3%" EQU "3E" goto:SwitchDarkWii_Green_4.3E
if /i "%LIST3%" EQU "2E" goto:SwitchDarkWii_Green_4.2E
if /i "%LIST3%" EQU "1E" goto:SwitchDarkWii_Green_4.1E
if /i "%LIST3%" EQU "3J" goto:SwitchDarkWii_Green_4.3J
if /i "%LIST3%" EQU "2J" goto:SwitchDarkWii_Green_4.2J
if /i "%LIST3%" EQU "1J" goto:SwitchDarkWii_Green_4.1J
if /i "%LIST3%" EQU "3K" goto:SwitchDarkWii_Green_4.3K
if /i "%LIST3%" EQU "2K" goto:SwitchDarkWii_Green_4.2K
if /i "%LIST3%" EQU "1K" goto:SwitchDarkWii_Green_4.1K
if /i "%LIST3%" EQU "4.3U" goto:SwitchSM4.3U-DWG
if /i "%LIST3%" EQU "4.2U" goto:SwitchSM4.2U-DWG
if /i "%LIST3%" EQU "4.1U" goto:SwitchSM4.1U-DWG
if /i "%LIST3%" EQU "4.3E" goto:SwitchSM4.3E-DWG
if /i "%LIST3%" EQU "4.2E" goto:SwitchSM4.2E-DWG
if /i "%LIST3%" EQU "4.1E" goto:SwitchSM4.1E-DWG
if /i "%LIST3%" EQU "4.3J" goto:SwitchSM4.3J-DWG
if /i "%LIST3%" EQU "4.2J" goto:SwitchSM4.2J-DWG
if /i "%LIST3%" EQU "4.1J" goto:SwitchSM4.1J-DWG
if /i "%LIST3%" EQU "4.3K" goto:SwitchSM4.3K-DWG
if /i "%LIST3%" EQU "4.2K" goto:SwitchSM4.2K-DWG
if /i "%LIST3%" EQU "4.1K" goto:SwitchSM4.1K-DWG
:skipgreen


::Blue
if /i "%selectedtheme%" NEQ "B" goto:skipBlue
if /i "%LIST3%" EQU "S" (set selectedtheme=O)&&(goto:LIST3)
if /i "%LIST3%" EQU "3U" goto:SwitchDarkWii_Blue_4.3U
if /i "%LIST3%" EQU "2U" goto:SwitchDarkWii_Blue_4.2U
if /i "%LIST3%" EQU "1U" goto:SwitchDarkWii_Blue_4.1U
if /i "%LIST3%" EQU "3E" goto:SwitchDarkWii_Blue_4.3E
if /i "%LIST3%" EQU "2E" goto:SwitchDarkWii_Blue_4.2E
if /i "%LIST3%" EQU "1E" goto:SwitchDarkWii_Blue_4.1E
if /i "%LIST3%" EQU "3J" goto:SwitchDarkWii_Blue_4.3J
if /i "%LIST3%" EQU "2J" goto:SwitchDarkWii_Blue_4.2J
if /i "%LIST3%" EQU "1J" goto:SwitchDarkWii_Blue_4.1J
if /i "%LIST3%" EQU "3K" goto:SwitchDarkWii_Blue_4.3K
if /i "%LIST3%" EQU "2K" goto:SwitchDarkWii_Blue_4.2K
if /i "%LIST3%" EQU "1K" goto:SwitchDarkWii_Blue_4.1K
if /i "%LIST3%" EQU "4.3U" goto:SwitchSM4.3U-DWB
if /i "%LIST3%" EQU "4.2U" goto:SwitchSM4.2U-DWB
if /i "%LIST3%" EQU "4.1U" goto:SwitchSM4.1U-DWB
if /i "%LIST3%" EQU "4.3E" goto:SwitchSM4.3E-DWB
if /i "%LIST3%" EQU "4.2E" goto:SwitchSM4.2E-DWB
if /i "%LIST3%" EQU "4.1E" goto:SwitchSM4.1E-DWB
if /i "%LIST3%" EQU "4.3J" goto:SwitchSM4.3J-DWB
if /i "%LIST3%" EQU "4.2J" goto:SwitchSM4.2J-DWB
if /i "%LIST3%" EQU "4.1J" goto:SwitchSM4.1J-DWB
if /i "%LIST3%" EQU "4.3K" goto:SwitchSM4.3K-DWB
if /i "%LIST3%" EQU "4.2K" goto:SwitchSM4.2K-DWB
if /i "%LIST3%" EQU "4.1K" goto:SwitchSM4.1K-DWB
:skipBlue


::Orange
if /i "%selectedtheme%" NEQ "O" goto:skipOrange
if /i "%LIST3%" EQU "S" (set selectedtheme=R)&&(goto:LIST3)
if /i "%LIST3%" EQU "3U" goto:Switchdarkwii_orange_4.3U
if /i "%LIST3%" EQU "2U" goto:Switchdarkwii_orange_4.2U
if /i "%LIST3%" EQU "1U" goto:Switchdarkwii_orange_4.1U
if /i "%LIST3%" EQU "3E" goto:Switchdarkwii_orange_4.3E
if /i "%LIST3%" EQU "2E" goto:Switchdarkwii_orange_4.2E
if /i "%LIST3%" EQU "1E" goto:Switchdarkwii_orange_4.1E
if /i "%LIST3%" EQU "3J" goto:Switchdarkwii_orange_4.3J
if /i "%LIST3%" EQU "2J" goto:Switchdarkwii_orange_4.2J
if /i "%LIST3%" EQU "1J" goto:Switchdarkwii_orange_4.1J
if /i "%LIST3%" EQU "3K" goto:Switchdarkwii_orange_4.3K
if /i "%LIST3%" EQU "2K" goto:Switchdarkwii_orange_4.2K
if /i "%LIST3%" EQU "1K" goto:Switchdarkwii_orange_4.1K
if /i "%LIST3%" EQU "4.3U" goto:SwitchSM4.3U-DWO
if /i "%LIST3%" EQU "4.2U" goto:SwitchSM4.2U-DWO
if /i "%LIST3%" EQU "4.1U" goto:SwitchSM4.1U-DWO
if /i "%LIST3%" EQU "4.3E" goto:SwitchSM4.3E-DWO
if /i "%LIST3%" EQU "4.2E" goto:SwitchSM4.2E-DWO
if /i "%LIST3%" EQU "4.1E" goto:SwitchSM4.1E-DWO
if /i "%LIST3%" EQU "4.3J" goto:SwitchSM4.3J-DWO
if /i "%LIST3%" EQU "4.2J" goto:SwitchSM4.2J-DWO
if /i "%LIST3%" EQU "4.1J" goto:SwitchSM4.1J-DWO
if /i "%LIST3%" EQU "4.3K" goto:SwitchSM4.3K-DWO
if /i "%LIST3%" EQU "4.2K" goto:SwitchSM4.2K-DWO
if /i "%LIST3%" EQU "4.1K" goto:SwitchSM4.1K-DWO
:skipOrange


echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:LIST3


:OptionCEp3
if /i "%effect%" EQU "no-spin" (set effect=Spin) & (support\sfk filter Support\settings.bat -!"Set effect=" -write -yes>nul) & (echo Set effect=Spin>>Support\settings.bat) & (goto:list3)
if /i "%effect%" EQU "spin" (set effect=Fast-Spin) & (support\sfk filter Support\settings.bat -!"Set effect=" -write -yes>nul) & (echo Set effect=Fast-Spin>>Support\settings.bat) & (goto:list3)
if /i "%effect%" EQU "fast-spin" (set effect=No-Spin) & (support\sfk filter Support\settings.bat -!"Set effect=" -write -yes>nul) & (echo Set effect=No-Spin>>Support\settings.bat) & (goto:list3)

:SwitchMyM
if /i "%MyM%" EQU "*" (set MyM=) else (set MyM=*)
goto:LIST3

:SwitchDarkWii_Red_4.3U
if /i "%DarkWii_Red_4.3U%" EQU "*" (set DarkWii_Red_4.3U=) else (set DarkWii_Red_4.3U=*)
goto:LIST3

:SwitchDarkWii_Red_4.2U
if /i "%DarkWii_Red_4.2U%" EQU "*" (set DarkWii_Red_4.2U=) else (set DarkWii_Red_4.2U=*)
goto:LIST3

:SwitchDarkWii_Red_4.1U
if /i "%DarkWii_Red_4.1U%" EQU "*" (set DarkWii_Red_4.1U=) else (set DarkWii_Red_4.1U=*)
goto:LIST3

:SwitchDarkWii_Red_4.3E
if /i "%DarkWii_Red_4.3E%" EQU "*" (set DarkWii_Red_4.3E=) else (set DarkWii_Red_4.3E=*)
goto:LIST3

:SwitchDarkWii_Red_4.2E
if /i "%DarkWii_Red_4.2E%" EQU "*" (set DarkWii_Red_4.2E=) else (set DarkWii_Red_4.2E=*)
goto:LIST3

:SwitchDarkWii_Red_4.1E
if /i "%DarkWii_Red_4.1E%" EQU "*" (set DarkWii_Red_4.1E=) else (set DarkWii_Red_4.1E=*)
goto:LIST3

:SwitchDarkWii_Red_4.1J
if /i "%DarkWii_Red_4.1J%" EQU "*" (set DarkWii_Red_4.1J=) else (set DarkWii_Red_4.1J=*)
goto:LIST3

:SwitchDarkWii_Red_4.2J
if /i "%DarkWii_Red_4.2J%" EQU "*" (set DarkWii_Red_4.2J=) else (set DarkWii_Red_4.2J=*)
goto:LIST3

:SwitchDarkWii_Red_4.3J
if /i "%DarkWii_Red_4.3J%" EQU "*" (set DarkWii_Red_4.3J=) else (set DarkWii_Red_4.3J=*)
goto:LIST3

:SwitchDarkWii_Red_4.1K
if /i "%DarkWii_Red_4.1K%" EQU "*" (set DarkWii_Red_4.1K=) else (set DarkWii_Red_4.1K=*)
goto:LIST3

:SwitchDarkWii_Red_4.2K
if /i "%DarkWii_Red_4.2K%" EQU "*" (set DarkWii_Red_4.2K=) else (set DarkWii_Red_4.2K=*)
goto:LIST3

:SwitchDarkWii_Red_4.3K
if /i "%DarkWii_Red_4.3K%" EQU "*" (set DarkWii_Red_4.3K=) else (set DarkWii_Red_4.3K=*)
goto:LIST3


:SwitchSM4.3U-DWR
if /i "%SM4.3U-DWR%" EQU "*" (set SM4.3U-DWR=) else (set SM4.3U-DWR=*)
goto:LIST3

:SwitchSM4.2U-DWR
if /i "%SM4.2U-DWR%" EQU "*" (set SM4.2U-DWR=) else (set SM4.2U-DWR=*)
goto:LIST3

:SwitchSM4.1U-DWR
if /i "%SM4.1U-DWR%" EQU "*" (set SM4.1U-DWR=) else (set SM4.1U-DWR=*)
goto:LIST3

:SwitchSM4.3E-DWR
if /i "%SM4.3E-DWR%" EQU "*" (set SM4.3E-DWR=) else (set SM4.3E-DWR=*)
goto:LIST3

:SwitchSM4.2E-DWR
if /i "%SM4.2E-DWR%" EQU "*" (set SM4.2E-DWR=) else (set SM4.2E-DWR=*)
goto:LIST3

:SwitchSM4.1E-DWR
if /i "%SM4.1E-DWR%" EQU "*" (set SM4.1E-DWR=) else (set SM4.1E-DWR=*)
goto:LIST3

:SwitchSM4.3J-DWR
if /i "%SM4.3J-DWR%" EQU "*" (set SM4.3J-DWR=) else (set SM4.3J-DWR=*)
goto:LIST3

:SwitchSM4.2J-DWR
if /i "%SM4.2J-DWR%" EQU "*" (set SM4.2J-DWR=) else (set SM4.2J-DWR=*)
goto:LIST3

:SwitchSM4.1J-DWR
if /i "%SM4.1J-DWR%" EQU "*" (set SM4.1J-DWR=) else (set SM4.1J-DWR=*)
goto:LIST3

:SwitchSM4.3K-DWR
if /i "%SM4.3K-DWR%" EQU "*" (set SM4.3K-DWR=) else (set SM4.3K-DWR=*)
goto:LIST3

:SwitchSM4.2K-DWR
if /i "%SM4.2K-DWR%" EQU "*" (set SM4.2K-DWR=) else (set SM4.2K-DWR=*)
goto:LIST3

:SwitchSM4.1K-DWR
if /i "%SM4.1K-DWR%" EQU "*" (set SM4.1K-DWR=) else (set SM4.1K-DWR=*)
goto:LIST3

:SwitchDarkWii_Green_4.3U
if /i "%DarkWii_Green_4.3U%" EQU "*" (set DarkWii_Green_4.3U=) else (set DarkWii_Green_4.3U=*)
goto:LIST3

:SwitchDarkWii_Green_4.2U
if /i "%DarkWii_Green_4.2U%" EQU "*" (set DarkWii_Green_4.2U=) else (set DarkWii_Green_4.2U=*)
goto:LIST3

:SwitchDarkWii_Green_4.1U
if /i "%DarkWii_Green_4.1U%" EQU "*" (set DarkWii_Green_4.1U=) else (set DarkWii_Green_4.1U=*)
goto:LIST3

:SwitchDarkWii_Green_4.3E
if /i "%DarkWii_Green_4.3E%" EQU "*" (set DarkWii_Green_4.3E=) else (set DarkWii_Green_4.3E=*)
goto:LIST3

:SwitchDarkWii_Green_4.2E
if /i "%DarkWii_Green_4.2E%" EQU "*" (set DarkWii_Green_4.2E=) else (set DarkWii_Green_4.2E=*)
goto:LIST3

:SwitchDarkWii_Green_4.1E
if /i "%DarkWii_Green_4.1E%" EQU "*" (set DarkWii_Green_4.1E=) else (set DarkWii_Green_4.1E=*)
goto:LIST3

:SwitchDarkWii_Green_4.1J
if /i "%DarkWii_Green_4.1J%" EQU "*" (set DarkWii_Green_4.1J=) else (set DarkWii_Green_4.1J=*)
goto:LIST3

:SwitchDarkWii_Green_4.2J
if /i "%DarkWii_Green_4.2J%" EQU "*" (set DarkWii_Green_4.2J=) else (set DarkWii_Green_4.2J=*)
goto:LIST3

:SwitchDarkWii_Green_4.3J
if /i "%DarkWii_Green_4.3J%" EQU "*" (set DarkWii_Green_4.3J=) else (set DarkWii_Green_4.3J=*)
goto:LIST3

:SwitchDarkWii_Green_4.1K
if /i "%DarkWii_Green_4.1K%" EQU "*" (set DarkWii_Green_4.1K=) else (set DarkWii_Green_4.1K=*)
goto:LIST3

:SwitchDarkWii_Green_4.2K
if /i "%DarkWii_Green_4.2K%" EQU "*" (set DarkWii_Green_4.2K=) else (set DarkWii_Green_4.2K=*)
goto:LIST3

:SwitchDarkWii_Green_4.3K
if /i "%DarkWii_Green_4.3K%" EQU "*" (set DarkWii_Green_4.3K=) else (set DarkWii_Green_4.3K=*)
goto:LIST3


:SwitchSM4.3U-DWG
if /i "%SM4.3U-DWG%" EQU "*" (set SM4.3U-DWG=) else (set SM4.3U-DWG=*)
goto:LIST3

:SwitchSM4.2U-DWG
if /i "%SM4.2U-DWG%" EQU "*" (set SM4.2U-DWG=) else (set SM4.2U-DWG=*)
goto:LIST3

:SwitchSM4.1U-DWG
if /i "%SM4.1U-DWG%" EQU "*" (set SM4.1U-DWG=) else (set SM4.1U-DWG=*)
goto:LIST3

:SwitchSM4.3E-DWG
if /i "%SM4.3E-DWG%" EQU "*" (set SM4.3E-DWG=) else (set SM4.3E-DWG=*)
goto:LIST3

:SwitchSM4.2E-DWG
if /i "%SM4.2E-DWG%" EQU "*" (set SM4.2E-DWG=) else (set SM4.2E-DWG=*)
goto:LIST3

:SwitchSM4.1E-DWG
if /i "%SM4.1E-DWG%" EQU "*" (set SM4.1E-DWG=) else (set SM4.1E-DWG=*)
goto:LIST3

:SwitchSM4.3J-DWG
if /i "%SM4.3J-DWG%" EQU "*" (set SM4.3J-DWG=) else (set SM4.3J-DWG=*)
goto:LIST3

:SwitchSM4.2J-DWG
if /i "%SM4.2J-DWG%" EQU "*" (set SM4.2J-DWG=) else (set SM4.2J-DWG=*)
goto:LIST3

:SwitchSM4.1J-DWG
if /i "%SM4.1J-DWG%" EQU "*" (set SM4.1J-DWG=) else (set SM4.1J-DWG=*)
goto:LIST3

:SwitchSM4.3K-DWG
if /i "%SM4.3K-DWG%" EQU "*" (set SM4.3K-DWG=) else (set SM4.3K-DWG=*)
goto:LIST3

:SwitchSM4.2K-DWG
if /i "%SM4.2K-DWG%" EQU "*" (set SM4.2K-DWG=) else (set SM4.2K-DWG=*)
goto:LIST3

:SwitchSM4.1K-DWG
if /i "%SM4.1K-DWG%" EQU "*" (set SM4.1K-DWG=) else (set SM4.1K-DWG=*)
goto:LIST3



:SwitchDarkWii_Blue_4.3U
if /i "%DarkWii_Blue_4.3U%" EQU "*" (set DarkWii_Blue_4.3U=) else (set DarkWii_Blue_4.3U=*)
goto:LIST3

:SwitchDarkWii_Blue_4.2U
if /i "%DarkWii_Blue_4.2U%" EQU "*" (set DarkWii_Blue_4.2U=) else (set DarkWii_Blue_4.2U=*)
goto:LIST3

:SwitchDarkWii_Blue_4.1U
if /i "%DarkWii_Blue_4.1U%" EQU "*" (set DarkWii_Blue_4.1U=) else (set DarkWii_Blue_4.1U=*)
goto:LIST3

:SwitchDarkWii_Blue_4.3E
if /i "%DarkWii_Blue_4.3E%" EQU "*" (set DarkWii_Blue_4.3E=) else (set DarkWii_Blue_4.3E=*)
goto:LIST3

:SwitchDarkWii_Blue_4.2E
if /i "%DarkWii_Blue_4.2E%" EQU "*" (set DarkWii_Blue_4.2E=) else (set DarkWii_Blue_4.2E=*)
goto:LIST3

:SwitchDarkWii_Blue_4.1E
if /i "%DarkWii_Blue_4.1E%" EQU "*" (set DarkWii_Blue_4.1E=) else (set DarkWii_Blue_4.1E=*)
goto:LIST3

:SwitchDarkWii_Blue_4.1J
if /i "%DarkWii_Blue_4.1J%" EQU "*" (set DarkWii_Blue_4.1J=) else (set DarkWii_Blue_4.1J=*)
goto:LIST3

:SwitchDarkWii_Blue_4.2J
if /i "%DarkWii_Blue_4.2J%" EQU "*" (set DarkWii_Blue_4.2J=) else (set DarkWii_Blue_4.2J=*)
goto:LIST3

:SwitchDarkWii_Blue_4.3J
if /i "%DarkWii_Blue_4.3J%" EQU "*" (set DarkWii_Blue_4.3J=) else (set DarkWii_Blue_4.3J=*)
goto:LIST3

:SwitchDarkWii_Blue_4.1K
if /i "%DarkWii_Blue_4.1K%" EQU "*" (set DarkWii_Blue_4.1K=) else (set DarkWii_Blue_4.1K=*)
goto:LIST3

:SwitchDarkWii_Blue_4.2K
if /i "%DarkWii_Blue_4.2K%" EQU "*" (set DarkWii_Blue_4.2K=) else (set DarkWii_Blue_4.2K=*)
goto:LIST3

:SwitchDarkWii_Blue_4.3K
if /i "%DarkWii_Blue_4.3K%" EQU "*" (set DarkWii_Blue_4.3K=) else (set DarkWii_Blue_4.3K=*)
goto:LIST3


:SwitchSM4.3U-DWB
if /i "%SM4.3U-DWB%" EQU "*" (set SM4.3U-DWB=) else (set SM4.3U-DWB=*)
goto:LIST3

:SwitchSM4.2U-DWB
if /i "%SM4.2U-DWB%" EQU "*" (set SM4.2U-DWB=) else (set SM4.2U-DWB=*)
goto:LIST3

:SwitchSM4.1U-DWB
if /i "%SM4.1U-DWB%" EQU "*" (set SM4.1U-DWB=) else (set SM4.1U-DWB=*)
goto:LIST3

:SwitchSM4.3E-DWB
if /i "%SM4.3E-DWB%" EQU "*" (set SM4.3E-DWB=) else (set SM4.3E-DWB=*)
goto:LIST3

:SwitchSM4.2E-DWB
if /i "%SM4.2E-DWB%" EQU "*" (set SM4.2E-DWB=) else (set SM4.2E-DWB=*)
goto:LIST3

:SwitchSM4.1E-DWB
if /i "%SM4.1E-DWB%" EQU "*" (set SM4.1E-DWB=) else (set SM4.1E-DWB=*)
goto:LIST3

:SwitchSM4.3J-DWB
if /i "%SM4.3J-DWB%" EQU "*" (set SM4.3J-DWB=) else (set SM4.3J-DWB=*)
goto:LIST3

:SwitchSM4.2J-DWB
if /i "%SM4.2J-DWB%" EQU "*" (set SM4.2J-DWB=) else (set SM4.2J-DWB=*)
goto:LIST3

:SwitchSM4.1J-DWB
if /i "%SM4.1J-DWB%" EQU "*" (set SM4.1J-DWB=) else (set SM4.1J-DWB=*)
goto:LIST3

:SwitchSM4.3K-DWB
if /i "%SM4.3K-DWB%" EQU "*" (set SM4.3K-DWB=) else (set SM4.3K-DWB=*)
goto:LIST3

:SwitchSM4.2K-DWB
if /i "%SM4.2K-DWB%" EQU "*" (set SM4.2K-DWB=) else (set SM4.2K-DWB=*)
goto:LIST3

:SwitchSM4.1K-DWB
if /i "%SM4.1K-DWB%" EQU "*" (set SM4.1K-DWB=) else (set SM4.1K-DWB=*)
goto:LIST3


:Switchdarkwii_orange_4.3U
if /i "%darkwii_orange_4.3U%" EQU "*" (set darkwii_orange_4.3U=) else (set darkwii_orange_4.3U=*)
goto:LIST3

:Switchdarkwii_orange_4.2U
if /i "%darkwii_orange_4.2U%" EQU "*" (set darkwii_orange_4.2U=) else (set darkwii_orange_4.2U=*)
goto:LIST3

:Switchdarkwii_orange_4.1U
if /i "%darkwii_orange_4.1U%" EQU "*" (set darkwii_orange_4.1U=) else (set darkwii_orange_4.1U=*)
goto:LIST3

:Switchdarkwii_orange_4.3E
if /i "%darkwii_orange_4.3E%" EQU "*" (set darkwii_orange_4.3E=) else (set darkwii_orange_4.3E=*)
goto:LIST3

:Switchdarkwii_orange_4.2E
if /i "%darkwii_orange_4.2E%" EQU "*" (set darkwii_orange_4.2E=) else (set darkwii_orange_4.2E=*)
goto:LIST3

:Switchdarkwii_orange_4.1E
if /i "%darkwii_orange_4.1E%" EQU "*" (set darkwii_orange_4.1E=) else (set darkwii_orange_4.1E=*)
goto:LIST3

:Switchdarkwii_orange_4.1J
if /i "%darkwii_orange_4.1J%" EQU "*" (set darkwii_orange_4.1J=) else (set darkwii_orange_4.1J=*)
goto:LIST3

:Switchdarkwii_orange_4.2J
if /i "%darkwii_orange_4.2J%" EQU "*" (set darkwii_orange_4.2J=) else (set darkwii_orange_4.2J=*)
goto:LIST3

:Switchdarkwii_orange_4.3J
if /i "%darkwii_orange_4.3J%" EQU "*" (set darkwii_orange_4.3J=) else (set darkwii_orange_4.3J=*)
goto:LIST3

:Switchdarkwii_orange_4.1K
if /i "%darkwii_orange_4.1K%" EQU "*" (set darkwii_orange_4.1K=) else (set darkwii_orange_4.1K=*)
goto:LIST3

:Switchdarkwii_orange_4.2K
if /i "%darkwii_orange_4.2K%" EQU "*" (set darkwii_orange_4.2K=) else (set darkwii_orange_4.2K=*)
goto:LIST3

:Switchdarkwii_orange_4.3K
if /i "%darkwii_orange_4.3K%" EQU "*" (set darkwii_orange_4.3K=) else (set darkwii_orange_4.3K=*)
goto:LIST3


:SwitchSM4.3U-DWO
if /i "%SM4.3U-DWO%" EQU "*" (set SM4.3U-DWO=) else (set SM4.3U-DWO=*)
goto:LIST3

:SwitchSM4.2U-DWO
if /i "%SM4.2U-DWO%" EQU "*" (set SM4.2U-DWO=) else (set SM4.2U-DWO=*)
goto:LIST3

:SwitchSM4.1U-DWO
if /i "%SM4.1U-DWO%" EQU "*" (set SM4.1U-DWO=) else (set SM4.1U-DWO=*)
goto:LIST3

:SwitchSM4.3E-DWO
if /i "%SM4.3E-DWO%" EQU "*" (set SM4.3E-DWO=) else (set SM4.3E-DWO=*)
goto:LIST3

:SwitchSM4.2E-DWO
if /i "%SM4.2E-DWO%" EQU "*" (set SM4.2E-DWO=) else (set SM4.2E-DWO=*)
goto:LIST3

:SwitchSM4.1E-DWO
if /i "%SM4.1E-DWO%" EQU "*" (set SM4.1E-DWO=) else (set SM4.1E-DWO=*)
goto:LIST3

:SwitchSM4.3J-DWO
if /i "%SM4.3J-DWO%" EQU "*" (set SM4.3J-DWO=) else (set SM4.3J-DWO=*)
goto:LIST3

:SwitchSM4.2J-DWO
if /i "%SM4.2J-DWO%" EQU "*" (set SM4.2J-DWO=) else (set SM4.2J-DWO=*)
goto:LIST3

:SwitchSM4.1J-DWO
if /i "%SM4.1J-DWO%" EQU "*" (set SM4.1J-DWO=) else (set SM4.1J-DWO=*)
goto:LIST3

:SwitchSM4.3K-DWO
if /i "%SM4.3K-DWO%" EQU "*" (set SM4.3K-DWO=) else (set SM4.3K-DWO=*)
goto:LIST3

:SwitchSM4.2K-DWO
if /i "%SM4.2K-DWO%" EQU "*" (set SM4.2K-DWO=) else (set SM4.2K-DWO=*)
goto:LIST3

:SwitchSM4.1K-DWO
if /i "%SM4.1K-DWO%" EQU "*" (set SM4.1K-DWO=) else (set SM4.1K-DWO=*)
goto:LIST3


:SwitchA40
if /i "%A40%" EQU "*" (set A40=) else (set A40=*)
goto:LIST3

:SwitchA42
if /i "%A42%" EQU "*" (set A42=) else (set A42=*)
goto:LIST3

:SwitchA45
if /i "%A45%" EQU "*" (set A45=) else (set A45=*)
goto:LIST3

:SwitchA70
if /i "%A70%" EQU "*" (set A70=) else (set A70=*)
goto:LIST3

:SwitchA72
if /i "%A72%" EQU "*" (set A72=) else (set A72=*)
goto:LIST3

:SwitchA75
if /i "%A75%" EQU "*" (set A75=) else (set A75=*)
goto:LIST3

:SwitchA78
if /i "%A78%" EQU "*" (set A78=) else (set A78=*)
goto:LIST3

:SwitchA7b
if /i "%A7b%" EQU "*" (set A7b=) else (set A7b=*)
goto:LIST3

:SwitchA7e
if /i "%A7e%" EQU "*" (set A7e=) else (set A7e=*)
goto:LIST3

:SwitchA84
if /i "%A84%" EQU "*" (set A84=) else (set A84=*)
goto:LIST3

:SwitchA87
if /i "%A87%" EQU "*" (set A87=) else (set A87=*)
goto:LIST3

:SwitchA8a
if /i "%A8a%" EQU "*" (set A8a=) else (set A8a=*)
goto:LIST3

:SwitchA94
if /i "%A94%" EQU "*" (set A94=) else (set A94=*)
goto:LIST3

:SwitchA97
if /i "%A97%" EQU "*" (set A97=) else (set A97=*)
goto:LIST3

:SwitchA9a
if /i "%A9a%" EQU "*" (set A9a=) else (set A9a=*)
goto:LIST3

:SwitchA81
if /i "%A81%" EQU "*" (set A81=) else (set A81=*)
goto:LIST3

:SwitchA8d
if /i "%A8d%" EQU "*" (set A8d=) else (set A8d=*)
goto:LIST3

:SwitchA9d
if /i "%A9d%" EQU "*" (set A9d=) else (set A9d=*)
goto:LIST3


:SelectAll4

:UTHEMES
if /i "%selectedtheme%" EQU "R" set DarkWii_Red_4.3U=*
if /i "%selectedtheme%" EQU "R" set DarkWii_Red_4.2U=*
if /i "%selectedtheme%" EQU "R" set DarkWii_Red_4.1U=*
if /i "%selectedtheme%" EQU "G" set DarkWii_Green_4.3U=*
if /i "%selectedtheme%" EQU "G" set DarkWii_Green_4.2U=*
if /i "%selectedtheme%" EQU "G" set DarkWii_Green_4.1U=*
if /i "%selectedtheme%" EQU "B" set DarkWii_Blue_4.3U=*
if /i "%selectedtheme%" EQU "B" set DarkWii_Blue_4.2U=*
if /i "%selectedtheme%" EQU "B" set DarkWii_Blue_4.1U=*
if /i "%selectedtheme%" EQU "O" set darkwii_orange_4.3U=*
if /i "%selectedtheme%" EQU "O" set darkwii_orange_4.2U=*
if /i "%selectedtheme%" EQU "O" set darkwii_orange_4.1U=*
if /i "%LIST3%" EQU "U" goto:LIST3

:ETHEMES
if /i "%selectedtheme%" EQU "R" set DarkWii_Red_4.3E=*
if /i "%selectedtheme%" EQU "R" set DarkWii_Red_4.2E=*
if /i "%selectedtheme%" EQU "R" set DarkWii_Red_4.1E=*
if /i "%selectedtheme%" EQU "G" set DarkWii_Green_4.3E=*
if /i "%selectedtheme%" EQU "G" set DarkWii_Green_4.2E=*
if /i "%selectedtheme%" EQU "G" set DarkWii_Green_4.1E=*
if /i "%selectedtheme%" EQU "B" set DarkWii_Blue_4.3E=*
if /i "%selectedtheme%" EQU "B" set DarkWii_Blue_4.2E=*
if /i "%selectedtheme%" EQU "B" set DarkWii_Blue_4.1E=*
if /i "%selectedtheme%" EQU "O" set darkwii_orange_4.3E=*
if /i "%selectedtheme%" EQU "O" set darkwii_orange_4.2E=*
if /i "%selectedtheme%" EQU "O" set darkwii_orange_4.1E=*
if /i "%LIST3%" EQU "E" goto:LIST3

:JTHEMES
if /i "%selectedtheme%" EQU "R" set DarkWii_Red_4.3J=*
if /i "%selectedtheme%" EQU "R" set DarkWii_Red_4.2J=*
if /i "%selectedtheme%" EQU "R" set DarkWii_Red_4.1J=*
if /i "%selectedtheme%" EQU "G" set DarkWii_Green_4.3J=*
if /i "%selectedtheme%" EQU "G" set DarkWii_Green_4.2J=*
if /i "%selectedtheme%" EQU "G" set DarkWii_Green_4.1J=*
if /i "%selectedtheme%" EQU "B" set DarkWii_Blue_4.3J=*
if /i "%selectedtheme%" EQU "B" set DarkWii_Blue_4.2J=*
if /i "%selectedtheme%" EQU "B" set DarkWii_Blue_4.1J=*
if /i "%selectedtheme%" EQU "O" set darkwii_orange_4.3J=*
if /i "%selectedtheme%" EQU "O" set darkwii_orange_4.2J=*
if /i "%selectedtheme%" EQU "O" set darkwii_orange_4.1J=*
if /i "%LIST3%" EQU "J" goto:LIST3

:KTHEMES
if /i "%selectedtheme%" EQU "R" set DarkWii_Red_4.3K=*
if /i "%selectedtheme%" EQU "R" set DarkWii_Red_4.2K=*
if /i "%selectedtheme%" EQU "R" set DarkWii_Red_4.1K=*
if /i "%selectedtheme%" EQU "G" set DarkWii_Green_4.3K=*
if /i "%selectedtheme%" EQU "G" set DarkWii_Green_4.2K=*
if /i "%selectedtheme%" EQU "G" set DarkWii_Green_4.1K=*
if /i "%selectedtheme%" EQU "B" set DarkWii_Blue_4.3K=*
if /i "%selectedtheme%" EQU "B" set DarkWii_Blue_4.2K=*
if /i "%selectedtheme%" EQU "B" set DarkWii_Blue_4.1K=*
if /i "%selectedtheme%" EQU "O" set darkwii_orange_4.3K=*
if /i "%selectedtheme%" EQU "O" set darkwii_orange_4.2K=*
if /i "%selectedtheme%" EQU "O" set darkwii_orange_4.1K=*
if /i "%LIST3%" EQU "K" goto:LIST3

:SMUTHEMES
if /i "%selectedtheme%" EQU "R" set SM4.3U-DWR=*
if /i "%selectedtheme%" EQU "R" set SM4.2U-DWR=*
if /i "%selectedtheme%" EQU "R" set SM4.1U-DWR=*
if /i "%selectedtheme%" EQU "G" set SM4.3U-DWG=*
if /i "%selectedtheme%" EQU "G" set SM4.2U-DWG=*
if /i "%selectedtheme%" EQU "G" set SM4.1U-DWG=*
if /i "%selectedtheme%" EQU "B" set SM4.3U-DWB=*
if /i "%selectedtheme%" EQU "B" set SM4.2U-DWB=*
if /i "%selectedtheme%" EQU "B" set SM4.1U-DWB=*
if /i "%selectedtheme%" EQU "O" set SM4.3U-DWO=*
if /i "%selectedtheme%" EQU "O" set SM4.2U-DWO=*
if /i "%selectedtheme%" EQU "O" set SM4.1U-DWO=*
if /i "%LIST3%" EQU "US" goto:LIST3

:SMETHEMES
if /i "%selectedtheme%" EQU "R" set SM4.3E-DWR=*
if /i "%selectedtheme%" EQU "R" set SM4.2E-DWR=*
if /i "%selectedtheme%" EQU "R" set SM4.1E-DWR=*
if /i "%selectedtheme%" EQU "G" set SM4.3E-DWG=*
if /i "%selectedtheme%" EQU "G" set SM4.2E-DWG=*
if /i "%selectedtheme%" EQU "G" set SM4.1E-DWG=*
if /i "%selectedtheme%" EQU "B" set SM4.3E-DWB=*
if /i "%selectedtheme%" EQU "B" set SM4.2E-DWB=*
if /i "%selectedtheme%" EQU "B" set SM4.1E-DWB=*
if /i "%selectedtheme%" EQU "O" set SM4.3E-DWO=*
if /i "%selectedtheme%" EQU "O" set SM4.2E-DWO=*
if /i "%selectedtheme%" EQU "O" set SM4.1E-DWO=*
if /i "%LIST3%" EQU "EU" goto:LIST3

:SMJTHEMES
if /i "%selectedtheme%" EQU "R" set SM4.3J-DWR=*
if /i "%selectedtheme%" EQU "R" set SM4.2J-DWR=*
if /i "%selectedtheme%" EQU "R" set SM4.1J-DWR=*
if /i "%selectedtheme%" EQU "G" set SM4.3J-DWG=*
if /i "%selectedtheme%" EQU "G" set SM4.2J-DWG=*
if /i "%selectedtheme%" EQU "G" set SM4.1J-DWG=*
if /i "%selectedtheme%" EQU "B" set SM4.3J-DWB=*
if /i "%selectedtheme%" EQU "B" set SM4.2J-DWB=*
if /i "%selectedtheme%" EQU "B" set SM4.1J-DWB=*
if /i "%selectedtheme%" EQU "O" set SM4.3J-DWO=*
if /i "%selectedtheme%" EQU "O" set SM4.2J-DWO=*
if /i "%selectedtheme%" EQU "O" set SM4.1J-DWO=*
if /i "%LIST3%" EQU "JA" goto:LIST3

:SMKTHEMES
if /i "%selectedtheme%" EQU "R" set SM4.3K-DWR=*
if /i "%selectedtheme%" EQU "R" set SM4.2K-DWR=*
if /i "%selectedtheme%" EQU "R" set SM4.1K-DWR=*
if /i "%selectedtheme%" EQU "G" set SM4.3K-DWG=*
if /i "%selectedtheme%" EQU "G" set SM4.2K-DWG=*
if /i "%selectedtheme%" EQU "G" set SM4.1K-DWG=*
if /i "%selectedtheme%" EQU "B" set SM4.3K-DWB=*
if /i "%selectedtheme%" EQU "B" set SM4.2K-DWB=*
if /i "%selectedtheme%" EQU "B" set SM4.1K-DWB=*
if /i "%selectedtheme%" EQU "O" set SM4.3K-DWO=*
if /i "%selectedtheme%" EQU "O" set SM4.2K-DWO=*
if /i "%selectedtheme%" EQU "O" set SM4.1K-DWO=*
if /i "%LIST3%" EQU "KO" goto:LIST3



::not in any list
set MyM=*

:SelectJMyMApps
set A40=*
set A70=*
set A78=*
set A84=*
set A94=*

:SelectUMyMApps
set A42=*
set A72=*
set A7b=*
set A87=*
set A97=*

:SelectKMyMApps
set A81=*
set A8d=*
set A9d=*

:SelectEMyMApps
set A45=*
set A75=*
set A7e=*
set A8a=*
set A9a=*

goto:LIST3




::........................................Additional LIST4 / BATCH.......................................
:LIST4
Set LIST4=
cls
echo                                        ModMii                                v%currentversion%
support\sfk echo -spat \x20 \x20 \x20 \x20 \x20[Red]DOWNLOAD PAGE 4 [def]\x20 \x20 \x20 \x20 \x20 \x20 \x20by XFlak

echo.
echo      Choose files to add/remove to download queue (Selected files marked with an *)
echo.
echo       D = Download Selected Files    1/2/3/4 = Page 1/2/3/4        M = Main Menu
echo       C = Clear Download Queue       (blank) = Cycle Pages        DR = Drive Menu
echo       A = Select All                     REC = Recommended cIOSs
echo.

support\sfk echo -spat \x20 \x20 \x20 \x20 \x20 \x20 [Red] Waninkoko (v14) cIOSs \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 Hermes (v4) cIOSs
echo              %cIOS249-v14% 24914 = cIOS249-v14              %cIOS223[37-38]-v4% 2234 = cIOS223[37-38]-v4
echo              %cIOS250-v14% 25014 = cIOS250-v14              %cIOS222[38]-v4% 2224 = cIOS222[38]-v4
echo.

support\sfk echo -spat \x20 \x20 \x20 \x20 \x20 \x20 [Red] Waninkoko (v17b) cIOSs \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20Hermes (v5) cIOSs
echo              %cIOS249-v17b% 24917 = cIOS249-v17b             %cIOS222[38]-v5% 2225 = cIOS222[38]-v5
echo              %cIOS250-v17b% 25017 = cIOS250-v17b             %cIOS223[37]-v5% 2235 = cIOS223[37]-v5
echo                                                %cIOS224[57]-v5% 2245 = cIOS224[57]-v5

support\sfk echo -spat \x20 \x20 \x20 \x20 \x20 \x20 [Red] Waninkoko (v19) cIOSs

support\sfk echo -spat \x20 \x20 \x20 \x20 \x20 \x20 %cIOS249[37]-v19% 2491937 = cIOS249[37]-v19 \x20 \x20 \x20 [Red] Hermes\Rodries (v5.1)R cIOSs

echo            %cIOS250[37]-v19% 2501937 = cIOS250[37]-v19         %cIOS202[60]-v5.1R% 20251 = cIOS202[60]-v5.1R
echo            %cIOS249[38]-v19% 2491938 = cIOS249[38]-v19         %cIOS222[38]-v5.1R% 22251 = cIOS222[38]-v5.1R
echo            %cIOS250[38]-v19% 2501938 = cIOS250[38]-v19         %cIOS223[37]-v5.1R% 22351 = cIOS223[37]-v5.1R
echo            %cIOS249[57]-v19% 2491957 = cIOS249[57]-v19         %cIOS224[57]-v5.1R% 22451 = cIOS224[57]-v5.1R
echo            %cIOS250[57]-v19% 2501957 = cIOS250[57]-v19

support\sfk echo -spat \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 [Red] (cM)IOSs
support\sfk echo -spat \x20 \x20 \x20 \x20 \x20 \x20 [Red] Waninkoko (v20) cIOSs [def] \x20 \x20 %DML%\x20DML = DML %CurrentDMLRev%


echo            %cIOS249[38]-v20% 2492038 = cIOS249[38]-v20    %RVL-cMIOS-v65535(v10)_WiiGator_WiiPower_v0.2% 10 = WiiGator+WiiPower cMIOS-v65535(v10)
echo            %cIOS250[38]-v20% 2502038 = cIOS250[38]-v20   %RVL-cmios-v4_WiiGator_GCBL_v0.2% 0.2 = WiiGator cMIOS-v4 v0.2
echo            %cIOS249[56]-v20% 2492056 = cIOS249[56]-v20     %RVL-cmios-v4_Waninkoko_rev5% 5 = Waninkoko cMIOS-v4 rev5
echo            %cIOS250[56]-v20% 2502056 = cIOS250[56]-v20


set d2x-beta-rev=8-final
if exist support\d2x-beta\d2x-beta.bat call support\d2x-beta\d2x-beta.bat


support\sfk echo -spat \x20 \x20 \x20 \x20 \x20 \x20%cIOS249[57]-v20%\x202492057 = cIOS249[57]-v20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 [Red](d2x) cIOSs

echo            %cIOS250[57]-v20% 2502057 = cIOS250[57]-v20     %cIOS249[37]-d2x-v8-final% 24937 = cIOS249[37]-d2x-v%d2x-beta-rev%
echo                                           %cIOS250[37]-d2x-v8-final% 25037 = cIOS250[37]-d2x-v%d2x-beta-rev%


support\sfk echo -spat \x20 \x20 \x20 \x20 \x20 \x20 [Red] Waninkoko (v21) cIOSs[def]\x20 \x20 \x20 \x20 %cIOS249[38]-d2x-v8-final%\x2024938 = cIOS249[38]-d2x-v%d2x-beta-rev%

echo            %cIOS249[37]-v21% 2492137 = cIOS249[37]-v21     %cIOS250[38]-d2x-v8-final% 25038 = cIOS250[38]-d2x-v%d2x-beta-rev%
echo            %cIOS250[37]-v21% 2502137 = cIOS250[37]-v21     %cIOS249[53]-d2x-v8-final% 24953 = cIOS249[53]-d2x-v%d2x-beta-rev%
echo            %cIOS249[38]-v21% 2492138 = cIOS249[38]-v21     %cIOS250[53]-d2x-v8-final% 25053 = cIOS250[53]-d2x-v%d2x-beta-rev%
echo            %cIOS250[38]-v21% 2502138 = cIOS250[38]-v21     %cIOS249[55]-d2x-v8-final% 24955 = cIOS249[55]-d2x-v%d2x-beta-rev%
echo            %cIOS249[53]-v21% 2492153 = cIOS249[53]-v21     %cIOS250[55]-d2x-v8-final% 25055 = cIOS250[55]-d2x-v%d2x-beta-rev%
echo            %cIOS250[53]-v21% 2502153 = cIOS250[53]-v21     %cIOS249[56]-d2x-v8-final% 24956 = cIOS249[56]-d2x-v%d2x-beta-rev%
echo            %cIOS249[55]-v21% 2492155 = cIOS249[55]-v21     %cIOS250[56]-d2x-v8-final% 25056 = cIOS250[56]-d2x-v%d2x-beta-rev%
echo            %cIOS250[55]-v21% 2502155 = cIOS250[55]-v21     %cIOS249[57]-d2x-v8-final% 24957 = cIOS249[57]-d2x-v%d2x-beta-rev%
echo            %cIOS249[56]-v21% 2492156 = cIOS249[56]-v21     %cIOS250[57]-d2x-v8-final% 25057 = cIOS250[57]-d2x-v%d2x-beta-rev%
echo            %cIOS250[56]-v21% 2502156 = cIOS250[56]-v21     %cIOS249[58]-d2x-v8-final% 24958 = cIOS249[58]-d2x-v%d2x-beta-rev%
echo            %cIOS249[57]-v21% 2492157 = cIOS249[57]-v21     %cIOS250[58]-d2x-v8-final% 25058 = cIOS250[58]-d2x-v%d2x-beta-rev%
echo            %cIOS250[57]-v21% 2502157 = cIOS250[57]-v21     %cIOS249[60]-d2x-v8-final% 24960 = cIOS249[60]-d2x-v%d2x-beta-rev%
echo            %cIOS249[58]-v21% 2492158 = cIOS249[58]-v21     %cIOS250[60]-d2x-v8-final% 25060 = cIOS250[60]-d2x-v%d2x-beta-rev%
echo            %cIOS250[58]-v21% 2502158 = cIOS250[58]-v21     %cIOS249[70]-d2x-v8-final% 24970 = cIOS249[70]-d2x-v%d2x-beta-rev%
echo                                           %cIOS250[70]-d2x-v8-final% 25070 = cIOS250[70]-d2x-v%d2x-beta-rev%
echo                                           %cIOS249[80]-d2x-v8-final% 24980 = cIOS249[80]-d2x-v%d2x-beta-rev%
echo                                           %cIOS250[80]-d2x-v8-final% 25080 = cIOS250[80]-d2x-v%d2x-beta-rev%
echo                                             BETA = d2x beta settings

::echo.

set /p LIST4=     Enter Selection Here: 

if /i "%LIST4%" EQU "M" goto:MENU
if /i "%LIST4%" EQU "D" set BACKB4QUEUE=LIST4
if /i "%LIST4%" EQU "D" set loadorgo=go
if /i "%LIST4%" EQU "D" goto:DOWNLOADQUEUE
if /i "%LIST4%" EQU "DR" set BACKB4DRIVE=LIST4
if /i "%LIST4%" EQU "DR" goto:DRIVECHANGE
if /i "%LIST4%" EQU "C" goto:CLEAR

if /i "%LIST4%" EQU "A" goto:SelectAllLIST4
if /i "%LIST4%" EQU "REC" goto:RECOMMENDEDCIOSS

if not exist support\More-cIOSs goto:quickskip
if /i "%LIST4%" EQU "BETA" (set backbeforebetaswitch=LIST4) & (goto:betaswitch)
:quickskip


if /i "%LIST4%" EQU "v4" goto:v4cIOSs
if /i "%LIST4%" EQU "v5" goto:v5cIOSs
if /i "%LIST4%" EQU "v5.1" goto:v5.1cIOSs
if /i "%LIST4%" EQU "v17b" goto:v17bcIOSs
if /i "%LIST4%" EQU "v14" goto:v14cIOSs
if /i "%LIST4%" EQU "v19" goto:v19cIOSs
if /i "%LIST4%" EQU "v20" goto:v20cIOSs
if /i "%LIST4%" EQU "v21" goto:v21cIOSs
if /i "%LIST4%" EQU "d2x" goto:d2xcIOSs
if /i "%LIST4%" EQU "cM" goto:cMIOSs

if /i "%LIST4%" EQU "1" goto:LIST
if /i "%LIST4%" EQU "2" goto:OLDLIST
if /i "%LIST4%" EQU "3" goto:LIST3
if /i "%LIST4%" EQU "4" goto:LIST4
if /i "%LIST4%" EQU "ADV" goto:ADVANCED
IF "%LIST4%"=="" goto:LIST


if /i "%LIST4%" EQU "DML" goto:SwitchDML

if /i "%LIST4%" EQU "2225" goto:SwitchcIOS222[38]-v5
if /i "%LIST4%" EQU "2235" goto:SwitchcIOS223[37]-v5
if /i "%LIST4%" EQU "2245" goto:SwitchcIOS224[57]-v5

if /i "%LIST4%" EQU "20251" goto:SwitchcIOS202[60]-v5.1R
if /i "%LIST4%" EQU "22251" goto:SwitchcIOS222[38]-v5.1R
if /i "%LIST4%" EQU "22351" goto:SwitchcIOS223[37]-v5.1R
if /i "%LIST4%" EQU "22451" goto:SwitchcIOS224[57]-v5.1R

if /i "%LIST4%" EQU "2491937" goto:SwitchcIOS249[37]-v19
if /i "%LIST4%" EQU "2491938" goto:SwitchcIOS249[38]-v19
if /i "%LIST4%" EQU "2492038" goto:SwitchcIOS249[38]-v20
if /i "%LIST4%" EQU "2502038" goto:SwitchcIOS250[38]-v20
if /i "%LIST4%" EQU "2492056" goto:SwitchcIOS249[56]-v20
if /i "%LIST4%" EQU "2502057" goto:SwitchcIOS250[57]-v20
if /i "%LIST4%" EQU "2492057" goto:SwitchcIOS249[57]-v20
if /i "%LIST4%" EQU "2502056" goto:SwitchcIOS250[56]-v20
if /i "%LIST4%" EQU "2491957" goto:SwitchcIOS249[57]-v19

if /i "%LIST4%" EQU "2501937" goto:SwitchcIOS250[37]-v19
if /i "%LIST4%" EQU "2501938" goto:SwitchcIOS250[38]-v19
if /i "%LIST4%" EQU "2501957" goto:SwitchcIOS250[57]-v19
if /i "%LIST4%" EQU "10" goto:SwitchRVL-cMIOS-v65535(v10)_WiiGator_WiiPower_v0.2
if /i "%LIST4%" EQU "0.2" goto:SwitchRVL-cmios-v4_WiiGator_GCBL_v0.2
if /i "%LIST4%" EQU "5" goto:SwitchRVL-cmios-v4_Waninkoko_rev5
if /i "%LIST4%" EQU "2224" goto:SwitchcIOS222[38]-v4

if /i "%LIST4%" EQU "2234" goto:SwitchcIOS223[37-38]-v4
if /i "%LIST4%" EQU "24917" goto:SwitchcIOS249-v17b
if /i "%LIST4%" EQU "25017" goto:SwitchcIOS250-v17b

if /i "%LIST4%" EQU "24914" goto:SwitchcIOS249-v14
if /i "%LIST4%" EQU "25014" goto:SwitchcIOS250-v14


if /i "%LIST4%" EQU "2492137" goto:SwitchcIOS249[37]-v21
if /i "%LIST4%" EQU "2502137" goto:SwitchcIOS250[37]-v21
if /i "%LIST4%" EQU "2492138" goto:SwitchcIOS249[38]-v21
if /i "%LIST4%" EQU "2502138" goto:SwitchcIOS250[38]-v21
if /i "%LIST4%" EQU "2492153" goto:SwitchcIOS249[53]-v21
if /i "%LIST4%" EQU "2502153" goto:SwitchcIOS250[53]-v21
if /i "%LIST4%" EQU "2492155" goto:SwitchcIOS249[55]-v21
if /i "%LIST4%" EQU "2502155" goto:SwitchcIOS250[55]-v21
if /i "%LIST4%" EQU "2492156" goto:SwitchcIOS249[56]-v21
if /i "%LIST4%" EQU "2502156" goto:SwitchcIOS250[56]-v21
if /i "%LIST4%" EQU "2492157" goto:SwitchcIOS249[57]-v21
if /i "%LIST4%" EQU "2502157" goto:SwitchcIOS250[57]-v21
if /i "%LIST4%" EQU "2492158" goto:SwitchcIOS249[58]-v21
if /i "%LIST4%" EQU "2502158" goto:SwitchcIOS250[58]-v21
if /i "%LIST4%" EQU "24937" goto:SwitchcIOS249[37]-d2x-v8-final
if /i "%LIST4%" EQU "24938" goto:SwitchcIOS249[38]-d2x-v8-final
if /i "%LIST4%" EQU "24953" goto:SwitchcIOS249[53]-d2x-v8-final
if /i "%LIST4%" EQU "24955" goto:SwitchcIOS249[55]-d2x-v8-final
if /i "%LIST4%" EQU "24956" goto:SwitchcIOS249[56]-d2x-v8-final
if /i "%LIST4%" EQU "24957" goto:SwitchcIOS249[57]-d2x-v8-final
if /i "%LIST4%" EQU "24958" goto:SwitchcIOS249[58]-d2x-v8-final
if /i "%LIST4%" EQU "24960" goto:SwitchcIOS249[60]-d2x-v8-final
if /i "%LIST4%" EQU "24970" goto:SwitchcIOS249[70]-d2x-v8-final
if /i "%LIST4%" EQU "24980" goto:SwitchcIOS249[80]-d2x-v8-final
if /i "%LIST4%" EQU "25037" goto:SwitchcIOS250[37]-d2x-v8-final
if /i "%LIST4%" EQU "25038" goto:SwitchcIOS250[38]-d2x-v8-final
if /i "%LIST4%" EQU "25053" goto:SwitchcIOS250[53]-d2x-v8-final
if /i "%LIST4%" EQU "25055" goto:SwitchcIOS250[55]-d2x-v8-final
if /i "%LIST4%" EQU "25056" goto:SwitchcIOS250[56]-d2x-v8-final
if /i "%LIST4%" EQU "25057" goto:SwitchcIOS250[57]-d2x-v8-final
if /i "%LIST4%" EQU "25058" goto:SwitchcIOS250[58]-d2x-v8-final
if /i "%LIST4%" EQU "25060" goto:SwitchcIOS250[60]-d2x-v8-final
if /i "%LIST4%" EQU "25070" goto:SwitchcIOS250[70]-d2x-v8-final
if /i "%LIST4%" EQU "25080" goto:SwitchcIOS250[80]-d2x-v8-final
echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:LIST4


:SwitchDML
if /i "%DML%" EQU "*" (set DML=) else (set DML=*)
if /i "%DML%" EQU "*" (set B4DMLRevSelect=list4) & (set AfterDMLRevSelect=list4) & (goto:CurrentDMLRevSelect)
if /i "%DML%" NEQ "*" set CurrentDMLRev=
goto:LIST4

:SwitchcIOS222[38]-v5
if /i "%cIOS222[38]-v5%" EQU "*" (set cIOS222[38]-v5=) else (set cIOS222[38]-v5=*)
goto:LIST4

:SwitchcIOS223[37]-v5
if /i "%cIOS223[37]-v5%" EQU "*" (set cIOS223[37]-v5=) else (set cIOS223[37]-v5=*)
goto:LIST4

:SwitchcIOS224[57]-v5
if /i "%cIOS224[57]-v5%" EQU "*" (set cIOS224[57]-v5=) else (set cIOS224[57]-v5=*)
goto:LIST4

:SwitchcIOS249[37]-v19
if /i "%cIOS249[37]-v19%" EQU "*" (set cIOS249[37]-v19=) else (set cIOS249[37]-v19=*)
goto:LIST4

:SwitchcIOS249[38]-v19
if /i "%cIOS249[38]-v19%" EQU "*" (set cIOS249[38]-v19=) else (set cIOS249[38]-v19=*)
goto:LIST4

:SwitchcIOS249[38]-v20
if /i "%cIOS249[38]-v20%" EQU "*" (set cIOS249[38]-v20=) else (set cIOS249[38]-v20=*)
goto:LIST4

:SwitchcIOS250[38]-v20
if /i "%cIOS250[38]-v20%" EQU "*" (set cIOS250[38]-v20=) else (set cIOS250[38]-v20=*)
goto:LIST4

:SwitchcIOS249[56]-v20
if /i "%cIOS249[56]-v20%" EQU "*" (set cIOS249[56]-v20=) else (set cIOS249[56]-v20=*)
goto:LIST4

:SwitchcIOS249[57]-v20
if /i "%cIOS249[57]-v20%" EQU "*" (set cIOS249[57]-v20=) else (set cIOS249[57]-v20=*)
goto:LIST4

:SwitchcIOS250[57]-v20
if /i "%cIOS250[57]-v20%" EQU "*" (set cIOS250[57]-v20=) else (set cIOS250[57]-v20=*)
goto:LIST4

:SwitchcIOS250[56]-v20
if /i "%cIOS250[56]-v20%" EQU "*" (set cIOS250[56]-v20=) else (set cIOS250[56]-v20=*)
goto:LIST4

:SwitchcIOS249[57]-v19
if /i "%cIOS249[57]-v19%" EQU "*" (set cIOS249[57]-v19=) else (set cIOS249[57]-v19=*)
goto:LIST4

:SwitchcIOS250[37]-v19
if /i "%cIOS250[37]-v19%" EQU "*" (set cIOS250[37]-v19=) else (set cIOS250[37]-v19=*)
goto:LIST4

:SwitchcIOS250[38]-v19
if /i "%cIOS250[38]-v19%" EQU "*" (set cIOS250[38]-v19=) else (set cIOS250[38]-v19=*)
goto:LIST4

:SwitchcIOS250[57]-v19
if /i "%cIOS250[57]-v19%" EQU "*" (set cIOS250[57]-v19=) else (set cIOS250[57]-v19=*)
goto:LIST4

:SwitchRVL-cmios-v4_WiiGator_GCBL_v0.2
if /i "%RVL-cmios-v4_WiiGator_GCBL_v0.2%" EQU "*" (set RVL-cmios-v4_WiiGator_GCBL_v0.2=) else (set RVL-cmios-v4_WiiGator_GCBL_v0.2=*)
goto:LIST4

:SwitchRVL-cMIOS-v65535(v10)_WiiGator_WiiPower_v0.2
if /i "%RVL-cMIOS-v65535(v10)_WiiGator_WiiPower_v0.2%" EQU "*" goto:switchRVL-cMIOS-v65535(v10)_WiiGator_WiiPower_v0.2off
set RVL-cMIOS-v65535(v10)_WiiGator_WiiPower_v0.2=*
goto:LIST4
:switchRVL-cMIOS-v65535(v10)_WiiGator_WiiPower_v0.2off
set RVL-cMIOS-v65535(v10)_WiiGator_WiiPower_v0.2=
goto:LIST4

:SwitchRVL-cmios-v4_Waninkoko_rev5
if /i "%RVL-cmios-v4_Waninkoko_rev5%" EQU "*" (set RVL-cmios-v4_Waninkoko_rev5=) else (set RVL-cmios-v4_Waninkoko_rev5=*)
goto:LIST4

:SwitchcIOS222[38]-v4
if /i "%cIOS222[38]-v4%" EQU "*" (set cIOS222[38]-v4=) else (set cIOS222[38]-v4=*)
goto:LIST4

:SwitchcIOS223[37-38]-v4
if /i "%cIOS223[37-38]-v4%" EQU "*" (set cIOS223[37-38]-v4=) else (set cIOS223[37-38]-v4=*)
goto:LIST4

:SwitchcIOS249-v17b
if /i "%cIOS249-v17b%" EQU "*" (set cIOS249-v17b=) else (set cIOS249-v17b=*)
goto:LIST4

:SwitchcIOS250-v17b
if /i "%cIOS250-v17b%" EQU "*" (set cIOS250-v17b=) else (set cIOS250-v17b=*)
goto:LIST4

:SwitchcIOS202[60]-v5.1R
if /i "%cIOS202[60]-v5.1R%" EQU "*" (set cIOS202[60]-v5.1R=) else (set cIOS202[60]-v5.1R=*)
goto:LIST4

:SwitchcIOS222[38]-v5.1R
if /i "%cIOS222[38]-v5.1R%" EQU "*" (set cIOS222[38]-v5.1R=) else (set cIOS222[38]-v5.1R=*)
goto:LIST4

:SwitchcIOS223[37]-v5.1R
if /i "%cIOS223[37]-v5.1R%" EQU "*" (set cIOS223[37]-v5.1R=) else (set cIOS223[37]-v5.1R=*)
goto:LIST4

:SwitchcIOS224[57]-v5.1R
if /i "%cIOS224[57]-v5.1R%" EQU "*" (set cIOS224[57]-v5.1R=) else (set cIOS224[57]-v5.1R=*)
goto:LIST4

:SwitchcIOS249-v14
if /i "%cIOS249-v14%" EQU "*" (set cIOS249-v14=) else (set cIOS249-v14=*)
goto:LIST4

:SwitchcIOS250-v14
if /i "%cIOS250-v14%" EQU "*" (set cIOS250-v14=) else (set cIOS250-v14=*)
goto:LIST4

:SwitchcIOS249[37]-v21
if /i "%cIOS249[37]-v21%" EQU "*" (set cIOS249[37]-v21=) else (set cIOS249[37]-v21=*)
goto:LIST4

:SwitchcIOS250[37]-v21
if /i "%cIOS250[37]-v21%" EQU "*" (set cIOS250[37]-v21=) else (set cIOS250[37]-v21=*)
goto:LIST4

:SwitchcIOS249[38]-v21
if /i "%cIOS249[38]-v21%" EQU "*" (set cIOS249[38]-v21=) else (set cIOS249[38]-v21=*)
goto:LIST4

:SwitchcIOS250[38]-v21
if /i "%cIOS250[38]-v21%" EQU "*" (set cIOS250[38]-v21=) else (set cIOS250[38]-v21=*)
goto:LIST4

:SwitchcIOS249[53]-v21
if /i "%cIOS249[53]-v21%" EQU "*" (set cIOS249[53]-v21=) else (set cIOS249[53]-v21=*)
goto:LIST4

:SwitchcIOS250[53]-v21
if /i "%cIOS250[53]-v21%" EQU "*" (set cIOS250[53]-v21=) else (set cIOS250[53]-v21=*)
goto:LIST4

:SwitchcIOS249[55]-v21
if /i "%cIOS249[55]-v21%" EQU "*" (set cIOS249[55]-v21=) else (set cIOS249[55]-v21=*)
goto:LIST4

:SwitchcIOS250[55]-v21
if /i "%cIOS250[55]-v21%" EQU "*" (set cIOS250[55]-v21=) else (set cIOS250[55]-v21=*)
goto:LIST4

:SwitchcIOS249[56]-v21
if /i "%cIOS249[56]-v21%" EQU "*" (set cIOS249[56]-v21=) else (set cIOS249[56]-v21=*)
goto:LIST4


:SwitchcIOS250[56]-v21
if /i "%cIOS250[56]-v21%" EQU "*" (set cIOS250[56]-v21=) else (set cIOS250[56]-v21=*)
goto:LIST4

:SwitchcIOS249[57]-v21
if /i "%cIOS249[57]-v21%" EQU "*" (set cIOS249[57]-v21=) else (set cIOS249[57]-v21=*)
goto:LIST4

:SwitchcIOS250[57]-v21
if /i "%cIOS250[57]-v21%" EQU "*" (set cIOS250[57]-v21=) else (set cIOS250[57]-v21=*)
goto:LIST4

:SwitchcIOS249[58]-v21
if /i "%cIOS249[58]-v21%" EQU "*" (set cIOS249[58]-v21=) else (set cIOS249[58]-v21=*)
goto:LIST4

:SwitchcIOS250[58]-v21
if /i "%cIOS250[58]-v21%" EQU "*" (set cIOS250[58]-v21=) else (set cIOS250[58]-v21=*)
goto:LIST4

:SwitchcIOS249[53]-d2x-v8-final
if /i "%cIOS249[53]-d2x-v8-final%" EQU "*" (set cIOS249[53]-d2x-v8-final=) else (set cIOS249[53]-d2x-v8-final=*)
goto:LIST4

:SwitchcIOS249[55]-d2x-v8-final
if /i "%cIOS249[55]-d2x-v8-final%" EQU "*" (set cIOS249[55]-d2x-v8-final=) else (set cIOS249[55]-d2x-v8-final=*)
goto:LIST4

:SwitchcIOS249[56]-d2x-v8-final
if /i "%cIOS249[56]-d2x-v8-final%" EQU "*" (set cIOS249[56]-d2x-v8-final=) else (set cIOS249[56]-d2x-v8-final=*)
goto:LIST4

:SwitchcIOS249[57]-d2x-v8-final
if /i "%cIOS249[57]-d2x-v8-final%" EQU "*" (set cIOS249[57]-d2x-v8-final=) else (set cIOS249[57]-d2x-v8-final=*)
goto:LIST4

:SwitchcIOS249[58]-d2x-v8-final
if /i "%cIOS249[58]-d2x-v8-final%" EQU "*" (set cIOS249[58]-d2x-v8-final=) else (set cIOS249[58]-d2x-v8-final=*)
goto:LIST4


:SwitchcIOS249[60]-d2x-v8-final
if /i "%cIOS249[60]-d2x-v8-final%" EQU "*" (set cIOS249[60]-d2x-v8-final=) else (set cIOS249[60]-d2x-v8-final=*)
goto:LIST4

:SwitchcIOS249[70]-d2x-v8-final
if /i "%cIOS249[70]-d2x-v8-final%" EQU "*" (set cIOS249[70]-d2x-v8-final=) else (set cIOS249[70]-d2x-v8-final=*)
goto:LIST4

:SwitchcIOS249[80]-d2x-v8-final
if /i "%cIOS249[80]-d2x-v8-final%" EQU "*" (set cIOS249[80]-d2x-v8-final=) else (set cIOS249[80]-d2x-v8-final=*)
goto:LIST4


:SwitchcIOS249[37]-d2x-v8-final
if /i "%cIOS249[37]-d2x-v8-final%" EQU "*" (set cIOS249[37]-d2x-v8-final=) else (set cIOS249[37]-d2x-v8-final=*)
goto:LIST4

:SwitchcIOS249[38]-d2x-v8-final
if /i "%cIOS249[38]-d2x-v8-final%" EQU "*" (set cIOS249[38]-d2x-v8-final=) else (set cIOS249[38]-d2x-v8-final=*)
goto:LIST4

:SwitchcIOS250[53]-d2x-v8-final
if /i "%cIOS250[53]-d2x-v8-final%" EQU "*" (set cIOS250[53]-d2x-v8-final=) else (set cIOS250[53]-d2x-v8-final=*)
goto:LIST4

:SwitchcIOS250[55]-d2x-v8-final
if /i "%cIOS250[55]-d2x-v8-final%" EQU "*" (set cIOS250[55]-d2x-v8-final=) else (set cIOS250[55]-d2x-v8-final=*)
goto:LIST4

:SwitchcIOS250[56]-d2x-v8-final
if /i "%cIOS250[56]-d2x-v8-final%" EQU "*" (set cIOS250[56]-d2x-v8-final=) else (set cIOS250[56]-d2x-v8-final=*)
goto:LIST4

:SwitchcIOS250[57]-d2x-v8-final
if /i "%cIOS250[57]-d2x-v8-final%" EQU "*" (set cIOS250[57]-d2x-v8-final=) else (set cIOS250[57]-d2x-v8-final=*)
goto:LIST4

:SwitchcIOS250[37]-d2x-v8-final
if /i "%cIOS250[37]-d2x-v8-final%" EQU "*" (set cIOS250[37]-d2x-v8-final=) else (set cIOS250[37]-d2x-v8-final=*)
goto:LIST4

:SwitchcIOS250[38]-d2x-v8-final
if /i "%cIOS250[38]-d2x-v8-final%" EQU "*" (set cIOS250[38]-d2x-v8-final=) else (set cIOS250[38]-d2x-v8-final=*)
goto:LIST4

:SwitchcIOS250[58]-d2x-v8-final
if /i "%cIOS250[58]-d2x-v8-final%" EQU "*" (set cIOS250[58]-d2x-v8-final=) else (set cIOS250[58]-d2x-v8-final=*)
goto:LIST4

:SwitchcIOS250[60]-d2x-v8-final
if /i "%cIOS250[60]-d2x-v8-final%" EQU "*" (set cIOS250[60]-d2x-v8-final=) else (set cIOS250[60]-d2x-v8-final=*)
goto:LIST4

:SwitchcIOS250[70]-d2x-v8-final
if /i "%cIOS250[70]-d2x-v8-final%" EQU "*" (set cIOS250[70]-d2x-v8-final=) else (set cIOS250[70]-d2x-v8-final=*)
goto:LIST4

:SwitchcIOS250[80]-d2x-v8-final
if /i "%cIOS250[80]-d2x-v8-final%" EQU "*" (set cIOS250[80]-d2x-v8-final=) else (set cIOS250[80]-d2x-v8-final=*)
goto:LIST4

:SELECTALLLIST4


:RECOMMENDEDCIOSS
set cIOS202[60]-v5.1R=*
set cIOS222[38]-v4=*
set cIOS223[37-38]-v4=*
set cIOS224[57]-v5.1R=*
set cIOS249[56]-d2x-v8-final=*
set cIOS250[57]-d2x-v8-final=*
set RVL-cMIOS-v65535(v10)_WiiGator_WiiPower_v0.2=*
if /i "%LIST4%" EQU "REC" goto:LIST4


:v4cIOSs
set cIOS223[37-38]-v4=*
set cIOS222[38]-v4=*
if /i "%LIST4%" EQU "v4" goto:LIST4

:v5cIOSs
set cIOS222[38]-v5=*
set cIOS224[57]-v5=*
set cIOS223[37]-v5=*
if /i "%LIST4%" EQU "v5" goto:LIST4

:v5.1cIOSs
set cIOS202[60]-v5.1R=*
set cIOS222[38]-v5.1R=*
set cIOS224[57]-v5.1R=*
set cIOS223[37]-v5.1R=*
if /i "%LIST4%" EQU "v5.1" goto:LIST4

:v17bcIOSs
set cIOS249-v17b=*
set cIOS250-v17b=*
if /i "%LIST4%" EQU "v17b" goto:LIST4

:v14cIOSs
set cIOS249-v14=*
set cIOS250-v14=*
if /i "%LIST4%" EQU "v14" goto:LIST4

:v19cIOSs
set cIOS249[37]-v19=*
set cIOS249[38]-v19=*
set cIOS249[57]-v19=*
set cIOS250[37]-v19=*
set cIOS250[38]-v19=*
set cIOS250[57]-v19=*
if /i "%LIST4%" EQU "v19" goto:LIST4

:v20cIOSs
set cIOS249[56]-v20=*
set cIOS250[57]-v20=*
set cIOS249[38]-v20=*
set cIOS250[38]-v20=*
set cIOS250[56]-v20=*
set cIOS249[57]-v20=*
if /i "%LIST4%" EQU "v20" goto:LIST4

:v21cIOSs
set cIOS249[37]-v21=*
set cIOS250[37]-v21=*
set cIOS249[38]-v21=*
set cIOS250[38]-v21=*
set cIOS249[53]-v21=*
set cIOS250[53]-v21=*
set cIOS249[55]-v21=*
set cIOS250[55]-v21=*
set cIOS249[56]-v21=*
set cIOS250[56]-v21=*
set cIOS249[57]-v21=*
set cIOS250[57]-v21=*
set cIOS249[58]-v21=*
set cIOS250[58]-v21=*
if /i "%LIST4%" EQU "v21" goto:LIST4

:d2xcIOSs
set cIOS249[37]-d2x-v8-final=*
set cIOS249[38]-d2x-v8-final=*
set cIOS249[53]-d2x-v8-final=*
set cIOS249[55]-d2x-v8-final=*
set cIOS249[56]-d2x-v8-final=*
set cIOS249[57]-d2x-v8-final=*
set cIOS249[58]-d2x-v8-final=*
set cIOS249[60]-d2x-v8-final=*
set cIOS249[70]-d2x-v8-final=*
set cIOS249[80]-d2x-v8-final=*
set cIOS250[37]-d2x-v8-final=*
set cIOS250[38]-d2x-v8-final=*
set cIOS250[53]-d2x-v8-final=*
set cIOS250[55]-d2x-v8-final=*
set cIOS250[56]-d2x-v8-final=*
set cIOS250[57]-d2x-v8-final=*
set cIOS250[58]-d2x-v8-final=*
set cIOS250[60]-d2x-v8-final=*
set cIOS250[70]-d2x-v8-final=*
set cIOS250[80]-d2x-v8-final=*
if /i "%LIST4%" EQU "d2x" goto:LIST4

:cMIOSs
set RVL-cMIOS-v65535(v10)_WiiGator_WiiPower_v0.2=*
set RVL-cmios-v4_WiiGator_GCBL_v0.2=*
set RVL-cmios-v4_Waninkoko_rev5=*
if /i "%DML%" NEQ "*" (set DML=*) & (set B4DMLRevSelect=list4) & (set AfterDMLRevSelect=list4) & (goto:CurrentDMLRevSelect)
if /i "%LIST4%" EQU "cM" goto:LIST4

goto:LIST4





::........................................Advanced Downloads........................................
:ADVANCED
cls
set loadorgo=load
if exist temp\DLnames.txt del temp\DLnames.txt>nul
if exist temp\DLgotos.txt del temp\DLgotos.txt>nul

set ADVPATCH=
set ADVSLOT=
set ADVVERSION=
set wadnameless=
::---
set name=
set wadname=
set dlname=
set ciosslot=
set ciosversion=
set md5=
set md5alt=
set basewad=none
set basewadb=none
set md5base=
set md5basealt=
set code1=
set code2=
set version=
set md5baseb=
set md5basebalt=
set code1b=
set code2b=
set path1=
set versionb=
set basecios=
set diffpath=
set code2new=
set lastbasemodule=
set category=
set wadnameless=
set patchname=
set slotname=
set slotcode=
set versionname=
set versioncode=
set DEC=
set VERFINAL=
set HEX=
set VER=
set wadfolder=
set verfinal=
set PATCHCODE=
set alreadyexists=
set patch=
set ADVTYPE=

Set ADVLIST=
cls
echo                                        ModMii                                v%currentversion%
support\sfk echo -spat \x20 \x20 \x20 \x20 \x20[Red]ADVANCED DOWNLOADS[def]\x20 \x20 \x20 \x20 \x20 \x20by XFlak
echo.
echo       D = Download Selected Files    1/2/3/4 = Page 1/2/3/4        M = Main Menu
echo       C = Clear Download Queue       (blank) = Cycle Pages        DR = Drive Menu
echo.
echo       Note: To return to this page from other Download Pages enter "ADV"
echo.
echo       U = User-Defined Custom Download            F = Forwarder DOL\ISO Builder
echo           (Get any IOS, MIOS or System Menu)
echo.
support\sfk echo -spat \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 [Red] IOSs \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 cIOSs
echo.


set d2x-beta-rev=8-final
if exist support\d2x-beta\d2x-beta.bat call support\d2x-beta\d2x-beta.bat



echo                 9 = IOS9v1034		 2224 = cIOS222[38]-v4
echo                12 = IOS12v526		 2234 = cIOS223[37-38]-v4
echo                13 = IOS13v1032		 2225 = cIOS222[38]-v5
echo                14 = IOS14v1032		 2235 = cIOS223[37]-v5
echo                15 = IOS15v1032		 2245 = cIOS224[57]-v5
echo                17 = IOS17v1032          20251 = cIOS202[60]-v5.1R
echo                21 = IOS21v1039          22251 = cIOS222[38]-v5.1R
echo                22 = IOS22v1294          22351 = cIOS223[37]-v5.1R
echo                28 = IOS28v1807          22451 = cIOS224[57]-v5.1R
echo                30 = IOS30v2576	        24914 = cIOS249-v14
echo                31 = IOS31v3608	        24917 = cIOS249-v17b
echo                33 = IOS33v3608        2491937 = cIOS249[37]-v19
echo                34 = IOS34v3608	      2491938 = cIOS249[38]-v19
echo                35 = IOS35v3608	      2491957 = cIOS249[57]-v19
echo                36 = IOS36v3608	      2492038 = cIOS249[38]-v20
echo                37 = IOS37v5663	      2492056 = cIOS249[56]-v20
echo                38 = IOS38v4124	      2492057 = cIOS249[57]-v20
echo                41 = IOS41v3607        2492137 = cIOS249[37]-v21
echo                43 = IOS43v3607        2492138 = cIOS249[38]-v21
echo                45 = IOS45v3607        2492153 = cIOS249[53]-v21
echo                46 = IOS46v3607        2492155 = cIOS249[55]-v21
echo                48 = IOS48v4124        2492156 = cIOS249[56]-v21
echo                53 = IOS53v5663        2492157 = cIOS249[57]-v21
echo                55 = IOS55v5663        2492158 = cIOS249[58]-v21
echo                56 = IOS56v5662          24937 = cIOS249[37]-d2x-v%d2x-beta-rev%
echo                57 = IOS57v5919          24938 = cIOS249[38]-d2x-v%d2x-beta-rev%
echo                58 = IOS58v6176          24953 = cIOS249[53]-d2x-v%d2x-beta-rev%
echo                60 = IOS60v6174          24955 = cIOS249[55]-d2x-v%d2x-beta-rev%
echo                61 = IOS61v5662          24956 = cIOS249[56]-d2x-v%d2x-beta-rev%
echo                62 = IOS62v6430          24957 = cIOS249[57]-d2x-v%d2x-beta-rev%
echo                70 = IOS70v6687          24958 = cIOS249[58]-d2x-v%d2x-beta-rev%
echo                80 = IOS80v6944          24960 = cIOS249[60]-d2x-v%d2x-beta-rev%
echo                                         24970 = cIOS249[70]-d2x-v%d2x-beta-rev%
echo                                         24980 = cIOS249[80]-d2x-v%d2x-beta-rev%
echo.
echo                                          BETA = d2x beta settings
echo.
echo      %AdvNumber% Advanced Downloads in Queue
echo.
set /p ADVLIST=     Enter Selection Here: 

if /i "%ADVLIST%" EQU "M" goto:MENU

if /i "%ADVLIST%" EQU "DR" set BACKB4DRIVE=ADVANCED
if /i "%ADVLIST%" EQU "DR" goto:DRIVECHANGE

if /i "%ADVLIST%" EQU "U" goto:Custom


if /i "%ADVLIST%" EQU "1" goto:LIST
if /i "%ADVLIST%" EQU "2" goto:OLDLIST
if /i "%ADVLIST%" EQU "3" goto:LIST3
if /i "%ADVLIST%" EQU "4" goto:LIST4
if /i "%ADVLIST%" EQU "ADV" goto:ADVANCED
if /i "%ADVLIST%" EQU "F" goto:FORWARDERDOLorISO
IF "%ADVLIST%"=="" goto:LIST


if not exist support\More-cIOSs goto:quickskip
if /i "%ADVLIST%" EQU "BETA" (set backbeforebetaswitch=ADVANCED) & (goto:betaswitch)
:quickskip


if /i "%ADVLIST%" EQU "D" set loadorgo=go
if /i "%ADVLIST%" EQU "D" set BACKB4QUEUE=ADVANCED
if /i "%ADVLIST%" EQU "D" goto:DOWNLOADQUEUE

if /i "%ADVLIST%" EQU "C" goto:CLEAR

set ADVTYPE=IOS
if /i "%ADVLIST%" EQU "9" goto:IOS9
if /i "%ADVLIST%" EQU "12" goto:IOS12
if /i "%ADVLIST%" EQU "13" goto:IOS13
if /i "%ADVLIST%" EQU "14" goto:IOS14
if /i "%ADVLIST%" EQU "15" goto:IOS15
if /i "%ADVLIST%" EQU "17" goto:IOS17
if /i "%ADVLIST%" EQU "21" goto:IOS21
if /i "%ADVLIST%" EQU "22" goto:IOS22
if /i "%ADVLIST%" EQU "28" goto:IOS28
if /i "%ADVLIST%" EQU "30" goto:IOS30
if /i "%ADVLIST%" EQU "31" goto:IOS31
if /i "%ADVLIST%" EQU "33" goto:IOS33
if /i "%ADVLIST%" EQU "34" goto:IOS34
if /i "%ADVLIST%" EQU "35" goto:IOS35
if /i "%ADVLIST%" EQU "36" goto:IOS36v3608
if /i "%ADVLIST%" EQU "37" goto:IOS37
if /i "%ADVLIST%" EQU "38" goto:IOS38
if /i "%ADVLIST%" EQU "41" goto:IOS41
if /i "%ADVLIST%" EQU "43" goto:IOS43
if /i "%ADVLIST%" EQU "45" goto:IOS45
if /i "%ADVLIST%" EQU "46" goto:IOS46
if /i "%ADVLIST%" EQU "48" goto:IOS48v4124
if /i "%ADVLIST%" EQU "53" goto:IOS53
if /i "%ADVLIST%" EQU "55" goto:IOS55
if /i "%ADVLIST%" EQU "56" goto:IOS56
if /i "%ADVLIST%" EQU "57" goto:IOS57
if /i "%ADVLIST%" EQU "58" goto:IOS58
if /i "%ADVLIST%" EQU "60" goto:IOS60
if /i "%ADVLIST%" EQU "61" goto:IOS61
if /i "%ADVLIST%" EQU "62" goto:IOS62
if /i "%ADVLIST%" EQU "70" goto:IOS70
if /i "%ADVLIST%" EQU "80" goto:IOS80

set ADVTYPE=CIOS
if /i "%ADVLIST%" EQU "2225" goto:cIOS222[38]-v5
if /i "%ADVLIST%" EQU "2235" goto:cIOS223[37]-v5
if /i "%ADVLIST%" EQU "2245" goto:cIOS224[57]-v5

if /i "%ADVLIST%" EQU "20251" goto:cIOS202[60]-v5.1R
if /i "%ADVLIST%" EQU "22251" goto:cIOS222[38]-v5.1R
if /i "%ADVLIST%" EQU "22351" goto:cIOS223[37]-v5.1R
if /i "%ADVLIST%" EQU "22451" goto:cIOS224[57]-v5.1R

if /i "%ADVLIST%" EQU "2491937" goto:cIOS249[37]-v19
if /i "%ADVLIST%" EQU "2491938" goto:cIOS249[38]-v19
if /i "%ADVLIST%" EQU "2492038" goto:cIOS249[38]-v20
if /i "%ADVLIST%" EQU "2492056" goto:cIOS249[56]-v20
if /i "%ADVLIST%" EQU "2492057" goto:cIOS249[57]-v20
if /i "%ADVLIST%" EQU "2491957" goto:cIOS249[57]-v19

if /i "%ADVLIST%" EQU "2224" goto:cIOS222[38]-v4
if /i "%ADVLIST%" EQU "2234" goto:cIOS223[37-38]-v4
if /i "%ADVLIST%" EQU "24917" goto:cIOS249-v17b
if /i "%ADVLIST%" EQU "24914" goto:cIOS249-v14
if /i "%ADVLIST%" EQU "2492137" goto:cIOS249[37]-v21
if /i "%ADVLIST%" EQU "2492138" goto:cIOS249[38]-v21
if /i "%ADVLIST%" EQU "2492156" goto:cIOS249[56]-v21
if /i "%ADVLIST%" EQU "2492153" goto:cIOS249[53]-v21
if /i "%ADVLIST%" EQU "2492155" goto:cIOS249[55]-v21
if /i "%ADVLIST%" EQU "2492157" goto:cIOS249[57]-v21
if /i "%ADVLIST%" EQU "2492158" goto:cIOS249[58]-v21
if /i "%ADVLIST%" EQU "24937" goto:cIOS249[37]-d2x-v8-final
if /i "%ADVLIST%" EQU "24938" goto:cIOS249[38]-d2x-v8-final
if /i "%ADVLIST%" EQU "24953" goto:cIOS249[53]-d2x-v8-final
if /i "%ADVLIST%" EQU "24955" goto:cIOS249[55]-d2x-v8-final
if /i "%ADVLIST%" EQU "24956" goto:cIOS249[56]-d2x-v8-final
if /i "%ADVLIST%" EQU "24957" goto:cIOS249[57]-d2x-v8-final
if /i "%ADVLIST%" EQU "24958" goto:cIOS249[58]-d2x-v8-final
if /i "%ADVLIST%" EQU "24960" goto:cIOS249[60]-d2x-v8-final
if /i "%ADVLIST%" EQU "24970" goto:cIOS249[70]-d2x-v8-final
if /i "%ADVLIST%" EQU "24980" goto:cIOS249[80]-d2x-v8-final

echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:ADVANCED

::------------------------
:betaswitch

if exist temp\list.txt del temp\list.txt>nul
if exist temp\list2.txt del temp\list2.txt>nul

echo Checking for new d2x beta's hosted online...

::get all list
start %ModMiimin%/wait support\wget --no-check-certificate -N "https://github.com/davebaol/d2x-cios/releases"

if exist releases (move /y releases temp\list.txt>nul) else (goto:nowifi)
::copy /y "temp\list.txt" "temp\list2.txt">nul

support\sfk filter -spat "temp\list.txt" ++"/davebaol/d2x-cios/releases/download/" ++".7z" -!"vwii" -!"uwii" -rep _*"download/"__ -rep _".7z*"__ -rep _"*files/"__ -rep _\x2528_\x28_ -rep _\x2529_\x29_ -rep _\x2520_\x20_ -rep _\x253B_\x3B_ -rep _\x252C_\x2C_ -write -yes>nul


:nowifi

::get local list
dir support\More-cIOSs /a:d /b>>temp\list.txt
support\sfk filter "temp\list.txt" -unique -write -yes>nul


:betaswitch2

::count # of folders in advance to set "mode"
setlocal ENABLEDELAYEDEXPANSION
SET d2xTOTAL=0
for /f "delims=" %%i in (temp\list.txt) do set /a d2xTOTAL=!d2xTOTAL!+1
setlocal DISABLEDELAYEDEXPANSION

SET /a LINES=%d2xTOTAL%+25
if %LINES% LEQ 54 goto:noresize
mode con cols=85 lines=%LINES%
:noresize


Set betacios=
cls
echo                                        ModMii                                v%currentversion%
echo                                       by XFlak
echo.
echo.
echo                    Select the beta d2x cIOS you would like to build:
echo.
echo.
echo            Warning: ModMii will report beta d2x cIOSs older than v8 beta 42
echo                     as "invalid" for bases 60, 70 and 80
echo.
echo.

if /i "%d2xTOTAL%" EQU "0" (echo                 No d2x-betas were found in the support\More-cIOSs Folder) & (goto:quickskip)
echo       N = None, build the d2x cIOSs that came with ModMii v%currentversion%
echo.

set MorecIOSsNum=0

::Loop through the the following once for EACH line in *.txt
for /F "tokens=*" %%A in (temp\list.txt) do call :processlist %%A
goto:quickskip
:processlist
set CurrentcIOS=%*
set /a MorecIOSsNum=%MorecIOSsNum%+1

::findStr /I /C:"%CurrentcIOS%" "temp\list2.txt" >nul
::IF ERRORLEVEL 1 (set d2xFeatured=) else (set d2xFeatured= - Featured)

if not exist "support\More-cIOSs\%CurrentcIOS%" echo       %MorecIOSsNum% = %CurrentcIOS% (Online)%d2xFeatured%
if exist "support\More-cIOSs\%CurrentcIOS%" echo       %MorecIOSsNum% = %CurrentcIOS% (Local)%d2xFeatured%

goto:EOF
:quickskip

echo.
echo     WWW = More Information Available at http://tinyurl.com/d2xcIOS

echo.
echo.
echo                B = Back
echo.
echo                M = Main Menu
echo.
echo.
set /p betacios=     Enter Selection Here: 

if /i "%betacios%" EQU "M" (mode con cols=85 lines=54) & (goto:MENU)
if /i "%betacios%" EQU "B" (mode con cols=85 lines=54) & (goto:%backbeforebetaswitch%)

if /i "%betacios%" EQU "WWW" (start http://gbatemp.net/t277659-ciosx-rev21d2x-v2-yet-another-hot-fix) & (goto:betaswitch)

if /i "%betacios%" NEQ "N" goto:notN
if exist support\d2x-beta rd /s /q support\d2x-beta
mode con cols=85 lines=54
goto:d2xfix
:notN

if "%betacios%"=="" goto:badkey
if /i "%d2xTOTAL%" EQU "0" goto:badkey
echo set betacios=%betacios% >temp\temp.bat
support\sfk filter -quiet temp\temp.bat -rep _.__ -lerep _" "__ -write -yes
call temp\temp.bat
del temp\temp.bat>nul

if %betacios% LSS 1 goto:badkey
if /i %betacios% GTR %MorecIOSsNum% goto:badkey



::----copy folders over----
set MorecIOSsNum2=0
::Loop through the the following once for EACH line in *.txt
for /F "tokens=*" %%A in (temp\list.txt) do call :processlist4 %%A
goto:quickskip
:processlist4
set CurrentcIOS=%*
::if not exist "support\More-cIOSs\%CurrentcIOS%\d2x-beta.bat" goto:EOF
set /a MorecIOSsNum2=%MorecIOSsNum2%+1
if /i "%MorecIOSsNum2%" EQU "%betacios%" goto:quickskip
goto:EOF
:quickskip


set DLcIOS=%CurrentcIOS%
set CurrentcIOS=%CurrentcIOS:*/=%

if exist "support\More-cIOSs\%CurrentcIOS%\d2x-beta.bat" goto:nodownload
if not exist "support\More-cIOSs\%CurrentcIOS%" mkdir "support\More-cIOSs\%CurrentcIOS%"

start %ModMiimin%/wait support\wget --output-document %CurrentcIOS%.zip --no-check-certificate -t 3 "https://github.com/davebaol/d2x-cios/releases/download/%DLcIOS%.7z"
if not exist "%CurrentcIOS%.zip" goto:badkey
support\7za e -aoa "%CurrentcIOS%.zip" -o"support\More-cIOSs\%CurrentcIOS%" *.* -r
del "%CurrentcIOS%.zip">nul
if not exist "support\More-cIOSs\%CurrentcIOS%\d2x-beta.bat" (rd /s /q "support\More-cIOSs\%CurrentcIOS%") & (goto:badkey)
:nodownload

if exist support\d2x-beta rd /s /q support\d2x-beta
mkdir support\d2x-beta
copy /y "support\More-cIOSs\%CurrentcIOS%\*" "support\d2x-beta">nul
del temp\list.txt>nul
mode con cols=85 lines=54
goto:d2xfix


:badkey
echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:betaswitch2


::--------------
:d2xfix
::d2x check for changed DL names and md5's for Advanced downloads only

if not exist temp\DLnamesADV.txt (mode con cols=85 lines=54) & (goto:%backbeforebetaswitch%)
findStr "d2x" temp\DLnamesADV.txt >nul
IF ERRORLEVEL 1 (mode con cols=85 lines=54) & (goto:%backbeforebetaswitch%)

FINDSTR /N . temp\DLnamesADV.txt>temp\DLnamesADVcheck.txt
support\sfk filter -quiet temp\DLnamesADVcheck.txt -+d2x -rep _cIOS*[_cIOS249[_ -rep _"Advanced Download: "__ -write -yes

set loadorgo=load4switch

::Loop through the the following once for EACH line in *.txt
for /F "tokens=*" %%A in (temp\DLnamesADVcheck.txt) do call :processDLCheckswitch %%A
goto:quickskip
:processDLCheckswitch

set advDLCheck=%*

echo set advDLcheckNUM=%advDLCheck%>temp\advDLcheckNUM.bat
support\sfk filter -quiet temp\advDLcheckNUM.bat -rep _:*__ -write -yes
call temp\advDLcheckNUM.bat
del temp\advDLcheckNUM.bat>nul

echo %advDLCheck%>temp\advDLcheck.bat
support\sfk filter -quiet temp\advDLcheck.bat -rep _"%advDLcheckNUM%:"_"set advDLcheck="_ -write -yes
call temp\advDLcheck.bat
del temp\advDLcheck.bat>nul


call temp\AdvDL%advDLcheckNUM%.bat
set oldfullname=%name%

set advDLCheck0=%advDLCheck%

set d2x-beta-rev=8-final
set advDLCheck=%advDLCheck:~0,17%%d2x-beta-rev%
if exist support\d2x-beta\d2x-beta.bat call support\d2x-beta\d2x-beta.bat

set string=%d2x-beta-rev%
set d2xVersionLength=0

:loopd2xVersionLength
if defined string (
    set string=%string:~1%
    set /A d2xVersionLength += 1
    goto:loopd2xVersionLength
    )

echo set alt-d2x-beta-rev=@advDLcheck0:~17,%d2xVersionLength%@>temp\d2x-beta-rev.bat
support\sfk filter temp\d2x-beta-rev.bat -spat -rep _@_%%_ -write -yes>nul
call temp\d2x-beta-rev.bat
del temp\d2x-beta-rev.bat>nul

if /i "%d2x-beta-rev%" EQU "%alt-d2x-beta-rev%" goto:EOF

goto:%advDLCheck%


:processDLCheck2switch

set slotnum=%slotcode:~7%
if "%slotnum%"=="" set slotnum=249
set newname=cIOS%slotnum%%basecios:~7,10%%d2x-beta-rev%

::update temp\AdvDL#.bat
support\sfk filter -quiet temp\AdvDL%advDLcheckNUM%.bat -rep _"set MD5="*_"set MD5=%MD5%"_ -rep _"set md5alt="*_"set md5alt=%md5alt%"_ -rep _"set ciosversion="*_"set ciosversion=%ciosversion%"_ -rep _"Advanced Download: "*_"Advanced Download: %newname%%versionname%"_ -rep _"set wadname="*_"set wadname=%wadname%"_ -rep _"set wadnameless="*_"set wadnameless=%newname%"_ -write -yes

::update temp\DLnamesADV.txt
support\sfk filter -quiet temp\DLnamesADV.txt -lerep _"%oldfullname%"_"Advanced Download: %newname%%versionname%"_ -write -yes
goto:EOF
:quickskip

if exist temp\DLnamesADVcheck.txt del temp\DLnamesADVcheck.txt>nul
::set loadorgo=go
mode con cols=85 lines=54
goto:%backbeforebetaswitch%
::---------------------


::------------------------------------ADVANCED page 2 - PATCH IOS--------------------------------
:ADVPAGE2
set loadorgo=go
set ADVPATCH=
set patchcode=
set patchname=
set ADVSLOT=
set SLOTCODE=
set SLOTNAME=

if /i "%ADVLIST%" EQU "U" goto:skip
set wadnameless=%wadname%
echo BLAH%wadname%>wadnametemp.bat
support\sfk filter wadnametemp.bat -rep _BLAH_"set wadnameless="_ -rep _-64-__ -rep _RVL-__ -rep _.wad__ -write -yes>nul
call wadnametemp.bat
del wadnametemp.bat>nul
if /i "%ADVTYPE%" EQU "CIOS" goto:ADVPAGE3
:skip

cls
echo                                        ModMii                                v%currentversion%
echo                                       by XFlak
echo.
echo.
echo      How would you like to patch %wadnameless%?
echo.
echo.
echo.
echo                A = All 4 available patches
echo                N = No Patches
echo.
echo              -FS = FakeSigning Patch
echo              -ES = ES Identify Patch
echo              -NP = Nand Permission Patch
echo              -VP = Version Patch
echo.
echo.
echo.
echo        Select multiple patches by separating them by a space.
echo.
echo.
echo        Examples of how to select multiple patches
echo        ------------------------------------------
echo               -FS -ES -NP
echo               -ES -FS
echo               -NP -VP
echo               -NP -FS -VP
echo               -FS -ES -NP -VP
echo                etc.
echo.
echo.
echo.
echo.
echo                B = Back
echo.
echo                M = Main Menu
echo.
echo.
echo.
set /p ADVPATCH=     Enter Selection Here: 

if "%ADVLIST%"=="" goto:badkey

if /i "%ADVPATCH%" EQU "M" goto:MENU

if /i "%ADVLIST%" EQU "U" goto:skip
if /i "%ADVPATCH%" EQU "B" goto:ADVANCED
:skip
if /i "%ADVPATCH%" EQU "B" goto:CUSTOMPAGE2

if /i "%ADVPATCH%" EQU "N" (set patchcode=) & (set patchname=) & (goto:ADVPAGE3)

if /i "%ADVPATCH%" EQU "A" set ADVPATCH=-FS -ES -NP -VP

::if lower case letters entered change to upper
if /i "%ADVPATCH%" EQU "-FS" set ADVPATCH=-FS
if /i "%ADVPATCH%" EQU "-ES" set ADVPATCH=-ES
if /i "%ADVPATCH%" EQU "-NP" set ADVPATCH=-NP
if /i "%ADVPATCH%" EQU "-VP" set ADVPATCH=-VP
if /i "%ADVPATCH%" EQU "-FS -ES" set ADVPATCH=-FS -ES
if /i "%ADVPATCH%" EQU "-ES -FS" set ADVPATCH=-ES -FS
if /i "%ADVPATCH%" EQU "-FS -NP" set ADVPATCH=-FS -NP
if /i "%ADVPATCH%" EQU "-NP -FS" set ADVPATCH=-NP -FS
if /i "%ADVPATCH%" EQU "-FS -VP" set ADVPATCH=-FS -VP
if /i "%ADVPATCH%" EQU "-VP -FS" set ADVPATCH=-VP -FS
if /i "%ADVPATCH%" EQU "-ES -NP" set ADVPATCH=-ES -NP
if /i "%ADVPATCH%" EQU "-NP -ES" set ADVPATCH=-NP -ES
if /i "%ADVPATCH%" EQU "-ES -VP" set ADVPATCH=-ES -VP
if /i "%ADVPATCH%" EQU "-VP -ES" set ADVPATCH=-VP -ES
if /i "%ADVPATCH%" EQU "-NP -VP" set ADVPATCH=-NP -VP
if /i "%ADVPATCH%" EQU "-VP -NP" set ADVPATCH=-VP -NP
if /i "%ADVPATCH%" EQU "-FS -ES -NP" set ADVPATCH=-FS -ES -NP
if /i "%ADVPATCH%" EQU "-FS -NP -ES" set ADVPATCH=-FS -NP -ES
if /i "%ADVPATCH%" EQU "-ES -FS -NP" set ADVPATCH=-ES -FS -NP
if /i "%ADVPATCH%" EQU "-ES -NP -FS" set ADVPATCH=-ES -NP -FS
if /i "%ADVPATCH%" EQU "-NP -FS -ES" set ADVPATCH=-NP -FS -ES
if /i "%ADVPATCH%" EQU "-NP -ES -FS" set ADVPATCH=-NP -ES -FS
if /i "%ADVPATCH%" EQU "-FS -ES -VP" set ADVPATCH=-FS -ES -VP
if /i "%ADVPATCH%" EQU "-FS -VP -ES" set ADVPATCH=-FS -VP -ES
if /i "%ADVPATCH%" EQU "-ES -FS -VP" set ADVPATCH=-ES -FS -VP
if /i "%ADVPATCH%" EQU "-ES -VP -FS" set ADVPATCH=-ES -VP -FS
if /i "%ADVPATCH%" EQU "-VP -FS -ES" set ADVPATCH=-VP -FS -ES
if /i "%ADVPATCH%" EQU "-VP -ES -FS" set ADVPATCH=-VP -ES -FS
if /i "%ADVPATCH%" EQU "-FS -NP -VP" set ADVPATCH=-FS -NP -VP
if /i "%ADVPATCH%" EQU "-FS -VP -NP" set ADVPATCH=-FS -VP -NP
if /i "%ADVPATCH%" EQU "-NP -FS -VP" set ADVPATCH=-NP -FS -VP
if /i "%ADVPATCH%" EQU "-NP -VP -FS" set ADVPATCH=-NP -VP -FS
if /i "%ADVPATCH%" EQU "-VP -NP -FS" set ADVPATCH=-VP -NP -FS
if /i "%ADVPATCH%" EQU "-VP -FS -NP" set ADVPATCH=-VP -FS -NP
if /i "%ADVPATCH%" EQU "-ES -NP -VP" set ADVPATCH=-ES -NP -VP
if /i "%ADVPATCH%" EQU "-ES -VP -NP" set ADVPATCH=-ES -VP -NP
if /i "%ADVPATCH%" EQU "-NP -ES -VP" set ADVPATCH=-NP -ES -VP
if /i "%ADVPATCH%" EQU "-NP -VP -ES" set ADVPATCH=-NP -VP -ES
if /i "%ADVPATCH%" EQU "-VP -ES -NP" set ADVPATCH=-VP -ES -NP
if /i "%ADVPATCH%" EQU "-VP -NP -ES" set ADVPATCH=-VP -NP -ES
if /i "%ADVPATCH%" EQU "-VP -FS -ES -NP" set ADVPATCH=-VP -FS -ES -NP
if /i "%ADVPATCH%" EQU "-VP -FS -NP -ES" set ADVPATCH=-VP -FS -NP -ES
if /i "%ADVPATCH%" EQU "-VP -ES -FS -NP" set ADVPATCH=-VP -ES -FS -NP
if /i "%ADVPATCH%" EQU "-VP -ES -NP -FS" set ADVPATCH=-VP -ES -NP -FS
if /i "%ADVPATCH%" EQU "-VP -NP -FS -ES" set ADVPATCH=-VP -NP -FS -ES
if /i "%ADVPATCH%" EQU "-VP -NP -ES -FS" set ADVPATCH=-VP -NP -ES -FS
if /i "%ADVPATCH%" EQU "-NP -FS -ES -VP" set ADVPATCH=-NP -FS -ES -VP
if /i "%ADVPATCH%" EQU "-NP -FS -VP -ES" set ADVPATCH=-NP -FS -VP -ES
if /i "%ADVPATCH%" EQU "-NP -ES -FS -VP" set ADVPATCH=-NP -ES -FS -VP
if /i "%ADVPATCH%" EQU "-NP -ES -VP -FS" set ADVPATCH=-NP -ES -VP -FS
if /i "%ADVPATCH%" EQU "-NP -VP -FS -ES" set ADVPATCH=-NP -VP -FS -ES
if /i "%ADVPATCH%" EQU "-NP -VP -ES -FS" set ADVPATCH=-NP -VP -ES -FS
if /i "%ADVPATCH%" EQU "-ES -FS -NP -VP" set ADVPATCH=-ES -FS -NP -VP
if /i "%ADVPATCH%" EQU "-ES -FS -VP -NP" set ADVPATCH=-ES -FS -VP -NP
if /i "%ADVPATCH%" EQU "-ES -NP -FS -VP" set ADVPATCH=-ES -NP -FS -VP
if /i "%ADVPATCH%" EQU "-ES -NP -VP -FS" set ADVPATCH=-ES -NP -VP -FS
if /i "%ADVPATCH%" EQU "-ES -VP -NP -FS" set ADVPATCH=-ES -VP -NP -FS
if /i "%ADVPATCH%" EQU "-ES -VP -FS -NP" set ADVPATCH=-ES -VP -FS -NP
if /i "%ADVPATCH%" EQU "-FS -ES -NP -VP" set ADVPATCH=-FS -ES -NP -VP
if /i "%ADVPATCH%" EQU "-FS -ES -VP -NP" set ADVPATCH=-FS -ES -VP -NP
if /i "%ADVPATCH%" EQU "-FS -NP -ES -VP" set ADVPATCH=-FS -NP -ES -VP
if /i "%ADVPATCH%" EQU "-FS -NP -VP -ES" set ADVPATCH=-FS -NP -VP -ES
if /i "%ADVPATCH%" EQU "-FS -VP -ES -NP" set ADVPATCH=-FS -VP -ES -NP
if /i "%ADVPATCH%" EQU "-FS -VP -NP -ES" set ADVPATCH=-FS -VP -NP -ES




::add leading space for patchcode
set patchcode= %ADVPATCH%
::remove leading dash and space for patchname
echo [%ADVPATCH:~1%]>temp\temp.txt
support\sfk filter -quiet temp\temp.txt -rep _" "__ -write -yes
set /p patchname= <temp\temp.txt
del temp\temp.txt>nul


if /i "%ADVPATCH%" EQU "-FS" goto:ADVPAGE3
if /i "%ADVPATCH%" EQU "-ES" goto:ADVPAGE3
if /i "%ADVPATCH%" EQU "-NP" goto:ADVPAGE3
if /i "%ADVPATCH%" EQU "-VP" goto:ADVPAGE3
if /i "%ADVPATCH%" EQU "-FS -ES" goto:ADVPAGE3
if /i "%ADVPATCH%" EQU "-ES -FS" goto:ADVPAGE3
if /i "%ADVPATCH%" EQU "-FS -NP" goto:ADVPAGE3
if /i "%ADVPATCH%" EQU "-NP -FS" goto:ADVPAGE3
if /i "%ADVPATCH%" EQU "-FS -VP" goto:ADVPAGE3
if /i "%ADVPATCH%" EQU "-VP -FS" goto:ADVPAGE3
if /i "%ADVPATCH%" EQU "-ES -NP" goto:ADVPAGE3
if /i "%ADVPATCH%" EQU "-NP -ES" goto:ADVPAGE3
if /i "%ADVPATCH%" EQU "-ES -VP" goto:ADVPAGE3
if /i "%ADVPATCH%" EQU "-VP -ES" goto:ADVPAGE3
if /i "%ADVPATCH%" EQU "-NP -VP" goto:ADVPAGE3
if /i "%ADVPATCH%" EQU "-VP -NP" goto:ADVPAGE3
if /i "%ADVPATCH%" EQU "-FS -ES -NP" goto:ADVPAGE3
if /i "%ADVPATCH%" EQU "-FS -NP -ES" goto:ADVPAGE3
if /i "%ADVPATCH%" EQU "-ES -FS -NP" goto:ADVPAGE3
if /i "%ADVPATCH%" EQU "-ES -NP -FS" goto:ADVPAGE3
if /i "%ADVPATCH%" EQU "-NP -FS -ES" goto:ADVPAGE3
if /i "%ADVPATCH%" EQU "-NP -ES -FS" goto:ADVPAGE3
if /i "%ADVPATCH%" EQU "-FS -ES -VP" goto:ADVPAGE3
if /i "%ADVPATCH%" EQU "-FS -VP -ES" goto:ADVPAGE3
if /i "%ADVPATCH%" EQU "-ES -FS -VP" goto:ADVPAGE3
if /i "%ADVPATCH%" EQU "-ES -VP -FS" goto:ADVPAGE3
if /i "%ADVPATCH%" EQU "-VP -FS -ES" goto:ADVPAGE3
if /i "%ADVPATCH%" EQU "-VP -ES -FS" goto:ADVPAGE3
if /i "%ADVPATCH%" EQU "-FS -NP -VP" goto:ADVPAGE3
if /i "%ADVPATCH%" EQU "-FS -VP -NP" goto:ADVPAGE3
if /i "%ADVPATCH%" EQU "-NP -FS -VP" goto:ADVPAGE3
if /i "%ADVPATCH%" EQU "-NP -VP -FS" goto:ADVPAGE3
if /i "%ADVPATCH%" EQU "-VP -NP -FS" goto:ADVPAGE3
if /i "%ADVPATCH%" EQU "-VP -FS -NP" goto:ADVPAGE3
if /i "%ADVPATCH%" EQU "-ES -NP -VP" goto:ADVPAGE3
if /i "%ADVPATCH%" EQU "-ES -VP -NP" goto:ADVPAGE3
if /i "%ADVPATCH%" EQU "-NP -ES -VP" goto:ADVPAGE3
if /i "%ADVPATCH%" EQU "-NP -VP -ES" goto:ADVPAGE3
if /i "%ADVPATCH%" EQU "-VP -ES -NP" goto:ADVPAGE3
if /i "%ADVPATCH%" EQU "-VP -NP -ES" goto:ADVPAGE3
if /i "%ADVPATCH%" EQU "-VP -FS -ES -NP" goto:ADVPAGE3
if /i "%ADVPATCH%" EQU "-VP -FS -NP -ES" goto:ADVPAGE3
if /i "%ADVPATCH%" EQU "-VP -ES -FS -NP" goto:ADVPAGE3
if /i "%ADVPATCH%" EQU "-VP -ES -NP -FS" goto:ADVPAGE3
if /i "%ADVPATCH%" EQU "-VP -NP -FS -ES" goto:ADVPAGE3
if /i "%ADVPATCH%" EQU "-VP -NP -ES -FS" goto:ADVPAGE3
if /i "%ADVPATCH%" EQU "-NP -FS -ES -VP" goto:ADVPAGE3
if /i "%ADVPATCH%" EQU "-NP -FS -VP -ES" goto:ADVPAGE3
if /i "%ADVPATCH%" EQU "-NP -ES -FS -VP" goto:ADVPAGE3
if /i "%ADVPATCH%" EQU "-NP -ES -VP -FS" goto:ADVPAGE3
if /i "%ADVPATCH%" EQU "-NP -VP -FS -ES" goto:ADVPAGE3
if /i "%ADVPATCH%" EQU "-NP -VP -ES -FS" goto:ADVPAGE3
if /i "%ADVPATCH%" EQU "-ES -FS -NP -VP" goto:ADVPAGE3
if /i "%ADVPATCH%" EQU "-ES -FS -VP -NP" goto:ADVPAGE3
if /i "%ADVPATCH%" EQU "-ES -NP -FS -VP" goto:ADVPAGE3
if /i "%ADVPATCH%" EQU "-ES -NP -VP -FS" goto:ADVPAGE3
if /i "%ADVPATCH%" EQU "-ES -VP -NP -FS" goto:ADVPAGE3
if /i "%ADVPATCH%" EQU "-ES -VP -FS -NP" goto:ADVPAGE3
if /i "%ADVPATCH%" EQU "-FS -ES -NP -VP" goto:ADVPAGE3
if /i "%ADVPATCH%" EQU "-FS -ES -VP -NP" goto:ADVPAGE3
if /i "%ADVPATCH%" EQU "-FS -NP -ES -VP" goto:ADVPAGE3
if /i "%ADVPATCH%" EQU "-FS -NP -VP -ES" goto:ADVPAGE3
if /i "%ADVPATCH%" EQU "-FS -VP -ES -NP" goto:ADVPAGE3
if /i "%ADVPATCH%" EQU "-FS -VP -NP -ES" goto:ADVPAGE3


:badkey
echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:ADVPAGE2


::------------------------------------ADVANCED page 3 - SLOT--------------------------------
:ADVPAGE3
set ADVSLOT=
set SLOTCODE=
set SLOTNAME=

cls
echo                                        ModMii                                v%currentversion%
echo                                       by XFlak
echo.
echo.
echo            To change the IOS slot # for %wadnameless%%patchname%
echo.
echo            Enter a new IOS slot # now
echo.
echo.
echo.
echo.
support\sfk echo -spat \x20 [Red] WARNING: Be careful what IOS slot # you choose, if it overwrites a crucial IOS 
support\sfk echo -spat \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 [Red] YOU MAY BRICK
echo.
echo.
echo.
echo              Note: Must be between 3 and 254
echo.
echo.
echo                N = No, leave slot unchanged
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo                B = Back
echo.
echo                M = Main Menu
echo.
echo.
echo.
set /p ADVSLOT=     Enter Selection Here: 


::"B" will actually take u to the menu only to clear the download_queue, then it will return to advanced page1

if /i "%ADVSLOT%" EQU "M" goto:MENU


if /i "%ADVTYPE%" EQU "CIOS" goto:BACKTOMENUFIRST
if /i "%ADVSLOT%" EQU "B" goto:ADVPAGE2
:BACKTOMENUFIRST
if /i "%ADVSLOT%" EQU "B" goto:ADVANCED


set SLOTCODE= -slot %ADVSLOT%
set SLOTNAME=-slot%ADVSLOT%


if /i "%ADVTYPE%" NEQ "CIOS" goto:notcIOS
if /i "%ADVSLOT%" EQU "N" (set ADVSLOT=%wadname:~4,3%) & (goto:ADVPAGE4)
:notcIOS

if /i "%ADVSLOT%" EQU "N" goto:ADVPAGE4

::limit user input to X# of digits
if not "%ADVSLOT:~3%"=="" (
::    echo. ERROR: Name cannot be more than 8 chars
    goto:badkey
)

::Reject negative numbers - and reject 1 and 2 (LSS is less than, GTR is greater than)
if %ADVSLOT% LSS 3 (goto:badkey)



if %ADVSLOT% LEQ 254 goto:ADVPAGE4




:badkey
echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:ADVPAGE3



::------------------------------------ADVANCED page 4 - Version--------------------------------
:ADVPAGE4
Set ADVVERSION=
set VERSIONNAME=
set VERSIONCODE=



set versionreal=%version%
if /i "%ADVLIST%" EQU "2224" set versionreal=4
if /i "%ADVLIST%" EQU "2234" set versionreal=4
if /i "%ADVLIST%" EQU "24914" set versionreal=14
if /i "%ADVLIST%" EQU "24917" set versionreal=17
if /i "%ADVLIST%" EQU "2491937" set versionreal=19
if /i "%ADVLIST%" EQU "2491938" set versionreal=19
if /i "%ADVLIST%" EQU "2491957" set versionreal=19
if /i "%ADVLIST%" EQU "2492056" set versionreal=20
if /i "%ADVLIST%" EQU "2492057" set versionreal=20
if /i "%ADVLIST%" EQU "2492038" set versionreal=20
if /i "%ADVLIST%" EQU "2225" set versionreal=65535
if /i "%ADVLIST%" EQU "2235" set versionreal=65535
if /i "%ADVLIST%" EQU "2245" set versionreal=65535
if /i "%ADVLIST%" EQU "20251" set versionreal=65535
if /i "%ADVLIST%" EQU "22251" set versionreal=65535
if /i "%ADVLIST%" EQU "22351" set versionreal=65535
if /i "%ADVLIST%" EQU "22451" set versionreal=65535

if /i "%ADVLIST%" EQU "2492137" set versionreal=21
if /i "%ADVLIST%" EQU "2492138" set versionreal=21
if /i "%ADVLIST%" EQU "2492153" set versionreal=21
if /i "%ADVLIST%" EQU "2492155" set versionreal=21
if /i "%ADVLIST%" EQU "2492156" set versionreal=21
if /i "%ADVLIST%" EQU "2492157" set versionreal=21
if /i "%ADVLIST%" EQU "2492158" set versionreal=21
if /i "%ADVLIST%" EQU "24937" set versionreal=%ciosversion%
if /i "%ADVLIST%" EQU "24938" set versionreal=%ciosversion%
if /i "%ADVLIST%" EQU "24953" set versionreal=%ciosversion%
if /i "%ADVLIST%" EQU "24955" set versionreal=%ciosversion%
if /i "%ADVLIST%" EQU "24956" set versionreal=%ciosversion%
if /i "%ADVLIST%" EQU "24957" set versionreal=%ciosversion%
if /i "%ADVLIST%" EQU "24958" set versionreal=%ciosversion%
if /i "%ADVLIST%" EQU "24960" set versionreal=%ciosversion%
if /i "%ADVLIST%" EQU "24970" set versionreal=%ciosversion%
if /i "%ADVLIST%" EQU "24980" set versionreal=%ciosversion%

if /i "%ADVTYPE%" NEQ "CIOS" goto:miniskip
if /i "%ADVSLOT%" EQU "%wadname:~4,3%" set SLOTCODE=
if /i "%ADVSLOT%" EQU "%wadname:~4,3%" set SLOTNAME=
::if /i "%ADVSLOT%" EQU "N" goto:miniskip
set wadnameless=cIOS%ADVSLOT%%wadname:~7%
set slotname=
:miniskip



set /a versionplus1=%versionreal%+1

cls
echo                                        ModMii                                v%currentversion%
echo                                       by XFlak
echo.
echo.
echo.
echo    Would you like to change the version # of %wadnameless%%patchname%%slotname%
echo.
echo.
echo                                Note: MAX is 65535
echo.
echo.
echo              MAX = MAX (65535)
echo.
echo                N = No, leave version unchanged (%versionreal%)
if /i "%VER%" EQU "*" goto:bypass
if /i "%versionreal%" NEQ "65535" echo.
if /i "%versionreal%" NEQ "65535" echo               V1 = Version + 1 (%versionplus1%)
:bypass
echo.
echo.
echo.
echo                B = Back
echo.
echo                M = Main Menu
echo.
echo.
echo.
set /p ADVVERSION=     Enter Selection Here: 



::"B" will actually take u to the menu only to clear the download_queue, then it will return to advanced page1



if /i "%ADVVERSION%" EQU "M" goto:MENU
if /i "%ADVVERSION%" EQU "B" goto:ADVPAGE3
if /i "%ADVVERSION%" EQU "MAX" set ADVVERSION=65535
if /i "%versionreal%" EQU "65535" goto:alreadymaxxed

if /i "%VER%" EQU "*" goto:alreadymaxxed
if /i "%ADVVERSION%" EQU "v1" set ADVVERSION=%versionplus1%
:alreadymaxxed

set versioncode= -v %ADVVERSION%
set versionname=-[v%ADVVERSION%]

if /i "%ADVLIST%" EQU "U" goto:skip
if /i "%ADVVERSION%" EQU "N" goto:ADVCONFIRM
:skip
if /i "%ADVVERSION%" EQU "N" goto:CONFIRM

::limit user input to X# of digits
if not "%ADVVERSION:~5%"=="" (
::    echo. ERROR: Name cannot be more than 8 chars
    goto:badkey
)

::Reject negative numbers (LSS is less than, GTR is greater than)
if %ADVVERSION% LSS 1 (goto:badkey)


if /i "%ADVLIST%" EQU "U" goto:skip
if %ADVVERSION% LEQ 65535 goto:ADVCONFIRM
:skip
if %ADVVERSION% LEQ 65535 goto:CONFIRM


:badkey
echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:ADVPAGE4






::------------------------------------ADVANCED page CONFIRM - Version--------------------------------
:ADVCONFIRM
set ADVCONFIRM=

if /i "%ADVVERSION%" EQU "N" set VERSIONNAME=
if /i "%ADVVERSION%" EQU "N" set VERSIONCODE=

set changes=
if /i "%wadname:~0,-4%" EQU "%wadnameless%%patchname%%slotname%%versionname%" set changes=none


cls
echo                                        ModMii                                v%currentversion%
echo                                       by XFlak
echo.
echo.
echo                               ADVANCED CUSTOM DOWNLOADS
echo.
echo.

if /i "%changes%" EQU "none" goto:nochanges
echo          Are these settings correct?
echo.
echo.
echo.
echo      Download %wadname% and Patch it accordingly
echo.


if /i "%ADVTYPE%" NEQ "CIOS" goto:miniskip
if /i "%ADVSLOT%" EQU "%wadname:~4,3%" goto:miniskip
support\sfk echo -spat \x20 \x20 \x20 \x20 \x20 \x20 \x20 cIOS[Red]%ADVSLOT%[def]%wadname:~7%[Red]%patchname%%slotname%%versionname%
goto:yeschanges
:miniskip

support\sfk echo -spat \x20 \x20 \x20 \x20 \x20 \x20 \x20 %wadnameless%[Red]%patchname%%slotname%%versionname%
goto:yeschanges

:nochanges
echo.
echo.
echo.
support\sfk echo -spat \x20 \x20 \x20 \x20 \x20 [Yellow] You have not selected any changes to be made to %wadnameless%
echo.
echo.
echo                        If you want to download %wadnameless%
echo                you can do so from the Batch/Additional Download Pages

:yeschanges
echo.
echo.
echo.
echo.

if /i "%changes%" NEQ "none" echo                Y = Yes, add Advanced Download to Queue
echo.
echo                N = No, go back to Advanced Custom Downloads Menu
echo.
echo.
echo.
echo                B = Back
echo.
echo                M = Main Menu
echo.
echo.
echo.
set /p ADVCONFIRM=     Enter Selection Here: 


::"B" will actually take u to the menu only to clear the download_queue, then it will return to advanced page1
if /i "%ADVCONFIRM%" EQU "B" goto:ADVPAGE4
if /i "%ADVCONFIRM%" EQU "M" goto:MENU
if /i "%ADVCONFIRM%" EQU "N" goto:ADVANCED

if /i "%changes%" EQU "none" goto:nochanges2


if /i "%ADVCONFIRM%" EQU "Y" set /a AdvNumber=%AdvNumber%+1
if /i "%ADVCONFIRM%" EQU "Y" goto:SaveADVdlSettings

:nochanges2

echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:ADVCONFIRM


:SaveADVdlSettings
echo "set name=Advanced Download: %wadnameless%%patchname%%slotname%%versionname%">temp\AdvDL%AdvNumber%.bat
echo "set wadname=%wadname%">>temp\AdvDL%AdvNumber%.bat
echo "set ciosslot=%ciosSLOT%">>temp\AdvDL%AdvNumber%.bat
echo "set ciosversion=%ciosVERSION%">>temp\AdvDL%AdvNumber%.bat
echo "set md5=%md5%">>temp\AdvDL%AdvNumber%.bat
echo "set md5alt=%md5alt%">>temp\AdvDL%AdvNumber%.bat
echo "set basewad=%basewad%">>temp\AdvDL%AdvNumber%.bat
echo "set md5base=%md5base%">>temp\AdvDL%AdvNumber%.bat
echo "set md5basealt=%md5basealt%">>temp\AdvDL%AdvNumber%.bat
echo "set code1=%code1%">>temp\AdvDL%AdvNumber%.bat
echo "set code2=%code2%">>temp\AdvDL%AdvNumber%.bat
echo "set version=%version%">>temp\AdvDL%AdvNumber%.bat
echo "set basewadb=%basewadb%">>temp\AdvDL%AdvNumber%.bat
echo "set md5baseb=%md5baseb%">>temp\AdvDL%AdvNumber%.bat
echo "set md5basebalt=%md5basebalt%">>temp\AdvDL%AdvNumber%.bat
echo "set code1b=%code1b%">>temp\AdvDL%AdvNumber%.bat
echo "set code2b=%code2b%">>temp\AdvDL%AdvNumber%.bat
echo "set versionb=%versionb%">>temp\AdvDL%AdvNumber%.bat
echo "set basecios=%basecios%">>temp\AdvDL%AdvNumber%.bat
echo "set diffpath=%diffpath%">>temp\AdvDL%AdvNumber%.bat
echo "set code2new=%code2new%">>temp\AdvDL%AdvNumber%.bat
echo "set lastbasemodule=%lastbasemodule%">>temp\AdvDL%AdvNumber%.bat
echo "set category=%category%">>temp\AdvDL%AdvNumber%.bat

echo "set wadnameless=%wadnameless%">>temp\AdvDL%AdvNumber%.bat
echo "set patchname=%patchname%">>temp\AdvDL%AdvNumber%.bat
echo "set slotname=%slotname%">>temp\AdvDL%AdvNumber%.bat
echo "set slotcode=%slotcode%">>temp\AdvDL%AdvNumber%.bat
echo "set versionname=%versionname%">>temp\AdvDL%AdvNumber%.bat
echo "set versioncode=%versioncode%">>temp\AdvDL%AdvNumber%.bat
echo "set cIOSFamilyName=%cIOSFamilyName%">>temp\AdvDL%AdvNumber%.bat
echo "set cIOSversionNum=%cIOSversionNum%">>temp\AdvDL%AdvNumber%.bat
echo "set PATCHCODE=%PATCHCODE%">>temp\AdvDL%AdvNumber%.bat

::echo "goto:downloadstart">>temp\AdvDL%AdvNumber%.bat

echo "Advanced Download: %wadnameless%%patchname%%slotname%%versionname%">>temp\DLnamesADV.txt
echo "temp\AdvDL%AdvNumber%.bat">>temp\DLgotosADV.txt

support\sfk filter -quiet "temp\AdvDL%AdvNumber%.bat" -rep _"""__ -write -yes
support\sfk filter -quiet "temp\DLnamesADV.txt" -rep _"""__ -write -yes
support\sfk filter -quiet "temp\DLgotosADV.txt" -rep _"""__ -write -yes


goto:ADVANCED

::...................................Custom- User-Defined Custom Download...............................
:CUSTOM

set DEC=none
set HEX=
set countIOS=0

set VERFINAL=
set patchname=
set slotname=
set versionname=
set HEX=
set VER=
set wadfolder=
set verfinal=
set PATCHCODE=
set slotcode=
set versioncode=

cls
echo                                        ModMii                                v%currentversion%
echo                                       by XFlak
echo.
echo.
echo          Enter the Number of the IOS you would like to download
::echo      either in Decimal (x,xx,xxx; ie. 9,60,249), or in Hex (xx; ie. F9=249)
echo          or enter "SM" or "MIOS" to download a System Menu or MIOS
echo.
echo.
echo.
support\sfk echo  -spat \x20 \x20 \x20 \x20 [Red] WARNING: Make sure the IOS number you input actually exists
echo.
echo.
echo.
echo.
echo               #  = Download the IOS number
echo.
echo              SM  = Download a System Menu
echo.
echo             MIOS = Download an MIOS
echo.
echo.
echo.
echo.
echo                B = Back
echo.
echo                M = Main Menu
echo.
echo.
echo.
echo.
set /p DEC=     Enter Selection Here: 

if /i "%DEC%" EQU "M" goto:MENU
if /i "%DEC%" EQU "B" goto:ADVANCED
if /i "%DEC%" EQU "MIOS" goto:CUSTOMPAGE2
if /i "%DEC%" EQU "SM" goto:CUSTOMPAGE2


::limit user input to X# of digits
if not "%DEC:~3%"=="" (
::    echo. ERROR: Name cannot be more than 8 chars
    goto:badkey
)

::Reject negative numbers (LSS is less than, GTR is greater than)
if %DEC% LSS 1 (goto:badkey)



if %DEC% LEQ 254 goto:CUSTOMPAGE2


:badkey
echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:CUSTOM



:CUSTOMPAGE2
set VER=
set ADVPATCH=
set patchcode=
set patchname=

cls
echo                                        ModMii                                v%currentversion%
echo                                       by XFlak
echo.
echo.
if /i "%DEC%" EQU "SM" echo      What Version of the System Menu would like to download? (ie. XXX)
if /i "%DEC%" EQU "SM" goto:NEXT1
if /i "%DEC%" EQU "MIOS" echo      What Version of MIOS would like to download? (ie. 4, 5, 8, 10)
if /i "%DEC%" EQU "MIOS" goto:NEXT1
echo      What Version of IOS %DEC% would like to download?
:NEXT1
echo.
echo.
echo.
support\sfk echo  -spat \x20 \x20 \x20 \x20 \x20 \x20 [Red] WARNINGS:[def] - Make sure the version you input actually exists
echo                        - Most recent version may be stubbed
echo.
echo.
echo.
echo.
if /i "%DEC%" NEQ "SM" echo                * = Download the most recent version
if /i "%DEC%" EQU "SM" echo                * = Download the most recent Korean System Menu
echo.
echo.
echo                B = Back
echo.
echo                M = Main Menu
echo.
echo.
echo.
echo.
set /p VER=     Enter Selection Here: 

if /i "%VER%" EQU "M" goto:MENU
if /i "%VER%" EQU "B" goto:CUSTOM

set version=%VER%
if /i "%VER%" EQU "*" goto:bypass


::limit user input to X# of digits
if not "%VER:~5%"=="" (
    goto:badkey
)


::Reject negative numbers (LSS is less than, GTR is greater than)
if %VER% LSS 1 (goto:badkey)



:bypass

if /i "%DEC%" EQU "SM" goto:nopatches
if /i "%DEC%" EQU "MIOS" goto:nopatches

::for IOSs Only
if /i "%VER%" NEQ "*" set wadnameless=IOS%DEC%-64-v%VER%
if /i "%VER%" EQU "*" set wadnameless=IOS%DEC%-64-vNEW
if /i "%VER%" EQU "*" goto:ADVPAGE2
if /i "%VER%" LSS 65536 goto:ADVPAGE2

:nopatches
if /i "%VER%" EQU "*" goto:CONFIRM
if /i "%VER%" LSS 65536 goto:CONFIRM

:badkey
echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:CUSTOMPAGE2




:CONFIRM
if /i "%ADVVERSION%" EQU "N" set VERSIONNAME=
if /i "%ADVVERSION%" EQU "N" set VERSIONCODE=


set VERFINAL=%VER%
if /i "%VER%" EQU "*" set VERFINAL=NEW



cls
echo                                        ModMii                                v%currentversion%
echo                                       by XFlak
echo.
echo.
echo.

if /i "%DEC%" EQU "SM" echo      Are you sure you want to try downloading System Menu v%VER%?
if /i "%DEC%" EQU "SM" goto:NEXT2
if /i "%DEC%" EQU "MIOS" echo      Are you sure you want to try downloading MIOS v%VER%?
if /i "%DEC%" EQU "MIOS" goto:NEXT2


echo          Are you sure you want to try downloading:
echo.
echo          IOS%DEC%v%VERFINAL%%patchname%%slotname%%versionname%




:NEXT2
echo.
echo.
echo.
support\sfk echo  -spat \x20 \x20 \x20 \x20 [Red] WARNING: this download will fail if the file does not exist.
echo.
echo.
echo.
echo.
echo                Y = Yes, add Advanced Download to Queue
echo.
echo                N = No, go back to Advanced Custom Downloads Menu
echo.
echo.
echo.
echo                B = Back
echo.
echo                M = Main Menu
echo.
echo.
echo.
set /p CONFIRM=     Enter Selection Here: 

if /i "%CONFIRM%" EQU "M" goto:MENU
if /i "%CONFIRM%" EQU "N" goto:ADVANCED

::if /i "%CONFIRM%" EQU "A" goto:CUSTOMDL
if /i "%CONFIRM%" EQU "Y" set /a AdvNumber=%AdvNumber%+1
if /i "%CONFIRM%" EQU "Y" goto:SaveADVdlSettings2


if /i "%DEC%" EQU "SM" goto:skip
if /i "%DEC%" EQU "MIOS" goto:skip
if /i "%CONFIRM%" EQU "B" goto:ADVPAGE4
:skip
if /i "%CONFIRM%" EQU "B" goto:CUSTOMPAGE2

echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:CONFIRM


:SaveADVdlSettings2
if /i "%DEC%" EQU "SM" (echo "set name=Advanced Download: System Menu v%VER%">temp\AdvDL%AdvNumber%.bat) & (echo "Advanced Download: System Menu v%VER%">>temp\DLnamesADV.txt) & (goto:miniskip)

if /i "%DEC%" EQU "MIOS" (echo "set name=Advanced Download: MIOS v%VER%">temp\AdvDL%AdvNumber%.bat) & (echo "Advanced Download: MIOS v%VER%">>temp\DLnamesADV.txt) & (goto:miniskip)

echo "set name=Advanced Download: IOS%DEC%v%VERFINAL%%patchname%%slotname%%versionname%">temp\AdvDL%AdvNumber%.bat

echo "Advanced Download: IOS%DEC%v%VERFINAL%%patchname%%slotname%%versionname%">>temp\DLnamesADV.txt

:miniskip

echo "set DEC=%DEC%">>temp\AdvDL%AdvNumber%.bat
echo "set VERFINAL=%VERFINAL%">>temp\AdvDL%AdvNumber%.bat
echo "set patchname=%patchname%">>temp\AdvDL%AdvNumber%.bat
echo "set slotname=%slotname%">>temp\AdvDL%AdvNumber%.bat
echo "set versionname=%versionname%">>temp\AdvDL%AdvNumber%.bat
echo "set HEX=%HEX%">>temp\AdvDL%AdvNumber%.bat
echo "set VER=%VER%">>temp\AdvDL%AdvNumber%.bat
echo "set wadfolder=%wadfolder%">>temp\AdvDL%AdvNumber%.bat
echo "set PATCHCODE=%PATCHCODE%">>temp\AdvDL%AdvNumber%.bat
echo "set slotcode=%slotcode%">>temp\AdvDL%AdvNumber%.bat
echo "set versioncode=%versioncode%">>temp\AdvDL%AdvNumber%.bat
echo "set category=userdefined">>temp\AdvDL%AdvNumber%.bat

::echo "Advanced Download: %wadnameless%%patchname%%slotname%%versionname%">>temp\DLnamesADV.txt

echo "temp\AdvDL%AdvNumber%.bat">>temp\DLgotosADV.txt

support\sfk filter -quiet "temp\AdvDL%AdvNumber%.bat" -rep _"""__ -write -yes
support\sfk filter -quiet "temp\DLnamesADV.txt" -rep _"""__ -write -yes
support\sfk filter -quiet "temp\DLgotosADV.txt" -rep _"""__ -write -yes
goto:Advanced




::------------------------------------ADVANCED - FORWARDER DOL or ISO--------------------------------
:FORWARDERDOLorISO
set FORWARDERDOLorISO=

cls
echo                                        ModMii                                v%currentversion%
echo                                       by XFlak
echo.
echo.
echo            What type of Forwarder would you like to build?
echo.
echo.
echo.
echo.
echo                1 = DOL
echo.
echo                2 = ISO
echo.
echo                3 = Both
echo.
echo.
echo            Note: Forwarder ISOs require a cIOS with base 38 in order to work.
echo                  If using a d2x cIOS, make sure IOS reload is set to "off".
echo.
echo            Warning: Even when using the recommended settings, not everyone has
echo                     had success with custom Forwarder ISOs, results may vary.
echo.
echo.
echo                B = Back
echo.
echo                M = Main Menu
echo.
echo.
echo.
set /p FORWARDERDOLorISO=     Enter Selection Here: 

if /i "%FORWARDERDOLorISO%" EQU "M" goto:MENU
if /i "%FORWARDERDOLorISO%" EQU "B" goto:ADVANCED
if /i "%FORWARDERDOLorISO%" EQU "1" goto:FORWARDERDOLBUILDER
if /i "%FORWARDERDOLorISO%" EQU "2" goto:FORWARDERDOLBUILDER
if /i "%FORWARDERDOLorISO%" EQU "3" goto:FORWARDERDOLBUILDER

:badkey
echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:FORWARDERDOLorISO



::------------------------------------ADVANCED - FORWARDER DOL BUILDER--------------------------------
:FORWARDERDOLBUILDER
set FORWARDERTYPE=
set URLPATH=
set path-0=
set path-1=
set path-2=
set path-3=
set path-4=
set path-5=
set path-6=
set path-7=
set path-8=
set path-9=
set path-10=
set NumberOfPaths=1
set bigt=1
set FORWARDERTITLEID=
set DISCID=

cls
echo                                        ModMii                                v%currentversion%
echo                                       by XFlak
echo.
echo.
echo            What type of Forwarder would you like to build?
echo.
echo.
echo.
echo.
echo                1 = SD\USB Forwarder (v12)
echo.
echo                2 = URL Forwarder (Requires Internet Channel)
echo.
echo                3 = Channel Forwarder
echo.
echo.
echo.
echo.
echo.
echo                B = Back
echo.
echo                M = Main Menu
echo.
echo.
echo.
set /p FORWARDERTYPE=     Enter Selection Here: 

if /i "%FORWARDERTYPE%" EQU "M" goto:MENU
if /i "%FORWARDERTYPE%" EQU "B" goto:FORWARDERDOLorISO
if /i "%FORWARDERTYPE%" EQU "1" goto:v10FORWARDERDOL
if /i "%FORWARDERTYPE%" EQU "2" goto:INTERNETFORWARDERDOL
if /i "%FORWARDERTYPE%" EQU "3" goto:CHANNELFORWARDERDOL

:badkey
echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:FORWARDERDOLBUILDER



::------------------------------------ADVANCED - FORWARDER DOL BUILDER--------------------------------
:v10FORWARDERDOL
set path-0=


cls
echo                                        ModMii                                v%currentversion%
echo                                       by XFlak
echo.
echo.
if "%path-10%"=="" echo            Input forwarder path #%NumberOfPaths%:
if not "%path-10%"=="" (support\sfk echo -spat \x20 \x20 \x20 \x20 \x20 [Red] Maximum Number of paths have been reached) & (goto:maxreached)
echo.
echo.
echo            Note: Cannot contain : * ? " < > | & %%
echo.
echo            Examples:
echo                     apps/usbloader_cfg/boot.dol
echo                     apps/HackMii_Installer/boot.elf
echo                     boot.elf
echo.
echo            Note: Maximum path length is 255 characters
:maxreached
echo.
if not "%path-1%"=="" echo     Path #1: %path-1%
if not "%path-2%"=="" echo     Path #2: %path-2%
if not "%path-3%"=="" echo     Path #3: %path-3%
if not "%path-4%"=="" echo     Path #4: %path-4%
if not "%path-5%"=="" echo     Path #5: %path-5%
if not "%path-6%"=="" echo     Path #6: %path-6%
if not "%path-7%"=="" echo     Path #7: %path-7%
if not "%path-8%"=="" echo     Path #8: %path-8%
if not "%path-9%"=="" echo     Path #9: %path-9%
if not "%path-10%"=="" echo     Path #10: %path-10%
echo.
echo.
if "%path-1%"=="" (echo.) else (echo                A = Add forwarder with the above paths to download queue)
echo.
echo.
echo                B = Back
echo.
echo                M = Main Menu
echo.
echo.
echo.
set /p path-0=     Enter Selection Here: 

if "%path-0%"=="" goto:badkey

if /i "%path-0%" EQU "M" goto:MENU

if /i "%path-0%" NEQ "B" goto:notback
if /i "%NumberOfPaths%" EQU "1" goto:FORWARDERDOLBUILDER
if /i "%NumberOfPaths%" EQU "2" set path-1=
if /i "%NumberOfPaths%" EQU "3" set path-2=
if /i "%NumberOfPaths%" EQU "4" set path-3=
if /i "%NumberOfPaths%" EQU "5" set path-4=
if /i "%NumberOfPaths%" EQU "6" set path-5=
if /i "%NumberOfPaths%" EQU "7" set path-6=
if /i "%NumberOfPaths%" EQU "8" set path-7=
if /i "%NumberOfPaths%" EQU "9" set path-8=
if /i "%NumberOfPaths%" EQU "10" set path-9=
if /i "%NumberOfPaths%" EQU "11" set path-10=
set /a NumberOfPaths=%NumberOfPaths%-1
goto:v10FORWARDERDOL
:notback

if "%path-1%"=="" goto:none
if /i "%path-0%" EQU "A" set beforeAddforwardertoQueue=v10FORWARDERDOL
if /i "%path-0%" EQU "A" goto:FORWARDERNAME
:none

if /i "%NumberOfPaths%" EQU "11" goto:badkey

::make sure last 4 chars are .dol or .elf
if /i "%path-0:~-4%" EQU ".dol" goto:good
if /i "%path-0:~-4%" EQU ".elf" goto:good
goto:badkey
:good

::make sure path doesn't start with a \ or /
:doublecheckF
if /i "%path-0:~0,1%" EQU "\" (set path-0=%path-0:~1%) & (goto:doublecheckF)
if /i "%path-0:~0,1%" EQU "/" (set path-0=%path-0:~1%) & (goto:doublecheckF)

::limit user input to X# of digits
if not "%path-0:~255%"=="" (goto:badkey)

::replace : * ? " < > |
support\sfk filter -quiet -spat temp\temp.bat -rep _\x3a__ -rep _\x2a__ -rep _\x3f__ -rep _\x3c__ -rep _\x3e__ -rep _\x7c__ -rep _\x22__ -write -yes

::replace all \ with / and set path-# = path-0 (must end with .dol or .elf, so will not end with #)
echo set path-%NumberOfPaths%=%path-0%>temp\temp.bat
support\sfk filter temp\temp.bat -rep _\_/_ -write -yes>nul
call temp\temp.bat
del temp\temp.bat>nul

set /a NumberOfPaths=%NumberOfPaths%+1
goto:v10FORWARDERDOL

:badkey
echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:v10FORWARDERDOL




::------------------------------------ADVANCED - FORWARDER NAME--------------------------------
:FORWARDERNAME
set FORWARDERNAME=

cls
echo                                        ModMii                                v%currentversion%
echo                                       by XFlak
echo.
echo.

if /i "%FORWARDERTYPE%" NEQ "1" goto:skip
echo            Please enter a name for your forwarder with the following paths
echo.
if not "%path-1%"=="" echo     Path #1: %path-1%
if not "%path-2%"=="" echo     Path #2: %path-2%
if not "%path-3%"=="" echo     Path #3: %path-3%
if not "%path-4%"=="" echo     Path #4: %path-4%
if not "%path-5%"=="" echo     Path #5: %path-5%
if not "%path-6%"=="" echo     Path #6: %path-6%
if not "%path-7%"=="" echo     Path #7: %path-7%
if not "%path-8%"=="" echo     Path #8: %path-8%
if not "%path-9%"=="" echo     Path #9: %path-9%
if not "%path-10%"=="" echo     Path #10: %path-10%
:skip

if /i "%FORWARDERTYPE%" NEQ "2" goto:skip
echo            Please enter a name for your forwarder for the following URL
echo.
echo            %URLpath%
:skip

if /i "%FORWARDERTYPE%" NEQ "3" goto:skip
echo        Please enter a name for your forwarder for the following channel Title ID:
echo.
echo        %FORWARDERTITLEID%
:skip

echo.
echo.
echo            Note: Cannot contain \ / : * ? " < > | & %%
echo.
if /i "%FORWARDERTYPE%" EQU "2" (echo            Example: Wiibrew) else (echo            Example: usbloader)
echo.
echo.



echo.
echo.
echo.
echo                B = Back
echo.
echo                M = Main Menu
echo.
echo.
echo.
set /p FORWARDERNAME=     Enter Selection Here: 

if "%FORWARDERNAME%"=="" goto:badkey

echo "set FORWARDERNAME=%FORWARDERNAME%">temp\temp.bat

support\sfk filter -quiet -spat temp\temp.bat -rep _\x5c__ -rep _\x2f__ -rep _\x3a__ -rep _\x2a__ -rep _\x3f__ -rep _\x3c__ -rep _\x3e__ -rep _\x7c__ -rep _\x22__ -write -yes

if /i "%FORWARDERNAME%" EQU "M" goto:MENU
if /i "%FORWARDERNAME%" EQU "B" goto:%beforeAddforwardertoQueue%

call temp\temp.bat
del temp\temp.bat>nul


if /i "%FORWARDERDOLorISO%" NEQ "1" goto:DISCID

goto:SaveADVdlSettingsFORWARDER

:badkey
echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:FORWARDERNAME


:SaveADVdlSettingsFORWARDER

set /a AdvNumber=%AdvNumber%+1

if /i "%FORWARDERDOLorISO%" EQU "1" echo "set name=Advanced Download: Forwarder - %FORWARDERNAME% DOL">temp\AdvDL%AdvNumber%.bat
if /i "%FORWARDERDOLorISO%" EQU "2" echo "set name=Advanced Download: Forwarder - %FORWARDERNAME% ISO">temp\AdvDL%AdvNumber%.bat
if /i "%FORWARDERDOLorISO%" EQU "3" echo "set name=Advanced Download: Forwarder - %FORWARDERNAME% DOL and ISO">temp\AdvDL%AdvNumber%.bat

echo "set wadname=%FORWARDERNAME%">>temp\AdvDL%AdvNumber%.bat
echo "set FORWARDERNAME=%FORWARDERNAME%">>temp\AdvDL%AdvNumber%.bat
echo "set path-1=%path-1%">>temp\AdvDL%AdvNumber%.bat
echo "set path-2=%path-2%">>temp\AdvDL%AdvNumber%.bat
echo "set path-3=%path-3%">>temp\AdvDL%AdvNumber%.bat
echo "set path-4=%path-4%">>temp\AdvDL%AdvNumber%.bat
echo "set path-5=%path-5%">>temp\AdvDL%AdvNumber%.bat
echo "set path-6=%path-6%">>temp\AdvDL%AdvNumber%.bat
echo "set path-7=%path-7%">>temp\AdvDL%AdvNumber%.bat
echo "set path-8=%path-8%">>temp\AdvDL%AdvNumber%.bat
echo "set path-9=%path-9%">>temp\AdvDL%AdvNumber%.bat
echo "set path-10=%path-10%">>temp\AdvDL%AdvNumber%.bat
echo "set URLPATH=%URLPATH%">>temp\AdvDL%AdvNumber%.bat
echo "set FORWARDERTITLEID=%FORWARDERTITLEID%">>temp\AdvDL%AdvNumber%.bat
echo "set bigt=%bigt%">>temp\AdvDL%AdvNumber%.bat
echo "set category=FORWARDER">>temp\AdvDL%AdvNumber%.bat
echo "set FORWARDERTYPE=%FORWARDERTYPE%">>temp\AdvDL%AdvNumber%.bat
echo "set FORWARDERDOLorISO=%FORWARDERDOLorISO%">>temp\AdvDL%AdvNumber%.bat
echo "set DISCID=%DISCID%">>temp\AdvDL%AdvNumber%.bat

if /i "%FORWARDERDOLorISO%" EQU "1" echo "Advanced Download: Forwarder - %FORWARDERNAME% DOL">>temp\DLnamesADV.txt
if /i "%FORWARDERDOLorISO%" EQU "2" echo "Advanced Download: Forwarder - %FORWARDERNAME% ISO">>temp\DLnamesADV.txt
if /i "%FORWARDERDOLorISO%" EQU "3" echo "Advanced Download: Forwarder - %FORWARDERNAME% DOL and ISO">>temp\DLnamesADV.txt

echo "temp\AdvDL%AdvNumber%.bat">>temp\DLgotosADV.txt

support\sfk filter -quiet "temp\AdvDL%AdvNumber%.bat" -rep _"""__ -write -yes
support\sfk filter -quiet "temp\DLnamesADV.txt" -rep _"""__ -write -yes
support\sfk filter -quiet "temp\DLgotosADV.txt" -rep _"""__ -write -yes

goto:Advanced



::------------------------------------ADVANCED - FORWARDER DOL BUILDER--------------------------------
:INTERNETFORWARDERDOL
set URLpath=


cls
echo                                        ModMii                                v%currentversion%
echo                                       by XFlak
echo.
echo.
echo            Input website URL
echo.
echo.
echo            Example: www.wiibrew.org
echo.
support\sfk echo -spat \x20 \x20 \x20 \x20\x20\x20\x20 Note: * URL Cannot contain \x25, \x26, or \x22
echo                  * Maximum URL length is 95 characters
echo.
echo.
echo.
echo                B = Back
echo.
echo                M = Main Menu
echo.
echo.
echo.
set /p URLpath=     Enter Selection Here: 

if /i "%URLpath%" EQU "M" goto:MENU
if /i "%URLpath%" EQU "B" goto:FORWARDERDOLBUILDER
if "%URLpath%"=="" goto:badkey

::limit user input to X# of digits
if not "%URLpath:~95%"=="" (goto:badkey)



::replace all \ with /
echo set URLPATH=%URLpath% >temp\temp.bat
support\sfk filter -quiet temp\temp.bat -rep _\_/_ -write -yes
call temp\temp.bat
set URLPATH=%URLPATH:~0,-1%

set beforeAddforwardertoQueue=INTERNETFORWARDERDOL
goto:FORWARDERNAME

:badkey
echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:INTERNETFORWARDERDOL



::------------------------------------ADVANCED - CHANNEL FORWARDER DOL BUILDER--------------------------------
:CHANNELFORWARDERDOL
set FORWARDERTITLEID=


cls
echo                                        ModMii                                v%currentversion%
echo                                       by XFlak
echo.
echo.
echo            Enter the 4 character title ID for the channel that you want to load
echo            Or enter the hex value of the channel, seperating each byte with a comma
echo.
echo            Examples:
echo                     IDCL
echo                     49,44,43,4c
echo.
echo.
echo            Channel Type: %bigt%
echo.
echo            Or enter "1", "2", "4" or "8" to change channel type
echo.
echo            Note: The following title IDs will be forced as channel type 2
echo                  HAAA HABA HACA HAFA HAFE HAFJ HAFP HAGA HAGE HAGJ HAGP HAYA
echo.
echo.
echo                B = Back
echo.
echo                M = Main Menu
echo.
echo.
echo.
set /p FORWARDERTITLEID=     Enter Selection Here: 

if /i "%FORWARDERTITLEID%" EQU "M" goto:MENU
if /i "%FORWARDERTITLEID%" EQU "B" goto:FORWARDERDOLBUILDER
if "%FORWARDERTITLEID%"=="" goto:badkey

if /i "%FORWARDERTITLEID%" EQU "1" (set bigt=1) & (goto:CHANNELFORWARDERDOL)
if /i "%FORWARDERTITLEID%" EQU "2" (set bigt=2) & (goto:CHANNELFORWARDERDOL)
if /i "%FORWARDERTITLEID%" EQU "4" (set bigt=4) & (goto:CHANNELFORWARDERDOL)
if /i "%FORWARDERTITLEID%" EQU "8" (set bigt=8) & (goto:CHANNELFORWARDERDOL)

::minimum number of chars = x+1 (ie. ~5 sets minimum of 6)
if "%FORWARDERTITLEID:~3%"=="" (goto:badkey)

::limit user input to X# of digits
if not "%FORWARDERTITLEID:~11%"=="" (goto:badkey)

::if more than 4 chars then check if hex
if "%FORWARDERTITLEID:~4%"=="" goto:nocheckhex
if /i "%FORWARDERTITLEID:~2,1%" NEQ "," goto:badkey
if /i "%FORWARDERTITLEID:~5,1%" NEQ "," goto:badkey
if /i "%FORWARDERTITLEID:~8,1%" NEQ "," goto:badkey
:nocheckhex

set beforeAddforwardertoQueue=CHANNELFORWARDERDOL
goto:FORWARDERNAME

:badkey
echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:CHANNELFORWARDERDOL


::------------------------------------ADVANCED - Forwarder ISO Name--------------------------------
:DISCID
set DISCID=


cls
echo                                        ModMii                                v%currentversion%
echo                                       by XFlak
echo.
echo.
echo            Enter the 6 character ID that you want to the ISO to use.
echo.
echo.
echo            Note: Should only contain numbers and\or letters.
echo                  For best results use this format: D**A00
echo.
echo.
echo                B = Back
echo.
echo                M = Main Menu
echo.
echo.
echo.
set /p DISCID=     Enter Selection Here: 

if /i "%DISCID%" EQU "M" goto:MENU
if /i "%DISCID%" EQU "B" goto:FORWARDERNAME

::minimum number of chars = x+1 (ie. ~5 sets minimum of 6)
if "%DISCID:~5%"=="" (goto:badkey)

::limit user input to X# of digits
if not "%DISCID:~6%"=="" (goto:badkey)

goto:SaveADVdlSettingsFORWARDER

:badkey
echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:DISCID

::...................................CONFIG File Menu...............................
:CONFIGFILEMENU
set configfile=

cls
echo                                        ModMii                                v%currentversion%
echo                                       by XFlak
echo.
echo.
echo.
echo          Which Wii App would you like to configure?
echo.
echo.
echo.
echo          BM = BootMii (create bootmii.ini)
echo.
echo         MMM = Multi-Mod Manager (create mmmconfig.txt)
echo.
echo          WM = Wad Manager (create wm_config.txt)
echo.
echo.
echo.
echo.
echo           B = Back
echo.
echo           M = Main Menu
echo.
echo.
echo.
echo.
set /p configfile=     Enter Selection Here: 

if /i "%configfile%" EQU "M" goto:MENU
if /i "%configfile%" EQU "B" goto:MENU

if /i "%configfile%" EQU "BM" goto:BMCONFIG
if /i "%configfile%" EQU "WM" goto:WMCONFIG
if /i "%configfile%" EQU "MMM" goto:MMMCONFIG


echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:CONFIGFILEMENU




::...................................BootMii CONFIGURATOR (bootmii.ini)...............................
:BMCONFIG
set BMVIDEO=
cls
echo                                        ModMii                                v%currentversion%
echo                                       by XFlak
echo.
echo.
echo.
echo                 This will create a bootmii.ini file in %DRIVE%\bootmii\
echo                        to determine how BootMii is launched.
echo.
echo.
echo.
echo.
echo      Enter the Video Mode you would like BootMii to use:
echo.
echo.
echo.
echo                 N = NTSC
echo                50 = PAL50
echo                60 = PAL60
echo                 P = Progressive
echo.
echo.
echo.
echo.
echo                 B = Back
echo.
echo                 M = Main Menu
echo.
echo.
echo.
echo.
set /p BMVIDEO=     Enter Selection Here: 

if /i "%BMVIDEO%" EQU "M" goto:MENU
if /i "%BMVIDEO%" EQU "B" goto:CONFIGFILEMENU
if /i "%BMVIDEO%" EQU "N" set BMVIDEO=NTSC
if /i "%BMVIDEO%" EQU "50" set BMVIDEO=PAL50
if /i "%BMVIDEO%" EQU "60" set BMVIDEO=PAL60
if /i "%BMVIDEO%" EQU "P" set BMVIDEO=PROGRESSIVE
if /i "%BMVIDEO%" EQU "NTSC" goto:BMCONFIG2
if /i "%BMVIDEO%" EQU "PAL50" goto:BMCONFIG2
if /i "%BMVIDEO%" EQU "PAL60" goto:BMCONFIG2
if /i "%BMVIDEO%" EQU "PROGRESSIVE" goto:BMCONFIG2

echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:BMCONFIG







::...................................BootMii CONFIGURATOR (bootmii.ini)...............................
:BMCONFIG2
set BMBOOT=
cls
echo                                        ModMii                                v%currentversion%
echo                                       by XFlak
echo.
echo.
echo.
echo      What would you like BootMii to AutoBoot?
echo.
echo.
echo.
echo                 O = OFF     (BootMii)
echo                 H = HBC     (Homebrew Channel)
echo                 S = SYSMENU (System Menu)
echo.
echo.
echo.
echo.
echo                 B = Back
echo.
echo                 M = Main Menu
echo.
echo.
echo.
echo.
set /p BMBOOT=     Enter Selection Here: 

if /i "%BMBOOT%" EQU "M" goto:MENU
if /i "%BMBOOT%" EQU "B" goto:BMCONFIG

if /i "%BMBOOT%" EQU "O" set BMBOOT=OFF
if /i "%BMBOOT%" EQU "H" set BMBOOT=HBC
if /i "%BMBOOT%" EQU "S" set BMBOOT=SYSMENU

if /i "%BMBOOT%" EQU "OFF" set BMDELAY=0
if /i "%BMBOOT%" EQU "OFF" goto:BMCONFIG4
if /i "%BMBOOT%" EQU "HBC" goto:BMCONFIG3
if /i "%BMBOOT%" EQU "SYSMENU" goto:BMCONFIG3

echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:BMCONFIG2



::...................................BootMii CONFIGURATOR (bootmii.ini)...............................
:BMCONFIG3
set BMDELAY=
cls
echo                                        ModMii                                v%currentversion%
echo                                       by XFlak
echo.
echo.
echo.
if /i "%BMBOOT%" EQU "HBC" echo      How many seconds should BootMii to wait to autoboot the HomeBrew Channel?
if /i "%BMBOOT%" EQU "SYSMENU" echo      How many seconds should BootMii to wait to autoboot the System Menu?
echo.
echo.
echo.
echo.
echo          Possible Settings:
echo.
echo                 0,1,2,3,4,5,6,7,8,9,10
echo.
echo.
echo.
echo.
echo                 B = Back
echo.
echo                 M = Main Menu
echo.
echo.
echo.
echo.
set /p BMDELAY=     Enter Selection Here: 

if /i "%BMDELAY%" EQU "M" goto:MENU
if /i "%BMDELAY%" EQU "B" goto:BMCONFIG2


if /i "%BMDELAY%" EQU "0" goto:BMCONFIG4
if /i "%BMDELAY%" EQU "1" goto:BMCONFIG4
if /i "%BMDELAY%" EQU "2" goto:BMCONFIG4
if /i "%BMDELAY%" EQU "3" goto:BMCONFIG4
if /i "%BMDELAY%" EQU "4" goto:BMCONFIG4
if /i "%BMDELAY%" EQU "5" goto:BMCONFIG4
if /i "%BMDELAY%" EQU "6" goto:BMCONFIG4
if /i "%BMDELAY%" EQU "7" goto:BMCONFIG4
if /i "%BMDELAY%" EQU "8" goto:BMCONFIG4
if /i "%BMDELAY%" EQU "9" goto:BMCONFIG4
if /i "%BMDELAY%" EQU "10" goto:BMCONFIG4

echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:BMCONFIG3





::...................................BootMii CONFIGURATOR (bootmii.ini)...............................
:BMCONFIG4
set BMSD=
cls
echo                                        ModMii                                v%currentversion%
echo                                       by XFlak
echo.
echo.
echo.
echo      Would you also like to download BootMii SD Files required to launch BootMii?
echo.
echo.
echo.
echo          Note: these are the same files generated by the HackMii Installer
echo                by installing BootMii as Boot2 or by Preparing an SD Card
echo.
echo.
echo.
echo                 Y = Yes
echo.
echo                 N = No
echo.
echo.
echo.
echo.
echo                 B = Back
echo.
echo                 M = Main Menu
echo.
echo.
echo.
echo.
set /p BMSD=     Enter Selection Here: 

if /i "%BMSD%" EQU "M" goto:MENU

if /i "%BMBOOT%" EQU "OFF" goto:skip
if /i "%BMSD%" EQU "B" goto:BMCONFIG3
:skip
if /i "%BMSD%" EQU "B" goto:BMCONFIG2

if /i "%BMSD%" EQU "Y" goto:BMCONFIG5
if /i "%BMSD%" EQU "N" goto:BMCONFIG5


echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:BMCONFIG4






::...................................BootMii CONFIGURATOR page 5...............................
:BMCONFIG5
set BMCONFIRM=
cls
echo                                        ModMii                                v%currentversion%
echo                                       by XFlak
echo.
echo.
echo.
echo                              Are these settings correct?
echo.
echo.
echo      Video Mode is set to %BMVIDEO%
echo.
echo      AutoBoot is set to %BMBOOT%
if /i "%BMBOOT%" EQU "OFF" goto:nodelay
echo.
echo      AutoBoot Delay is set to %BMDELAY% seconds
:nodelay
echo.
if /i "%BMSD%" EQU "Y" echo      * Download BootMii SD Files to Launch BootMii
echo.
echo.
echo.
echo.
echo.
echo      Y = Yes, Create bootmii.ini with these settings
if exist "%Drive%"\bootmii\bootmii.ini echo           Note: existing bootmii.ini will be overwritten
echo.
echo      N = No, take me back to the Main Menu
echo.
echo.
echo.
echo      B = Back
echo.
echo      M = Main Menu
echo.
echo.
echo.
echo.
set /p BMCONFIRM=     Enter Selection Here: 

if /i "%BMCONFIRM%" EQU "B" goto:BMCONFIG4
if /i "%BMCONFIRM%" EQU "M" goto:MENU
if /i "%BMCONFIRM%" EQU "N" goto:MENU
if /i "%BMCONFIRM%" EQU "Y" goto:BUILDBMCONFIG

echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:BMCONFIG5


:BUILDBMCONFIG
if not exist "%Drive%"\bootmii mkdir "%Drive%"\bootmii


echo # BootMii Config File> "%Drive%"\bootmii\bootmii.ini
echo # Created by ModMii>> "%Drive%"\bootmii\bootmii.ini
echo #>> "%Drive%"\bootmii\bootmii.ini
echo # Video mode, possible settings:>> "%Drive%"\bootmii\bootmii.ini
echo # NTSC, PAL50, PAL60, PROGRESSIVE>> "%Drive%"\bootmii\bootmii.ini
echo VIDEO=%BMVIDEO%>> "%Drive%"\bootmii\bootmii.ini
echo #>> "%Drive%"\bootmii\bootmii.ini
echo # Autoboot, possible settings:>> "%Drive%"\bootmii\bootmii.ini
echo # SYSMENU, HBC, OFF>> "%Drive%"\bootmii\bootmii.ini
echo AUTOBOOT=%BMBOOT%>> "%Drive%"\bootmii\bootmii.ini
echo #>> "%Drive%"\bootmii\bootmii.ini
echo # BOOTDELAY, possible settings:>> "%Drive%"\bootmii\bootmii.ini
echo # 0,1,2,3,4,5,6,7,8,9,10>> "%Drive%"\bootmii\bootmii.ini
echo BOOTDELAY=BLAH>> "%Drive%"\bootmii\bootmii.ini
support\sfk filter "%Drive%"\bootmii\bootmii.ini -rep _BLAH_%BMDELAY%_ -write -yes>nul

start notepad "%Drive%\bootmii\bootmii.ini"

cls
if /i "%BMSD%" EQU "Y" set DLTOTAL=1
if /i "%BMSD%" EQU "Y" set bootmiisd=*
if /i "%BMSD%" EQU "Y" goto:DLSETTINGS

goto:MENU






::...................................WAD MANAGER CONFIGURATOR (wmconfig.txt)...............................
:WMCONFIG
set WMCIOS=
cls
echo                                        ModMii                                v%currentversion%
echo                                       by XFlak
echo.
echo.
echo.
echo      This will create a wm_config.txt file in %DRIVE%\WAD\, and it is optional.
echo      You will get all the prompts if you don't have this file.
echo.
echo      Note: only works for YAWMM, Wad Manager Multi-Mod and WAD Manager Folder Mod
echo.
echo.
echo.
echo.
echo      Enter the IOS # you would like Wad Manager to load automatically
echo.
echo              Note: MAX is 254
echo                    Common choices are 36, 249, 250, etc.
echo                    NAND Emulation installation only available for 249 or 250
echo.
echo.
echo.
echo      N = None (Wad Manager will prompt you for selection)
echo.
echo.
echo.
echo      B = Back
echo.
echo      M = Main Menu
echo.
echo.
echo.
echo.
set /p WMCIOS=     Enter Selection Here: 

if /i "%WMCIOS%" EQU "M" goto:MENU
if /i "%WMCIOS%" EQU "B" goto:CONFIGFILEMENU
if /i "%WMCIOS%" EQU "N" goto:WMCONFIG2

::limit user input to X# of digits
if not "%WMCIOS:~3%"=="" (
    goto:badkey
)

::Reject negative numbers (LSS is less than, GTR is greater than)
if %WMCIOS% LSS 1 (goto:badkey)

if %WMCIOS% LEQ 254 goto:WMCONFIG2

:badkey
echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:WMCONFIG


::...................................WAD MANAGER CONFIGURATOR page 2...............................
:WMCONFIG2
set WMDEVICE=
cls
echo                                        ModMii                                v%currentversion%
echo                                       by XFlak
echo.
echo.
echo.
echo              Enter the FAT device you would like to load automatically.
echo.
echo              Note: you can enter either the number or the word
echo.
echo.
echo.
echo.
echo      1 = SD
echo      2 = USB
echo      3 = USB2
echo      4 = GCSDA
echo      5 = GCSDA
echo.
echo      N = None (Wad Manager will prompt you for selection)
echo.
echo.
echo.
echo.
echo      B = Back
echo.
echo      M = Main Menu
echo.
echo.
echo.
echo.
set /p WMDEVICE=     Enter Selection Here: 

if /i "%WMDEVICE%" EQU "1" SET WMDEVICE=sd
if /i "%WMDEVICE%" EQU "2" SET WMDEVICE=usb
if /i "%WMDEVICE%" EQU "3" SET WMDEVICE=usb2
if /i "%WMDEVICE%" EQU "4" SET WMDEVICE=gcsda
if /i "%WMDEVICE%" EQU "5" SET WMDEVICE=gcsdb

if /i "%WMDEVICE%" EQU "sd" goto:WMCONFIG3
if /i "%WMDEVICE%" EQU "usb" goto:WMCONFIG3
if /i "%WMDEVICE%" EQU "usb2" goto:WMCONFIG3
if /i "%WMDEVICE%" EQU "gcsda" goto:WMCONFIG3
if /i "%WMDEVICE%" EQU "gcsda" goto:WMCONFIG3
if /i "%WMDEVICE%" EQU "N" goto:WMCONFIG3

if /i "%WMDEVICE%" EQU "B" goto:WMCONFIG
if /i "%WMDEVICE%" EQU "M" goto:MENU



echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:WMCONFIG2


::...................................WAD MANAGER CONFIGURATOR page 3...............................
:WMCONFIG3
:: NAND Emulation installation only available if cIOS249 or cIOS250 selected
if /i "%WMCIOS%" EQU "249" goto:WMCONFIG3B
if /i "%WMCIOS%" EQU "250" goto:WMCONFIG3B
if /i "%WMCIOS%" EQU "N" goto:WMCONFIG3B
set WMNAND=N
goto:WMCONFIG4

:WMCONFIG3B

set WMNAND=
cls
echo                                        ModMii                                v%currentversion%
echo                                       by XFlak
echo.
echo.
echo      NAND Emulation
echo.
echo      Enter the NAND device you would like to select automatically.
echo.
echo.
echo          Note: PC tools like ShowMiiWads are better at installing wads to
echo                emulated nand. So I recommend leaving NAND Emulation Disabled
echo.
echo          Note: you can enter either the number or the word
echo.
echo.
echo.
echo      1 = Disable
echo      2 = USB
echo      3 = SD
echo.
echo      N = None (Wad Manager will prompt selection if cIOS249 or cIOS250 selected)
echo.
echo.
echo.
echo.
echo      B = Back
echo.
echo      M = Main Menu
echo.
echo.
echo.
echo.
set /p WMNAND=     Enter Selection Here: 


if /i "%WMNAND%" EQU "3" SET WMNAND=SD
if /i "%WMNAND%" EQU "2" SET WMNAND=USB
if /i "%WMNAND%" EQU "1" SET WMNAND=Disable


if /i "%WMNAND%" EQU "SD" goto:WMCONFIG4
if /i "%WMNAND%" EQU "USB" goto:WMCONFIG4
if /i "%WMNAND%" EQU "Disable" goto:WMCONFIG4
if /i "%WMNAND%" EQU "N" goto:WMCONFIG4
if /i "%WMNAND%" EQU "M" goto:MENU
if /i "%WMNAND%" EQU "B" goto:WMCONFIG2


echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:WMCONFIG3

::...................................WAD MANAGER CONFIGURATOR page 4...............................
:WMCONFIG4
set WMPATH=
cls
echo                                        ModMii                                v%currentversion%
echo                                       by XFlak
echo.
echo.
echo.
echo      Enter the Start-up Path you would like to load initially.
echo.
echo          Note: If you don't have a startupPath, the default is /WAD
echo.
echo          Note: Be sure that the path exists, else you will get an error.
echo.
echo.
echo.
echo.
echo          Examples:
echo                   /WAD/Forwarders
echo                   /myWad
echo                   /
echo                      Note: '/' sets the StartupPath to the root of the device
echo.
echo.
echo      N = None (the default is /WAD)
echo.
echo.
echo.
echo.
echo      B = Back
echo.
echo      M = Main Menu
echo.
echo.
echo.
echo.
set /p WMPATH=     Enter Selection Here: 


if /i "%WMPATH%" EQU "N" SET WMPATH=/WAD
if /i "%WMPATH%" EQU "B" goto:WMCONFIG4BACK
if /i "%WMPATH%" EQU "M" goto:MENU
IF "%WMPATH%"=="" echo You Have Entered an Incorrect Key
IF "%WMPATH%"=="" @ping 127.0.0.1 -n 2 -w 1000> nul
IF "%WMPATH%"=="" goto:WMCONFIG4
goto:WMCONFIG5

:WMCONFIG4BACK
if /i "%WMCIOS%" EQU "249" goto:WMCONFIG3B
if /i "%WMCIOS%" EQU "250" goto:WMCONFIG3B
if /i "%WMCIOS%" EQU "N" goto:WMCONFIG3B
goto:WMCONFIG2





::...................................WAD MANAGER CONFIGURATOR page 5...............................
:WMCONFIG5
set WMPASS=
cls
echo                                        ModMii                                v%currentversion%
echo                                       by XFlak
echo.
echo.
echo.
echo      Enter a Password to access Wad Manager ONLY using LRUD; where
echo.
echo         L = Left
echo         R = Right
echo         U = Up
echo         D = Down
echo.
echo      Note: Password is entered on the WiiMote or GC Controller, max 10 characters
echo.
echo      Note: If you don't have a password, the default is no password
echo.
echo.
echo.
echo.
echo          Examples:
echo                   UDLR
echo                   UDLRUDLRUD
echo                   UUUUUUU
echo                   L
echo.
echo.
echo      N = None (No Password)
echo.
echo.
echo.
echo.
echo      B = Back
echo.
echo      M = Main Menu
echo.
echo.
echo.
echo.
set /p WMPASS=     Enter Selection Here: 

if /i "%WMPASS%" EQU "B" goto:WMCONFIG4
if /i "%WMPASS%" EQU "M" goto:MENU

IF "%WMPASS%"=="" echo You Have Entered an Incorrect Key
IF "%WMPASS%"=="" @ping 127.0.0.1 -n 2 -w 1000> nul
IF "%WMPASS%"=="" goto:WMCONFIG5


::limit user input to X# of digits
if not "%WMPASS:~10%"=="" (
    echo. ERROR: Password cannot be more than 10 Digits
    @ping 127.0.0.1 -n 2 -w 1000> nul
    goto:WMCONFIG5
)



::...................................WAD MANAGER CONFIGURATOR page 6...............................
:WMCONFIG6
set WMCONFIRM=
cls
echo                                        ModMii                                v%currentversion%
echo                                       by XFlak
echo.
echo.
echo.
echo                              Are these settings correct?
echo.
echo.
if /i "%WMCIOS%" EQU "N" echo      Prompt cIOS Selection
if /i "%WMCIOS%" NEQ "N" echo      cIOSVersion=%WMCIOS%
echo.
if /i "%WMDEVICE%" EQU "N" echo      Prompt FAT Device Selection
if /i "%WMDEVICE%" NEQ "N" echo      FatDevice=%WMDEVICE%
echo.
if /i "%WMCIOS%" EQU "249" goto:nanddevice
if /i "%WMCIOS%" EQU "250" goto:nanddevice
goto:skipnanddevice

:nanddevice
if /i "%WMNAND%" EQU "N" echo      Prompt NAND Device Selection
if /i "%WMNAND%" NEQ "N" echo      NANDDevice=%WMNAND%
echo.
:skipnanddevice

echo      StartupPath=%WMPATH%
echo.
if /i "%WMPASS%" EQU "N" echo      No Password
if /i "%WMPASS%" NEQ "N" echo      Password=%WMPASS%
echo.
echo.
echo.
echo.
echo      Y = Yes, Create wm_config.txt with these settings
if exist "%Drive%"\WAD\wm_config.txt echo           Note: existing wm_config.txt will be overwritten
echo.
echo      N = No, take me back to the main menu
echo.
echo.
echo.
echo      B = Back
echo.
echo      M = Main Menu
echo.
echo.
echo.
echo.
set /p WMCONFIRM=     Enter Selection Here: 

if /i "%WMCONFIRM%" EQU "B" goto:WMCONFIG5
if /i "%WMCONFIRM%" EQU "M" goto:MENU
if /i "%WMCONFIRM%" EQU "N" goto:MENU
if /i "%WMCONFIRM%" EQU "Y" goto:BUILDWMCONFIG

echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:WMCONFIG6


:BUILDWMCONFIG
if not exist "%Drive%"\WAD mkdir "%Drive%"\WAD
echo ;wm_config.txt made by ModMii> "%Drive%"\WAD\wm_config.txt
if /i "%WMCIOS%" NEQ "N" echo cIOSVersion=%WMCIOS%>> "%Drive%"\WAD\wm_config.txt
if /i "%WMDEVICE%" NEQ "N" echo FatDevice=%WMDEVICE%>> "%Drive%"\WAD\wm_config.txt
if /i "%WMNAND%" NEQ "N" echo NANDDevice=%WMNAND%>> "%Drive%"\WAD\wm_config.txt
echo StartupPath=%WMPATH%>> "%Drive%"\WAD\wm_config.txt
if /i "%WMPASS%" NEQ "N" echo Password=%WMPASS%>> "%Drive%"\WAD\wm_config.txt
start notepad "%Drive%\WAD\wm_config.txt"
goto:MENU








::...................................MMM CONFIGURATOR (mmmconfig.txt)...............................
:MMMCONFIG
set WMCIOS=
cls
echo                                        ModMii                                v%currentversion%
echo                                       by XFlak
echo.
echo.
echo.
echo      This will create a mmmconfig.txt file in %DRIVE%\, and it is optional.
echo.
echo.
echo.
echo.
echo      Enter the IOS # you would like Multi-Mod Manager (MMM) to load automatically
echo.
echo              Note: Max is 254
echo                    Common choices are 36, 249, 250, etc.
echo.
echo.
echo.
echo      N = None (Do Not Auto-Reload IOS)
echo.
echo.
echo.
echo      B = Back
echo.
echo      M = Main Menu
echo.
echo.
echo.
echo.
set /p WMCIOS=     Enter Selection Here: 

if /i "%WMCIOS%" EQU "M" goto:MENU
if /i "%WMCIOS%" EQU "B" goto:CONFIGFILEMENU
if /i "%WMCIOS%" EQU "N" goto:MMMCONFIG2

::limit user input to X# of digits
if not "%WMCIOS:~3%"=="" (
    goto:badkey
)

::Reject negative numbers (LSS is less than, GTR is greater than)
if %WMCIOS% LSS 1 (goto:badkey)

if %WMCIOS% LEQ 254 goto:MMMCONFIG2

:badkey
echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:MMMCONFIG


::...................................MMM CONFIGURATOR (mmmconfig.txt) page 2...............................
:MMMCONFIG2
set WMDEVICE=
cls
echo                                        ModMii                                v%currentversion%
echo                                       by XFlak
echo.
echo.
echo.
echo      Enter the FAT device you would like to load automatically.
echo.
echo          Note: you can enter either the number or the word
echo.
echo.
echo.
echo.
echo      1 = SD (default if mmmconfig.txt does not exist)
echo      2 = USB
echo      3 = SMB
echo.
echo      N = None (MMM will prompt you for selection)
echo.
echo.
echo.
echo.
echo      B = Back
echo.
echo      M = Main Menu
echo.
echo.
echo.
echo.
set /p WMDEVICE=     Enter Selection Here: 


if /i "%WMDEVICE%" EQU "1" SET WMDEVICE=sd
if /i "%WMDEVICE%" EQU "2" SET WMDEVICE=usb
if /i "%WMDEVICE%" EQU "3" SET WMDEVICE=smb

if /i "%WMDEVICE%" EQU "sd" goto:MMMCONFIG3
if /i "%WMDEVICE%" EQU "usb" goto:MMMCONFIG3
if /i "%WMDEVICE%" EQU "smb" goto:MMMCONFIG3

if /i "%WMDEVICE%" EQU "N" goto:MMMCONFIG3

if /i "%WMDEVICE%" EQU "B" goto:MMMCONFIG
if /i "%WMDEVICE%" EQU "M" goto:MENU



echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:MMMCONFIG2



::...................................MMM CONFIGURATOR (mmmconfig.txt) page 3...............................
:MMMCONFIG3
set WMPATH=
cls
echo                                        ModMii                                v%currentversion%
echo                                       by XFlak
echo.
echo.
echo.
echo      Enter the Start-up Path you would like to load initially.
echo.
echo          Note: If you don't have a startupPath, the default is /WAD
echo.
echo          Note: Be sure that the path exists, else you will get an error.
echo.
echo.
echo.
echo.
echo          Examples:
echo                   /WAD/Forwarders
echo                   /myWad
echo                   /
echo                      Note: '/' sets the StartupPath to the root of the device
echo.
echo.
echo      N = None (the default is /WAD)
echo.
echo.
echo.
echo      B = Back
echo.
echo      M = Main Menu
echo.
echo.
echo.
echo.
set /p WMPATH=     Enter Selection Here: 


if /i "%WMPATH%" EQU "N" SET WMPATH=/WAD
if /i "%WMPATH%" EQU "B" goto:MMMCONFIG2
if /i "%WMPATH%" EQU "M" goto:MENU

IF "%WMPATH%"=="" echo You Have Entered an Incorrect Key
IF "%WMPATH%"=="" @ping 127.0.0.1 -n 2 -w 1000> nul
IF "%WMPATH%"=="" goto:MMMCONFIG3

::...................................MMM CONFIGURATOR (mmmconfig.txt) page 4...............................
:MMMCONFIG4
set WMCONFIRM=
cls
echo                                        ModMii                                v%currentversion%
echo                                       by XFlak
echo.
echo.
echo.
echo                              Are these settings correct?
echo.
echo.
if /i "%WMCIOS%" EQU "N" echo      Do Not Auto-Reload IOS
if /i "%WMCIOS%" NEQ "N" echo      AutoLoadIOS=%WMCIOS%
echo.
if /i "%WMDEVICE%" EQU "N" echo      Prompt FAT Device Selection
echo.
if /i "%WMDEVICE%" NEQ "N" echo      FatDevice=%WMDEVICE%

echo      StartupPath=%WMPATH%
echo.
echo.
echo.
echo.
echo      Y = Yes, Create mmmconfig.txt with these settings
if exist "%Drive%"\mmmconfig.txt echo           Note: existing mmmconfig.txt will be overwritten
echo.
echo      N = No, take me back to the main menu
echo.
echo.
echo      B = Back
echo.
echo      M = Main Menu
echo.
echo.
echo.
echo.
set /p WMCONFIRM=     Enter Selection Here: 

if /i "%WMCONFIRM%" EQU "B" goto:MMMCONFIG3
if /i "%WMCONFIRM%" EQU "M" goto:MENU
if /i "%WMCONFIRM%" EQU "N" goto:MENU
if /i "%WMCONFIRM%" EQU "Y" goto:BUILDMMMCONFIG

echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:MMMCONFIG4


:BUILDMMMCONFIG
if not exist "%Drive%" mkdir "%Drive%"
echo ;mmmconfig.txt made by ModMii> "%Drive%"\mmmconfig.txt
if /i "%WMCIOS%" NEQ "N" echo AutoLoadIOS=%WMCIOS%>> "%Drive%"\mmmconfig.txt
if /i "%WMDEVICE%" NEQ "N" echo FatDevice=%WMDEVICE%>> "%Drive%"\mmmconfig.txt
if /i "%WMDEVICE%" EQU "N" echo FatDevice=>> "%Drive%"\mmmconfig.txt

echo StartupPath=%WMPATH%>> "%Drive%"\mmmconfig.txt

start notepad "%Drive%\mmmconfig.txt"
goto:MENU




::----------------------------------------sysCheck Selector-------------------------------------
:sysCheckName
set sysCheckName=
cls
echo                                        ModMii                                v%currentversion%
echo                                       by XFlak
echo.
echo.
echo      Enter the path\name of your sysCheck.csv log that you want to analyze.
echo.
echo.
echo      You can do this by dragging and dropping the file onto this window
echo      then hitting Enter. Or you can just drag and drop it onto ModMii.exe
echo      or a shortcut to ModMii.
echo.
echo.
echo.
echo      Note: You can download sysCheck from ModMii's Download Page 2.
echo            Simply save it to your SD card or FAT32 HDD and run it from the
echo            Homebrew Channel. It will then save a sysCheck.csv log to the root
echo            of your SD Card or FAT32 HDD.
echo.
echo.
echo.
echo                B = Back
echo.
echo                M = Main Menu
echo.
echo.
echo.
set /p sysCheckName=     Enter Selection Here: 

echo "set sysCheckName=%sysCheckName%">temp\temp.txt
support\sfk filter -quiet temp\temp.txt -rep _""""__>temp\temp.bat
call temp\temp.bat
del temp\temp.bat>nul
del temp\temp.txt>nul

if "%sysCheckName%"=="" goto:badkey

if /i "%sysCheckName%" EQU "M" goto:MENU
if /i "%sysCheckName%" EQU "B" goto:MENU

if /i "%sysCheckName:~-4%" NEQ ".csv" goto:badkey

if not exist "%sysCheckName%" goto:badkey

findStr /I /C:"syscheck" "%sysCheckName%" >nul
IF ERRORLEVEL 1 (echo This is not a valid syscheck report) & (@ping 127.0.0.1 -n 2 -w 1000> nul) & (goto:sysCheckName)

goto:sysCheckAnalyzer

:badkey
echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:sysCheckName


::----------------------------------------sysCheck Analyzer-------------------------------------
:sysCheckAnalyzer
cls

::get syscheck version
copy /y "%sysCheckName%" temp\syscheck.txt>nul
support\sfk filter -quiet temp\syscheck.txt -ls+"sysCheck" -rep _"sysCheck v"__ -rep _" by*"__ -write -yes
set /p syscheckversion= <temp\syscheck.txt
del temp\syscheck.txt>nul

::get System Menu info (ie. "System Menu 4.3E")
copy /y "%sysCheckName%" temp\syscheck.txt>nul
support\sfk filter -quiet temp\syscheck.txt -ls+"System Menu " -rep _"*System Menu "__ -rep _" *"__ -rep _",*"__ -write -yes
set /p firmstart= <temp\syscheck.txt


set region=%firmstart:~-1%
set firmstart=%firmstart:~0,-1%
if /i "%firmstart:~0,1%" EQU "3" set firmstart=3.X
if /i "%firmstart:~0,1%" EQU "2" set firmstart=o
::echo %firmstart%%region%
del temp\syscheck.txt>nul

set firm=%firmstart%



set firmwarechange=no
if /i "%firmstart%" EQU "4.0" set firmwarechange=yes
if /i "%firmstart%" EQU "3.x" set firmwarechange=yes
if /i "%firmstart%" EQU "o" set firmwarechange=yes

if /i "%firmwarechange%" EQU "no" goto:noSM
set firm=4.1
if /i "%REGION%" EQU "U" set SM4.1U=*
if /i "%REGION%" EQU "E" set SM4.1E=*
if /i "%REGION%" EQU "J" set SM4.1J=*
if /i "%REGION%" EQU "K" set SM4.1K=*
:noSM


::check if priiloader is installed
set pri=*
if /i "%firmwarechange%" EQU "yes" (set pri=*) & (goto:skipprianalysis)
if /i "%syscheckversion%" EQU "2.0.1" goto:skipprianalysis
::note: Priiloader is spelled wrong in SOME syscheck logs
findStr /I /C:"Priilaoder installed" "%sysCheckName%" >nul
IF not ERRORLEVEL 1 set pri=
findStr /I /C:"Priiloader installed" "%sysCheckName%" >nul
IF not ERRORLEVEL 1 set pri=
:skipprianalysis

if /i "%syscheckversion%" NEQ "2.0.1" goto:nopriconfirmation
if /i "%pri%" EQU "*" goto:nopriconfirmation


:Prisyscheck

::---------------CMD LINE MODE-------------
if /i "%cmdlinemode%" NEQ "Y" goto:cmdskip
if /i "%PRICMD%" EQU "Y" set pri=*
goto:nopriconfirmation
:cmdskip

set Prisyscheck=
cls
echo Unable to determine if priiloader is installed using sysCheck v2.0.1 logs
echo.
echo Do you already have priiloader installed? (Y/N)
echo.
echo If you don't know, try accessing Priiloader by powering off the Wii,
echo then powering it back on while holding reset.
echo If Priiloader is installed you will be taken to the Priiloader menu.
echo If you're still unsure, just answer "N".
echo.
set /p Prisyscheck=     Enter Selection Here: 

if /i "%Prisyscheck%" EQU "Y" (set pri=) & (cls) & (goto:nopriconfirmation)
if /i "%Prisyscheck%" EQU "N" (set pri=*) & (cls) & (goto:nopriconfirmation)

echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:Prisyscheck
:nopriconfirmation




set d2x-beta-rev=8-final
set ciosversion=21008
if exist support\d2x-beta\d2x-beta.bat call support\d2x-beta\d2x-beta.bat

echo "set cIOSversionNum=%d2x-beta-rev%">temp\cIOSrev.bat
support\sfk filter -spat temp\cIOSrev.bat -rep _\x22__ -rep _"-*"__ -write -yes>nul
call temp\cIOSrev.bat
del temp\cIOSrev.bat>nul


set string1=%cIOSversionNum%
set versionlength=1
::letter by letter loop
:loopy2
    if /i "%string1%" EQU "" goto:endloopy2
    set string1=%string1:~1%
    set /A versionlength=%versionlength%+1
    goto:loopy2
:endloopy2


echo set cIOSsubversion=@d2x-beta-rev:~%versionlength%,16@>temp\cIOSsubversion.bat
support\sfk filter temp\cIOSsubversion.bat -spat -rep _@_%%_ -write -yes>nul
call temp\cIOSsubversion.bat
del temp\cIOSsubversion.bat>nul
:tinyjump



::check for recommended cIOSs and HBC
if /i "%syscheckversion%" EQU "2.0.1" goto:v2.0.1

set HM=*
findStr /I /C:"Homebrew Channel 1.1.2 running on IOS58" "%sysCheckName%" >nul
IF not ERRORLEVEL 1 set HM=

::check for any version of IOS58
if /i "%HM%" NEQ "*" goto:no58check
findStr /I /C:"IOS58 " "%sysCheckName%" >nul
IF ERRORLEVEL 1 (set IOS58=*) else (set IOS58=)
:no58check

findStr /I /C:"IOS202[60] (rev 65535, Info: hermesrodries-v6" "%sysCheckName%" >nul
IF ERRORLEVEL 1 (set cIOS202[60]-v5.1R=*) else (set cIOS202[60]-v5.1R=)

findStr /I /C:"IOS222[38] (rev 4, Info: hermes-v4" "%sysCheckName%" >nul
IF ERRORLEVEL 1 (set cIOS222[38]-v4=*) else (set cIOS222[38]-v4=)

set cIOS223[37-38]-v4=*
findStr /I /C:"IOS223[75] (rev 4, Info: hermes-v4" "%sysCheckName%" >nul
IF not ERRORLEVEL 1 set cIOS223[37-38]-v4=
findStr /I /C:"IOS223[38+37] (rev 4, Info: hermes-v4" "%sysCheckName%" >nul
IF not ERRORLEVEL 1 set cIOS223[37-38]-v4=

findStr /I /C:"IOS224[57] (rev 65535, Info: hermesrodries-v6" "%sysCheckName%" >nul
IF ERRORLEVEL 1 (set cIOS224[57]-v5.1R=*) else (set cIOS224[57]-v5.1R=)

findStr /I /C:"IOS249[56] (rev %ciosversion%, Info: d2x-v%cIOSversionNum%%cIOSsubversion%" "%sysCheckName%" >nul
IF ERRORLEVEL 1 (set cIOS249[56]-d2x-v8-final=*) else (set cIOS249[56]-d2x-v8-final=)

findStr /I /C:"IOS250[57] (rev %ciosversion%, Info: d2x-v%cIOSversionNum%%cIOSsubversion%" "%sysCheckName%" >nul
IF ERRORLEVEL 1 (set cIOS250[57]-d2x-v8-final=*) else (set cIOS250[57]-d2x-v8-final=)

goto:skipv2.0.1




:v2.0.1

findStr /I /C:"runs on IOS58" "%sysCheckName%" >nul
IF ERRORLEVEL 1 (set HM=*) else (set HM=)

::check for any version of IOS58
if /i "%HM%" NEQ "*" goto:no58check
findStr /I /C:"IOS58 " "%sysCheckName%" >nul
IF ERRORLEVEL 1 (set IOS58=*) else (set IOS58=)
:no58check

findStr /I /C:"IOS202 (rev 65535): Trucha Bug, NAND Access, USB 2.0" "%sysCheckName%" >nul
IF ERRORLEVEL 1 (set cIOS202[60]-v5.1R=*) else (set cIOS202[60]-v5.1R=)

findStr /I /C:"IOS222 (rev 4): Trucha Bug, ES Identify" "%sysCheckName%" >nul
IF ERRORLEVEL 1 (set cIOS222[38]-v4=*) else (set cIOS222[38]-v4=)

findStr /I /C:"IOS223 (rev 4): Trucha Bug, ES Identify" "%sysCheckName%" >nul
IF ERRORLEVEL 1 (set cIOS223[37-38]-v4=*) else (set cIOS223[37-38]-v4=)

findStr /I /C:"IOS224 (rev 65535): Trucha Bug, NAND Access, USB 2.0" "%sysCheckName%" >nul
IF ERRORLEVEL 1 (set cIOS224[57]-v5.1R=*) else (set cIOS224[57]-v5.1R=)

findStr /I /C:"IOS249 (rev %ciosversion%): Trucha Bug, NAND Access, USB 2.0" "%sysCheckName%" >nul
IF ERRORLEVEL 1 (set cIOS249[56]-d2x-v8-final=*) else (set cIOS249[56]-d2x-v8-final=)

findStr /I /C:"IOS250 (rev %ciosversion%): Trucha Bug, NAND Access, USB 2.0" "%sysCheckName%" >nul
IF ERRORLEVEL 1 (set cIOS250[57]-d2x-v8-final=*) else (set cIOS250[57]-d2x-v8-final=)

:skipv2.0.1



::bootmii check
findStr /I /C:"bootmii" "%sysCheckName%" >nul
IF ERRORLEVEL 1 set HM=*

::bootmiiSD files
if /i "%HM%" EQU "*" set bootmiisd=*



::check for missing active IOSs
if /i "%ACTIVEIOS%" EQU "OFF" goto:skipactivecheck

findStr /I /C:"IOS9 (rev 1034): No Patches" "%sysCheckName%" >nul
IF ERRORLEVEL 1 (set IOS9=*) else (set IOS9=)

findStr /I /C:"IOS12 (rev 526): No Patches" "%sysCheckName%" >nul
IF ERRORLEVEL 1 (set IOS12=*) else (set IOS12=)

findStr /I /C:"IOS13 (rev 1032): No Patches" "%sysCheckName%" >nul
IF ERRORLEVEL 1 (set IOS13=*) else (set IOS13=)

findStr /I /C:"IOS14 (rev 1032): No Patches" "%sysCheckName%" >nul
IF ERRORLEVEL 1 (set IOS14=*) else (set IOS14=)

findStr /I /C:"IOS15 (rev 1032): No Patches" "%sysCheckName%" >nul
IF ERRORLEVEL 1 (set IOS15=*) else (set IOS15=)

findStr /I /C:"IOS17 (rev 1032): No Patches" "%sysCheckName%" >nul
IF ERRORLEVEL 1 (set IOS17=*) else (set IOS17=)

findStr /I /C:"IOS21 (rev 1039): No Patches" "%sysCheckName%" >nul
IF ERRORLEVEL 1 (set IOS21=*) else (set IOS21=)

findStr /I /C:"IOS22 (rev 1294): No Patches" "%sysCheckName%" >nul
IF ERRORLEVEL 1 (set IOS22=*) else (set IOS22=)

findStr /I /C:"IOS28 (rev 1807): No Patches" "%sysCheckName%" >nul
IF ERRORLEVEL 1 (set IOS28=*) else (set IOS28=)

findStr /I /C:"IOS31 (rev 3608): No Patches" "%sysCheckName%" >nul
IF ERRORLEVEL 1 (set IOS31=*) else (set IOS31=)

findStr /I /C:"IOS33 (rev 3608): No Patches" "%sysCheckName%" >nul
IF ERRORLEVEL 1 (set IOS33=*) else (set IOS33=)

findStr /I /C:"IOS34 (rev 3608): No Patches" "%sysCheckName%" >nul
IF ERRORLEVEL 1 (set IOS34=*) else (set IOS34=)

findStr /I /C:"IOS35 (rev 3608): No Patches" "%sysCheckName%" >nul
IF ERRORLEVEL 1 (set IOS35=*) else (set IOS35=)

if /i "%OPTION36%" EQU "OFF" goto:no36update
findStr /I /C:"IOS36 (rev 3608): No Patches" "%sysCheckName%" >nul
IF ERRORLEVEL 1 (set IOS36v3608=*) else (set IOS36v3608=)
:no36update

findStr /I /C:"IOS37 (rev 5663): No Patches" "%sysCheckName%" >nul
IF ERRORLEVEL 1 (set IOS37=*) else (set IOS37=)

findStr /I /C:"IOS38 (rev 4124): No Patches" "%sysCheckName%" >nul
IF ERRORLEVEL 1 (set IOS38=*) else (set IOS38=)

findStr /I /C:"IOS41 (rev 3607): No Patches" "%sysCheckName%" >nul
IF ERRORLEVEL 1 (set IOS41=*) else (set IOS41=)

findStr /I /C:"IOS43 (rev 3607): No Patches" "%sysCheckName%" >nul
IF ERRORLEVEL 1 (set IOS43=*) else (set IOS43=)

findStr /I /C:"IOS45 (rev 3607): No Patches" "%sysCheckName%" >nul
IF ERRORLEVEL 1 (set IOS45=*) else (set IOS45=)

findStr /I /C:"IOS46 (rev 3607): No Patches" "%sysCheckName%" >nul
IF ERRORLEVEL 1 (set IOS46=*) else (set IOS46=)

findStr /I /C:"IOS48 (rev 4124): No Patches" "%sysCheckName%" >nul
IF ERRORLEVEL 1 (set IOS48v4124=*) else (set IOS48v4124=)

findStr /I /C:"IOS53 (rev 5663): No Patches" "%sysCheckName%" >nul
IF ERRORLEVEL 1 (set IOS53=*) else (set IOS53=)

findStr /I /C:"IOS55 (rev 5663): No Patches" "%sysCheckName%" >nul
IF ERRORLEVEL 1 (set IOS55=*) else (set IOS55=)

findStr /I /C:"IOS56 (rev 5662): No Patches" "%sysCheckName%" >nul
IF ERRORLEVEL 1 (set IOS56=*) else (set IOS56=)

findStr /I /C:"IOS57 (rev 5919): No Patches" "%sysCheckName%" >nul
IF ERRORLEVEL 1 (set IOS57=*) else (set IOS57=)

set IOS58=*
findStr /I /C:"IOS58 (rev 6176): No Patches" "%sysCheckName%" >nul
IF not ERRORLEVEL 1 set IOS58=
findStr /I /C:"IOS58 (rev 6176): USB 2.0" "%sysCheckName%" >nul
IF not ERRORLEVEL 1 set IOS58=

findStr /I /C:"IOS61 (rev 5662): No Patches" "%sysCheckName%" >nul
IF ERRORLEVEL 1 (set IOS61=*) else (set IOS61=)

findStr /I /C:"IOS62 (rev 6430): No Patches" "%sysCheckName%" >nul
IF ERRORLEVEL 1 (set IOS62=*) else (set IOS62=)

:skipactivecheck



::patched IOS check

findStr /I /C:"IOS60 (rev 16174): Trucha Bug, NAND Access" "%sysCheckName%" >nul
IF ERRORLEVEL 1 (set IOS60P=*) else (set IOS60P=)

findStr /I /C:"IOS70 (rev 16174): Trucha Bug, NAND Access" "%sysCheckName%" >nul
IF ERRORLEVEL 1 (set IOS70K=*) else (set IOS70K=)

findStr /I /C:"IOS80 (rev 16174): Trucha Bug, NAND Access" "%sysCheckName%" >nul
IF ERRORLEVEL 1 (set IOS80K=*) else (set IOS80K=)

findStr /I /C:"IOS11 (rev 16174): Trucha Bug, NAND Access" "%sysCheckName%" >nul
IF ERRORLEVEL 1 (set IOS11P60=*) else (set IOS11P60=)

findStr /I /C:"IOS20 (rev 16174): Trucha Bug, NAND Access" "%sysCheckName%" >nul
IF ERRORLEVEL 1 (set IOS20P60=*) else (set IOS20P60=)

findStr /I /C:"IOS30 (rev 16174): Trucha Bug, NAND Access" "%sysCheckName%" >nul
IF ERRORLEVEL 1 (set IOS30P60=*) else (set IOS30P60=)

findStr /I /C:"IOS40 (rev 16174): Trucha Bug, NAND Access" "%sysCheckName%" >nul
IF ERRORLEVEL 1 (set IOS40P60=*) else (set IOS40P60=)

findStr /I /C:"IOS50 (rev 16174): Trucha Bug, NAND Access" "%sysCheckName%" >nul
IF ERRORLEVEL 1 (set IOS50P=*) else (set IOS50P=)

findStr /I /C:"IOS52 (rev 16174): Trucha Bug, NAND Access" "%sysCheckName%" >nul
IF ERRORLEVEL 1 (set IOS52P=*) else (set IOS52P=)


::cMIOS
if /i "%CMIOSOPTION%" EQU "OFF" goto:skipcMIOScheck
set RVL-cMIOS-v65535(v10)_WiiGator_WiiPower_v0.2=
findStr /I /C:"MIOS v65535" "%sysCheckName%" >nul
IF ERRORLEVEL 1 set RVL-cMIOS-v65535(v10)_WiiGator_WiiPower_v0.2=*
:skipcMIOScheck

::MIOSv10
if /i "%CMIOSOPTION%" EQU "ON" goto:skipMIOScheck
findStr /I /C:"MIOS v10" "%sysCheckName%" >nul
IF ERRORLEVEL 1 (set M10=*) else (set M10=)
:skipMIOScheck


::IOS236
findStr /I /C:"IOS236" "%sysCheckName%" >nul
IF ERRORLEVEL 1 (set IOS236Installer=*) else (set IOS236Installer=)
if /i "%IOS236Installer%" EQU "*" (set SIP=*) else (set SIP=)
if /i "%IOS236Installer%" EQU "*" (set IOS36=*) else (set IOS36=)


set mmm=
set RECCIOS=
if /i "%cIOS202[60]-v5.1R%" EQU "*" (set mmm=*) & (set RECCIOS=Y)
if /i "%cIOS222[38]-v4%" EQU "*" (set mmm=*) & (set RECCIOS=Y)
if /i "%cIOS223[37-38]-v4%" EQU "*" (set mmm=*) & (set RECCIOS=Y)
if /i "%cIOS224[57]-v5.1R%" EQU "*" (set mmm=*) & (set RECCIOS=Y)
if /i "%cIOS249[56]-d2x-v8-final%" EQU "*" (set mmm=*) & (set RECCIOS=Y)
if /i "%cIOS250[57]-d2x-v8-final%" EQU "*" (set mmm=*) & (set RECCIOS=Y)
if /i "%IOS9%" EQU "*" set mmm=*
if /i "%IOS12%" EQU "*" set mmm=*
if /i "%IOS13%" EQU "*" set mmm=*
if /i "%IOS14%" EQU "*" set mmm=*
if /i "%IOS15%" EQU "*" set mmm=*
if /i "%IOS17%" EQU "*" set mmm=*
if /i "%IOS21%" EQU "*" set mmm=*
if /i "%IOS22%" EQU "*" set mmm=*
if /i "%IOS28%" EQU "*" set mmm=*
if /i "%IOS31%" EQU "*" set mmm=*
if /i "%IOS33%" EQU "*" set mmm=*
if /i "%IOS34%" EQU "*" set mmm=*
if /i "%IOS35%" EQU "*" set mmm=*
if /i "%IOS36v3608%" EQU "*" set mmm=*
if /i "%IOS37%" EQU "*" set mmm=*
if /i "%IOS38%" EQU "*" set mmm=*
if /i "%IOS41%" EQU "*" set mmm=*
if /i "%IOS48v4124%" EQU "*" set mmm=*
if /i "%IOS43%" EQU "*" set mmm=*
if /i "%IOS45%" EQU "*" set mmm=*
if /i "%IOS46%" EQU "*" set mmm=*
if /i "%IOS53%" EQU "*" set mmm=*
if /i "%IOS55%" EQU "*" set mmm=*
if /i "%IOS56%" EQU "*" set mmm=*
if /i "%IOS57%" EQU "*" set mmm=*
if /i "%IOS58%" EQU "*" set mmm=*
if /i "%IOS61%" EQU "*" set mmm=*
if /i "%IOS62%" EQU "*" set mmm=*
if /i "%IOS60P%" EQU "*" set mmm=*
if /i "%IOS70K%" EQU "*" set mmm=*
if /i "%IOS80K%" EQU "*" set mmm=*
if /i "%IOS236%" EQU "*" set mmm=*
if /i "%RVL-cMIOS-v65535(v10)_WiiGator_WiiPower_v0.2%" EQU "*" set mmm=*
if /i "%M10%" EQU "*" set mmm=*


set BACKB4QUEUE=sysCheckName
goto:DOWNLOADQUEUE



::........................................HACKMII SOLUTION.......................................
:HACKMIISOLUTION
set SETTINGSHM=



set BB1=
set BB2=
set SMASH=
set PWNS=
set Bathaxx=
set ROTJ=
set TOS=
set TWI=
set YUGI=


::set IOS30P60=*
set IOS31=*
set IOS33=*
set IOS34=*
set IOS35=*
set IOS36v3608=*
set IOS58=*

set HM=*
set bootmiisd=*
set mmm=*
if /i "%FIRMSTART%" EQU "4.1" set BB1=*
if /i "%FIRMSTART%" EQU "4.0" set BB1=*
if /i "%FIRMSTART%" EQU "3.x" set BB1=*
if /i "%FIRMSTART%" EQU "4.2" set BB2=*

if /i "%EXPLOIT%" EQU "W" set Wilbrand=*
if /i "%EXPLOIT%" EQU "S" set SMASH=*
if /i "%EXPLOIT%" EQU "L" set PWNS=*
if /i "%EXPLOIT%" EQU "LB" set Bathaxx=*
if /i "%EXPLOIT%" EQU "LS" set ROTJ=*
if /i "%EXPLOIT%" EQU "TOS" set TOS=*
if /i "%EXPLOIT%" EQU "T" set TWI=*
if /i "%EXPLOIT%" EQU "Y" set YUGI=*
if /i "%EXPLOIT%" EQU "LB" set Bathaxx=*

if /i "%EXPLOIT%" NEQ "?" goto:notallexploits2
if /i "%FIRMSTART%" EQU "o" set Twi=*
set SMASH=*

if /i "%REGION%" NEQ "K" set PWNS=*
if /i "%REGION%" NEQ "K" set YUGI=*
if /i "%REGION%" NEQ "K" set Bathaxx=*
if /i "%REGION%" NEQ "K" set ROTJ=*
if /i "%REGION%" NEQ "K" set TOS=*
:notallexploits2

set BACKB4QUEUE=%backb4HACKMIISOLUTION%
goto:DOWNLOADQUEUE



::...................................Download...............................
:Download

cls
set cleardownloadsettings=yes
goto:clear

:DownloadSettings
set cleardownloadsettings=


::Abstinence Logic
if /i "%AbstinenceWiz%" NEQ "Y" goto:NotAbstinenceLogic

set casper=*

if /i "%SNKFLOW%" EQU "Y" set FLOW=*
if /i "%SNKPLC%" EQU "Y" set PL=*

if /i "%FIRMSTART%" EQU "4.1" set BB1=*
if /i "%FIRMSTART%" EQU "4.0" set BB1=*
if /i "%FIRMSTART%" EQU "3.2" set BB1=*
if /i "%FIRMSTART%" EQU "3.x" set BB1=*
if /i "%FIRMSTART%" EQU "4.2" set BB2=*
if /i "%EXPLOIT%" EQU "W" set Wilbrand=*
if /i "%EXPLOIT%" EQU "S" set SMASH=*
if /i "%EXPLOIT%" EQU "L" set PWNS=*
if /i "%EXPLOIT%" EQU "T" set Twi=*
if /i "%EXPLOIT%" EQU "Y" set YUGI=*
if /i "%EXPLOIT%" EQU "LB" set Bathaxx=*
if /i "%EXPLOIT%" EQU "LS" set ROTJ=*
if /i "%EXPLOIT%" EQU "TOS" set TOS=*
if /i "%EXPLOIT%" NEQ "?" goto:notallexploits
if /i "%FIRMSTART%" EQU "o" set Twi=*
set SMASH=*
if /i "%REGION%" NEQ "K" set PWNS=*
if /i "%REGION%" NEQ "K" set YUGI=*
if /i "%REGION%" NEQ "K" set Bathaxx=*
if /i "%REGION%" NEQ "K" set ROTJ=*
if /i "%REGION%" NEQ "K" set TOS=*
:notallexploits

::IOS53 and mmm
if /i "%FIRMSTART%" EQU "4.3" goto:smallskip
if /i "%FIRMSTART%" EQU "4.2" goto:smallskip
set IOS53=*
set mmm=*
:smallskip

if /i "%SNEEKTYPE:~0,1%" EQU "U" set f32=*

if /i "%secondrun%" EQU "Y" goto:DLCOUNT
set secondrun=Y
goto:guide

:NotAbstinenceLogic


set firmwarechange=yes
if /i "%FIRM%" EQU "%FIRMSTART%" set firmwarechange=no

if /i "%REGION%" EQU "U" goto:U
if /i "%REGION%" EQU "E" goto:E
if /i "%REGION%" EQU "J" goto:J
if /i "%REGION%" EQU "K" goto:K


:U
if /i "%firmwarechange%" EQU "no" goto:nofirmwarechange

if /i "%ThemeSelection%" NEQ "N" goto:skip
if /i "%FIRM%" EQU "4.3" set SM4.3U=*
if /i "%FIRM%" EQU "4.2" set SM4.2U=*
if /i "%FIRM%" EQU "4.1" set SM4.1U=*
:skip

if /i "%ThemeSelection%" NEQ "R" goto:SKIPredSM
if /i "%FIRM%" EQU "4.3" set SM4.3U-DWR=*
if /i "%FIRM%" EQU "4.2" set SM4.2U-DWR=*
if /i "%FIRM%" EQU "4.1" set SM4.1U-DWR=*
goto:SKIPSM
:SKIPredSM

if /i "%ThemeSelection%" NEQ "G" goto:SKIPgreenSM
if /i "%FIRM%" EQU "4.3" set SM4.3U-DWG=*
if /i "%FIRM%" EQU "4.2" set SM4.2U-DWG=*
if /i "%FIRM%" EQU "4.1" set SM4.1U-DWG=*
goto:SKIPSM
:SKIPgreenSM

if /i "%ThemeSelection%" NEQ "BL" goto:SKIPblueSM
if /i "%FIRM%" EQU "4.3" set SM4.3U-DWB=*
if /i "%FIRM%" EQU "4.2" set SM4.2U-DWB=*
if /i "%FIRM%" EQU "4.1" set SM4.1U-DWB=*
goto:SKIPSM
:SKIPblueSM

if /i "%ThemeSelection%" NEQ "O" goto:SKIPorangeSM
if /i "%FIRM%" EQU "4.3" set SM4.3U-DWO=*
if /i "%FIRM%" EQU "4.2" set SM4.2U-DWO=*
if /i "%FIRM%" EQU "4.1" set SM4.1U-DWO=*
goto:SKIPSM
:SKIPorangeSM

:nofirmwarechange
if /i "%ThemeSelection%" NEQ "R" goto:SKIPredSM
set MyM=*
if /i "%FIRM%" EQU "4.3" set DarkWii_Red_4.3U=*
if /i "%FIRM%" EQU "4.2" set DarkWii_Red_4.2U=*
if /i "%FIRM%" EQU "4.1" set DarkWii_Red_4.1U=*
:SKIPredSM

if /i "%ThemeSelection%" NEQ "G" goto:SKIPgreenSM
set MyM=*
if /i "%FIRM%" EQU "4.3" set DarkWii_Green_4.3U=*
if /i "%FIRM%" EQU "4.2" set DarkWii_Green_4.2U=*
if /i "%FIRM%" EQU "4.1" set DarkWii_Green_4.1U=*
:SKIPgreenSM

if /i "%ThemeSelection%" NEQ "BL" goto:SKIPBlueSM
set MyM=*
if /i "%FIRM%" EQU "4.3" set DarkWii_Blue_4.3U=*
if /i "%FIRM%" EQU "4.2" set DarkWii_Blue_4.2U=*
if /i "%FIRM%" EQU "4.1" set DarkWii_Blue_4.1U=*
:SKIPBlueSM

if /i "%ThemeSelection%" NEQ "O" goto:SKIPOrangeSM
set MyM=*
if /i "%FIRM%" EQU "4.3" set darkwii_orange_4.3U=*
if /i "%FIRM%" EQU "4.2" set darkwii_orange_4.2U=*
if /i "%FIRM%" EQU "4.1" set darkwii_orange_4.1U=*
:SKIPOrangeSM

:SKIPSM

if /i "%PIC%" EQU "Y" set P=*
if /i "%NET%" EQU "Y" set IU=*
if /i "%WEATHER%" EQU "Y" set WU=*
if /i "%NEWS%" EQU "Y" set NU=*
if /i "%SHOP%" EQU "Y" set S=*
if /i "%SPEAK%" EQU "Y" set WSU=*
goto:BUGGEDSMIOS



:E
if /i "%firmwarechange%" EQU "no" goto:nofirmwarechange

if /i "%ThemeSelection%" NEQ "N" goto:skip
if /i "%FIRM%" EQU "4.3" set SM4.3E=*
if /i "%FIRM%" EQU "4.2" set SM4.2E=*
if /i "%FIRM%" EQU "4.1" set SM4.1E=*
:skip

if /i "%ThemeSelection%" NEQ "R" goto:SKIPredSM
if /i "%FIRM%" EQU "4.3" set SM4.3E-DWR=*
if /i "%FIRM%" EQU "4.2" set SM4.2E-DWR=*
if /i "%FIRM%" EQU "4.1" set SM4.1E-DWR=*
goto:SKIPSM
:SKIPredSM

if /i "%ThemeSelection%" NEQ "G" goto:SKIPgreenSM
if /i "%FIRM%" EQU "4.3" set SM4.3E-DWG=*
if /i "%FIRM%" EQU "4.2" set SM4.2E-DWG=*
if /i "%FIRM%" EQU "4.1" set SM4.1E-DWG=*
goto:SKIPSM
:SKIPgreenSM

if /i "%ThemeSelection%" NEQ "BL" goto:SKIPblueSM
if /i "%FIRM%" EQU "4.3" set SM4.3E-DWB=*
if /i "%FIRM%" EQU "4.2" set SM4.2E-DWB=*
if /i "%FIRM%" EQU "4.1" set SM4.1E-DWB=*
goto:SKIPSM
:SKIPblueSM

if /i "%ThemeSelection%" NEQ "O" goto:SKIPorangeSM
if /i "%FIRM%" EQU "4.3" set SM4.3E-DWO=*
if /i "%FIRM%" EQU "4.2" set SM4.2E-DWO=*
if /i "%FIRM%" EQU "4.1" set SM4.1E-DWO=*
goto:SKIPSM
:SKIPorangeSM

:nofirmwarechange
if /i "%ThemeSelection%" NEQ "R" goto:SKIPredSM
set MyM=*
if /i "%FIRM%" EQU "4.3" set DarkWii_Red_4.3E=*
if /i "%FIRM%" EQU "4.2" set DarkWii_Red_4.2E=*
if /i "%FIRM%" EQU "4.1" set DarkWii_Red_4.1E=*
:SKIPredSM

if /i "%ThemeSelection%" NEQ "G" goto:SKIPgreenSM
set MyM=*
if /i "%FIRM%" EQU "4.3" set DarkWii_Green_4.3E=*
if /i "%FIRM%" EQU "4.2" set DarkWii_Green_4.2E=*
if /i "%FIRM%" EQU "4.1" set DarkWii_Green_4.1E=*
:SKIPgreenSM

if /i "%ThemeSelection%" NEQ "BL" goto:SKIPBlueSM
set MyM=*
if /i "%FIRM%" EQU "4.3" set DarkWii_Blue_4.3E=*
if /i "%FIRM%" EQU "4.2" set DarkWii_Blue_4.2E=*
if /i "%FIRM%" EQU "4.1" set DarkWii_Blue_4.1E=*
:SKIPBlueSM

if /i "%ThemeSelection%" NEQ "O" goto:SKIPOrangeSM
set MyM=*
if /i "%FIRM%" EQU "4.3" set darkwii_orange_4.3E=*
if /i "%FIRM%" EQU "4.2" set darkwii_orange_4.2E=*
if /i "%FIRM%" EQU "4.1" set darkwii_orange_4.1E=*
:SKIPOrangeSM

:SKIPSM

if /i "%PIC%" EQU "Y" set P=*
if /i "%NET%" EQU "Y" set IE=*
if /i "%WEATHER%" EQU "Y" set WE=*
if /i "%NEWS%" EQU "Y" set NE=*
if /i "%SHOP%" EQU "Y" set S=*
if /i "%SPEAK%" EQU "Y" set WSE=*
goto:BUGGEDSMIOS



:J
if /i "%firmwarechange%" EQU "no" goto:nofirmwarechange

if /i "%ThemeSelection%" NEQ "N" goto:skip
if /i "%FIRM%" EQU "4.3" set SM4.3J=*
if /i "%FIRM%" EQU "4.2" set SM4.2J=*
if /i "%FIRM%" EQU "4.1" set SM4.1J=*
:skip

if /i "%ThemeSelection%" NEQ "R" goto:SKIPredSM
if /i "%FIRM%" EQU "4.3" set SM4.3J-DWR=*
if /i "%FIRM%" EQU "4.2" set SM4.2J-DWR=*
if /i "%FIRM%" EQU "4.1" set SM4.1J-DWR=*
goto:SKIPSM
:SKIPredSM

if /i "%ThemeSelection%" NEQ "G" goto:SKIPgreenSM
if /i "%FIRM%" EQU "4.3" set SM4.3J-DWG=*
if /i "%FIRM%" EQU "4.2" set SM4.2J-DWG=*
if /i "%FIRM%" EQU "4.1" set SM4.1J-DWG=*
goto:SKIPSM
:SKIPgreenSM

if /i "%ThemeSelection%" NEQ "BL" goto:SKIPblueSM
if /i "%FIRM%" EQU "4.3" set SM4.3J-DWB=*
if /i "%FIRM%" EQU "4.2" set SM4.2J-DWB=*
if /i "%FIRM%" EQU "4.1" set SM4.1J-DWB=*
goto:SKIPSM
:SKIPblueSM

if /i "%ThemeSelection%" NEQ "O" goto:SKIPorangeSM
if /i "%FIRM%" EQU "4.3" set SM4.3J-DWO=*
if /i "%FIRM%" EQU "4.2" set SM4.2J-DWO=*
if /i "%FIRM%" EQU "4.1" set SM4.1J-DWO=*
goto:SKIPSM
:SKIPorangeSM

:nofirmwarechange
if /i "%ThemeSelection%" NEQ "R" goto:SKIPredSM
set MyM=*
if /i "%FIRM%" EQU "4.3" set DarkWii_Red_4.3J=*
if /i "%FIRM%" EQU "4.2" set DarkWii_Red_4.2J=*
if /i "%FIRM%" EQU "4.1" set DarkWii_Red_4.1J=*
:SKIPredSM

if /i "%ThemeSelection%" NEQ "G" goto:SKIPgreenSM
set MyM=*
if /i "%FIRM%" EQU "4.3" set DarkWii_Green_4.3J=*
if /i "%FIRM%" EQU "4.2" set DarkWii_Green_4.2J=*
if /i "%FIRM%" EQU "4.1" set DarkWii_Green_4.1J=*
:SKIPgreenSM

if /i "%ThemeSelection%" NEQ "BL" goto:SKIPBlueSM
set MyM=*
if /i "%FIRM%" EQU "4.3" set DarkWii_Blue_4.3J=*
if /i "%FIRM%" EQU "4.2" set DarkWii_Blue_4.2J=*
if /i "%FIRM%" EQU "4.1" set DarkWii_Blue_4.1J=*
:SKIPBlueSM

if /i "%ThemeSelection%" NEQ "O" goto:SKIPOrangeSM
set MyM=*
if /i "%FIRM%" EQU "4.3" set darkwii_orange_4.3J=*
if /i "%FIRM%" EQU "4.2" set darkwii_orange_4.2J=*
if /i "%FIRM%" EQU "4.1" set darkwii_orange_4.1J=*
:SKIPOrangeSM

:SKIPSM

if /i "%PIC%" EQU "Y" set P=*
if /i "%NET%" EQU "Y" set IJ=*
if /i "%WEATHER%" EQU "Y" set WJ=*
if /i "%NEWS%" EQU "Y" set NJ=*
if /i "%SHOP%" EQU "Y" set S=*
if /i "%SPEAK%" EQU "Y" set WSJ=*
goto:BUGGEDSMIOS



:K
if /i "%firmwarechange%" EQU "no" goto:nofirmwarechange

if /i "%ThemeSelection%" NEQ "N" goto:skip
if /i "%FIRM%" EQU "4.3" set SM4.3K=*
if /i "%FIRM%" EQU "4.2" set SM4.2K=*
if /i "%FIRM%" EQU "4.1" set SM4.1K=*
:skip

if /i "%ThemeSelection%" NEQ "R" goto:SKIPredSM
if /i "%FIRM%" EQU "4.3" set SM4.3K-DWR=*
if /i "%FIRM%" EQU "4.2" set SM4.2K-DWR=*
if /i "%FIRM%" EQU "4.1" set SM4.1K-DWR=*
goto:SKIPSM
:SKIPredSM

if /i "%ThemeSelection%" NEQ "G" goto:SKIPgreenSM
if /i "%FIRM%" EQU "4.3" set SM4.3K-DWG=*
if /i "%FIRM%" EQU "4.2" set SM4.2K-DWG=*
if /i "%FIRM%" EQU "4.1" set SM4.1K-DWG=*
goto:SKIPSM
:SKIPgreenSM

if /i "%ThemeSelection%" NEQ "BL" goto:SKIPblueSM
if /i "%FIRM%" EQU "4.3" set SM4.3K-DWB=*
if /i "%FIRM%" EQU "4.2" set SM4.2K-DWB=*
if /i "%FIRM%" EQU "4.1" set SM4.1K-DWB=*
goto:SKIPSM
:SKIPblueSM

if /i "%ThemeSelection%" NEQ "O" goto:SKIPorangeSM
if /i "%FIRM%" EQU "4.3" set SM4.3K-DWO=*
if /i "%FIRM%" EQU "4.2" set SM4.2K-DWO=*
if /i "%FIRM%" EQU "4.1" set SM4.1K-DWO=*
goto:SKIPSM
:SKIPorangeSM

:nofirmwarechange
if /i "%ThemeSelection%" NEQ "R" goto:SKIPredSM
set MyM=*
if /i "%FIRM%" EQU "4.3" set DarkWii_Red_4.3K=*
if /i "%FIRM%" EQU "4.2" set DarkWii_Red_4.2K=*
if /i "%FIRM%" EQU "4.1" set DarkWii_Red_4.1K=*
:SKIPredSM

if /i "%ThemeSelection%" NEQ "G" goto:SKIPgreenSM
set MyM=*
if /i "%FIRM%" EQU "4.3" set DarkWii_Green_4.3K=*
if /i "%FIRM%" EQU "4.2" set DarkWii_Green_4.2K=*
if /i "%FIRM%" EQU "4.1" set DarkWii_Green_4.1K=*
:SKIPgreenSM

if /i "%ThemeSelection%" NEQ "BL" goto:SKIPBlueSM
set MyM=*
if /i "%FIRM%" EQU "4.3" set DarkWii_Blue_4.3K=*
if /i "%FIRM%" EQU "4.2" set DarkWii_Blue_4.2K=*
if /i "%FIRM%" EQU "4.1" set DarkWii_Blue_4.1K=*
:SKIPBlueSM

if /i "%ThemeSelection%" NEQ "O" goto:SKIPOrangeSM
set MyM=*
if /i "%FIRM%" EQU "4.3" set darkwii_orange_4.3K=*
if /i "%FIRM%" EQU "4.2" set darkwii_orange_4.2K=*
if /i "%FIRM%" EQU "4.1" set darkwii_orange_4.1K=*
:SKIPOrangeSM

:SKIPSM

if /i "%PIC%" EQU "Y" set PK=*
if /i "%SHOP%" EQU "Y" set SK=*





:BUGGEDSMIOS
if /i "%FIRM%" EQU "%Firmstart%" goto:miniskip
if /i "%FIRM%" EQU "4.1" set IOS60P=*
if /i "%FIRM%" EQU "4.2" set IOS70K=*
if /i "%FIRM%" EQU "4.3" set IOS80K=*
:miniskip

if /i "%VIRGIN%" EQU "Y" goto:forceSMIOSs
if /i "%ACTIVEIOS%" EQU "off" goto:skipBuggedSMIOS
if /i "%UpdatesIOSQ%" EQU "N" goto:skipBuggedSMIOS
:forceSMIOSs
set IOS11P60=*
set IOS20P60=*
set IOS30P60=*
set IOS40P60=*
set IOS50P=*
set IOS52P=*
set IOS60P=*
set IOS70K=*
set IOS80K=*
:skipBuggedSMIOS

::for region changing guide
if /i "%MENU1%" NEQ "RC" goto:notRC
set mmm=*
set ARC=*
set pri=*
set bootmiisd=*
if /i "%REGION%" EQU "U" (set EULAU=*) & (set RSU=*)
if /i "%REGION%" EQU "E" (set EULAE=*) & (set RSE=*)
if /i "%REGION%" EQU "J" (set EULAJ=*) & (set RSJ=*)
if /i "%REGION%" EQU "K" (set EULAK=*) & (set RSK=*)
goto:DOWNLOADQUEUE
:notRC




:COMMONSETTINGS
if /i "%SHOP%" EQU "Y" set IOS56=*

if /i "%ACTIVEIOS%" EQU "off" goto:skipactiveios
if /i "%UpdatesIOSQ%" EQU "N" goto:skipactiveios
::if /i "%FIRMSTART%" EQU "4.3" goto:skipactiveios


:ACTIVEIOS
set mmm=*
set M10=*
set IOS9=*
set IOS12=*
set IOS13=*
set IOS14=*
set IOS15=*
set IOS17=*
set IOS21=*
set IOS22=*
set IOS28=*
set IOS31=*
set IOS33=*
set IOS34=*
set IOS35=*
if /i "%OPTION36%" EQU "on" set IOS36v3608=*
set IOS37=*
set IOS38=*
set ios41=*
set ios43=*
set ios45=*
set ios46=*
set IOS48v4124=*
set IOS53=*
set IOS55=*
set IOS56=*
set IOS57=*
set IOS58=*
set IOS61=*
set IOS62=*
:skipactiveios

if /i "%MIIQ%" EQU "Y" set Mii=*





if /i "%FWDOPTION%" EQU "on" (set usbx=*) & (set mmm=*)

if /i "%USBGUIDE%" NEQ "Y" goto:NoUSBSETUP
if /i "%LOADER%" EQU "CFG" set usbfolder=*
if /i "%LOADER%" EQU "ALL" set usbfolder=*
if /i "%LOADER%" EQU "FLOW" set FLOW=*
if /i "%LOADER%" EQU "ALL" set FLOW=*
set wbm=*
if /i "%FORMAT%" EQU "1" set f32=*
if /i "%FORMAT%" EQU "3" set f32=*
:NoUSBSETUP



if /i "%VIRGIN%" NEQ "Y" goto:notvirgin
:virgin
set HM=*
set bootmiisd=*
set IOS58=*
if /i "%FIRMSTART%" EQU "4.1" set BB1=*
if /i "%FIRMSTART%" EQU "4.0" set BB1=*
if /i "%FIRMSTART%" EQU "3.2" set BB1=*
if /i "%FIRMSTART%" EQU "3.x" set BB1=*
if /i "%FIRMSTART%" EQU "4.2" set BB2=*
if /i "%EXPLOIT%" EQU "W" set Wilbrand=*
if /i "%EXPLOIT%" EQU "S" set SMASH=*
if /i "%EXPLOIT%" EQU "L" set PWNS=*
if /i "%EXPLOIT%" EQU "T" set Twi=*
if /i "%EXPLOIT%" EQU "Y" set YUGI=*
if /i "%EXPLOIT%" EQU "LB" set Bathaxx=*
if /i "%EXPLOIT%" EQU "LS" set ROTJ=*
if /i "%EXPLOIT%" EQU "TOS" set TOS=*
if /i "%EXPLOIT%" NEQ "?" goto:notallexploits
if /i "%FIRMSTART%" EQU "o" set Twi=*
set SMASH=*
if /i "%REGION%" NEQ "K" set PWNS=*
if /i "%REGION%" NEQ "K" set YUGI=*
if /i "%REGION%" NEQ "K" set Bathaxx=*
if /i "%REGION%" NEQ "K" set ROTJ=*
if /i "%REGION%" NEQ "K" set TOS=*
:notallexploits

::set IOS236=*
set IOS236Installer=*
set SIP=*
set IOS36=*

set cIOS202[60]-v5.1R=*
set cIOS222[38]-v4=*
set cIOS223[37-38]-v4=*
set cIOS224[57]-v5.1R=*
set cIOS249[56]-d2x-v8-final=*
set cIOS250[57]-d2x-v8-final=*



if /i "%CMIOSOPTION%" EQU "on" set RVL-cMIOS-v65535(v10)_WiiGator_WiiPower_v0.2=*
if /i "%CMIOSOPTION%" EQU "on" set M10=
set pri=*
::set HAX=*
set mmm=*

goto:DOWNLOADQUEUE



:notvirgin

::set mmm=*
if /i "%PIC%" EQU "Y" set mmm=*
if /i "%NET%" EQU "Y" set mmm=*
if /i "%WEATHER%" EQU "Y" set mmm=*
if /i "%NEWS%" EQU "Y" set mmm=*
if /i "%SHOP%" EQU "Y" set mmm=*
if /i "%SPEAK%" EQU "Y" set mmm=*

if /i "%HMInstaller%" NEQ "Y" goto:noHMInstallerforNonVirgin
set HM=*
set bootmiisd=*
set IOS58=*
set mmm=*
::if /i "%FIRMSTART%" EQU "4.1" set BB1=*
::if /i "%FIRMSTART%" EQU "4.0" set BB1=*
::if /i "%FIRMSTART%" EQU "3.x" set BB1=*
::if /i "%FIRMSTART%" EQU "3.2" set BB1=*
::if /i "%FIRMSTART%" EQU "4.2" set BB2=*

if /i "%FIRMSTART%" EQU "o" goto:gonow
if /i "%FIRMSTART%" EQU "4.3" goto:gonow
goto:skipextra2

:gonow
::if /i "%FIRMSTART%" EQU "o" set TWI=*
::set SMASH=*
::if /i "%REGION%" NEQ "K" set PWNS=*
::if /i "%REGION%" NEQ "K" set YUGI=*
::if /i "%REGION%" NEQ "K" set Bathaxx=*
::if /i "%REGION%" NEQ "K" set ROTJ=*
::if /i "%REGION%" NEQ "K" set TOS=*
:skipextra2

:noHMInstallerforNonVirgin

if /i "%FIRM%" NEQ "%FIRMSTART%" set mmm=*

if /i "%IOS236InstallerQ%" EQU "Y" (set IOS236Installer=*) & (set SIP=*) & (set IOS36=*)
::if /i "%IOS236InstallerQ%" EQU "Y" (set IOS236=*) & (set mmm=*)

if /i "%RECCIOS%" EQU "Y" set mmm=*
if /i "%RECCIOS%" EQU "Y" set cIOS202[60]-v5.1R=*
if /i "%RECCIOS%" EQU "Y" set cIOS222[38]-v4=*
if /i "%RECCIOS%" EQU "Y" set cIOS223[37-38]-v4=*
if /i "%RECCIOS%" EQU "Y" set cIOS224[57]-v5.1R=*
if /i "%RECCIOS%" EQU "Y" set cIOS249[56]-d2x-v8-final=*
if /i "%RECCIOS%" EQU "Y" set cIOS250[57]-d2x-v8-final=*

if /i "%CMIOSOPTION%" EQU "off" goto:quickskip
if /i "%RECCIOS%" EQU "Y" set RVL-cMIOS-v65535(v10)_WiiGator_WiiPower_v0.2=*
if /i "%RECCIOS%" EQU "Y" set M10=
:quickskip

if /i "%yawmQ%" EQU "Y" set YAWM=*


if /i "%PRIQ%" NEQ "Y" goto:DOWNLOADQUEUE
set pri=*
goto:DOWNLOADQUEUE



::...................................PICK Download Queue...............................
:PICKDOWNLOADQUEUE

dir temp\DownloadQueues /a:-d /b>temp\list.txt

::support\sfk filter -quiet temp\list.txt -le+".bat" -rep _".bat"__ -write -yes
support\sfk filter -quiet temp\list.txt -le+".bat" -write -yes

::count # of folders in advance to set "mode"
setlocal ENABLEDELAYEDEXPANSION
SET DLQUEUEtotal=0
for /f "delims=" %%i in (temp\list.txt) do set /a DLQUEUEtotal=!DLQUEUEtotal!+1
setlocal DISABLEDELAYEDEXPANSION

SET /a LINES=%DLQUEUEtotal%+29
if %LINES% LEQ 54 goto:noresize
mode con cols=85 lines=%LINES%
:noresize


set DLQUEUE=
cls
echo                                        ModMii                                v%currentversion%
echo                                       by XFlak
echo.
echo.
echo                    Select the Download Queue you would like to load:
echo.
echo.


if /i "%DLQUEUEtotal%" NEQ "0" goto:notzero

echo                               No Download Queues Found
echo.
echo          Before you can load a queue you have to save one using ModMii
echo          Or if loading a queue a friend has shared with you, just drag
echo          and drop it onto ModMii.exe or a shortcut to ModMii.
echo.
echo.
echo          Note: Download Queues are saved to "temp\DownloadQueues"
echo                and can be shared amongst different ModMii users.
echo.
echo                You can drag and drop a download queue onto ModMii.exe
echo                to load it and save a copy to "temp\DownloadQueues"
echo                for future use. To delete a queue from the above list
echo                just delete the appropriate file from "temp\DownloadQueues"
echo.
echo.
echo Press any key to return to the Main Menu.
echo.
pause>nul
goto:MENU

:notzero

echo.

set DLQUEUEnum=0

::Loop through the the following once for EACH line in *.txt
for /F "tokens=*" %%A in (temp\list.txt) do call :processlist6 %%A
goto:quickskip
:processlist6
set /a DLQUEUEnum=%DLQUEUEnum%+1
set whatev=%*
echo       %DLQUEUEnum% = %whatev:~0,-4%
goto:EOF
:quickskip

echo.
echo.
echo          Note: Download Queues are saved to "temp\DownloadQueues"
echo                and can be shared amongst different ModMii users.
echo.
echo                You can drag and drop a download queue onto ModMii.exe
echo                to load it and save a copy to "temp\DownloadQueues"
echo                for future use. To delete a queue from the above list
echo                just delete the appropriate file from "temp\DownloadQueues"
echo.
echo.
echo.
echo                B = Back
echo.
echo                M = Main Menu
echo.
echo.
set /p DLQUEUE=     Enter Selection Here: 

if /i "%DLQUEUE%" EQU "M" (mode con cols=85 lines=54) & (goto:MENU)
if /i "%DLQUEUE%" EQU "B" (mode con cols=85 lines=54) & (goto:MENU)

if "%DLQUEUE%"=="" goto:badkey

if %DLQUEUE% LSS 1 goto:badkey
if /i %DLQUEUE% GTR %DLQUEUEnum% goto:badkey


set DLQUEUEnum2=0
::Loop through the the following once for EACH line in *.txt
for /F "tokens=*" %%A in (temp\list.txt) do call :processlist5 %%A
goto:quickskip
:processlist5
set CurrentQueue=%*
set /a DLQUEUEnum2=%DLQUEUEnum2%+1
if not exist "temp\DownloadQueues\%CurrentQueue%" goto:EOF
if /i "%DLQUEUEnum2%" EQU "%DLQUEUE%" goto:quickskip
goto:EOF

:quickskip
del temp\list.txt>nul


findStr /I /C:":endofqueue" "temp\DownloadQueues\%CurrentQueue%" >nul
IF ERRORLEVEL 1 (echo Not a valid download queue...) & (goto:badkey)


mode con cols=85 lines=54
:forcmdlineL
call "temp\DownloadQueues\%CurrentQueue%"
goto:DownloadQueue


:badkey
echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:PICKDOWNLOADQUEUE





::...................................Download Queue...............................
:DOWNLOADQUEUE
set settings=

if /i "%cmdguide%" EQU "G" set settings=G


set d2x-beta-rev=8-final
if exist support\d2x-beta\d2x-beta.bat call support\d2x-beta\d2x-beta.bat

::--------------
::d2x check for changed DL names and md5's for Advanced downloads only
if /i "%MENU1%" NEQ "L" goto:DLCOUNT
if not exist temp\DLnamesADV.txt goto:DLCOUNT
findStr "d2x" temp\DLnamesADV.txt >nul
IF ERRORLEVEL 1 goto:DLCOUNT


::split out default d2x cIOSs and force "8-final" (ie. set d2x-beta-rev=8-final)
support\sfk filter -spat "temp\DownloadQueues\%CurrentQueue%" -ls+"SET cIOS" -le+"\x3d\x2a">temp\temp.bat
support\sfk filter -spat temp\temp.bat ++"-d2x-v" -rep _"-d2x-"*_"-d2x-v8-final\x3d\x2a"_ -write -yes>nul
call temp\temp.bat



FINDSTR /N . temp\DLnamesADV.txt>temp\DLnamesADVcheck.txt
support\sfk filter -quiet temp\DLnamesADVcheck.txt -+d2x -rep _cIOS*[_cIOS249[_ -rep _"Advanced Download: "__ -write -yes

set loadorgo=load4queue

::Loop through the the following once for EACH line in *.txt
for /F "tokens=*" %%A in (temp\DLnamesADVcheck.txt) do call :processDLCheck %%A
goto:quickskip
:processDLCheck

set advDLCheck=%*

echo set advDLcheckNUM=%advDLCheck%>temp\advDLcheckNUM.bat
support\sfk filter -quiet temp\advDLcheckNUM.bat -rep _:*__ -write -yes
call temp\advDLcheckNUM.bat
del temp\advDLcheckNUM.bat>nul

echo %advDLCheck%>temp\advDLcheck.bat
support\sfk filter -quiet temp\advDLcheck.bat -rep _"%advDLcheckNUM%:"_"set advDLcheck="_ -write -yes
call temp\advDLcheck.bat
del temp\advDLcheck.bat>nul


call temp\AdvDL%advDLcheckNUM%.bat
set oldfullname=%name%

set advDLCheck0=%advDLCheck%

set d2x-beta-rev=8-final
set advDLCheck=%advDLCheck:~0,17%%d2x-beta-rev%
if exist support\d2x-beta\d2x-beta.bat call support\d2x-beta\d2x-beta.bat

set string=%d2x-beta-rev%
set d2xVersionLength=0

:loopd2xVersionLength
if defined string (
    set string=%string:~1%
    set /A d2xVersionLength += 1
    goto:loopd2xVersionLength
    )

echo set alt-d2x-beta-rev=@advDLcheck0:~17,%d2xVersionLength%@>temp\d2x-beta-rev.bat
support\sfk filter temp\d2x-beta-rev.bat -spat -rep _@_%%_ -write -yes>nul
call temp\d2x-beta-rev.bat
del temp\d2x-beta-rev.bat>nul

if /i "%d2x-beta-rev%" EQU "%alt-d2x-beta-rev%" goto:EOF

goto:%advDLCheck%


:processDLCheck2

set slotnum=%slotcode:~7%
if "%slotnum%"=="" set slotnum=249
set newname=cIOS%slotnum%%basecios:~7,10%%d2x-beta-rev%

::update temp\AdvDL#.bat
support\sfk filter -quiet temp\AdvDL%advDLcheckNUM%.bat -rep _"set MD5="*_"set MD5=%MD5%"_ -rep _"set md5alt="*_"set md5alt=%md5alt%"_ -rep _"set ciosversion="*_"set ciosversion=%ciosversion%"_ -rep _"Advanced Download: "*_"Advanced Download: %newname%%versionname%"_ -rep _"set wadname="*_"set wadname=%wadname%"_ -rep _"set wadnameless="*_"set wadnameless=%newname%"_ -write -yes

::update temp\DLnamesADV.txt
support\sfk filter -quiet temp\DLnamesADV.txt -lerep _"%oldfullname% "_"Advanced Download: %newname%%versionname%"_ -write -yes
goto:EOF
:quickskip

if exist temp\DLnamesADVcheck.txt del temp\DLnamesADVcheck.txt>nul
set loadorgo=go
::---------------------


::Count how many downloads there are!
:DLCOUNT

if exist temp\DLnames.txt del temp\DLnames.txt>nul
if exist temp\DLgotos.txt del temp\DLgotos.txt>nul


::---------------CMD LINE MODE-------------
if /i "%one%" NEQ "U" goto:nocmdlineusbloadersettings
if /i "%LOADER%" EQU "CFG" set usbfolder=*
if /i "%LOADER%" EQU "ALL" set usbfolder=*
if /i "%LOADER%" EQU "FLOW" set FLOW=*
if /i "%LOADER%" EQU "ALL" set FLOW=*
set wbm=*
if /i "%FORMAT%" EQU "1" set f32=*
if /i "%FORMAT%" EQU "3" set f32=*
:nocmdlineusbloadersettings



if /i "%EULAU%" EQU "*" (echo "EULA v3 (USA)">>temp\DLnames.txt) & (echo "EULAU">>temp\DLgotos.txt)
if /i "%EULAE%" EQU "*" (echo "EULA v3 (PAL)">>temp\DLnames.txt) & (echo "EULAE">>temp\DLgotos.txt)
if /i "%EULAJ%" EQU "*" (echo "EULA v3 (JAP)">>temp\DLnames.txt) & (echo "EULAJ">>temp\DLgotos.txt)
if /i "%EULAK%" EQU "*" (echo "EULA v3 (KOR)">>temp\DLnames.txt) & (echo "EULAK">>temp\DLgotos.txt)
if /i "%RSU%" EQU "*" (echo "Region Select v2 (USA)">>temp\DLnames.txt) & (echo "RSU">>temp\DLgotos.txt)
if /i "%RSE%" EQU "*" (echo "Region Select v2 (PAL)">>temp\DLnames.txt) & (echo "RSE">>temp\DLgotos.txt)
if /i "%RSJ%" EQU "*" (echo "Region Select v2 (JAP)">>temp\DLnames.txt) & (echo "RSJ">>temp\DLgotos.txt)
if /i "%RSK%" EQU "*" (echo "Region Select v2 (KOR)">>temp\DLnames.txt) & (echo "RSK">>temp\DLgotos.txt)
if /i "%BC%" EQU "*" (echo "BC">>temp\DLnames.txt) & (echo "BC">>temp\DLgotos.txt)
if /i "%cBC%" EQU "*" (echo "NMM">>temp\DLnames.txt) & (echo "NMM">>temp\DLgotos.txt)
if /i "%DML%" EQU "*" (echo "DML %CurrentDMLRev% ">>temp\DLnames.txt) & (echo "DML">>temp\DLgotos.txt)
if /i "%SM3.2U%" EQU "*" (echo "System Menu 3.2U">>temp\DLnames.txt) & (echo "SM3.2U">>temp\DLgotos.txt)
if /i "%SM4.1U%" EQU "*" (echo "System Menu 4.1U">>temp\DLnames.txt) & (echo "SM4.1U">>temp\DLgotos.txt)
if /i "%SM4.2U%" EQU "*" (echo "System Menu 4.2U">>temp\DLnames.txt) & (echo "SM4.2U">>temp\DLgotos.txt)
if /i "%SM4.3U%" EQU "*" (echo "System Menu 4.3U">>temp\DLnames.txt) & (echo "SM4.3U">>temp\DLgotos.txt)
if /i "%SM3.2E%" EQU "*" (echo "System Menu 3.2E">>temp\DLnames.txt) & (echo "SM3.2E">>temp\DLgotos.txt)
if /i "%SM4.1E%" EQU "*" (echo "System Menu 4.1E">>temp\DLnames.txt) & (echo "SM4.1E">>temp\DLgotos.txt)
if /i "%SM4.2E%" EQU "*" (echo "System Menu 4.2E">>temp\DLnames.txt) & (echo "SM4.2E">>temp\DLgotos.txt)
if /i "%SM4.3E%" EQU "*" (echo "System Menu 4.3E">>temp\DLnames.txt) & (echo "SM4.3E">>temp\DLgotos.txt)
if /i "%SM3.2J%" EQU "*" (echo "System Menu 3.2J">>temp\DLnames.txt) & (echo "SM3.2J">>temp\DLgotos.txt)
if /i "%SM4.1J%" EQU "*" (echo "System Menu 4.1J">>temp\DLnames.txt) & (echo "SM4.1J">>temp\DLgotos.txt)
if /i "%SM4.2J%" EQU "*" (echo "System Menu 4.2J">>temp\DLnames.txt) & (echo "SM4.2J">>temp\DLgotos.txt)
if /i "%SM4.3J%" EQU "*" (echo "System Menu 4.3J">>temp\DLnames.txt) & (echo "SM4.3J">>temp\DLgotos.txt)
if /i "%SM4.1K%" EQU "*" (echo "System Menu 4.1K">>temp\DLnames.txt) & (echo "SM4.1K">>temp\DLgotos.txt)
if /i "%SM4.2K%" EQU "*" (echo "System Menu 4.2K">>temp\DLnames.txt) & (echo "SM4.2K">>temp\DLgotos.txt)
if /i "%SM4.3K%" EQU "*" (echo "System Menu 4.3K">>temp\DLnames.txt) & (echo "SM4.3K">>temp\DLgotos.txt)

if /i "%SM4.1U-DWR%" EQU "*" (echo "System Menu 4.1U with Dark Wii Red Theme - %effect%">>temp\DLnames.txt) & (echo "SM4.1U-DWR">>temp\DLgotos.txt)
if /i "%SM4.2U-DWR%" EQU "*" (echo "System Menu 4.2U with Dark Wii Red Theme - %effect%">>temp\DLnames.txt) & (echo "SM4.2U-DWR">>temp\DLgotos.txt)
if /i "%SM4.3U-DWR%" EQU "*" (echo "System Menu 4.3U with Dark Wii Red Theme - %effect%">>temp\DLnames.txt) & (echo "SM4.3U-DWR">>temp\DLgotos.txt)
if /i "%SM4.1E-DWR%" EQU "*" (echo "System Menu 4.1E with Dark Wii Red Theme - %effect%">>temp\DLnames.txt) & (echo "SM4.1E-DWR">>temp\DLgotos.txt)
if /i "%SM4.2E-DWR%" EQU "*" (echo "System Menu 4.2E with Dark Wii Red Theme - %effect%">>temp\DLnames.txt) & (echo "SM4.2E-DWR">>temp\DLgotos.txt)
if /i "%SM4.3E-DWR%" EQU "*" (echo "System Menu 4.3E with Dark Wii Red Theme - %effect%">>temp\DLnames.txt) & (echo "SM4.3E-DWR">>temp\DLgotos.txt)
if /i "%SM4.1J-DWR%" EQU "*" (echo "System Menu 4.1J with Dark Wii Red Theme - %effect%">>temp\DLnames.txt) & (echo "SM4.1J-DWR">>temp\DLgotos.txt)
if /i "%SM4.2J-DWR%" EQU "*" (echo "System Menu 4.2J with Dark Wii Red Theme - %effect%">>temp\DLnames.txt) & (echo "SM4.2J-DWR">>temp\DLgotos.txt)
if /i "%SM4.3J-DWR%" EQU "*" (echo "System Menu 4.3J with Dark Wii Red Theme - %effect%">>temp\DLnames.txt) & (echo "SM4.3J-DWR">>temp\DLgotos.txt)
if /i "%SM4.1K-DWR%" EQU "*" (echo "System Menu 4.1K with Dark Wii Red Theme - %effect%">>temp\DLnames.txt) & (echo "SM4.1K-DWR">>temp\DLgotos.txt)
if /i "%SM4.2K-DWR%" EQU "*" (echo "System Menu 4.2K with Dark Wii Red Theme - %effect%">>temp\DLnames.txt) & (echo "SM4.2K-DWR">>temp\DLgotos.txt)
if /i "%SM4.3K-DWR%" EQU "*" (echo "System Menu 4.3K with Dark Wii Red Theme - %effect%">>temp\DLnames.txt) & (echo "SM4.3K-DWR">>temp\DLgotos.txt)

if /i "%SM4.1U-DWG%" EQU "*" (echo "System Menu 4.1U with Dark Wii Green Theme - %effect%">>temp\DLnames.txt) & (echo "SM4.1U-DWG">>temp\DLgotos.txt)
if /i "%SM4.2U-DWG%" EQU "*" (echo "System Menu 4.2U with Dark Wii Green Theme - %effect%">>temp\DLnames.txt) & (echo "SM4.2U-DWG">>temp\DLgotos.txt)
if /i "%SM4.3U-DWG%" EQU "*" (echo "System Menu 4.3U with Dark Wii Green Theme - %effect%">>temp\DLnames.txt) & (echo "SM4.3U-DWG">>temp\DLgotos.txt)
if /i "%SM4.1E-DWG%" EQU "*" (echo "System Menu 4.1E with Dark Wii Green Theme - %effect%">>temp\DLnames.txt) & (echo "SM4.1E-DWG">>temp\DLgotos.txt)
if /i "%SM4.2E-DWG%" EQU "*" (echo "System Menu 4.2E with Dark Wii Green Theme - %effect%">>temp\DLnames.txt) & (echo "SM4.2E-DWG">>temp\DLgotos.txt)
if /i "%SM4.3E-DWG%" EQU "*" (echo "System Menu 4.3E with Dark Wii Green Theme - %effect%">>temp\DLnames.txt) & (echo "SM4.3E-DWG">>temp\DLgotos.txt)
if /i "%SM4.1J-DWG%" EQU "*" (echo "System Menu 4.1J with Dark Wii Green Theme - %effect%">>temp\DLnames.txt) & (echo "SM4.1J-DWG">>temp\DLgotos.txt)
if /i "%SM4.2J-DWG%" EQU "*" (echo "System Menu 4.2J with Dark Wii Green Theme - %effect%">>temp\DLnames.txt) & (echo "SM4.2J-DWG">>temp\DLgotos.txt)
if /i "%SM4.3J-DWG%" EQU "*" (echo "System Menu 4.3J with Dark Wii Green Theme - %effect%">>temp\DLnames.txt) & (echo "SM4.3J-DWG">>temp\DLgotos.txt)
if /i "%SM4.1K-DWG%" EQU "*" (echo "System Menu 4.1K with Dark Wii Green Theme - %effect%">>temp\DLnames.txt) & (echo "SM4.1K-DWG">>temp\DLgotos.txt)
if /i "%SM4.2K-DWG%" EQU "*" (echo "System Menu 4.2K with Dark Wii Green Theme - %effect%">>temp\DLnames.txt) & (echo "SM4.2K-DWG">>temp\DLgotos.txt)
if /i "%SM4.3K-DWG%" EQU "*" (echo "System Menu 4.3K with Dark Wii Green Theme - %effect%">>temp\DLnames.txt) & (echo "SM4.3K-DWG">>temp\DLgotos.txt)

if /i "%SM4.1U-DWB%" EQU "*" (echo "System Menu 4.1U with Dark Wii Blue Theme - %effect%">>temp\DLnames.txt) & (echo "SM4.1U-DWB">>temp\DLgotos.txt)
if /i "%SM4.2U-DWB%" EQU "*" (echo "System Menu 4.2U with Dark Wii Blue Theme - %effect%">>temp\DLnames.txt) & (echo "SM4.2U-DWB">>temp\DLgotos.txt)
if /i "%SM4.3U-DWB%" EQU "*" (echo "System Menu 4.3U with Dark Wii Blue Theme - %effect%">>temp\DLnames.txt) & (echo "SM4.3U-DWB">>temp\DLgotos.txt)
if /i "%SM4.1E-DWB%" EQU "*" (echo "System Menu 4.1E with Dark Wii Blue Theme - %effect%">>temp\DLnames.txt) & (echo "SM4.1E-DWB">>temp\DLgotos.txt)
if /i "%SM4.2E-DWB%" EQU "*" (echo "System Menu 4.2E with Dark Wii Blue Theme - %effect%">>temp\DLnames.txt) & (echo "SM4.2E-DWB">>temp\DLgotos.txt)
if /i "%SM4.3E-DWB%" EQU "*" (echo "System Menu 4.3E with Dark Wii Blue Theme - %effect%">>temp\DLnames.txt) & (echo "SM4.3E-DWB">>temp\DLgotos.txt)
if /i "%SM4.1J-DWB%" EQU "*" (echo "System Menu 4.1J with Dark Wii Blue Theme - %effect%">>temp\DLnames.txt) & (echo "SM4.1J-DWB">>temp\DLgotos.txt)
if /i "%SM4.2J-DWB%" EQU "*" (echo "System Menu 4.2J with Dark Wii Blue Theme - %effect%">>temp\DLnames.txt) & (echo "SM4.2J-DWB">>temp\DLgotos.txt)
if /i "%SM4.3J-DWB%" EQU "*" (echo "System Menu 4.3J with Dark Wii Blue Theme - %effect%">>temp\DLnames.txt) & (echo "SM4.3J-DWB">>temp\DLgotos.txt)
if /i "%SM4.1K-DWB%" EQU "*" (echo "System Menu 4.1K with Dark Wii Blue Theme - %effect%">>temp\DLnames.txt) & (echo "SM4.1K-DWB">>temp\DLgotos.txt)
if /i "%SM4.2K-DWB%" EQU "*" (echo "System Menu 4.2K with Dark Wii Blue Theme - %effect%">>temp\DLnames.txt) & (echo "SM4.2K-DWB">>temp\DLgotos.txt)
if /i "%SM4.3K-DWB%" EQU "*" (echo "System Menu 4.3K with Dark Wii Blue Theme - %effect%">>temp\DLnames.txt) & (echo "SM4.3K-DWB">>temp\DLgotos.txt)

if /i "%SM4.1U-DWO%" EQU "*" (echo "System Menu 4.1U with Dark Wii Orange Theme - %effect%">>temp\DLnames.txt) & (echo "SM4.1U-DWO">>temp\DLgotos.txt)
if /i "%SM4.2U-DWO%" EQU "*" (echo "System Menu 4.2U with Dark Wii Orange Theme - %effect%">>temp\DLnames.txt) & (echo "SM4.2U-DWO">>temp\DLgotos.txt)
if /i "%SM4.3U-DWO%" EQU "*" (echo "System Menu 4.3U with Dark Wii Orange Theme - %effect%">>temp\DLnames.txt) & (echo "SM4.3U-DWO">>temp\DLgotos.txt)
if /i "%SM4.1E-DWO%" EQU "*" (echo "System Menu 4.1E with Dark Wii Orange Theme - %effect%">>temp\DLnames.txt) & (echo "SM4.1E-DWO">>temp\DLgotos.txt)
if /i "%SM4.2E-DWO%" EQU "*" (echo "System Menu 4.2E with Dark Wii Orange Theme - %effect%">>temp\DLnames.txt) & (echo "SM4.2E-DWO">>temp\DLgotos.txt)
if /i "%SM4.3E-DWO%" EQU "*" (echo "System Menu 4.3E with Dark Wii Orange Theme - %effect%">>temp\DLnames.txt) & (echo "SM4.3E-DWO">>temp\DLgotos.txt)
if /i "%SM4.1J-DWO%" EQU "*" (echo "System Menu 4.1J with Dark Wii Orange Theme - %effect%">>temp\DLnames.txt) & (echo "SM4.1J-DWO">>temp\DLgotos.txt)
if /i "%SM4.2J-DWO%" EQU "*" (echo "System Menu 4.2J with Dark Wii Orange Theme - %effect%">>temp\DLnames.txt) & (echo "SM4.2J-DWO">>temp\DLgotos.txt)
if /i "%SM4.3J-DWO%" EQU "*" (echo "System Menu 4.3J with Dark Wii Orange Theme - %effect%">>temp\DLnames.txt) & (echo "SM4.3J-DWO">>temp\DLgotos.txt)
if /i "%SM4.1K-DWO%" EQU "*" (echo "System Menu 4.1K with Dark Wii Orange Theme - %effect%">>temp\DLnames.txt) & (echo "SM4.1K-DWO">>temp\DLgotos.txt)
if /i "%SM4.2K-DWO%" EQU "*" (echo "System Menu 4.2K with Dark Wii Orange Theme - %effect%">>temp\DLnames.txt) & (echo "SM4.2K-DWO">>temp\DLgotos.txt)
if /i "%SM4.3K-DWO%" EQU "*" (echo "System Menu 4.3K with Dark Wii Orange Theme - %effect%">>temp\DLnames.txt) & (echo "SM4.3K-DWO">>temp\DLgotos.txt)

if /i "%DarkWii_Red_4.1U%" EQU "*" (echo "DarkWii Red Theme (4.1U) - %effect%">>temp\DLnames.txt) & (echo "DarkWii_Red_4.1U">>temp\DLgotos.txt)
if /i "%DarkWii_Red_4.2U%" EQU "*" (echo "DarkWii Red Theme (4.2U) - %effect%">>temp\DLnames.txt) & (echo "DarkWii_Red_4.2U">>temp\DLgotos.txt)
if /i "%DarkWii_Red_4.3U%" EQU "*" (echo "DarkWii Red Theme (4.3U) - %effect%">>temp\DLnames.txt) & (echo "DarkWii_Red_4.3U">>temp\DLgotos.txt)
if /i "%DarkWii_Red_4.1E%" EQU "*" (echo "DarkWii Red Theme (4.1E) - %effect%">>temp\DLnames.txt) & (echo "DarkWii_Red_4.1E">>temp\DLgotos.txt)
if /i "%DarkWii_Red_4.2E%" EQU "*" (echo "DarkWii Red Theme (4.2E) - %effect%">>temp\DLnames.txt) & (echo "DarkWii_Red_4.2E">>temp\DLgotos.txt)
if /i "%DarkWii_Red_4.3E%" EQU "*" (echo "DarkWii Red Theme (4.3E) - %effect%">>temp\DLnames.txt) & (echo "DarkWii_Red_4.3E">>temp\DLgotos.txt)
if /i "%DarkWii_Red_4.1J%" EQU "*" (echo "DarkWii Red Theme (4.1J) - %effect%">>temp\DLnames.txt) & (echo "DarkWii_Red_4.1J">>temp\DLgotos.txt)
if /i "%DarkWii_Red_4.2J%" EQU "*" (echo "DarkWii Red Theme (4.2J) - %effect%">>temp\DLnames.txt) & (echo "DarkWii_Red_4.2J">>temp\DLgotos.txt)
if /i "%DarkWii_Red_4.3J%" EQU "*" (echo "DarkWii Red Theme (4.3J) - %effect%">>temp\DLnames.txt) & (echo "DarkWii_Red_4.3J">>temp\DLgotos.txt)
if /i "%DarkWii_Red_4.1K%" EQU "*" (echo "DarkWii Red Theme (4.1K) - %effect%">>temp\DLnames.txt) & (echo "DarkWii_Red_4.1K">>temp\DLgotos.txt)
if /i "%DarkWii_Red_4.2K%" EQU "*" (echo "DarkWii Red Theme (4.2K) - %effect%">>temp\DLnames.txt) & (echo "DarkWii_Red_4.2K">>temp\DLgotos.txt)
if /i "%DarkWii_Red_4.3K%" EQU "*" (echo "DarkWii Red Theme (4.3K) - %effect%">>temp\DLnames.txt) & (echo "DarkWii_Red_4.3K">>temp\DLgotos.txt)

if /i "%DarkWii_Green_4.1U%" EQU "*" (echo "DarkWii Green Theme (4.1U) - %effect%">>temp\DLnames.txt) & (echo "DarkWii_Green_4.1U">>temp\DLgotos.txt)
if /i "%DarkWii_Green_4.2U%" EQU "*" (echo "DarkWii Green Theme (4.2U) - %effect%">>temp\DLnames.txt) & (echo "DarkWii_Green_4.2U">>temp\DLgotos.txt)
if /i "%DarkWii_Green_4.3U%" EQU "*" (echo "DarkWii Green Theme (4.3U) - %effect%">>temp\DLnames.txt) & (echo "DarkWii_Green_4.3U">>temp\DLgotos.txt)
if /i "%DarkWii_Green_4.1E%" EQU "*" (echo "DarkWii Green Theme (4.1E) - %effect%">>temp\DLnames.txt) & (echo "DarkWii_Green_4.1E">>temp\DLgotos.txt)
if /i "%DarkWii_Green_4.2E%" EQU "*" (echo "DarkWii Green Theme (4.2E) - %effect%">>temp\DLnames.txt) & (echo "DarkWii_Green_4.2E">>temp\DLgotos.txt)
if /i "%DarkWii_Green_4.3E%" EQU "*" (echo "DarkWii Green Theme (4.3E) - %effect%">>temp\DLnames.txt) & (echo "DarkWii_Green_4.3E">>temp\DLgotos.txt)
if /i "%DarkWii_Green_4.1J%" EQU "*" (echo "DarkWii Green Theme (4.1J) - %effect%">>temp\DLnames.txt) & (echo "DarkWii_Green_4.1J">>temp\DLgotos.txt)
if /i "%DarkWii_Green_4.2J%" EQU "*" (echo "DarkWii Green Theme (4.2J) - %effect%">>temp\DLnames.txt) & (echo "DarkWii_Green_4.2J">>temp\DLgotos.txt)
if /i "%DarkWii_Green_4.3J%" EQU "*" (echo "DarkWii Green Theme (4.3J) - %effect%">>temp\DLnames.txt) & (echo "DarkWii_Green_4.3J">>temp\DLgotos.txt)
if /i "%DarkWii_Green_4.1K%" EQU "*" (echo "DarkWii Green Theme (4.1K) - %effect%">>temp\DLnames.txt) & (echo "DarkWii_Green_4.1K">>temp\DLgotos.txt)
if /i "%DarkWii_Green_4.2K%" EQU "*" (echo "DarkWii Green Theme (4.2K) - %effect%">>temp\DLnames.txt) & (echo "DarkWii_Green_4.2K">>temp\DLgotos.txt)
if /i "%DarkWii_Green_4.3K%" EQU "*" (echo "DarkWii Green Theme (4.3K) - %effect%">>temp\DLnames.txt) & (echo "DarkWii_Green_4.3K">>temp\DLgotos.txt)

if /i "%DarkWii_Blue_4.1U%" EQU "*" (echo "DarkWii Blue Theme (4.1U) - %effect%">>temp\DLnames.txt) & (echo "DarkWii_Blue_4.1U">>temp\DLgotos.txt)
if /i "%DarkWii_Blue_4.2U%" EQU "*" (echo "DarkWii Blue Theme (4.2U) - %effect%">>temp\DLnames.txt) & (echo "DarkWii_Blue_4.2U">>temp\DLgotos.txt)
if /i "%DarkWii_Blue_4.3U%" EQU "*" (echo "DarkWii Blue Theme (4.3U) - %effect%">>temp\DLnames.txt) & (echo "DarkWii_Blue_4.3U">>temp\DLgotos.txt)
if /i "%DarkWii_Blue_4.1E%" EQU "*" (echo "DarkWii Blue Theme (4.1E) - %effect%">>temp\DLnames.txt) & (echo "DarkWii_Blue_4.1E">>temp\DLgotos.txt)
if /i "%DarkWii_Blue_4.2E%" EQU "*" (echo "DarkWii Blue Theme (4.2E) - %effect%">>temp\DLnames.txt) & (echo "DarkWii_Blue_4.2E">>temp\DLgotos.txt)
if /i "%DarkWii_Blue_4.3E%" EQU "*" (echo "DarkWii Blue Theme (4.3E) - %effect%">>temp\DLnames.txt) & (echo "DarkWii_Blue_4.3E">>temp\DLgotos.txt)
if /i "%DarkWii_Blue_4.1J%" EQU "*" (echo "DarkWii Blue Theme (4.1J) - %effect%">>temp\DLnames.txt) & (echo "DarkWii_Blue_4.1J">>temp\DLgotos.txt)
if /i "%DarkWii_Blue_4.2J%" EQU "*" (echo "DarkWii Blue Theme (4.2J) - %effect%">>temp\DLnames.txt) & (echo "DarkWii_Blue_4.2J">>temp\DLgotos.txt)
if /i "%DarkWii_Blue_4.3J%" EQU "*" (echo "DarkWii Blue Theme (4.3J) - %effect%">>temp\DLnames.txt) & (echo "DarkWii_Blue_4.3J">>temp\DLgotos.txt)
if /i "%DarkWii_Blue_4.1K%" EQU "*" (echo "DarkWii Blue Theme (4.1K) - %effect%">>temp\DLnames.txt) & (echo "DarkWii_Blue_4.1K">>temp\DLgotos.txt)
if /i "%DarkWii_Blue_4.2K%" EQU "*" (echo "DarkWii Blue Theme (4.2K) - %effect%">>temp\DLnames.txt) & (echo "DarkWii_Blue_4.2K">>temp\DLgotos.txt)
if /i "%DarkWii_Blue_4.3K%" EQU "*" (echo "DarkWii Blue Theme (4.3K) - %effect%">>temp\DLnames.txt) & (echo "DarkWii_Blue_4.3K">>temp\DLgotos.txt)

if /i "%darkwii_orange_4.1U%" EQU "*" (echo "DarkWii Orange Theme (4.1U) - %effect%">>temp\DLnames.txt) & (echo "darkwii_orange_4.1U">>temp\DLgotos.txt)
if /i "%darkwii_orange_4.2U%" EQU "*" (echo "DarkWii Orange Theme (4.2U) - %effect%">>temp\DLnames.txt) & (echo "darkwii_orange_4.2U">>temp\DLgotos.txt)
if /i "%darkwii_orange_4.3U%" EQU "*" (echo "DarkWii Orange Theme (4.3U) - %effect%">>temp\DLnames.txt) & (echo "darkwii_orange_4.3U">>temp\DLgotos.txt)
if /i "%darkwii_orange_4.1E%" EQU "*" (echo "DarkWii Orange Theme (4.1E) - %effect%">>temp\DLnames.txt) & (echo "darkwii_orange_4.1E">>temp\DLgotos.txt)
if /i "%darkwii_orange_4.2E%" EQU "*" (echo "DarkWii Orange Theme (4.2E) - %effect%">>temp\DLnames.txt) & (echo "darkwii_orange_4.2E">>temp\DLgotos.txt)
if /i "%darkwii_orange_4.3E%" EQU "*" (echo "DarkWii Orange Theme (4.3E) - %effect%">>temp\DLnames.txt) & (echo "darkwii_orange_4.3E">>temp\DLgotos.txt)
if /i "%darkwii_orange_4.1J%" EQU "*" (echo "DarkWii Orange Theme (4.1J) - %effect%">>temp\DLnames.txt) & (echo "darkwii_orange_4.1J">>temp\DLgotos.txt)
if /i "%darkwii_orange_4.2J%" EQU "*" (echo "DarkWii Orange Theme (4.2J) - %effect%">>temp\DLnames.txt) & (echo "darkwii_orange_4.2J">>temp\DLgotos.txt)
if /i "%darkwii_orange_4.3J%" EQU "*" (echo "DarkWii Orange Theme (4.3J) - %effect%">>temp\DLnames.txt) & (echo "darkwii_orange_4.3J">>temp\DLgotos.txt)
if /i "%darkwii_orange_4.1K%" EQU "*" (echo "DarkWii Orange Theme (4.1K) - %effect%">>temp\DLnames.txt) & (echo "darkwii_orange_4.1K">>temp\DLgotos.txt)
if /i "%darkwii_orange_4.2K%" EQU "*" (echo "DarkWii Orange Theme (4.2K) - %effect%">>temp\DLnames.txt) & (echo "darkwii_orange_4.2K">>temp\DLgotos.txt)
if /i "%darkwii_orange_4.3K%" EQU "*" (echo "DarkWii Orange Theme (4.3K) - %effect%">>temp\DLnames.txt) & (echo "darkwii_orange_4.3K">>temp\DLgotos.txt)

if /i "%IOS11P60%" EQU "*" (echo "IOS11v16174(IOS60v6174[FS-ES-NP-VP-DIP])">>temp\DLnames.txt) & (echo "IOS11P60">>temp\DLgotos.txt)
if /i "%IOS20P60%" EQU "*" (echo "IOS20v16174(IOS60v6174[FS-ES-NP-VP-DIP])">>temp\DLnames.txt) & (echo "IOS20P60">>temp\DLgotos.txt)
if /i "%IOS30%" EQU "*" (echo "IOS30v2576">>temp\DLnames.txt) & (echo "IOS30">>temp\DLgotos.txt)
if /i "%IOS30P60%" EQU "*" (echo "IOS30v16174(IOS60v6174[FS-ES-NP-VP-DIP])">>temp\DLnames.txt) & (echo "IOS30P60">>temp\DLgotos.txt)
if /i "%IOS30P%" EQU "*" (echo "IOS30v12576(IOS30v2576[FS-ES-NP-VP])">>temp\DLnames.txt) & (echo "IOS30P">>temp\DLgotos.txt)
if /i "%IOS40P60%" EQU "*" (echo "IOS40v16174(IOS60v6174[FS-ES-NP-VP-DIP])">>temp\DLnames.txt) & (echo "IOS40P60">>temp\DLgotos.txt)
if /i "%IOS50P%" EQU "*" (echo "IOS50v16174(IOS60v6174[FS-ES-NP-VP-DIP])">>temp\DLnames.txt) & (echo "IOS50P">>temp\DLgotos.txt)
if /i "%IOS52P%" EQU "*" (echo "IOS52v16174(IOS60v6174[FS-ES-NP-VP-DIP])">>temp\DLnames.txt) & (echo "IOS52P">>temp\DLgotos.txt)
if /i "%IOS60%" EQU "*" (echo "IOS60v6174">>temp\DLnames.txt) & (echo "IOS60">>temp\DLgotos.txt)
if /i "%IOS60P%" EQU "*" (echo "IOS60v16174(IOS60v6174[FS-ES-NP-VP-DIP])">>temp\DLnames.txt) & (echo "IOS60P">>temp\DLgotos.txt)
if /i "%IOS70%" EQU "*" (echo "IOS70v6687">>temp\DLnames.txt) & (echo "IOS70">>temp\DLgotos.txt)
if /i "%IOS70P%" EQU "*" (echo "IOS70v16687(IOS70v6687[FS-ES-NP-VP])">>temp\DLnames.txt) & (echo "IOS70P">>temp\DLgotos.txt)
if /i "%IOS70K%" EQU "*" (echo "IOS70v16174(IOS60v6174[FS-ES-NP-VP-DIP])">>temp\DLnames.txt) & (echo "IOS70K">>temp\DLgotos.txt)
if /i "%IOS80K%" EQU "*" (echo "IOS80v16174(IOS60v6174[FS-ES-NP-VP-DIP])">>temp\DLnames.txt) & (echo "IOS80K">>temp\DLgotos.txt)
if /i "%IOS80%" EQU "*" (echo "IOS80v6944">>temp\DLnames.txt) & (echo "IOS80">>temp\DLgotos.txt)
if /i "%IOS80P%" EQU "*" (echo "IOS80v16944(IOS80v6944[FS-ES-NP-VP])">>temp\DLnames.txt) & (echo "IOS80P">>temp\DLgotos.txt)

if /i "%mmm%" EQU "*" (echo "Multi-Mod Manager (MMM) v13.4">>temp\DLnames.txt) & (echo "mmm">>temp\DLgotos.txt)
if /i "%ARC%" EQU "*" (echo "Any Region Changer (1.1b Mod06 Offline)">>temp\DLnames.txt) & (echo "ARC">>temp\DLgotos.txt)
if /i "%WiiMod%" EQU "*" (echo "WiiMod">>temp\DLnames.txt) & (echo "WiiMod">>temp\DLgotos.txt)
if /i "%yawm%" EQU "*" (echo "Yet Another Wad Manager Mod">>temp\DLnames.txt) & (echo "yawm">>temp\DLgotos.txt)
if /i "%dop%" EQU "*" (echo "Dop-Mii">>temp\DLnames.txt) & (echo "dopmii">>temp\DLgotos.txt)

if /i "%syscheck%" EQU "*" (echo "sysCheck">>temp\DLnames.txt) & (echo "sysCheck">>temp\DLgotos.txt)
if /i "%Casper%" EQU "*" (echo "Casper">>temp\DLnames.txt) & (echo "Casper">>temp\DLgotos.txt)
if /i "%Wilbrand%" EQU "*" (echo "Wilbrand - 4.3%REGION% - MAC:%macaddress%">>temp\DLnames.txt) & (echo "Wilbrand">>temp\DLgotos.txt)

if /i "%HM%" EQU "*" (echo "HackMii Installer">>temp\DLnames.txt) & (echo "HackmiiInstaller">>temp\DLgotos.txt)
if /i "%bootmiisd%" EQU "*" (echo "BootMii SD Files">>temp\DLnames.txt) & (echo "bootmiisd">>temp\DLgotos.txt)
if /i "%BB1%" EQU "*" (echo "Bannerbomb v1">>temp\DLnames.txt) & (echo "BannerBomb1">>temp\DLgotos.txt)
if /i "%BB2%" EQU "*" (echo "Bannerbomb v2">>temp\DLnames.txt) & (echo "BannerBomb2">>temp\DLgotos.txt)
if /i "%smash%" EQU "*" (echo "Smash Stack (USA, PAL, JAP and KOR)">>temp\DLnames.txt) & (echo "smash">>temp\DLgotos.txt)
if /i "%pwns%" EQU "*" (echo "Indiana Pwns">>temp\DLnames.txt) & (echo "pwns">>temp\DLgotos.txt)
if /i "%Bathaxx%" EQU "*" (echo "Bathaxx (USA, PAL and JAP)">>temp\DLnames.txt) & (echo "Bathaxx">>temp\DLgotos.txt)
if /i "%ROTJ%" EQU "*" (echo "Return of the Jodi (USA, PAL and JAP)">>temp\DLnames.txt) & (echo "ROTJ">>temp\DLgotos.txt)
if /i "%TOS%" EQU "*" (echo "Eri HaKawai (USA, PAL and JAP)">>temp\DLnames.txt) & (echo "TOS">>temp\DLgotos.txt)
if /i "%YUGI%" EQU "*" (echo "YU-GI-OWNED (USA, PAL and JAP)">>temp\DLnames.txt) & (echo "YUGI">>temp\DLgotos.txt)
if /i "%Twi%" EQU "*" (echo "Twilight Hack v0.1 Beta1 (for Wii's 3.3 and below)">>temp\DLnames.txt) & (echo "Twi">>temp\DLgotos.txt)

if /i "%IOS236Installer%" EQU "*" (echo "IOS236 Installer v5 Mod">>temp\DLnames.txt) & (echo "IOS236Installer">>temp\DLgotos.txt)
if /i "%SIP%" EQU "*" (echo "Simple IOS Patcher">>temp\DLnames.txt) & (echo "SIP">>temp\DLgotos.txt)
if /i "%Pri%" EQU "*" (echo "Priiloader v0.7 (236 Mod)">>temp\DLnames.txt) & (echo "Priiloader">>temp\DLgotos.txt)
if /i "%HAX%" EQU "*" (echo "Priiloader Hacks">>temp\DLnames.txt) & (echo "PriiHacks">>temp\DLgotos.txt)
if /i "%MyM%" EQU "*" (echo "MyMenuifyMod">>temp\DLnames.txt) & (echo "Mym">>temp\DLgotos.txt)

if /i "%PCSAVE%" EQU "Local" goto:local
if /i "%PCSAVE%" NEQ "Auto" goto:skip
if /i "%Homedrive%" EQU "%ModMiiDrive%" goto:local
:skip
if /i "%f32%" EQU "*" (echo "FAT32 GUI Formatter">>temp\DLnames.txt) & (echo "F32">>temp\DLgotos.txt)
if /i "%CM%" EQU "*" (echo "Customize Mii">>temp\DLnames.txt) & (echo "CM">>temp\DLgotos.txt)
if /i "%SMW%" EQU "*" (echo "ShowMiiWads">>temp\DLnames.txt) & (echo "SMW">>temp\DLgotos.txt)
if /i "%wbm%" EQU "*" (echo "Wii Backup Manager">>temp\DLnames.txt) & (echo "WBM">>temp\DLgotos.txt)
if /i "%WiiGSC%" EQU "*" (echo "Wii Game Shortcut Creator">>temp\DLnames.txt) & (echo "WiiGSC">>temp\DLgotos.txt)
goto:skiplocal
:local

if /i "%f32%" EQU "*" (echo "FAT32 GUI Formatter (saved with shortcuts)">>temp\DLnames.txt) & (echo "F32">>temp\DLgotos.txt)
if /i "%wbm%" EQU "*" (echo "Wii Backup Manager (saved with shortcuts)">>temp\DLnames.txt) & (echo "WBM">>temp\DLgotos.txt)
if /i "%CM%" EQU "*" (echo "Customize Mii (saved with shortcuts)">>temp\DLnames.txt) & (echo "CM">>temp\DLgotos.txt)
if /i "%SMW%" EQU "*" (echo "ShowMiiWads (saved with shortcuts)">>temp\DLnames.txt) & (echo "SMW">>temp\DLgotos.txt)
if /i "%WiiGSC%" EQU "*" (echo "Wii Game Shortcut Creator (saved with shortcuts)">>temp\DLnames.txt) & (echo "WiiGSC">>temp\DLgotos.txt)
:skiplocal



if /i "%usbfolder%" EQU "*" (echo "Configurable USB-Loader">>temp\DLnames.txt) & (echo "usbfolder">>temp\DLgotos.txt)
if /i "%FLOW%" EQU "*" (echo "WiiFlow">>temp\DLnames.txt) & (echo "FLOW">>temp\DLgotos.txt)
if /i "%neogamma%" EQU "*" (echo "Neogamma Backup Disc Loader">>temp\DLnames.txt) & (echo "neogamma">>temp\DLgotos.txt)
if /i "%AccioHacks%" EQU "*" (echo "Accio Hacks">>temp\DLnames.txt) & (echo "AccioHacks">>temp\DLgotos.txt)
if /i "%CheatCodes%" EQU "*" (echo "%cheatregion% Region Cheat Codes: txtcodes from geckocodes.org">>temp\DLnames.txt) & (echo "CheatCodes">>temp\DLgotos.txt)
if /i "%USBX%" EQU "*" (echo "USB-Loader Forwarder Channel">>temp\DLnames.txt) & (echo "USBX">>temp\DLgotos.txt)

if /i "%FLOWF%" EQU "*" (echo "WiiFlow Forwarder Channel\dol">>temp\DLnames.txt) & (echo "FLOWF">>temp\DLgotos.txt)
if /i "%PLC%" EQU "*" (echo "Post Loader Forwarder Channel">>temp\DLnames.txt) & (echo "PLC">>temp\DLgotos.txt)
if /i "%S2U%" EQU "*" (echo "Switch2Uneek">>temp\DLnames.txt) & (echo "S2U">>temp\DLgotos.txt)
if /i "%nSwitch%" EQU "*" (echo "nSwitch">>temp\DLnames.txt) & (echo "nSwitch">>temp\DLgotos.txt)
if /i "%WiiMC%" EQU "*" (echo "WiiMC - Media Player">>temp\DLnames.txt) & (echo "WIIMC">>temp\DLgotos.txt)
if /i "%fceugx%" EQU "*" (echo "FCEUGX - NES Emulator for the Wii">>temp\DLnames.txt) & (echo "fceugx">>temp\DLgotos.txt)
if /i "%snes9xgx%" EQU "*" (echo "SNES9xGX - SNES Emulator for the Wii">>temp\DLnames.txt) & (echo "snes9xgx">>temp\DLgotos.txt)
if /i "%vbagx%" EQU "*" (echo "Visual Boy Advance GX - GB/GBA Emulator for the Wii">>temp\DLnames.txt) & (echo "vbagx">>temp\DLgotos.txt)
if /i "%WII64%" EQU "*" (echo "Wii64 beta1.1 (N64 Emulator)">>temp\DLnames.txt) & (echo "WII64">>temp\DLgotos.txt)
if /i "%WIISX%" EQU "*" (echo "WiiSX beta2.1 (Playstation 1 Emulator)">>temp\DLnames.txt) & (echo "WIISX">>temp\DLgotos.txt)
if /i "%SGM%" EQU "*" (echo "SaveGame Manager GX">>temp\DLnames.txt) & (echo "SGM">>temp\DLgotos.txt)
if /i "%PL%" EQU "*" (echo "Postloader">>temp\DLnames.txt) & (echo "PL">>temp\DLgotos.txt)
if /i "%WIIX%" EQU "*" (echo "WiiXplorer">>temp\DLnames.txt) & (echo "WIIX">>temp\DLgotos.txt)
if /i "%HBB%" EQU "*" (echo "Homebrew Browser">>temp\DLnames.txt) & (echo "HBB">>temp\DLgotos.txt)
if /i "%locked%" EQU "*" (echo "Locked Apps Folder for HBC (PASS=UDLRAB)">>temp\DLnames.txt) & (echo "locked">>temp\DLgotos.txt)

if /i "%MII%" EQU "*" (echo "MII Channel">>temp\DLnames.txt) & (echo "MII">>temp\DLgotos.txt)

if /i "%P0%" EQU "*" (echo "Photo Channel (USA / PAL / JAP /KOR)">>temp\DLnames.txt) & (echo "PHOTO0">>temp\DLgotos.txt)
if /i "%P%" EQU "*" (echo "Photo Channel 1.1 (USA / PAL / JAP)">>temp\DLnames.txt) & (echo "PHOTO">>temp\DLgotos.txt)
if /i "%PK%" EQU "*" (echo "KOREAN Photo Channel 1.1">>temp\DLnames.txt) & (echo "PHOTO_K">>temp\DLgotos.txt)
if /i "%S%" EQU "*" (echo "Shopping Channel (USA / PAL / JAP)">>temp\DLnames.txt) & (echo "SHOP">>temp\DLgotos.txt)
if /i "%SK%" EQU "*" (echo "KOREAN Shopping Channel">>temp\DLnames.txt) & (echo "SHOP_K">>temp\DLgotos.txt)
if /i "%IU%" EQU "*" (echo "USA Internet Channel">>temp\DLnames.txt) & (echo "NET_U">>temp\DLgotos.txt)
if /i "%IE%" EQU "*" (echo "PAL Internet Channel">>temp\DLnames.txt) & (echo "NET_E">>temp\DLgotos.txt)
if /i "%IJ%" EQU "*" (echo "JAP Internet Channel">>temp\DLnames.txt) & (echo "NET_J">>temp\DLgotos.txt)
if /i "%WU%" EQU "*" (echo "USA Weather Channel">>temp\DLnames.txt) & (echo "WEATHER_U">>temp\DLgotos.txt)
if /i "%WE%" EQU "*" (echo "PAL Weather Channel">>temp\DLnames.txt) & (echo "WEATHER_E">>temp\DLgotos.txt)
if /i "%WJ%" EQU "*" (echo "JAP Weather Channel">>temp\DLnames.txt) & (echo "WEATHER_J">>temp\DLgotos.txt)
if /i "%NU%" EQU "*" (echo "USA NEWS Channel">>temp\DLnames.txt) & (echo "NEWS_U">>temp\DLgotos.txt)
if /i "%NE%" EQU "*" (echo "PAl NEWS Channel">>temp\DLnames.txt) & (echo "NEWS_E">>temp\DLgotos.txt)
if /i "%NJ%" EQU "*" (echo "JAP NEWS Channel">>temp\DLnames.txt) & (echo "NEWS_J">>temp\DLgotos.txt)
if /i "%WSU%" EQU "*" (echo "USA Wii Speak Channel">>temp\DLnames.txt) & (echo "SPEAK_U">>temp\DLgotos.txt)
if /i "%WSE%" EQU "*" (echo "PAL Wii Speak Channel">>temp\DLnames.txt) & (echo "SPEAK_E">>temp\DLgotos.txt)
if /i "%WSJ%" EQU "*" (echo "JAP Wii Speak Channel">>temp\DLnames.txt) & (echo "SPEAK_J">>temp\DLgotos.txt)

if /i "%M10%" EQU "*" (echo "MIOSv10">>temp\DLnames.txt) & (echo "M10">>temp\DLgotos.txt)
if /i "%IOS9%" EQU "*" (echo "IOS9">>temp\DLnames.txt) & (echo "IOS9">>temp\DLgotos.txt)
if /i "%IOS12%" EQU "*" (echo "IOS12">>temp\DLnames.txt) & (echo "IOS12">>temp\DLgotos.txt)
if /i "%IOS13%" EQU "*" (echo "IOS13">>temp\DLnames.txt) & (echo "IOS13">>temp\DLgotos.txt)
if /i "%IOS14%" EQU "*" (echo "IOS14">>temp\DLnames.txt) & (echo "IOS14">>temp\DLgotos.txt)
if /i "%IOS15%" EQU "*" (echo "IOS15">>temp\DLnames.txt) & (echo "IOS15">>temp\DLgotos.txt)
if /i "%IOS17%" EQU "*" (echo "IOS17">>temp\DLnames.txt) & (echo "IOS17">>temp\DLgotos.txt)
if /i "%IOS21%" EQU "*" (echo "IOS21">>temp\DLnames.txt) & (echo "IOS21">>temp\DLgotos.txt)
if /i "%IOS22%" EQU "*" (echo "IOS22">>temp\DLnames.txt) & (echo "IOS22">>temp\DLgotos.txt)
if /i "%IOS28%" EQU "*" (echo "IOS28">>temp\DLnames.txt) & (echo "IOS28">>temp\DLgotos.txt)
if /i "%IOS31%" EQU "*" (echo "IOS31">>temp\DLnames.txt) & (echo "IOS31">>temp\DLgotos.txt)
if /i "%IOS33%" EQU "*" (echo "IOS33">>temp\DLnames.txt) & (echo "IOS33">>temp\DLgotos.txt)
if /i "%IOS34%" EQU "*" (echo "IOS34">>temp\DLnames.txt) & (echo "IOS34">>temp\DLgotos.txt)
if /i "%IOS35%" EQU "*" (echo "IOS35">>temp\DLnames.txt) & (echo "IOS35">>temp\DLgotos.txt)
if /i "%IOS36%" EQU "*" (echo "IOS36v3351">>temp\DLnames.txt) & (echo "IOS36">>temp\DLgotos.txt)
if /i "%IOS36v3608%" EQU "*" (echo "IOS36v3608">>temp\DLnames.txt) & (echo "IOS36v3608">>temp\DLgotos.txt)
if /i "%IOS37%" EQU "*" (echo "IOS37">>temp\DLnames.txt) & (echo "IOS37">>temp\DLgotos.txt)
if /i "%IOS38%" EQU "*" (echo "IOS38">>temp\DLnames.txt) & (echo "IOS38">>temp\DLgotos.txt)
if /i "%IOS41%" EQU "*" (echo "IOS41">>temp\DLnames.txt) & (echo "IOS41">>temp\DLgotos.txt)
if /i "%IOS43%" EQU "*" (echo "IOS43">>temp\DLnames.txt) & (echo "IOS43">>temp\DLgotos.txt)
if /i "%IOS45%" EQU "*" (echo "IOS45">>temp\DLnames.txt) & (echo "IOS45">>temp\DLgotos.txt)
if /i "%IOS46%" EQU "*" (echo "IOS46">>temp\DLnames.txt) & (echo "IOS46">>temp\DLgotos.txt)
if /i "%IOS48v4124%" EQU "*" (echo "IOS48">>temp\DLnames.txt) & (echo "IOS48v4124">>temp\DLgotos.txt)
if /i "%IOS53%" EQU "*" (echo "IOS53">>temp\DLnames.txt) & (echo "IOS53">>temp\DLgotos.txt)
if /i "%IOS55%" EQU "*" (echo "IOS55">>temp\DLnames.txt) & (echo "IOS55">>temp\DLgotos.txt)
if /i "%IOS56%" EQU "*" (echo "IOS56">>temp\DLnames.txt) & (echo "IOS56">>temp\DLgotos.txt)
if /i "%IOS57%" EQU "*" (echo "IOS57">>temp\DLnames.txt) & (echo "IOS57">>temp\DLgotos.txt)
if /i "%IOS58%" EQU "*" (echo "IOS58">>temp\DLnames.txt) & (echo "IOS58">>temp\DLgotos.txt)
if /i "%IOS61%" EQU "*" (echo "IOS61">>temp\DLnames.txt) & (echo "IOS61">>temp\DLgotos.txt)
if /i "%IOS62%" EQU "*" (echo "IOS62">>temp\DLnames.txt) & (echo "IOS62">>temp\DLgotos.txt)
if /i "%A0e%" EQU "*" (echo "0000000e.app from IOS80 v6943 (SNEEK)">>temp\DLnames.txt) & (echo "NUSGRABBER0e">>temp\DLgotos.txt)

if /i "%A01%" EQU "*" (echo "00000001.app from IOS80 v6687 (SNEEK)">>temp\DLnames.txt) & (echo "NUSGRABBER01">>temp\DLgotos.txt)
if /i "%A0e_70%" EQU "*" (echo "0000000e.app from IOS70 v6687 (SNEEK)">>temp\DLnames.txt) & (echo "NUSGRABBER0e_70">>temp\DLgotos.txt)
if /i "%A01_70%" EQU "*" (echo "00000001.app from IOS70 v6687 (SNEEK)">>temp\DLnames.txt) & (echo "NUSGRABBER01_70">>temp\DLgotos.txt)
if /i "%A0e_60%" EQU "*" (echo "0000000e.app from IOS60 v6174 (SNEEK)">>temp\DLnames.txt) & (echo "NUSGRABBER0e_60">>temp\DLgotos.txt)
if /i "%A0c%" EQU "*" (echo "0000000c.app from MIOS v10 (DIOS MIOS)">>temp\DLnames.txt) & (echo "NUSGRABBER0c">>temp\DLgotos.txt)
if /i "%A01_60%" EQU "*" (echo "00000001.app from IOS60 v6174 (SNEEK)">>temp\DLnames.txt) & (echo "NUSGRABBER01_60">>temp\DLgotos.txt)
if /i "%A40%" EQU "*" (echo "00000040.app from System Menu 3.2J (for MyMenuify)">>temp\DLnames.txt) & (echo "NUSGRABBER40">>temp\DLgotos.txt)
if /i "%A42%" EQU "*" (echo "00000042.app from System Menu 3.2U (for MyMenuify)">>temp\DLnames.txt) & (echo "NUSGRABBER42">>temp\DLgotos.txt)
if /i "%A45%" EQU "*" (echo "00000045.app from System Menu 3.2E (for MyMenuify)">>temp\DLnames.txt) & (echo "NUSGRABBER45">>temp\DLgotos.txt)
if /i "%A70%" EQU "*" (echo "00000070.app from System Menu 4.0J (for MyMenuify)">>temp\DLnames.txt) & (echo "NUSGRABBER70">>temp\DLgotos.txt)
if /i "%A72%" EQU "*" (echo "00000072.app from System Menu 4.0U (for MyMenuify)">>temp\DLnames.txt) & (echo "NUSGRABBER72">>temp\DLgotos.txt)
if /i "%A75%" EQU "*" (echo "00000075.app from System Menu 4.0E (for MyMenuify)">>temp\DLnames.txt) & (echo "NUSGRABBER75">>temp\DLgotos.txt)
if /i "%A78%" EQU "*" (echo "00000078.app from System Menu 4.1J (for MyMenuify)">>temp\DLnames.txt) & (echo "NUSGRABBER78">>temp\DLgotos.txt)
if /i "%A7b%" EQU "*" (echo "0000007b.app from System Menu 4.1U (for MyMenuify)">>temp\DLnames.txt) & (echo "NUSGRABBER7b">>temp\DLgotos.txt)
if /i "%A7e%" EQU "*" (echo "0000007e.app from System Menu 4.1E (for MyMenuify)">>temp\DLnames.txt) & (echo "NUSGRABBER7e">>temp\DLgotos.txt)
if /i "%A81%" EQU "*" (echo "00000081.app from System Menu 4.1K (for MyMenuify)">>temp\DLnames.txt) & (echo "NUSGRABBER81">>temp\DLgotos.txt)
if /i "%A84%" EQU "*" (echo "00000084.app from System Menu 4.2J (for MyMenuify)">>temp\DLnames.txt) & (echo "NUSGRABBER84">>temp\DLgotos.txt)
if /i "%A87%" EQU "*" (echo "00000087.app from System Menu 4.2U (for MyMenuify)">>temp\DLnames.txt) & (echo "NUSGRABBER87">>temp\DLgotos.txt)
if /i "%A8a%" EQU "*" (echo "0000008a.app from System Menu 4.2E (for MyMenuify)">>temp\DLnames.txt) & (echo "NUSGRABBER8a">>temp\DLgotos.txt)
if /i "%A8d%" EQU "*" (echo "0000008d.app from System Menu 4.2K (for MyMenuify)">>temp\DLnames.txt) & (echo "NUSGRABBER8d">>temp\DLgotos.txt)
if /i "%A94%" EQU "*" (echo "00000094.app from System Menu 4.3J (for MyMenuify)">>temp\DLnames.txt) & (echo "NUSGRABBER94">>temp\DLgotos.txt)
if /i "%A97%" EQU "*" (echo "00000097.app from System Menu 4.3U (for MyMenuify)">>temp\DLnames.txt) & (echo "NUSGRABBER97">>temp\DLgotos.txt)
if /i "%A9a%" EQU "*" (echo "0000009a.app from System Menu 4.3E (for MyMenuify)">>temp\DLnames.txt) & (echo "NUSGRABBER9a">>temp\DLgotos.txt)
if /i "%A9d%" EQU "*" (echo "0000009d.app from System Menu 4.3K (for MyMenuify)">>temp\DLnames.txt) & (echo "NUSGRABBER9d">>temp\DLgotos.txt)

if /i "%IOS236%" EQU "*" (echo "IOS236v65535(IOS36v3351[FS-ES-NP-VP])">>temp\DLnames.txt) & (echo "IOS236">>temp\DLgotos.txt)

if /i "%cIOS249[37]-d2x-v8-final%" EQU "*" (echo "cIOS249[37]-d2x-v%d2x-beta-rev%">>temp\DLnames.txt) & (echo "cIOS249[37]-d2x-v8-final">>temp\DLgotos.txt)
if /i "%cIOS249[38]-d2x-v8-final%" EQU "*" (echo "cIOS249[38]-d2x-v%d2x-beta-rev%">>temp\DLnames.txt) & (echo "cIOS249[38]-d2x-v8-final">>temp\DLgotos.txt)
if /i "%cIOS249[53]-d2x-v8-final%" EQU "*" (echo "cIOS249[53]-d2x-v%d2x-beta-rev%">>temp\DLnames.txt) & (echo "cIOS249[53]-d2x-v8-final">>temp\DLgotos.txt)
if /i "%cIOS249[55]-d2x-v8-final%" EQU "*" (echo "cIOS249[55]-d2x-v%d2x-beta-rev%">>temp\DLnames.txt) & (echo "cIOS249[55]-d2x-v8-final">>temp\DLgotos.txt)
if /i "%cIOS249[56]-d2x-v8-final%" EQU "*" (echo "cIOS249[56]-d2x-v%d2x-beta-rev%">>temp\DLnames.txt) & (echo "cIOS249[56]-d2x-v8-final">>temp\DLgotos.txt)
if /i "%cIOS249[57]-d2x-v8-final%" EQU "*" (echo "cIOS249[57]-d2x-v%d2x-beta-rev%">>temp\DLnames.txt) & (echo "cIOS249[57]-d2x-v8-final">>temp\DLgotos.txt)
if /i "%cIOS249[58]-d2x-v8-final%" EQU "*" (echo "cIOS249[58]-d2x-v%d2x-beta-rev%">>temp\DLnames.txt) & (echo "cIOS249[58]-d2x-v8-final">>temp\DLgotos.txt)
if /i "%cIOS249[60]-d2x-v8-final%" EQU "*" (echo "cIOS249[60]-d2x-v%d2x-beta-rev%">>temp\DLnames.txt) & (echo "cIOS249[60]-d2x-v8-final">>temp\DLgotos.txt)
if /i "%cIOS249[70]-d2x-v8-final%" EQU "*" (echo "cIOS249[70]-d2x-v%d2x-beta-rev%">>temp\DLnames.txt) & (echo "cIOS249[70]-d2x-v8-final">>temp\DLgotos.txt)
if /i "%cIOS249[80]-d2x-v8-final%" EQU "*" (echo "cIOS249[80]-d2x-v%d2x-beta-rev%">>temp\DLnames.txt) & (echo "cIOS249[80]-d2x-v8-final">>temp\DLgotos.txt)
if /i "%cIOS250[37]-d2x-v8-final%" EQU "*" (echo "cIOS250[37]-d2x-v%d2x-beta-rev%">>temp\DLnames.txt) & (echo "cIOS250[37]-d2x-v8-final">>temp\DLgotos.txt)
if /i "%cIOS250[38]-d2x-v8-final%" EQU "*" (echo "cIOS250[38]-d2x-v%d2x-beta-rev%">>temp\DLnames.txt) & (echo "cIOS250[38]-d2x-v8-final">>temp\DLgotos.txt)
if /i "%cIOS250[53]-d2x-v8-final%" EQU "*" (echo "cIOS250[53]-d2x-v%d2x-beta-rev%">>temp\DLnames.txt) & (echo "cIOS250[53]-d2x-v8-final">>temp\DLgotos.txt)
if /i "%cIOS250[55]-d2x-v8-final%" EQU "*" (echo "cIOS250[55]-d2x-v%d2x-beta-rev%">>temp\DLnames.txt) & (echo "cIOS250[55]-d2x-v8-final">>temp\DLgotos.txt)
if /i "%cIOS250[56]-d2x-v8-final%" EQU "*" (echo "cIOS250[56]-d2x-v%d2x-beta-rev%">>temp\DLnames.txt) & (echo "cIOS250[56]-d2x-v8-final">>temp\DLgotos.txt)
if /i "%cIOS250[57]-d2x-v8-final%" EQU "*" (echo "cIOS250[57]-d2x-v%d2x-beta-rev%">>temp\DLnames.txt) & (echo "cIOS250[57]-d2x-v8-final">>temp\DLgotos.txt)
if /i "%cIOS250[58]-d2x-v8-final%" EQU "*" (echo "cIOS250[58]-d2x-v%d2x-beta-rev%">>temp\DLnames.txt) & (echo "cIOS250[58]-d2x-v8-final">>temp\DLgotos.txt)
if /i "%cIOS250[60]-d2x-v8-final%" EQU "*" (echo "cIOS250[60]-d2x-v%d2x-beta-rev%">>temp\DLnames.txt) & (echo "cIOS250[60]-d2x-v8-final">>temp\DLgotos.txt)
if /i "%cIOS250[70]-d2x-v8-final%" EQU "*" (echo "cIOS250[70]-d2x-v%d2x-beta-rev%">>temp\DLnames.txt) & (echo "cIOS250[70]-d2x-v8-final">>temp\DLgotos.txt)
if /i "%cIOS250[80]-d2x-v8-final%" EQU "*" (echo "cIOS250[80]-d2x-v%d2x-beta-rev%">>temp\DLnames.txt) & (echo "cIOS250[80]-d2x-v8-final">>temp\DLgotos.txt)

if /i "%cIOS222[38]-v4%" EQU "*" (echo "cIOS222[38]-v4">>temp\DLnames.txt) & (echo "cIOS222[38]-v4">>temp\DLgotos.txt)
if /i "%cIOS223[37-38]-v4%" EQU "*" (echo "cIOS223[37-38]-v4">>temp\DLnames.txt) & (echo "cIOS223[37-38]-v4">>temp\DLgotos.txt)

if /i "%cIOS222[38]-v5%" EQU "*" (echo "cIOS222[38]-v5">>temp\DLnames.txt) & (echo "cIOS222[38]-v5">>temp\DLgotos.txt)
if /i "%cIOS223[37]-v5%" EQU "*" (echo "cIOS223[37]-v5">>temp\DLnames.txt) & (echo "cIOS223[37]-v5">>temp\DLgotos.txt)
if /i "%cIOS224[57]-v5%" EQU "*" (echo "cIOS224[57]-v5">>temp\DLnames.txt) & (echo "cIOS224[57]-v5">>temp\DLgotos.txt)

if /i "%cIOS202[60]-v5.1R%" EQU "*" (echo "cIOS202[60]-v5.1R">>temp\DLnames.txt) & (echo "cIOS202[60]-v5.1R">>temp\DLgotos.txt)
if /i "%cIOS222[38]-v5.1R%" EQU "*" (echo "cIOS222[38]-v5.1R">>temp\DLnames.txt) & (echo "cIOS222[38]-v5.1R">>temp\DLgotos.txt)
if /i "%cIOS223[37]-v5.1R%" EQU "*" (echo "cIOS223[37]-v5.1R">>temp\DLnames.txt) & (echo "cIOS223[37]-v5.1R">>temp\DLgotos.txt)
if /i "%cIOS224[57]-v5.1R%" EQU "*" (echo "cIOS224[57]-v5.1R">>temp\DLnames.txt) & (echo "cIOS224[57]-v5.1R">>temp\DLgotos.txt)

if /i "%cIOS249-v14%" EQU "*" (echo "cIOS249-v14">>temp\DLnames.txt) & (echo "cIOS249-v14">>temp\DLgotos.txt)
if /i "%cIOS250-v14%" EQU "*" (echo "cIOS250-v14">>temp\DLnames.txt) & (echo "cIOS250-v14">>temp\DLgotos.txt)

if /i "%cIOS249-v17b%" EQU "*" (echo "cIOS249-v17b">>temp\DLnames.txt) & (echo "cIOS249-v17b">>temp\DLgotos.txt)
if /i "%cIOS250-v17b%" EQU "*" (echo "cIOS250-v17b">>temp\DLnames.txt) & (echo "cIOS250-v17b">>temp\DLgotos.txt)

if /i "%cIOS249[37]-v19%" EQU "*" (echo "cIOS249[37]-v19">>temp\DLnames.txt) & (echo "cIOS249[37]-v19">>temp\DLgotos.txt)
if /i "%cIOS249[38]-v19%" EQU "*" (echo "cIOS249[38]-v19">>temp\DLnames.txt) & (echo "cIOS249[38]-v19">>temp\DLgotos.txt)
if /i "%cIOS249[57]-v19%" EQU "*" (echo "cIOS249[57]-v19">>temp\DLnames.txt) & (echo "cIOS249[57]-v19">>temp\DLgotos.txt)
if /i "%cIOS250[37]-v19%" EQU "*" (echo "cIOS250[37]-v19">>temp\DLnames.txt) & (echo "cIOS250[37]-v19">>temp\DLgotos.txt)
if /i "%cIOS250[38]-v19%" EQU "*" (echo "cIOS250[38]-v19">>temp\DLnames.txt) & (echo "cIOS250[38]-v19">>temp\DLgotos.txt)
if /i "%cIOS250[57]-v19%" EQU "*" (echo "cIOS250[57]-v19">>temp\DLnames.txt) & (echo "cIOS250[57]-v19">>temp\DLgotos.txt)

if /i "%cIOS249[38]-v20%" EQU "*" (echo "cIOS249[38]-v20">>temp\DLnames.txt) & (echo "cIOS249[38]-v20">>temp\DLgotos.txt)
if /i "%cIOS249[56]-v20%" EQU "*" (echo "cIOS249[56]-v20">>temp\DLnames.txt) & (echo "cIOS249[56]-v20">>temp\DLgotos.txt)
if /i "%cIOS249[57]-v20%" EQU "*" (echo "cIOS249[57]-v20">>temp\DLnames.txt) & (echo "cIOS249[57]-v20">>temp\DLgotos.txt)
if /i "%cIOS250[38]-v20%" EQU "*" (echo "cIOS250[38]-v20">>temp\DLnames.txt) & (echo "cIOS250[38]-v20">>temp\DLgotos.txt)
if /i "%cIOS250[56]-v20%" EQU "*" (echo "cIOS250[56]-v20">>temp\DLnames.txt) & (echo "cIOS250[56]-v20">>temp\DLgotos.txt)
if /i "%cIOS250[57]-v20%" EQU "*" (echo "cIOS250[57]-v20">>temp\DLnames.txt) & (echo "cIOS250[57]-v20">>temp\DLgotos.txt)

if /i "%cIOS249[37]-v21%" EQU "*" (echo "cIOS249[37]-v21">>temp\DLnames.txt) & (echo "cIOS249[37]-v21">>temp\DLgotos.txt)
if /i "%cIOS249[38]-v21%" EQU "*" (echo "cIOS249[38]-v21">>temp\DLnames.txt) & (echo "cIOS249[38]-v21">>temp\DLgotos.txt)
if /i "%cIOS249[53]-v21%" EQU "*" (echo "cIOS249[53]-v21">>temp\DLnames.txt) & (echo "cIOS249[53]-v21">>temp\DLgotos.txt)
if /i "%cIOS249[55]-v21%" EQU "*" (echo "cIOS249[55]-v21">>temp\DLnames.txt) & (echo "cIOS249[55]-v21">>temp\DLgotos.txt)
if /i "%cIOS249[56]-v21%" EQU "*" (echo "cIOS249[56]-v21">>temp\DLnames.txt) & (echo "cIOS249[56]-v21">>temp\DLgotos.txt)
if /i "%cIOS249[57]-v21%" EQU "*" (echo "cIOS249[57]-v21">>temp\DLnames.txt) & (echo "cIOS249[57]-v21">>temp\DLgotos.txt)
if /i "%cIOS249[58]-v21%" EQU "*" (echo "cIOS249[58]-v21">>temp\DLnames.txt) & (echo "cIOS249[58]-v21">>temp\DLgotos.txt)
if /i "%cIOS250[37]-v21%" EQU "*" (echo "cIOS250[37]-v21">>temp\DLnames.txt) & (echo "cIOS250[37]-v21">>temp\DLgotos.txt)
if /i "%cIOS250[38]-v21%" EQU "*" (echo "cIOS250[38]-v21">>temp\DLnames.txt) & (echo "cIOS250[38]-v21">>temp\DLgotos.txt)
if /i "%cIOS250[53]-v21%" EQU "*" (echo "cIOS250[53]-v21">>temp\DLnames.txt) & (echo "cIOS250[53]-v21">>temp\DLgotos.txt)
if /i "%cIOS250[55]-v21%" EQU "*" (echo "cIOS250[55]-v21">>temp\DLnames.txt) & (echo "cIOS250[55]-v21">>temp\DLgotos.txt)
if /i "%cIOS250[56]-v21%" EQU "*" (echo "cIOS250[56]-v21">>temp\DLnames.txt) & (echo "cIOS250[56]-v21">>temp\DLgotos.txt)
if /i "%cIOS250[57]-v21%" EQU "*" (echo "cIOS250[57]-v21">>temp\DLnames.txt) & (echo "cIOS250[57]-v21">>temp\DLgotos.txt)
if /i "%cIOS250[58]-v21%" EQU "*" (echo "cIOS250[58]-v21">>temp\DLnames.txt) & (echo "cIOS250[58]-v21">>temp\DLgotos.txt)

if /i "%RVL-cMIOS-v65535(v10)_WiiGator_WiiPower_v0.2%" EQU "*" (echo "WiiGator+WiiPower cMIOS-v65535(v10)">>temp\DLnames.txt) & (echo "RVL-cMIOS-v65535(v10)_WiiGator_WiiPower_v0.2">>temp\DLgotos.txt)
if /i "%RVL-cmios-v4_WiiGator_GCBL_v0.2%" EQU "*" (echo "cMIOS-v4 WiiGator GCBL v0.2">>temp\DLnames.txt) & (echo "RVL-cmios-v4_WiiGator_GCBL_v0.2">>temp\DLgotos.txt)
if /i "%RVL-cmios-v4_Waninkoko_rev5%" EQU "*" (echo "cMIOS-v4 Waninkoko rev5">>temp\DLnames.txt) & (echo "RVL-cmios-v4_Waninkoko_rev5">>temp\DLgotos.txt)

if exist temp\DLnames.txt support\sfk filter -quiet "temp\DLnames.txt" -rep _"""__ -write -yes
if exist temp\DLgotos.txt support\sfk filter -quiet "temp\DLgotos.txt" -rep _"""__ -write -yes

if not exist temp\DLGotosADV.txt goto:quickskip
::Loop through the the following once for EACH line in *.txt
for /F "tokens=*" %%A in (temp\DLGotosADV.txt) do call :processDLGotosADV %%A
goto:quickskip
:processDLGotosADV
echo %*>>temp\DLgotos.txt
goto:EOF
:quickskip

if not exist temp\DLnamesADV.txt goto:quickskip
::Loop through the the following once for EACH line in *.txt
for /F "tokens=*" %%A in (temp\DLnamesADV.txt) do call :processDLnamesADV %%A
goto:quickskip
:processDLnamesADV
echo %*>>temp\DLnames.txt
goto:EOF
:quickskip

if exist "temp\DLgotos.txt" copy /y "temp\DLgotos.txt" "temp\DLgotos-copy.txt">nul


if not exist temp\DLnames.txt goto:miniskip
setlocal ENABLEDELAYEDEXPANSION
SET DLTOTAL=0
for /f "delims=" %%i in (temp\DLnames.txt) do set /a DLTOTAL=!DLTOTAL!+1
setlocal DISABLEDELAYEDEXPANSION
:miniskip



if /i "%MENU1%" EQU "S" goto:DLSETTINGS
if /i "%MENUREAL%" EQU "S" goto:DLSETTINGS

SET /a LINES=%DLTOTAL%+22

if /i "%MENU1%" EQU "L" SET /a LINES=%LINES%+14


::sysCheck Updater - handles when no downloads were marked for installation
if /i "%MENU1%" NEQ "SU" goto:miniskip
if /i "%DLTOTAL%" NEQ "0" goto:miniskip
echo.
echo      According to your sysCheck log your Wii's softmods are up to date.
echo.
@ping 127.0.0.1 -n 5 -w 1000> nul
if /i "%cmdlinemode%" EQU "Y" exit
goto:sysCheckName
:miniskip

::---------------CMD LINE MODE-------------
if /i "%cmdlinemodeswitchoff%" EQU "Y" (set cmdlinemode=) & (set one=) & (set two=)
if /i "%cmdlinemode%" EQU "Y" goto:DLSettings



if %LINES% LEQ 54 goto:noresize
mode con cols=85 lines=%LINES%

::Support\nircmd.exe win setsize title "ModMii" 50 50 720 700
:noresize

cls
echo                                        ModMii                                v%currentversion%
echo                                       by XFlak
echo.
if /i "%MENU1%" EQU "H" echo                                  HackMii Solutions
if /i "%MENU1%" EQU "H" echo.


::-----------DL QUEUE SETTINGS---------
if /i "%MENU1%" NEQ "L" goto:skiploadDLcue

if /i "%ROOTSAVE%" EQU "%ROOTSAVETEMP%" set matchrs=Green
if /i "%ROOTSAVE%" NEQ "%ROOTSAVETEMP%" set matchrs=Red

if /i "%OPTION1%" EQU "%OPTION1TEMP%" set match1=Green
if /i "%OPTION1%" NEQ "%OPTION1TEMP%" set match1=Red

echo.
echo                                 Download Queue Loaded:
echo.
echo                                 %CurrentQueue:~0,-4%
echo.
echo.
support\sfk echo -spat \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 Queue Options appear [Red]Red [def]when they differ from
support\sfk echo -spat \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 your saved settings and [Green]Green [def]if they match
echo.
if /i "%ROOTSAVE%" EQU "ON" support\sfk echo -spat \x20 \x20 [%matchrs%]Root Save: Save IOSs\MIOSs to Root instead of WAD Folder (Enabled)
if /i "%ROOTSAVE%" EQU "OFF" support\sfk echo -spat \x20 \x20 [%matchrs%]Root Save: Save IOSs\MIOSs to Root instead of WAD Folder (Disabled)
echo               * Useful for Wii Apps that require IOSs\MIOSs saved to Root
echo.
if /i "%OPTION1%" EQU "OFF" support\sfk echo -spat \x20 \x20 [%match1%]Do not Keep 00000001 Folder for IOSs\MIOSs\SMs etc
if /i "%OPTION1%" EQU "OFF" echo               * Folder sometimes required for offline usage of a few Wii Apps
if /i "%OPTION1%" EQU "ON" support\sfk echo -spat \x20 \x20 [%match1%]Keep 00000001 Folder for IOSs\MIOSs\SMs etc
if /i "%OPTION1%" EQU "ON" echo               * Useful for offline usage of Wii Apps like Dop-Mii



if /i "%OPTION1%" EQU "NUS" support\sfk echo -spat \x20 \x20 [%match1%]Keep NUS\00000001000000##v# Folder for IOSs\MIOSs\SMs etc
if /i "%OPTION1%" EQU "NUS" echo               * Useful for offline usage of Wii Apps like d2x\Hermes cIOS Installers

if /i "%OPTION1%" EQU "ALL" support\sfk echo -spat \x20 \x20 [%match1%]Keep NUS\00000001000000##v# and 00000001 Folder for IOSs\MIOSs\SMs etc
if /i "%OPTION1%" EQU "ALL" echo               * Useful for offline usage of a handful of Wii Apps
echo.
echo.

:skiploadDLcue

if /i "%DLTOTAL%" EQU "0" echo      No files were marked for download
if /i "%DLTOTAL%" EQU "0" goto:skipall

if /i "%USBGUIDE%" NEQ "Y" goto:skip
if /i "%USBCONFIG%" EQU "USB" (echo      The following %DLTOTAL% files will be downloaded to "%DRIVE%" or "%DRIVEU%":) else (echo      The following %DLTOTAL% files will be downloaded to "%DRIVE%":)
goto:skipall
:skip


if /i "%MENU1%" EQU "SU" (echo      According to your sysCheck log the following files are required) & (echo      in order to update your softmod.) & (echo.)

echo      The following %DLTOTAL% files will be downloaded to "%DRIVE%":
:skipall

echo.

SET DLNUM=0

::Loop through the the following once for EACH line in *.txt
if not exist temp\DLnames.txt goto:nextstep
for /F "tokens=*" %%A in (temp\DLnames.txt) do call :processDLlist %%A
goto:nextstep
:processDLlist
SET /a DLNUM=%DLNUM%+1
echo      %DLNUM%) %*
goto:EOF
:nextstep


echo.

echo      Begin Downloading now?
echo.
if /i "%DLTOTAL%" EQU "0" goto:zerodownloads
if /i "%MENU1%" EQU "W" goto:WorUSB
if /i "%MENU1%" EQU "U" goto:WorUSB
if /i "%MENU1%" EQU "H" goto:WorUSB
if /i "%MENU1%" EQU "SU" goto:WorUSB
if /i "%MENU1%" EQU "RC" goto:WorUSB

echo           Y = Yes, Begin Downloading

:WorUSB
if /i "%MENU1%" EQU "W" echo           Y = Yes, Generate Guide and Begin Downloading
if /i "%MENU1%" EQU "W" echo           G = Generate Guide Only
if /i "%MENU1%" EQU "U" echo           Y = Yes, Generate Guide and Begin Downloading
if /i "%MENU1%" EQU "U" echo           G = Generate Guide Only
if /i "%MENU1%" EQU "H" echo           Y = Yes, Generate Guide and Begin Downloading
if /i "%MENU1%" EQU "H" echo           G = Generate Guide Only
if /i "%MENU1%" EQU "SU" echo           Y = Yes, Generate Guide and Begin Downloading
if /i "%MENU1%" EQU "SU" echo           G = Generate Guide Only
if /i "%MENU1%" EQU "RC" echo           Y = Yes, Generate Guide and Begin Downloading
if /i "%MENU1%" EQU "RC" echo           G = Generate Guide Only

:zerodownloads

if /i "%MENU1%" EQU "1" echo           A = Add more files to batch download list
if /i "%MENU1%" EQU "2" echo           A = Add more files to batch download list
if /i "%MENU1%" EQU "3" echo           A = Add more files to batch download list
if /i "%MENU1%" EQU "4" echo           A = Add more files to batch download list
if /i "%MENU1%" EQU "A" echo           A = Add more files to batch download list
if /i "%MENU1%" EQU "L" echo           A = Add more files to batch download list
echo.
echo           S = Save Download Queue
echo.


echo           B = Back
echo           M = Main Menu
echo.
set /p SETTINGS=     Enter Selection Here: 




if /i "%SETTINGS%" EQU "B" mode con cols=85 lines=54
if /i "%SETTINGS%" EQU "B" goto:%BACKB4QUEUE%
if /i "%SETTINGS%" EQU "M" goto:MENU

if /i "%SETTINGS%" EQU "S" (set beforesave=DOWNLOADQUEUE) & (goto:SaveDownloadQueue)

if /i "%MENU1%" NEQ "L" goto:notbatch
if /i "%SETTINGS%" EQU "A" mode con cols=85 lines=54
if /i "%SETTINGS%" EQU "A" goto:LIST
if /i "%DLTOTAL%" EQU "0" goto:badkey
if /i "%SETTINGS%" EQU "Y" (mode con cols=85 lines=54) & (goto:creditcheck)
:notbatch


if /i "%MENU1%" NEQ "1" goto:notbatch
if /i "%SETTINGS%" EQU "A" mode con cols=85 lines=54
if /i "%SETTINGS%" EQU "A" goto:%BACKB4QUEUE%
if /i "%DLTOTAL%" EQU "0" goto:badkey
if /i "%SETTINGS%" EQU "Y" (mode con cols=85 lines=54) & (goto:creditcheck)
:notbatch

if /i "%MENU1%" NEQ "2" goto:notoldbatch
if /i "%SETTINGS%" EQU "A" mode con cols=85 lines=54
if /i "%SETTINGS%" EQU "A" set lines=54
if /i "%SETTINGS%" EQU "A" goto:%BACKB4QUEUE%
if /i "%DLTOTAL%" EQU "0" goto:badkey
if /i "%SETTINGS%" EQU "Y" (mode con cols=85 lines=54) & (goto:creditcheck)
:notoldbatch

if /i "%MENU1%" NEQ "3" goto:NotBatchApp
if /i "%SETTINGS%" EQU "A" mode con cols=85 lines=54
if /i "%SETTINGS%" EQU "A" set lines=54
if /i "%SETTINGS%" EQU "A" goto:%BACKB4QUEUE%
if /i "%DLTOTAL%" EQU "0" goto:badkey
if /i "%SETTINGS%" EQU "Y" (mode con cols=85 lines=54) & (goto:creditcheck)
:NotBatchApp

if /i "%MENU1%" NEQ "4" goto:NotLIST4
if /i "%SETTINGS%" EQU "A" mode con cols=85 lines=54
if /i "%SETTINGS%" EQU "A" set lines=54
if /i "%SETTINGS%" EQU "A" goto:%BACKB4QUEUE%
if /i "%DLTOTAL%" EQU "0" goto:badkey
if /i "%SETTINGS%" EQU "Y" (mode con cols=85 lines=54) & (goto:creditcheck)
:NotLIST4

if /i "%MENU1%" NEQ "A" goto:NotAdv
if /i "%SETTINGS%" EQU "A" mode con cols=85 lines=54
if /i "%SETTINGS%" EQU "A" set lines=54
if /i "%SETTINGS%" EQU "A" goto:%BACKB4QUEUE%
if /i "%DLTOTAL%" EQU "0" goto:badkey
if /i "%SETTINGS%" EQU "Y" (mode con cols=85 lines=54) & (goto:creditcheck)
:NotAdv

if /i "%DLTOTAL%" EQU "0" goto:badkey
if /i "%SETTINGS%" EQU "Y" (mode con cols=85 lines=54) & (goto:COPY)


if /i "%MENU1%" EQU "W" goto:generateguideonly
if /i "%MENU1%" EQU "U" goto:generateguideonly
if /i "%MENU1%" EQU "H" goto:generateguideonly
if /i "%MENU1%" EQU "SU" goto:generateguideonly
if /i "%MENU1%" EQU "RC" goto:generateguideonly
goto:badkey

:generateguideonly

if /i "%SETTINGS%" EQU "G" (mode con cols=85 lines=54) & (goto:guide)


:badkey
echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:DOWNLOADQUEUE


::--------------------------SAVE DOWNLOAD QUEUE-----------------------
:SaveDownloadQueue
set DLQUEUENAME=
cls
echo                                        ModMii                                v%currentversion%
echo                                       by XFlak
echo.
echo                     Please enter a name for your Download Queue
echo.
echo.
echo          Note: Cannot contain \ / : * ? " < > | & %%
echo.
echo.
echo          Note: Download Queues are saved to "temp\DownloadQueues"
echo                and can be shared amongst different ModMii users
echo.
echo.
echo.
echo                B = Back
echo.
echo                M = Main Menu
echo.
echo.
echo.
set /p DLQUEUENAME=     Enter Selection Here: 

if "%DLQUEUENAME%"=="" goto:badkey

if /i "%DLQUEUENAME%" EQU "M" goto:MENU
if /i "%DLQUEUENAME%" EQU "B" goto:%beforesave%

echo "set DLQUEUENAME=%DLQUEUENAME%">temp\temp.bat

support\sfk filter -quiet -spat temp\temp.bat -rep _\x5c__ -rep _\x2f__ -rep _\x3a__ -rep _\x2a__ -rep _\x3f__ -rep _\x3c__ -rep _\x3e__ -rep _\x7c__ -rep _\x22__ -write -yes

call temp\temp.bat
del temp\temp.bat>nul

if not exist "temp\DownloadQueues\%DLQUEUENAME%.bat" goto:SaveDownloadQueue2

::queue with the same name already exists
echo.
echo A Download Queue with this name already exists, overwrite it? (Y/N)
echo.
set /p overwritequeue=     Enter Selection Here: 

if /i "%overwritequeue%" EQU "Y" (goto:SaveDownloadQueue2) else (goto:SaveDownloadQueue)

:badkey
echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:SaveDownloadQueue


:SaveDownloadQueue2
cls
echo                                        ModMii                                v%currentversion%
echo                                       by XFlak
echo.
echo                                  Saving Download Queue
echo.

if not exist temp\DownloadQueues mkdir temp\DownloadQueues

set AdvNumberCOPY=%AdvNumber%
if /i "%SETTINGS%" EQU "S" set AdvNumberCOPY=0
if /i "%FINISH%" EQU "S" set AdvNumberCOPY=0

::set GetAdvNumberOnly=Y
::if exist "temp\DownloadQueues\%DLQUEUENAME%.bat" call "temp\DownloadQueues\%DLQUEUENAME%.bat"
::set GetAdvNumberOnly=

set /a AdvNumberCOPY=%AdvNumberCOPY%+%AdvNumber%

set AdvNumberCOPY2=%AdvNumber%
if /i "%SETTINGS%" EQU "S" set AdvNumberCOPY2=0
if /i "%FINISH%" EQU "S" set AdvNumberCOPY2=0

set AdvNumberCOPY3=%AdvNumberCOPY2%
::set AdvNumber=0

::if exist "temp\DownloadQueues\%DLQUEUENAME%.bat" support\sfk filter -quiet "temp\DownloadQueues\%DLQUEUENAME%.bat" -ls!":endofqueue" -write -yes
::if exist "temp\DownloadQueues\%DLQUEUENAME%.bat" support\sfk filter -quiet -spat "temp\DownloadQueues\%DLQUEUENAME%.bat" -rep _\x22_quote_ -write -yes

echo.

echo ::ModMii v%currentversion% - Download Queue - %DATE% - %TIME% > "temp\DownloadQueues\%DLQUEUENAME%.bat"

echo "set AdvNumber=%AdvNumbercopy%">>"temp\DownloadQueues\%DLQUEUENAME%.bat"
echo "if /i quote@GetAdvNumberOnly@quote EQU quoteYquote goto:endofqueue">>"temp\DownloadQueues\%DLQUEUENAME%.bat"

echo ::Queue Settings>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
echo Set ROOTSAVE=%ROOTSAVE%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
echo Set Option1=%Option1%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"

echo ::Queue>> "temp\DownloadQueues\%DLQUEUENAME%.bat"

if /i "%EULAU%" EQU "*" echo SET EULAU=%EULAU%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%EULAE%" EQU "*" echo SET EULAE=%EULAE%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%EULAJ%" EQU "*" echo SET EULAJ=%EULAJ%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%EULAK%" EQU "*" echo SET EULAK=%EULAK%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%RSU%" EQU "*" echo SET RSU=%RSU%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%RSE%" EQU "*" echo SET RSE=%RSE%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%RSJ%" EQU "*" echo SET RSJ=%RSJ%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%RSK%" EQU "*" echo SET RSK=%RSK%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%BC%" EQU "*" echo SET BC=%BC%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"

if /i "%SM3.2U%" EQU "*" echo SET SM3.2U=%SM3.2U%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%SM4.1U%" EQU "*" echo SET SM4.1U=%SM4.1U%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%SM4.2U%" EQU "*" echo SET SM4.2U=%SM4.2U%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%SM4.3U%" EQU "*" echo SET SM4.3U=%SM4.3U%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%SM3.2E%" EQU "*" echo SET SM3.2E=%SM3.2E%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%SM4.1E%" EQU "*" echo SET SM4.1E=%SM4.1E%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%SM4.2E%" EQU "*" echo SET SM4.2E=%SM4.2E%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%SM4.3E%" EQU "*" echo SET SM4.3E=%SM4.3E%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%SM3.2J%" EQU "*" echo SET SM3.2J=%SM3.2J%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%SM4.1J%" EQU "*" echo SET SM4.1J=%SM4.1J%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%SM4.2J%" EQU "*" echo SET SM4.2J=%SM4.2J%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%SM4.3J%" EQU "*" echo SET SM4.3J=%SM4.3J%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%SM4.1K%" EQU "*" echo SET SM4.1K=%SM4.1K%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%SM4.2K%" EQU "*" echo SET SM4.2K=%SM4.2K%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%SM4.3K%" EQU "*" echo SET SM4.3K=%SM4.3K%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%SM4.3U-DWR%" EQU "*" echo SET SM4.3U-DWR=%SM4.3U-DWR%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%SM4.2U-DWR%" EQU "*" echo SET SM4.2U-DWR=%SM4.2U-DWR%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%SM4.1U-DWR%" EQU "*" echo SET SM4.1U-DWR=%SM4.1U-DWR%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%SM4.3E-DWR%" EQU "*" echo SET SM4.3E-DWR=%SM4.3E-DWR%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%SM4.2E-DWR%" EQU "*" echo SET SM4.2E-DWR=%SM4.2E-DWR%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%SM4.1E-DWR%" EQU "*" echo SET SM4.1E-DWR=%SM4.1E-DWR%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%SM4.3J-DWR%" EQU "*" echo SET SM4.3J-DWR=%SM4.3J-DWR%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%SM4.2J-DWR%" EQU "*" echo SET SM4.2J-DWR=%SM4.2J-DWR%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%SM4.1J-DWR%" EQU "*" echo SET SM4.1J-DWR=%SM4.1J-DWR%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%SM4.3K-DWR%" EQU "*" echo SET SM4.3K-DWR=%SM4.3K-DWR%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%SM4.2K-DWR%" EQU "*" echo SET SM4.2K-DWR=%SM4.2K-DWR%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%SM4.1K-DWR%" EQU "*" echo SET SM4.1K-DWR=%SM4.1K-DWR%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"

if /i "%SM4.3U-DWG%" EQU "*" echo SET SM4.3U-DWG=%SM4.3U-DWG%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%SM4.2U-DWG%" EQU "*" echo SET SM4.2U-DWG=%SM4.2U-DWG%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%SM4.1U-DWG%" EQU "*" echo SET SM4.1U-DWG=%SM4.1U-DWG%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%SM4.3E-DWG%" EQU "*" echo SET SM4.3E-DWG=%SM4.3E-DWG%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%SM4.2E-DWG%" EQU "*" echo SET SM4.2E-DWG=%SM4.2E-DWG%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%SM4.1E-DWG%" EQU "*" echo SET SM4.1E-DWG=%SM4.1E-DWG%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%SM4.3J-DWG%" EQU "*" echo SET SM4.3J-DWG=%SM4.3J-DWG%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%SM4.2J-DWG%" EQU "*" echo SET SM4.2J-DWG=%SM4.2J-DWG%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%SM4.1J-DWG%" EQU "*" echo SET SM4.1J-DWG=%SM4.1J-DWG%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%SM4.3K-DWG%" EQU "*" echo SET SM4.3K-DWG=%SM4.3K-DWG%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%SM4.2K-DWG%" EQU "*" echo SET SM4.2K-DWG=%SM4.2K-DWG%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%SM4.1K-DWG%" EQU "*" echo SET SM4.1K-DWG=%SM4.1K-DWG%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"

if /i "%SM4.3U-DWB%" EQU "*" echo SET SM4.3U-DWB=%SM4.3U-DWB%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%SM4.2U-DWB%" EQU "*" echo SET SM4.2U-DWB=%SM4.2U-DWB%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%SM4.1U-DWB%" EQU "*" echo SET SM4.1U-DWB=%SM4.1U-DWB%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%SM4.3E-DWB%" EQU "*" echo SET SM4.3E-DWB=%SM4.3E-DWB%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%SM4.2E-DWB%" EQU "*" echo SET SM4.2E-DWB=%SM4.2E-DWB%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%SM4.1E-DWB%" EQU "*" echo SET SM4.1E-DWB=%SM4.1E-DWB%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%SM4.3J-DWB%" EQU "*" echo SET SM4.3J-DWB=%SM4.3J-DWB%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%SM4.2J-DWB%" EQU "*" echo SET SM4.2J-DWB=%SM4.2J-DWB%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%SM4.1J-DWB%" EQU "*" echo SET SM4.1J-DWB=%SM4.1J-DWB%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%SM4.3K-DWB%" EQU "*" echo SET SM4.3K-DWB=%SM4.3K-DWB%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%SM4.2K-DWB%" EQU "*" echo SET SM4.2K-DWB=%SM4.2K-DWB%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%SM4.1K-DWB%" EQU "*" echo SET SM4.1K-DWB=%SM4.1K-DWB%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"

if /i "%SM4.3U-DWO%" EQU "*" echo SET SM4.3U-DWO=%SM4.3U-DWO%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%SM4.2U-DWO%" EQU "*" echo SET SM4.2U-DWO=%SM4.2U-DWO%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%SM4.1U-DWO%" EQU "*" echo SET SM4.1U-DWO=%SM4.1U-DWO%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%SM4.3E-DWO%" EQU "*" echo SET SM4.3E-DWO=%SM4.3E-DWO%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%SM4.2E-DWO%" EQU "*" echo SET SM4.2E-DWO=%SM4.2E-DWO%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%SM4.1E-DWO%" EQU "*" echo SET SM4.1E-DWO=%SM4.1E-DWO%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%SM4.3J-DWO%" EQU "*" echo SET SM4.3J-DWO=%SM4.3J-DWO%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%SM4.2J-DWO%" EQU "*" echo SET SM4.2J-DWO=%SM4.2J-DWO%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%SM4.1J-DWO%" EQU "*" echo SET SM4.1J-DWO=%SM4.1J-DWO%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%SM4.3K-DWO%" EQU "*" echo SET SM4.3K-DWO=%SM4.3K-DWO%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%SM4.2K-DWO%" EQU "*" echo SET SM4.2K-DWO=%SM4.2K-DWO%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%SM4.1K-DWO%" EQU "*" echo SET SM4.1K-DWO=%SM4.1K-DWO%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"

if /i "%IOS30%" EQU "*" echo SET IOS30=%IOS30%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%IOS30P60%" EQU "*" echo SET IOS30P60=%IOS30P60%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%IOS20P60%" EQU "*" echo SET IOS20P60=%IOS20P60%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%IOS30P%" EQU "*" echo SET IOS30P=%IOS30P%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%IOS11P60%" EQU "*" echo SET IOS11P60=%IOS11P60%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%IOS20P60%" EQU "*" echo SET IOS20P60=%IOS20P60%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%IOS50P%" EQU "*" echo SET IOS50P=%IOS50P%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%IOS52P%" EQU "*" echo SET IOS52P=%IOS52P%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%IOS60%" EQU "*" echo SET IOS60=%IOS60%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%IOS60P%" EQU "*" echo SET IOS60P=%IOS60P%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%IOS70%" EQU "*" echo SET IOS70=%IOS70%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%IOS70P%" EQU "*" echo SET IOS70P=%IOS70P%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%IOS70K%" EQU "*" echo SET IOS70K=%IOS70K%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%IOS80%" EQU "*" echo SET IOS80=%IOS80%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%IOS80P%" EQU "*" echo SET IOS80P=%IOS80P%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%IOS80K%" EQU "*" echo SET IOS80K=%IOS80K%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%IOS236%" EQU "*" echo SET IOS236=%IOS236%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%BB1%" EQU "*" echo SET BB1=%BB1%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%BB2%" EQU "*" echo SET BB2=%BB2%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%HM%" EQU "*" echo SET HM=%HM%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%IOS236Installer%" EQU "*" echo SET IOS236Installer=%IOS236Installer%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%SIP%" EQU "*" echo SET SIP=%SIP%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%dop%" EQU "*" echo SET dop=%dop%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%syscheck%" EQU "*" echo SET syscheck=%syscheck%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%AccioHacks%" EQU "*" echo SET AccioHacks=%AccioHacks%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%MyM%" EQU "*" echo SET MyM=%MyM%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%locked%" EQU "*" echo SET locked=%locked%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%HBB%" EQU "*" echo SET HBB=%HBB%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%WII64%" EQU "*" echo SET WII64=%WII64%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%Casper%" EQU "*" echo SET Casper=%Casper%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"

if /i "%Wilbrand%" EQU "*" echo SET Wilbrand=%Wilbrand%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%Wilbrand%" EQU "*" echo SET REGION=%REGION%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%Wilbrand%" EQU "*" echo SET macaddress=%macaddress% >> "temp\DownloadQueues\%DLQUEUENAME%.bat"

if /i "%WIISX%" EQU "*" echo SET WIISX=%WIISX%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%bootmiisd%" EQU "*" echo SET bootmiisd=%bootmiisd%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%pwns%" EQU "*" echo SET pwns=%pwns%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%Twi%" EQU "*" echo SET Twi=%Twi%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%YUGI%" EQU "*" echo SET YUGI=%YUGI%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%Bathaxx%" EQU "*" echo SET Bathaxx=%Bathaxx%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%ROTJ%" EQU "*" echo SET ROTJ=%ROTJ%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%TOS%" EQU "*" echo SET TOS=%TOS%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%smash%" EQU "*" echo SET smash=%smash%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%mmm%" EQU "*" echo SET mmm=%mmm%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%WiiMod%" EQU "*" echo SET WiiMod=%WiiMod%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%ARC%" EQU "*" echo SET ARC=%ARC%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%yawm%" EQU "*" echo SET yawm=%yawm%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%neogamma%" EQU "*" echo SET neogamma=%neogamma%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%usbfolder%" EQU "*" echo SET usbfolder=%usbfolder%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%WiiMC%" EQU "*" echo SET WiiMC=%WiiMC%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%fceugx%" EQU "*" echo SET fceugx=%fceugx%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%snes9xgx%" EQU "*" echo SET snes9xgx=%snes9xgx%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%vbagx%" EQU "*" echo SET vbagx=%vbagx%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%SGM%" EQU "*" echo SET SGM=%SGM%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%PL%" EQU "*" echo SET PL=%PL%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%WIIX%" EQU "*" echo SET WIIX=%WIIX%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%wbm%" EQU "*" echo SET wbm=%wbm%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%CheatCodes%" EQU "*" echo SET CheatCodes=%CheatCodes%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%f32%" EQU "*" echo SET f32=%f32%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"

if /i "%CM%" EQU "*" echo SET CM=%CM%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%SMW%" EQU "*" echo SET SMW=%SMW%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%WiiGSC%" EQU "*" echo SET WiiGSC=%WiiGSC%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"

if /i "%FLOW%" EQU "*" echo SET FLOW=%FLOW%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%USBX%" EQU "*" echo SET USBX=%USBX%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%FLOWF%" EQU "*" echo SET FLOWF=%FLOWF%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%S2U%" EQU "*" echo SET S2U=%S2U%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%nSwitch%" EQU "*" echo SET nSwitch=%nSwitch%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%PLC%" EQU "*" echo SET PLC=%PLC%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%Pri%" EQU "*" echo SET Pri=%Pri%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%HAX%" EQU "*" echo SET HAX=%HAX%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%MII%" EQU "*" echo SET MII=%MII%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%P0%" EQU "*" echo SET P0=%P0%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%P%" EQU "*" echo SET P=%P%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%PK%" EQU "*" echo SET PK=%PK%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%S%" EQU "*" echo SET S=%S%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%SK%" EQU "*" echo SET SK=%SK%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%IU%" EQU "*" echo SET IU=%IU%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%IE%" EQU "*" echo SET IE=%IE%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%IJ%" EQU "*" echo SET IJ=%IJ%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%WU%" EQU "*" echo SET WU=%WU%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%WE%" EQU "*" echo SET WE=%WE%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%WJ%" EQU "*" echo SET WJ=%WJ%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%NU%" EQU "*" echo SET NU=%NU%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%NE%" EQU "*" echo SET NE=%NE%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%NJ%" EQU "*" echo SET NJ=%NJ%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%WSU%" EQU "*" echo SET WSU=%WSU%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%WSE%" EQU "*" echo SET WSE=%WSE%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%WSJ%" EQU "*" echo SET WSJ=%WSJ%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%M10%" EQU "*" echo SET M10=%M10%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%IOS9%" EQU "*" echo SET IOS9=%IOS9%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%IOS12%" EQU "*" echo SET IOS12=%IOS12%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%IOS13%" EQU "*" echo SET IOS13=%IOS13%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%IOS14%" EQU "*" echo SET IOS14=%IOS14%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%IOS15%" EQU "*" echo SET IOS15=%IOS15%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%IOS17%" EQU "*" echo SET IOS17=%IOS17%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%IOS21%" EQU "*" echo SET IOS21=%IOS21%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%IOS22%" EQU "*" echo SET IOS22=%IOS22%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%IOS28%" EQU "*" echo SET IOS28=%IOS28%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%IOS31%" EQU "*" echo SET IOS31=%IOS31%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%IOS33%" EQU "*" echo SET IOS33=%IOS33%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%IOS34%" EQU "*" echo SET IOS34=%IOS34%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%IOS35%" EQU "*" echo SET IOS35=%IOS35%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%IOS36%" EQU "*" echo SET IOS36=%IOS36%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%IOS36v3608%" EQU "*" echo SET IOS36v3608=%IOS36v3608%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%IOS37%" EQU "*" echo SET IOS37=%IOS37%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%IOS38%" EQU "*" echo SET IOS38=%IOS38%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%IOS41%" EQU "*" echo SET IOS41=%IOS41%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%IOS48v4124%" EQU "*" echo SET IOS48v4124=%IOS48v4124%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%IOS43%" EQU "*" echo SET IOS43=%IOS43%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%IOS45%" EQU "*" echo SET IOS45=%IOS45%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%IOS46%" EQU "*" echo SET IOS46=%IOS46%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%IOS53%" EQU "*" echo SET IOS53=%IOS53%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%IOS55%" EQU "*" echo SET IOS55=%IOS55%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%IOS56%" EQU "*" echo SET IOS56=%IOS56%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%IOS57%" EQU "*" echo SET IOS57=%IOS57%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%IOS58%" EQU "*" echo SET IOS58=%IOS58%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%IOS61%" EQU "*" echo SET IOS61=%IOS61%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%IOS62%" EQU "*" echo SET IOS62=%IOS62%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"

if /i "%A0e%" EQU "*" echo SET A0e=%A0e%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%A01%" EQU "*" echo SET A01=%A01%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"

if /i "%A0e_70%" EQU "*" echo SET A0e_70=%A0e_70%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%A01%" EQU "*" echo SET A01__60=%A01_60%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%A0e_60%" EQU "*" echo SET A0e_60=%A0e_60%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%A01%" EQU "*" echo SET A01=%A01%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%A0c%" EQU "*" echo SET A0c=%A0c%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"

if /i "%A40%" EQU "*" echo SET A40=%A40%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%A42%" EQU "*" echo SET A42=%A42%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%A45%" EQU "*" echo SET A45=%A45%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%A70%" EQU "*" echo SET A70=%A70%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%A72%" EQU "*" echo SET A72=%A72%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%A75%" EQU "*" echo SET A75=%A75%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%A78%" EQU "*" echo SET A78=%A78%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%A7b%" EQU "*" echo SET A7b=%A7b%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%A7e%" EQU "*" echo SET A7e=%A7e%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%A84%" EQU "*" echo SET A84=%A84%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%A87%" EQU "*" echo SET A87=%A87%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%A8a%" EQU "*" echo SET A8a=%A8a%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"

if /i "%A81%" EQU "*" echo SET A81=%A81%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%A8d%" EQU "*" echo SET A8d=%A8d%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%A9d%" EQU "*" echo SET A9d=%A9d%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"

if /i "%A94%" EQU "*" echo SET A94=%A94%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%A97%" EQU "*" echo SET A97=%A97%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%A9a%" EQU "*" echo SET A9a=%A9a%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%cIOS202[37]-v5%" EQU "*" echo SET cIOS202[37]-v5=%cIOS202[37]-v5%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%cIOS202[38]-v5%" EQU "*" echo SET cIOS202[38]-v5=%cIOS202[38]-v5%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%cIOS222[38]-v4%" EQU "*" echo SET cIOS222[38]-v4=%cIOS222[38]-v4%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"

if /i "%cIOS223[37-38]-v4%" EQU "*" echo SET cIOS223[37-38]-v4=%cIOS223[37-38]-v4%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%cBC%" EQU "*" echo SET cBC=%cBC%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%DML%" EQU "*" echo SET DML=%DML%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%DML%" EQU "*" echo "SET CurrentDMLRev=%CurrentDMLRev%">> "temp\DownloadQueues\%DLQUEUENAME%.bat"


if /i "%cIOS222[38]-v5%" EQU "*" echo SET cIOS222[38]-v5=%cIOS222[38]-v5%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%cIOS223[37]-v5%" EQU "*" echo SET cIOS223[37]-v5=%cIOS223[37]-v5%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%cIOS224[57]-v5%" EQU "*" echo SET cIOS224[57]-v5=%cIOS224[57]-v5%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"


if /i "%cIOS202[60]-v5.1R%" EQU "*" echo SET cIOS202[60]-v5.1R=%cIOS202[60]-v5.1R%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%cIOS222[38]-v5.1R%" EQU "*" echo SET cIOS222[38]-v5.1R=%cIOS222[38]-v5.1R%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%cIOS223[37]-v5.1R%" EQU "*" echo SET cIOS223[37]-v5.1R=%cIOS223[37]-v5.1R%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%cIOS224[57]-v5.1R%" EQU "*" echo SET cIOS224[57]-v5.1R=%cIOS224[57]-v5.1R%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%cIOS249-v14%" EQU "*" echo SET cIOS249-v14=%cIOS249-v14%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%cIOS249-v17b%" EQU "*" echo SET cIOS249-v17b=%cIOS249-v17b%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%cIOS249[37]-v19%" EQU "*" echo SET cIOS249[37]-v19=%cIOS249[37]-v19%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%cIOS249[38]-v19%" EQU "*" echo SET cIOS249[38]-v19=%cIOS249[38]-v19%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%cIOS249[57]-v19%" EQU "*" echo SET cIOS249[57]-v19=%cIOS249[57]-v19%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%cIOS250-v14%" EQU "*" echo SET cIOS250-v14=%cIOS250-v14%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%cIOS250-v17b%" EQU "*" echo SET cIOS250-v17b=%cIOS250-v17b%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%cIOS250[37]-v19%" EQU "*" echo SET cIOS250[37]-v19=%cIOS250[37]-v19%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%cIOS250[38]-v19%" EQU "*" echo SET cIOS250[38]-v19=%cIOS250[38]-v19%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%cIOS250[57]-v19%" EQU "*" echo SET cIOS250[57]-v19=%cIOS250[57]-v19%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%cIOS249[38]-v20%" EQU "*" echo SET cIOS249[38]-v20=%cIOS249[38]-v20%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%cIOS250[38]-v20%" EQU "*" echo SET cIOS250[38]-v20=%cIOS250[38]-v20%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%cIOS249[56]-v20%" EQU "*" echo SET cIOS249[56]-v20=%cIOS249[56]-v20%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%cIOS250[56]-v20%" EQU "*" echo SET cIOS250[56]-v20=%cIOS250[56]-v20%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%cIOS249[57]-v20%" EQU "*" echo SET cIOS249[57]-v20=%cIOS249[57]-v20%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%cIOS250[57]-v20%" EQU "*" echo SET cIOS250[57]-v20=%cIOS250[57]-v20%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%cIOS249[37]-v21%" EQU "*" echo SET cIOS249[37]-v21=%cIOS249[37]-v21%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%cIOS250[37]-v21%" EQU "*" echo SET cIOS250[37]-v21=%cIOS250[37]-v21%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%cIOS249[38]-v21%" EQU "*" echo SET cIOS249[38]-v21=%cIOS249[38]-v21%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%cIOS250[38]-v21%" EQU "*" echo SET cIOS250[38]-v21=%cIOS250[38]-v21%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%cIOS249[53]-v21%" EQU "*" echo SET cIOS249[53]-v21=%cIOS249[53]-v21%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%cIOS250[53]-v21%" EQU "*" echo SET cIOS250[53]-v21=%cIOS250[53]-v21%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%cIOS249[55]-v21%" EQU "*" echo SET cIOS249[55]-v21=%cIOS249[55]-v21%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%cIOS250[55]-v21%" EQU "*" echo SET cIOS250[55]-v21=%cIOS250[55]-v21%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%cIOS249[56]-v21%" EQU "*" echo SET cIOS249[56]-v21=%cIOS249[56]-v21%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%cIOS250[56]-v21%" EQU "*" echo SET cIOS250[56]-v21=%cIOS250[56]-v21%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%cIOS249[57]-v21%" EQU "*" echo SET cIOS249[57]-v21=%cIOS249[57]-v21%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%cIOS250[57]-v21%" EQU "*" echo SET cIOS250[57]-v21=%cIOS250[57]-v21%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%cIOS249[58]-v21%" EQU "*" echo SET cIOS249[58]-v21=%cIOS249[58]-v21%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%cIOS250[58]-v21%" EQU "*" echo SET cIOS250[58]-v21=%cIOS250[58]-v21%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%cIOS249[37]-d2x-v8-final%" EQU "*" echo SET cIOS249[37]-d2x-v8-final=%cIOS249[37]-d2x-v8-final%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%cIOS249[38]-d2x-v8-final%" EQU "*" echo SET cIOS249[38]-d2x-v8-final=%cIOS249[38]-d2x-v8-final%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%cIOS249[56]-d2x-v8-final%" EQU "*" echo SET cIOS249[56]-d2x-v8-final=%cIOS249[56]-d2x-v8-final%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%cIOS249[53]-d2x-v8-final%" EQU "*" echo SET cIOS249[53]-d2x-v8-final=%cIOS249[53]-d2x-v8-final%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%cIOS249[55]-d2x-v8-final%" EQU "*" echo SET cIOS249[55]-d2x-v8-final=%cIOS249[55]-d2x-v8-final%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%cIOS249[57]-d2x-v8-final%" EQU "*" echo SET cIOS249[57]-d2x-v8-final=%cIOS249[57]-d2x-v8-final%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%cIOS249[58]-d2x-v8-final%" EQU "*" echo SET cIOS249[58]-d2x-v8-final=%cIOS249[58]-d2x-v8-final%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%cIOS249[60]-d2x-v8-final%" EQU "*" echo SET cIOS249[60]-d2x-v8-final=%cIOS249[60]-d2x-v8-final%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%cIOS249[70]-d2x-v8-final%" EQU "*" echo SET cIOS249[70]-d2x-v8-final=%cIOS249[70]-d2x-v8-final%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%cIOS249[80]-d2x-v8-final%" EQU "*" echo SET cIOS249[80]-d2x-v8-final=%cIOS249[80]-d2x-v8-final%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%cIOS250[37]-d2x-v8-final%" EQU "*" echo SET cIOS250[37]-d2x-v8-final=%cIOS250[37]-d2x-v8-final%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%cIOS250[38]-d2x-v8-final%" EQU "*" echo SET cIOS250[38]-d2x-v8-final=%cIOS250[38]-d2x-v8-final%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%cIOS250[53]-d2x-v8-final%" EQU "*" echo SET cIOS250[53]-d2x-v8-final=%cIOS250[53]-d2x-v8-final%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%cIOS250[55]-d2x-v8-final%" EQU "*" echo SET cIOS250[55]-d2x-v8-final=%cIOS250[55]-d2x-v8-final%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%cIOS250[56]-d2x-v8-final%" EQU "*" echo SET cIOS250[56]-d2x-v8-final=%cIOS250[56]-d2x-v8-final%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%cIOS250[57]-d2x-v8-final%" EQU "*" echo SET cIOS250[57]-d2x-v8-final=%cIOS250[57]-d2x-v8-final%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%cIOS250[58]-d2x-v8-final%" EQU "*" echo SET cIOS250[58]-d2x-v8-final=%cIOS250[58]-d2x-v8-final%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%cIOS250[60]-d2x-v8-final%" EQU "*" echo SET cIOS250[60]-d2x-v8-final=%cIOS250[60]-d2x-v8-final%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%cIOS250[70]-d2x-v8-final%" EQU "*" echo SET cIOS250[70]-d2x-v8-final=%cIOS250[70]-d2x-v8-final%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%cIOS250[80]-d2x-v8-final%" EQU "*" echo SET cIOS250[80]-d2x-v8-final=%cIOS250[80]-d2x-v8-final%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%RVL-cMIOS-v65535(v10)_WiiGator_WiiPower_v0.2%" EQU "*" echo SET RVL-cMIOS-v65535(v10)_WiiGator_WiiPower_v0.2=%RVL-cMIOS-v65535(v10)_WiiGator_WiiPower_v0.2%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%RVL-cmios-v4_WiiGator_GCBL_v0.2%" EQU "*" echo SET RVL-cmios-v4_WiiGator_GCBL_v0.2=%RVL-cmios-v4_WiiGator_GCBL_v0.2%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%RVL-cmios-v4_Waninkoko_rev5%" EQU "*" echo SET RVL-cmios-v4_Waninkoko_rev5=%RVL-cmios-v4_Waninkoko_rev5%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"

if /i "%DarkWii_Red_4.3U%" EQU "*" echo SET DarkWii_Red_4.3U=%DarkWii_Red_4.3U%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%DarkWii_Red_4.2U%" EQU "*" echo SET DarkWii_Red_4.2U=%DarkWii_Red_4.2U%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%DarkWii_Red_4.1U%" EQU "*" echo SET DarkWii_Red_4.1U=%DarkWii_Red_4.1U%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%DarkWii_Red_4.3E%" EQU "*" echo SET DarkWii_Red_4.3E=%DarkWii_Red_4.3E%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%DarkWii_Red_4.2E%" EQU "*" echo SET DarkWii_Red_4.2E=%DarkWii_Red_4.2E%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%DarkWii_Red_4.1E%" EQU "*" echo SET DarkWii_Red_4.1E=%DarkWii_Red_4.1E%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%DarkWii_Red_4.3J%" EQU "*" echo SET DarkWii_Red_4.3J=%DarkWii_Red_4.3J%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%DarkWii_Red_4.2J%" EQU "*" echo SET DarkWii_Red_4.2J=%DarkWii_Red_4.2J%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%DarkWii_Red_4.1J%" EQU "*" echo SET DarkWii_Red_4.1J=%DarkWii_Red_4.1J%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%DarkWii_Red_4.3K%" EQU "*" echo SET DarkWii_Red_4.3K=%DarkWii_Red_4.3K%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%DarkWii_Red_4.2K%" EQU "*" echo SET DarkWii_Red_4.2K=%DarkWii_Red_4.2K%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%DarkWii_Red_4.1K%" EQU "*" echo SET DarkWii_Red_4.1K=%DarkWii_Red_4.1K%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"

if /i "%DarkWii_Green_4.3U%" EQU "*" echo SET DarkWii_Green_4.3U=%DarkWii_Green_4.3U%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%DarkWii_Green_4.2U%" EQU "*" echo SET DarkWii_Green_4.2U=%DarkWii_Green_4.2U%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%DarkWii_Green_4.1U%" EQU "*" echo SET DarkWii_Green_4.1U=%DarkWii_Green_4.1U%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%DarkWii_Green_4.3E%" EQU "*" echo SET DarkWii_Green_4.3E=%DarkWii_Green_4.3E%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%DarkWii_Green_4.2E%" EQU "*" echo SET DarkWii_Green_4.2E=%DarkWii_Green_4.2E%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%DarkWii_Green_4.1E%" EQU "*" echo SET DarkWii_Green_4.1E=%DarkWii_Green_4.1E%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%DarkWii_Green_4.3J%" EQU "*" echo SET DarkWii_Green_4.3J=%DarkWii_Green_4.3J%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%DarkWii_Green_4.2J%" EQU "*" echo SET DarkWii_Green_4.2J=%DarkWii_Green_4.2J%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%DarkWii_Green_4.1J%" EQU "*" echo SET DarkWii_Green_4.1J=%DarkWii_Green_4.1J%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%DarkWii_Green_4.3K%" EQU "*" echo SET DarkWii_Green_4.3K=%DarkWii_Green_4.3K%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%DarkWii_Green_4.2K%" EQU "*" echo SET DarkWii_Green_4.2K=%DarkWii_Green_4.2K%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%DarkWii_Green_4.1K%" EQU "*" echo SET DarkWii_Green_4.1K=%DarkWii_Green_4.1K%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"

if /i "%DarkWii_Blue_4.3U%" EQU "*" echo SET DarkWii_Blue_4.3U=%DarkWii_Blue_4.3U%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%DarkWii_Blue_4.2U%" EQU "*" echo SET DarkWii_Blue_4.2U=%DarkWii_Blue_4.2U%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%DarkWii_Blue_4.1U%" EQU "*" echo SET DarkWii_Blue_4.1U=%DarkWii_Blue_4.1U%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%DarkWii_Blue_4.3E%" EQU "*" echo SET DarkWii_Blue_4.3E=%DarkWii_Blue_4.3E%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%DarkWii_Blue_4.2E%" EQU "*" echo SET DarkWii_Blue_4.2E=%DarkWii_Blue_4.2E%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%DarkWii_Blue_4.1E%" EQU "*" echo SET DarkWii_Blue_4.1E=%DarkWii_Blue_4.1E%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%DarkWii_Blue_4.3J%" EQU "*" echo SET DarkWii_Blue_4.3J=%DarkWii_Blue_4.3J%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%DarkWii_Blue_4.2J%" EQU "*" echo SET DarkWii_Blue_4.2J=%DarkWii_Blue_4.2J%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%DarkWii_Blue_4.1J%" EQU "*" echo SET DarkWii_Blue_4.1J=%DarkWii_Blue_4.1J%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%DarkWii_Blue_4.3K%" EQU "*" echo SET DarkWii_Blue_4.3K=%DarkWii_Blue_4.3K%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%DarkWii_Blue_4.2K%" EQU "*" echo SET DarkWii_Blue_4.2K=%DarkWii_Blue_4.2K%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%DarkWii_Blue_4.1K%" EQU "*" echo SET DarkWii_Blue_4.1K=%DarkWii_Blue_4.1K%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"

if /i "%darkwii_orange_4.3U%" EQU "*" echo SET darkwii_orange_4.3U=%darkwii_orange_4.3U%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%darkwii_orange_4.2U%" EQU "*" echo SET darkwii_orange_4.2U=%darkwii_orange_4.2U%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%darkwii_orange_4.1U%" EQU "*" echo SET darkwii_orange_4.1U=%darkwii_orange_4.1U%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%darkwii_orange_4.3E%" EQU "*" echo SET darkwii_orange_4.3E=%darkwii_orange_4.3E%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%darkwii_orange_4.2E%" EQU "*" echo SET darkwii_orange_4.2E=%darkwii_orange_4.2E%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%darkwii_orange_4.1E%" EQU "*" echo SET darkwii_orange_4.1E=%darkwii_orange_4.1E%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%darkwii_orange_4.3J%" EQU "*" echo SET darkwii_orange_4.3J=%darkwii_orange_4.3J%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%darkwii_orange_4.2J%" EQU "*" echo SET darkwii_orange_4.2J=%darkwii_orange_4.2J%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%darkwii_orange_4.1J%" EQU "*" echo SET darkwii_orange_4.1J=%darkwii_orange_4.1J%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%darkwii_orange_4.3K%" EQU "*" echo SET darkwii_orange_4.3K=%darkwii_orange_4.3K%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%darkwii_orange_4.2K%" EQU "*" echo SET darkwii_orange_4.2K=%darkwii_orange_4.2K%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"
if /i "%darkwii_orange_4.1K%" EQU "*" echo SET darkwii_orange_4.1K=%darkwii_orange_4.1K%>> "temp\DownloadQueues\%DLQUEUENAME%.bat"

support\sfk filter "temp\DownloadQueues\%DLQUEUENAME%.bat" -unique -write -yes>nul
support\sfk filter "temp\DownloadQueues\%DLQUEUENAME%.bat" -lerep _" "__ -write -yes>nul

if not exist temp\DLGotosADV.txt goto:quickskip
::Loop through the the following once for EACH line in *.txt
for /F "tokens=*" %%A in (temp\DLGotosADV.txt) do call :process1 %%A
goto:quickskip
:process1
set AdvDLX=%*
set /a AdvNumberCOPY2=%AdvNumberCOPY2%+1
echo "echo %AdvDLX:~0,10%%AdvNumberCOPY2%.batredirectredirecttemp\DLGotosADV.txt">>"temp\DownloadQueues\%DLQUEUENAME%.bat"
goto:EOF
:quickskip


if not exist temp\DLnamesADV.txt goto:quickskip
::Loop through the the following once for EACH line in *.txt
for /F "tokens=*" %%A in (temp\DLnamesADV.txt) do call :process2 %%A
goto:quickskip
:process2
echo "echo %* redirectredirecttemp\DLnamesADV.txt">>"temp\DownloadQueues\%DLQUEUENAME%.bat"
goto:EOF
:quickskip



if not exist temp\DLGotosADV.txt goto:quickskip
copy /y temp\DLGotosADV.txt temp\DLGotosADV-copy.txt>nul
::Loop through the the following once for EACH line in *.txt
:doitagain
for /F "tokens=*" %%A in (temp\DLGotosADV-copy.txt) do call :process3 %%A
goto:quickskip
:process3
set AdvDLX=%*
set /a AdvNumberCOPY3=%AdvNumberCOPY3%+1

echo "if exist %AdvDLX:~0,10%%AdvNumberCOPY3%.bat del %AdvDLX:~0,10%%AdvNumberCOPY3%.batredirectnul">>"temp\DownloadQueues\%DLQUEUENAME%.bat"

for /F "tokens=*" %%A in (%AdvDLX%) do call :process4 %%A
goto:tinyskip
:process4

echo "echo quote%*quoteredirectredirect%AdvDLX:~0,10%%AdvNumberCOPY3%.bat">>"temp\DownloadQueues\%DLQUEUENAME%.bat"


goto:EOF
:tinyskip

support\sfk filter -quiet temp\DLGotosADV-copy.txt -le!"%AdvDLX:~5%" -write -yes

echo "support\sfk filter -quiet %AdvDLX:~0,10%%AdvNumberCOPY3%.bat -rep _quotequotequote__ -write -yes">>"temp\DownloadQueues\%DLQUEUENAME%.bat"


goto:doitagain
::goto:EOF
:quickskip

echo ":endofqueue">>"temp\DownloadQueues\%DLQUEUENAME%.bat"

support\sfk filter "temp\DownloadQueues\%DLQUEUENAME%.bat" -rep _"redirect"_">"_ -write -yes>nul
support\sfk filter -quiet "temp\DownloadQueues\%DLQUEUENAME%.bat" -rep _"""__ -write -yes
support\sfk filter -quiet -spat "temp\DownloadQueues\%DLQUEUENAME%.bat" -rep _quote_\x22_ -rep _@_%%_ -write -yes

support\sfk filter -quiet "temp\DownloadQueues\%DLQUEUENAME%.bat" -rep _"set AdvNumber="*_"set AdvNumber=%AdvNumberCOPY%"_ -write -yes


::support\sfk filter "temp\DownloadQueues\%DLQUEUENAME%.bat" -spat -rep _@_%%_ -write -yes>nul



if exist "temp\DownloadQueues\%DLQUEUENAME%.bat" echo                                  Download Queue Saved
@ping 127.0.0.1 -n 2 -w 1000> nul
if /i "%LIST%" EQU "S" goto:LIST
if /i "%SETTINGS%" EQU "S" goto:DOWNLOADQUEUE
if /i "%SETTINGS%" EQU "S+" goto:DOWNLOADQUEUE
if /i "%FINISH%" EQU "S" goto:FINISH
if /i "%FINISH%" EQU "S+" goto:FINISH






::...................................Copy (rename %Drive%\wad if applicable)...............................
:COPY
if not exist "%Drive%"\WAD goto:creditcheck
if /i "%USBCONFIG%" EQU "USB" goto:creditcheck
::if /i "%DRIVE%" NEQ "COPY_TO_SD" goto:creditcheck

Set COPY=

cls
echo                                        ModMii                                v%currentversion%
echo                                       by XFlak
echo.
echo      %Drive%\WAD Folder already exists, what would you like to do?
echo.
echo           M = Merge downloads with existing %Drive%\WAD Folder.
echo               Duplicates will be skipped.
echo.
echo           R = Rename the existing %Drive%\WAD Folder to %Drive%\WAD#
echo               and begin downloading.
echo.
echo           C = Cancel/Main Menu
echo.
echo           E = Exit
echo.
set /p COPY=     Enter Selection Here: 

if /i "%COPY%" EQU "M" goto:creditcheck
if /i "%COPY%" EQU "E" EXIT
if /i "%COPY%" EQU "C" goto:MENU

if /i "%COPY%" NEQ "R" echo You Have Entered an Incorrect Key
if /i "%COPY%" NEQ "R" @ping 127.0.0.1 -n 2 -w 1000> nul
if /i "%COPY%" NEQ "R" goto:COPY

:COPY2
SET /a COUNT=%COUNT%+1
if exist "%Drive%"\WAD%COUNT% goto:COPY2
::move "%Drive%"\WAD "%Drive%"\WAD%COUNT%>nul
rename "%Drive%"\WAD WAD%COUNT%

if /i "%LIST%" EQU "R" goto:LIST
if /i "%OLDLIST%" EQU "R" goto:OLDLIST
if /i "%list3%" EQU "R" goto:LIST3
if /i "%list4%" EQU "R" goto:LIST4
goto:creditcheck


::.................................................ACTUAL DOWNLOAD CODE...........................................................................
:DOWNLOADSTART
if /i "%loadorgo%" EQU "load" goto:ADVPAGE2
if /i "%loadorgo%" EQU "load4queue" goto:processDLCheck2
if /i "%loadorgo%" EQU "load4switch" goto:processDLCheck2switch
set retry=1
set attempt=1


::DBUPDATE.bat check (added in v4.5.0)
::instead of putting out ModMii updates for minor things, the update check can be used to create\download a DBUPDATE.bat file to modify variables like "wadname", "md5", etc.
::if exist "temp\DBUPDATE%currentversion%.bat" call "temp\DBUPDATE%currentversion%.bat"



:DOWNLOADSTART2


::change drive to usb if applicable
set DRIVE=%REALDRIVE%
if /i "%USBCONFIG%" NEQ "USB" goto:skipchange

if /i "%WADNAME%" EQU "WiiBackupManager.zip" set DRIVE=%DRIVEU%
if /i "%WADNAME%" EQU "Configurable USB-Loader (Most recent Full 249 version)" set DRIVE=%DRIVEU%
if /i "%PATH1%" EQU "apps\WiiFlow\" set DRIVE=%DRIVEU%

:skipchange

if /i "%MENU1%" EQU "S" set DRIVE=temp


if not exist "%Drive%" mkdir "%Drive%"
:actualDL
if /i "%retry%" EQU "1" SET /a CURRENTDL=%CURRENTDL%+1


if /i "%CURRENTDL%" NEQ "1" echo.
if /i "%retry%" EQU "1" support\sfk echo [Red]Downloading %CURRENTDL% of %DLTOTAL%: %name%
if /i "%retry%" NEQ "1" support\sfk echo [Yellow]Re-Downloading %CURRENTDL% of %DLTOTAL%: %name%
echo.


::---------------SKIN MODE-------------
if /i "%SkinMode%" NEQ "Y" goto:notskin
if /i "%CURRENTDL%" EQU "1" set percent=0
::if "%percent%"=="" set percent=0
set percentlast=%percent%
set /a percent=%CURRENTDL%00/%DLTOTAL%
if %percent% LSS %percentlast% set percent=%percentlast%
start support\wizapp PB UPDATE %percent%
:notskin


::---------Exceptions----------------
if /i "%category%" EQU "cfgr" goto:CFGRDOWNLOADER
if /i "%category%" EQU "TANTRIC" goto:TANTRIC
if /i "%category%" EQU "CHEATS" goto:CHEATS
if /i "%category%" EQU "ManualUpdate" goto:MANUALUPDATE
if /i "%category%" EQU "fullextract" goto:fullextract
if /i "%category%" EQU "themes" goto:THEMES
if /i "%basewad%" NEQ "none" goto:CIOSMAKER
if /i "%name%" EQU "Hackmii Installer" goto:wget
if /i "%category%" EQU "userdefined" goto:CustomDL
if /i "%category%" EQU "FORWARDER" goto:FORWARDER



if /i "%code1%" EQU "SNEEKAPP" goto:DownloadApp
if /i "%code1%" EQU "MYMAPP" goto:DownloadApp
if /i "%code1%" EQU "URL" goto:DownloadURL



::--------------------------NUSD.EXE Downloader---------------
:nusd
if not exist "%Drive%"\WAD mkdir "%Drive%"\WAD

::----if exist and fails md5 check, delete and redownload----
:checkifwadexist
if not exist "%Drive%"\WAD\%wadname% goto:nocheckexisting
set md5check=
set md5altcheck=
support\sfk md5 -quiet -verify %md5% "%Drive%"\WAD\%wadname%
if errorlevel 1 set md5check=fail
IF "%md5check%"=="" set md5check=pass
if /i "%md5check%" NEQ "fail" goto:pass

support\sfk md5 -quiet -verify %md5alt% "%Drive%"\WAD\%wadname%
if errorlevel 1 set md5altcheck=fail
IF "%md5altcheck%"=="" set md5altcheck=pass
if /i "%md5altcheck%" NEQ "fail" goto:pass

:fail
echo.
support\sfk echo [Yellow] This file already exists but it failed MD5 verification.
support\sfk echo [Yellow] The current version of the file will be deleted and the file will be re-downloaded.
echo.
SET /a retry=%retry%+1
SET /a attempt=%attempt%+1
del "%Drive%"\WAD\%wadname%>nul
if exist temp\%wadname% del temp\%wadname%>nul
if exist temp\%code1%\%code2%\v%version% rd /s /q temp\%code1%\%code2%\v%version%
goto:DOWNLOADSTART2

:pass
if /i "%OPTION1%" EQU "OFF" goto:no01check
if not exist temp\%code1%\%code2%\v%version% goto:nocheckexisting

if /i "%OPTION1%" EQU "ON" goto:option1on
if /i "%OPTION1%" EQU "ALL" (goto:option1on) else (goto:option1noton)
:option1on
if not exist "%Drive%"\%code1%\%code2%\v%version% mkdir "%Drive%"\%code1%\%code2%\v%version%
copy /y temp\%code1%\%code2%\v%version% "%Drive%"\%code1%\%code2%\v%version% >nul
:option1noton

if /i "%OPTION1%" EQU "NUS" goto:option1NUS
if /i "%OPTION1%" EQU "ALL" (goto:option1NUS) else (goto:no01check)
:option1NUS
if not exist "%Drive%"\NUS\%code1%%code2%v%version% mkdir "%Drive%"\NUS\%code1%%code2%v%version%
copy /y temp\%code1%\%code2%\v%version% "%Drive%"\NUS\%code1%%code2%v%version% >nul
:no01check

support\sfk echo [Green]This file already exists and has been verified, Skipping download
echo.
set alreadyexists=yes
if /i "%AdvancedDownload%" NEQ "Y" echo "echo %wadname%: Valid">>temp\ModMii_Log.bat
goto:NEXT
:nocheckexisting



::SAVE TO WAD FOLDER ONLY

if not exist "%Drive%"\WAD mkdir "%Drive%"\WAD

if exist temp\%wadname% goto:AlreadyinTemp
echo     If you encounter long periods of inactivity, type "C" while holding "Ctrl",
echo     then type "N", then "Enter" (ie. Ctrl+C = N = Enter)
echo.

support\nusd %code1%%code2% %version%
move /y Support\%code1%%code2%\%code1%%code2%.wad temp\%wadname%>nul


if not exist temp\%code1%\%code2%\v%version% mkdir temp\%code1%\%code2%\v%version%
copy /y support\%code1%%code2% temp\%code1%\%code2%\v%version%\ >nul
rd /s /q support\%code1%%code2%

:AlreadyinTemp
if /i "%MENU1%" NEQ "S" copy /y temp\%wadname% "%Drive%"\WAD\%wadname% >nul
if /i "%MENU1%" EQU "S" move /y temp\%wadname% "%Drive%"\WAD\%wadname% >nul

if /i "%OPTION1%" EQU "ON" goto:option1on
if /i "%OPTION1%" EQU "ALL" (goto:option1on) else (goto:option1noton)
:option1on
if not exist "%Drive%"\%code1%\%code2%\v%version% mkdir "%Drive%"\%code1%\%code2%\v%version%
copy /y temp\%code1%\%code2%\v%version% "%Drive%"\%code1%\%code2%\v%version% >nul
:option1noton

if /i "%OPTION1%" EQU "NUS" goto:option1NUS
if /i "%OPTION1%" EQU "ALL" (goto:option1NUS) else (goto:option1notNUS)
:option1NUS
if not exist "%Drive%"\NUS\%code1%%code2%v%version% mkdir "%Drive%"\NUS\%code1%%code2%v%version%
copy /y temp\%code1%\%code2%\v%version% "%Drive%"\NUS\%code1%%code2%v%version% >nul
:option1notNUS

:wadverifyretry
::----check after downloading - if md5 check fails, delete and redownload----
if exist "%Drive%"\WAD\%wadname% goto:checkexisting

:missing
if /i "%attempt%" EQU "1" goto:missingretry
echo.
support\sfk echo [Magenta] This file has failed to download properly multiple times, Skipping download.
if /i "%AdvancedDownload%" NEQ "Y" echo "support\sfk echo %wadname%: [Red]Missing">>temp\ModMii_Log.bat
echo.
goto:NEXT

:missingretry
echo.
support\sfk echo [Yellow] The file is missing, retrying download.
echo.
SET /a retry=%retry%+1
SET /a attempt=%attempt%+1
goto:DOWNLOADSTART2

:checkexisting
set md5check=
set md5altcheck=
support\sfk md5 -quiet -verify %md5% "%Drive%"\WAD\%wadname%
if errorlevel 1 set md5check=fail
IF "%md5check%"=="" set md5check=pass
if /i "%md5check%" NEQ "fail" goto:pass
support\sfk md5 -quiet -verify %md5alt% "%Drive%"\WAD\%wadname%
if errorlevel 1 set md5altcheck=fail
IF "%md5altcheck%"=="" set md5altcheck=pass
if /i "%md5altcheck%" NEQ "fail" goto:pass

:fail
echo.
if /i "%attempt%" NEQ "1" goto:multiplefail
support\sfk echo [Yellow] This file already exists but it failed MD5 verification.
support\sfk echo [Yellow] The current version of the file will be deleted and the file will be re-downloaded.
echo.
del "%Drive%"\WAD\%wadname%>nul
if exist temp\%wadname% del temp\%wadname%>nul
if exist temp\%code1%\%code2%\v%version% rd /s /q temp\%code1%\%code2%\v%version%
SET /a retry=%retry%+1
SET /a attempt=%attempt%+1
goto:DOWNLOADSTART2

:multiplefail
support\sfk echo [Magenta] This file has failed to download properly multiple times, Skipping download.
set multiplefail=Y
echo.
if /i "%AdvancedDownload%" NEQ "Y" echo "support\sfk echo %wadname%: [Red]Invalid">>temp\ModMii_Log.bat
goto:NEXT

:pass
echo.
support\sfk echo [Green]Download Successful
echo.
if /i "%AdvancedDownload%" NEQ "Y" echo "echo %wadname%: Valid">>temp\ModMii_Log.bat
goto:NEXT



::-------------------------------cIOS Maker-----------------------------------------------------
:CIOSMAKER

if "%wadname:~-4%" EQU ".wad" set wadname=%wadname:~0,-4%

::no md5 check for dml
if /i "%wadname:~0,3%" EQU "DML" goto:nocheckexisting

::----if exist and fails md5 check, delete and redownload----
if exist "%Drive%"\WAD\%wadname%.wad (goto:checkexisting) else (goto:nocheckexisting)
:checkexisting
set md5check=
set md5altcheck=
support\sfk md5 -quiet -verify %md5% "%Drive%"\WAD\%wadname%.wad
if errorlevel 1 set md5check=fail
IF "%md5check%"=="" set md5check=pass
if /i "%md5check%" NEQ "fail" goto:pass

support\sfk md5 -quiet -verify %md5alt% "%Drive%"\WAD\%wadname%.wad
if errorlevel 1 set md5altcheck=fail
IF "%md5altcheck%"=="" set md5altcheck=pass
if /i "%md5altcheck%" NEQ "fail" goto:pass

:fail
echo.
support\sfk echo [Yellow] This file already exists but it failed MD5 verification.
support\sfk echo [Yellow] The current version of the file will be deleted and the file will be re-downloaded.
echo.
SET /a retry=%retry%+1
SET /a attempt=%attempt%+1
del "%Drive%"\WAD\%wadname%.wad>nul
goto:DOWNLOADSTART2

:pass
support\sfk echo [Green]This file already exists and has been verified, Skipping download
echo.
set alreadyexists=yes
if /i "%AdvancedDownload%" NEQ "Y" echo "echo %wadname%.wad: Valid">>temp\ModMii_Log.bat
goto:NEXT
:nocheckexisting



::missing Support folder error message and skip
if not exist Support support\sfk echo -spat [Yellow] Missing "Support" folder - Required to make cIOSs/cMIOSs
if not exist Support support\sfk echo -spat \x20 \x20 [Yellow] Redownload ModMii from tinyurl.com/ModMiiNow
if not exist Support support\sfk echo -spat \x20 \x20 [Yellow] Skipping download
if not exist Support @ping 127.0.0.1 -n 5 -w 1000> nul
if not exist Support goto:NEXT


if not exist "%Drive%"\WAD mkdir "%Drive%"\WAD


:downloadbasewad
::download base wad to "%Drive%"
echo.
echo Downloading Base Wad: %basewad%
echo.




::----Check base IOS-----------
::----if exist and fails md5 check, delete and redownload----
if exist temp\%basewad%.wad (goto:checkexisting) else (goto:nocheckexisting)
:checkexisting
set md5basecheck=
set md5basealtcheck=
support\sfk md5 -quiet -verify %md5base% temp\%basewad%.wad
if errorlevel 1 set md5basecheck=fail
IF "%md5basecheck%"=="" set md5basecheck=pass
if /i "%md5basecheck%" NEQ "fail" goto:pass

support\sfk md5 -quiet -verify %md5basealt% temp\%basewad%.wad
if errorlevel 1 set md5basealtcheck=fail
IF "%md5basealtcheck%"=="" set md5basealtcheck=pass
if /i "%md5basealtcheck%" NEQ "fail" goto:pass

:fail
echo.
support\sfk echo [Yellow] This base wad already exists but it failed MD5 verification.
support\sfk echo [Yellow] The current version of the file will be deleted and the file will be re-downloaded.
echo.
del temp\%basewad%.wad>nul
goto:downloadbasewad

:pass
echo.
support\sfk echo -spat \x20 \x20 \x20 [Green] Base Wad already exists and has been verified, Continuing...
echo.
goto:basealreadythere
:nocheckexisting


echo     If you encounter long periods of inactivity, type "C" while holding "Ctrl",
echo     then type "N", then "Enter" (ie. Ctrl+C = N = Enter)
echo.

support\nusd %code1%%code2% %version%
if not exist "%Drive%"\WAD mkdir "%Drive%"\WAD
move /y support\%code1%%code2%\%code1%%code2%.wad temp\%basewad%.wad>nul
rd /s /q support\%code1%%code2%


::----check after downloading - if md5 check fails, delete and redownload----
if exist temp\%basewad%.wad goto:checkexisting

:missing
if /i "%attempt%" EQU "1" goto:missingretry
echo.
support\sfk echo [Magenta] This file has failed to download properly multiple times, Skipping download.
if /i "%AdvancedDownload%" NEQ "Y" echo "support\sfk echo %wadname%.wad: [Red]Missing">>temp\ModMii_Log.bat
echo.
goto:NEXT

:missingretry
echo.
support\sfk echo [Yellow] The basewad is missing, retrying download.
echo.
SET /a retry=%retry%+1
SET /a attempt=%attempt%+1
goto:downloadbasewad

:checkexisting
set md5basecheck=
set md5basealtcheck=
support\sfk md5 -quiet -verify %md5base% temp\%basewad%.wad
if errorlevel 1 set md5basecheck=fail
IF "%md5basecheck%"=="" set md5basecheck=pass
if /i "%md5basecheck%" NEQ "fail" goto:pass

support\sfk md5 -quiet -verify %md5basealt% temp\%basewad%.wad
if errorlevel 1 set md5basealtcheck=fail
IF "%md5basealtcheck%"=="" set md5basealtcheck=pass
if /i "%md5basealtcheck%" NEQ "fail" goto:pass

:fail
if /i "%attempt%" NEQ "1" goto:multiplefail
echo.
support\sfk echo [Yellow] This file already exists but it failed MD5 verification.
support\sfk echo [Yellow] The current version of the file will be deleted and the file will be re-downloaded.
echo.
del temp\%basewad%.wad>nul
SET /a retry=%retry%+1
SET /a attempt=%attempt%+1
goto:downloadbasewad

:multiplefail
echo.
support\sfk echo [Magenta] This file has failed to download properly multiple times, Skipping download.
if /i "%AdvancedDownload%" NEQ "Y" echo "support\sfk echo %wadname%.wad: [Red]Invalid">>temp\ModMii_Log.bat
set multiplefail=Y
echo.
goto:NEXT

:pass
echo.
support\sfk echo -spat \x20 \x20 \x20 [Green] Base Wad has been Downloaded Successfully, Continuing...
echo.

:basealreadythere


::----------PATCHIOS Category-------------
if /i "%category%" NEQ "patchios" goto:notpatchios
if not "%lastbasemodule%"=="" goto:notpatchios
copy /y temp\%basewad%.wad "%Drive%"\WAD\%wadname%.wad>nul
cd support
if /i "%DRIVE:~1,1%" EQU ":" (set DRIVEadj=%DRIVE%) else (set DRIVEadj=..\%DRIVE%)
if "%lastbasemodule%"=="" patchios "%DRIVEadj%"\WAD\%wadname%.wad -FS -ES -NP -VP -slot %ciosslot% -v %ciosversion%
if not "%lastbasemodule%"=="" patchios "%DRIVEadj%"\WAD\%wadname%.wad -FS -ES -NP -VP
cd..
if "%wadname:~-4%" NEQ ".wad" set wadname=%wadname%.wad
goto:wadverifyretry
:notpatchios
::----------------------------------------

::unpack base wad
echo.
echo Unpacking Base Wad: %basewad%
echo.

if exist %basecios% rd /s /q %basecios%
mkdir %basecios%
support\wadmii -in temp\%basewad%.wad -out %basecios%


::-----------DML Stuff------------
:DML-stuff

if /i "%wadname:~0,3%" NEQ "DML" goto:SkipDML-stuff


::download DML currentrev if missing

echo.
echo Downloading %dlname%
echo.

if exist "temp\DML\%dlname%" goto:getfixelf

if not exist "%dlname%" start %ModMiimin%/wait support\wget --no-check-certificate -t 3 "%URL%"


if not exist "%dlname%" (rd /s /q %basewad%) & (rd /s /q %basecios%) & (echo.) & (support\sfk echo [Magenta] %dlname% Failed to Download properly, Skipping download.) & (echo "support\sfk echo %wadname%.wad: [Red]Missing">>temp\ModMii_Log.bat) & (echo.) & (goto:NEXT)

if not exist "temp\DML" mkdir "temp\DML"
move /y "%dlname%" "temp\DML\%dlname%">nul


:getfixelf

echo.
echo Downloading FixELF
echo.

if exist "temp\DML\FixELF.exe" goto:gotfixelf

if not exist "FixELF.zip" start %ModMiimin%/wait support\wget --no-check-certificate -t 3 "http://tiny.cc/FixELF"

if not exist "FixELF.zip" (rd /s /q %basewad%) & (rd /s /q %basecios%) & (echo.) & (support\sfk echo [Magenta] %dlname% Failed to Download properly, Skipping download.) & (echo "support\sfk echo %wadname%.wad: [Red]Missing">>temp\ModMii_Log.bat) & (echo.) & (goto:NEXT)

support\7za e -aoa "FixELF.zip" -o"temp\DML" *.* -r>nul

if not exist "temp\DML\FixELF.exe" (Corrupted archive detected and deleted...) & (del "temp\DML\FixELF.zip">nul) & (goto:NEXT)

del FixELF.zip>nul

:gotfixelf


move /y "%basecios%\00000001.app" "temp\DML\MIOS.app">nul


cd "temp\DML"


if exist 00000001.app del 00000001.app>nul

echo.
echo Running Crediar's FixELF to patch MIOS.app
echo.
FixELF MIOS.app "DMLr%CurrentDMLRev%.elf" 00000001.app>nul
cd..
cd..


move /y "temp\DML\00000001.app" "%basecios%\00000001.app">nul

goto:repackwad
:SkipDML-stuff




::--------------------base wad B------------------------
:downloadbasewadb
::download SECOND base wadB to "%Drive%" (if applicable)
if /i "%basewadb%" EQU "none" goto:nobasewadb

echo.
echo Downloading Base Wad: %basewadb%
echo.


::----Check base IOS B-----------
::----if exist and fails md5 check, delete and redownload----
if exist temp\%basewadb%.wad (goto:checkexisting) else (goto:nocheckexisting)
:checkexisting
set md5basebcheck=
set md5basebaltcheck=
support\sfk md5 -quiet -verify %md5baseb% temp\%basewadb%.wad
if errorlevel 1 set md5basebcheck=fail
IF "%md5basebcheck%"=="" set md5basebcheck=pass
if /i "%md5basebcheck%" NEQ "fail" goto:pass

support\sfk md5 -quiet -verify %md5basebalt% temp\%basewadb%.wad
if errorlevel 1 set md5basebaltcheck=fail
IF "%md5basebaltcheck%"=="" set md5basebaltcheck=pass
if /i "%md5basebaltcheck%" NEQ "fail" goto:pass

:fail
echo.
support\sfk echo [Yellow] This base wad already exists but it failed MD5 verification.
support\sfk echo [Yellow] The current version of the file will be deleted and the file will be re-downloaded.
echo.
del temp\%basewadb%.wad>nul
goto:downloadbasewadb

:pass
echo.
support\sfk echo -spat \x20 \x20 \x20 [Green] Base Wad already exists and has been verified, Continuing...
echo.
goto:baseBalreadythere
:nocheckexisting


echo     If you encounter long periods of inactivity, type "C" while holding "Ctrl",
echo     then type "N", then "Enter" (ie. Ctrl+C = N = Enter)
echo.

support\nusd %code1b%%code2b% %versionb%
if not exist "%Drive%"\WAD mkdir "%Drive%"\WAD
move /y support\%code1b%%code2b%\%code1b%%code2b%.wad temp\%basewadb%.wad>nul
rd /s /q support\%code1b%%code2b%




::----check after downloading - if md5 check fails, delete and redownload----
if exist temp\%basewadb%.wad goto:checkexisting

:missing
if /i "%attempt%" EQU "1" goto:missingretry
echo.
support\sfk echo [Magenta] This file has failed to download properly multiple times, Skipping download.
if /i "%AdvancedDownload%" NEQ "Y" echo "support\sfk echo %wadname%.wad: [Red]Missing">>temp\ModMii_Log.bat
echo.
goto:NEXT

:missingretry
echo.
support\sfk echo [Yellow] The basewad is missing, retrying download.
echo.
SET /a retry=%retry%+1
SET /a attempt=%attempt%+1
goto:downloadbasewadb

:checkexisting
set md5basebcheck=
set md5basebaltcheck=
support\sfk md5 -quiet -verify %md5baseb% temp\%basewadb%.wad
if errorlevel 1 set md5basebcheck=fail
IF "%md5basebcheck%"=="" set md5basebcheck=pass
if /i "%md5basebcheck%" NEQ "fail" goto:pass

support\sfk md5 -quiet -verify %md5basebalt% temp\%basewadb%.wad
if errorlevel 1 set md5basebaltcheck=fail
IF "%md5basebaltcheck%"=="" set md5basebaltcheck=pass
if /i "%md5basebaltcheck%" NEQ "fail" goto:pass

:fail
if /i "%attempt%" NEQ "1" goto:multiplefail
echo.
support\sfk echo [Yellow] This file already exists but it failed MD5 verification.
support\sfk echo [Yellow] The current version of the file will be deleted and the file will be re-downloaded.
echo.
del temp\%basewadb%.wad>nul
SET /a retry=%retry%+1
SET /a attempt=%attempt%+1
goto:downloadbasewadb

:multiplefail
echo.
support\sfk echo [Magenta] This file has failed to download properly multiple times, Skipping download.
if /i "%AdvancedDownload%" NEQ "Y" echo "support\sfk echo %wadname%.wad: [Red]Invalid">>temp\ModMii_Log.bat
echo.
set multiplefail=Y
goto:NEXT

:pass
echo.
support\sfk echo -spat \x20 \x20 \x20 [Green] Base Wad has been Downloaded Successfully, Continuing...
echo.

:baseBalreadythere

::----unpack base wad
echo.
echo Unpacking Base Wad: %basewadb%
echo.

mkdir %basewadb%
support\wadmii -in temp\%basewadb%.wad -out %basewadb%


if /i "%wadname:~0,3%" EQU "cBC" goto:cbc-stuff

::----specific for cios223v4[37+38]
::move modules that are from 38 and to be patched
move /y %basewadb%\00000001.app %basecios%\00000001.app>nul
move /y %basewadb%\%lastbasemodule%.app %basecios%\%lastbasemodule%.app>nul
rd /s /q %basewadb%
goto:nobasewadb


:cbc-stuff

::download NMM\DML-installer if missing
if exist "temp\%dlname:~0,-4%\FixElf\FixELF.exe" goto:gotit

::download unrar if missing
if not exist temp\UnRAR.exe echo.
if not exist temp\UnRAR.exe echo Downloading UnRAR
if not exist temp\UnRAR.exe start %ModMiimin%/wait support\wget --no-check-certificate -t 3 "http://files.cybergamer.com.au/richard/FIFA Online 2 Full Client v200/UnRAR.exe"
if exist UnRAR.exe move /y UnRAR.exe temp\UnRAR.exe>nul


echo.
echo Downloading %dlname%
if not exist "%dlname%" start %ModMiimin%/wait support\wget --no-check-certificate -t 3 "%URL%"
echo.

if not exist "%dlname%" (rd /s /q %basewadb%) & (rd /s /q %basecios%) & (echo.) & (support\sfk echo [Magenta] %dlname% Failed to Download properly, Skipping download.) & (echo "support\sfk echo %wadname%.wad: [Red]Missing">>temp\ModMii_Log.bat) & (echo.) & (goto:NEXT)


if not exist "temp\%dlname:~0,-4%" mkdir "temp\%dlname:~0,-4%"
temp\unrar.exe x -y %dlname% "temp\%dlname:~0,-4%">nul

if exist %dlname% del %dlname%>nul

:gotit
if exist "temp\%dlname:~0,-4%\%wadname:~4,3%.elf" move /y "temp\%dlname:~0,-4%\%wadname:~4,3%.elf" "temp\%dlname:~0,-4%\FixElf\%wadname:~4,3%.elf">nul

move /y "%basewadb%\00000001.app" "temp\%dlname:~0,-4%\FixElf\MIOS.app">nul
rd /s /q %basewadb%


cd "temp\%dlname:~0,-4%\FixElf"


if exist 00000001.app del 00000001.app>nul

echo.
echo Running Crediar's FixELF to patch MIOS.app
echo.
FixELF MIOS.app %wadname:~4,3%.elf 00000001.app>nul
cd..
cd..
cd..

move /y "temp\%dlname:~0,-4%\FixElf\00000001.app" "%basecios%\00000001.app">nul

goto:repackwad




:nobasewadb



::------for theming system menu's only----------
if /i "%category%" NEQ "SMTHEME" goto:skip
goto:mym_download
:SMTHEME2

echo.
echo Patching System Theme, please wait...
echo.

rename %basecios%\00000001.app 00000001-original.app


::Portable ModMii Installation fix

if /i "%Homedrive%" EQU "%ModMiiDrive%" goto:skipPortableFix
if not exist "%homedrive%\ModMii\temp" mkdir "%homedrive%\ModMii\temp"

copy /y "temp\TMCL.exe" "%homedrive%\ModMii\temp\TMCL.exe">nul
copy /y "temp\ASH.exe" "%homedrive%\ModMii\temp\ASH.exe">nul
copy /y "temp\ICSharpCode.SharpZipLib.dll" "%homedrive%\ModMii\temp\ICSharpCode.SharpZipLib.dll">nul

move /y "temp\TMCL.exe" "temp\TMCL.bak">nul

:skipPortableFix


cd /d temp
TMCL.exe "%mym1%" "..\%basecios%\00000001-original.app" "temp.csm">nul
TMCL.exe "%mym2%" "temp.csm" "..\%basecios%\00000001.app">nul
cd /d ..

if exist "temp\temp.csm" del "temp\temp.csm">nul
del %basecios%\00000001-original.app>nul

if exist "temp\TMCL.bak" move /y "temp\TMCL.bak" "temp\TMCL.exe">nul

goto:repackwad
:skip





::-----cios/cmios stuff------------
::rename *.cert and *.footer (doesn't need to be patched), rename components that need to be patched (excluding tik and tmd)

echo.
echo Patching A handful of BaseWad Component Files
echo.

if /i "%code2%" NEQ "%code2new%" ren %basecios%\%code1%%code2%.cert %code1%%code2new%.cert
if /i "%code2%" NEQ "%code2new%" ren %basecios%\%code1%%code2%.footer %code1%%code2new%.footer


::skip for d2x cIOSs
set usetmdedit=
if /i "%basecios:~12,3%" NEQ "d2x" goto:notd2x

if %ciosversion% GEQ 21009 set usetmdedit=Y
if /i "%d2x-beta-rev%" EQU "9-beta(r47)" set usetmdedit=
::::force on (testing only)
::set usetmdedit=Y
::::force off (testing only)
::set usetmdedit=
if /i "%usetmdedit%" EQU "Y" (goto:NotRenamedOriginal2) else (goto:NotRenamedOriginal)
:notd2x

if exist support\Diffs\%diffpath%\%diffpath%_00.diff ren %basecios%\00000000.app 00000000-original.app
if exist support\Diffs\%diffpath%\%diffpath%_01.diff ren %basecios%\00000001.app 00000001-original.app
if exist support\Diffs\%diffpath%\%diffpath%_02.diff ren %basecios%\00000002.app 00000002-original.app
if exist support\Diffs\%diffpath%\%diffpath%_%lastbasemodule%.diff ren %basecios%\%lastbasemodule%.app %lastbasemodule%-original.app


::rename tik & tmd for cMIOSs
if /i "%code2%" EQU "00000101" goto:rename
if /i "%category%" EQU "patchios" goto:rename
goto:notcMIOS
:rename
::ren %basecios%\%code1%%code2new%.tik %code1%%code2new%-original.tik

ren %basecios%\%code1%%code2new%.tmd %code1%%code2new%-original.tmd

:notcMIOS





::-------------diff patch files----------------

if exist support\Diffs\%diffpath%\%diffpath%_00.diff support\jptch  %basecios%\00000000-original.app support\Diffs\%diffpath%\%diffpath%_00.diff %basecios%\00000000.app
if exist support\Diffs\%diffpath%\%diffpath%_01.diff support\jptch  %basecios%\00000001-original.app support\Diffs\%diffpath%\%diffpath%_01.diff %basecios%\00000001.app
if exist support\Diffs\%diffpath%\%diffpath%_02.diff support\jptch  %basecios%\00000002-original.app support\Diffs\%diffpath%\%diffpath%_02.diff %basecios%\00000002.app
if exist support\Diffs\%diffpath%\%diffpath%_%lastbasemodule%.diff support\jptch  %basecios%\%lastbasemodule%-original.app support\Diffs\%diffpath%\%diffpath%_%lastbasemodule%.diff %basecios%\%lastbasemodule%.app


::patch tmd and tiks when they've been renamed to *-original.tik\tmd (for cMIOSs)
if /i "%code2%" EQU "00000101" goto:RenamedOriginal
if /i "%category%" EQU "patchios" goto:RenamedOriginal
goto:NotRenamedOriginal
:RenamedOriginal
::if exist support\Diffs\%diffpath%\%diffpath%_tik.diff support\jptch  %basecios%\%code1%%code2%-original.tik support\Diffs\%diffpath%\%diffpath%_tik.diff %basecios%\%code1%%code2new%.tik

if exist support\Diffs\%diffpath%\%diffpath%_tmd.diff support\jptch  %basecios%\%code1%%code2%-original.tmd support\Diffs\%diffpath%\%diffpath%_tmd.diff %basecios%\%code1%%code2new%.tmd
goto:deletefiles

:NotRenamedOriginal
if exist support\Diffs\%diffpath%\%diffpath%_tmd.diff support\jptch  %basecios%\%code1%%code2%.tmd support\Diffs\%diffpath%\%diffpath%_tmd.diff %basecios%\%code1%%code2new%.tmd

::use different tik diff files depending on what base wad downloaded

:NotRenamedOriginal2

if not exist "support\Diffs\%diffpath%\%diffpath%_tik.diff" goto:notik
if /i "%md5basecheck%" EQU "pass" support\jptch  %basecios%\%code1%%code2%.tik support\Diffs\%diffpath%\%diffpath%_tik.diff %basecios%\%code1%%code2new%.tik
:notik
if not exist "support\Diffs\%diffpath%\%diffpath%_tik2.diff" goto:notik2
if /i "%md5basealtcheck%" EQU "pass" support\jptch  %basecios%\%code1%%code2%.tik support\Diffs\%diffpath%\%diffpath%_tik2.diff %basecios%\%code1%%code2new%.tik
:notik2


::delete un-needed original files that have already been patched
:deletefiles

if exist %basecios%\00000000-original.app del %basecios%\00000000-original.app>nul
if exist %basecios%\00000001-original.app del %basecios%\00000001-original.app>nul
if exist %basecios%\00000002-original.app del %basecios%\00000002-original.app>nul
if exist %basecios%\%lastbasemodule%-original.app del %basecios%\%lastbasemodule%-original.app>nul

::--for cMIOS's that have tiks and tmds renamed to -original
if exist %basecios%\%code1%%code2%-original.tik del %basecios%\%code1%%code2%-original.tik>nul
if exist %basecios%\%code1%%code2%-original.tmd del %basecios%\%code1%%code2%-original.tmd>nul
if /i "%code2%" EQU "00000101" goto:repackwad
if /i "%category%" EQU "patchios" goto:repackwad

if exist %basecios%\%code1%%code2%.tik del %basecios%\%code1%%code2%.tik>nul

::don't delete base tmd if usetmdedit=Y
if /i "%usetmdedit%" NEQ "Y" if exist %basecios%\%code1%%code2%.tmd del %basecios%\%code1%%code2%.tmd>nul


::---------------Korean Key Patch---------------

::skip korean key patch and copying of custom modules for d2x cIOSs (will be done later)
if /i "%basecios:~12,3%" EQU "d2x" goto:signcios

if /i "%basewad:~3,2%" EQU "38" goto:nokorpatch
if /i "%basecios%" EQU "cIOS223[37-38]-v4" goto:nokorpatch
if /i "%wadname:~0,3%" EQU "cBC" goto:repackwad

echo.
echo Patching %lastbasemodule%.app to support the Korean Common Key


::IOS37-64-v3869
if /i "%basewad%" EQU "IOS37-64-v3869" support\hexalter.exe %basecios%\%lastbasemodule%.app 0x1FD00=0xE0
if /i "%basewad%" EQU "IOS37-64-v3869" support\hexalter.exe %basecios%\%lastbasemodule%.app 0x278E0=0x63,0xB8,0x2B,0xB4,0xF4,0x61,0x4E,0x2E,0x13,0xF2,0xFE,0xFB,0xBA,0x4C,0x9B,0x7E

::IOS57-64-v5661
if /i "%basewad%" EQU "IOS57-64-v5661" support\hexalter.exe %basecios%\%lastbasemodule%.app 0x21340=0xE0
if /i "%basewad%" EQU "IOS57-64-v5661" support\hexalter.exe %basecios%\%lastbasemodule%.app 0x28F5C=0x63,0xB8,0x2B,0xB4,0xF4,0x61,0x4E,0x2E,0x13,0xF2,0xFE,0xFB,0xBA,0x4C,0x9B,0x7E


::NEXT GEN BASES

::IOS37-64-v5662
if /i "%basewad%" EQU "IOS37-64-v5662" support\hexalter.exe %basecios%\%lastbasemodule%.app 0x1FD88=0xE0
if /i "%basewad%" EQU "IOS37-64-v5662" support\hexalter.exe %basecios%\%lastbasemodule%.app 0x27968=0x63,0xB8,0x2B,0xB4,0xF4,0x61,0x4E,0x2E,0x13,0xF2,0xFE,0xFB,0xBA,0x4C,0x9B,0x7E

::IOS53-64-v5662
if /i "%basewad%" EQU "IOS53-64-v5662" support\hexalter.exe %basecios%\%lastbasemodule%.app 0x1FD88=0xE0
if /i "%basewad%" EQU "IOS53-64-v5662" support\hexalter.exe %basecios%\%lastbasemodule%.app 0x27968=0x63,0xB8,0x2B,0xB4,0xF4,0x61,0x4E,0x2E,0x13,0xF2,0xFE,0xFB,0xBA,0x4C,0x9B,0x7E

::IOS55-64-v5662
if /i "%basewad%" EQU "IOS55-64-v5662" support\hexalter.exe %basecios%\%lastbasemodule%.app 0x1FD88=0xE0
if /i "%basewad%" EQU "IOS55-64-v5662" support\hexalter.exe %basecios%\%lastbasemodule%.app 0x27968=0x63,0xB8,0x2B,0xB4,0xF4,0x61,0x4E,0x2E,0x13,0xF2,0xFE,0xFB,0xBA,0x4C,0x9B,0x7E

::IOS56-64-v5661
if /i "%basewad%" EQU "IOS56-64-v5661" support\hexalter.exe %basecios%\%lastbasemodule%.app 0x21424=0xE0
if /i "%basewad%" EQU "IOS56-64-v5661" support\hexalter.exe %basecios%\%lastbasemodule%.app 0x29078=0x63,0xB8,0x2B,0xB4,0xF4,0x61,0x4E,0x2E,0x13,0xF2,0xFE,0xFB,0xBA,0x4C,0x9B,0x7E

::IOS57-64-v5918
if /i "%basewad%" EQU "IOS57-64-v5918" support\hexalter.exe %basecios%\%lastbasemodule%.app 0x21424=0xE0
if /i "%basewad%" EQU "IOS57-64-v5918" support\hexalter.exe %basecios%\%lastbasemodule%.app 0x29078=0x63,0xB8,0x2B,0xB4,0xF4,0x61,0x4E,0x2E,0x13,0xF2,0xFE,0xFB,0xBA,0x4C,0x9B,0x7E

::IOS58-64-v6175
if /i "%basewad%" EQU "IOS58-64-v6175" support\hexalter.exe %basecios%\%lastbasemodule%.app 0x21424=0xE0
if /i "%basewad%" EQU "IOS58-64-v6175" support\hexalter.exe %basecios%\%lastbasemodule%.app 0x29078=0x63,0xB8,0x2B,0xB4,0xF4,0x61,0x4E,0x2E,0x13,0xF2,0xFE,0xFB,0xBA,0x4C,0x9B,0x7E

::IOS60-64-v6174
if /i "%basewad%" EQU "IOS60-64-v6174" support\hexalter.exe %basecios%\%lastbasemodule%.app 0x20678=0xE0
if /i "%basewad%" EQU "IOS60-64-v6174" support\hexalter.exe %basecios%\%lastbasemodule%.app 0x28294=0x63,0xB8,0x2B,0xB4,0xF4,0x61,0x4E,0x2E,0x13,0xF2,0xFE,0xFB,0xBA,0x4C,0x9B,0x7E

::IOS70-64-v6687
if /i "%basewad%" EQU "IOS70-64-v6687" support\hexalter.exe %basecios%\%lastbasemodule%.app 0x21340=0xE0
if /i "%basewad%" EQU "IOS70-64-v6687" support\hexalter.exe %basecios%\%lastbasemodule%.app 0x28f5c=0x63,0xB8,0x2B,0xB4,0xF4,0x61,0x4E,0x2E,0x13,0xF2,0xFE,0xFB,0xBA,0x4C,0x9B,0x7E

::IOS80-64-v6943
if /i "%basewad%" EQU "IOS80-64-v6943" support\hexalter.exe %basecios%\%lastbasemodule%.app 0x21424=0xE0
if /i "%basewad%" EQU "IOS80-64-v6943" support\hexalter.exe %basecios%\%lastbasemodule%.app 0x29078=0x63,0xB8,0x2B,0xB4,0xF4,0x61,0x4E,0x2E,0x13,0xF2,0xFE,0xFB,0xBA,0x4C,0x9B,0x7E


echo.

:nokorpatch





::copy over extra components

echo.
echo Copying over Custom Modules
echo.

::222v4
if /i "%basecios%" EQU "cIOS222[38]-v4" copy support\Hermes\mloadv3.app %basecios%\0000000f.app

::223v4
if /i "%basecios%" EQU "cIOS223[37-38]-v4" copy support\Hermes\mloadv3.app %basecios%\0000000f.app

::222v5
if /i "%basecios%" EQU "cIOS222[38]-v5" copy support\Hermes\mloadv5.app %basecios%\0000000f.app

::223v5 base37
if /i "%basecios%" EQU "cIOS223[37]-v5" copy support\Hermes\mloadv5.app %basecios%\0000000f.app

::224v5 base57
if /i "%basecios%" EQU "cIOS224[57]-v5" copy support\Hermes\mloadv5.app %basecios%\00000013.app

::202v5.1R base60
if /i "%basecios%" EQU "cIOS202[60]-v5.1R" copy support\Hermes\mloadv5.1R.app %basecios%\0000000f.app

::222v5.1R base38
if /i "%basecios%" EQU "cIOS222[38]-v5.1R" copy support\Hermes\mloadv5.1R.app %basecios%\0000000f.app

::223v5.1R base37
if /i "%basecios%" EQU "cIOS223[37]-v5.1R" copy support\Hermes\mloadv5.1R.app %basecios%\0000000f.app

::224v5.1R base57
if /i "%basecios%" EQU "cIOS224[57]-v5.1R" copy support\Hermes\mloadv5.1R.app %basecios%\00000013.app


::249v19 base37
if /i "%basecios%" EQU "cIOS249[37]-v19" copy support\W19modules\mload.app %basecios%\0000000f.app
if /i "%basecios%" EQU "cIOS249[37]-v19" copy support\W19modules\EHCI.app %basecios%\00000010.app
if /i "%basecios%" EQU "cIOS249[37]-v19" copy support\W19modules\FAT.app %basecios%\00000011.app
if /i "%basecios%" EQU "cIOS249[37]-v19" copy support\W19modules\SDHC.app %basecios%\00000012.app
if /i "%basecios%" EQU "cIOS249[37]-v19" copy support\W19modules\DIPP.app %basecios%\00000013.app
if /i "%basecios%" EQU "cIOS249[37]-v19" copy support\W19modules\FFSP.app %basecios%\00000014.app

::249v19 base38
if /i "%basecios%" EQU "cIOS249[38]-v19" copy support\W19modules\mload.app %basecios%\0000000f.app
if /i "%basecios%" EQU "cIOS249[38]-v19" copy support\W19modules\EHCI.app %basecios%\00000010.app
if /i "%basecios%" EQU "cIOS249[38]-v19" copy support\W19modules\FAT.app %basecios%\00000011.app
if /i "%basecios%" EQU "cIOS249[38]-v19" copy support\W19modules\SDHC.app %basecios%\00000012.app
if /i "%basecios%" EQU "cIOS249[38]-v19" copy support\W19modules\DIPP.app %basecios%\00000013.app
if /i "%basecios%" EQU "cIOS249[38]-v19" copy support\W19modules\FFSP.app %basecios%\00000014.app

::249v20 base38
if /i "%basecios%" EQU "cIOS249[38]-v20" copy support\W20modules\mload.app %basecios%\0000000f.app
if /i "%basecios%" EQU "cIOS249[38]-v20" copy support\W20modules\EHCI.app %basecios%\00000010.app
if /i "%basecios%" EQU "cIOS249[38]-v20" copy support\W20modules\FAT.app %basecios%\00000011.app
if /i "%basecios%" EQU "cIOS249[38]-v20" copy support\W20modules\SDHC.app %basecios%\00000012.app
if /i "%basecios%" EQU "cIOS249[38]-v20" copy support\W20modules\DIPP.app %basecios%\00000013.app
if /i "%basecios%" EQU "cIOS249[38]-v20" copy support\W20modules\ES.app %basecios%\00000014.app
if /i "%basecios%" EQU "cIOS249[38]-v20" copy support\W20modules\FFSP.app %basecios%\00000015.app

::249v20 base56
if /i "%basecios%" EQU "cIOS249[56]-v20" copy support\W20modules\mload.app %basecios%\0000000f.app
if /i "%basecios%" EQU "cIOS249[56]-v20" copy support\W20modules\EHCI.app %basecios%\00000010.app
if /i "%basecios%" EQU "cIOS249[56]-v20" copy support\W20modules\FAT.app %basecios%\00000011.app
if /i "%basecios%" EQU "cIOS249[56]-v20" copy support\W20modules\SDHC.app %basecios%\00000012.app
if /i "%basecios%" EQU "cIOS249[56]-v20" copy support\W20modules\DIPP.app %basecios%\00000013.app
if /i "%basecios%" EQU "cIOS249[56]-v20" copy support\W20modules\ES.app %basecios%\00000014.app
if /i "%basecios%" EQU "cIOS249[56]-v20" copy support\W20modules\FFSP.app %basecios%\00000015.app

::249v19 base57
if /i "%basecios%" EQU "cIOS249[57]-v19" copy support\W19modules\mload.app %basecios%\00000013.app
if /i "%basecios%" EQU "cIOS249[57]-v19" copy support\W19modules\EHCI.app %basecios%\00000014.app
if /i "%basecios%" EQU "cIOS249[57]-v19" copy support\W19modules\FAT.app %basecios%\00000015.app
if /i "%basecios%" EQU "cIOS249[57]-v19" copy support\W19modules\SDHC.app %basecios%\00000016.app
if /i "%basecios%" EQU "cIOS249[57]-v19" copy support\W19modules\DIPP.app %basecios%\00000017.app
if /i "%basecios%" EQU "cIOS249[57]-v19" copy support\W19modules\FFSP.app %basecios%\00000018.app

::249v20 base57
if /i "%basecios%" EQU "cIOS249[57]-v20" copy support\W20modules\mload.app %basecios%\00000013.app
if /i "%basecios%" EQU "cIOS249[57]-v20" copy support\W20modules\EHCI.app %basecios%\00000014.app
if /i "%basecios%" EQU "cIOS249[57]-v20" copy support\W20modules\FAT.app %basecios%\00000015.app
if /i "%basecios%" EQU "cIOS249[57]-v20" copy support\W20modules\SDHC.app %basecios%\00000016.app
if /i "%basecios%" EQU "cIOS249[57]-v20" copy support\W20modules\DIPP.app %basecios%\00000017.app
if /i "%basecios%" EQU "cIOS249[57]-v20" copy support\W20modules\ES.app %basecios%\00000018.app
if /i "%basecios%" EQU "cIOS249[57]-v20" copy support\W20modules\FFSP.app %basecios%\00000019.app

::249v17b
if /i "%basecios%" EQU "cIOS249-v17b" copy support\W17bmodules\0000000f.app %basecios%\0000000f.app
if /i "%basecios%" EQU "cIOS249-v17b" copy support\W17bmodules\00000010.app %basecios%\00000010.app
if /i "%basecios%" EQU "cIOS249-v17b" copy support\W17bmodules\00000011.app %basecios%\00000011.app

::249v14
if /i "%basecios%" EQU "cIOS249-v14" copy support\W14modules\EHCI.app %basecios%\0000000f.app
if /i "%basecios%" EQU "cIOS249-v14" copy support\W14modules\SDHC.app %basecios%\00000010.app
if /i "%basecios%" EQU "cIOS249-v14" copy support\W14modules\FAT.app %basecios%\00000011.app


::249v21 base 37/38/56
if /i "%basecios%" EQU "cIOS249[37]-v21" goto:yes
if /i "%basecios%" EQU "cIOS249[38]-v21" goto:yes
if /i "%basecios%" EQU "cIOS249[53]-v21" goto:yes
if /i "%basecios%" EQU "cIOS249[55]-v21" goto:yes
if /i "%basecios%" EQU "cIOS249[56]-v21" goto:yes
goto:skip
:yes
copy support\W21modules\mload.app %basecios%\0000000f.app
copy support\W21modules\FAT.app %basecios%\00000010.app
copy support\W21modules\SDHC.app %basecios%\00000011.app
copy support\W21modules\EHCI.app %basecios%\00000012.app
copy support\W21modules\DIPP.app %basecios%\00000013.app
copy support\W21modules\ES.app %basecios%\00000014.app
copy support\W21modules\FFSP.app %basecios%\00000015.app
:skip


::249v21 base57
if /i "%basecios%" EQU "cIOS249[57]-v21" copy support\W21modules\mload.app %basecios%\00000013.app
if /i "%basecios%" EQU "cIOS249[57]-v21" copy support\W21modules\FAT.app %basecios%\00000014.app
if /i "%basecios%" EQU "cIOS249[57]-v21" copy support\W21modules\SDHC.app %basecios%\00000015.app
if /i "%basecios%" EQU "cIOS249[57]-v21" copy support\W21modules\EHCI.app %basecios%\00000016.app
if /i "%basecios%" EQU "cIOS249[57]-v21" copy support\W21modules\DIPP.app %basecios%\00000017.app
if /i "%basecios%" EQU "cIOS249[57]-v21" copy support\W21modules\ES.app %basecios%\00000018.app
if /i "%basecios%" EQU "cIOS249[57]-v21" copy support\W21modules\FFSP.app %basecios%\00000019.app

::249v21 base58
if /i "%basecios%" EQU "cIOS249[58]-v21" copy support\W21modules\mload.app %basecios%\00000013.app
if /i "%basecios%" EQU "cIOS249[58]-v21" copy support\W21modules\FAT.app %basecios%\00000014.app
if /i "%basecios%" EQU "cIOS249[58]-v21" copy support\W21modules\SDHC.app %basecios%\00000015.app
if /i "%basecios%" EQU "cIOS249[58]-v21" copy support\W21modules\USBS.app %basecios%\00000016.app
if /i "%basecios%" EQU "cIOS249[58]-v21" copy support\W21modules\DIPP.app %basecios%\00000017.app
if /i "%basecios%" EQU "cIOS249[58]-v21" copy support\W21modules\ES.app %basecios%\00000018.app
if /i "%basecios%" EQU "cIOS249[58]-v21" copy support\W21modules\FFSP.app %basecios%\00000019.app








::------sign cIOS with details---------
:signcios
set d2xNumber=
set d2xhexNumber=
set baseNumber=
set basehexNumber=
set d2xsubversion=
set string=
set string1=

if /i "%code2%" EQU "00000101" goto:repackwad

echo.
echo Signing 00000000.app with cIOS details
echo.

::----convert some values from dec to hex----

if /i "%basecios:~12,3%" NEQ "d2x" goto:minijump
echo "set cIOSversionNum=%d2x-beta-rev%">cIOSrev.bat
support\sfk filter -spat cIOSrev.bat -rep _\x22__ -rep _"-*"__ -write -yes>nul
call cIOSrev.bat
del cIOSrev.bat>nul
:minijump

support\sfk hex %cIOSversionNum% -digits=8 >hex.txt

::set a file with 1 line as a variable
set /p cIOShexNumber= <hex.txt
if exist hex.txt del hex.txt>nul

::-----
set baseNumber=%basewad:~3,2%
::base # for 37+38=75
if /i "%basecios%" EQU "cIOS223[37-38]-v4" set baseNumber=75
support\sfk hex %baseNumber% -digits=8 >hex.txt

::set a file with 1 line as a variable
set /p basehexNumber= <hex.txt
if exist hex.txt del hex.txt>nul


set cIOSsubversion=
::-----cIOSFamilyName (this part required for d2x betas only)-------
if /i "%basecios:~12,3%" NEQ "d2x" goto:tinyjump
set cIOSFamilyName=d2x
if exist support\d2x-beta\d2x-beta.bat call support\d2x-beta\d2x-beta.bat

::limit cios family name to 16 chars
set cIOSFamilyName=%cIOSFamilyName:~0,16%

::-----version string (ie. beta1) (this part required for d2x betas only)------

set string1=%cIOSversionNum%
set versionlength=1
::letter by letter loop
:loopy
    if /i "%string1%" EQU "" goto:endloopy
    set string1=%string1:~1%
    set /A versionlength=%versionlength%+1
    goto loopy
:endloopy


echo set cIOSsubversion=@d2x-beta-rev:~%versionlength%,16@>cIOSsubversion.bat
support\sfk filter cIOSsubversion.bat -spat -rep _@_%%_ -write -yes>nul
call cIOSsubversion.bat
del cIOSsubversion.bat>nul
:tinyjump


::copy template .app
copy /y "support\00000000-template.app" "%basecios%\00000000.app">nul


::hexalter version number and base wad number
support\hexalter.exe "%basecios%\00000000.app" 0x8=0x%cIOShexNumber:~0,2%,0x%cIOShexNumber:~2,2%,0x%cIOShexNumber:~4,2%,0x%cIOShexNumber:~6,2%,0x%basehexNumber:~0,2%,0x%basehexNumber:~2,2%,0x%basehexNumber:~4,2%,0x%basehexNumber:~6,2%


::convert %cIOSFamilyName% to hex then hexalter
set var=%cIOSFamilyName%
call support\Ascii2hex.bat
setlocal DISABLEDELAYEDEXPANSION
support\sfk filter -quiet "temphex.txt" -rep _,_,0x_ -write -yes
set /p cIOSFamilyNamehex= <temphex.txt
del /f /q temphex.txt
set cIOSFamilyNamehex=0x%cIOSFamilyNamehex:~0,-4%
support\hexalter.exe "%basecios%\00000000.app" 0x10=%cIOSFamilyNamehex%


::only patch cIOSsubversion if not = nul
if "%cIOSsubversion%"=="" goto:tinyjump
set var=%cIOSsubversion%
call support\Ascii2hex.bat
setlocal DISABLEDELAYEDEXPANSION
support\sfk filter -quiet "temphex.txt" -rep _,_,0x_ -write -yes
set /p cIOSsubversionhex= <temphex.txt
del /f /q temphex.txt
set cIOSsubversionhex=0x%cIOSsubversionhex:~0,-4%
support\hexalter.exe "%basecios%\00000000.app" 0x20=%cIOSsubversionhex%
:tinyjump




::---------patches for d2x cIOSs via ciosmaps.xml (including IRQ4 patch if applicable)--------
if /i "%basecios:~12,3%" NEQ "d2x" goto:repackwad

echo.
echo Patching some IOS modules
echo.

if exist Support\d2x-beta\ciosmaps.xml (copy /y Support\d2x-beta\ciosmaps.xml temp\ciosmaps.xml>nul) else (copy /y Support\d2xModules\ciosmaps.xml temp\ciosmaps.xml>nul)

::get base IOS section
support\sfk -spat filter temp\ciosmaps.xml -inc "base ios\x3d\x22%basewad:~3,2%" to "\x2fbase" -nocheck -write -yes>nul

::rename comments and redirects
support\sfk -spat filter temp\ciosmaps.xml -rep _"\x3c\x21\x2d\x2d"_commentstart_ -rep _"\x2d\x2d\x3e"_commentend_ -write -yes>nul
support\sfk -spat filter temp\ciosmaps.xml -rep _"\x3c"__ -rep _"\x2f\x3e"_LineEnd_ -rep _"\x3e"_LineEnd_ -write -yes>nul


::remove quotes, equal signs, and trailing spaces\slashes
support\sfk -spat filter temp\ciosmaps.xml -rep _"\x3d"__ -rep _"\x22"__ -write -yes>nul
support\sfk -spat filter temp\ciosmaps.xml -lerep _"\x2f"__ -lerep _"\x20"__ -write -yes>nul


::remove blank lines
support\sfk filter temp\ciosmaps.xml -no-empty-lines -no-blank-lines -write -yes>nul

::force remove IRQ4 patch for d2x v8 base 58 (harmless but included by davebaol by accident)
if /i "%basewad:~3,2%" NEQ "58" goto:no58fix
if /i "%ciosversion%" NEQ "21008" goto:no58fix
support\sfk -spat filter temp\ciosmaps.xml -!"patch offset0x28530 size4 originalbytes0xFF,0xFF,0x5D,0x52 newbytes0xFF,0xFF,0x5D,0x5C" -write -yes>nul
:no58fix


::get contentscount\basemodules\modulescount --> basemodules=lastbasemodules+1 (includes 00000000.app)

set /p topline= <temp\ciosmaps.xml

::-------disable getting info for now, not needed-------
goto:DisableGettingcIOSINFO

echo %topline%>temp\temp.txt
support\sfk filter temp\temp.txt -rep _*contentscount__ -rep _" "*__ -write -yes>nul
set /p contentscount= <temp\temp.txt

support\sfk dec %lastbasemodule%>temp\temp.txt
set /p basemodules= <temp\temp.txt
set /a basemodules=%basemodules%+1


set /a modulescount=%contentscount%-%basemodules%

::echo %contentscount%
::echo %basemodules%
::echo %modulescount%

:DisableGettingcIOSINFO
::--------------------------------------------------------


::remove topline
support\sfk filter temp\ciosmaps.xml -!"%topline%" -write -yes>nul

::remove 00000000.app patches (done later)
support\sfk -spat filter temp\ciosmaps.xml -cut "*" to "\x2fcontent" -nocheck -write -yes>nul

::remove /content and /base
support\sfk -spat filter temp\ciosmaps.xml -!"\x2fcontent" -!"\x2fbase" -write -yes>nul

::split to temp\ciosmodules.xml
support\sfk filter temp\ciosmaps.xml ++"module" -!"commentstart" -!"commentend" -!"\x2fbase">temp\ciosmodules.xml
support\sfk filter temp\ciosmaps.xml -!"module" -!"\x2fbase" -write -yes>nul


set contentid=0
set xmlcomment=
set newbytes=
set newbytestemp=
set getnewbytes=

::-----------------------:process ciosmaps.xml: loop though xml---------------------------
::Loop through the the following once for EACH line in *.txt
for /F "tokens=*" %%A in (temp\ciosmaps.xml) do call :processciosmaps %%A
goto:quickskip
:processciosmaps

::set xmlLine=%*

echo %*>temp\temp.txt

findStr /I /C:"commentend" "temp\temp.txt" >nul
if not ERRORLEVEL 1 (set xmlcomment=) & (goto:EOF)

if /i "%xmlcomment%" EQU "on" goto:EOF

findStr /I /C:"commentstart" "temp\temp.txt" >nul
if not ERRORLEVEL 1 (set xmlcomment=on) & (goto:EOF)


findStr /I /C:"content id" "temp\temp.txt" >nul
if not ERRORLEVEL 1 (set /a contentid=%contentid%+1) & (goto:EOF)



::----patching...----

::get current contendid
support\sfk hex %contentid% -digits=8 >temp\hex.txt
set /p contentidhex= <temp\hex.txt
set contentidhex=%contentidhex:~0,-1%

::get patchoffset
findStr /I /C:"patch offset" "temp\temp.txt" >nul
if ERRORLEVEL 1 goto:skip
support\sfk -spat filter temp\temp.txt -rep _*"patch offset"__ -rep _" "*__ -rep _"LineEnd"*__ -write -yes>nul
set /p patchoffset= <temp\temp.txt
:skip



::get newbytes
echo %*>temp\temp.txt

findStr /I /C:"newbytes" "temp\temp.txt" >nul
if not ERRORLEVEL 1 set getnewbytes=on
if /i "%getnewbytes%" NEQ "on" goto:skip

::filter for newbytes
support\sfk -spat filter temp\temp.txt -rep _*"newbytes"__ -rep _\x20\x20__ -lsrep _\x20__ -rep _"LineEnd"*__ -rep _" "*__ -write -yes>nul

set newbytestemp=
set /p newbytestemp= <temp\temp.txt
set newbytes=%newbytes%%newbytestemp%
if "%newbytes%"=="" goto:EOF
if /i "%newbytes:~0,2%" NEQ "0x" (set newbytes=) & (goto:EOF)
:skip


::check LineEnd
echo %*>temp\temp.txt

findStr /I /C:"LineEnd" "temp\temp.txt" >nul
if ERRORLEVEL 1 goto:EOF

if "%newbytes%"=="" goto:EOF
if "%patchoffset%"=="" goto:EOF

::::verbose
::echo support\hexalter.exe %basecios%\%contentidhex%.app %patchoffset%=%newbytes%

support\hexalter.exe %basecios%\%contentidhex%.app %patchoffset%=%newbytes%

set patchoffset=
set newbytes=
set newbytestemp=
set getnewbytes=

goto:EOF
:quickskip



echo.
echo Copying over Custom Modules
echo.


::Loop through the the following once for EACH line in *.txt
for /F "tokens=*" %%A in (temp\ciosmodules.xml) do call :processciosmodules %%A
goto:quickskip
:processciosmodules

set /a contentid=%contentid%+1
support\sfk hex %contentid% -digits=8 >temp\hex.txt
set /p contentidhex= <temp\hex.txt
set contentidhex=%contentidhex:~0,-1%

::set xmlLine=%*

echo %*>temp\temp.txt

::get module
support\sfk -spat filter temp\temp.txt -rep _*" module"__ -rep _" "*__ -write -yes>nul
set /p module= <temp\temp.txt

if exist support\d2x-beta\%module%.app (copy support\d2x-beta\%module%.app %basecios%\%contentidhex%.app) else (copy Support\d2xModules\%module%.app %basecios%\%contentidhex%.app)


goto:EOF
:quickskip

echo.


::use tmdedit.exe to patch tmd
if /i "%usetmdedit%" NEQ "Y" goto:repackwad

if exist Support\d2x-beta\ciosmaps.xml (set xml=Support\d2x-beta\ciosmaps.xml) else (set xml=Support\d2xModules\ciosmaps.xml)


support\TMDedit.exe -b "%basecios%\%code1%%code2new%.tmd" -xml %xml% -group d2x-v%d2x-beta-rev% %ciosversion% -base %basewad:~3,2% %version% -folder "%basecios%" -basefile %basecios%\%code1%%code2%.tmd -outIOS 249


del %basecios%\%code1%%code2%.tmd>nul






::---------pack files into cIOS wad---------
:repackwad



echo.
echo Repacking Wad
echo.

support\wadmii -in "%basecios%" -out "%Drive%\WAD\%wadname%.wad"

::delete unpacked files
rd /s /q %basecios%

::Change version number and slot number (using patchios) only if required
:patchios
if /i "%ciosslot%" EQU "unchanged" goto:skip


echo.
echo Changing version number and/or slot number
echo.

cd support
if /i "%DRIVE:~1,1%" EQU ":" (set DRIVEadj=%DRIVE%) else (set DRIVEadj=..\%DRIVE%)
patchios "%Driveadj%\WAD\%wadname%.wad" -slot %ciosslot% -v %ciosversion%
cd..
echo.
:skip


if "%wadname:~-4%" NEQ ".wad" set wadname=%wadname%.wad

if /i "%wadname:~0,3%" EQU "DML" goto:simpleDMLcheck

goto:wadverifyretry



:simpleDMLcheck
if not exist "%Drive%"\WAD\%wadname% goto:missing

:pass
echo.
support\sfk echo [Green]Download Successful
echo.
if /i "%AdvancedDownload%" NEQ "Y" echo "echo %name%: Valid">>temp\ModMii_Log.bat

goto:NEXT

:missing
if /i "%attempt%" EQU "1" goto:missingretry
echo.
support\sfk echo [Magenta] This file has failed to download properly multiple times, Skipping download.
if /i "%AdvancedDownload%" NEQ "Y" echo "support\sfk echo %name%: [Red]Missing">>temp\ModMii_Log.bat
echo.
goto:NEXT

:missingretry
echo.
support\sfk echo [Yellow] The file is missing, retrying download.
echo.
SET /a retry=%retry%+1
SET /a attempt=%attempt%+1
goto:DOWNLOADSTART2


::----------------------------------------THEMES-------------------------------------
:THEMES
if not exist "%Drive%"\ModThemes mkdir "%Drive%"\ModThemes

::----if exist and fails md5 check, delete and redownload----
if exist "%Drive%"\ModThemes\%wadname%.csm (goto:checkexisting) else (goto:nocheckexisting)
:checkexisting
set md5check=
support\sfk md5 -quiet -verify %md5% "%Drive%"\ModThemes\%wadname%.csm
if errorlevel 1 set md5check=fail
IF "%md5check%"=="" set md5check=pass
if /i "%md5check%" NEQ "fail" goto:pass

:fail
echo.
support\sfk echo [Yellow] This file already exists but it failed MD5 verification.
support\sfk echo [Yellow] The current version of the file will be deleted and the file will be re-downloaded.
echo.
SET /a retry=%retry%+1
SET /a attempt=%attempt%+1
del "%Drive%"\ModThemes\%wadname%.csm>nul
goto:DOWNLOADSTART2

:pass
support\sfk echo [Green]This file already exists and has been verified, Skipping download
echo.
if /i "%AdvancedDownload%" NEQ "Y" echo "echo %name%: Valid">>temp\ModMii_Log.bat
goto:NEXT
:nocheckexisting





::-------------Download base app----------------------
echo.
echo Downloading Base app from System Menu %wadname:~-4%: 000000%version%.app
echo.

set dlname=000000%version%_%wadname:~-4%.app

::----if exist and fails md5 check, delete and redownload----
if not exist "%Drive%"\ModThemes\%dlname% goto:nocheckexisting
set md5basecheck=
support\sfk md5 -quiet -verify %md5base% "%Drive%"\ModThemes\%dlname%
if errorlevel 1 set md5basecheck=fail
IF "%md5basecheck%"=="" set md5basecheck=pass
if /i "%md5basecheck%" NEQ "fail" goto:pass

:fail
echo.
support\sfk echo [Yellow] This base app already exists but it failed MD5 verification.
support\sfk echo [Yellow] The current version of the file will be deleted and the file will be re-downloaded.
echo.
SET /a retry=%retry%+1
SET /a attempt=%attempt%+1
del "%Drive%"\ModThemes\%dlname%>nul
if exist temp\%dlname% del temp\%dlname%>nul
goto:DOWNLOADSTART2

:pass
support\sfk echo -spat \x20 \x20 \x20 [Green] Base App already exists and has been verified, Continuing...
echo.
goto:mym_download
:nocheckexisting


if exist temp\%dlname% goto:AlreadyinTemp


support\NusFileGrabber.exe %version%
if exist 000000%version%.app move /Y 000000%version%.app temp\%dlname%>nul

:AlreadyinTemp
copy /y temp\%dlname% "%Drive%"\ModThemes\%dlname% >nul




::----Check base APP-----------
::----check after downloading - if md5 check fails, delete and redownload----
if exist "%Drive%"\ModThemes\%dlname% goto:checkexisting

:missing
if /i "%attempt%" EQU "1" goto:missingretry
echo.
support\sfk echo [Magenta] This file has failed to download properly multiple times, Skipping download.
echo.
if /i "%AdvancedDownload%" NEQ "Y" echo "support\sfk echo %wadname%.csm: [Red]Missing">>temp\ModMii_Log.bat
goto:NEXT

:missingretry
echo.
support\sfk echo [Yellow] The file is missing, retrying download.
echo.
SET /a retry=%retry%+1
SET /a attempt=%attempt%+1
goto:DOWNLOADSTART2

:checkexisting
set md5basecheck=

support\sfk md5 -quiet -verify %md5base% "%Drive%"\ModThemes\%dlname%
if errorlevel 1 set md5basecheck=fail
IF "%md5basecheck%"=="" set md5basecheck=pass
if /i "%md5basecheck%" NEQ "fail" goto:pass

:fail
if /i "%attempt%" NEQ "1" goto:multiplefail
echo.
support\sfk echo [Yellow] This base app already exists but it failed MD5 verification.
support\sfk echo [Yellow] The current version of the file will be deleted and the file will be re-downloaded.
echo.
del "%Drive%"\ModThemes\%dlname%>nul
if exist temp\%dlname% del temp\%dlname%>nul
SET /a retry=%retry%+1
SET /a attempt=%attempt%+1
goto:DOWNLOADSTART2

:multiplefail
echo.
support\sfk echo [Magenta] This file has failed to download properly multiple times, Skipping download.
echo.
set multiplefail=Y
if /i "%AdvancedDownload%" NEQ "Y" echo "support\sfk echo %wadname%.csm: [Red]Missing">>temp\ModMii_Log.bat
goto:NEXT

:pass
echo.
support\sfk echo -spat \x20 \x20 \x20 [Green] Base App has been Downloaded Successfully, Continuing...
echo.
::if /i "%AdvancedDownload%" NEQ "Y" echo "echo %wadname%.csm: Valid">>temp\ModMii_Log.bat
goto:mym_download






::-------------------mym download to build csm file---------------------

:mym_download

set mym0=%mym1%
set md5mym0=%md5mym1%
set mym2=

:mym2_download

echo.
echo Downloading %mym0%
echo.

::----if exist and fails md5 check, delete and redownload----
if not exist "temp\%mym0%" goto:nocheckexisting
set md5mymcheck=
support\sfk md5 -quiet -verify %md5mym0% "temp\%mym0%"
if errorlevel 1 set md5mymcheck=fail
IF "%md5mymcheck%"=="" set md5mymcheck=pass
if /i "%md5mymcheck%" NEQ "fail" goto:pass

:fail
echo.
support\sfk echo [Yellow] This mym file already exists but it failed MD5 verification.
support\sfk echo [Yellow] The current version of the file will be deleted and the file will be re-downloaded.
echo.
SET /a retry=%retry%+1
SET /a attempt=%attempt%+1
del "temp\%mym0%">nul
goto:DOWNLOADSTART2

:pass
support\sfk echo -spat \x20 \x20 \x20 [Green] File already exists and has been verified, Continuing...
echo.
::if /i "%category%" EQU "SMTHEME" goto:SMTHEME2
goto:download_mym2
:nocheckexisting

start %ModMiimin%/wait support\wget --no-check-certificate -t 3 "https://googledrive.com/host/0BzWzf-jnAnp1YkFURFF0cDdsRUE/ModMii/%mym0%"
if exist "%mym0%" move /Y "%mym0%" temp>nul




::----Check mym file after downloading-----------
::----check after downloading - if md5 check fails, delete and redownload----
if exist "temp\%mym0%" goto:checkexisting

:missing
if /i "%attempt%" EQU "1" goto:missingretry
echo.
support\sfk echo [Magenta] This file has failed to download properly multiple times, Skipping download.
echo.
if /i "%AdvancedDownload%" NEQ "Y" echo "support\sfk echo %name%: [Red]Missing">>temp\ModMii_Log.bat
goto:NEXT

:missingretry
echo.
support\sfk echo [Yellow] The file is missing, retrying download.
echo.
SET /a retry=%retry%+1
SET /a attempt=%attempt%+1
goto:DOWNLOADSTART2

:checkexisting
set md5mymcheck=

support\sfk md5 -quiet -verify %md5mym0% "temp\%mym0%"
if errorlevel 1 set md5mymcheck=fail
IF "%md5mymcheck%"=="" set md5mymcheck=pass
if /i "%md5mymcheck%" NEQ "fail" goto:pass

:fail
if /i "%attempt%" NEQ "1" goto:multiplefail
echo.
support\sfk echo [Yellow] This File already exists but it failed MD5 verification.
support\sfk echo [Yellow] The current version of the file will be deleted and the file will be re-downloaded.
echo.
del "temp\%mym0%">nul
SET /a retry=%retry%+1
SET /a attempt=%attempt%+1
goto:DOWNLOADSTART2

:multiplefail
echo.
support\sfk echo [Magenta] This file has failed to download properly multiple times, Skipping download.
echo.
set multiplefail=Y
if /i "%AdvancedDownload%" NEQ "Y" echo "support\sfk echo %name%: [Red]Missing">>temp\ModMii_Log.bat
goto:NEXT

:pass
echo.
support\sfk echo -spat \x20 \x20 \x20 [Green] File has been Downloaded Successfully, Continuing...
echo.
::if /i "%category%" EQU "SMTHEME" goto:SMTHEME2
::goto:build_csm



:download_mym2
if /i "%mym0%" EQU "%mym2%" goto:thememiiDL

if /i "%effect%" EQU "No-Spin" set mym2=optional_non_spinning_outline.mym
if /i "%effect%" EQU "No-Spin" set md5mym2=9e70e955aa9ba04cb904b350402ed5b3

if /i "%effect%" EQU "Spin" set mym2=optional_spinning_outline.mym
if /i "%effect%" EQU "Spin" set md5mym2=b66e0d93eac883651898090236c14306

if /i "%effect%" EQU "Fast-Spin" set mym2=optional_fast_spinning_outline.mym
if /i "%effect%" EQU "Fast-Spin" set md5mym2=1ddddcf02bc7024b7fde393308cdbd5f

set mym0=%mym2%
set md5mym0=%md5mym2%
goto:mym2_download



::---------thememii cmd line download-------------
:thememiiDL

echo.
echo Downloading ThemeMii Cmd Line
echo.

set ThemeMiiZip=thememii_cmd.v1.1_3.5NetFramework.zip
set md5TMCL=25b32f4e282e4c0bef2b21ca86a8df9a
::if exist "temp\DBUPDATE%currentversion%.bat" call "temp\DBUPDATE%currentversion%.bat"


::----if exist and fails md5 check, delete and redownload----
if not exist temp\TMCL.exe goto:nocheckexisting
set md5TMCLcheck=
support\sfk md5 -quiet -verify %md5TMCL% temp\TMCL.exe
if errorlevel 1 set md5TMCLcheck=fail
IF "%md5TMCLcheck%"=="" set md5TMCLcheck=pass
if /i "%md5TMCLcheck%" NEQ "fail" goto:pass

:fail
echo.
support\sfk echo [Yellow] This file already exists but it failed MD5 verification.
support\sfk echo [Yellow] The current version of the file will be deleted and the file will be re-downloaded.
echo.
SET /a retry=%retry%+1
SET /a attempt=%attempt%+1
del temp\TMCL.exe>nul
goto:DOWNLOADSTART2

:pass
support\sfk echo -spat \x20 \x20 \x20 [Green] File already exists and has been verified, Continuing...
echo.
goto:build_csm
:nocheckexisting


start %ModMiimin%/wait support\wget --no-check-certificate -t 3 "https://googledrive.com/host/0BzWzf-jnAnp1YkFURFF0cDdsRUE/ModMii/%ThemeMiiZip%"

if exist %ThemeMiiZip% support\7za e -aoa %ThemeMiiZip% -otemp *.* -r
if exist %ThemeMiiZip% del %ThemeMiiZip%>nul


::----Check mym file after downloading-----------
::----check after downloading - if md5 check fails, delete and redownload----
if exist temp\TMCL.exe goto:checkexisting

:missing
if /i "%attempt%" EQU "1" goto:missingretry
echo.
support\sfk echo [Magenta] This file has failed to download properly multiple times, Skipping download.
echo.
if /i "%AdvancedDownload%" NEQ "Y" echo "support\sfk echo %name%: [Red]Missing">>temp\ModMii_Log.bat
goto:NEXT

:missingretry
echo.
support\sfk echo [Yellow] The file is missing, retrying download.
echo.
SET /a retry=%retry%+1
SET /a attempt=%attempt%+1
goto:DOWNLOADSTART2

:checkexisting
set md5TMCLcheck=

support\sfk md5 -quiet -verify %md5TMCL% temp\TMCL.exe
if errorlevel 1 set md5TMCLcheck=fail
IF "%md5TMCLcheck%"=="" set md5TMCLcheck=pass
if /i "%md5TMCLcheck%" NEQ "fail" goto:pass

:fail
if /i "%attempt%" NEQ "1" goto:multiplefail
echo.
support\sfk echo [Yellow] This file already exists but it failed MD5 verification.
support\sfk echo [Yellow] The current version of the file will be deleted and the file will be re-downloaded.
echo.
del temp\TMCL.exe>nul
SET /a retry=%retry%+1
SET /a attempt=%attempt%+1
goto:DOWNLOADSTART2

:multiplefail
echo.
support\sfk echo [Magenta] This file has failed to download properly multiple times, Skipping download.
echo.
set multiplefail=Y
if /i "%AdvancedDownload%" NEQ "Y" echo "support\sfk echo %name%: [Red]Missing">>temp\ModMii_Log.bat
goto:NEXT

:pass
echo.
support\sfk echo -spat \x20 \x20 \x20 [Green] File has been Downloaded Successfully, Continuing...
echo.
::goto:build_csm



:build_csm
if /i "%category%" EQU "SMTHEME" goto:SMTHEME2
echo.
echo Building Theme (%wadname%.csm), please wait...
echo.


::Portable ModMii Installation fix

if /i "%Homedrive%" EQU "%ModMiiDrive%" goto:skipPortableFix
if not exist "%homedrive%\ModMii\temp" mkdir "%homedrive%\ModMii\temp"

copy /y "temp\TMCL.exe" "%homedrive%\ModMii\temp\TMCL.exe">nul
copy /y "temp\ASH.exe" "%homedrive%\ModMii\temp\ASH.exe">nul
copy /y "temp\ICSharpCode.SharpZipLib.dll" "%homedrive%\ModMii\temp\ICSharpCode.SharpZipLib.dll">nul

move /y "temp\TMCL.exe" "temp\TMCL.bak">nul

:skipPortableFix


cd /d temp
TMCL.exe "%mym1%" "%dlname%" "temp.csm">nul
TMCL.exe "%mym2%" "temp.csm" "%wadname%.csm">nul
cd /d ..

if exist "temp\temp.csm" del "temp\temp.csm">nul
::del %basecios%\00000001-original.app>nul

if exist "temp\TMCL.bak" move /y "temp\TMCL.bak" "temp\TMCL.exe">nul

if exist "temp\%wadname%.csm" move /y "temp\%wadname%.csm" "%Drive%\ModThemes\%wadname%.csm">nul


::----check after downloading - if md5 check fails, delete and redownload----
if exist "%Drive%"\ModThemes\%wadname%.csm goto:checkexisting

:missing
if /i "%attempt%" EQU "1" goto:missingretry
echo.
support\sfk echo [Magenta] This file has failed to download properly multiple times, Skipping download.
echo.
if /i "%AdvancedDownload%" NEQ "Y" echo "support\sfk echo %name%: [Red]Missing">>temp\ModMii_Log.bat
goto:NEXT

:missingretry
echo.
support\sfk echo [Yellow] The file is missing, retrying download.
echo.
SET /a retry=%retry%+1
SET /a attempt=%attempt%+1
goto:DOWNLOADSTART2

:checkexisting
set md5check=
support\sfk md5 -quiet -verify %md5% "%Drive%"\ModThemes\%wadname%.csm
if errorlevel 1 set md5check=fail
IF "%md5check%"=="" set md5check=pass
if /i "%md5check%" NEQ "fail" goto:pass

:fail
if /i "%attempt%" NEQ "1" goto:multiplefail
echo.
support\sfk echo [Yellow] This file already exists but it failed MD5 verification.
support\sfk echo [Yellow] The current version of the file will be deleted and the file will be re-downloaded.
echo.
del "%Drive%"\ModThemes\%wadname%.csm>nul
SET /a retry=%retry%+1
SET /a attempt=%attempt%+1
goto:DOWNLOADSTART2

:multiplefail
echo.
support\sfk echo [Magenta] This file has failed to download properly multiple times, Skipping download.
echo.
set multiplefail=Y
if /i "%AdvancedDownload%" NEQ "Y" echo "support\sfk echo %name%: [Red]Invalid">>temp\ModMii_Log.bat
goto:NEXT

:pass
echo.
support\sfk echo [Green]Download Successful
echo.
if /i "%AdvancedDownload%" NEQ "Y" echo "echo %name%: Valid">>temp\ModMii_Log.bat
goto:NEXT


::--------------------------------------Cheat Codes: txtcodes from geckocodes.org------------------------------
:CHEATS

::set cheatregion=all

if exist "codeindex.txt" del "codeindex.txt" >nul
if exist "codeindextemp.txt" del "codeindextemp.txt">nul

echo.
echo       Downloading %cheatregion% Region Cheat Codes for the following console(s):
echo.
if /i "%wiicheat%" EQU "ON" echo                * Wii
if /i "%WiiWarecheat%" EQU "ON" echo                * WiiWare
if /i "%VCArcadecheat%" EQU "ON" echo                * VC Arcade
if /i "%WiiChannelscheat%" EQU "ON" echo                * Wii Channels
if /i "%Gamecubecheat%" EQU "ON" echo                * Gamecube
if /i "%NEScheat%" EQU "ON" echo                * NES/Famicom VC
if /i "%SNEScheat%" EQU "ON" echo                * Super NES/Famicom VC
if /i "%N64cheat%" EQU "ON" echo                * Nintendo 64 VC
if /i "%SMScheat%" EQU "ON" echo                * Sega Master System VC
if /i "%Segacheat%" EQU "ON" echo                * Sega Genesis/Mega Drive VC
if /i "%NeoGeocheat%" EQU "ON" echo                * NeoGeo VC
if /i "%Commodorecheat%" EQU "ON" echo                * Commodore 64 VC
if /i "%MSXcheat%" EQU "ON" echo                * MSX VC
if /i "%TurboGraFX-16cheat%" EQU "ON" echo                * TurboGraFX-16 VC
if /i "%TurboGraFX-CDcheat%" EQU "ON" echo                * TurboGraFX-CD VC
echo.
if /i "%cheatlocation%" EQU "B" echo           Location(s) to save cheats: (txtcodes and codes\X\L)
if /i "%cheatlocation%" EQU "T" echo           Location(s) to save cheats: (txtcodes)
if /i "%cheatlocation%" EQU "C" echo           Location(s) to save cheats: (codes\X\L)
echo.
if /i "%overwritecodes%" EQU "OFF" echo           Overwrite existing txtcodes (Disabled)
if /i "%overwritecodes%" EQU "ON" echo           Overwrite existing txtcodes (Enabled)
echo.
echo       Note: The above settings can be customized in the Cheat Code Options
echo.
echo.
echo   Grabbing current list of cheats from geckocodes.org,
echo   Please wait...
echo.


::---get game/iso list and game count-------
if /i "%cheatlocation%" EQU "C" goto:skip
if not exist "%drive%"\txtcodes mkdir "%drive%"\txtcodes
:skip




::-----------used to get full list of all games---------------
goto:skipcheatrepeat
:cheatrepeat
if exist codeindex.txt copy /y codeindex.txt codeindextemp.txt >nul
if exist codeindex.txt (copy /y codeindextemp.txt+"index*=all" codeindex.txt >nul) else (move /y "index*=all" "codeindex.txt">nul)
if exist "index*=all" del "index*=all" >nul
if exist "codeindextemp.txt" del "codeindextemp.txt" >nul
goto:%nextcheatlist%
:skipcheatrepeat





::--------------ALL REGION---------------
if /i "%cheatregion%" NEQ "all" goto:skipall

::-------Wii Games--------
set nextcheatlist=allwiiwarecheats
if /i "%wiicheat%" NEQ "on" goto:%nextcheatlist%
start %ModMiimin%/wait support\wget --no-check-certificate -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=R&r=*&l=all"
goto:cheatrepeat

::-------WiiWare------
:allwiiwarecheats
set nextcheatlist=allvccheats
if /i "%WiiWarecheat%" NEQ "on" goto:%nextcheatlist%
start %ModMiimin%/wait support\wget --no-check-certificate -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=W&r=*&l=all"
goto:cheatrepeat

::-------VC Arcade------
:allVCcheats
set nextcheatlist=allwiichannelcheats
if /i "%VCArcadecheat%" NEQ "on" goto:%nextcheatlist%
start %ModMiimin%/wait support\wget --no-check-certificate -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=D&r=*&l=all"
goto:cheatrepeat

::-------Wii Channels------
:allwiichannelcheats
set nextcheatlist=allGCcheats
if /i "%WiiChannelscheat%" NEQ "on" goto:%nextcheatlist%
start %ModMiimin%/wait support\wget --no-check-certificate -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=H&r=*&l=all"
goto:cheatrepeat

::-------Gamecube------
:allGCcheats
set nextcheatlist=allNEScheats
if /i "%Gamecubecheat%" NEQ "on" goto:%nextcheatlist%
start %ModMiimin%/wait support\wget --no-check-certificate -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=G&r=*&l=all"
goto:cheatrepeat

::-------NES------
:allNEScheats
set nextcheatlist=allSNEScheats
if /i "%NEScheat%" NEQ "on" goto:%nextcheatlist%
start %ModMiimin%/wait support\wget --no-check-certificate -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=F&r=*&l=all"
goto:cheatrepeat

::-------SNES------
:allSNEScheats
set nextcheatlist=allN64cheats
if /i "%SNEScheat%" NEQ "on" goto:%nextcheatlist%
start %ModMiimin%/wait support\wget --no-check-certificate -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=J&r=*&l=all"
goto:cheatrepeat

::-------N64------
:allN64cheats
set nextcheatlist=allSMScheats
if /i "%N64cheat%" NEQ "on" goto:%nextcheatlist%
start %ModMiimin%/wait support\wget --no-check-certificate -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=N&r=*&l=all"
goto:cheatrepeat

::-------SMS------
:allSMScheats
set nextcheatlist=allGenesischeats
if /i "%SMScheat%" NEQ "on" goto:%nextcheatlist%
start %ModMiimin%/wait support\wget --no-check-certificate -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=L&r=*&l=all"
goto:cheatrepeat

::-------Genesis------
:allGenesischeats
set nextcheatlist=allNEOcheats
if /i "%Segacheat%" NEQ "on" goto:%nextcheatlist%
start %ModMiimin%/wait support\wget --no-check-certificate -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=M&r=*&l=all"
goto:cheatrepeat

::-------NEO------
:allNEOcheats
set nextcheatlist=allCOMcheats
if /i "%NeoGeocheat%" NEQ "on" goto:%nextcheatlist%
start %ModMiimin%/wait support\wget --no-check-certificate -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=E&r=*&l=all"
goto:cheatrepeat

::-------COMMODORE------
:allCOMcheats
set nextcheatlist=allMSXcheats
if /i "%Commodorecheat%" NEQ "on" goto:%nextcheatlist%
start %ModMiimin%/wait support\wget --no-check-certificate -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=C&r=*&l=all"
goto:cheatrepeat

::-------MSX------
:allMSXcheats
set nextcheatlist=allT16cheats
if /i "%MSXcheat%" NEQ "on" goto:%nextcheatlist%
start %ModMiimin%/wait support\wget --no-check-certificate -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=X&r=*&l=all"
goto:cheatrepeat

::-------T16------
:allT16cheats
set nextcheatlist=allTCDcheats
if /i "%TurboGraFX-16cheat%" NEQ "on" goto:%nextcheatlist%
start %ModMiimin%/wait support\wget --no-check-certificate -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=P&r=*&l=all"
goto:cheatrepeat

::-------TCD------
:allTCDcheats
set nextcheatlist=skipall
if /i "%TurboGraFX-CDcheat%" NEQ "on" goto:%nextcheatlist%
start %ModMiimin%/wait support\wget --no-check-certificate -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=Q&r=*&l=all"
goto:cheatrepeat

:skipall



::--------------USA REGION---------------
if /i "%cheatregion%" NEQ "USA" goto:skipUSA

::-------Wii Games--------
set nextcheatlist=USAwiiwarecheats
if /i "%wiicheat%" NEQ "on" goto:%nextcheatlist%
start %ModMiimin%/wait support\wget --no-check-certificate -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=R&r=E&l=all"
goto:cheatrepeat

::-------WiiWare------
:USAwiiwarecheats
set nextcheatlist=USAvccheats
if /i "%WiiWarecheat%" NEQ "on" goto:%nextcheatlist%
start %ModMiimin%/wait support\wget --no-check-certificate -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=W&r=E&l=all"
goto:cheatrepeat

::-------VC Arcade------
:USAVCcheats
set nextcheatlist=USAwiichannelcheats
if /i "%VCArcadecheat%" NEQ "on" goto:%nextcheatlist%
start %ModMiimin%/wait support\wget --no-check-certificate -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=D&r=E&l=all"
goto:cheatrepeat

::-------Wii Channels------
:USAwiichannelcheats
set nextcheatlist=USAGCcheats
if /i "%WiiChannelscheat%" NEQ "on" goto:%nextcheatlist%
start %ModMiimin%/wait support\wget --no-check-certificate -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=H&r=E&l=all"
goto:cheatrepeat

::-------Gamecube------
:USAGCcheats
set nextcheatlist=USANEScheats
if /i "%Gamecubecheat%" NEQ "on" goto:%nextcheatlist%
start %ModMiimin%/wait support\wget --no-check-certificate -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=G&r=E&l=all"
goto:cheatrepeat

::-------NES------
:USANEScheats
set nextcheatlist=USASNEScheats
if /i "%NEScheat%" NEQ "on" goto:%nextcheatlist%
start %ModMiimin%/wait support\wget --no-check-certificate -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=F&r=E&l=all"
goto:cheatrepeat

::-------SNES------
:USASNEScheats
set nextcheatlist=USAN64cheats
if /i "%SNEScheat%" NEQ "on" goto:%nextcheatlist%
start %ModMiimin%/wait support\wget --no-check-certificate -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=J&r=E&l=all"
goto:cheatrepeat

::-------N64------
:USAN64cheats
set nextcheatlist=USASMScheats
if /i "%N64cheat%" NEQ "on" goto:%nextcheatlist%
start %ModMiimin%/wait support\wget --no-check-certificate -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=N&r=E&l=all"
goto:cheatrepeat

::-------SMS------
:USASMScheats
set nextcheatlist=USAGenesischeats
if /i "%SMScheat%" NEQ "on" goto:%nextcheatlist%
start %ModMiimin%/wait support\wget --no-check-certificate -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=L&r=E&l=all"
goto:cheatrepeat

::-------Genesis------
:USAGenesischeats
set nextcheatlist=USANEOcheats
if /i "%Segacheat%" NEQ "on" goto:%nextcheatlist%
start %ModMiimin%/wait support\wget --no-check-certificate -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=M&r=E&l=all"
goto:cheatrepeat

::-------NEO------
:USANEOcheats
set nextcheatlist=USACOMcheats
if /i "%NeoGeocheat%" NEQ "on" goto:%nextcheatlist%
start %ModMiimin%/wait support\wget --no-check-certificate -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=E&r=E&l=all"
goto:cheatrepeat

::-------COMMODORE------
:USACOMcheats
set nextcheatlist=USAMSXcheats
if /i "%Commodorecheat%" NEQ "on" goto:%nextcheatlist%
start %ModMiimin%/wait support\wget --no-check-certificate -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=C&r=E&l=all"
goto:cheatrepeat

::-------MSX------
:USAMSXcheats
set nextcheatlist=USAT16cheats
if /i "%MSXcheat%" NEQ "on" goto:%nextcheatlist%
start %ModMiimin%/wait support\wget --no-check-certificate -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=X&r=E&l=all"
goto:cheatrepeat

::-------T16------
:USAT16cheats
set nextcheatlist=USATCDcheats
if /i "%TurboGraFX-16cheat%" NEQ "on" goto:%nextcheatlist%
start %ModMiimin%/wait support\wget --no-check-certificate -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=P&r=E&l=all"
goto:cheatrepeat

::-------TCD------
:USATCDcheats
set nextcheatlist=skipUSA
if /i "%TurboGraFX-CDcheat%" NEQ "on" goto:%nextcheatlist%
start %ModMiimin%/wait support\wget --no-check-certificate -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=Q&r=E&l=all"
goto:cheatrepeat

:skipUSA





::--------------PAL REGION---------------
if /i "%cheatregion%" NEQ "PAL" goto:skipPAL

::-------Wii Games--------
set nextcheatlist=PALwiiwarecheats
if /i "%wiicheat%" NEQ "on" goto:%nextcheatlist%
start %ModMiimin%/wait support\wget --no-check-certificate -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=R&r=P&l=all"
goto:cheatrepeat

::-------WiiWare------
:PALwiiwarecheats
set nextcheatlist=PALvccheats
if /i "%WiiWarecheat%" NEQ "on" goto:%nextcheatlist%
start %ModMiimin%/wait support\wget --no-check-certificate -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=W&r=P&l=all"
goto:cheatrepeat

::-------VC Arcade------
:PALVCcheats
set nextcheatlist=PALwiichannelcheats
if /i "%VCArcadecheat%" NEQ "on" goto:%nextcheatlist%
start %ModMiimin%/wait support\wget --no-check-certificate -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=D&r=P&l=all"
goto:cheatrepeat

::-------Wii Channels------
:PALwiichannelcheats
set nextcheatlist=PALGCcheats
if /i "%WiiChannelscheat%" NEQ "on" goto:%nextcheatlist%
start %ModMiimin%/wait support\wget --no-check-certificate -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=H&r=P&l=all"
goto:cheatrepeat

::-------Gamecube------
:PALGCcheats
set nextcheatlist=PALNEScheats
if /i "%Gamecubecheat%" NEQ "on" goto:%nextcheatlist%
start %ModMiimin%/wait support\wget --no-check-certificate -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=G&r=P&l=all"
goto:cheatrepeat

::-------NES------
:PALNEScheats
set nextcheatlist=PALSNEScheats
if /i "%NEScheat%" NEQ "on" goto:%nextcheatlist%
start %ModMiimin%/wait support\wget --no-check-certificate -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=F&r=P&l=all"
goto:cheatrepeat

::-------SNES------
:PALSNEScheats
set nextcheatlist=PALN64cheats
if /i "%SNEScheat%" NEQ "on" goto:%nextcheatlist%
start %ModMiimin%/wait support\wget --no-check-certificate -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=J&r=P&l=all"
goto:cheatrepeat

::-------N64------
:PALN64cheats
set nextcheatlist=PALSMScheats
if /i "%N64cheat%" NEQ "on" goto:%nextcheatlist%
start %ModMiimin%/wait support\wget --no-check-certificate -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=N&r=P&l=all"
goto:cheatrepeat

::-------SMS------
:PALSMScheats
set nextcheatlist=PALGenesischeats
if /i "%SMScheat%" NEQ "on" goto:%nextcheatlist%
start %ModMiimin%/wait support\wget --no-check-certificate -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=L&r=P&l=all"
goto:cheatrepeat

::-------Genesis------
:PALGenesischeats
set nextcheatlist=PALNEOcheats
if /i "%Segacheat%" NEQ "on" goto:%nextcheatlist%
start %ModMiimin%/wait support\wget --no-check-certificate -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=M&r=P&l=all"
goto:cheatrepeat

::-------NEO------
:PALNEOcheats
set nextcheatlist=PALCOMcheats
if /i "%NeoGeocheat%" NEQ "on" goto:%nextcheatlist%
start %ModMiimin%/wait support\wget --no-check-certificate -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=E&r=P&l=all"
goto:cheatrepeat

::-------COMMODORE------
:PALCOMcheats
set nextcheatlist=PALMSXcheats
if /i "%Commodorecheat%" NEQ "on" goto:%nextcheatlist%
start %ModMiimin%/wait support\wget --no-check-certificate -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=C&r=P&l=all"
goto:cheatrepeat

::-------MSX------
:PALMSXcheats
set nextcheatlist=PALT16cheats
if /i "%MSXcheat%" NEQ "on" goto:%nextcheatlist%
start %ModMiimin%/wait support\wget --no-check-certificate -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=X&r=P&l=all"
goto:cheatrepeat

::-------T16------
:PALT16cheats
set nextcheatlist=PALTCDcheats
if /i "%TurboGraFX-16cheat%" NEQ "on" goto:%nextcheatlist%
start %ModMiimin%/wait support\wget --no-check-certificate -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=P&r=P&l=all"
goto:cheatrepeat

::-------TCD------
:PALTCDcheats
set nextcheatlist=skipPAL
if /i "%TurboGraFX-CDcheat%" NEQ "on" goto:%nextcheatlist%
start %ModMiimin%/wait support\wget --no-check-certificate -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=Q&r=P&l=all"
goto:cheatrepeat

:skipPAL





::--------------JAP REGION---------------
if /i "%cheatregion%" NEQ "JAP" goto:skipJAP

::-------Wii Games--------
set nextcheatlist=JAPwiiwarecheats
if /i "%wiicheat%" NEQ "on" goto:%nextcheatlist%
start %ModMiimin%/wait support\wget --no-check-certificate -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=R&r=J&l=all"
goto:cheatrepeat

::-------WiiWare------
:JAPwiiwarecheats
set nextcheatlist=JAPvccheats
if /i "%WiiWarecheat%" NEQ "on" goto:%nextcheatlist%
start %ModMiimin%/wait support\wget --no-check-certificate -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=W&r=J&l=all"
goto:cheatrepeat

::-------VC Arcade------
:JAPVCcheats
set nextcheatlist=JAPwiichannelcheats
if /i "%VCArcadecheat%" NEQ "on" goto:%nextcheatlist%
start %ModMiimin%/wait support\wget --no-check-certificate -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=D&r=J&l=all"
goto:cheatrepeat

::-------Wii Channels------
:JAPwiichannelcheats
set nextcheatlist=JAPGCcheats
if /i "%WiiChannelscheat%" NEQ "on" goto:%nextcheatlist%
start %ModMiimin%/wait support\wget --no-check-certificate -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=H&r=J&l=all"
goto:cheatrepeat

::-------Gamecube------
:JAPGCcheats
set nextcheatlist=JAPNEScheats
if /i "%Gamecubecheat%" NEQ "on" goto:%nextcheatlist%
start %ModMiimin%/wait support\wget --no-check-certificate -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=G&r=J&l=all"
goto:cheatrepeat

::-------NES------
:JAPNEScheats
set nextcheatlist=JAPSNEScheats
if /i "%NEScheat%" NEQ "on" goto:%nextcheatlist%
start %ModMiimin%/wait support\wget --no-check-certificate -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=F&r=J&l=all"
goto:cheatrepeat

::-------SNES------
:JAPSNEScheats
set nextcheatlist=JAPN64cheats
if /i "%SNEScheat%" NEQ "on" goto:%nextcheatlist%
start %ModMiimin%/wait support\wget --no-check-certificate -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=J&r=J&l=all"
goto:cheatrepeat

::-------N64------
:JAPN64cheats
set nextcheatlist=JAPSMScheats
if /i "%N64cheat%" NEQ "on" goto:%nextcheatlist%
start %ModMiimin%/wait support\wget --no-check-certificate -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=N&r=J&l=all"
goto:cheatrepeat

::-------SMS------
:JAPSMScheats
set nextcheatlist=JAPGenesischeats
if /i "%SMScheat%" NEQ "on" goto:%nextcheatlist%
start %ModMiimin%/wait support\wget --no-check-certificate -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=L&r=J&l=all"
goto:cheatrepeat

::-------Genesis------
:JAPGenesischeats
set nextcheatlist=JAPNEOcheats
if /i "%Segacheat%" NEQ "on" goto:%nextcheatlist%
start %ModMiimin%/wait support\wget --no-check-certificate -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=M&r=J&l=all"
goto:cheatrepeat

::-------NEO------
:JAPNEOcheats
set nextcheatlist=JAPCOMcheats
if /i "%NeoGeocheat%" NEQ "on" goto:%nextcheatlist%
start %ModMiimin%/wait support\wget --no-check-certificate -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=E&r=J&l=all"
goto:cheatrepeat

::-------COMMODORE------
:JAPCOMcheats
set nextcheatlist=JAPMSXcheats
if /i "%Commodorecheat%" NEQ "on" goto:%nextcheatlist%
start %ModMiimin%/wait support\wget --no-check-certificate -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=C&r=J&l=all"
goto:cheatrepeat

::-------MSX------
:JAPMSXcheats
set nextcheatlist=JAPT16cheats
if /i "%MSXcheat%" NEQ "on" goto:%nextcheatlist%
start %ModMiimin%/wait support\wget --no-check-certificate -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=X&r=J&l=all"
goto:cheatrepeat

::-------T16------
:JAPT16cheats
set nextcheatlist=JAPTCDcheats
if /i "%TurboGraFX-16cheat%" NEQ "on" goto:%nextcheatlist%
start %ModMiimin%/wait support\wget --no-check-certificate -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=P&r=J&l=all"
goto:cheatrepeat

::-------TCD------
:JAPTCDcheats
set nextcheatlist=skipJAP
if /i "%TurboGraFX-CDcheat%" NEQ "on" goto:%nextcheatlist%
start %ModMiimin%/wait support\wget --no-check-certificate -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=Q&r=J&l=all"
goto:cheatrepeat

:skipJAP



support\sfk filter -quiet codeindex.txt -+"index.php?c=******" -write -yes



goto:nextstep
::----------DISABLED------------
::-----remove titles that already exist (if applicable)---------
if /i "%overwritecodes%" EQU "on" goto:nextstep
if not exist "%drive%"\txtcodes\*.txt goto:nextstep
::echo Checking for new cheat codes
::echo This could take a minute, please wait...
::echo.
echo The following cheats already exist and will be removed from the download queue:
echo.
dir /b "%drive%"\txtcodes>existingcodes.txt
support\sfk filter -quiet existingcodes.txt -+.txt -rep _.txt__ -write -yes
::Loop through the existing list of codes (existingcodes.txt) and remove each existing game from codeindex.txt
for /F "tokens=*" %%A in (existingcodes.txt) do call :processthis %%A
goto:nextstep

:processthis
::this is repeated for each line of the txt.file
::"%*" (no quotes) is the variable for each line as it passes through the loop

set removetitleID=%*
echo Skipping %removetitleID%.txt...
support\sfk filter -quiet codeindex.txt -!%removetitleID% -write -yes
goto:EOF
:nextstep


if exist existingcodes.txt del existingcodes.txt>nul


support\sfk filter codeindex.txt -unique -write -yes>nul
FINDSTR /N href codeindex.txt>codeindexfull.txt
del codeindex.txt>nul

::totalcodes
setlocal ENABLEDELAYEDEXPANSION
set totalcodes=0
set codenumber=0
for /f "delims=" %%i in (codeindexfull.txt) do set /a totalcodes=!totalcodes!+1
setlocal DISABLEDELAYEDEXPANSION

echo.
:processcode

copy /y codeindexfull.txt codeindexfull2.txt>nul

if /i "%totalcodes%" EQU "%codenumber%" goto:nextstep
set /a codenumber=%codenumber%+1

support\sfk filter -quiet codeindexfull2.txt -ls+"%codenumber%:<" -ls!"%codenumber%%codenumber%:<" -ls!"%codenumber%%codenumber%%codenumber%:<" -rep _"*title='*["_"set titleid="_ -rep _"] *"__ -rep _"set titleid=set titleid="_"set titleid="_ -write -yes

::support\sfk filter -quiet codeindexfull2.txt -ls+"%codenumber%:<" -ls!"%codenumber%%codenumber%:<" -ls!"%codenumber%%codenumber%%codenumber%:<" -rep _"*'Wii ["_"set titleid="_ -rep _"] *"__ -write -yes



FINDSTR /N set codeindexfull2.txt>codeindex.bat
del codeindexfull2.txt>nul

support\sfk filter -quiet codeindex.bat -ls+"1:" -rep _"1:"__ -write -yes
call codeindex.bat
del codeindex.bat>nul


::now get game name!!
copy /y codeindexfull.txt codeindexTitle.bat>nul
::add in delay so support\sfk has access to codeindexTitle.bat (Foez reported bug)
::@ping 127.0.0.1 -n 1 -w 1500> nul
support\sfk filter -quiet codeindexTitle.bat -+"%titleid%" -rep _"*c=%titleid%"_"set titlename="_ -rep _" [%titleid%]*"_"""_ -rep _>__ -write -yes
support\sfk filter -quiet codeindexTitle.bat -ls+"set titlename=" -write -yes
call codeindexTitle.bat
del codeindexTitle.bat>nul


::if /i "%cheatlocation%" EQU "T" goto:skipconsoleinfo

::now get console!!
copy /y codeindexfull.txt codeindexConsole.bat>nul
support\sfk filter -quiet codeindexConsole.bat -+"%titleid%" -rep _"*sysn' title='"_"set console="_ -rep _"'>[*"_"""_ -write -yes
support\sfk filter -quiet codeindexConsole.bat -rep _"""__ -write -yes
support\sfk filter -quiet codeindexConsole.bat -ls+"set console=" -write -yes
call codeindexConsole.bat
del codeindexConsole.bat>nul

::get console code
set consolecode=
if /i "%console%" EQU "Wii" set consolecode=R
if /i "%console%" EQU "WiiWare" set consolecode=W
if /i "%console%" EQU "VC Arcade" set consolecode=D
if /i "%console%" EQU "GameCube" set consolecode=G
::Wii Channels(H)-currently no codes, so unsure of "Wii Channels"
if /i "%console%" EQU "Wii Channels" set consolecode=H
if /i "%console%" EQU "NES/Famicom VC" set consolecode=F
if /i "%console%" EQU "Super NES/Famicom VC" set consolecode=J
if /i "%console%" EQU "Nintendo 64 VC" set consolecode=N
if /i "%console%" EQU "Sega Master System VC" set consolecode=L
if /i "%console%" EQU "Sega Genesis/Mega Drive VC" set consolecode=M
if /i "%console%" EQU "NeoGeo VC" set consolecode=E
if /i "%console%" EQU "Commodore 64 VC" set consolecode=C
if /i "%console%" EQU "MSX VC" set consolecode=X
if /i "%console%" EQU "TurboGraFX-16 VC" set consolecode=P
if /i "%console%" EQU "TurboGraFX-CD VC" set consolecode=Q

::get first letter of titlename (actually second letter cuz first one is ")
set letter1=%titlename:~1,1%
if /i "%letter1%" EQU "0" set letter1=#
if /i "%letter1%" EQU "1" set letter1=#
if /i "%letter1%" EQU "2" set letter1=#
if /i "%letter1%" EQU "3" set letter1=#
if /i "%letter1%" EQU "4" set letter1=#
if /i "%letter1%" EQU "5" set letter1=#
if /i "%letter1%" EQU "6" set letter1=#
if /i "%letter1%" EQU "7" set letter1=#
if /i "%letter1%" EQU "8" set letter1=#
if /i "%letter1%" EQU "9" set letter1=#

:skipconsoleinfo

::echo %titlename%
::echo %titleid%
::echo %console%
::echo %consolecode%
::echo %letter1%

echo.
echo Downloading Cheat %codenumber% of %totalcodes%: %titlename% [%titleid%]

if /i "%cheatlocation%" EQU "T" goto:skip
if not exist "%drive%\codes\%consolecode%\%letter1%" mkdir "%drive%\codes\%consolecode%\%letter1%"
:skip

if /i "%overwritecodes%" EQU "on" goto:overwritecheat


::----copy existing codes to alternate location if missing----
if /i "%cheatlocation%" EQU "C" goto:skip
if not exist "%drive%\codes\%consolecode%\%letter1%\%titleid%.txt" goto:skip
if not exist "%drive%\txtcodes\%titleid%.txt" echo Copying from codes\%consolecode%\%letter1%\%titleid%.txt to txtcodes\%titleid%.txt
if not exist "%drive%\txtcodes\%titleid%.txt" copy /y "%drive%\codes\%consolecode%\%letter1%\%titleid%.txt" "%drive%\txtcodes\%titleid%.txt">nul
:skip
if /i "%cheatlocation%" EQU "T" goto:skip
if not exist "%drive%\txtcodes\%titleid%.txt" goto:skip
if not exist "%drive%\codes\%consolecode%\%letter1%\%titleid%.txt" echo Copying from txtcodes\%titleid%.txt to codes\%consolecode%\%letter1%\%titleid%.txt
if not exist "%drive%\codes\%consolecode%\%letter1%\%titleid%.txt" copy /y "%drive%\txtcodes\%titleid%.txt" "%drive%\codes\%consolecode%\%letter1%\%titleid%.txt">nul
:skip

if /i "%cheatlocation%" EQU "C" goto:skip
if not exist "%drive%\txtcodes\%titleid%.txt" goto:downloadcheat
:skip

if /i "%cheatlocation%" EQU "T" goto:skip
if not exist "%drive%\codes\%consolecode%\%letter1%\%titleid%.txt" goto:downloadcheat
:skip

echo %titleid%.txt already exists,
echo Skipping download...
echo.
goto:processcode

:overwritecheat
if /i "%cheatlocation%" EQU "C" goto:skip
if exist "%drive%\txtcodes\%titleid%.txt" echo Overwriting %drive%\txtcodes\%titleid%.txt...
:skip
if /i "%cheatlocation%" EQU "T" goto:skip
if exist "%drive%\codes\%consolecode%\%letter1%\%titleid%.txt" echo Overwriting %drive%\codes\%consolecode%\%letter1%\%titleid%.txt...
:skip

:downloadcheat
start %ModMiimin%/wait support\wget --no-check-certificate "http://www.geckocodes.org/txt.php?txt=%titleid%"

if /i "%cheatlocation%" EQU "T" move /y "txt.php@txt=%titleid%" "%drive%\txtcodes\%titleid%.txt">nul
if /i "%cheatlocation%" EQU "C" move /y "txt.php@txt=%titleid%" "%drive%\codes\%consolecode%\%letter1%\%titleid%.txt">nul

if /i "%cheatlocation%" EQU "B" copy /y "txt.php@txt=%titleid%" "%drive%\txtcodes\%titleid%.txt">nul
if /i "%cheatlocation%" EQU "B" move /y "txt.php@txt=%titleid%" "%drive%\codes\%consolecode%\%letter1%\%titleid%.txt">nul

::for some reason VC downloads fail, and they leave index.html as a trace instead
if exist index.html del index.html>nul

goto:processcode

:nextstep

del codeindexfull.txt>nul
del codeindexfull2.txt>nul


::Simple Check

if /i "%cheatlocation%" EQU "C" goto:skip
If exist "%DRIVE%"\txtcodes\*.txt echo "echo Cheat Codes: Found">>temp\ModMii_Log.bat
If not exist "%DRIVE%"\txtcodes\*.txt echo "support\sfk echo Cheat Codes: [Red]Missing">>temp\ModMii_Log.bat
:skip

if /i "%cheatlocation%" EQU "B" goto:skip
if /i "%cheatlocation%" EQU "T" goto:skip
If exist "%DRIVE%"\codes echo "echo Cheat Codes: Found">>temp\ModMii_Log.bat
If not exist "%DRIVE%"\codes echo "support\sfk echo Cheat Codes: [Red]Missing">>temp\ModMii_Log.bat
:skip


goto:NEXT




::------------------------NUS File Grabber Downloader---------------------

:DownloadApp

if /i "%code1%" EQU "MYMAPP" goto:MYMAPP

::SNEEKAPP
if not exist "%Drive%"\SNEEKFILES mkdir "%Drive%"\SNEEKFILES
goto:skip

:MYMAPP
if not exist "%Drive%"\ModThemes mkdir "%Drive%"\ModThemes
:skip


set filename=%wadname%
if /i "%code1%" EQU "SNEEKAPP" set path1=SNEEKFILES\
if /i "%code1%" EQU "MYMAPP" set path1=ModThemes\
set md5alt=%md5%
goto:DownloadURL


:DownloadApp2


set dlname=%wadname:~0,8%.app

if exist temp\%wadname% goto:AlreadyinTemp

support\NusFileGrabber.exe %version%
move /Y "%dlname%" temp\%wadname%>nul

:AlreadyinTemp
if /i "%code1%" EQU "MYMAPP" copy /Y temp\"%wadname%" "%Drive%"\ModThemes\%wadname%>nul
if /i "%code1%" EQU "SNEEKAPP" copy /Y temp\"%wadname%" "%Drive%"\SNEEKFILES\%wadname%>nul

goto:URLverifyretry




::-------------------------Download from URLs------------------------------
:DownloadURL
::----if exist and fails md5 check, delete and redownload----
if not exist "%Drive%\%path1%%filename%" goto:nocheckexisting
set md5check=
support\sfk md5 -quiet -verify %md5% "%Drive%\%path1%%filename%"
if errorlevel 1 set md5check=fail
IF "%md5check%"=="" set md5check=pass
if /i "%md5check%" NEQ "fail" goto:pass

:fail
echo.
support\sfk echo [Yellow] This file already exists but it failed MD5 verification.
support\sfk echo [Yellow] The current version of the file will be deleted and the file will be re-downloaded.
echo.
SET /a retry=%retry%+1
SET /a attempt=%attempt%+1
del "%Drive%\%path1%%filename%">nul
if exist temp\%wadname% del temp\%wadname%>nul
goto:DOWNLOADSTART2

:pass
support\sfk echo [Green]This file already exists and has been verified, Skipping download
echo.
if /i "%AdvancedDownload%" NEQ "Y" echo "echo %name%: Valid">>temp\ModMii_Log.bat
goto:NEXT
:nocheckexisting

if /i "%code1%" EQU "MYMAPP" goto:DownloadApp2
if /i "%code1%" EQU "SNEEKAPP" goto:DownloadApp2


:DownloadURL2
if not exist temp\%wadname% start %ModMiimin%/wait support\wget --no-check-certificate %code2%
if exist %dlname% move /y %dlname% temp\%wadname% >nul
support\7za e -aoa temp\%wadname% -o"%Drive%"\%path1% *.%version% -r

::save identifier for bannerbombs
if /i "%code2%" EQU "http://bannerbomb.qoid.us/aads/aad1f_v108.zip" echo Bannerbombv1 >"%Drive%\%path1%Bannerbombv1.txt"
if /i "%code2%" EQU "http://bannerbomb.qoid.us/abds/abd6a_v200.zip" echo Bannerbombv2 >"%Drive%\%path1%Bannerbombv2.txt"

:URLverifyretry
if "%DRIVErestore%"=="" set DRIVErestore=%Drive%
::----check after downloading - if md5 check fails, delete and redownload----
if exist "%Drive%\%path1%%filename%" goto:checkexisting

:missing
if /i "%attempt%" EQU "1" goto:missingretry
echo.
support\sfk echo [Magenta] This file has failed to download properly multiple times, Skipping download.
echo.
set DRIVE=%DRIVErestore%
if /i "%AdvancedDownload%" NEQ "Y" echo "support\sfk echo %name%: [Red]Missing">>temp\ModMii_Log.bat
goto:NEXT

:missingretry
echo.
support\sfk echo [Yellow] The file is missing, retrying download.
echo.
SET /a retry=%retry%+1
SET /a attempt=%attempt%+1
if exist temp\%wadname% del temp\%wadname%>nul
set DRIVE=%DRIVErestore%
goto:DOWNLOADSTART2

:checkexisting
set md5check=
support\sfk md5 -quiet -verify %md5% "%Drive%\%path1%%filename%"
if errorlevel 1 set md5check=fail
IF "%md5check%"=="" set md5check=pass
if /i "%md5check%" NEQ "fail" goto:pass

:fail
if /i "%attempt%" NEQ "1" goto:multiplefail
echo.
support\sfk echo [Yellow] This file already exists but it failed MD5 verification.
support\sfk echo [Yellow] The current version of the file will be deleted and the file will be re-downloaded.
echo.
del "%Drive%\%path1%%filename%">nul
if exist temp\%wadname% del temp\%wadname%>nul
SET /a retry=%retry%+1
SET /a attempt=%attempt%+1
set DRIVE=%DRIVErestore%
goto:DOWNLOADSTART2

:multiplefail
echo.
support\sfk echo [Magenta] This file has failed to download properly multiple times, Skipping download.
echo.
set DRIVE=%DRIVErestore%
set multiplefail=Y
if /i "%AdvancedDownload%" NEQ "Y" echo "support\sfk echo %name%: [Red]Invalid">>temp\ModMii_Log.bat
goto:NEXT

:pass
echo.
support\sfk echo [Green]Download Successful
echo.
set DRIVE=%DRIVErestore%
if /i "%AdvancedDownload%" NEQ "Y" echo "echo %name%: Valid">>temp\ModMii_Log.bat
goto:NEXT





:fullextract

set DRIVErestore=%Drive%

if /i "%wadname%" EQU "WiiBackupManager.zip" goto:doit
if /i "%wadname%" EQU "FAT32_GUI_Formatter.exe" goto:doit
if /i "%filename%" EQU "ShowMiiWads.exe" goto:doit
if /i "%filename%" EQU "CustomizeMii.exe" goto:doit
if /i "%filename%" EQU "WiiGSC.exe" goto:doit
goto:skip
:doit
if /i "%PCSAVE%" EQU "Local" set DRIVE=Program Files

if /i "%PCSAVE%" NEQ "Auto" goto:skip
if /i "%Homedrive%" EQU "%ModMiiDrive%" set DRIVE=Program Files
:skip
if not exist "%Drive%" mkdir "%Drive%"


::no md5 check for dml
if /i "%name%" NEQ "%CurrentDMLRev%" goto:notdios
if exist "temp\DML\%wadname%" (goto:FullExtractZipAlreadyExists) else (goto:nocheckexisting)
:notdios


::----if exist and fails md5 check, delete and redownload----
if not exist "%Drive%\%path1%%filename%" goto:nocheckexisting
set md5check=
support\sfk md5 -quiet -verify %md5% "%Drive%\%path1%%filename%"
if errorlevel 1 set md5check=fail
IF "%md5check%"=="" set md5check=pass
if /i "%md5check%" NEQ "fail" goto:pass

:fail
echo.
support\sfk echo [Yellow] This file already exists but it failed MD5 verification.
support\sfk echo [Yellow] The current version of the file will be deleted and the file will be re-downloaded.
echo.
SET /a retry=%retry%+1
SET /a attempt=%attempt%+1
del "%Drive%\%path1%%filename%">nul
if exist temp\%wadname% del temp\%wadname%>nul
set DRIVE=%DRIVErestore%
goto:DOWNLOADSTART2

:pass
support\sfk echo [Green]This file already exists and has been verified, Skipping download
echo.
set DRIVE=%DRIVErestore%
if /i "%AdvancedDownload%" NEQ "Y" echo "echo %name%: Valid">>temp\ModMii_Log.bat
goto:NEXT
:nocheckexisting


:fullextract2

if exist "temp\%wadname%" goto:FullExtractZipAlreadyExists
if not exist temp\%dlname% start %ModMiimin%/wait support\wget --no-check-certificate %code2%
if exist %dlname% move /y %dlname% "temp\%wadname%">nul

:FullExtractZipAlreadyExists

::extract selected apps differently...


if /i "%path1%" NEQ "apps\MyMenuifyMod\" goto:notmym
::download unrar if missing
if not exist temp\UnRAR.exe echo.
if not exist temp\UnRAR.exe echo Downloading UnRAR
if not exist temp\UnRAR.exe start %ModMiimin%/wait support\wget --no-check-certificate -t 3 "http://files.cybergamer.com.au/richard/FIFA Online 2 Full Client v200/UnRAR.exe"
if exist UnRAR.exe move /y UnRAR.exe temp\UnRAR.exe>nul


temp\unrar.exe x -y "temp\%wadname%" "%Drive%\apps\"
goto:skipnormalextraction
:notmym


if /i "%wadname:~0,20%" EQU "USBLoader(s)-ahbprot" support\7za e -aoa temp\%dlname% -o"%Drive%"/WAD *.%version% -r
if /i "%wadname:~0,20%" EQU "USBLoader(s)-ahbprot" goto:skipnormalextraction

if /i "%wadname%" EQU "indiana-pwns.zip" (support\7za X -aoa temp\%wadname% -o"%Drive%" private -r) & (goto:skipnormalextraction)

if /i "%wadname%" EQU "bathaxx.zip" support\7za X -aoa temp\%wadname% -o"%Drive%" private -r
if /i "%wadname%" EQU "bathaxx.zip" goto:skipnormalextraction

if /i "%wadname%" EQU "return-jodi.zip" support\7za X -aoa temp\%wadname% -o"%Drive%" private -r
if /i "%wadname%" EQU "return-jodi.zip" goto:skipnormalextraction

if /i "%wadname%" EQU "EriHaKawai-USA+PAL.zip" support\7za X -aoa temp\%wadname% -o"%Drive%" private -r
if /i "%wadname%" EQU "EriHaKawai-USA+PAL.zip" goto:skipnormalextraction


if /i "%name%" EQU "Neogamma Backup Disc Loader" (support\7za X -aoa temp\%wadname% -o"%Drive%" apps -r) & (support\7za X -aoa temp\%wadname% -o"%Drive%" NeoGamma -r) & (goto:skipnormalextraction)


if /i "%path1%" EQU "apps\SIP\" (support\7za X -aoa temp\%wadname% -o"%Drive%" apps -r) & (goto:skipnormalextraction)


if /i "%name%" NEQ "WiiFlow Forwarder Channel\dol" goto:skipFLOWF
::if /i "%MENU1%" EQU "S" support\7za e -aoa temp\%dlname% -o"%Drive%"/ *.wad *.dol -r
support\7za X -aoa temp\%dlname% -o"%Drive%" -r
goto:skipnormalextraction
:skipFLOWF


if /i "%name%" NEQ "switch2uneek" goto:skipS2U
if /i "%MENU1%" EQU "S" support\7za e -aoa temp\%wadname% -o"%Drive%/WAD"/ %filename% -r
if /i "%MENU1%" EQU "S" goto:skipnormalextraction
::for when MENU1 not equal to "S"
support\7za x -aoa temp\%dlname% -o"%Drive%" -r -x!switch2uneek(emulators)-4EMUNand-v12-S2RL.wad

if not exist "%DRIVEU%" mkdir "%DRIVEU%"
if not exist "%DRIVEU%"\nandpath.txt echo NOFILE>"%DRIVEU%"\nandpath.txt
if exist "%DRIVEU%"\nandslot.bin goto:skipnormalextraction
echo 00000000>dump.txt
support\sfk filter dump.txt +hextobin "%DRIVEU%"\nandslot.bin
del dump.txt>nul
goto:skipnormalextraction
:skipS2U


if /i "%name%" NEQ "Casper" goto:skipcasper
if not exist "%Drive%\apps\Casper" mkdir "%Drive%\apps\Casper"
support\7za e -aoa "temp\%wadname%" -otemp *.* -r
support\7za e -aoa "temp\%wadname:~0,-3%" -o"%Drive%\apps\Casper" *.* -r
move /y "%Drive%\apps\Casper\casper_0.3.elf" "%Drive%\apps\Casper\boot.elf">nul
copy /y "%Drive%\apps\Casper\boot.elf" "%Drive%\boot.elf">nul

::abstinence wizard only - boot exploit-mmm instead of casper
if /i "%AbstinenceWiz%" NEQ "Y" goto:skipnormalextraction
if /i "%FIRMSTART%" EQU "4.3" goto:skipnormalextraction
if /i "%FIRMSTART%" EQU "4.2" goto:skipnormalextraction
if exist "%Drive%"\apps\MMM\MMMv13.4boot.elf copy /Y "%Drive%"\apps\MMM\MMMv13.4boot.elf "%Drive%"\boot.elf >nul
goto:skipnormalextraction
:skipcasper


if /i "%name%" NEQ "Wilbrand" goto:skipWilbrand


echo Wilbrand by giantpune
echo.
echo MAC:%macaddress%
echo 4.3%REGION%
echo.

::get yesterday's date

set CurDate=

if exist date.vbs del /f /q date.vbs
>date.vbs echo wscript.echo Right(String(2,"0") ^& Month(date), 2) ^& "/" ^& Right(String(2,"0") ^& Day(date), 2) ^& "/" ^& Year(date)
for /f "tokens=*" %%a in ('cscript//nologo date.vbs') do set CurDate=%%a
if exist date.vbs del /f /q date.vbs

Set Day=%CurDate:~3,2%
Set Month=%CurDate:~0,2%
Set Year=%CurDate:~-4%

if /i "%day%" NEQ "01" (set /a day=%day%-1) & (goto:yesterday)

::jan to dec
if /i "%month%" EQU "01" (set /a year=%year%-1) & (set day=31) & (set month=12) & (goto:yesterday)

set /a month=%month%-1

if "%month:~1%"=="" set month=0%month%

if /i "%month%" EQU "01" set day=31
if /i "%month%" EQU "02" set day=28
if /i "%month%" EQU "03" set day=31
if /i "%month%" EQU "04" set day=30
if /i "%month%" EQU "05" set day=31
if /i "%month%" EQU "06" set day=30
if /i "%month%" EQU "07" set day=31
if /i "%month%" EQU "08" set day=31
if /i "%month%" EQU "09" set day=30
if /i "%month%" EQU "10" set day=31
if /i "%month%" EQU "11" set day=30
::if /i "%month%" EQU "12" set day=31

:yesterday

::echo yesterday
::echo mm/dd/yyyy
::echo %Month%/%day%/%year%

if exist temp\temp.txt del temp\temp.txt>nul

temp\wilbrand.exe %macaddress% %Month%/%day%/%year% 4.3%REGION% "%Drive%">temp\temp.txt


findStr /I /C:"Wrote to:" "temp\temp.txt" >nul
IF not ERRORLEVEL 1 (echo "echo %name% - 4.3%REGION% - MAC:%macaddress%: Valid">>temp\ModMii_Log.bat) & (echo.) & (support\sfk echo [Green]Download Successful) & (echo.) & (goto:NEXT)

goto:skipnormalextraction

:skipWilbrand


if /i "%name%" NEQ "nSwitch" goto:skipnSwitch
if not exist "%Drive%\WAD" mkdir "%Drive%\WAD"
copy /y "temp\%wadname%" "%Drive%\WAD\%wadname%" >nul
goto:skipnormalextraction
:skipnSwitch

if /i "%name%" NEQ "Post Loader Forwarder Channel" goto:skipPLC
if not exist "%Drive%\WAD" mkdir "%Drive%\WAD"
copy /y "temp\%wadname%" "%Drive%\WAD\%wadname%" >nul
goto:skipnormalextraction
:skipPLC


if /i "%name%" NEQ "DML" goto:skipdios
::if not exist "temp\DML" mkdir "temp\DML"
if not exist "%Drive%\WAD" mkdir "%Drive%\WAD"
::if exist "temp\%wadname%" move /y "temp\%wadname%" "temp\DML\%wadname%" >nul
copy /y "temp\%wadname%" "%Drive%\WAD\%wadname%" >nul
goto:simpleDMLcheck
:skipdios



if /i "%wadname%" NEQ "WiiBackupManager.zip" goto:notWBM
if exist "%DRIVE%"\WiiBackupManager rd /s /q "%DRIVE%"\WiiBackupManager
mkdir "%DRIVE%"\WiiBackupManager
support\7za x -aoa temp\%wadname% -o"%Drive%\WiiBackupManager" -r


::rename "%Drive%"\%dlname:~6,-4% WiiBackupManager
if /i "%PCSAVE%" EQU "Local" goto:createshortcuts
if /i "%PCSAVE%" NEQ "Auto" goto:skip
if /i "%Homedrive%" EQU "%ModMiiDrive%" (goto:createshortcuts) else (goto:skip)
:createshortcuts
if exist "%homedrive%\Program Files (x86)" (set OSbit=64) else (set OSbit=32)
support\nircmd.exe shortcut "%cd%\%DRIVE%\WiiBackupManager\WiiBackupManager_Win%OSbit%.exe" "~$folder.desktop$" "WiiBackupManager"
support\nircmd.exe shortcut "%cd%\%DRIVE%\WiiBackupManager\WiiBackupManager_Win%OSbit%.exe" "~$folder.programs$\WiiBackupManager" "WiiBackupManager"
:skip
goto:skipnormalextraction
:notWBM


if /i "%filename%" NEQ "FAT32_GUI_Formatter.exe" goto:notF32
if not exist "%DRIVE%"\FAT32_GUI_Formatter mkdir "%DRIVE%"\FAT32_GUI_Formatter
if /i "%Drive%" NEQ "temp" copy /y temp\%wadname% "%Drive%\%path1%FAT32_GUI_Formatter.exe">nul

if /i "%PCSAVE%" EQU "Local" goto:createshortcuts
if /i "%PCSAVE%" NEQ "Auto" goto:skip
if /i "%Homedrive%" EQU "%ModMiiDrive%" (goto:createshortcuts) else (goto:skip)
:createshortcuts
support\nircmd.exe shortcut "%cd%\%DRIVE%\%path1%FAT32_GUI_Formatter.exe" "~$folder.desktop$" "FAT32 GUI Formatter"
support\nircmd.exe shortcut "%cd%\%DRIVE%\%path1%FAT32_GUI_Formatter.exe" "~$folder.programs$\FAT32 GUI Formatter" "FAT32 GUI Formatter"
:skip
goto:skipnormalextraction
:notF32


if /i "%filename%" NEQ "ShowMiiWads.exe" goto:notSMW
if not exist "%DRIVE%"\ShowMiiWads mkdir "%DRIVE%"\ShowMiiWads


::download unrar if missing
if not exist temp\UnRAR.exe echo.
if not exist temp\UnRAR.exe echo Downloading UnRAR
if not exist temp\UnRAR.exe start %ModMiimin%/wait support\wget --no-check-certificate -t 3 "http://files.cybergamer.com.au/richard/FIFA Online 2 Full Client v200/UnRAR.exe"
if exist UnRAR.exe move /y UnRAR.exe temp\UnRAR.exe>nul


temp\unrar.exe x -y "temp\%wadname%" "%Drive%\ShowMiiWads"


if exist support\common-key.bin goto:commonkeyalreadythere

::silently build common-key.bin
echo EBE42A225E8593E448D9C5457381AAF7>support\common-key.txt
support\sfk filter support\common-key.txt +hextobin support\common-key.bin>nul
del support\common-key.txt>nul
:commonkeyalreadythere
copy /y support\common-key.bin "%Drive%\ShowMiiWads\common-key.bin">nul

if /i "%PCSAVE%" EQU "Local" goto:createshortcuts
if /i "%PCSAVE%" NEQ "Auto" goto:skip
if /i "%Homedrive%" EQU "%ModMiiDrive%" (goto:createshortcuts) else (goto:skip)
:createshortcuts
support\nircmd.exe shortcut "%cd%\%DRIVE%\ShowMiiWads\ShowMiiWads.exe" "~$folder.desktop$" "ShowMiiWads"
support\nircmd.exe shortcut "%cd%\%DRIVE%\ShowMiiWads\ShowMiiWads.exe" "~$folder.programs$\ShowMiiWads" "ShowMiiWads"
:skip
goto:skipnormalextraction
:notSMW


if /i "%filename%" NEQ "CustomizeMii.exe" goto:notCM
if not exist "%DRIVE%"\CustomizeMii mkdir "%DRIVE%"\CustomizeMii

::download unrar if missing
if not exist temp\UnRAR.exe echo.
if not exist temp\UnRAR.exe echo Downloading UnRAR
if not exist temp\UnRAR.exe start %ModMiimin%/wait support\wget --no-check-certificate -t 3 "http://files.cybergamer.com.au/richard/FIFA Online 2 Full Client v200/UnRAR.exe"
if exist UnRAR.exe move /y UnRAR.exe temp\UnRAR.exe>nul

temp\unrar.exe x -y "temp\%wadname%" "%Drive%\CustomizeMii"
if /i "%PCSAVE%" EQU "Local" goto:createshortcuts
if /i "%PCSAVE%" NEQ "Auto" goto:skip
if /i "%Homedrive%" EQU "%ModMiiDrive%" (goto:createshortcuts) else (goto:skip)
:createshortcuts
support\nircmd.exe shortcut "%cd%\%DRIVE%\CustomizeMii\CustomizeMii.exe" "~$folder.desktop$" "CustomizeMii"
support\nircmd.exe shortcut "%cd%\%DRIVE%\CustomizeMii\CustomizeMii.exe" "~$folder.programs$\CustomizeMii" "CustomizeMii"
:skip
goto:skipnormalextraction
:notCM


if /i "%filename%" NEQ "WiiGSC.exe" goto:notWiiGSC
if not exist "%DRIVE%"\WiiGSC mkdir "%DRIVE%"\WiiGSC
support\7za x -aoa temp\%wadname% -o"%Drive%\WiiGSC" -r
if /i "%PCSAVE%" EQU "Local" goto:createshortcuts
if /i "%PCSAVE%" NEQ "Auto" goto:skip
if /i "%Homedrive%" EQU "%ModMiiDrive%" (goto:createshortcuts) else (goto:skip)
:createshortcuts
support\nircmd.exe shortcut "%cd%\%DRIVE%\WiiGSC\WiiGSC.exe" "~$folder.desktop$" "WiiGSC"
support\nircmd.exe shortcut "%cd%\%DRIVE%\WiiGSC\WiiGSC.exe" "~$folder.programs$\Wiidewii" "WiiGSC"
support\nircmd.exe shortcut "%cd%\%DRIVE%\WiiGSC\CrazyInstaller.exe" "~$folder.programs$\Wiidewii" "CrazyInstaller"
support\nircmd.exe shortcut "%cd%\%DRIVE%\WiiGSC\KeyStego.exe" "~$folder.programs$\Wiidewii" "KeyStego"

:skip
goto:skipnormalextraction
:notWiiGSC



if /i "%path1%" NEQ "apps\usbloader_cfg\" goto:skipusbloadercfg

::rename existing usb-loader folder if applicable
set COUNT9=0
:renameusbloader
if not exist "%Drive%\usb-loader" goto:extractusbloader
SET /a COUNT9=%COUNT9%+1
if exist "%Drive%\usb-loader%COUNT9%" goto:renameusbloader
move "%Drive%\usb-loader" "%Drive%\usb-loader%COUNT9%">nul

:extractusbloader
support\7za x -aoa temp\%wadname% -o"%Drive%"

::------extra for USB-Loader Setup Guide-------
if /i "%FORMAT%" EQU "NONE" goto:skip
::FAT or NTFS partition will only be valid if the \wbfs folder exists
if not exist "%Drive%\wbfs" mkdir "%Drive%\wbfs"
if not exist "%DRIVE%"\usb-loader\music mkdir "%DRIVE%"\usb-loader\music

echo Save music Here>"%DRIVE%\usb-loader\music\Save MP3s Here To Play at USB-Loader Menu"
if /i "%USBCONFIG%" EQU "USB" echo music = usb:/usb-loader/music>>"%DRIVE%\usb-loader\config.txt"
if /i "%USBCONFIG%" NEQ "USB" echo music = sd:/usb-loader/music>>"%DRIVE%\usb-loader\config.txt"

echo unlock_password = AAAA>>"%DRIVE%\usb-loader\config.txt"
echo disable_remove = BLAHBLAH>>"%DRIVE%\usb-loader\config.txt"
echo disable_format = BLAHBLAH>>"%DRIVE%\usb-loader\config.txt"
echo admin_unlock = BLAHBLAH>>"%DRIVE%\usb-loader\config.txt"

support\sfk filter -write -yes "%DRIVE%\usb-loader\config.txt" -rep _BLAHBLAH_1_> nul

:skip

if /i "%USBCONFIG%" NEQ "USB" goto:skip
echo covers_path = usb:/usb-loader/covers>>"%DRIVE%\usb-loader\config.txt"
echo covers_path_2d = usb:/usb-loader/covers/2d>>"%DRIVE%\usb-loader\config.txt"
echo covers_path_3d = usb:/usb-loader/covers/3d>>"%DRIVE%\usb-loader\config.txt"
echo covers_path_disc = usb:/usb-loader/covers/disc>>"%DRIVE%\usb-loader\config.txt"
echo covers_path_full = usb:/usb-loader/covers/full>>"%DRIVE%\usb-loader\config.txt"

if /i "%FORMAT%" EQU "2" support\sfk filter -write -yes "%DRIVE%\usb-loader\config.txt" -rep _usb:_ntfs:_> nul
:skip


goto:skipnormalextraction
:skipusbloadercfg

if /i "%wadname%" EQU "twilight_hack_v0.1_beta1.zip" support\7za X -aoa temp\%wadname% -o"%Drive%" private -r
if /i "%wadname%" EQU "twilight_hack_v0.1_beta1.zip" goto:skipnormalextraction
if /i "%path1%" EQU "apps\homebrew_browser\" support\7za X -aoa temp\%wadname% -o"%Drive%"\apps homebrew_browser -r
if /i "%path1%" EQU "apps\homebrew_browser\" goto:skipnormalextraction

if /i "%wadname%" EQU "YU-GI-OWNED-ALL.zip" support\7za X -aoa temp\%wadname% -o"%Drive%" private -r
if /i "%wadname%" EQU "YU-GI-OWNED-ALL.zip" goto:skipnormalextraction


if /i "%path1%" EQU "apps\DOP-Mii\" support\7za e -aoa temp\%wadname% -o"%Drive%"/%path1% -x!*.cfg
if /i "%path1%" EQU "apps\DOP-Mii\" rd /s /q "%Drive%\%path1%DOP-Mii"
if /i "%path1%" EQU "apps\DOP-Mii\" rd /s /q "%Drive%\%path1%DOP-Mii v13"
if /i "%path1%" EQU "apps\DOP-Mii\" rd /s /q "%Drive%\%path1%config"
if /i "%path1%" EQU "apps\DOP-Mii\" rd /s /q "%Drive%\%path1%apps"
if /i "%path1%" EQU "apps\DOP-Mii\" mkdir "%DRIVE%\config"
if /i "%path1%" EQU "apps\DOP-Mii\" move /y "%Drive%\%path1%\DOP-Mii.cfg" "%Drive%\config\DOP-Mii.cfg" >nul
if /i "%path1%" EQU "apps\DOP-Mii\" goto:skipnormalextraction

support\7za x -aoa temp\%wadname% -o"%Drive%" -x!README
:skipnormalextraction
goto:URLverifyretry
::DONE (will retry if necessary)



::---------------CustomDL--------------------------
:CUSTOMDL
echo     Note that custom downloads are not verified, and are not necessarily safe.
echo     Make sure you know what you're doing! Use at your own risk!
echo.


if /i "%DEC%" EQU "SM" set HEX=00000002
if /i "%DEC%" EQU "MIOS" set HEX=00000101
if /i "%DEC%" EQU "SM" goto:skiphexcalc
if /i "%DEC%" EQU "MIOS" goto:skiphexcalc

support\sfk hex %DEC% -digits=8 >hex.txt


::Loop through the the following once for EACH line in whatever.txt
for /F "tokens=*" %%A in (hex.txt) do call :processhexx %%A
goto:skiphexcalc

:processhexx
::this is repeated for each line of the txt.file
::"%*" (no quotes) is the variable for each line as it passes through the loop
set hex=%*
goto:EOF


:skiphexcalc

if exist hex.txt del hex.txt>nul

if not exist "%DRIVE%"\WAD mkdir "%DRIVE%"\WAD

echo     If you encounter long periods of inactivity, type "C" while holding "Ctrl",
echo     then type "N", then "Enter" (ie. Ctrl+C = N = Enter)
echo.
support\nusd 00000001%HEX% "%VER%"


::if not exist 00000001%HEX%\00000001%HEX%.wad goto:missing


if /i "%DEC%" EQU "SM" goto:SYSMENU
if /i "%DEC%" EQU "MIOS" goto:MIOS2

::IOS

if /i "%ROOTSAVE%" EQU "OFF" (set wadfolder=WAD\) else (set wadfolder=)

if exist support\00000001%HEX%\00000001%HEX%.wad move /Y support\00000001%HEX%\00000001%HEX%.wad "%Drive%"\%wadfolder%IOS%DEC%v%VERFINAL%%patchname%%slotname%%versionname%.wad>nul

if /i "%verfinal%" EQU "NEW" goto:option1notNUS

if /i "%OPTION1%" EQU "ON" goto:option1on
if /i "%OPTION1%" EQU "ALL" (goto:option1on) else (goto:option1noton)
:option1on
if not exist "%Drive%"\00000001\%HEX%\v%verfinal% mkdir "%Drive%"\00000001\%HEX%\v%verfinal%
if exist support\00000001%HEX% copy /Y support\00000001%HEX% "%Drive%"\00000001\%HEX%\v%verfinal% >nul
:option1noton

if /i "%OPTION1%" EQU "NUS" goto:option1NUS
if /i "%OPTION1%" EQU "ALL" (goto:option1NUS) else (goto:option1notNUS)
:option1NUS
if not exist "%Drive%"\NUS\00000001%HEX%v%verfinal% mkdir "%Drive%"\NUS\00000001%HEX%v%verfinal%
copy /y support\00000001%HEX% "%Drive%"\NUS\00000001%HEX%v%verfinal% >nul
:option1notNUS

if exist support\00000001%HEX% rd /s /q support\00000001%HEX%

if /i "IOS%DEC%v%VERFINAL%%patchname%%slotname%%versionname%.wad" EQU "IOS%DEC%v%VERFINAL%.wad" goto:nopatching

echo.
cd support
if /i "%DRIVE:~1,1%" EQU ":" (set DRIVEadj=%DRIVE%) else (set DRIVEadj=..\%DRIVE%)
if exist "%DRIVEadj%"\%wadfolder%IOS%DEC%v%VERFINAL%%patchname%%slotname%%versionname%.wad (patchios "%DRIVEadj%"\%wadfolder%IOS%DEC%v%VERFINAL%%patchname%%slotname%%versionname%.wad%PATCHCODE%%slotcode%%versioncode%) & (echo.) & (echo Note: Patches are not always successful, read the PatchIOS log above for details)
cd..
:nopatching

if exist "%DRIVE%"\%wadfolder%IOS%DEC%v%VERFINAL%%patchname%%slotname%%versionname%.wad (goto:there) else (goto:missing)



:SYSMENU
if exist support\00000001%HEX%\00000001%HEX%.wad move /Y support\00000001%HEX%\00000001%HEX%.wad "%Drive%"\%wadfolder%SystemMenu-NUS-v%VERFINAL%.wad>nul

if /i "%verfinal%" EQU "NEW" goto:option1notNUS

if /i "%OPTION1%" EQU "ON" goto:option1on
if /i "%OPTION1%" EQU "ALL" (goto:option1on) else (goto:option1noton)
:option1on
if not exist "%Drive%"\00000001\%HEX%\v%verfinal% mkdir "%Drive%"\00000001\%HEX%\v%verfinal%
if exist support\00000001%HEX% copy /Y support\00000001%HEX% "%Drive%"\00000001\%HEX%\v%verfinal% >nul
:option1noton

if /i "%OPTION1%" EQU "NUS" goto:option1NUS
if /i "%OPTION1%" EQU "ALL" (goto:option1NUS) else (goto:option1notNUS)
:option1NUS
if not exist "%Drive%"\NUS\00000001%HEX%v%verfinal% mkdir "%Drive%"\NUS\00000001%HEX%v%verfinal%
copy /y temp\%code1%\%code2%\v%version% "%Drive%"\NUS\00000001%HEX%v%verfinal% >nul
:option1notNUS

if exist support\00000001%HEX% rd /s /q support\00000001%HEX%

if exist "%Drive%"\%wadfolder%SystemMenu-NUS-v%VERFINAL%.wad (goto:there) else (goto:missing)



:MIOS2
if /i "%ROOTSAVE%" EQU "OFF" (set wadfolder=WAD\) else (set wadfolder=)
if exist support\00000001%HEX%\00000001%HEX%.wad move /Y support\00000001%HEX%\00000001%HEX%.wad "%Drive%"\%wadfolder%RVL-mios-v%VERFINAL%.wad>nul

if /i "%verfinal%" EQU "NEW" goto:option1notNUS

if /i "%OPTION1%" EQU "ON" goto:option1on
if /i "%OPTION1%" EQU "ALL" (goto:option1on) else (goto:option1noton)
:option1on
if not exist "%Drive%"\00000001\%HEX%\v%verfinal% mkdir "%Drive%"\00000001\%HEX%\v%verfinal%
if exist support\00000001%HEX% copy /Y support\00000001%HEX% "%Drive%"\00000001\%HEX%\v%verfinal% >nul
:option1noton

if /i "%OPTION1%" EQU "NUS" goto:option1NUS
if /i "%OPTION1%" EQU "ALL" (goto:option1NUS) else (goto:option1notNUS)
:option1NUS
if not exist "%Drive%"\NUS\00000001%HEX%v%verfinal% mkdir "%Drive%"\NUS\00000001%HEX%v%verfinal%
copy /y temp\%code1%\%code2%\v%version% "%Drive%"\NUS\00000001%HEX%v%verfinal% >nul
:option1notNUS

if exist support\00000001%HEX% rd /s /q support\00000001%HEX%

if exist "%Drive%"\%wadfolder%RVL-mios-v%VERFINAL%.wad (goto:there) else (goto:missing)


::----check after downloading - if md5 check fails, delete and redownload----

:missing
if /i "%attempt%" EQU "1" goto:missingretry
echo.
support\sfk echo [Magenta] This file has failed to download properly multiple times, Skipping download.
support\sfk echo -spat \x20 \x20 \x20 [Magenta] Most likely reason is that the file does not exist.
support\sfk echo -spat \x20 \x20 \x20 [Magenta] Double check your custom values.
echo.

if /i "%DEC%" EQU "SM" (echo "support\sfk echo SystemMenu-NUS-v%VERFINAL%.wad: [Red]Missing">>temp\ModMii_Log.bat) & (goto:NEXT)
if /i "%DEC%" EQU "MIOS" (echo "support\sfk echo %RVL-mios-v%VERFINAL%.wad: [Red]Missing">>temp\ModMii_Log.bat) & (goto:NEXT)
echo "support\sfk echo IOS%DEC%v%VERFINAL%%patchname%%slotname%%versionname%.wad: [Red]Missing">>temp\ModMii_Log.bat
goto:NEXT

:missingretry
echo.
support\sfk echo [Yellow] The file is missing, retrying download.
echo.
SET /a retry=%retry%+1
SET /a attempt=%attempt%+1
::if exist temp\%wadname% del temp\%wadname%>nul
goto:DOWNLOADSTART2

:there
echo.
support\sfk echo [Green]Advanced Download Successful

if /i "%DEC%" EQU "SM" (echo "echo SystemMenu-NUS-v%VERFINAL%.wad: Found">>temp\ModMii_Log.bat) & (goto:NEXT)
if /i "%DEC%" EQU "MIOS" (echo "echo RVL-mios-v%VERFINAL%.wad: Found">>temp\ModMii_Log.bat) & (goto:NEXT)
echo "echo IOS%DEC%v%VERFINAL%%patchname%%slotname%%versionname%.wad: Found">>temp\ModMii_Log.bat
goto:NEXT



::---------------HackMii Installer support\wget --no-check-certificate Download CODE-----------------------
:wget
::----if exist and fails md5 check, delete and redownload----
if not exist "%Drive%"\apps\HackMii_Installer\boot.elf goto:nocheckexisting
set md5check=
support\sfk md5 -quiet -verify %md5% "%Drive%"\apps\HackMii_Installer\boot.elf
if errorlevel 1 set md5check=fail
IF "%md5check%"=="" set md5check=pass
if /i "%md5check%" NEQ "fail" goto:pass

:fail
echo.
support\sfk echo [Yellow] This file already exists but it failed MD5 verification.
support\sfk echo [Yellow] The current version of the file will be deleted and the file will be re-downloaded.
echo.
del "%Drive%"\apps\HackMii_Installer\boot.elf>nul
SET /a retry=%retry%+1
SET /a attempt=%attempt%+1
if exist temp\%wadname% del temp\%wadname%>nul
goto:DOWNLOADSTART2

:pass
support\sfk echo [Green]This file already exists and has been verified, Skipping download
echo.
COPY /Y "%Drive%"\apps\HackMii_Installer\boot.elf "%Drive%"\boot.elf> nul
COPY /Y "%Drive%"\apps\HackMii_Installer\bootmini.elf "%Drive%"\bootmini.elf> nul
if /i "%AdvancedDownload%" NEQ "Y" echo "echo %name%: Valid">>temp\ModMii_Log.bat
goto:alreadyhavehackmii
:nocheckexisting



if not exist temp\%wadname% start %ModMiimin%/wait support\wget --no-check-certificate -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --reject "*.html" --reject "%2A" --reject "get.php@file=hackmii_installer_v1.0*" %code2%*

if not exist temp\%wadname% move /y get.*.* temp\%wadname%>nul
if not exist "%Drive%"\apps\HackMii_Installer mkdir "%Drive%"\apps\HackMii_Installer
support\7za e -aoa temp\%wadname% -o"%Drive%"\apps\HackMii_Installer *.%version% *.txt -r
support\7za e -aoa temp\%wadname% -o"%Drive%" *.%version% -r



::----check after downloading - if md5 check fails, delete and redownload----
if exist "%Drive%"\apps\HackMii_Installer\boot.elf goto:checkexisting

:missing
if /i "%attempt%" EQU "1" goto:missingretry
echo.
support\sfk echo [Magenta] This file has failed to download properly multiple times, Skipping download.
echo.
if /i "%AdvancedDownload%" NEQ "Y" echo "support\sfk echo %name%: [Red]Missing">>temp\ModMii_Log.bat
goto:NEXT

:missingretry
echo.
support\sfk echo [Yellow] The file is missing, retrying download.
echo.
SET /a retry=%retry%+1
SET /a attempt=%attempt%+1
if exist temp\%wadname% del temp\%wadname%>nul
goto:DOWNLOADSTART2

:checkexisting
set md5check=
support\sfk md5 -quiet -verify %md5% "%Drive%"\apps\HackMii_Installer\boot.elf
if errorlevel 1 set md5check=fail
IF "%md5check%"=="" set md5check=pass
if /i "%md5check%" NEQ "fail" goto:pass

:fail
if /i "%attempt%" NEQ "1" goto:multiplefail
echo.
support\sfk echo [Yellow] This file already exists but it failed MD5 verification.
support\sfk echo [Yellow] The current version of the file will be deleted and the file will be re-downloaded.
echo.
del "%Drive%"\apps\HackMii_Installer\boot.elf>nul
if exist temp\%wadname% del temp\%wadname%>nul
SET /a retry=%retry%+1
SET /a attempt=%attempt%+1
goto:DOWNLOADSTART2

:multiplefail
echo.
support\sfk echo [Magenta] This file has failed to download properly multiple times, Skipping download.
echo.
set multiplefail=Y
if /i "%AdvancedDownload%" NEQ "Y" echo "support\sfk echo %name%: [Red]Invalid">>temp\ModMii_Log.bat
goto:NEXT

:pass
echo.
support\sfk echo [Green]Download Successful
echo.
if /i "%AdvancedDownload%" NEQ "Y" echo "echo %name%: Valid">>temp\ModMii_Log.bat
::goto:NEXT


:alreadyhavehackmii
if /i "%MENU1%" EQU "H" goto:RenameBootToHackMii
if /i "%virgin%" EQU "N" goto:next
if /i "%REGION%" EQU "K" goto:RenameBootToHackMii
goto:next


::-----Bannerbomb MMM instead of HackMii installer------
:RenameBootToHackMii
if exist "%Drive%"\apps\MMM\MMMv13.4boot.elf copy /Y "%Drive%"\apps\MMM\MMMv13.4boot.elf "%Drive%"\boot.elf >nul
::if exist "%Drive%"\apps\WiiMod\boot.elf copy /Y "%Drive%"\apps\WiiMod\boot.elf "%Drive%"\boot.elf >nul
goto:next


::----------------------FORWARDER------------------
:FORWARDER

if not exist "%Drive%\DOLS" mkdir "%Drive%\DOLS"

if /i "%FORWARDERTYPE:~0,1%" EQU "1" copy /y support\DOLS\SDUSBFORWARDER_v12.dol "%Drive%\DOLS\%wadname%.dol">nul
if /i "%FORWARDERTYPE:~0,1%" EQU "2" copy /y support\DOLS\INTERNETFORWARDER.dol "%Drive%\DOLS\%wadname%.dol">nul
if /i "%FORWARDERTYPE:~0,1%" EQU "3" copy /y support\DOLS\CHANNELFORWARDER.dol "%Drive%\DOLS\%wadname%.dol">nul

::%s:/ = 0x25,0x73,0x3a,0x2f

if "%path-1%"=="" goto:nopath-1
echo Converting %path-1% to hex
set var=%path-1%
call support\Ascii2hex.bat
setlocal DISABLEDELAYEDEXPANSION
support\sfk filter -quiet "temphex.txt" -rep _,_,0x_ -write -yes
set /p hex= <temphex.txt
del /f /q temphex.txt
set hex=0x%hex:~0,-4%
echo Patching %wadname%.dol with %path-1%
support\hexalter.exe "%Drive%\DOLS\%wadname%.dol" 0x77426=0x25,0x73,0x3a,0x2f,%hex%
echo.
:nopath-1

if "%path-2%"=="" goto:nopath-2
echo Converting %path-2% to hex
set var=%path-2%
call support\Ascii2hex.bat
setlocal DISABLEDELAYEDEXPANSION
support\sfk filter -quiet "temphex.txt" -rep _,_,0x_ -write -yes
set /p hex= <temphex.txt
del /f /q temphex.txt
set hex=0x%hex:~0,-4%
echo Patching %wadname%.dol with %path-2%
support\hexalter.exe "%Drive%\DOLS\%wadname%.dol" 0x7752d=0x25,0x73,0x3a,0x2f,%hex%
echo.
:nopath-2

if "%path-3%"=="" goto:nopath-3
echo Converting %path-3% to hex
set var=%path-3%
call support\Ascii2hex.bat
setlocal DISABLEDELAYEDEXPANSION
support\sfk filter -quiet "temphex.txt" -rep _,_,0x_ -write -yes
set /p hex= <temphex.txt
del /f /q temphex.txt
set hex=0x%hex:~0,-4%
echo Patching %wadname%.dol with %path-3%
support\hexalter.exe "%Drive%\DOLS\%wadname%.dol" 0x77631=0x25,0x73,0x3a,0x2f,%hex%
echo.
:nopath-3

if "%path-4%"=="" goto:nopath-4
echo Converting %path-4% to hex
set var=%path-4%
call support\Ascii2hex.bat
setlocal DISABLEDELAYEDEXPANSION
support\sfk filter -quiet "temphex.txt" -rep _,_,0x_ -write -yes
set /p hex= <temphex.txt
del /f /q temphex.txt
set hex=0x%hex:~0,-4%
echo Patching %wadname%.dol with %path-4%
support\hexalter.exe "%Drive%\DOLS\%wadname%.dol" 0x77735=0x25,0x73,0x3a,0x2f,%hex%
echo.
:nopath-4

if "%path-5%"=="" goto:nopath-5
echo Converting %path-5% to hex
set var=%path-5%
call support\Ascii2hex.bat
setlocal DISABLEDELAYEDEXPANSION
support\sfk filter -quiet "temphex.txt" -rep _,_,0x_ -write -yes
set /p hex= <temphex.txt
del /f /q temphex.txt
set hex=0x%hex:~0,-4%
echo Patching %wadname%.dol with %path-5%
support\hexalter.exe "%Drive%\DOLS\%wadname%.dol" 0x77839=0x25,0x73,0x3a,0x2f,%hex%
echo.
:nopath-5

if "%path-6%"=="" goto:nopath-6
echo Converting %path-6% to hex
set var=%path-6%
call support\Ascii2hex.bat
setlocal DISABLEDELAYEDEXPANSION
support\sfk filter -quiet "temphex.txt" -rep _,_,0x_ -write -yes
set /p hex= <temphex.txt
del /f /q temphex.txt
set hex=0x%hex:~0,-4%
echo Patching %wadname%.dol with %path-6%
support\hexalter.exe "%Drive%\DOLS\%wadname%.dol" 0x7793d=0x25,0x73,0x3a,0x2f,%hex%
echo.
:nopath-6

if "%path-7%"=="" goto:nopath-7
echo Converting %path-7% to hex
set var=%path-7%
call support\Ascii2hex.bat
setlocal DISABLEDELAYEDEXPANSION
support\sfk filter -quiet "temphex.txt" -rep _,_,0x_ -write -yes
set /p hex= <temphex.txt
del /f /q temphex.txt
set hex=0x%hex:~0,-4%
echo Patching %wadname%.dol with %path-7%
support\hexalter.exe "%Drive%\DOLS\%wadname%.dol" 0x77a41=0x25,0x73,0x3a,0x2f,%hex%
echo.
:nopath-7

if "%path-8%"=="" goto:nopath-8
echo Converting %path-8% to hex
set var=%path-8%
call support\Ascii2hex.bat
setlocal DISABLEDELAYEDEXPANSION
support\sfk filter -quiet "temphex.txt" -rep _,_,0x_ -write -yes
set /p hex= <temphex.txt
del /f /q temphex.txt
set hex=0x%hex:~0,-4%
echo Patching %wadname%.dol with %path-8%
support\hexalter.exe "%Drive%\DOLS\%wadname%.dol" 0x77b45=0x25,0x73,0x3a,0x2f,%hex%
echo.
:nopath-8

if "%path-9%"=="" goto:nopath-9
echo Converting %path-9% to hex
set var=%path-9%
call support\Ascii2hex.bat
setlocal DISABLEDELAYEDEXPANSION
support\sfk filter -quiet "temphex.txt" -rep _,_,0x_ -write -yes
set /p hex= <temphex.txt
del /f /q temphex.txt
set hex=0x%hex:~0,-4%
echo Patching %wadname%.dol with %path-9%
support\hexalter.exe "%Drive%\DOLS\%wadname%.dol" 0x77c49=0x25,0x73,0x3a,0x2f,%hex%
echo.
:nopath-9

if "%path-10%"=="" goto:nopath-10
echo Converting %path-10% to hex
set var=%path-10%
call support\Ascii2hex.bat
setlocal DISABLEDELAYEDEXPANSION
support\sfk filter -quiet "temphex.txt" -rep _,_,0x_ -write -yes
set /p hex= <temphex.txt
del /f /q temphex.txt
set hex=0x%hex:~0,-4%
echo Patching %wadname%.dol with %path-10%
support\hexalter.exe "%Drive%\DOLS\%wadname%.dol" 0x77d4d=0x25,0x73,0x3a,0x2f,%hex%
echo.
:nopath-10

if "%URLPATH%"=="" goto:noURLPATH
echo Converting %URLPATH% to hex
set var=%URLPATH%
call support\Ascii2hex.bat
setlocal DISABLEDELAYEDEXPANSION
support\sfk filter -quiet "temphex.txt" -rep _,_,0x_ -write -yes
set /p hex= <temphex.txt
del /f /q temphex.txt
set hex=0x%hex:~0,-4%
echo Patching %wadname%.dol with %URLPATH%
support\hexalter.exe "%Drive%\DOLS\%wadname%.dol" 0x1f3a4=%hex%
echo.
:noURLPATH


if "%FORWARDERTITLEID%"=="" goto:noFORWARDERTITLEID

::if more than 4 chars it's already hex and skip conversion
if not "%FORWARDERTITLEID:~4%"=="" (echo %FORWARDERTITLEID%, >temphex.txt) & (goto:quickskip)

echo Converting %FORWARDERTITLEID% to hex
set var=%FORWARDERTITLEID%
call support\Ascii2hex.bat
setlocal DISABLEDELAYEDEXPANSION
:quickskip


support\sfk filter -quiet "temphex.txt" -rep _,_,0x_ -write -yes
set /p hex= <temphex.txt
del /f /q temphex.txt
set hex=0x%hex:~0,-4%
echo Patching %wadname%.dol with %FORWARDERTITLEID%
support\hexalter.exe "%Drive%\DOLS\%wadname%.dol" 0x2ee6=%hex:~0,9%
support\hexalter.exe "%Drive%\DOLS\%wadname%.dol" 0x2eee=%hex:~10%

if "%hex%"=="0x48,0x41,0x41,0x41" set bigt=02
if "%hex%"=="0x48,0x41,0x42,0x41" set bigt=02
if "%hex%"=="0x48,0x41,0x43,0x41" set bigt=02
if "%hex%"=="0x48,0x41,0x46,0x41" set bigt=02
if "%hex%"=="0x48,0x41,0x46,0x45" set bigt=02
if "%hex%"=="0x48,0x41,0x46,0x4A" set bigt=02
if "%hex%"=="0x48,0x41,0x46,0x50" set bigt=02
if "%hex%"=="0x48,0x41,0x47,0x41" set bigt=02
if "%hex%"=="0x48,0x41,0x47,0x45" set bigt=02
if "%hex%"=="0x48,0x41,0x47,0x4A" set bigt=02
if "%hex%"=="0x48,0x41,0x47,0x50" set bigt=02
if "%hex%"=="0x48,0x41,0x59,0x41" set bigt=02

if /i "%bigt%" NEQ "1" (echo.) & (echo Patching Channel Type: 000100%bigt%) & (support\hexalter.exe "%Drive%\DOLS\%wadname%.dol" 0x2eeb=0x0%bigt%)
echo.
:noFORWARDERTITLEID




if exist "%Drive%\DOLS\%wadname%.dol" (goto:there) else (goto:missing)

::----check after downloading----

:missing
if /i "%attempt%" EQU "1" goto:missingretry
echo.
support\sfk echo [Magenta] This file has failed to download properly multiple times, Skipping download.
echo.
if /i "%FORWARDERDOLorISO%" EQU "1" echo "support\sfk echo %FORWARDERNAME% DOL: [Red]Missing">>temp\ModMii_Log.bat
if /i "%FORWARDERDOLorISO%" EQU "2" echo "support\sfk echo %FORWARDERNAME% ISO: [Red]Missing">>temp\ModMii_Log.bat
if /i "%FORWARDERDOLorISO%" EQU "3" echo "support\sfk echo %FORWARDERNAME% DOL and ISO: [Red]Missing">>temp\ModMii_Log.bat
goto:NEXT

:missingretry
echo.
support\sfk echo [Yellow] The file is missing, retrying download.
echo.
SET /a retry=%retry%+1
SET /a attempt=%attempt%+1
::if exist temp\%wadname% del temp\%wadname%
goto:DOWNLOADSTART2

:there
if /i "%FORWARDERDOLorISO%" NEQ "1" goto:FORWARDERISO
echo "echo %FORWARDERNAME% DOL: Found">>temp\ModMii_Log.bat
echo.
support\sfk echo [Green]Advanced Download Successful
goto:NEXT






:FORWARDERISO

echo.
echo Creating Forwarder ISO...
echo.

if /i "%FORWARDERDOLorISO%" EQU "2" move /y "%Drive%\DOLS\%FORWARDERNAME%.dol" "support\disc-template\sys\main.dol">nul
if /i "%FORWARDERDOLorISO%" NEQ "2" copy /v /y "%Drive%\DOLS\%FORWARDERNAME%.dol" "support\disc-template\sys\main.dol">nul

::make WBFS folder for forwarder ISO
if not exist "%Drive%\WBFS\%FORWARDERNAME% [%discid%]" mkdir "%Drive%\WBFS\%FORWARDERNAME% [%discid%]"
if exist "%Drive%\WBFS\%FORWARDERNAME% [%discid%]\%discid%.iso" del "%Drive%\WBFS\%FORWARDERNAME% [%discid%]\%discid%.iso" >nul

Support\wit copy -s ./Support/disc-template/ -d "%Drive%/WBFS/%FORWARDERNAME% [%discid%]/%discid%.iso" --id %discid% --name "%FORWARDERNAME%" -q -C

del "support\disc-template\sys\main.dol">nul


if exist "%Drive%\WBFS\%FORWARDERNAME% [%discid%]\%discid%.iso" echo Forwarder ISO Created

if exist "%Drive%\WBFS\%FORWARDERNAME% [%discid%]\%discid%.iso" (goto:there) else (goto:missing)

::----check after downloading----

:missing
if /i "%attempt%" EQU "1" goto:missingretry
echo.
support\sfk echo [Magenta] This file has failed to download properly multiple times, Skipping download.
echo.
if /i "%FORWARDERDOLorISO%" EQU "2" echo "support\sfk echo %FORWARDERNAME% ISO: [Red]Missing">>temp\ModMii_Log.bat
if /i "%FORWARDERDOLorISO%" EQU "3" echo "support\sfk echo %FORWARDERNAME% DOL: FOUND - %FORWARDERNAME% ISO: [Red]Missing">>temp\ModMii_Log.bat
goto:NEXT

:missingretry
echo.
support\sfk echo [Yellow] The file is missing, retrying download.
echo.
SET /a retry=%retry%+1
SET /a attempt=%attempt%+1
goto:DOWNLOADSTART2

:there
if /i "%FORWARDERDOLorISO%" EQU "2" echo "echo %FORWARDERNAME% ISO: Found">>temp\ModMii_Log.bat
if /i "%FORWARDERDOLorISO%" EQU "3" echo "echo %FORWARDERNAME% DOL and ISO: Found">>temp\ModMii_Log.bat
echo.
support\sfk echo [Green]Advanced Download Successful
goto:NEXT



::----------------MetaChecker----------------
:MetaChecker
if not exist "%DRIVE%\%path1%meta.xml" (echo "support\sfk echo %name%: [Red]Missing">>temp\ModMii_Log.bat) & (goto:NEXT)
if not exist "%DRIVE%\%path1%boot.dol" (echo "support\sfk echo %name%: [Red]Missing">>temp\ModMii_Log.bat) & (goto:NEXT)
support\sfk filter -quiet "%DRIVE%\%path1%meta.xml" -+"/version" -rep _"*<version>"_"set currentcode="_ -rep _"</version*"__ >currentcode.bat
call currentcode.bat
del currentcode.bat>nul
echo "support\sfk echo %name%: [Red]Not Updated[def]: Found Version %currentcode%">>temp\ModMii_Log.bat
goto:NEXT


::----------------------NEXT----------------------
:NEXT

::-----ROOT SAVE OPTION for IOSs (does not apply to wizard)-----
if /i "%MENU1%" EQU "W" goto:miniskip
if /i "%MENU1%" EQU "RC" goto:miniskip
if /i "%MENU1%" EQU "SU" goto:miniskip
if /i "%MENU1%" EQU "H" goto:miniskip
if /i "%category%" EQU "ios" goto:noskip
if /i "%category%" EQU "patchios" (goto:noskip) else (goto:miniskip)
:noskip
if "%wadname:~-4%" NEQ ".wad" (set movename="%wadname%.wad") else (set movename="%wadname%")
if /i "%ROOTSAVE%" EQU "ON" move /Y "%Drive%"\WAD\%movename% "%DRIVE%"\%movename% >nul
:miniskip


::-----------Exceptions for DL Wizard and syscheck updater----------
if /i "%name%" NEQ "IOS36" goto:skipwizardexceptions
if /i "%MENU1%" EQU "W" goto:exception
if /i "%MENU1%" NEQ "SU" goto:skipwizardexceptions
:exception
if "%wadname:~-4%" NEQ ".wad" (set movename="%wadname%.wad") else (set movename="%wadname%")
move /Y "%Drive%"\WAD\%movename% "%DRIVE%"\%movename% >nul
:skipwizardexceptions
::----------------------------


if /i "%category%" EQU "userdefined" goto:quickskip
if /i "%category%" EQU "FORWARDER" goto:quickskip
if /i "%AdvancedDownload%" EQU "Y" goto:customcopyandpatch
:quickskip
support\sfk filter -quiet "temp\DLgotos.txt" -le!"%CurrentDLNAME%" -write -yes

goto:DLSETTINGS3






::-----------------------------------------cUSTOM COPY AND PATCH (only for advanced downloads)--------------------------------
:customcopyandpatch

if /i "%loadorgo%" EQU "load" goto:ADVPAGE2

if "%wadname:~-4%" EQU ".wad" set wadname=%wadname:~0,-4%

::move from WAD folder
if "%alreadyexists%" EQU "yes" goto:makeacopy
if exist "%DRIVE%"\WAD\%wadname%.wad move /Y "%DRIVE%"\WAD\%wadname%.wad "%DRIVE%"\WAD\%wadnameless%%patchname%%slotname%%versionname%.wad>nul
goto:nocopy

:makeacopy
if exist "%DRIVE%"\WAD\%wadname%.wad copy /Y "%DRIVE%"\WAD\%wadname%.wad "%DRIVE%"\WAD\%wadnameless%%patchname%%slotname%%versionname%.wad>nul
:nocopy

if exist "%DRIVE%"\WAD\%wadnameless%%patchname%%slotname%%versionname%.wad goto:copyisthere

if not exist "%DRIVE%"\WAD mkdir "%DRIVE%"\WAD >nul

::move from root
if "%alreadyexists%" EQU "yes" goto:makeacopy
if exist "%DRIVE%"\%wadname%.wad move /Y "%DRIVE%"\%wadname%.wad "%DRIVE%"\WAD\%wadnameless%%patchname%%slotname%%versionname%.wad>nul
goto:nocopy

:makeacopy
if exist "%DRIVE%"\%wadname%.wad copy /Y "%DRIVE%"\%wadname%.wad "%DRIVE%"\WAD\%wadnameless%%patchname%%slotname%%versionname%.wad>nul
:nocopy

if exist "%DRIVE%"\WAD\%wadnameless%%patchname%%slotname%%versionname%.wad (goto:copyisthere) else (goto:missing)

:copyisthere
echo.
cd support
if /i "%DRIVE:~1,1%" EQU ":" (set DRIVEadj=%DRIVE%) else (set DRIVEadj=..\%DRIVE%)

patchios "%DRIVEadj%"\WAD\%wadnameless%%patchname%%slotname%%versionname%.wad%PATCHCODE%%slotcode%%versioncode%


cd..
echo.
echo Note: Patches are not always successful, read the PatchIOS log above for details
echo.
:nopatching


if exist "%DRIVE%"\WAD\%wadnameless%%patchname%%slotname%%versionname%.wad goto:there

::----check after Advanced downloading----
:missing
if /i "%attempt%" EQU "1" goto:missingretry
echo.
support\sfk echo [Magenta] This file has failed to download properly multiple times, Skipping download.
echo.
support\sfk filter -quiet "temp\DLgotos.txt" -ls!"%CurrentDLNAME%" -write -yes
echo "support\sfk echo %wadnameless%%patchname%%slotname%%versionname%.wad: [Red]Missing">>temp\ModMii_Log.bat
goto:DLSETTINGS3

:missingretry
echo.
support\sfk echo [Yellow] The file is missing, retrying download.
echo.
SET /a retry=%retry%+1
SET /a attempt=%attempt%+1
goto:DOWNLOADSTART2

:there

if /i "%multiplefail%" EQU "Y" (support\sfk echo [Magenta] Base wad failed hash check multiple times, Advanced download probably corrupted) else (support\sfk echo [Green]Advanced Download Successful)
echo.

if /i "%multiplefail%" EQU "Y" (echo "support\sfk echo %wadnameless%%patchname%%slotname%%versionname%.wad: Found but potentially corrupt">>temp\ModMii_Log.bat) else (echo "echo %wadnameless%%patchname%%slotname%%versionname%.wad: Found">>temp\ModMii_Log.bat)
:miniskip


support\sfk filter -quiet "temp\DLgotos.txt" -ls!"%CurrentDLNAME%" -write -yes
goto:DLSETTINGS3

::---------------------------------------SNEEKINSTALLER----------------------------------
:SNEEKINSTALLER
cls
if not exist "%DRIVE%" mkdir "%DRIVE%"
if /i "%SNEEKTYPE%" EQU "UD" goto:checkdriveU
if /i "%SNEEKTYPE%" EQU "U" (goto:checkdriveU) else (goto:skip)
:checkdriveU
if not exist "%DRIVEU%" mkdir "%DRIVEU%"
:skip


::delete all files that may interfere with SNEEK
if exist "%DRIVE%"\SNEEK\kernel.bin del "%DRIVE%"\SNEEK\kernel.bin>nul
if exist "%DRIVE%"\SNEEK\di.bin del "%DRIVE%"\SNEEK\di.bin>nul
if exist "%DRIVE%"\SNEEK\font.bin del "%DRIVE%"\SNEEK\font.bin>nul


::Special handling of bootmii\armboot.bin to avoid deleting Bootmii-SD Files
if not exist "%DRIVE%"\bootmii\armboot.bin goto:skip

::No Bootmii-SD Files
if not exist "%DRIVE%"\bootmii\ppcboot.elf del "%DRIVE%"\bootmii\armboot.bin>nul
if not exist "%DRIVE%"\bootmii\ppcboot.elf goto:skip


::RENAME Bootmii Booter Folder
set countbootmii=0
:renamebootmii
SET /a countbootmii=%countbootmii%+1
if exist "%DRIVE%"\bootmii_SDBooter%countbootmii% goto:renamebootmii
rename "%DRIVE%"\bootmii bootmii_SDBooter%countbootmii% >nul
:skip


::delete sneek files from USB (interfere's with nswitch)
if exist "%DRIVEU%"\SNEEK\kernel.bin del "%DRIVEU%"\SNEEK\kernel.bin>nul
if exist "%DRIVEU%"\SNEEK\di.bin del "%DRIVEU%"\SNEEK\di.bin>nul
if exist "%DRIVEU%"\SNEEK\font.bin del "%DRIVEU%"\SNEEK\font.bin>nul


if /i "%neek2o%" EQU "on" goto:neek2obuild
if /i "%SNEEKTYPE%" EQU "SD" echo Building SNEEK+DI rev%CurrentRev%
if /i "%SNEEKTYPE%" EQU "UD" echo Building UNEEK+DI rev%CurrentRev%
if /i "%SNEEKTYPE%" EQU "U" echo Building UNEEK rev%CurrentRev%
if /i "%SNEEKTYPE%" EQU "S" echo Building SNEEK rev%CurrentRev%
goto:skipneek2obuild
:neek2obuild


if /i "%SNEEKTYPE%" EQU "SD" echo Building SNEEK+DI neek2o rev%CurrentRev%
if /i "%SNEEKTYPE%" EQU "UD" echo Building UNEEK+DI neek2o rev%CurrentRev%
if /i "%SNEEKTYPE%" EQU "U" echo Building UNEEK neek2o rev%CurrentRev%
if /i "%SNEEKTYPE%" EQU "S" echo Building SNEEK neek2o rev%CurrentRev%

:skipneek2obuild
echo.
if /i "%neek2o%" EQU "on" echo neek2o Enabled (can be changed in options)
if /i "%neek2o%" NEQ "on" echo neek2o Disabled (can be changed in options)
echo.
if /i "%SSD%" EQU "on" echo SNEEK and SNEEK+DI SD Access Enabled (can be changed in options)
if /i "%SSD%" NEQ "on" echo SNEEK and SNEEK+DI SD Access Disabled (can be changed in options)


::download unrar if missing
if not exist temp\UnRAR.exe echo.
if not exist temp\UnRAR.exe echo Downloading UnRAR
if not exist temp\UnRAR.exe start %ModMiimin%/wait support\wget --no-check-certificate -t 3 "http://files.cybergamer.com.au/richard/FIFA Online 2 Full Client v200/UnRAR.exe"
if exist UnRAR.exe move /y UnRAR.exe temp\UnRAR.exe>nul



if /i "%neek2o%" EQU "on" set NewInstallerRev=70
if /i "%neek2o%" NEQ "on" set NewInstallerRev=186

if %CurrentRev% GEQ %NewInstallerRev% goto:newinstaller

::old installer
set wadname=SNEEKInstallerv0.6c-cred.rar
set md5=bcdd0ddb85dc63c1ad7fad0007b6b606
goto:skipnew

:newinstaller
set wadname=SNEEKInstallerv0.7a-cred.rar
set md5=e1c094efd57d19e9a3726bcb8f543660
:skipnew

::if exist "temp\DBUPDATE%currentversion%.bat" call "temp\DBUPDATE%currentversion%.bat"

echo.
echo Downloading Official Sneek Installer (%wadname:~14,5%)

if not exist temp\%wadname:~0,-4%\SNEEKInstaller.exe goto:nocheck

set md5check=
support\sfk md5 -quiet -verify %md5% temp\%wadname:~0,-4%\SneekInstaller.exe

if errorlevel 1 set md5check=fail
if "%md5check%"=="" set md5check=pass
if /i "%md5check%" NEQ "fail" goto:AlreadyinTemp

:nocheck
if exist temp\%wadname:~0,-4% rd /s /q temp\%wadname:~0,-4%
mkdir temp\%wadname:~0,-4%

start %ModMiimin%/wait support\wget --no-check-certificate -t 3 http://iweb.dl.sourceforge.net/project/sneek-modmii/%wadname%

if exist %wadname% temp\unrar.exe x -y %wadname% temp\%wadname:~0,-4%

if exist %wadname% del %wadname%>nul

:AlreadyinTemp
if not exist temp\%wadname:~0,-4%\SNEEKInstaller.exe goto:sneekwarning

::create empty sneek installer config file
type NUL > temp\%wadname:~0,-4%\sinst.ini
echo.


::---------------SKIN MODE-------------
if /i "%SkinMode%" EQU "Y" start support\wizapp PB UPDATE 15



echo Downloading Autoit
if exist temp\autoit3.exe goto:AlreadyinTemp
if not exist autoit-v3.zip start %ModMiimin%/wait support\wget --no-check-certificate -t 3 http://www.autoitscript.com/cgi-bin/getfile.pl?autoit3/autoit-v3.zip
if exist autoit-v3.zip support\7za e -aoa autoit-v3.zip -otemp autoit3.exe -r
if exist autoit-v3.zip del autoit-v3.zip>nul
if not exist temp\autoit3.exe goto:sneekwarning
:AlreadyinTemp
echo.

::---------------SKIN MODE-------------
if /i "%SkinMode%" EQU "Y" start support\wizapp PB UPDATE 30


echo Downloading 0000000e.app from IOS80
if exist temp\0000000e_IOS80.app goto:AlreadyinTemp

support\NusFileGrabber.exe 0e
move /Y 0000000e.app temp\0000000e_IOS80.app>nul

:AlreadyinTemp
copy /Y temp\0000000e_IOS80.app temp\0000000e.app>nul
if not exist temp\0000000e.app goto:sneekwarning
echo.



::---------------SKIN MODE-------------
if /i "%SkinMode%" EQU "Y" start support\wizapp PB UPDATE 45

::only old installer uses 0x1.app for neek+di
if /i "%wadname%" NEQ "SNEEKInstallerv0.6c-cred.rar" goto:skipDL01

if /i "%SNEEKTYPE%" EQU "SD" goto:DL01
if /i "%SNEEKTYPE%" EQU "UD" goto:DL01
goto:skipDL01
:DL01
echo Downloading 00000001.app from IOS60
if exist temp\00000001_IOS60.app goto:AlreadyinTemp
support\NusFileGrabber.exe 01_60
move /Y 00000001.app temp\00000001_IOS60.app>nul

:AlreadyinTemp
copy /Y temp\00000001_IOS60.app temp\00000001.app>nul
if not exist temp\00000001.app goto:sneekwarning
echo.
:skipDL01


::---------------SKIN MODE-------------
if /i "%SkinMode%" EQU "Y" start support\wizapp PB UPDATE 60



::FONT.BIN
if /i "%SNKFONT%" EQU "B" echo Downloading Black font.bin (this can be changed to White in Options)
if /i "%SNKFONT%" EQU "W" echo Downloading White font.bin (this can be changed to Black in Options)

if /i "%SNKFONT%" EQU "B" set fonturl=https://googledrive.com/host/0BzWzf-jnAnp1YkFURFF0cDdsRUE/ModMii/fontb.bin
if /i "%SNKFONT%" EQU "W" set fonturl=https://googledrive.com/host/0BzWzf-jnAnp1YkFURFF0cDdsRUE/ModMii/fontw.bin

if not exist temp\font%SNKFONT%.bin start %ModMiimin%/wait support\wget --no-check-certificate -t 3 %fonturl%

if exist font%SNKFONT%.bin move /Y font%SNKFONT%.bin temp\font%SNKFONT%.bin>nul
:skip

if /i "%SNEEKTYPE%" EQU "UD" goto:save2DriveU
if not exist "%DRIVE%"\SNEEK mkdir "%DRIVE%"\SNEEK
if exist temp\font%SNKFONT%.bin copy /Y temp\font%SNKFONT%.bin "%DRIVE%"\SNEEK\font.bin>nul
if not exist "%DRIVE%"\SNEEK\font.bin goto:sneekwarning
echo.
goto:GetNEEKfiles

:save2DriveU
if not exist "%DRIVEU%"\SNEEK mkdir "%DRIVEU%"\SNEEK
if exist temp\font%SNKFONT%.bin copy /Y temp\font%SNKFONT%.bin "%DRIVEU%"\SNEEK\font.bin>nul
if not exist "%DRIVEU%"\SNEEK\font.bin goto:sneekwarning
echo.


:GetNEEKfiles

echo Grabbing Modules for %neekname% Rev%CurrentRev%
echo.
if exist "temp\%neekname%\%neekname%-rev%CurrentRev%.zip" goto:Extract

start %ModMiimin%/wait support\wget --no-check-certificate -t 3 "http://iweb.dl.sourceforge.net/project/%googlecode%/%neekname%-rev%CurrentRev%.zip"
if not exist "%neekname%-rev%CurrentRev%.zip" goto:sneekwarning

if not exist "temp\%neekname%" mkdir "temp\%neekname%"
move /y "%neekname%-rev%CurrentRev%.zip" "temp\%neekname%\%neekname%-rev%CurrentRev%.zip">nul

if exist "temp\dimodule-sd.elf" del "temp\dimodule-sd.elf">nul
if exist "temp\dimodule-usb.elf" del "temp\dimodule-usb.elf">nul

:EXTRACT
support\7za e -aoa "temp\%neekname%\%neekname%-rev%CurrentRev%.zip" -o"temp" *.* -r>temp\7zalog.txt
findStr /I /C:"Everything is Ok" "temp\7zalog.txt" >nul
IF ERRORLEVEL 1 (Corrupted archive detected and deleted, please try again..) & (del temp\7zalog.txt>nul) & (del "temp\%neekname%\%neekname%-rev%CurrentRev%.zip">nul) & (goto:sneekwarning)
del temp\7zalog.txt>nul

::---------------SKIN MODE-------------
if /i "%SkinMode%" EQU "Y" start support\wizapp PB UPDATE 75

::Sneek SD Card Access
if /i "%SSD%" EQU "on" move /y "temp\esmodule-sdon.elf" "temp\esmodule.elf">nul

if /i "%SNEEKTYPE:~0,1%" NEQ "S" goto:noSDdi
if exist "temp\dimodule-sd.elf" move /y "temp\dimodule-sd.elf" "temp\dimodule.elf">nul
:noSDdi

if /i "%SNEEKTYPE:~0,1%" NEQ "U" goto:noUSBdi
if exist "temp\dimodule-usb.elf" move /y "temp\dimodule-usb.elf" "temp\dimodule.elf">nul
:noUSBdi


echo Building...
echo.

::create autoit script

echo WinWait ("SNEEK Installer","install SNEEK")>custom.au3
echo WinActivate ("SNEEK Installer","install SNEEK")>>custom.au3


if /i "%SNEEKTYPE%" EQU "S" echo ControlClick ("SNEEK Installer","SNEEK setup","SNEEK")>>custom.au3
if /i "%SNEEKTYPE%" EQU "SD" echo ControlClick ("SNEEK Installer","SNEEK setup","SNEEK+DI")>>custom.au3
if /i "%SNEEKTYPE%" EQU "U" echo ControlClick ("SNEEK Installer","SNEEK setup","UNEEK")>>custom.au3
if /i "%SNEEKTYPE%" EQU "UD" echo ControlClick ("SNEEK Installer","SNEEK setup","UNEEK+DI")>>custom.au3

if /i "%sneekverbose%" EQU "on" echo ControlClick ("SNEEK Installer","SNEEK setup","Verbose output")>>custom.au3


::ControlSetText vs ControlSend

echo ControlSetText("SNEEK Installer","","[CLASS:Edit; INSTANCE:2]","%cd%\temp")>>custom.au3
echo ControlSetText("SNEEK Installer","","[CLASS:Edit; INSTANCE:3]","%cd%\temp")>>custom.au3

if /i "%DRIVE:~1,1%" EQU ":" echo ControlSetText("SNEEK Installer","","[CLASS:Edit; INSTANCE:1]","%DRIVE%")>>custom.au3

if /i "%DRIVE:~1,1%" NEQ ":" echo ControlSetText("SNEEK Installer","","[CLASS:Edit; INSTANCE:1]","%cd%\%DRIVE%")>>custom.au3

::how to only change field if empty
::echo $a = ControlGetText ("SNEEK Installer","","[CLASS:Edit; INSTANCE:1]")>>custom.au3
::echo if $a = "" Then ControlSetText("SNEEK Installer","","[CLASS:Edit; INSTANCE:1]","%DRIVE%")>>custom.au3

if /i "%SNEEKTYPE%" EQU "S" goto:skip
if /i "%SNEEKTYPE%" EQU "SD" goto:skip

set DRIVEUabsolute=%cd%\%DRIVEU%
if /i "%DRIVEU:~1,1%" EQU ":" set DRIVEUabsolute=%DRIVEU%

echo ControlSetText("SNEEK Installer","","[CLASS:Edit; INSTANCE:4]","%DRIVEUabsolute%")>>custom.au3
:skip

echo ControlClick ("SNEEK Installer","SNEEK setup","install SNEEK")>>custom.au3




cd temp\%wadname:~0,-4%
start /I %ModMiimin%SneekInstaller.exe
cd..
cd..

echo start /wait temp\AutoIt3.exe custom.au3>run.bat
call run.bat
del run.bat>nul

@ping 127.0.0.1 -n 3 -w 1000> nul
taskkill /im SneekInstaller.exe /f >nul
del custom.au3>nul


::---------------SKIN MODE-------------
if /i "%SkinMode%" EQU "Y" start support\wizapp PB UPDATE 100



if /i "%AbstinenceWiz%" EQU "Y" move /y "%DRIVE%\bootmii\armboot.bin" "%DRIVE%\bootmii_ios.bin">nul
if /i "%AbstinenceWiz%" EQU "Y" rd /s /q "%DRIVE%\bootmii"
if /i "%AbstinenceWiz%" EQU "Y" goto:norename


if /i "%SNKS2U%" NEQ "Y" goto:noswitch2uneek
if exist "%DRIVE%\bootmiiuneek" rd /s /q "%DRIVE%\bootmiiuneek"
rename "%DRIVE%\bootmii" "bootmiiuneek"
:noswitch2uneek

::if /i "%neek2o%" EQU "off" goto:norename
if exist "%DRIVE%\bootmiineek" rd /s /q "%DRIVE%\bootmiineek"
rename "%DRIVE%\bootmii" "bootmiineek"
:norename

::save rev information

if /i "%neek2o%" EQU "on" goto:neek2orevinfo

if /i "%sneekverbose%" EQU "on" goto:sneekverbose

if /i "%SNEEKTYPE%" EQU "SD" echo SNEEK+DI rev%CurrentRev% >"%DRIVE%"\sneek\rev.txt
if /i "%SNEEKTYPE%" EQU "S" echo SNEEK rev%CurrentRev% >"%DRIVE%"\sneek\rev.txt
if /i "%SSD%" EQU "off" goto:miniskip
if /i "%SNEEKTYPE%" EQU "SD" echo SNEEK+DI (with SD Access On) rev%CurrentRev% >"%DRIVE%"\sneek\rev.txt
if /i "%SNEEKTYPE%" EQU "S" echo SNEEK (with SD Access On) rev%CurrentRev% >"%DRIVE%"\sneek\rev.txt
:miniskip

if /i "%SNEEKTYPE%" EQU "UD" echo UNEEK+DI rev%CurrentRev% >"%DRIVE%"\sneek\rev.txt
if /i "%SNEEKTYPE%" EQU "UD" echo UNEEK+DI rev%CurrentRev% >"%DRIVEU%"\sneek\rev.txt

if /i "%SNEEKTYPE%" EQU "U" echo UNEEK rev%CurrentRev% >"%DRIVE%"\sneek\rev.txt
if /i "%SNEEKTYPE%" EQU "U" echo UNEEK rev%CurrentRev% >"%DRIVEU%"\sneek\rev.txt
goto:skipsneekverbose

:sneekverbose
if /i "%SNEEKTYPE%" EQU "SD" echo SNEEK+DI (verbose) rev%CurrentRev% >"%DRIVE%"\sneek\rev.txt
if /i "%SNEEKTYPE%" EQU "S" echo SNEEK (verbose) rev%CurrentRev% >"%DRIVE%"\sneek\rev.txt
if /i "%SSD%" EQU "off" goto:miniskip
if /i "%SNEEKTYPE%" EQU "SD" echo SNEEK+DI (verbose and SD Access On) rev%CurrentRev% >"%DRIVE%"\sneek\rev.txt
if /i "%SNEEKTYPE%" EQU "S" echo SNEEK (verbose and SD Access On) rev%CurrentRev% >"%DRIVE%"\sneek\rev.txt
:miniskip

if /i "%SNEEKTYPE%" EQU "UD" echo UNEEK+DI (verbose) rev%CurrentRev% >"%DRIVE%"\sneek\rev.txt
if /i "%SNEEKTYPE%" EQU "UD" echo UNEEK+DI (verbose) rev%CurrentRev% >"%DRIVEU%"\sneek\rev.txt

if /i "%SNEEKTYPE%" EQU "U" echo UNEEK (verbose) rev%CurrentRev% >"%DRIVE%"\sneek\rev.txt
if /i "%SNEEKTYPE%" EQU "U" echo UNEEK (verbose) rev%CurrentRev% >"%DRIVEU%"\sneek\rev.txt
:skipsneekverbose
goto:skipneek2orevinfo


:neek2orevinfo

if /i "%sneekverbose%" EQU "on" goto:sneekverbose

if /i "%SNEEKTYPE%" EQU "SD" echo SNEEK+DI neek2o rev%CurrentRev% >"%DRIVE%"\sneek\rev.txt
if /i "%SNEEKTYPE%" EQU "S" echo SNEEK neek2o rev%CurrentRev% >"%DRIVE%"\sneek\rev.txt


if /i "%SSD%" EQU "off" goto:miniskip
if /i "%SNEEKTYPE%" EQU "SD" echo SNEEK+DI (with SD Access On) neek2o rev%CurrentRev% >"%DRIVE%"\sneek\rev.txt
if /i "%SNEEKTYPE%" EQU "S" echo SNEEK (with SD Access On) neek2o rev%CurrentRev% >"%DRIVE%"\sneek\rev.txt
:miniskip

if /i "%SNEEKTYPE%" EQU "UD" echo UNEEK+DI neek2o rev%CurrentRev% >"%DRIVE%"\sneek\rev.txt
if /i "%SNEEKTYPE%" EQU "UD" echo UNEEK+DI neek2o rev%CurrentRev% >"%DRIVEU%"\sneek\rev.txt

if /i "%SNEEKTYPE%" EQU "U" echo UNEEK neek2o rev%CurrentRev% >"%DRIVE%"\sneek\rev.txt
if /i "%SNEEKTYPE%" EQU "U" echo UNEEK neek2o rev%CurrentRev% >"%DRIVEU%"\sneek\rev.txt
goto:skipsneekverbose

:sneekverbose
if /i "%SNEEKTYPE%" EQU "SD" echo SNEEK+DI (verbose) neek2o rev%CurrentRev% >"%DRIVE%"\sneek\rev.txt
if /i "%SNEEKTYPE%" EQU "S" echo SNEEK (verbose) neek2o rev%CurrentRev% >"%DRIVE%"\sneek\rev.txt

::neek2o sd access temporarily always disabled
goto:miniskip

if /i "%SSD%" EQU "off" goto:miniskip
if /i "%SNEEKTYPE%" EQU "SD" echo SNEEK+DI (verbose and SD Access On) neek2o rev%CurrentRev% >"%DRIVE%"\sneek\rev.txt
if /i "%SNEEKTYPE%" EQU "S" echo SNEEK (verbose and SD Access On) neek2o rev%CurrentRev% >"%DRIVE%"\sneek\rev.txt
:miniskip

if /i "%SNEEKTYPE%" EQU "UD" echo UNEEK+DI (verbose) neek2o rev%CurrentRev% >"%DRIVE%"\sneek\rev.txt
if /i "%SNEEKTYPE%" EQU "UD" echo UNEEK+DI (verbose) neek2o rev%CurrentRev% >"%DRIVEU%"\sneek\rev.txt

if /i "%SNEEKTYPE%" EQU "U" echo UNEEK (verbose) neek2o rev%CurrentRev% >"%DRIVE%"\sneek\rev.txt
if /i "%SNEEKTYPE%" EQU "U" echo UNEEK (verbose) neek2o rev%CurrentRev% >"%DRIVEU%"\sneek\rev.txt
:skipsneekverbose


:skipneek2orevinfo



if /i "%SNEEKSELECT%" EQU "3" goto:SNKNANDBUILDER
goto:finishsneekinstall3




:sneekwarning

::---------------CMD LINE MODE-------------
if /i "%cmdlinemode%" NEQ "Y" goto:notcmdfinish

echo Some files required for %neekname% installation >temp\ModMii_CMD_LINE_NEEK_Errors.txt
echo are missing. Aborting %neekname% installation, >>temp\ModMii_CMD_LINE_NEEK_Errors.txt
echo check your internet connection then try again. >>temp\ModMii_CMD_LINE_NEEK_Errors.txt

if /i "%SKINmode%" NEQ "Y" start notepad "temp\ModMii_CMD_LINE_NEEK_Errors.txt"

if /i "%SNEEKSELECT%" EQU "3" goto:SNKNANDBUILDER

if exist support\settings.bak move /y support\settings.bak support\settings.bat>nul
if /i "%SKINmode%" EQU "Y" start support\wizapp PB CLOSE
exit
:notcmdfinish

echo.
support\sfk echo -spat \x20 [Yellow] WARNING: Some files Required for the %neekname% install are missing.
support\sfk echo -spat \x20 \x20 \x20 \x20 [Yellow] Aborting %neekname% Installation, check your internet connection
support\sfk echo -spat \x20 \x20 \x20 \x20 [Yellow] Then repeat the Installation to try again.
echo.

if /i "%SKINmode%" EQU "Y" goto:noaudio
if /i "%AudioOption%" NEQ "on" goto:noaudio
start support\nircmd.exe mediaplay 3000 "support\FAIL.mp3"
:noaudio

echo Press any key to return to the Main Menu.
pause>nul
goto:MENU





::------------------------wad2nand-install wads from temp\wad to emu nand--------------------
:wad2nand


if exist support\common-key.bin goto:commonkeyalreadythere

::silently build common-key.bin
echo EBE42A225E8593E448D9C5457381AAF7>support\common-key.txt
support\sfk filter support\common-key.txt +hextobin support\common-key.bin>nul
del support\common-key.txt>nul
:commonkeyalreadythere

set nandpathadj=..\%nandpath%
if /i "%nandpath:~1,1%" EQU ":" set nandpathadj=%nandpath%

set line1="<?xml version='1.0' standalone='yes'?>"
set line2="<ShowMiiWads>"
set line3="  <Settings>"
set line4="    <Version>1.5</Version>"
set line5="    <Language>English</Language>"
set line6="    <LangFile />"
set line7="    <AutoSize>true</AutoSize>"
set line8="    <NandPath>%nandpathadj%</NandPath>"
set line9="    <ShowPath>true</ShowPath>"
set line10="    <AddSub>false</AddSub>"
set line11="    <Portable>False</Portable>"
set line12="    <Accepted>false</Accepted>"
set line13="    <SaveFolders>true</SaveFolders>"
set line14="    <CreateBackups>false</CreateBackups>"
set line15="    <SplashScreen>false</SplashScreen>"
set line16="    <View>ShowMiiWads</View>"
set line17="  </Settings>"
set line18="  <Window>"
set line19="    <WindowWidth>930</WindowWidth>"
set line20="    <WindowHeight>396</WindowHeight>"
set line21="    <LocationX>50</LocationX>"
set line22="    <LocationY>200</LocationY>"
set line23="    <WindowState>Normal</WindowState>"
set line24="  </Window>"
set line25="  <Folders>"
set line26="    <MRU0>..\temp\WAD</MRU0>"
if "%addwadfolder%"=="" set line27="    <MRU1 />"
if not "%addwadfolder%"=="" set line27="    <MRU1>%addwadfolder%</MRU1>"
set line28="    <MRU2 />"
set line29="    <MRU3 />"
set line30="    <MRU4 />"

if "%addwadfolder%"=="" set line31="    <Foldercount>1</Foldercount>"
if not "%addwadfolder%"=="" set line31="    <Foldercount>2</Foldercount>"
set line32="    <Folder0>..\temp\WAD</Folder0>"
if "%addwadfolder%"=="" set line33=
if not "%addwadfolder%"=="" set line33="    <Folder1>%addwadfolder%</Folder1>"
set line34="  </Folders>"
set line35="</ShowMiiWads>"


echo %line1%>support\ShowMiiWads.cfg
echo %line2%>>support\ShowMiiWads.cfg
echo %line3%>>support\ShowMiiWads.cfg
echo %line4%>>support\ShowMiiWads.cfg
echo %line5%>>support\ShowMiiWads.cfg
echo %line6%>>support\ShowMiiWads.cfg
echo %line7%>>support\ShowMiiWads.cfg
echo %line8%>>support\ShowMiiWads.cfg
echo %line9%>>support\ShowMiiWads.cfg
echo %line10%>>support\ShowMiiWads.cfg
echo %line12%>>support\ShowMiiWads.cfg
echo %line13%>>support\ShowMiiWads.cfg
echo %line14%>>support\ShowMiiWads.cfg
echo %line15%>>support\ShowMiiWads.cfg
echo %line16%>>support\ShowMiiWads.cfg
echo %line17%>>support\ShowMiiWads.cfg
echo %line18%>>support\ShowMiiWads.cfg
echo %line19%>>support\ShowMiiWads.cfg
echo %line20%>>support\ShowMiiWads.cfg
echo %line21%>>support\ShowMiiWads.cfg
echo %line22%>>support\ShowMiiWads.cfg
echo %line23%>>support\ShowMiiWads.cfg
echo %line24%>>support\ShowMiiWads.cfg
echo %line25%>>support\ShowMiiWads.cfg
echo %line26%>>support\ShowMiiWads.cfg
echo %line27%>>support\ShowMiiWads.cfg
echo %line28%>>support\ShowMiiWads.cfg
echo %line29%>>support\ShowMiiWads.cfg
echo %line30%>>support\ShowMiiWads.cfg
echo %line31%>>support\ShowMiiWads.cfg
echo %line32%>>support\ShowMiiWads.cfg
if not "%addwadfolder%"=="" echo %line33%>>support\ShowMiiWads.cfg
echo %line34%>>support\ShowMiiWads.cfg
echo %line35%>>support\ShowMiiWads.cfg

support\sfk filter -quiet "support\ShowMiiWads.cfg" -rep _"""__ -write -yes
support\sfk filter -quiet "support\ShowMiiWads.cfg" -rep _"'"_"""_ -write -yes


cls

if /i "%SNEEKSELECT%" NEQ "5" goto:tinyskip
if /i "%emuwadcount%" EQU "0" goto:skipSMWall
:tinyskip



::---------------SKIN MODE-------------
if /i "%SkinMode%" EQU "Y" start support\wizapp PB UPDATE 10




echo Loading ShowMiiWads
echo.
echo installing wads from: temp\WAD\
if not "%addwadfolder%"=="" echo             and from: %addwadfolder%
if not "%addwadfolder%"=="" echo.
echo     to emulated nand: %nandpath%\
echo.
echo Please wait for ShowMiiWads to finish doing it job...
cd support

if not "%addwadfolder%"=="" goto:forceSMW
if not exist ..\temp\WAD\*.wad goto:skipSMW
:forceSMW
SMW-Mod.exe
:skipSMW
cd..
:skipSMWall


::---------------SKIN MODE-------------
if /i "%SkinMode%" EQU "Y" start support\wizapp PB UPDATE 50


::---delete non-temp files---
if exist temp\WAD\Default-FIX94v14b-forwarder-DWFA.wad del temp\WAD\Default-FIX94v14b-forwarder-DWFA.wad>nul
if exist temp\WAD\switch2uneek(emulators)-4EMUNand-v12-S2RL.wad del temp\WAD\switch2uneek(emulators)-4EMUNand-v12-S2RL.wad>nul
if exist temp\WAD\cIOS249-v14.wad del temp\WAD\cIOS249-v14.wad>nul
if exist temp\WAD\cBC-NMMv0.2a.wad del temp\WAD\cBC-NMMv0.2a.wad>nul
::if exist temp\WAD\cBC-DML.wad del temp\WAD\cBC-DML.wad>nul

if exist temp\WAD\*.wad move temp\WAD\*.wad temp\>nul

::restore setting.txt if applicable
if /i "%SNEEKSELECT%" EQU "5" goto:skipSMW
if not exist "%nandpath%\title\00000001\00000002\data" mkdir "%nandpath%\title\00000001\00000002\data"
if /i "%SNKSERIAL%" EQU "current" move /y "%nandpath%"\setting.txt "%nandpath%"\title\00000001\00000002\data\setting.txt>nul
:skipSMW

if exist support\ShowMiiWads.cfg del support\ShowMiiWads.cfg>nul



::NANDINFO.TXT
if /i "%SNEEKSELECT%" EQU "2" goto:newnand
if /i "%SNEEKSELECT%" EQU "3" (goto:newnand) else (goto:nonewnand)
:newnand
if exist "%nandpath%\sneek\nandcfg.bin" del "%nandpath%\sneek\nandcfg.bin" >nul
echo ================================================== >"%nandpath%\nandinfo.txt"
echo %SNKVERSION%%SNKREGION% Emulated NAND created by ModMii on %DATE% >>"%nandpath%\nandinfo.txt"
echo ================================================== >>"%nandpath%\nandinfo.txt"
:nonewnand

if /i "%SNEEKSELECT%" NEQ "5" goto:nomoddednand
echo ============================================== >>"%nandpath%\nandinfo.txt"
echo Emulated NAND Modified by ModMii on %DATE% >>"%nandpath%\nandinfo.txt"
echo ============================================== >>"%nandpath%\nandinfo.txt"
:nomoddednand


::if /i "%SNEEKSELECT%" EQU "5" goto:skip

::Build setting.txt
if /i "%SNKSERIAL%" EQU "current" goto:skip

echo.
echo Building setting.txt using serial number: %SNKSERIAL%

support\settings %SNKSERIAL% >nul

if /i "%SNKREGION%" EQU "K" move /y KORsetting.txt "%nandpath%"\title\00000001\00000002\data\setting.txt >nul
if /i "%SNKREGION%" EQU "U" move /y USAsetting.txt "%nandpath%"\title\00000001\00000002\data\setting.txt >nul
if /i "%SNKREGION%" EQU "E" move /y EURsetting.txt "%nandpath%"\title\00000001\00000002\data\setting.txt >nul
if /i "%SNKREGION%" EQU "J" move /y JPNsetting.txt "%nandpath%"\title\00000001\00000002\data\setting.txt >nul

if /i "%SNKREGION%" NEQ "K" del KORsetting.txt>nul
if /i "%SNKREGION%" NEQ "E" del EURsetting.txt>nul
if /i "%SNKREGION%" NEQ "J" del JPNsetting.txt>nul
if /i "%SNKREGION%" NEQ "U" del USAsetting.txt>nul

if exist "%nandpath%"\title\00000001\00000002\data\setting.txt (echo setting.txt built using this serial: %SNKSERIAL% >>"%nandpath%\nandinfo.txt") else (echo setting.txt failed to build properly >>"%nandpath%\nandinfo.txt")

:skip


::---------------SKIN MODE-------------
if /i "%SkinMode%" EQU "Y" start support\wizapp PB UPDATE 60


if "%ThemeSelection%"=="" goto:quickskip2
if /i "%ThemeSelection%" EQU "N" goto:quickskip
if /i "%ThemeSelection%" EQU "D" goto:quickskip
echo.
echo Copying over Custom Theme

if /i "%ThemeSelection%" EQU "R" set themecolour=Red
if /i "%ThemeSelection%" EQU "G" set themecolour=Green
if /i "%ThemeSelection%" EQU "BL" set themecolour=Blue
if /i "%ThemeSelection%" EQU "O" set themecolour=Orange


if exist "temp\ModThemes\DarkWii_%themecolour%_%effect%_%SNKVERSION%%SNKREGION%.csm" (echo Custom System Menu Theme Installed - Dark Wii %themecolour% >>"%nandpath%\nandinfo.txt") else (echo Custom System Menu Theme Failed to Install Properly >>"%nandpath%\nandinfo.txt")

move /y "temp\ModThemes\DarkWii_%themecolour%_%effect%_%SNKVERSION%%SNKREGION%.csm" "%nandpath%"\title\00000001\00000002\content\%SMTHEMEAPP%.app>nul

goto:quickskip2
:quickskip


if /i "%ThemeSelection%" NEQ "D" goto:quickskip2
echo.
echo Restoring Original Theme

if exist "temp\ModThemes\%SMTHEMEAPP%_%SNKVERSION%%SNKREGION%.app" (echo Original System Menu Theme Restored >>"%nandpath%\nandinfo.txt") else (echo Failed to Restore Original System Menu Theme >>"%nandpath%\nandinfo.txt")

move /y "temp\ModThemes\%SMTHEMEAPP%_%SNKVERSION%%SNKREGION%.app" "%nandpath%"\title\00000001\00000002\content\%SMTHEMEAPP%.app>nul



:quickskip2



if exist temp\ModThemes rd /s /q temp\ModThemes
if exist temp\WAD rd /s /q temp\WAD


::disable wbfs and games folder creation for now
goto:notDI
if /i "%SNEEKSELECT%" EQU "5" goto:skip
::---------if building uneek+di or sneek+di add games\wbfs folder to usb---------
if /i "%SNEEKTYPE:~1,1%" NEQ "D" goto:notDI
if not exist "%DRIVEU%\games" mkdir "%DRIVEU%\games" >nul
if /i "%neek2o%" EQU "off" goto:notDI
if not exist "%DRIVEU%\wbfs" mkdir "%DRIVEU%\wbfs" >nul
:notDI


::---------------SKIN MODE-------------
if /i "%SkinMode%" EQU "Y" start support\wizapp PB UPDATE 70


if /i "%SNEEKSELECT%" EQU "5" goto:skip
::---------building cdf.vff----------
echo.
echo Building cdb.vff to speed up the time required to launch s\uneek the first time
cd support
writecbd.exe
cd..
if exist support\cdb.vff move /y support\cdb.vff "%nandpath%"\title\00000001\00000002\data\cdb.vff>nul

:skip


::---------------SKIN MODE-------------
if /i "%SkinMode%" EQU "Y" start support\wizapp PB UPDATE 80


if /i "%PRIIFOUND%" EQU "Yes" goto:skipSNKpri
if /i "%SNKPRI%" NEQ "Y" goto:skipSNKpri
echo.
echo Downloading Priiloader v0.7 (mod for neek2o)
echo.
if not exist temp\Priiloader-v0.7neek.app start %ModMiimin%/wait support\wget --no-check-certificate -t 3 http://custom-di.googlecode.com/files/priiloader.app
if exist priiloader.app move /Y priiloader.app temp\Priiloader-v0.7neek.app>nul


if exist temp\Priiloader-v0.7neek.app (echo Priiloader v0.7 [mod for neek2o] Installed >>"%nandpath%\nandinfo.txt") else (echo Failed to Install Priiloader v0.7 [mod for neek2o] >>"%nandpath%\nandinfo.txt")

move /y "%nandpath%\title\00000001\00000002\content\%SMAPP%.app" "%nandpath%\title\00000001\00000002\content\1%SMAPP:~1%.app" >nul

copy /Y temp\Priiloader-v0.7neek.app "%nandpath%"\title\00000001\00000002\content\%SMAPP%.app>nul

if not exist "%nandpath%"\title\00000001\00000002\data mkdir "%nandpath%"\title\00000001\00000002\data >nul
move /Y temp\hacks.ini "%nandpath%"\title\00000001\00000002\data\hacks.ini >nul
move /Y temp\hacks_hash.ini "%nandpath%"\title\00000001\00000002\data\hackshas.ini >nul

if /i "%SNKFLOW%" NEQ "Y" goto:skipSNKpri

echo Adding WiiFlow forwarder dol to Priiloader's installed file.
echo.

if exist temp\Priiloader-Forwader-Loader-DWFA.dol move /y temp\Priiloader-Forwader-Loader-DWFA.dol "%nandpath%"\title\00000001\00000002\data\main.bin>nul

:skipSNKpri

if /i "%SNKFLOW%" EQU "Y" echo WiiFlow Forwarder Channel Installed >>"%nandpath%\nandinfo.txt"


if /i "%uninstallprii%" NEQ "yes" goto:skippriiuninstall
echo.
echo Removing Priiloader from emulated NAND
echo.
move /y "%nandpath%\title\00000001\00000002\content\1%SMAPP:~1%.app" "%nandpath%\title\00000001\00000002\content\%SMAPP%.app" >nul
if exist "%nandpath%"\title\00000001\00000002\data\hacks.ini del "%nandpath%"\title\00000001\00000002\data\hacks.ini >nul
if exist "%nandpath%"\title\00000001\00000002\data\hackshas.ini del "%nandpath%"\title\00000001\00000002\data\hackshas.ini >nul
if exist "%nandpath%"\title\00000001\00000002\data\main.bin del "%nandpath%"\title\00000001\00000002\data\main.bin >nul

echo Priiloader Uninstalled >>"%nandpath%\nandinfo.txt"

:skippriiuninstall


::add extra info to "%nandpath%\nandinfo.txt"

if /i "%nswitchFound%" NEQ "YES" echo nSwitch Channel Installed >>"%nandpath%\nandinfo.txt"
if /i "%SNKPLC%" EQU "Y" echo Post Loader Forwarder Channel Installed >>"%nandpath%\nandinfo.txt"
if /i "%SNKCIOS%" EQU "Y" echo cIOS249 rev14 Installed >>"%nandpath%\nandinfo.txt"
if /i "%SNKS2U%" EQU "Y" echo Switch2Uneek Forwarder Channel Installed >>"%nandpath%\nandinfo.txt"
if /i "%PIC%" EQU "Y" echo Photo Channel Installed >>"%nandpath%\nandinfo.txt"
if /i "%NET%" EQU "Y" echo Internet Channel Installed >>"%nandpath%\nandinfo.txt"
if /i "%WEATHER%" EQU "Y" echo Weather Channel Installed >>"%nandpath%\nandinfo.txt"
if /i "%NEWS%" EQU "Y" echo News Channel Installed >>"%nandpath%\nandinfo.txt"
if /i "%MIIQ%" EQU "Y" echo Mii Channel Installed >>"%nandpath%\nandinfo.txt"
if /i "%Shop%" EQU "Y" echo Shopping Channel Installed >>"%nandpath%\nandinfo.txt"
if /i "%Speak%" EQU "Y" echo Wii Speak Channel Installed >>"%nandpath%\nandinfo.txt"


if /i "%SNEEKSELECT%" NEQ "5" goto:skipthis
if /i "%BCtype%" EQU "BC" goto:skipthis
if /i "%BCtype%" EQU "NONE" goto:skipthis

::Old DML is uninstalled when detected
if /i "%SNKcBC%" NEQ "DML" goto:continue
if /i "%BCtype%" EQU "DML" echo Outdated DML uninstalled from Emulated NAND >>"%nandpath%\nandinfo.txt"
if /i "%BCtype%" EQU "DML" goto:skipthis

:continue
if /i "%BCtype%" EQU "%SNKcBC%" goto:skipthis

echo %BCTYPE% Uninstalled >>"%nandpath%\nandinfo.txt"
:skipthis

if /i "%BCtype%" EQU "NMM" goto:noNMM
if /i "%SNKcBC%" EQU "NMM" echo NMM (No More Memory-Cards) Installed >>"%nandpath%\nandinfo.txt"
:noNMM

if /i "%BCtype%" EQU "DML" goto:noDML
if /i "%SNKcBC%" EQU "DML" echo DML WAD (install to real NAND) >>"%nandpath%\nandinfo.txt"
:noDML


IF not "%addwadfolder%"=="" echo Custom Folder of WADs Installed: %addwadfolder% >>"%nandpath%\nandinfo.txt"


if exist temp\Priiloader-Forwader-Loader-DWFA.dol del temp\Priiloader-Forwader-Loader-DWFA.dol>nul

copy /y temp\ModMii_Log.bat temp\ModMii_Log_SNK.bat>nul


::---------------SKIN MODE-------------
if /i "%SkinMode%" EQU "Y" start support\wizapp PB UPDATE 100

::small pause
::@ping 127.0.0.1 -n 2 -w 1000> nul

goto:finishsneekinstall




::----------------------------------SNEEK INSTALL FINISH------------------------------------
:finishsneekinstall


::RESTORE DRIVE SETTINGS
set DRIVE=%REALDRIVE%

::if /i "%SNEEKSELECT%" EQU "1" goto:finishsneekinstall3

::clear download queue
set MENUREAL=S
goto:CLEAR

:finishsneekinstall2
set MENU1=1

::queue up files that need to TRULY be saved to %Drive%

if /i "%SNKS2U%" NEQ "Y" (set nSwitch=*) & (set mmm=*)
if /i "%nswitchFound%" EQU "Yes" (set nSwitch=) & (set mmm=)

if /i "%SNKS2U%" EQU "Y" (set S2U=*) & (set mmm=*)
if /i "%SNKcBC%" EQU "DML" (set DML=*) & (set mmm=*)

if /i "%SNKFLOW%" EQU "Y" set FLOW=*
if /i "%SNKPLC%" EQU "Y" set PL=*

if /i "%AbstinenceWiz%" EQU "Y" (set nSwitch=) & (set mmm=) & (goto:Download)

:tinyskip

goto:DLCOUNT

:finishsneekinstall3

::check for errors - do not do if ONLY installing sneek
if /i "%SNEEKSELECT%" EQU "1" goto:nocheck

if exist temp\ModMii_Log_SNK.bat del temp\ModMii_Log_SNK.bat>nul

if not exist "temp\ModMii_Log.bat" (set problematicDLs=0) & (goto:nocounting)

support\sfk filter -quiet "temp\ModMii_Log.bat" -rep _"""__ -write -yes

::count # of problematic downloads
support\sfk filter -quiet "temp\ModMii_Log.bat" -+"[Red]" -write -yes
set problematicDLs=0

setlocal ENABLEDELAYEDEXPANSION
for /f "delims=" %%i in (temp\ModMii_Log.bat) do set /a problematicDLs=!problematicDLs!+1
setlocal DISABLEDELAYEDEXPANSION
:nocounting

if /i "%problematicDLs%" EQU "0" (set snksuccess=Successfully) else (set snksuccess=)

if /i "%problematicDLs%" EQU "0" (set snkfailure=) else (set snkfailure= but with errors)

::resize window
SET /a LINES=%problematicDLs%+56

if %LINES% LEQ 54 set lines=54
mode con cols=85 lines=%LINES%

if /i "%SKINmode%" EQU "Y" goto:noaudio
if /i "%AudioOption%" NEQ "on" goto:noaudio
if /i "%problematicDLs%" EQU "0" (start support\nircmd.exe mediaplay 3000 "support\Success.mp3") else (start support\nircmd.exe mediaplay 3000 "support\Fail.mp3")
:noaudio

:nocheck

if /i "%SKINmode%" EQU "Y" goto:noaudio
if /i "%SNEEKSELECT%" NEQ "1" goto:noaudio
if /i "%AudioOption%" NEQ "on" goto:noaudio
start support\nircmd.exe mediaplay 3000 "support\Success.mp3"
:noaudio

if /i "%cmdlinemode%" EQU "Y" goto:problemlog

set MENUREAL=

cls
echo                                        ModMii                                v%currentversion%
echo                                       by XFlak
echo.

if /i "%AbstinenceWiz%" NEQ "Y" goto:notabstinence
if /i "%FIRMSTART%" NEQ "o" echo                              Abstinence Wizard for %FIRMSTART%%REGION%
if /i "%FIRMSTART%" EQU "o" echo                              Abstinence Wizard for ^<2.2%REGION%
echo.
:notabstinence

::both sneek install and nand build
if /i "%SNEEKSELECT%" NEQ "3" goto:skip
if /i "%neek2o%" EQU "on" goto:neek2o3report

if /i "%SNEEKTYPE%" EQU "SD" echo    %snksuccess% installed SNEEK+DI rev%CurrentRev% and built a %SNKVERSION%%SNKREGION% Emulated Nand%snkfailure%
if /i "%SNEEKTYPE%" EQU "UD" echo    %snksuccess% installed UNEEK+DI rev%CurrentRev% and built a %SNKVERSION%%SNKREGION% Emulated Nand%snkfailure%
if /i "%SNEEKTYPE%" EQU "S" echo    %snksuccess% installed SNEEK rev%CurrentRev% and built a %SNKVERSION%%SNKREGION% Emulated Nand%snkfailure%
if /i "%SNEEKTYPE%" EQU "U" echo    %snksuccess% installed UNEEK rev%CurrentRev% and built a %SNKVERSION%%SNKREGION% Emulated Nand%snkfailure%
goto:skip

:neek2o3report
if /i "%SNEEKTYPE%" EQU "SD" echo    %snksuccess% installed SNEEK+DI neek2o rev%CurrentRev% and built a %SNKVERSION%%SNKREGION% Emulated Nand%snkfailure%
if /i "%SNEEKTYPE%" EQU "UD" echo    %snksuccess% installed UNEEK+DI neek2o rev%CurrentRev% and built a %SNKVERSION%%SNKREGION% Emulated Nand%snkfailure%
if /i "%SNEEKTYPE%" EQU "S" echo    %snksuccess% installed SNEEK neek2o rev%CurrentRev% and built a %SNKVERSION%%SNKREGION% Emulated Nand%snkfailure%
if /i "%SNEEKTYPE%" EQU "U" echo    %snksuccess% installed UNEEK neek2o rev%CurrentRev% and built a %SNKVERSION%%SNKREGION% Emulated Nand%snkfailure%
:skip

::only install sneek
if /i "%SNEEKSELECT%" NEQ "1" goto:skip
if /i "%neek2o%" EQU "on" goto:neek2o1report

if /i "%SNEEKTYPE%" EQU "SD" echo    Successfully installed SNEEK+DI rev%CurrentRev%
if /i "%SNEEKTYPE%" EQU "UD" echo    Successfully installed UNEEK+DI rev%CurrentRev%
if /i "%SNEEKTYPE%" EQU "U" echo    Successfully installed UNEEK rev%CurrentRev%
if /i "%SNEEKTYPE%" EQU "S" echo    Successfully installed SNEEK rev%CurrentRev%
goto:skip

:neek2o1report
if /i "%SNEEKTYPE%" EQU "SD" echo    Successfully installed SNEEK+DI neek2o rev%CurrentRev%
if /i "%SNEEKTYPE%" EQU "UD" echo    Successfully installed UNEEK+DI neek2o rev%CurrentRev%
if /i "%SNEEKTYPE%" EQU "U" echo    Successfully installed UNEEK neek2o rev%CurrentRev%
if /i "%SNEEKTYPE%" EQU "S" echo    Successfully installed SNEEK neek2o rev%CurrentRev%

:skip





::only build nand
if /i "%SNEEKSELECT%" NEQ "2" goto:skip
if /i "%SNEEKTYPE%" EQU "SD" echo    %snksuccess% Built a %SNKVERSION%%SNKREGION% Emulated Nand%snkfailure%
if /i "%SNEEKTYPE%" EQU "UD" echo    %snksuccess% Built a %SNKVERSION%%SNKREGION% Emulated Nand%snkfailure%
if /i "%SNEEKTYPE%" EQU "U" echo    %snksuccess% Built a %SNKVERSION%%SNKREGION% Emulated Nand%snkfailure%
if /i "%SNEEKTYPE%" EQU "S" echo    %snksuccess% Built a %SNKVERSION%%SNKREGION% Emulated Nand%snkfailure%
:skip


if /i "%SNEEKSELECT%" EQU "5" echo    Emulated Nand has been modified %snkfailure%


:problemlog
::list problematic Download
if /i "%SNEEKSELECT%" EQU "1" goto:noproblems
if /i "%problematicDLs%" EQU "0" goto:noproblems

if /i "%cmdlinemode%" NEQ "Y" echo.
if /i "%cmdlinemode%" NEQ "Y" echo The following file(s) failed to download properly:
if /i "%cmdlinemode%" NEQ "Y" call temp\ModMii_Log.bat

support\sfk filter -quiet "temp\ModMii_Log.bat" -rep _[Red]__ -rep _[def]__ -rep _"support\sfk echo "__ -rep _"echo "__ >temp\ModMii_Log_temp.txt

echo ------ >>"%nandpath%\nandinfo.txt"
echo Errors >>"%nandpath%\nandinfo.txt"
echo ------ >>"%nandpath%\nandinfo.txt"

if exist "temp\nandinfo.txt" del "temp\nandinfo.txt">nul
copy "%nandpath%\nandinfo.txt"+"temp\ModMii_Log_temp.txt" "temp\nandinfo.txt">nul
move /y "temp\nandinfo.txt" "%nandpath%\nandinfo.txt">nul
:noproblems


::---------------CMD LINE MODE-------------
if /i "%cmdlinemode%" NEQ "Y" goto:notcmdfinish
if exist support\settings.bak move /y support\settings.bak support\settings.bat>nul


if /i "%problematicDLs%" EQU "0" exit
support\sfk filter -quiet "temp\ModMii_Log.bat" -rep _"support\sfk echo "__ -rep _"echo "__ -rep _"[Red]"__ -write -yes
move /y "temp\ModMii_Log.bat" "temp\ModMii_CMD_LINE_Log_Errors.txt">nul
if /i "%SKINmode%" NEQ "Y" start notepad "temp\ModMii_CMD_LINE_Log_Errors.txt"
if /i "%SKINmode%" EQU "Y" start support\wizapp PB CLOSE
exit
:notcmdfinish


echo.
if /i "%SNEEKSELECT%" NEQ "2" goto:skip
if /i "%SNEEKTYPE%" EQU "U" goto:skipsdmsg
if /i "%SNEEKTYPE%" EQU "UD" goto:skipsdmsg
:skip
if /i "%Drive%" EQU "COPY_TO_SD" echo    * Copy the contents of the COPY_TO_SD folder to SD Card
if /i "%Drive%" NEQ "COPY_TO_SD" echo    * Make sure that %DRIVE% is your SD card Drive Letter
if /i "%Drive%" NEQ "COPY_TO_SD" echo    * If %DRIVE% is not your SD card Drive Letter, copy the contents of
if /i "%Drive%" NEQ "COPY_TO_SD" echo      the %DRIVE% folder to your SD card
:skipsdmsg

if /i "%SNEEKTYPE%" EQU "UD" goto:UDRIVEMSG
if /i "%SNEEKTYPE%" NEQ "U" goto:skipUDRIVEMSG
:UDRIVEMSG
if /i "%DRIVEU%" EQU "COPY_TO_USB" echo    * Copy the contents of the COPY_TO_USB folder to FAT32 Hard Drive
if /i "%DRIVEU%" NEQ "COPY_TO_USB" echo    * Make sure that %DRIVEU% is your USB HDD Drive Letter
if /i "%DRIVEU%" NEQ "COPY_TO_USB" echo    * If %DRIVEU% is not your USB HDD Drive Letter, copy the contents of
if /i "%DRIVEU%" NEQ "COPY_TO_USB" echo      the %DRIVEU% folder to your USB Hard Drive
:skipUDRIVEMSG


echo.
echo    THINGS YOU NEED TO KNOW ABOUT SNEEK:
echo.
echo        * If you have problems with S/UNEEK or Mighty Channels, copy cert.sys
echo          from an original nand dump to your emulated nand's sys folder.
echo.
echo        * When launching any form of SNEEK for the first time,
echo          it could take a long time to load the System Menu,
echo          but it will be much quicker the second time around.
echo.

if /i "%SNKcBC%" NEQ "DML" goto:skipDMLmsg
echo        * Install the DML WAD using MMM to your
echo          REAL NAND in order for your Emulated NAND to use DML. DML currently
echo          requires SNEEK+DI r157 or higher and neek2o has yet to support DML.
echo.
:skipDMLmsg

if /i "%SNKS2U%" EQU "Y" goto:quickskip
echo        * Install the neek2o channel using MMM then launch the channel
echo          in order to start NEEK. You can also use this channel to return
echo          to your real NAND.
echo.
echo        * If you have BootMii as Boot2, SNEEK can be started immediately
echo          when the Wii powers on by renaming the BootMiiNeek folder to
echo          BootMii on the SD Card.
echo.
:quickskip

if /i "%SNKS2U%" NEQ "Y" goto:quickskip
echo        * Access UNEEK/UNEEK+DI by launching switch2uneek from the
echo          Homebrew Channel. Alternatively, can use MMM to install the
echo          switch2uneek forwarder channel that ModMii saved to your SD card.
echo.
:quickskip

echo        * When using SNEEK+DI or UNEEK+DI, you can access the Game/DI Menu
echo          by pressing "1" on the WiiMote. To access other settings
echo          (including Region Options), you must press "+" from within the DI Menu.
echo.

echo        * To add Games to the Game/DI Menu, you can use ModMii to extract
echo          Wii Games to your FAT32 USB External Hard Drive.
if /i "%neek2o%" EQU "on" echo          neek2o is also able to load games from USB:\WBFS
if /i "%neek2o%" EQU "on" echo          which means you can also use WiiBackupManager.
echo.
echo        * ShowMiiWads can be used to decrypt your real Wii's BootMii NAND
echo          dump (nand.bin) to use as an emulated NAND, and it can add custom
echo          channels/WADs to an emulated NAND.
echo          ShowMiiWads is available on ModMii's Download Page 2.
echo.
echo        * For more SNEEK info, like formatting a USB Hard Drive for SNEEK,
echo          or installing the HBC to an emulated NAND, visit: tinyurl.com/SNEEK-DI
echo.





::---------------CMD LINE MODE-------------
if /i "%cmdlinemode%" NEQ "Y" goto:notcmdfinish
if exist support\settings.bak move /y support\settings.bak support\settings.bat>nul
echo After Reviewing Your Tips - Press Any Key to Exit
pause>nul
exit
:notcmdfinish

if /i "%SNEEKSELECT%" EQU "1" goto:miniskip
if /i "%SNEEKSELECT%" EQU "4" goto:miniskip
if exist "%nandpath%\nandinfo.txt" start notepad "%nandpath%\nandinfo.txt"
:miniskip

echo Press any key to return to the Main Menu.
pause>nul

goto:MENU





::.........................................FINISH / Verify..................................
:FINISH

if exist temp\DLnames.txt del temp\DLnames.txt>nul
if exist temp\DLgotos.txt del temp\DLgotos.txt>nul

set played=

if /i "%MENU1%" EQU "S" goto:wad2nand



:FINISH2

if /i "%MENUREAL%" EQU "S" goto:finishsneekinstall3

setlocal ENABLEDELAYEDEXPANSION
set loglines=0

if /i "%DB%" EQU "C" goto:countcustom
if not exist temp\ModMii_Log.bat goto:donecounting
support\sfk filter -quiet "temp\ModMii_Log.bat" -rep _"""__ -write -yes
for /f "delims=" %%i in (temp\ModMii_Log.bat) do set /a loglines=!loglines!+1

::count # of problematic downloads
copy /y "temp\ModMii_Log.bat" "temp\ModMii_Log_Red.bat">nul
support\sfk filter -quiet "temp\ModMii_Log_Red.bat" -+"[Red]" -write -yes
set problematicDLs=0
for /f "delims=" %%i in (temp\ModMii_Log_Red.bat) do set /a problematicDLs=!problematicDLs!+1
del "temp\ModMii_Log_Red.bat">nul
goto:donecounting

:countcustom
if exist Custom.md5 for /f "delims=" %%i in (Custom.md5) do set /a loglines=!loglines!+1

:donecounting

::resize window
SET /a LINES=%loglines%+25
if %LINES% LEQ 54 set lines=54
mode con cols=85 lines=%LINES%

setlocal DISABLEDELAYEDEXPANSION


::check ACTUAL drive letter
::SD
if /i "%DRIVE:~1,1%" NEQ ":" (set ActualDrive=%cd:~0,2%) else (set ActualDrive=%DRIVE:~0,2%)
if /i "%ActualDrive%" EQU "%cd:~0,2%" (set DrivesNeedingFreeSpace=%ActualDrive%) else (set DrivesNeedingFreeSpace=%ActualDrive% and %cd:~0,2%)


::USB
if /i "%USBCONFIG%" NEQ "USB" goto:skip
if /i "%DRIVEU:~1,1%" NEQ ":" (set ActualDriveU=%cd:~0,2%) else (set ActualDriveU=%DRIVEU:~0,2%)
if /i "%ActualDriveU%" EQU "%cd:~0,2%" goto:skip
if /i "%ActualDriveU%" EQU "%ActualDrive%" goto:skip
set DrivesNeedingFreeSpace=%DrivesNeedingFreeSpace% and %ActualDriveU%
:skip

if /i "%DB%" EQU "C" goto:noaudio
if /i "%SKINmode%" EQU "Y" goto:noaudio
if /i "%AudioOption%" NEQ "on" goto:noaudio
if /i "%played%" EQU "yes" goto:noaudio
if /i "%problematicDLs%" EQU "0" (start support\nircmd.exe mediaplay 3000 "support\Success.mp3") else (start support\nircmd.exe mediaplay 3000 "support\Fail.mp3")
set played=yes
:noaudio


::---------------CMD LINE MODE-------------
if /i "%cmdlinemode%" NEQ "Y" goto:notcmdfinish
if exist support\settings.bak move /y support\settings.bak support\settings.bat>nul

if /i "%problematicDLs%" EQU "0" echo * %DLTOTAL% file(s) downloaded succcessfully>>temp\ModMii_Log.bat
if /i "%problematicDLs%" EQU "0" goto:noproblemscmd
echo * %problematicDLs% of %DLTOTAL% file(s) are Invalid, Missing or were Not Updated properly>>temp\ModMii_Log.bat
:noproblemscmd

support\sfk filter -quiet "temp\ModMii_Log.bat" -rep _"support\sfk echo "__ -rep _"echo "__ -rep _"[Red]"__ -write -yes
move /y "temp\ModMii_Log.bat" "temp\ModMii_CMD_LINE_Log.txt">nul

if /i "%SKINmode%" EQU "Y" (start support\wizapp PB CLOSE) & (exit)
if /i "%problematicDLs%" NEQ "0" start notepad "temp\ModMii_CMD_LINE_Log.txt"
exit
:notcmdfinish



Set FINISH=
cls

echo                                        ModMii                                v%currentversion%
echo                                       by XFlak
echo.
if /i "%DB%" EQU "N" echo                                     DOWNLOAD LOG
if /i "%DB%" EQU "C" echo                              DOWNLOAD LOG - Custom Log
echo.

If not exist Custom.md5 goto:SkipCustomCheck
if /i "%DB%" NEQ "C" goto:SkipCustomCheck
support\fvc -x -v Custom.md5
:SkipCustomCheck

if /i "%DB%" NEQ "N" goto:miniskip
if exist temp\ModMii_Log.bat (call temp\ModMii_Log.bat)
:miniskip

if /i "%DB%" EQU "C" goto:skipcopytoSDmsg

echo.


if /i "%problematicDLs%" EQU "0" (support\sfk echo -spat \x20 \x20[Green]* %DLTOTAL% file\x28s\x29 downloaded succcessfully) & (goto:noproblems)

:problems
support\sfk echo -spat \x20 \x20[Red]* %problematicDLs% of %DLTOTAL% file\x28s\x29 are Invalid, Missing or were Not Updated properly
echo.
echo    * Make sure you have free space here: %DrivesNeedingFreeSpace%
echo      Check internet connection (try disabling firewall/bypasing proxy if applicable)
echo      It is recommended you select "R" to repeat download.
goto:skipcopytoSDmsg

:noproblems
if /i "%USBCONFIG%" EQU "USB" goto:skipcopytoSDmsg
echo.
if /i "%Drive%" EQU "COPY_TO_SD" echo    * Copy the contents of the COPY_TO_SD folder to your SD Card
if /i "%Drive%" NEQ "COPY_TO_SD" echo    * Make sure that %DRIVE% is your SD card Drive Letter
if /i "%Drive%" NEQ "COPY_TO_SD" echo    * If %DRIVE% is not your SD card Drive Letter,
if /i "%Drive%" NEQ "COPY_TO_SD" echo      copy the contents of the %DRIVE% folder to your SD card
:skipcopytoSDmsg


::Warning message for 2x Bannerbomb DLs
if /i "%BB1%" NEQ "*" goto:no2xBB
if /i "%BB2%" NEQ "*" goto:no2xBB
echo.
echo    Note: Bannerbomb v1 saved to "private" folder and Bannerbomb v2 saved to
echo          "private2" folder. To use Bannerbomb v2 instead of v1 swap the
echo          private folder names.
:no2xBB


echo.
echo.






if exist "%DRIVE%" echo          O = Open File Location (%Drive%)

if /i "%DB%" NEQ "C" goto:miniskip
if exist custom.md5 echo          L = Log: View custom.md5 to see which files were checked
:miniskip

if /i "%DLTOTAL%" EQU "0" goto:dltotaliszero
echo.
echo          R = Repeat Download
echo          S = Save Download Queue
:dltotaliszero

echo.

if /i "%DB%" EQU "N" goto:miniskip
if exist temp\ModMii_Log.bat echo          N = Verify NEW Downloads only
:miniskip
if /i "%DB%" EQU "C" goto:miniskip
if exist Custom.md5 echo          C = Verify Files against Custom.md5
:miniskip

if exist CUSTOM_COPY_TO_SD goto:tinyskip
if exist CUSTOM_COPY_TO_USB (goto:tinyskip) else (goto:nocustoms)
:tinyskip
echo.
if exist CUSTOM_COPY_TO_SD echo         CC = Copy Contents of CUSTOM_COPY_TO_SD to %Drive%
if exist CUSTOM_COPY_TO_USB echo        CCU = Copy Contents of CUSTOM_COPY_TO_USB to %DriveU%
:nocustoms


echo.
echo          M = Main Menu
echo          E = Exit
echo.
set /p FINISH=     Enter Selection Here: 



if /i "%FINISH%" NEQ "CC" goto:miniskip
if not exist CUSTOM_COPY_TO_SD goto:miniskip
if not exist "%DRIVE%" mkdir "%DRIVE%" >nul
xcopy /y /e "CUSTOM_COPY_TO_SD" "%DRIVE%"
goto:FINISH2
:miniskip

if /i "%FINISH%" NEQ "CCU" goto:miniskip
if not exist CUSTOM_COPY_TO_USB goto:miniskip
if not exist "%DRIVEU%" mkdir "%DRIVEU%" >nul
xcopy /y /e "CUSTOM_COPY_TO_USB" "%DRIVEU%"
goto:FINISH2
:miniskip


if /i "%FINISH%" EQU "M" goto:MENU
if /i "%FINISH%" EQU "E" EXIT

if not exist "%DRIVE%" goto:drivedoesnotexist2
if /i "%FINISH%" EQU "O" explorer "%DRIVE%"
if /i "%FINISH%" EQU "O" goto:Finish2
:drivedoesnotexist2

if /i "%DB%" NEQ "C" goto:nolog
if not exist "custom.md5" goto:nolog
if /i "%FINISH%" EQU "L" start notepad "custom.md5"
if /i "%FINISH%" EQU "L" goto:Finish2
:nolog

if not exist Custom.md5 goto:skip
if /i "%FINISH%" EQU "C" SET DB=C
if /i "%FINISH%" EQU "C" goto:Finish2
:skip

if not exist temp\ModMii_Log.bat goto:skip
if /i "%FINISH%" EQU "N" SET DB=N
if /i "%FINISH%" EQU "N" goto:FINISH2
:skip

if /i "%DLTOTAL%" EQU "0" goto:dltotaliszero2


if /i "%FINISH%" EQU "R" copy /y "temp\DLgotos-copy.txt" "temp\DLgotos.txt">nul
if /i "%FINISH%" EQU "R" mode con cols=85 lines=54
if /i "%FINISH%" EQU "R" goto:DLSettings2
if /i "%FINISH%" EQU "S" (set beforesave=FINISH) & (goto:SaveDownloadQueue)
:dltotaliszero2


echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:FINISH2

::..........................DOWNLOAD SETTINGS................................
:DLSETTINGS
cls

set REALDRIVE=%DRIVE%


if /i "%MENU1%" EQU "W" goto:guide
if /i "%MENU1%" EQU "H" goto:guide
if /i "%MENU1%" EQU "U" goto:guide
if /i "%MENU1%" EQU "SU" goto:guide
if /i "%MENU1%" EQU "RC" goto:guide

if /i "%secondrun%" EQU "Y" goto:DLSETTINGS2
if /i "%AbstinenceWiz%" EQU "Y" goto:guide

:DLSETTINGS2
cls
if exist temp\ModMii_Log_SNK.bat goto:donotdeletelog
if exist temp\ModMii_Log.bat del temp\ModMii_Log.bat>nul
:donotdeletelog
SET CURRENTDL=0


:DLSETTINGS3
::clear a bunch of stuff
set name=
set wadname=
set dlname=
set ciosslot=
set ciosversion=
set md5=
set md5alt=
set basewad=none
set basewadb=none
set md5base=
set md5basealt=
set code1=
set code2=
set version=
set md5baseb=
set md5basebalt=
set code1b=
set code2b=
set path1=
set versionb=
set basecios=
set diffpath=
set code2new=
set lastbasemodule=
set category=
set wadnameless=
set patchname=
set slotname=
set slotcode=
set versionname=
set versioncode=
set DEC=
set VERFINAL=
set HEX=
set VER=
set wadfolder=
set verfinal=
set PATCHCODE=
set alreadyexists=
set patch=
set multiplefail=
set AdvancedDownload=

if not exist temp\DLgotos.txt goto:FINISH
::Loop through the the following once for EACH line in *.txt
for /F "tokens=*" %%A in (temp\DLgotos.txt) do call :processDLnext %%A
goto:Finish

:processDLnext
set CurrentDLNAME=%*

::if /i "%name:~0,17%" EQU "Advanced Download" set AdvancedDownload=Y

if /i "%CurrentDLNAME:~-4%" EQU ".bat" set AdvancedDownload=Y
if /i "%CurrentDLNAME:~-4%" EQU ".bat" call "%CurrentDLNAME%"
if /i "%CurrentDLNAME:~-4%" EQU ".bat" goto:downloadstart
goto:%CurrentDLNAME%
::goto:EOF

cls


:EULAU
set name=EULA v3 (USA)
set code1=00010008
set code2=48414B45
set version=3
set wadname=EULA-NUS-v3[U].wad
set md5=f30393cd89cb20007c501efab75dab0c
set md5alt=%md5%
set category=ios
goto:downloadstart

:EULAE
set name=EULA v3 (PAL)
set code1=00010008
set code2=48414B50
set version=3
set wadname=EULA-NUS-v3[E].wad
set md5=e835877a6460beeb0d6756c43a800465
set md5alt=%md5%
set category=ios
goto:downloadstart

:EULAJ
set name=EULA v3 (JAP)
set code1=00010008
set code2=48414B4A
set version=3
set wadname=EULA-NUS-v3[J].wad
set md5=1b73948a1b3729cd29f0939652e856b3
set md5alt=%md5%
set category=ios
goto:downloadstart

:EULAK
set name=EULA v3 (KOR)
set code1=00010008
set code2=48414B4B
set version=3
set wadname=EULA-NUS-v3[K].wad
set md5=21c48127696cf028a3bc19b3d34aef11
set md5alt=%md5%
set category=ios
goto:downloadstart

:RSU
set name=Region Select v2 (USA)
set code1=00010008
set code2=48414C45
set version=2
set wadname=Region-Select-NUS-v2[U].wad
set md5=27950cf84c554a851c42c33688f301c5
set md5alt=%md5%
set category=ios
goto:downloadstart

:RSE
set name=Region Select v2 (PAL)
set code1=00010008
set code2=48414C50
set version=2
set wadname=Region-Select-NUS-v2[E].wad
set md5=bac3441c6b6aec07a38b4b2cab103a3d
set md5alt=%md5%
set category=ios
goto:downloadstart

:RSJ
set name=Region Select v2 (JAP)
set code1=00010008
set code2=48414C4A
set version=2
set wadname=Region-Select-NUS-v2[J].wad
set md5=982d8507a94fbad1e298b073ba90c16d
set md5alt=%md5%
set category=ios
goto:downloadstart

:RSK
set name=Region Select v2 (KOR)
set code1=00010008
set code2=48414C4B
set version=2
set wadname=Region-Select-NUS-v2[K].wad
set md5=18aee652bc16bc1aa4261400758ac04a
set md5alt=%md5%
set category=ios
goto:downloadstart



:BC
set name=BC
set code1=00000001
set code2=00000100
set version=6
set wadname=BC-NUS-v6.wad
set md5=d1593a77e24ecc95af2b393abe5d92f0
set md5alt=%md5%
set category=ios
goto:downloadstart



:SM4.3U
set name=System Menu 4.3U
set code1=00000001
set code2=00000002
set version=513
set wadname=SystemMenu_4.3U_v513.wad
set md5=4f5c63e3fd1bf732067fa4c439c68a97
set md5alt=%md5%
set category=ios
goto:downloadstart


:SM4.2U
set name=System Menu 4.2U
set code1=00000001
set code2=00000002
set version=481
set wadname=SystemMenu_4.2U_v481.wad
set md5=4ac52b981845473bd3655e4836d7442b
set md5alt=%md5%
set category=ios
goto:downloadstart

:SM4.1U
set name=System Menu 4.1U
set code1=00000001
set code2=00000002
set version=449
set wadname=SystemMenu_4.1U_v449.wad
set md5=38a95a9acd257265294be41b796f6239
set md5alt=%md5%
set category=ios
goto:downloadstart

:SM3.2U
set name=System Menu 3.2U
set code1=00000001
set code2=00000002
set version=289
set wadname=SystemMenu_3.2U_v289.wad
set md5=7514582f06126aee897fc2b2e9185980
set md5alt=%md5%
set category=ios
goto:downloadstart

:SM4.3E
set name=System Menu 4.3E
set code1=00000001
set code2=00000002
set version=514
set wadname=SystemMenu_4.3E_v514.wad
set md5=2ec2e6fbdfc52fe5174749e7032f1bad
set md5alt=%md5%
set category=ios
goto:downloadstart

:SM4.2E
set name=System Menu 4.2E
set code1=00000001
set code2=00000002
set version=482
set wadname=SystemMenu_4.2E_v482.wad
set md5=7d77be8b6df5ac893d24652db33d02cd
set md5alt=%md5%
set category=ios
goto:downloadstart

:SM4.1E
set name=System Menu 4.1E
set code1=00000001
set code2=00000002
set version=450
set wadname=SystemMenu_4.1E_v450.wad
set md5=688cc78b8eab4e30da04f01a81a3739f
set md5alt=%md5%
set category=ios
goto:downloadstart

:SM3.2E
set name=System Menu 3.2E
set code1=00000001
set code2=00000002
set version=290
set wadname=SystemMenu_3.2E_v290.wad
set md5=5f0ff5a2b160f5340ccf74118edc9e33
set md5alt=%md5%
set category=ios
goto:downloadstart

:SM4.3J
set name=System Menu 4.3J
set code1=00000001
set code2=00000002
set version=512
set wadname=SystemMenu_4.3J_v512.wad
set md5=df67ed4bd8f8f117741fef7952ee5c17
set md5alt=%md5%
set category=ios
goto:downloadstart

:SM4.2J
set name=System Menu 4.2J
set code1=00000001
set code2=00000002
set version=480
set wadname=SystemMenu_4.2J_v480.wad
set md5=0413a9aed208b193fea85db908bbdabf
set md5alt=%md5%
set category=ios
goto:downloadstart

:SM4.1J
set name=System Menu 4.1J
set code1=00000001
set code2=00000002
set version=448
set wadname=SystemMenu_4.1J_v448.wad
set md5=6edb4b3f7ca26c643c6bc662d159ec2e
set md5alt=%md5%
set category=ios
goto:downloadstart

:SM3.2J
set name=System Menu 3.2J
set code1=00000001
set code2=00000002
set version=288
set wadname=SystemMenu_3.2J_v288.wad
set md5=907e4901a936337bd7188c82d449eae0
set md5alt=%md5%
set category=ios
goto:downloadstart


:SM4.3K
set name=System Menu 4.3K
set code1=00000001
set code2=00000002
set version=518
set wadname=SystemMenu_4.3K_v518.wad
set md5=6ed8f9e75b0a54eacfbacce57c20136d
set md5alt=%md5%
set category=ios
goto:downloadstart


:SM4.2K
set name=System Menu 4.2K
set code1=00000001
set code2=00000002
set version=486
set wadname=SystemMenu_4.2K_v486.wad
set md5=40c0bf90ea07b02d610edae1d7aea39f
set md5alt=%md5%
set category=ios
goto:downloadstart

:SM4.1K
set name=System Menu 4.1K
set code1=00000001
set code2=00000002
set version=454
set wadname=SystemMenu_4.1K_v454.wad
set md5=c0e5d5c4914e76e7df7495ccf28ef869
set md5alt=%md5%
set category=ios
goto:downloadstart


::System Menu wads with embedded Themes

:SM4.3U-DWR
set name=System Menu 4.3U with Dark Wii Red Theme - %effect%
set wadname=SystemMenu_4.3U_v513_DarkWiiRed_%effect%
set ciosslot=unchanged
if /i "%effect%" EQU "No-Spin" set md5=948c6bf88b44a3982465efe51c6a41b2
if /i "%effect%" EQU "Spin" set md5=186fb42766546bd0db960627cefa40ca
if /i "%effect%" EQU "Fast-Spin" set md5=3fbe41cbb391e4241dbbceb3484e96f1
set md5alt=%md5%
set basewad=SystemMenu_4.3U_v513
set basecios=%basewad%
set md5base=4f5c63e3fd1bf732067fa4c439c68a97
set md5basealt=%md5base%
set code1=00000001
set code2=00000002
set mym1=DarkWii_Red_No-Spin_4.XU_V2.mym
set md5mym1=d25623ec4c687bb528fad499f385983f
set version=513
set lastbasemodule=00000001
set category=SMTHEME
goto:downloadstart

:SM4.2U-DWR
set name=System Menu 4.2U with Dark Wii Red Theme - %effect%
set wadname=SystemMenu_4.2U_v481_DarkWiiRed_%effect%
set ciosslot=unchanged
if /i "%effect%" EQU "No-Spin" set md5=24947a4407e53902c0c2e21b7b8d3381
if /i "%effect%" EQU "Spin" set md5=a5b511818dd25aa89bee06db2e88bca7
if /i "%effect%" EQU "Fast-Spin" set md5=b60f281761041dee2ac5a7017ac3f176
set md5alt=%md5%
set basewad=SystemMenu_4.2U_v481
set basecios=%basewad%
set md5base=4ac52b981845473bd3655e4836d7442b
set md5basealt=%md5base%
set code1=00000001
set code2=00000002
set mym1=DarkWii_Red_No-Spin_4.XU_V2.mym
set md5mym1=d25623ec4c687bb528fad499f385983f
set version=481
set lastbasemodule=00000001
set category=SMTHEME
goto:downloadstart

:SM4.1U-DWR
set name=System Menu 4.1U with Dark Wii Red Theme - %effect%
set wadname=SystemMenu_4.1U_v449_DarkWiiRed_%effect%
set ciosslot=unchanged
if /i "%effect%" EQU "No-Spin" set md5=9f21f5745ff5ae0ba2e48facf194624b
if /i "%effect%" EQU "Spin" set md5=8f48949c75fafb1eabd479347de77101
if /i "%effect%" EQU "Fast-Spin" set md5=9cccec585a9b251ac747dec8bbe60eea
set md5alt=%md5%
set basewad=SystemMenu_4.1U_v449
set basecios=%basewad%
set md5base=38a95a9acd257265294be41b796f6239
set md5basealt=%md5base%
set code1=00000001
set code2=00000002
set mym1=DarkWii_Red_No-Spin_4.XU_V2.mym
set md5mym1=d25623ec4c687bb528fad499f385983f
set version=449
set lastbasemodule=00000001
set category=SMTHEME
goto:downloadstart

:SM4.3E-DWR
set name=System Menu 4.3E with Dark Wii Red Theme - %effect%
set wadname=SystemMenu_4.3E_v514_DarkWiiRed_%effect%
set ciosslot=unchanged
if /i "%effect%" EQU "No-Spin" set md5=65e6a6ca89618c285b0229529649ccf4
if /i "%effect%" EQU "Spin" set md5=da47de9056100ea9c61b112a63df6ffa
if /i "%effect%" EQU "Fast-Spin" set md5=5006a5c030fff7bf998a38a23017149f
set md5alt=%md5%
set basewad=SystemMenu_4.3E_v514
set basecios=%basewad%
set md5base=2ec2e6fbdfc52fe5174749e7032f1bad
set md5basealt=%md5base%
set code1=00000001
set code2=00000002
set mym1=DarkWii_Red_No-Spin_4.XE_V2.mym
set md5mym1=543130dbc6ece1d4a666586ed084d714
set version=514
set lastbasemodule=00000001
set category=SMTHEME
goto:downloadstart

:SM4.2E-DWR
set name=System Menu 4.2E with Dark Wii Red Theme - %effect%
set wadname=SystemMenu_4.2E_v482_DarkWiiRed_%effect%
set ciosslot=unchanged
if /i "%effect%" EQU "No-Spin" set md5=467c51cd0c2eb30682ba8f696e8d0fcc
if /i "%effect%" EQU "Spin" set md5=9025889c4478a8fb8a3f6c4fbb1903a5
if /i "%effect%" EQU "Fast-Spin" set md5=dee18f0bdd63f259860e5bf2a57f6e32
set md5alt=%md5%
set basewad=SystemMenu_4.2E_v482
set basecios=%basewad%
set md5base=7d77be8b6df5ac893d24652db33d02cd
set md5basealt=%md5base%
set code1=00000001
set code2=00000002
set mym1=DarkWii_Red_No-Spin_4.XE_V2.mym
set md5mym1=543130dbc6ece1d4a666586ed084d714
set version=482
set lastbasemodule=00000001
set category=SMTHEME
goto:downloadstart

:SM4.1E-DWR
set name=System Menu 4.1E with Dark Wii Red Theme - %effect%
set wadname=SystemMenu_4.1E_v450_DarkWiiRed_%effect%
set ciosslot=unchanged
if /i "%effect%" EQU "No-Spin" set md5=e8d7b4818311d2c8f76d13770b9c7c09
if /i "%effect%" EQU "Spin" set md5=cf35e863536098419eee8e860fc27e42
if /i "%effect%" EQU "Fast-Spin" set md5=fc730f01cc8622842687bdd41b265794
set md5alt=%md5%
set basewad=SystemMenu_4.1E_v450
set basecios=%basewad%
set md5base=688cc78b8eab4e30da04f01a81a3739f
set md5basealt=%md5base%
set code1=00000001
set code2=00000002
set mym1=DarkWii_Red_No-Spin_4.XE_V2.mym
set md5mym1=543130dbc6ece1d4a666586ed084d714
set version=450
set lastbasemodule=00000001
set category=SMTHEME
goto:downloadstart

:SM4.3J-DWR
set name=System Menu 4.3J with Dark Wii Red Theme - %effect%
set wadname=SystemMenu_4.3J_v512_DarkWiiRed_%effect%
set ciosslot=unchanged
if /i "%effect%" EQU "No-Spin" set md5=41ee875e0bd8985f8d3c845c3be19fc5
if /i "%effect%" EQU "Spin" set md5=e678615ed5627ee0f1f623cf315b2ea3
if /i "%effect%" EQU "Fast-Spin" set md5=39c0979b2d70d379d172a07484b74a12
set md5alt=%md5%
set basewad=SystemMenu_4.3J_v512
set basecios=%basewad%
set md5base=df67ed4bd8f8f117741fef7952ee5c17
set md5basealt=%md5base%
set code1=00000001
set code2=00000002
set mym1=DarkWii_Red_No-Spin_4.XJ_V2.mym
set md5mym1=ff34815d750afa045381a922366e85e2
set version=512
set lastbasemodule=00000001
set category=SMTHEME
goto:downloadstart

:SM4.2J-DWR
set name=System Menu 4.2J with Dark Wii Red Theme - %effect%
set wadname=SystemMenu_4.2J_v480_DarkWiiRed_%effect%
set ciosslot=unchanged
if /i "%effect%" EQU "No-Spin" set md5=dcca20b12149f8adedabe6f7a27993dd
if /i "%effect%" EQU "Spin" set md5=9ba3ff06951b08eadd738e200c946a12
if /i "%effect%" EQU "Fast-Spin" set md5=7cccf0921592d3a905b8f98be371a528
set md5alt=%md5%
set basewad=SystemMenu_4.2J_v480
set basecios=%basewad%
set md5base=0413a9aed208b193fea85db908bbdabf
set md5basealt=%md5base%
set code1=00000001
set code2=00000002
set mym1=DarkWii_Red_No-Spin_4.XJ_V2.mym
set md5mym1=ff34815d750afa045381a922366e85e2
set version=480
set lastbasemodule=00000001
set category=SMTHEME
goto:downloadstart

:SM4.1J-DWR
set name=System Menu 4.1J with Dark Wii Red Theme - %effect%
set wadname=SystemMenu_4.1J_v448_DarkWiiRed_%effect%
set ciosslot=unchanged
if /i "%effect%" EQU "No-Spin" set md5=134b31aa8aea0e9a740084ee5c3f2004
if /i "%effect%" EQU "Spin" set md5=aa2a0473ecfff7946ac5218e22ed4609
if /i "%effect%" EQU "Fast-Spin" set md5=9897510d88c3626151181510fed01cfb
set md5alt=%md5%
set basewad=SystemMenu_4.1J_v448
set basecios=%basewad%
set md5base=6edb4b3f7ca26c643c6bc662d159ec2e
set md5basealt=%md5base%
set code1=00000001
set code2=00000002
set mym1=DarkWii_Red_No-Spin_4.XJ_V2.mym
set md5mym1=ff34815d750afa045381a922366e85e2
set version=448
set lastbasemodule=00000001
set category=SMTHEME
goto:downloadstart


:SM4.3K-DWR
set name=System Menu 4.3K with Dark Wii Red Theme - %effect%
set wadname=SystemMenu_4.3K_v518_DarkWiiRed_%effect%
set ciosslot=unchanged
if /i "%effect%" EQU "No-Spin" set md5=56c992a32248438d0096362285c27a79
if /i "%effect%" EQU "Spin" set md5=9b7875eac578c09c12c4f34cd7e28fc6
if /i "%effect%" EQU "Fast-Spin" set md5=fd0ab2155825e6716813d278e51bd093
set md5alt=%md5%
set basewad=SystemMenu_4.3K_v518
set basecios=%basewad%
set md5base=6ed8f9e75b0a54eacfbacce57c20136d
set md5basealt=%md5base%
set code1=00000001
set code2=00000002
set mym1=DarkWii_Red_No-Spin_4.XK_V2.mym
set md5mym1=39621a542fb6870286c0fb672084ab05
set version=518
set lastbasemodule=00000001
set category=SMTHEME
goto:downloadstart

:SM4.2K-DWR
set name=System Menu 4.2K with Dark Wii Red Theme - %effect%
set wadname=SystemMenu_4.2K_v486_DarkWiiRed_%effect%
set ciosslot=unchanged
if /i "%effect%" EQU "No-Spin" set md5=4d222b2db1cc936b6067268210d64f3a
if /i "%effect%" EQU "Spin" set md5=5eefeacc33cfab5e465c5555d5c5291f
if /i "%effect%" EQU "Fast-Spin" set md5=1dabf7b6d79cd02df131b87378f97332
set md5alt=%md5%
set basewad=SystemMenu_4.2K_v486
set basecios=%basewad%
set md5base=40c0bf90ea07b02d610edae1d7aea39f
set md5basealt=%md5base%
set code1=00000001
set code2=00000002
set mym1=DarkWii_Red_No-Spin_4.XK_V2.mym
set md5mym1=39621a542fb6870286c0fb672084ab05
set version=486
set lastbasemodule=00000001
set category=SMTHEME
goto:downloadstart

:SM4.1K-DWR
set name=System Menu 4.1K with Dark Wii Red Theme - %effect%
set wadname=SystemMenu_4.1K_v454_DarkWiiRed_%effect%
set ciosslot=unchanged
if /i "%effect%" EQU "No-Spin" set md5=0e6caeaf42482f921d75657a086594a9
if /i "%effect%" EQU "Spin" set md5=acf1fda221555b399087a223bf7076d0
if /i "%effect%" EQU "Fast-Spin" set md5=d5ed6ce37250bcf2f06a56356b08e410
set md5alt=%md5%
set basewad=SystemMenu_4.1K_v454
set basecios=%basewad%
set md5base=c0e5d5c4914e76e7df7495ccf28ef869
set md5basealt=%md5base%
set code1=00000001
set code2=00000002
set mym1=DarkWii_Red_No-Spin_4.XK_V2.mym
set md5mym1=39621a542fb6870286c0fb672084ab05
set version=454
set lastbasemodule=00000001
set category=SMTHEME
goto:downloadstart

:SM4.3U-DWG
set name=System Menu 4.3U with Dark Wii Green Theme - %effect%
set wadname=SystemMenu_4.3U_v513_DarkWiiGreen_%effect%
set ciosslot=unchanged
if /i "%effect%" EQU "No-Spin" set md5=6df85caaff6698aa05a3b3706b8cd2ce
if /i "%effect%" EQU "Spin" set md5=008c57387d95851408bf50c1d98fa9a6
if /i "%effect%" EQU "Fast-Spin" set md5=35343c2abdd52655c59fa9576a6de6dc
set md5alt=%md5%
set basewad=SystemMenu_4.3U_v513
set basecios=%basewad%
set md5base=4f5c63e3fd1bf732067fa4c439c68a97
set md5basealt=%md5base%
set code1=00000001
set code2=00000002
set mym1=DarkWii_Green_No-Spin_4.XU_V2.mym
set md5mym1=69cbc2704736d99c2011d023794b0ac0
set version=513
set lastbasemodule=00000001
set category=SMTHEME
goto:downloadstart

:SM4.2U-DWG
set name=System Menu 4.2U with Dark Wii Green Theme - %effect%
set wadname=SystemMenu_4.2U_v481_DarkWiiGreen_%effect%
set ciosslot=unchanged
if /i "%effect%" EQU "No-Spin" set md5=c22b700e3ae95d0e168e0eb79ab6631b
if /i "%effect%" EQU "Spin" set md5=4273134c4f12d58bd06e32fdc14b00f4
if /i "%effect%" EQU "Fast-Spin" set md5=6ce407213cb4e4739ef5fe3ab1d21cf1
set md5alt=%md5%
set basewad=SystemMenu_4.2U_v481
set basecios=%basewad%
set md5base=4ac52b981845473bd3655e4836d7442b
set md5basealt=%md5base%
set code1=00000001
set code2=00000002
set mym1=DarkWii_Green_No-Spin_4.XU_V2.mym
set md5mym1=69cbc2704736d99c2011d023794b0ac0
set version=481
set lastbasemodule=00000001
set category=SMTHEME
goto:downloadstart

:SM4.1U-DWG
set name=System Menu 4.1U with Dark Wii Green Theme - %effect%
set wadname=SystemMenu_4.1U_v449_DarkWiiGreen_%effect%
set ciosslot=unchanged
if /i "%effect%" EQU "No-Spin" set md5=01a1759216f9849b3abde6242fcc4b5a
if /i "%effect%" EQU "Spin" set md5=5daa457e3a1cedff13e306429739695c
if /i "%effect%" EQU "Fast-Spin" set md5=68aee48bb14791b85b4fde71866e6eed
set md5alt=%md5%
set basewad=SystemMenu_4.1U_v449
set basecios=%basewad%
set md5base=38a95a9acd257265294be41b796f6239
set md5basealt=%md5base%
set code1=00000001
set code2=00000002
set mym1=DarkWii_Green_No-Spin_4.XU_V2.mym
set md5mym1=69cbc2704736d99c2011d023794b0ac0
set version=449
set lastbasemodule=00000001
set category=SMTHEME
goto:downloadstart

:SM4.3E-DWG
set name=System Menu 4.3E with Dark Wii Green Theme - %effect%
set wadname=SystemMenu_4.3E_v514_DarkWiiGreen_%effect%
set ciosslot=unchanged
if /i "%effect%" EQU "No-Spin" set md5=5e39cb21fba828a8190e785b95c8206f
if /i "%effect%" EQU "Spin" set md5=545a7745ef945474dd0de9206c304cac
if /i "%effect%" EQU "Fast-Spin" set md5=79d6151e19f07772986e0909b3fd6275
set md5alt=%md5%
set basewad=SystemMenu_4.3E_v514
set basecios=%basewad%
set md5base=2ec2e6fbdfc52fe5174749e7032f1bad
set md5basealt=%md5base%
set code1=00000001
set code2=00000002
set mym1=DarkWii_Green_No-Spin_4.XE_V2.mym
set md5mym1=34c991872b67273307c7bc7aa522b09d
set version=514
set lastbasemodule=00000001
set category=SMTHEME
goto:downloadstart

:SM4.2E-DWG
set name=System Menu 4.2E with Dark Wii Green Theme - %effect%
set wadname=SystemMenu_4.2E_v482_DarkWiiGreen_%effect%
set ciosslot=unchanged
if /i "%effect%" EQU "No-Spin" set md5=251d260ea8d2c7162e84a3574a6ec4bc
if /i "%effect%" EQU "Spin" set md5=9f90d04ad17d19006209515c76c6c756
if /i "%effect%" EQU "Fast-Spin" set md5=d98f173e8cdd68d8fd67ed8d9a7b14b1
set md5alt=%md5%
set basewad=SystemMenu_4.2E_v482
set basecios=%basewad%
set md5base=7d77be8b6df5ac893d24652db33d02cd
set md5basealt=%md5base%
set code1=00000001
set code2=00000002
set mym1=DarkWii_Green_No-Spin_4.XE_V2.mym
set md5mym1=34c991872b67273307c7bc7aa522b09d
set version=482
set lastbasemodule=00000001
set category=SMTHEME
goto:downloadstart

:SM4.1E-DWG
set name=System Menu 4.1E with Dark Wii Green Theme - %effect%
set wadname=SystemMenu_4.1E_v450_DarkWiiGreen_%effect%
set ciosslot=unchanged
if /i "%effect%" EQU "No-Spin" set md5=17071d6c0beb781d17f4ac39beaf06c5
if /i "%effect%" EQU "Spin" set md5=9cd3cb5665646e8444ef9c86f30ac2cc
if /i "%effect%" EQU "Fast-Spin" set md5=97fb3461f3ad86f333809af043ad0b69
set md5alt=%md5%
set basewad=SystemMenu_4.1E_v450
set basecios=%basewad%
set md5base=688cc78b8eab4e30da04f01a81a3739f
set md5basealt=%md5base%
set code1=00000001
set code2=00000002
set mym1=DarkWii_Green_No-Spin_4.XE_V2.mym
set md5mym1=34c991872b67273307c7bc7aa522b09d
set version=450
set lastbasemodule=00000001
set category=SMTHEME
goto:downloadstart

:SM4.3J-DWG
set name=System Menu 4.3J with Dark Wii Green Theme - %effect%
set wadname=SystemMenu_4.3J_v512_DarkWiiGreen_%effect%
set ciosslot=unchanged
if /i "%effect%" EQU "No-Spin" set md5=e2330536840a6f12e5143d23e11fbb02
if /i "%effect%" EQU "Spin" set md5=3f3b0447237dcdf383986af595fa53b7
if /i "%effect%" EQU "Fast-Spin" set md5=17a00cb794c88c68080c21d0014b1918
set md5alt=%md5%
set basewad=SystemMenu_4.3J_v512
set basecios=%basewad%
set md5base=df67ed4bd8f8f117741fef7952ee5c17
set md5basealt=%md5base%
set code1=00000001
set code2=00000002
set mym1=DarkWii_Green_No-Spin_4.XJ_V2.mym
set md5mym1=61a8d22e0211a3c5d09cb4cf61594f7b
set version=512
set lastbasemodule=00000001
set category=SMTHEME
goto:downloadstart

:SM4.2J-DWG
set name=System Menu 4.2J with Dark Wii Green Theme - %effect%
set wadname=SystemMenu_4.2J_v480_DarkWiiGreen_%effect%
set ciosslot=unchanged
if /i "%effect%" EQU "No-Spin" set md5=cd6ef6a86b4f4e5264542fc2d85186d9
if /i "%effect%" EQU "Spin" set md5=7082a58421e10a024e6a0883da7fc7dc
if /i "%effect%" EQU "Fast-Spin" set md5=0676c2f6d11c946ca6f26faa8075da29
set md5alt=%md5%
set basewad=SystemMenu_4.2J_v480
set basecios=%basewad%
set md5base=0413a9aed208b193fea85db908bbdabf
set md5basealt=%md5base%
set code1=00000001
set code2=00000002
set mym1=DarkWii_Green_No-Spin_4.XJ_V2.mym
set md5mym1=61a8d22e0211a3c5d09cb4cf61594f7b
set version=480
set lastbasemodule=00000001
set category=SMTHEME
goto:downloadstart

:SM4.1J-DWG
set name=System Menu 4.1J with Dark Wii Green Theme - %effect%
set wadname=SystemMenu_4.1J_v448_DarkWiiGreen_%effect%
set ciosslot=unchanged
if /i "%effect%" EQU "No-Spin" set md5=a64c214e26bfcae7e728d4509fa47274
if /i "%effect%" EQU "Spin" set md5=9893de0f682e7ab911cd18c63071cf0c
if /i "%effect%" EQU "Fast-Spin" set md5=9203880501ca5243f771e22a07b9e3ec
set md5alt=%md5%
set basewad=SystemMenu_4.1J_v448
set basecios=%basewad%
set md5base=6edb4b3f7ca26c643c6bc662d159ec2e
set md5basealt=%md5base%
set code1=00000001
set code2=00000002
set mym1=DarkWii_Green_No-Spin_4.XJ_V2.mym
set md5mym1=61a8d22e0211a3c5d09cb4cf61594f7b
set version=448
set lastbasemodule=00000001
set category=SMTHEME
goto:downloadstart


:SM4.3K-DWG
set name=System Menu 4.3K with Dark Wii Green Theme - %effect%
set wadname=SystemMenu_4.3K_v518_DarkWiiGreen_%effect%
set ciosslot=unchanged
if /i "%effect%" EQU "No-Spin" set md5=84547c57cbd0f361fbf7d73290b5134e
if /i "%effect%" EQU "Spin" set md5=dde1e404f6f34bdca0a4312f3fc017d2
if /i "%effect%" EQU "Fast-Spin" set md5=7cc3e0f666fb8a91c22f5384a412ddd0
set md5alt=%md5%
set basewad=SystemMenu_4.3K_v518
set basecios=%basewad%
set md5base=6ed8f9e75b0a54eacfbacce57c20136d
set md5basealt=%md5base%
set code1=00000001
set code2=00000002
set mym1=DarkWii_Green_No-Spin_4.XK_V2.mym
set md5mym1=46e8ff2f49142ea3b6877a4a636de941
set version=518
set lastbasemodule=00000001
set category=SMTHEME
goto:downloadstart

:SM4.2K-DWG
set name=System Menu 4.2K with Dark Wii Green Theme - %effect%
set wadname=SystemMenu_4.2K_v486_DarkWiiGreen_%effect%
set ciosslot=unchanged
if /i "%effect%" EQU "No-Spin" set md5=6fc912f8830c6948f8a17155ad298dcb
if /i "%effect%" EQU "Spin" set md5=3ba0c3912a25028e300eba53e47c42ec
if /i "%effect%" EQU "Fast-Spin" set md5=d64b6dc99f69d70638099fb00a252c9b
set md5alt=%md5%
set basewad=SystemMenu_4.2K_v486
set basecios=%basewad%
set md5base=40c0bf90ea07b02d610edae1d7aea39f
set md5basealt=%md5base%
set code1=00000001
set code2=00000002
set mym1=DarkWii_Green_No-Spin_4.XK_V2.mym
set md5mym1=46e8ff2f49142ea3b6877a4a636de941
set version=486
set lastbasemodule=00000001
set category=SMTHEME
goto:downloadstart

:SM4.1K-DWG
set name=System Menu 4.1K with Dark Wii Green Theme - %effect%
set wadname=SystemMenu_4.1K_v454_DarkWiiGreen_%effect%
set ciosslot=unchanged
if /i "%effect%" EQU "No-Spin" set md5=6b9f5710b1cc8de8e02359364265f1ff
if /i "%effect%" EQU "Spin" set md5=fe6bf7532ca2844d2541bfdf1f8a5236
if /i "%effect%" EQU "Fast-Spin" set md5=59c84a8627ff691dcaae53a6fbab0884
set md5alt=%md5%
set basewad=SystemMenu_4.1K_v454
set basecios=%basewad%
set md5base=c0e5d5c4914e76e7df7495ccf28ef869
set md5basealt=%md5base%
set code1=00000001
set code2=00000002
set mym1=DarkWii_Green_No-Spin_4.XK_V2.mym
set md5mym1=46e8ff2f49142ea3b6877a4a636de941
set version=454
set lastbasemodule=00000001
set category=SMTHEME
goto:downloadstart


:MII
set name=MII Channel
set code1=00010002
set code2=48414341
set version=6
set wadname=Mii-Channel-NUS-v6.wad
set md5=5f03c5970ecf064bc520f4a11a0d3a34
set md5alt=%md5%
set category=ios
goto:downloadstart

:PHOTO0
set name=Photo Channel (USA / PAL / JAP / KOR)
set code1=00010002
set code2=48414141
set version=2
set wadname=Photo-Channel-1.0-NUS-v2.wad
set md5=574e6939fe6b0f0bf11b10e6e75ad192
set md5alt=%md5%
set category=ios
goto:downloadstart

:PHOTO
set name=Photo Channel 1.1 (USA / PAL / JAP)
set code1=00010002
set code2=48415941
set version=3
set wadname=Photo-Channel-1.1-NUS-v3.wad
set md5=ba88843d7d5d8090c6cce2c822965299
set md5alt=%md5%
set category=ios
goto:downloadstart

:PHOTO_K
set name=KOREAN Photo Channel 1.1
set code1=00010002
set code2=4841594B
set version=3
set wadname=Photo-Channel-1.1-NUS-v3[K].wad
set md5=a3aa49e803fe297c0e23dd2d6a1467b3
set md5alt=%md5%
set category=ios
goto:downloadstart

:SHOP
set name=Shopping Channel (USA / PAL / JAP)
set code1=00010002
set code2=48414241
set version=21
set wadname=Shopping-Channel-NUS-v21.wad
set md5=7041a8c9f0ee8fd3037f6228ddd6dfc3
set md5alt=%md5%
set category=ios
goto:downloadstart

:SHOP_K
set name=KOREAN Shopping Channel
set code1=00010002
set code2=4841424B
set version=21
set wadname=Shopping-Channel-NUS-v21[K].wad
set md5=b4ed08d8f9ff5fa0a4ba5effacffbc97
set md5alt=%md5%
set category=ios
goto:downloadstart

:NET_U
set name=USA Internet Channel
set code1=00010001
set code2=48414445
set version=1024
set wadname=Opera-Internet-Channel-NUS[U].wad
set md5=434356a447bc01f10ea6a3289521d127
set md5alt=%md5%
set category=ios
goto:downloadstart

:NET_E
set name=PAL Internet Channel
set code1=00010001
set code2=48414450
set version=1024
set wadname=Opera-Internet-Channel-NUS[E].wad
set md5=da20d4d1aedcd4dfa281423f2152ef6e
set md5alt=%md5%
set category=ios
goto:downloadstart

:NET_J
set name=JAP Internet Channel
set code1=00010001
set code2=4841444A
set version=1024
set wadname=Opera-Internet-Channel-NUS[J].wad
set md5=2ed4f8ad0977a3073b8fdfbf76ef1ba8
set md5alt=%md5%
set category=ios
goto:downloadstart

:WEATHER_U
set name=USA Weather Channel
set code1=00010002
set code2=48414645
set version=7
set wadname=Weather-Channel-NUS-v7[U].wad
set md5=3c6c857751770fdcf3a80facbbfe3be4
set md5alt=%md5%
set category=ios
goto:downloadstart

:WEATHER_E
set name=PAL Weather Channel
set code1=00010002
set code2=48414650
set version=7
set wadname=Weather-Channel-NUS-v7[E].wad
set md5=56dd7a5a34cf4ee4ac222eb6bd01c0d9
set md5alt=%md5%
set category=ios
goto:downloadstart

:WEATHER_J
set name=JAP Weather Channel
set code1=00010002
set code2=4841464A
set version=7
set wadname=Weather-Channel-NUS-v7[J].wad
set md5=c9f5ee197779910e71f9f554f7fa64ac
set md5alt=%md5%
set category=ios
goto:downloadstart

:NEWS_U
set name=USA NEWS Channel
set code1=00010002
set code2=48414745
set version=7
set wadname=NEWS-Channel-NUS-v7[U].wad
set md5=c9fff95d6a4ca9f04dcd1fe3b28cc83a
set md5alt=%md5%
set category=ios
goto:downloadstart

:NEWS_E
set name=PAL NEWS Channel
set code1=00010002
set code2=48414750
set version=7
set wadname=NEWS-Channel-NUS-v7[E].wad
set md5=11c713ff825f918bfe2c1065e5ab9827
set md5alt=%md5%
set category=ios
goto:downloadstart

:NEWS_J
set name=JAP NEWS Channel
set code1=00010002
set code2=4841474A
set version=7
set wadname=NEWS-Channel-NUS-v7[J].wad
set md5=15dbd847c9f4b1df53cabe3fad57ad87
set md5alt=%md5%
set category=ios
goto:downloadstart

:SPEAK_U
set name=USA Wii Speak Channel
set code1=00010001
set code2=48434645
set version=512
set wadname=Wii-Speak-Channel-NUS[U].wad
set md5=0c48ace121c73f1703e8790a494712bb
set md5alt=%md5%
set category=ios
goto:downloadstart

:SPEAK_E
set name=PAL Wii Speak Channel
set code1=00010001
set code2=48434650
set version=512
set wadname=Wii-Speak-Channel-NUS[E].wad
set md5=77643094290097a2d237c78ba6e78df6
set md5alt=%md5%
set category=ios
goto:downloadstart

:SPEAK_J
set name=JAP Wii Speak Channel
set code1=00010001
set code2=4843464A
set version=512
set wadname=Wii-Speak-Channel-NUS[J].wad
set md5=a686e2934045eff007a62760272208b8
set md5alt=%md5%
set category=ios
goto:downloadstart

:IOS9
set name=IOS9
set code1=00000001
set code2=00000009
set version=1034
set wadname=IOS9-64-v1034.wad
set md5=b81f3fe9912ac711b3e6423116420bc1
set md5alt=%md5%
set category=ios
goto:downloadstart

:IOS12
set name=IOS12
set code1=00000001
set code2=0000000C
set version=526
set wadname=IOS12-64-v526.wad
set md5=60fad19280c01d5632e5a745da34640a
set md5alt=56e793bb18368b2819251682c92b4b16
set category=ios
goto:downloadstart

:IOS13
set name=IOS13
set code1=00000001
set code2=0000000D
set version=1032
set wadname=IOS13-64-v1032.wad
set md5=861b51f06dbdec73eac60a980313f604
set md5alt=%md5%
set category=ios
goto:downloadstart

:IOS14
set name=IOS14
set code1=00000001
set code2=0000000E
set version=1032
set wadname=IOS14-64-v1032.wad
set md5=48ac1dc132ca31c2520ea1a8dbc321e2
set md5alt=171a3d7fc79e502915bf7654ea3f5204
set category=ios
goto:downloadstart

:IOS15
set name=IOS15 v1032
set code1=00000001
set code2=0000000F
set version=1032
set wadname=IOS15-64-v1032.wad
set md5=4c56fd21ce0c59ad33f70497d504b10a
set md5alt=c9b8f623a294530057ddabd42da79a9b
set category=ios
goto:downloadstart


:IOS17
set name=IOS17
set code1=00000001
set code2=00000011
set version=1032
set wadname=IOS17-64-v1032.wad
set md5=5e73e5bc654d17f60db4f4426be46755
set md5alt=1b8b976c81622181df5508a8ea050cfc
set category=ios
goto:downloadstart

:IOS21
set name=IOS21
set code1=00000001
set code2=00000015
set version=1039
set wadname=IOS21-64-v1039.wad
set md5=c85f2b33b3d96f91e57deefc1dd57eee
set md5alt=86123b565792d5c103b05cd9544f98e1
set category=ios
goto:downloadstart

:IOS22
set name=IOS22
set code1=00000001
set code2=00000016
set version=1294
set wadname=IOS22-64-v1294.wad
set md5=d924051fcab6280a71b39378c754b1d9
set md5alt=e5c16a04547fd2c23da4eb93199d9fc9
set category=ios
goto:downloadstart

:IOS28
set name=IOS28
set code1=00000001
set code2=0000001C
set version=1807
set wadname=IOS28-64-v1807.wad
set md5=ae6e5fdf37bc38380b09c1d934dc60d6
set md5alt=6dfccbac761898eb8099063d5308f72f
set category=ios
goto:downloadstart

:IOS30
set name=IOS30v2576 (3.2 SM IOS)
set code1=00000001
set code2=0000001E
set version=2576
set wadname=IOS30-64-v2576.wad
set md5=45d7945d08eb25dc167b6f30ab8a9a9d
set md5alt=%md5%
set category=ios
goto:downloadstart

:IOS30P
set name=IOS30v12576(IOS30v2576[FS-ES-NP-VP])
set code1=00000001
set code2=0000001E
set version=2576
set wadname=IOS30v12576(IOS30v2576[FS-ES-NP-VP])
set md5=e9003966357126dfefa4061f1c7c635c
set md5alt=%md5%
set ciosslot=30
set ciosversion=12576
set category=patchios
set basewad=IOS30-64-v2576
set md5base=45d7945d08eb25dc167b6f30ab8a9a9d
set md5basealt=%md5base%
goto:downloadstart

:IOS31
set name=IOS31
set code1=00000001
set code2=0000001F
set version=3608
set wadname=IOS31-64-v3608.wad
set md5=b0d71604ed554c6fd1db9bfdad0d6335
set md5alt=3555e0b6baa7e3e5043d1cf1df054b2c
set category=ios
goto:downloadstart

:IOS33
set name=IOS33
set code1=00000001
set code2=00000021
set version=3608
set wadname=IOS33-64-v3608.wad
set md5=a969609ec1a69dcc234f71443e1471f7
set md5alt=52b56a8f36c3ef5948c0d11147073e49
set category=ios
goto:downloadstart

:IOS34
set name=IOS34
set code1=00000001
set code2=00000022
set version=3608
set wadname=IOS34-64-v3608.wad
set md5=cefee27b32cee588f3bbd81d022777ad
set md5alt=b65cde9ad841561e645ecfe7b0bb9cc1
set category=ios
goto:downloadstart

:IOS35
set name=IOS35
set code1=00000001
set code2=00000023
set version=3608
set wadname=IOS35-64-v3608.wad
set md5=34cf8249ac64c252f4e5950a1fbf41a6
set md5alt=3e862b5bb75a45c544fbe588f37c60f4
set category=ios
goto:downloadstart

:IOS36
set name=IOS36
set code1=00000001
set code2=00000024
set version=3351
set wadname=IOS36-64-v3351.wad
set md5=47ef27d46fc581c520f8215f39f11ecb
set md5alt=daa08e17264c523049e395edad5a50fe
set category=ios
goto:downloadstart

:IOS36v3608
set name=IOS36v3608
set code1=00000001
set code2=00000024
set version=3608
set wadname=IOS36-64-v3608.wad
set md5=58d6f06bfea15a562713df6e33b2f18b
set md5alt=dea0c5d8e4ce7adf0e54e5890929e904
set category=ios
goto:downloadstart



:IOS37
set name=IOS37
set code1=00000001
set code2=00000025
set version=5663
set wadname=IOS37-64-v5663.wad
set md5=54dfa6105113926b1996f8bc20d99007
set md5alt=16bc6ae65e6f469631b6add48b6b22b2
set category=ios
goto:downloadstart

:IOS38
set name=IOS38
set code1=00000001
set code2=00000026
set version=4124
set wadname=IOS38-64-v4124.wad
set md5=366dc2b1f7d8000a41755ff12f63d39c
set md5alt=162f370e1ee3f0d86a3313f285fbb318
set category=ios
goto:downloadstart

:IOS41
set name=IOS41
set code1=00000001
set code2=00000029
set version=3607
set wadname=IOS41-64-v3607.wad
set md5=6256a159cf74fd7a59822cf5597c69e3
set md5alt=3610517695d246b9cb69069e77eb3ae5
set category=ios
goto:downloadstart




:IOS43
set name=IOS43
set code1=00000001
set code2=0000002B
set version=3607
set wadname=IOS43-64-v3607.wad
set md5=633aa0cecd534622df8de27cd7361194
set md5alt=%md5%
set category=ios
goto:downloadstart

:IOS45
set name=IOS45
set code1=00000001
set code2=0000002D
set version=3607
set wadname=IOS45-64-v3607.wad
set md5=e0aaa5cb0a6121ac61255f0bfe484205
set md5alt=%md5%
set category=ios
goto:downloadstart

:IOS46
set name=IOS46
set code1=00000001
set code2=0000002E
set version=3607
set wadname=IOS46-64-v3607.wad
set md5=f542b3945ba76ad60cbe21fc091f79cf
set md5alt=%md5%
set category=ios
goto:downloadstart


:IOS48v4124
set name=IOS48
set code1=00000001
set code2=00000030
set version=4124
set wadname=IOS48-64-v4124.wad
set md5=5c825044e599b78b84da74778dfe0bb7
set md5alt=%md5%
set category=ios
goto:downloadstart


:IOS53
set name=IOS53
set code1=00000001
set code2=00000035
set version=5663
set wadname=IOS53-64-v5663.wad
set md5=7222503d83c869b5633a8bedaae517d8
set md5alt=fb73af31ff36a6ce9e1289ba867eb2e7
set category=ios
goto:downloadstart

:IOS55
set name=IOS55
set code1=00000001
set code2=00000037
set version=5663
set wadname=IOS55-64-v5663.wad
set md5=92c8877577c68143595f5e48dfa14ed1
set md5alt=4de32047ace920a15cdd3fe24abeef50
set category=ios
goto:downloadstart

:IOS56
set name=IOS56
set code1=00000001
set code2=00000038
set version=5662
set wadname=IOS56-64-v5662.wad
set md5=e6341c6c30c44fa9735c9cc6090133d8
set md5alt=1f6487d137fcd494cb2c35986ad6b490
set category=ios
goto:downloadstart

:IOS57
set name=IOS57
set code1=00000001
set code2=00000039
set version=5919
set wadname=IOS57-64-v5919.wad
set md5=c96e3b6a0616bf9f3ae188aca92d32cc
set md5alt=41cbc739426ce5ebe3a40a5b635a4736
set category=ios
goto:downloadstart


:IOS58
set name=IOS58
set code1=00000001
set code2=0000003A
set version=6176
set wadname=IOS58-64-v6176.wad
set md5=b72783f95e1567740c1cce6dc9d3ddc8
set md5alt=c7c24f0cd2e331294e32e0325b69a6d9
set category=ios
goto:downloadstart

:IOS60
set name=IOS60v6174 (4.1 SM IOS)
set code1=00000001
set code2=0000003C
set version=6174
set wadname=IOS60-64-v6174.wad
set md5=a8cfd7a77016227203639713db5ac34e
set md5alt=%md5%
set category=ios
goto:downloadstart



:IOS60P
set name=IOS60v16174(IOS60v6174[FS-ES-NP-VP-DIP])
set code1=00000001
set code2=0000003C
set version=6174
set wadname=IOS60v16174(IOS60v6174[FS-ES-NP-VP-DIP])
set md5=c45a2bf6d560b2039f900f57cb00e7e1
set md5alt=%md5%
set ciosslot=60
set ciosversion=16174
set category=patchios
set basewad=IOS60-64-v6174
set md5base=a8cfd7a77016227203639713db5ac34e
set md5basealt=%md5base%
set basecios=IOS60v16174(IOS60v6174[FS-ES-NP-VP-DIP])
set diffpath=%basecios%
set code2new=0000003C
set lastbasemodule=0000000e
set cIOSFamilyName=
goto:downloadstart


::IOS60 installed to a bunch of different SM IOS slots for brick protection
:IOS11P60
set name=IOS11v16174(IOS60v6174[FS-ES-NP-VP-DIP])
set code1=00000001
set code2=0000003C
set version=6174
set wadname=IOS11v16174(IOS60v6174[FS-ES-NP-VP-DIP]).wad
set md5=32f25aaefd0bb4cf53b76c2e984d12f7
set md5alt=%md5%
set ciosslot=11
set ciosversion=16174
set category=patchios
set basewad=IOS60-64-v6174
set md5base=a8cfd7a77016227203639713db5ac34e
set md5basealt=%md5base%
set basecios=IOS60v16174(IOS60v6174[FS-ES-NP-VP-DIP])
set diffpath=%basecios%
set code2new=0000003C
set lastbasemodule=0000000e
set cIOSFamilyName=
goto:downloadstart



:IOS20P60
set name=IOS20v16174(IOS60v6174[FS-ES-NP-VP-DIP])
set code1=00000001
set code2=0000003C
set version=6174
set wadname=IOS20v16174(IOS60v6174[FS-ES-NP-VP-DIP]).wad
set md5=808f1d1f073adc9dc0406ead1d43a318
set md5alt=%md5%
set ciosslot=20
set ciosversion=16174
set category=patchios
set basewad=IOS60-64-v6174
set md5base=a8cfd7a77016227203639713db5ac34e
set md5basealt=%md5base%
set basecios=IOS60v16174(IOS60v6174[FS-ES-NP-VP-DIP])
set diffpath=%basecios%
set code2new=0000003C
set lastbasemodule=0000000e
set cIOSFamilyName=
goto:downloadstart



:IOS30P60
set name=IOS30v16174(IOS60v6174[FS-ES-NP-VP-DIP])
set code1=00000001
set code2=0000003C
set version=6174
set wadname=IOS30v16174(IOS60v6174[FS-ES-NP-VP-DIP]).wad
set md5=a68689125e3172faa04c00ef42a593b1
set md5alt=%md5%
set ciosslot=30
set ciosversion=16174
set category=patchios
set basewad=IOS60-64-v6174
set md5base=a8cfd7a77016227203639713db5ac34e
set md5basealt=%md5base%
set basecios=IOS60v16174(IOS60v6174[FS-ES-NP-VP-DIP])
set diffpath=%basecios%
set code2new=0000003C
set lastbasemodule=0000000e
set cIOSFamilyName=
goto:downloadstart

:IOS40P60
set name=IOS40v16174(IOS60v6174[FS-ES-NP-VP-DIP])
set code1=00000001
set code2=0000003C
set version=6174
set wadname=IOS40v16174(IOS60v6174[FS-ES-NP-VP-DIP]).wad
set md5=dd8fe0f58a019f45c792b92837125cd8
set md5alt=%md5%
set ciosslot=40
set ciosversion=16174
set category=patchios
set basewad=IOS60-64-v6174
set md5base=a8cfd7a77016227203639713db5ac34e
set md5basealt=%md5base%
set basecios=IOS60v16174(IOS60v6174[FS-ES-NP-VP-DIP])
set diffpath=%basecios%
set code2new=0000003C
set lastbasemodule=0000000e
set cIOSFamilyName=
goto:downloadstart


:IOS70K
set name=IOS70v16174(IOS60v6174[FS-ES-NP-VP-DIP])
set code1=00000001
set code2=0000003C
set version=6174
set wadname=IOS70v16174(IOS60v6174[FS-ES-NP-VP-DIP]).wad
set md5=2ddf180d37b35f1e9abb6982fe55f587
set md5alt=%md5%
set ciosslot=70
set ciosversion=16174
set category=patchios
set basewad=IOS60-64-v6174
set md5base=a8cfd7a77016227203639713db5ac34e
set md5basealt=%md5base%
set basecios=IOS60v16174(IOS60v6174[FS-ES-NP-VP-DIP])
set diffpath=%basecios%
set code2new=0000003C
set lastbasemodule=0000000e
set cIOSFamilyName=
goto:downloadstart


:IOS80K
set name=IOS80v16174(IOS60v6174[FS-ES-NP-VP-DIP])
set code1=00000001
set code2=0000003C
set version=6174
set wadname=IOS80v16174(IOS60v6174[FS-ES-NP-VP-DIP]).wad
set md5=23f3008dca379b5db2044bf09ec03276
set md5alt=%md5%
set ciosslot=80
set ciosversion=16174
set category=patchios
set basewad=IOS60-64-v6174
set md5base=a8cfd7a77016227203639713db5ac34e
set md5basealt=%md5base%
set basecios=IOS60v16174(IOS60v6174[FS-ES-NP-VP-DIP])
set diffpath=%basecios%
set code2new=0000003C
set lastbasemodule=0000000e
set cIOSFamilyName=
goto:downloadstart


:IOS50P
set name=IOS50v16174(IOS60v6174[FS-ES-NP-VP-DIP])
set code1=00000001
set code2=0000003C
set version=6174
set wadname=IOS50v16174(IOS60v6174[FS-ES-NP-VP-DIP]).wad
set md5=3b1f2a76fd800ddb777744a47086844b
set md5alt=%md5%
set ciosslot=50
set ciosversion=16174
set category=patchios
set basewad=IOS60-64-v6174
set md5base=a8cfd7a77016227203639713db5ac34e
set md5basealt=%md5base%
set basecios=IOS60v16174(IOS60v6174[FS-ES-NP-VP-DIP])
set diffpath=%basecios%
set code2new=0000003C
set lastbasemodule=0000000e
set cIOSFamilyName=
goto:downloadstart


:IOS52P
set name=IOS52v16174(IOS60v6174[FS-ES-NP-VP-DIP])
set code1=00000001
set code2=0000003C
set version=6174
set wadname=IOS52v16174(IOS60v6174[FS-ES-NP-VP-DIP]).wad
set md5=62fb16adb16b6b3823ef99746caaef03
set md5alt=%md5%
set ciosslot=52
set ciosversion=16174
set category=patchios
set basewad=IOS60-64-v6174
set md5base=a8cfd7a77016227203639713db5ac34e
set md5basealt=%md5base%
set basecios=IOS60v16174(IOS60v6174[FS-ES-NP-VP-DIP])
set diffpath=%basecios%
set code2new=0000003C
set lastbasemodule=0000000e
set cIOSFamilyName=
goto:downloadstart


:IOS61
set name=IOS61
set code1=00000001
set code2=0000003D
set version=5662
set wadname=IOS61-64-v5662.wad
set md5=54c44b17be63ea4b3b674d66f4efa7bf
set md5alt=7f79db4519182d15b1332ff06ed40880
set category=ios
goto:downloadstart


:IOS62
set name=IOS62
set code1=00000001
set code2=0000003E
set version=6430
set wadname=IOS62-64-v6430.wad
set md5=f2222e05ce9cc8ad14a2b4ed7ce16977
set md5alt=%md5%
set category=ios
goto:downloadstart


:IOS70
set name=IOS70v6687 (4.2 SM IOS)
set code1=00000001
set code2=00000046
set version=6687
set wadname=IOS70-64-v6687.wad
set md5=c38ff50344c00e17b7fe58c05d35a91c
set md5alt=%md5%
set category=ios
goto:downloadstart



:IOS70P
set name=IOS70v16687(IOS70v6687[FS-ES-NP-VP])
set code1=00000001
set code2=00000046
set version=6687
set wadname=IOS70v16687(IOS70v6687[FS-ES-NP-VP]).wad
::IOS70-64-v6687[FS-ES-NP-VP].wad
set md5=c31c4d1ad79de3a0840997a73c40b6e4
set md5alt=%md5%
set ciosslot=70
set ciosversion=16687
set category=patchios
set basewad=IOS70-64-v6687
set md5base=c38ff50344c00e17b7fe58c05d35a91c
set md5basealt=%md5base%
goto:downloadstart


:IOS80
set name=IOS80v6944
set code1=00000001
set code2=00000050
set version=6944
set wadname=IOS80-64-v6944.wad
set md5=08af8d598af53c8bc66b31228364cfd7
set md5alt=dde76a81090611406bcb3b76ac3f082c
set category=ios
goto:downloadstart


:IOS80P
set name=IOS80v16944(IOS80v6944[FS-ES-NP-VP])
set code1=00000001
set code2=00000050
set version=6944
set wadname=IOS80v16944(IOS80v6944[FS-ES-NP-VP])
set md5=9cfe4beddbf77087220191b5c8a96263
set md5alt=%md5%
set ciosslot=80
set ciosversion=16944
set category=patchios
set basewad=IOS80-64-v6944
set md5base=dde76a81090611406bcb3b76ac3f082c
set md5basealt=%md5base%
goto:downloadstart


:IOS236
set name=IOS236v65535(IOS36v3351[FS-ES-NP-VP])
set code1=00000001
set code2=00000024
set version=3351
set wadname=IOS236v65535(IOS36v3351[FS-ES-NP-VP]).wad
set md5=06259eb90e6ca115ba67720fc1a1ff80
set md5alt=%md5%
set ciosslot=236
set ciosversion=65535
set category=patchios
set basewad=IOS36-64-v3351
set md5base=daa08e17264c523049e395edad5a50fe
set md5basealt=%md5base%
goto:downloadstart


:M10
set name=MIOSv10
set code1=00000001
set code2=00000101
set version=10
set wadname=RVL-mios-v10.wad
set md5=851c27dae82bc1c758be07fa964d17cb
set md5alt=%md5%
set category=ios
goto:downloadstart


:NUSGRABBER0e
set name=0000000e.app from IOS80 v6943 (SNEEK)
set code1=SNEEKAPP
::set code2=APP
set version=0e
set wadname=0000000e_IOS80.app
set md5=4b3ad6d33707d55ec27583a84b2ecf2a
goto:downloadstart


:NUSGRABBER0e_70
set name=0000000e.app from IOS70 v6687 (SNEEK)
set code1=SNEEKAPP
::set code2=APP
set version=0e_70
set wadname=0000000e_IOS70.app
set md5=7c3a8a690b6f701d2dcea082da1bd478
goto:downloadstart


:NUSGRABBER0e_60
set name=0000000e.app from IOS60 v6174 (SNEEK)
set code1=SNEEKAPP
::set code2=APP
set version=0e_60
set wadname=0000000e_IOS60.app
set md5=ddaa661a6aac528c26217eda972a1787
goto:downloadstart

:NUSGRABBER01
set name=00000001.app from IOS80 v6687 (SNEEK)
set code1=SNEEKAPP
::set code2=APP
set version=01
set wadname=00000001_IOS80.app
set md5=89f7dc21f07e2cae97c3a571b23d8abd
goto:downloadstart

:NUSGRABBER01_70
set name=00000001.app from IOS70 v6687 (SNEEK)
set code1=SNEEKAPP
::set code2=APP
set version=01_70
set wadname=00000001_IOS70.app
set md5=89f7dc21f07e2cae97c3a571b23d8abd
goto:downloadstart


:NUSGRABBER01_60
set name=00000001.app from IOS60 v6174 (SNEEK)
set code1=SNEEKAPP
::set code2=APP
set version=01_60
set wadname=00000001_IOS60.app
set md5=48e1be8f767feb59cbc51aa4329d735a
goto:downloadstart

:NUSGRABBER0c
set name=0000000c.app from MIOS v10 (DIOS MIOS)
set code1=SNEEKAPP
::set code2=APP
set version=0c
set wadname=0000000c.app
set md5=42634040d7cbb53057c577ec4c3c63f8
goto:downloadstart

:NUSGRABBER40
set name=00000040.app from System Menu 3.2J (for MyMenuify)
set code1=MYMAPP
::set code2=APP
set version=40
set wadname=00000040_3.2J.app
set md5=c39e9edfc6df2264ce8ade4fd933f47f
goto:downloadstart

:NUSGRABBER42
set name=00000042.app from System Menu 3.2U (for MyMenuify)
set code1=MYMAPP
::set code2=APP
set version=42
set wadname=00000042_3.2U.app
set md5=9aae1917fdb8ba4d409664c230d89b27
goto:downloadstart

:NUSGRABBER45
set name=00000045.app from System Menu 3.2E (for MyMenuify)
set code1=MYMAPP
::set code2=APP
set version=45
set wadname=00000045_3.2E.app
set md5=500130276620408b47777355460193de
goto:downloadstart

:NUSGRABBER70
set name=00000070.app from System Menu 4.0J (for MyMenuify)
set code1=MYMAPP
::set code2=APP
set version=70
set wadname=00000070_4.0J.app
set md5=cc23b71d9246154f289644beee1b1682
goto:downloadstart

:NUSGRABBER72
set name=00000072.app from System Menu 4.0U (for MyMenuify)
set code1=MYMAPP
::set code2=APP
set version=72
set wadname=00000072_4.0U.app
set md5=611d8d5e1f7ce778ba4c44d1b4c2910b
goto:downloadstart

:NUSGRABBER75
set name=00000075.app from System Menu 4.0E (for MyMenuify)
set code1=MYMAPP
::set code2=APP
set version=75
set wadname=00000075_4.0E.app
set md5=a1d5703a4a2a5d764a12224d646c2849
goto:downloadstart

:NUSGRABBER78
set name=00000078.app from System Menu 4.1J (for MyMenuify)
set code1=MYMAPP
::set code2=APP
set version=78
set wadname=00000078_4.1J.app
set md5=f2eadf12d18e793373060222b870057d
goto:downloadstart

:NUSGRABBER81
set name=00000081.app from System Menu 4.1K (for MyMenuify)
set code1=MYMAPP
::set code2=APP
set version=81
set wadname=00000081_4.1K.app
set md5=7eedbf1a146b29b63edbb55e04f81f98
goto:downloadstart

:NUSGRABBER7b
set name=0000007b.app from System Menu 4.1U (for MyMenuify)
set code1=MYMAPP
::set code2=APP
set version=7b
set wadname=0000007b_4.1U.app
set md5=6b939de8222800733f4c44ae4eadb325
goto:downloadstart

:NUSGRABBER7e
set name=0000007e.app from System Menu 4.1E (for MyMenuify)
set code1=MYMAPP
::set code2=APP
set version=7e
set wadname=0000007e_4.1E.app
set md5=574a3a144971ea0ec61bf8cef8d7ff80
goto:downloadstart

:NUSGRABBER84
set name=00000084.app from System Menu 4.2J (for MyMenuify)
set code1=MYMAPP
::set code2=APP
set version=84
set wadname=00000084_4.2J.app
set md5=b08998e582c48afba3a14f6d9e1e9373
goto:downloadstart

:NUSGRABBER87
set name=00000087.app from System Menu 4.2U (for MyMenuify)
set code1=MYMAPP
::set code2=APP
set version=87
set wadname=00000087_4.2U.app
set md5=7079948c6aed8aae6009e4fdf27c7171
goto:downloadstart

:NUSGRABBER8a
set name=0000008a.app from System Menu 4.2E (for MyMenuify)
set code1=MYMAPP
::set code2=APP
set version=8a
set wadname=0000008a_4.2E.app
set md5=7e7994f78941afb51e9a20085deac305
goto:downloadstart


:NUSGRABBER8d
set name=0000008d.app from System Menu 4.2K (for MyMenuify)
set code1=MYMAPP
::set code2=APP
set version=8d
set wadname=0000008d_4.2K.app
set md5=9d72a1966370e44cb4c456c17a077bec
goto:downloadstart


:NUSGRABBER94
set name=00000094.app from System Menu 4.3J (for MyMenuify)
set code1=MYMAPP
::set code2=APP
set version=94
set wadname=00000094_4.3J.app
set md5=5b3ee6942a3cda716badbce3665076fc
goto:downloadstart

:NUSGRABBER97
set name=00000097.app from System Menu 4.3U (for MyMenuify)
set code1=MYMAPP
::set code2=APP
set version=97
set wadname=00000097_4.3U.app
set md5=f388c9b11543ac2fe0912ab96064ee37
goto:downloadstart

:NUSGRABBER9a
set name=0000009a.app from System Menu 4.3E (for MyMenuify)
set code1=MYMAPP
::set code2=APP
set version=9a
set wadname=0000009a_4.3E.app
set md5=41310f79497c56850c37676074ee1237
goto:downloadstart


:NUSGRABBER9d
set name=0000009d.app from System Menu 4.3K (for MyMenuify)
set code1=MYMAPP
::set code2=APP
set version=9d
set wadname=0000009d_4.3K.app
set md5=e6f2b0d4d5e0c095895f186009bf9516
goto:downloadstart


:URLDownloadDB

:BannerBomb1
set name=Bannerbomb v1 (for 3.0 - 4.1 Wii's)
set code1=URL
set code2=http://bannerbomb.qoid.us/aads/aad1f_v108.zip
set version=bin
set dlname=aad1f_v108.zip
set wadname=BB1.zip
set md5=41d50b69c5763159afb35918c42cf320
set path1=private\wii\title\aktn\
set filename=content.bin
goto:downloadstart

:BannerBomb2
set name=Bannerbomb v2 (for 4.2 Wii's)
set code1=URL
set code2=http://bannerbomb.qoid.us/abds/abd6a_v200.zip
set version=bin
set dlname=abd6a_v200.zip
set wadname=BB2.zip
set md5=d846f2c07c0a3be6fadca90dbb7356a7
if /i "%BB1%" EQU "*" (set path1=private2\wii\title\aktn\) else (set path1=private\wii\title\aktn\)
set filename=content.bin
goto:downloadstart

:ARC
set name=Any Region Changer (1.1b Mod06 Offline)
set code1=URL
set code2=http://filetrip.net/d26999-Any-Region-Changer-06.html
set version=*
set dlname=26999-ARCmod06_Offline.zip
set wadname=ARCmod06_Offline.zip
set md5=01889b98b95279258201387de1d0a8f7
set path1=apps\ARCmod06_Offline\
set filename=boot.dol
goto:downloadstart


:mmm
set name=Multi-Mod Manager (MMM) v13.4
set code1=URL
set code2="https://googledrive.com/host/0BzWzf-jnAnp1YkFURFF0cDdsRUE/ModMii/Multi-Mod-Manager_v13.4.zip"
set version=*
set dlname="Multi-Mod-Manager_v13.4.zip"
set wadname=Multi-Mod-Manager_v13.4.zip
set filename=boot.dol
set md5=6d5167f976b5c35b2b2a12c3aa3e7766
set path1=apps\mmm\
goto:downloadstart

:WiiMod
set name=WiiMod
set code1=URL
set code2="https://googledrive.com/host/0BzWzf-jnAnp1YkFURFF0cDdsRUE/ModMii/wiimod_v3_2.zip"
set version=*
set dlname="wiimod_v3_2.zip"
set wadname=wiimod_v3_2.zip
set filename=boot.dol
set md5=5ee14b32aaef1cfcb67e4d6e44e214d1
set path1=apps\WiiMod\
goto:downloadstart


:HackmiiInstaller
set name=HackMii Installer
set code1=URL
::set code2="http://bootmii.org/download/"
set code2="http://bootmii.org/download/"
set version=elf
::set dlname=
set wadname=hackmii_installer_v1.2.zip
set filename=boot.elf
set path1=
set md5=729eebb48f6b562b94a47a3eb0543bf4
goto:downloadstart

:IOS236Installer
set name=IOS236 Installer v5 Mod
set code1=URL
set code2=https://googledrive.com/host/0BzWzf-jnAnp1YkFURFF0cDdsRUE/ModMii/ios236_v5_mod.zip
set version=*
set dlname=ios236_v5_mod.zip
set wadname=ios236_v5_mod.zip
set filename=boot.dol
set md5=719a2a338121a17bedd3984faa8bd722
set path1=apps\IOS236-v5-Mod\
goto:downloadstart


:sysCheck
set category=fullextract
set name=sysCheck v2.1.0.b19
set code1=URL
set code2=http://s5.filetrip.net/p/5365/275808-syscheckb19.zip
set version=*
set dlname=275808-syscheckb19.zip
set wadname=syscheckb19.zip
set filename=boot.dol
set md5=3b53fe8fa9e036b0885a5d1aec153d1a
set path1=apps\sysCheck\
goto:downloadstart


:SIP
set category=fullextract
set name=Simple IOS Patcher
set code1=URL
set code2=http://filetrip.net/f/25749-sip_v1.14.zip
set version=*
set dlname=25749-sip_v1.14.zip
set wadname=sip_v1.14.zip
set filename=boot.dol
set md5=fbaeb401e44cdbe0e455490190cc196d
set path1=apps\SIP\
goto:downloadstart

:pwns
set category=fullextract
set name=Indiana Pwns (USA, PAL and JAP)
set code1=URL
set code2="http://static.hackmii.com/indiana-pwns.zip"
set version=*
set dlname="indiana-pwns.zip"
set wadname=indiana-pwns.zip
set filename=data.bin
set md5=a6b8f03f49baa471228dcd81d3fd623a
set path1=private\wii\title\rlip\
goto:downloadstart

:Twi
set category=fullextract
set name=Twilight Hack v0.1 Beta1 (for Wii's 3.3 and below)
set code1=URL
set code2="http://filetrip.net/d2425-Twilight-Hack-v0-1-beta1.html"
set version=*
set dlname="[2711]twilight_hack_v0.1_beta1.zip"
set wadname=twilight_hack_v0.1_beta1.zip
set filename=data.bin
set md5=704bd625ea5b42d7ac06fc937af74d38
set path1=private\wii\title\rzdp\
goto:downloadstart

:Bathaxx
set category=fullextract
set name=Bathaxx (USA, PAL and JAP)
set code1=URL
set code2="http://wien.tomnetworks.com/wii/bathaxx.zip"
set version=*
set dlname="bathaxx.zip"
set wadname=bathaxx.zip
set filename=data.bin
set md5=5dac3152baabbc6ca17bedfd5b7350c9
set path1=private\wii\title\rlbe\
goto:downloadstart


:ROTJ
set category=fullextract
set name=Return of the Jodi (USA, PAL and JAP)
set code1=URL
set code2="http://static.hackmii.com/return-jodi.zip"
set version=*
set dlname="return-jodi.zip"
set wadname=return-jodi.zip
set filename=data.bin
set md5=448a3e6bfb4b6d9fafd64c45575f9cb4
set path1=private\wii\title\rlge\
goto:downloadstart

:TOS
set category=fullextract
set name=Eri HaKawai (USA, PAL and JAP)
set code1=URL
set code2="https://googledrive.com/host/0BzWzf-jnAnp1YkFURFF0cDdsRUE/ModMii/EriHaKawai-USA+PAL+JAP.zip"
set version=*
set dlname="EriHaKawai-USA+PAL+JAP.zip"
set wadname=EriHaKawai-USA+PAL+JAP.zip
set filename=data.bin
set md5=7884370e1b8960ed09ed61395007affd
set path1=private\wii\title\rt4j\
goto:downloadstart

:YUGI
set category=fullextract
set name=YU-GI-OWNED (USA, PAL and JAP)
set code1=URL
set code2="https://googledrive.com/host/0BzWzf-jnAnp1YkFURFF0cDdsRUE/ModMii/yu-gi-vah-ALL.zip"
set version=*
set dlname="yu-gi-vah-ALL.zip"
set wadname=yu-gi-vah-ALL.zip
set filename=data.bin
set md5=0319cb55ecb1caea34e4504aa56664ab
set path1=private\wii\title\ryoe\
goto:downloadstart



:smash
set name=Smash Stack (USA, PAL, JAP and KOR)
set category=fullextract
set code1=URL
set code2="https://googledrive.com/host/0BzWzf-jnAnp1YkFURFF0cDdsRUE/ModMii/Smashstack_AllRegions.zip"
set version=*
set dlname="Smashstack_AllRegions.zip"
set wadname=Smashstack_AllRegions.zip
set filename=st_080805_0933.bin
set md5=aa93aab9bfdd25883bbd826a62645033
set path1=private\wii\app\rsbe\st\
goto:downloadstart

:dopmii
set name=Dop-Mii v13
set category=fullextract
set code1=URL
set code2="http://s2.filetrip.net/p/5365/275810-DOP-Mii_v13.zip"
set version=*
set dlname="275810-DOP-Mii_v13.zip"
set wadname=DOP-Mii_v13.zip
set filename=boot.dol
set md5=7cbd40d4987d17d85d4184bafc886c1c
set path1=apps\DOP-Mii\
goto:downloadstart

:locked
set name=Locked Apps Folder for HBC (PASS=UDLRAB)
set category=fullextract
set code1=URL
set code2="https://googledrive.com/host/0BzWzf-jnAnp1YkFURFF0cDdsRUE/ModMii/LockedApps-Categorii.zip"
set version=*
set dlname=LockedApps-Categorii.zip
set wadname=LockedApps-Categorii.zip
set filename=boot.dol
set md5=6f277fd19e359db7d6f84dbad1076a29
set path1=apps\_apps_locked\
goto:downloadstart

:AccioHacks
set name=Accio Hacks
set code1=URL
set code2=http://geckocodes.org/AH.php?dl
set version=*
set dlname="AH.php@dl"
set wadname=AccioHacks.zip
set filename=boot.dol
set md5=e321da8d59578313890a50b7a31aff7b
set path1=apps\AccioHacks\
goto:downloadstart


:MyM
set name=MyMenuifyMod
::set category=fullextract
set code1=URL
set code2=http://s2.filetrip.net/p/5365/275812-MyMenuifyModv1.5.zip
set version=*
set dlname=275812-MyMenuifyModv1.5.zip
set wadname=MyMenuifyModv1.5.zip
set filename=boot.dol
set md5=8d232e7ecd5ede5966c2abc3649fd108
set path1=apps\MyMenuifyMod\
goto:downloadstart

:bootmiisd
set name=BootMii SD Files
set category=fullextract
set code1=URL
set code2="http://static.hackmii.com/bootmii_sd_files.zip"
set version=*
set dlname="bootmii_sd_files.zip"
set wadname=bootmii_sd_files.zip
set filename=ppcboot.elf
set md5=4b2ac026e3b08a588a340841244f4e98
set path1=bootmii\
goto:downloadstart

:neogamma
set name=Neogamma Backup Disc Loader
set category=fullextract
set code1=URL
set code2="http://filetrip.net/f/27066-NeoGammaR9beta56.zip"
set version=*
set dlname="27066-NeoGammaR9beta56.zip"
set wadname=NeoGammaR9beta56.zip
set filename=boot.dol
set md5=603a7c4cba387aa81a6149f1a76cada1
set path1=apps\neogamma\
goto:downloadstart

:yawm
set name=Yet Another Wad Manager Mod
set code1=URL
set code2="http://s2.filetrip.net/p/5365/275814-YAWMM.zip"
set version=*
set dlname="275814-YAWMM.zip"
set wadname=YAWMM.zip
set filename=boot.dol
set md5=e475232c74f630aae3444e67e17d5f27
set path1=apps\yawmm\
goto:downloadstart

:usbfolder
set name=Configurable USB-Loader Mod
set category=fullextract
set code1=URL
set code2="expresstek.org/xflak/files/Cfg_USB_Loader_70_Mod_r65.zip"
set version=*
set dlname=Cfg_USB_Loader_70_Mod_r65.zip
set wadname=Cfg_USB_Loader_70_Mod_r65.zip
set filename=boot.dol
set md5=d1a39c8bebbc074590e1b6aa4493ca25
set path1=apps\usbloader_cfg\
goto:downloadstart


:FLOW
set name=WiiFlow
set category=fullextract
set code1=URL
set code2="expresstek.org/xflak/files/WiiFlow_v4.2.1.zip"
set version=*
set dlname=WiiFlow_v4.2.1.zip
set wadname=WiiFlow_v4.2.1.zip
set filename=boot.dol
set md5=06c2c97254dc7adb0547530fc400826f
set path1=apps\WiiFlow\
goto:downloadstart


:CheatCodes
set name=%cheatregion% Region Cheat Codes: txtcodes from geckocodes.org
set category=CHEATS
goto:downloadstart


:WBM
set name=Wii Backup Manager v0.4.5 build 78
set category=fullextract
set code1=URL
set code2="http://filetrip.net/d26812-Wii-Backup-Manager-0-4-5-build-78.html"
set version=*
set dlname=26812-WiiBackupManager_Build78.zip
set wadname=WiiBackupManager.zip
set filename=WiiBackupManager_Win32.exe
set md5=8ee733c1c126260962bcc83926d3cea6
set path1=WiiBackupManager\
goto:downloadstart


:USBX
set name=USB-Loader Forwarder Channel v12
set code1=ZIP
set code2="https://googledrive.com/host/0BzWzf-jnAnp1YkFURFF0cDdsRUE/ModMii/USBLoader(s)-ahbprot58-SD-USB-v12-IDCL.zip"
set version=*
set dlname=USBLoader(s)-ahbprot58-SD-USB-v12-IDCL.zip
set wadname=USBLoader(s)-ahbprot58-SD-USB-v12-IDCL.zip
set filename=USBLoader(s)-ahbprot58-SD-USB-v12-IDCL.wad
set md5=19edb88943527102dd5844e8c2b78b25
set md5alt=%md5%
set category=fullextract
set path1=WAD\
goto:downloadstart


:FLOWF
set name=WiiFlow Forwarder Channel\dol
set code1=ZIP
set code2="https://googledrive.com/host/0BzWzf-jnAnp1YkFURFF0cDdsRUE/ModMii/WiiFlow_Forwarder_wad_dol_v14b.zip"
set version=*
set dlname=WiiFlow_Forwarder_wad_dol_v14b.zip
set wadname=WiiFlow_Forwarder_wad_dol_v14b.zip
set filename=Default-FIX94v14b-forwarder-DWFA.wad
set md5=1617817ce0c2954dfc8626253f9920d7
set md5alt=%md5%
set category=fullextract
set path1=WAD\
goto:downloadstart


:S2U
set name=Switch2Uneek
set code1=ZIP
set code2="https://googledrive.com/host/0BzWzf-jnAnp1YkFURFF0cDdsRUE/ModMii/switch2uneek_ModMiiBundle_v12.zip"
set version=*
set dlname=switch2uneek_ModMiiBundle_v12.zip
set wadname=switch2uneek_ModMiiBundle_v12.zip
set filename=switch2uneek(emulators)-4RealNand-v12-S2UK.wad
set md5=0639ea7dd95c5f2f4266a60bef66bf99
set md5alt=%md5%
set category=fullextract
set path1=WAD\
::below is for building emu nand
if /i "%MENU1%" NEQ "S" goto:downloadstart
set filename=switch2uneek(emulators)-4EMUNand-v12-S2RL.wad
set md5=b0ea307ccddcc9542ec1e8b14c2d4e10
set md5alt=%md5%
::set path1=\
goto:downloadstart


:nSwitch
set name=nSwitch
set code1=ZIP
set code2="http://custom-di.googlecode.com/files/neek2o NK2O_1 .wad"
set version=*
set dlname="neek2o NK2O_1 .wad"
set wadname=neek2o_NK2O_1.wad
set filename=neek2o_NK2O_1.wad
set md5=2b68b689d182a6151fb9d9154430889f
set md5alt=%md5%
set category=fullextract
set path1=WAD\
goto:downloadstart


:PLC
set name=Post Loader Forwarder Channel
set code1=ZIP
set code2="expresstek.org/xflak/files/plforwarder.4.wad"
set version=*
set dlname="plforwarder.4.wad"
set wadname=plforwarder.4.wad
set filename=plforwarder.4.wad
set md5=3f172454cd2d970dd0d76c70aced05df
set md5alt=%md5%
set category=fullextract
set path1=WAD\
goto:downloadstart


:F32
set name=FAT32 GUI Formatter
set category=fullextract
set code1=URL
set code2="http://www.ridgecrop.demon.co.uk/guiformat.exe"
set version=*
set dlname=guiformat.exe
set wadname=FAT32_GUI_Formatter.exe
set filename=FAT32_GUI_Formatter.exe
set md5=2459a629ace148286360b860442221a2
set path1=FAT32_GUI_Formatter\
goto:downloadstart


:SMW
set name=ShowMiiWads
set category=fullextract
set code1=URL
set code2="http://s2.filetrip.net/p/5365/275816-ShowMiiWads 1.4.rar"
set version=*
set dlname="275816-ShowMiiWads 1.4.rar"
set wadname=ShowMiiWads 1.4.rar
set filename=ShowMiiWads.exe
set md5=58277ad0974e59493bb3e9f8a8aca82b
set path1=ShowMiiWads\
goto:downloadstart

:CM
set name=Customize Mii
set category=fullextract
set code1=URL
set code2="http://filetrip.net/f/22023-CustomizeMii 3.11.rar"
set version=*
set dlname="22023-CustomizeMii 3.11.rar"
set wadname=CustomizeMii 3.11.rar
set filename=CustomizeMii.exe
set md5=e35d75c3ad0a058149bdf45155595cfc
set path1=CustomizeMii\
goto:downloadstart

:WiiGSC
set name=Wii Game Shortcut Creator
set category=fullextract
set code1=URL
set code2="https://googledrive.com/host/0BzWzf-jnAnp1YkFURFF0cDdsRUE/ModMii/WiiGSC-Unpacked-1.06b.zip"
set version=*
set dlname=WiiGSC-Unpacked-1.06b.zip
set wadname=WiiGSC-Unpacked-1.06b.zip
set filename=WiiGSC.exe
set md5=3779833ec3279dff3d415c7bd6e56fec
set path1=WiiGSC\
goto:downloadstart


:dopmii
set name=Dop-Mii v13
set category=fullextract
set code1=URL
set code2="http://s2.filetrip.net/p/5365/275810-DOP-Mii_v13.zip"
set version=*
set dlname="275810-DOP-Mii_v13.zip"
set wadname=DOP-Mii_v13.zip
set filename=boot.dol
set md5=7cbd40d4987d17d85d4184bafc886c1c
set path1=apps\DOP-Mii\
goto:downloadstart



:WIIMC
set name=WiiMC - Media Player
set category=fullextract
set code1=URL
set code2="http://s2.filetrip.net/p/5365/275818-WiiMC.1.3.4.New.Install.zip"
set version=*
set dlname="275818-WiiMC.1.3.4.New.Install.zip"
set wadname=WiiMC.1.3.4.New.Install.zip
set filename=boot.dol
set md5=cc2fc8abed046de33997fdb701db660c
set path1=apps\WiiMC\
goto:downloadstart

:fceugx
set name=FCEUGX - NES Emulator for the Wii
set category=fullextract
set code1=URL
set code2="http://s4.filetrip.net/p/5365/275819-FCE.Ultra.GX.3.3.4.zip"
set version=*
set dlname="275819-FCE.Ultra.GX.3.3.4.zip"
set wadname=FCE.Ultra.GX.3.3.4.zip
set filename=boot.dol
set md5=1a2c54ff5da63e31f60c9bc08a769768
set path1=apps\fceugx\
goto:downloadstart


:snes9xgx
set name=SNES9xGX - SNES Emulator for the Wii
set category=fullextract
set code1=URL
set code2="http://s5.filetrip.net/p/5365/275822-Snes9x.GX.4.3.2.zip"
set version=*
set dlname="275822-Snes9x.GX.4.3.2.zip"
set wadname=Snes9x.GX.4.3.2.zip
set filename=boot.dol
set md5=8b4cc0958a6c342a18283f3d4a607f8f
set path1=apps\snes9xgx\
goto:downloadstart

:vbagx
set name=Visual Boy Advance GX - GB/GBA Emulator for the Wii
set category=fullextract
set code1=URL
set code2="http://s6.filetrip.net/p/30026/230195-Visual Boy Advance GX 2.2.8.zip"
set version=*
set dlname="230195-Visual Boy Advance GX 2.2.8.zip"
set wadname=VisualBoyAdvanceGX.2.2.8.zip
set filename=boot.dol
set md5=001fe833bfd35e23c68ea0a59bd520ec
set path1=apps\vbagx\
goto:downloadstart


:SGM
set name=SaveGame Manager GX
::set category=fullextract
set code1=URL
set code2="expresstek.org/xflak/files/savegame-manager-gx_R127.zip"
set version=*
set dlname="savegame-manager-gx_R127.zip"
set wadname=savegame-manager-gx_R127.zip
set filename=boot.dol
set md5=4435b05aa39761a32ac68765ca74304e
set path1=apps\SaveGameManagerGX\
goto:downloadstart


:WII64
set name=Wii64 beta1.1 (N64 Emulator)
set category=fullextract
set code1=URL
set code2="expresstek.org/xflak/files/wii64-beta1.1.zip"
set version=*
set dlname="wii64-beta1.1.zip"
set wadname=wii64-beta1.1.zip
set filename=boot.dol
set md5=630dbc8b8a5be6527b76d49b65c47f23
set path1=apps\wii64\
goto:downloadstart


:PL
set name=Postloader
set category=fullextract
set code1=URL
set code2="http://postloader.mooo.com/downloads/postloader.4.7.4.zip"
set version=*
set dlname="postloader.4.7.4.zip"
set wadname=postloader.4.7.4.zip
set filename=boot.dol
set md5=102acc7db95d127bb93f088d0996fd01
set path1=apps\postloader\
goto:downloadstart


:WIIX
set name=WiiXplorer
::set category=fullextract
set code1=URL
set code2="expresstek.org/xflak/files/WiiXplorer_R259.zip"
set version=*
set dlname="WiiXplorer_R259.zip"
set wadname=WiiXplorer_R259.zip
set filename=boot.dol
set md5=cf87f97410b15fc107e010e02beb14aa
set path1=apps\WiiXplorer\
goto:downloadstart


:HBB
set name=Homebrew Browser v0.3.9c
set category=fullextract
set code1=URL
set code2="http://www.codemii.com/wiihomebrew/homebrew_browser_v0.3.9c.zip"
set version=*
set dlname="homebrew_browser_v0.3.9c.zip"
set wadname=homebrew_browser_v0.3.9c.zip
set filename=boot.dol
set md5=334a432365d4054bcf972c27c54b8eac
set path1=apps\homebrew_browser\
goto:downloadstart


:WII64
set name=Wii64 beta1.1 (N64 Emulator)
set category=fullextract
set code1=URL
set code2="http://mupen64gc.googlecode.com/files/wii64-beta1.1.zip"
set version=*
set dlname="wii64-beta1.1.zip"
set wadname=wii64-beta1.1.zip
set filename=boot.dol
set md5=630dbc8b8a5be6527b76d49b65c47f23
set path1=apps\wii64\
goto:downloadstart


:Casper
set name=Casper
set category=fullextract
set code1=URL
set code2="http://s2.filetrip.net/p/5365/275825-casper_0.3.elf.tar.gz"
set version=*
set dlname="275825-casper_0.3.elf.tar.gz"
set wadname=casper_0.3.elf.tar.gz
set filename=boot.elf
set md5=3e9d8254c3b197dca97d5ceb8bb5b7db
set path1=apps\Casper\
goto:downloadstart


:Wilbrand
set name=Wilbrand
set category=fullextract
set code1=URL
set code2="https://googledrive.com/host/0BzWzf-jnAnp1YkFURFF0cDdsRUE/Wilbrand.exe"
set version=*
set dlname="Wilbrand.exe"
set wadname=Wilbrand.exe
set filename=Wilbrand.exe
set md5=0c747be356a44ad80b050ad3d18d18ab
set path1=
goto:downloadstart


:WIISX
set name=WiiSX Beta 2.1.1 (Playstation 1 Emulator)
set category=fullextract
set code1=URL
set code2="http://filetrip.net/f/32021-WiiSX-beta2.1.1[a].zip"
set version=*
set dlname="32021-WiiSX-beta2.1.1[a].zip"
set wadname=WiiSX-beta2.1.1[a].zip
set filename=boot.dol
set md5=b54900bd47ef6855fb3a018af5893b5b
set path1=apps\wiiSX\
goto:downloadstart


:Priiloader
set name=Priiloader v0.7 (236 LULZ Mod)
set code1=URL
set code2="https://googledrive.com/host/0BzWzf-jnAnp1YkFURFF0cDdsRUE/ModMii/priiloader_MOD_IOS236_r142_LULZ.zip"
set version=*
set dlname=priiloader_MOD_IOS236_r142_LULZ.zip
set wadname=priiloader_MOD_IOS236_r142_LULZ.zip
set filename=boot.dol
set md5=f3904649eb2677ffd50d8a55971826d9
set path1=apps\Priiloader\
goto:downloadstart


:PriiHacks
set name=Priiloader Hacks
set code1=URL
set code2="https://googledrive.com/host/0BzWzf-jnAnp1YkFURFF0cDdsRUE/ModMii/PriiloaderHacks_2.zip"
set version=*
set dlname="PriiloaderHacks_2.zip"
set wadname=PriiloaderHacks_2.zip
set md5=adeb7f5f6758ed4f866bd180b2180ed2
set filename=hacks.ini
set path1=
goto:downloadstart

::---------------------cIOSs----------------------
:CIOSDATABASE

:cIOS222[38]-v4
set name=cIOS222[38]-v4
set wadname=cIOS222[38]-v4
set ciosslot=unchanged
set ciosversion=
set md5=ab4b09e0b330be2ae957fc6847bce687
set md5alt=%md5%
set basewad=IOS38-64-v3610
set md5base=7fa5aa3ee9fbb041b69a190928029b29
set md5basealt=f31080503997c1fc29c0760b8c0cc38b
set code1=00000001
set code2=00000026
set version=3610
set basecios=cIOS222[38]-v4
set diffpath=%basecios%
set code2new=000000de
set lastbasemodule=0000000e
set cIOSFamilyName=hermes
set cIOSversionNum=4
goto:downloadstart

:cIOS223[37-38]-v4
set name=cIOS223[37-38]-v4
set wadname=cIOS223[37-38]-v4
set ciosslot=unchanged
set ciosversion=
set md5=606d03466c6faa398525f8ab9496ee68
set md5alt=%md5%
set basewad=IOS37-64-v3612
set md5base=8af99fa502a5035e77fc80835e91faaa
set md5basealt=e240510b257b6d28beeade967ca299e6
set code1=00000001
set code2=00000025
set version=3612
set basewadb=IOS38-64-v3610
set md5baseb=7fa5aa3ee9fbb041b69a190928029b29
set md5basebalt=f31080503997c1fc29c0760b8c0cc38b
set code1b=00000001
set code2b=00000026
set versionb=3610
set basecios=cIOS223[37-38]-v4
set diffpath=%basecios%
set code2new=000000df
set lastbasemodule=0000000e
set cIOSFamilyName=hermes
set cIOSversionNum=4
goto:downloadstart



:NMM
set name=cBC-NMMv0.2a
set wadname=cBC-NMMv0.2a
set ciosslot=unchanged
set ciosversion=
set md5=5920f84dcc5343674d08fc2c4e400b09
set md5alt=%md5%
set basewad=BC-NUS-v6
set md5base=d1593a77e24ecc95af2b393abe5d92f0
set md5basealt=%md5base%
set code1=00000001
set code2=00000100
set version=6
set basewadb=RVL-mios-v10
set md5baseb=851c27dae82bc1c758be07fa964d17cb
set md5basebalt=%md5baseb%
set code1b=00000001
set code2b=00000101
set versionb=10
set basecios=cBC-NMMv0.2a
set diffpath=%basecios%
set code2new=00000100
set lastbasemodule=
set cIOSFamilyName=
set cIOSversionNum=
set URL=http://crediar.no-ip.com/NMMv0.2a-cred.rar
set dlname=NMMv0.2a-cred.rar
goto:downloadstart


:DML
set name=DML
set code1=ZIP
set code2="http://iweb.dl.sourceforge.net/project/diosmioslite/diosmioslitesv1.3.wad"
set version=*
set dlname="diosmioslitesv1.3.wad"
set wadname=diosmioslitesv1.3.wad
set filename=diosmioslitesv1.3.wad
set md5=f3d314648cbf453dfc2c895c7cd311dc
set md5alt=%md5%
set category=fullextract
set path1=WAD\
goto:downloadstart


::HERMES V5 BASE 38
:cIOS222[38]-v5
set name=cIOS222[38]-v5
set wadname=cIOS222[38]-v5
set ciosslot=unchanged
set ciosversion=
set md5=77f1df39a24d312f988cecf4dd68e582
set md5alt=%md5%
set basewad=IOS38-64-v3867
set md5base=394298e4c9ff287e69020f2405423eb4
set md5basealt=a2f935cab6a864909325cf0e8fefc349
set code1=00000001
set code2=00000026
set version=3867
set basecios=cIOS222[38]-v5
set diffpath=%basecios%
set code2new=000000de
set lastbasemodule=0000000e
set cIOSFamilyName=hermes
set cIOSversionNum=5
goto:downloadstart


::HERMES V5 BASE 37
:cIOS223[37]-v5
set name=cIOS223[37]-v5
set wadname=cIOS223[37]-v5
set ciosslot=unchanged
set ciosversion=
set md5=a2cf208d51cea80b82059937778c15b7
set md5alt=%md5%
set basewad=IOS37-64-v3869
set md5base=5f4295741efab0d919e491b7151d5ed3
set md5basealt=47b658053d224af86ce11aa71bea0112
set code1=00000001
set code2=00000025
set version=3869
set basecios=cIOS223[37]-v5
set diffpath=%basecios%
set code2new=000000df
set lastbasemodule=0000000e
set cIOSFamilyName=hermes
set cIOSversionNum=5
goto:downloadstart

::HERMES V5 BASE 57

:cIOS224[57]-v5
set name=cIOS224[57]-v5
set wadname=cIOS224[57]-v5
set ciosslot=unchanged
set ciosversion=
set md5=ce67b890fd6dd804d75ae18093fc4235
set md5alt=%md5%
set basewad=IOS57-64-v5661
set md5base=ba50f0d46290d74d020f0afa58811e2e
set md5basealt=bca6176ccca817e722d73130a9e73258
set code1=00000001
set code2=00000039
set version=5661
set basecios=cIOS224[57]-v5
set diffpath=%basecios%
set code2new=000000e0
set lastbasemodule=00000012
set cIOSFamilyName=hermes
set cIOSversionNum=5
goto:downloadstart


:cIOS202[60]-v5.1R
set name=cIOS202[60]-v5.1R
set wadname=cIOS202[60]-v5.1R
set ciosslot=unchanged
set ciosversion=
set md5=7e455ddeeac4f831f9235b8d37a36078
set md5alt=%md5%
set basewad=IOS60-64-v6174
set md5base=a8cfd7a77016227203639713db5ac34e
set md5basealt=%md5base%
set code1=00000001
set code2=0000003C
set version=6174
set basecios=cIOS202[60]-v5.1R
set diffpath=%basecios%
set code2new=000000ca
set lastbasemodule=0000000e
set cIOSFamilyName=hermesrodries
set cIOSversionNum=6
goto:downloadstart

:cIOS222[38]-v5.1R
set name=cIOS222[38]-v5.1R
set wadname=cIOS222[38]-v5.1R
set ciosslot=unchanged
set ciosversion=
set md5=99404fcf2af266469d93fd2ae8f0fe0a
set md5alt=%md5%
set basewad=IOS38-64-v3867
set md5base=394298e4c9ff287e69020f2405423eb4
set md5basealt=a2f935cab6a864909325cf0e8fefc349
set code1=00000001
set code2=00000026
set version=3867
set basecios=cIOS222[38]-v5.1R
set diffpath=%basecios%
set code2new=000000de
set lastbasemodule=0000000e
set cIOSFamilyName=hermesrodries
set cIOSversionNum=6
goto:downloadstart

:cIOS223[37]-v5.1R
set name=cIOS223[37]-v5.1R
set wadname=cIOS223[37]-v5.1R
set ciosslot=unchanged
set ciosversion=
set md5=488f09d029346edd84701f789c99bd31
set md5alt=%md5%
set basewad=IOS37-64-v3869
set md5base=5f4295741efab0d919e491b7151d5ed3
set md5basealt=47b658053d224af86ce11aa71bea0112
set code1=00000001
set code2=00000025
set version=3869
set basecios=cIOS223[37]-v5.1R
set diffpath=%basecios%
set code2new=000000df
set lastbasemodule=0000000e
set cIOSFamilyName=hermesrodries
set cIOSversionNum=6
goto:downloadstart

:cIOS224[57]-v5.1R
set name=cIOS224[57]-v5.1R
set wadname=cIOS224[57]-v5.1R
set ciosslot=unchanged
set ciosversion=
set md5=f9d9b2967b4568e7d3c304c5e43d4952
set md5alt=%md5%
set basewad=IOS57-64-v5661
set md5base=ba50f0d46290d74d020f0afa58811e2e
set md5basealt=bca6176ccca817e722d73130a9e73258
set code1=00000001
set code2=00000039
set version=5661
set basecios=cIOS224[57]-v5.1R
set diffpath=%basecios%
set code2new=000000e0
set lastbasemodule=00000012
set cIOSFamilyName=hermesrodries
set cIOSversionNum=6
goto:downloadstart


::WANIN'S V14 BASE 38

:cIOS249-v14
set name=cIOS249-v14
set wadname=cIOS249-v14
set ciosslot=unchanged
set ciosversion=
set md5=8cb5ff74ec37bb0b6992353097f10318
set md5alt=%md5%
set basewad=IOS38-64-v3610
set md5base=f31080503997c1fc29c0760b8c0cc38b
set md5basealt=%md5base%
set code1=00000001
set code2=00000026
set version=3610
set basecios=cIOS249-v14
set diffpath=%basecios%
set code2new=000000f9
set lastbasemodule=0000000e
set cIOSFamilyName=waninkoko
set cIOSversionNum=14
goto:downloadstart

:cIOS250-v14
set name=cIOS250-v14
set wadname=cIOS250-v14
set ciosslot=250
set ciosversion=65535
set md5=bf53a319daf796c7b0467194911ba33e
set md5alt=%md5%
set basewad=IOS38-64-v3610
set md5base=f31080503997c1fc29c0760b8c0cc38b
set md5basealt=%md5base%
set code1=00000001
set code2=00000026
set version=3610
set basecios=cIOS249-v14
set diffpath=%basecios%
set code2new=000000f9
set lastbasemodule=0000000e
set cIOSFamilyName=waninkoko
set cIOSversionNum=14
goto:downloadstart


::WANIN'S V17B BASE 38

:cIOS249-v17b
set name=cIOS249-v17b
set wadname=cIOS249-v17b
set ciosslot=unchanged
set ciosversion=
set md5=dff98dfa945112aecfda31ad3900dc75
set md5alt=%md5%
set basewad=IOS38-64-v3867
set md5base=394298e4c9ff287e69020f2405423eb4
set md5basealt=a2f935cab6a864909325cf0e8fefc349
set code1=00000001
set code2=00000026
set version=3867
set basecios=cIOS249-v17b
set diffpath=%basecios%
set code2new=000000f9
set lastbasemodule=0000000e
set cIOSFamilyName=waninkoko
set cIOSversionNum=17
goto:downloadstart


:cIOS250-v17b
set name=cIOS250-v17b
set wadname=cIOS250-v17b
set ciosslot=250
set ciosversion=65535
set md5=8d8a6655bf221be8897c30aa52b1c2ac
set md5alt=%md5%
set basewad=IOS38-64-v3867
set md5base=394298e4c9ff287e69020f2405423eb4
set md5basealt=a2f935cab6a864909325cf0e8fefc349
set code1=00000001
set code2=00000026
set version=3867
set basecios=cIOS249-v17b
set diffpath=%basecios%
set code2new=000000f9
set lastbasemodule=0000000e
set cIOSFamilyName=waninkoko
set cIOSversionNum=17
goto:downloadstart



::WANIN'S V19 BASE 37
:cIOS249[37]-v19
set name=cIOS249[37]-v19
set wadname=cIOS249[37]-v19
set ciosslot=unchanged
set ciosversion=
set md5=b98ac3559567497cae3e0af28749bc64
set md5alt=%md5%
set basewad=IOS37-64-v3869
set md5base=5f4295741efab0d919e491b7151d5ed3
set md5basealt=47b658053d224af86ce11aa71bea0112
set code1=00000001
set code2=00000025
set version=3869
set basecios=cIOS249[37]-v19
set diffpath=%basecios%
set code2new=000000f9
set lastbasemodule=0000000e
set cIOSFamilyName=waninkoko
set cIOSversionNum=19
goto:downloadstart


:cIOS250[37]-v19
set name=cIOS250[37]-v19
set wadname=cIOS250[37]-v19
set ciosslot=250
set ciosversion=65535
set md5=d203532a55358f40d2607d5435dc1574
set md5alt=%md5%
set basewad=IOS37-64-v3869
set md5base=5f4295741efab0d919e491b7151d5ed3
set md5basealt=47b658053d224af86ce11aa71bea0112
set code1=00000001
set code2=00000025
set version=3869
set basecios=cIOS249[37]-v19
set diffpath=%basecios%
set code2new=000000f9
set lastbasemodule=0000000e
set cIOSFamilyName=waninkoko
set cIOSversionNum=19
goto:downloadstart



::WANIN'S V19 BASE 38
:cIOS249[38]-v19
set name=cIOS249[38]-v19
set wadname=cIOS249[38]-v19
set ciosslot=unchanged
set ciosversion=
set md5=9ba15ac66b321827e21026fa6cd1b04f
set md5alt=%md5%
set basewad=IOS38-64-v3867
set md5base=394298e4c9ff287e69020f2405423eb4
set md5basealt=a2f935cab6a864909325cf0e8fefc349
set code1=00000001
set code2=00000026
set version=3867
set basecios=cIOS249[38]-v19
set diffpath=%basecios%
set code2new=000000f9
set lastbasemodule=0000000e
set cIOSFamilyName=waninkoko
set cIOSversionNum=19
goto:downloadstart


:cIOS250[38]-v19
set name=cIOS250[38]-v19
set wadname=cIOS250[38]-v19
set ciosslot=250
set ciosversion=65535
set md5=c216987bad6bac699af0ae6c6c7d5738
set md5alt=%md5%
set basewad=IOS38-64-v3867
set md5base=394298e4c9ff287e69020f2405423eb4
set md5basealt=a2f935cab6a864909325cf0e8fefc349
set code1=00000001
set code2=00000026
set version=3867
set basecios=cIOS249[38]-v19
set diffpath=%basecios%
set code2new=000000f9
set lastbasemodule=0000000e
set cIOSFamilyName=waninkoko
set cIOSversionNum=19
goto:downloadstart


::WANIN'S V19 BASE 57
:cIOS249[57]-v19
set name=cIOS249[57]-v19
set wadname=cIOS249[57]-v19
set ciosslot=unchanged
set ciosversion=
set md5=5b756d6cc3ca20736bff8d925a9dd877
set md5alt=%md5%
set basewad=IOS57-64-v5661
set md5base=ba50f0d46290d74d020f0afa58811e2e
set md5basealt=bca6176ccca817e722d73130a9e73258
set basecios=cIOS249[57]-v19
set diffpath=%basecios%
set code1=00000001
set code2=00000039
set version=5661
set code2new=000000f9
set lastbasemodule=00000012
set cIOSFamilyName=waninkoko
set cIOSversionNum=19
goto:downloadstart


:cIOS250[57]-v19
set name=cIOS250[57]-v19
set wadname=cIOS250[57]-v19
set ciosslot=250
set ciosversion=65535
set md5=1755e220b994e45120ea905289c97724
set md5alt=%md5%
set basewad=IOS57-64-v5661
set md5base=ba50f0d46290d74d020f0afa58811e2e
set md5basealt=bca6176ccca817e722d73130a9e73258
set basecios=cIOS249[57]-v19
set diffpath=%basecios%
set code1=00000001
set code2=00000039
set version=5661
set code2new=000000f9
set lastbasemodule=00000012
set cIOSFamilyName=waninkoko
set cIOSversionNum=19
goto:downloadstart



::WANIN'S V20 BASE 38
:cIOS249[38]-v20
set name=cIOS249[38]-v20
set wadname=cIOS249[38]-v20
set ciosslot=unchanged
set ciosversion=
set md5=74b2f313224fd9ba7dec16eecea21949
set md5alt=%md5%
set basewad=IOS38-64-v4123
set md5base=fb3db1afa0685a5778cd83b148f74723
set md5basealt=%md5base%
set code1=00000001
set code2=00000026
set version=4123
set basecios=cIOS249[38]-v20
set diffpath=%basecios%
set code2new=000000f9
set lastbasemodule=0000000e
set cIOSFamilyName=waninkoko
set cIOSversionNum=20
goto:downloadstart

:cIOS250[38]-v20
set name=cIOS250[38]-v20
set wadname=cIOS250[38]-v20
set ciosslot=250
set ciosversion=65535
set md5=7a629c9288c2b89904956a2f7e07a7d0
set md5alt=%md5%
set basewad=IOS38-64-v4123
set md5base=fb3db1afa0685a5778cd83b148f74723
set md5basealt=%md5base%
set code1=00000001
set code2=00000026
set version=4123
set basecios=cIOS249[38]-v20
set diffpath=%basecios%
set code2new=000000f9
set lastbasemodule=0000000e
set cIOSFamilyName=waninkoko
set cIOSversionNum=20
goto:downloadstart


::WANIN'S V20 BASE 56
:cIOS249[56]-v20
set name=cIOS249[56]-v20
set wadname=cIOS249[56]-v20
set ciosslot=unchanged
set ciosversion=
set md5=973742ce57938744afbbe689b415da6a
set md5alt=%md5%
set basewad=IOS56-64-v5661
set md5base=726d464aa08fee191e76119ab0e0dc00
set md5basealt=%md5base%
set code1=00000001
set code2=00000038
set version=5661
set basecios=cIOS249[56]-v20
set diffpath=%basecios%
set code2new=000000f9
set lastbasemodule=0000000e
set cIOSFamilyName=waninkoko
set cIOSversionNum=20
goto:downloadstart

:cIOS250[56]-v20
set name=cIOS250[56]-v20
set wadname=cIOS250[56]-v20
set ciosslot=250
set ciosversion=65535
set md5=6e8422260eb3740be64303354f37a780
set md5alt=%md5%
set basewad=IOS56-64-v5661
set md5base=726d464aa08fee191e76119ab0e0dc00
set md5basealt=%md5base%
set code1=00000001
set code2=00000038
set version=5661
set basecios=cIOS249[56]-v20
set diffpath=%basecios%
set code2new=000000f9
set lastbasemodule=0000000e
set cIOSFamilyName=waninkoko
set cIOSversionNum=20
goto:downloadstart


::WANIN'S V20 BASE 57
:cIOS249[57]-v20
set name=cIOS249[57]-v20
set wadname=cIOS249[57]-v20
set ciosslot=unchanged
set ciosversion=
set md5=a1a157985cc99047712b018bd3059ef8
set md5alt=%md5%
set basewad=IOS57-64-v5918
set md5base=85e8101949d48a646448bde93640cdef
set md5basealt=%md5base%
set code1=00000001
set code2=00000039
set version=5918
set basecios=cIOS249[57]-v20
set diffpath=%basecios%
set code2new=000000f9
set lastbasemodule=00000012
set cIOSFamilyName=waninkoko
set cIOSversionNum=20
goto:downloadstart

:cIOS250[57]-v20
set name=cIOS250[57]-v20
set wadname=cIOS250[57]-v20
set ciosslot=250
set ciosversion=65535
set md5=128f04cca48c2bc3a2e60d7f34ce16fa
set md5alt=%md5%
set basewad=IOS57-64-v5918
set md5base=85e8101949d48a646448bde93640cdef
set md5basealt=%md5base%
set code1=00000001
set code2=00000039
set version=5918
set basecios=cIOS249[57]-v20
set diffpath=%basecios%
set code2new=000000f9
set lastbasemodule=00000012
set cIOSFamilyName=waninkoko
set cIOSversionNum=20
goto:downloadstart



::WANIN'S V21 BASE 37
:cIOS249[37]-v21
set name=cIOS249[37]-v21
set wadname=cIOS249[37]-v21
set ciosslot=unchanged
set ciosversion=
set md5=be4300b989dd53d71fcf5b8dbb940be8
set md5alt=%md5%
set basewad=IOS37-64-v5662
set md5base=bdeb8d02ba1f3de7b430fbe12560a3eb
set md5basealt=%md5base%
set code1=00000001
set code2=00000025
set version=5662
set basecios=cIOS249[37]-v21
set diffpath=%basecios%
set code2new=000000f9
set lastbasemodule=0000000e
set cIOSFamilyName=waninkoko
set cIOSversionNum=21
goto:downloadstart

:cIOS250[37]-v21
set name=cIOS250[37]-v21
set wadname=cIOS250[37]-v21
set ciosslot=250
set ciosversion=65535
set md5=15bd9700e2025a2892ea9a8bc2e88b8b
set md5alt=%md5%
set basewad=IOS37-64-v5662
set md5base=bdeb8d02ba1f3de7b430fbe12560a3eb
set md5basealt=%md5base%
set code1=00000001
set code2=00000025
set version=5662
set basecios=cIOS249[37]-v21
set diffpath=%basecios%
set code2new=000000f9
set lastbasemodule=0000000e
set cIOSFamilyName=waninkoko
set cIOSversionNum=21
goto:downloadstart


::WANIN'S V21 BASE 38
:cIOS249[38]-v21
set name=cIOS249[38]-v21
set wadname=cIOS249[38]-v21
set ciosslot=unchanged
set ciosversion=
set md5=219450b423a81517ba1d79c09947a36a
set md5alt=%md5%
set basewad=IOS38-64-v4123
set md5base=fb3db1afa0685a5778cd83b148f74723
set md5basealt=%md5base%
set code1=00000001
set code2=00000026
set version=4123
set basecios=cIOS249[38]-v21
set diffpath=%basecios%
set code2new=000000f9
set lastbasemodule=0000000e
set cIOSFamilyName=waninkoko
set cIOSversionNum=21
goto:downloadstart

:cIOS250[38]-v21
set name=cIOS250[38]-v21
set wadname=cIOS250[38]-v21
set ciosslot=250
set ciosversion=65535
set md5=cda6cdb6bd7f9419656fed1307f80e06
set md5alt=%md5%
set basewad=IOS38-64-v4123
set md5base=fb3db1afa0685a5778cd83b148f74723
set md5basealt=%md5base%
set code1=00000001
set code2=00000026
set version=4123
set basecios=cIOS249[38]-v21
set diffpath=%basecios%
set code2new=000000f9
set lastbasemodule=0000000e
set cIOSFamilyName=waninkoko
set cIOSversionNum=21
goto:downloadstart


::WANIN'S V21 BASE 53
:cIOS249[53]-v21
set name=cIOS249[53]-v21
set wadname=cIOS249[53]-v21
set ciosslot=unchanged
set ciosversion=
set md5=93057dccaef92e008d85ee71e55ec901
set md5alt=%md5%
set basewad=IOS53-64-v5662
set md5base=ce7a5174a863488655f9c97b59e1b380
set md5basealt=%md5base%
set code1=00000001
set code2=00000035
set version=5662
set basecios=cIOS249[53]-v21
set diffpath=%basecios%
set code2new=000000f9
set lastbasemodule=0000000e
set cIOSFamilyName=waninkoko
set cIOSversionNum=21
goto:downloadstart

:cIOS250[53]-v21
set name=cIOS250[53]-v21
set wadname=cIOS250[53]-v21
set ciosslot=250
set ciosversion=65535
set md5=90d4ae05fdfa8165829cae2701ff0ff4
set md5alt=%md5%
set basewad=IOS53-64-v5662
set md5base=ce7a5174a863488655f9c97b59e1b380
set md5basealt=%md5base%
set code1=00000001
set code2=00000035
set version=5662
set basecios=cIOS249[53]-v21
set diffpath=%basecios%
set code2new=000000f9
set lastbasemodule=0000000e
set cIOSFamilyName=waninkoko
set cIOSversionNum=21
goto:downloadstart


::WANIN'S V21 BASE 55
:cIOS249[55]-v21
set name=cIOS249[55]-v21
set wadname=cIOS249[55]-v21
set ciosslot=unchanged
set ciosversion=
set md5=d4a3b454438199973a1f405ce0deaed9
set md5alt=%md5%
set basewad=IOS55-64-v5662
set md5base=cf19171ee90455917e5da3ca56c52612
set md5basealt=%md5base%
set code1=00000001
set code2=00000037
set version=5662
set basecios=cIOS249[55]-v21
set diffpath=%basecios%
set code2new=000000f9
set lastbasemodule=0000000e
set cIOSFamilyName=waninkoko
set cIOSversionNum=21
goto:downloadstart

:cIOS250[55]-v21
set name=cIOS250[55]-v21
set wadname=cIOS250[55]-v21
set ciosslot=250
set ciosversion=65535
set md5=439f8b48374ad4e43a9217edafec7952
set md5alt=%md5%
set basewad=IOS55-64-v5662
set md5base=cf19171ee90455917e5da3ca56c52612
set md5basealt=%md5base%
set code1=00000001
set code2=00000037
set version=5662
set basecios=cIOS249[55]-v21
set diffpath=%basecios%
set code2new=000000f9
set lastbasemodule=0000000e
set cIOSFamilyName=waninkoko
set cIOSversionNum=21
goto:downloadstart


::WANIN'S V21 BASE 56
:cIOS249[56]-v21
set name=cIOS249[56]-v21
set wadname=cIOS249[56]-v21
set ciosslot=unchanged
set ciosversion=
set md5=ed58b6e48f5c83f25d2fb63393066af7
set md5alt=%md5%
set basewad=IOS56-64-v5661
set md5base=726d464aa08fee191e76119ab0e0dc00
set md5basealt=%md5base%
set code1=00000001
set code2=00000038
set version=5661
set basecios=cIOS249[56]-v21
set diffpath=%basecios%
set code2new=000000f9
set lastbasemodule=0000000e
set cIOSFamilyName=waninkoko
set cIOSversionNum=21
goto:downloadstart

:cIOS250[56]-v21
set name=cIOS250[56]-v21
set wadname=cIOS250[56]-v21
set ciosslot=250
set ciosversion=65535
set md5=8ea19a6026eabe99b2b38c854fe73b18
set md5alt=%md5%
set basewad=IOS56-64-v5661
set md5base=726d464aa08fee191e76119ab0e0dc00
set md5basealt=%md5base%
set code1=00000001
set code2=00000038
set version=5661
set basecios=cIOS249[56]-v21
set diffpath=%basecios%
set code2new=000000f9
set lastbasemodule=0000000e
set cIOSFamilyName=waninkoko
set cIOSversionNum=21
goto:downloadstart

::WANIN'S V21 BASE 57
:cIOS249[57]-v21
set name=cIOS249[57]-v21
set wadname=cIOS249[57]-v21
set ciosslot=unchanged
set ciosversion=
set md5=ff4a32a702a435990b3d4b155112fce6
set md5alt=%md5%
set basewad=IOS57-64-v5918
set md5base=85e8101949d48a646448bde93640cdef
set md5basealt=%md5base%
set code1=00000001
set code2=00000039
set version=5918
set basecios=cIOS249[57]-v21
set diffpath=%basecios%
set code2new=000000f9
set lastbasemodule=00000012
set cIOSFamilyName=waninkoko
set cIOSversionNum=21
goto:downloadstart

:cIOS250[57]-v21
set name=cIOS250[57]-v21
set wadname=cIOS250[57]-v21
set ciosslot=250
set ciosversion=65535
set md5=454a1892e7872534a5fdbedcf075aaee
set md5alt=%md5%
set basewad=IOS57-64-v5918
set md5base=85e8101949d48a646448bde93640cdef
set md5basealt=%md5base%
set code1=00000001
set code2=00000039
set version=5918
set basecios=cIOS249[57]-v21
set diffpath=%basecios%
set code2new=000000f9
set lastbasemodule=00000012
set cIOSFamilyName=waninkoko
set cIOSversionNum=21
goto:downloadstart


::WANIN'S V21 BASE 58
:cIOS249[58]-v21
set name=cIOS249[58]-v21
set wadname=cIOS249[58]-v21
set ciosslot=unchanged
set ciosversion=
set md5=a05755c95e4452a0ed120d9b8de4faba
set md5alt=%md5%
set basewad=IOS58-64-v6175
set md5base=791907a4993bf018cb52bf8f963cff92
set md5basealt=%md5base%
set code1=00000001
set code2=0000003a
set version=6175
set basecios=cIOS249[58]-v21
set diffpath=%basecios%
set code2new=000000f9
set lastbasemodule=00000012
set cIOSFamilyName=waninkoko
set cIOSversionNum=21
goto:downloadstart

:cIOS250[58]-v21
set name=cIOS250[58]-v21
set wadname=cIOS250[58]-v21
set ciosslot=250
set ciosversion=65535
set md5=68aa669b178f2207c56d41e13acce969
set md5alt=%md5%
set basewad=IOS58-64-v6175
set md5base=791907a4993bf018cb52bf8f963cff92
set md5basealt=%md5base%
set code1=00000001
set code2=0000003a
set version=6175
set basecios=cIOS249[58]-v21
set diffpath=%basecios%
set code2new=000000f9
set lastbasemodule=00000012
set cIOSFamilyName=waninkoko
set cIOSversionNum=21
goto:downloadstart


::d2x cIOSs

:cIOS249[37]-d2x-v8-final
set name=cIOS249[37]-d2x-v8-final
set wadname=cIOS249[37]-d2x-v8-final
set ciosslot=249
set ciosversion=21008
set md5=26b2ab4b94378b92ee2a4802f80db5d0
set md5alt=%md5%
set basewad=IOS37-64-v5662
set md5base=bdeb8d02ba1f3de7b430fbe12560a3eb
set md5basealt=%md5base%
set code1=00000001
set code2=00000025
set version=5662
set basecios=cIOS249[37]-d2x-v8-final
set diffpath=cIOS249[37]-v21
set code2new=000000f9
set lastbasemodule=0000000e
if exist support\d2x-beta\d2x-beta.bat call support\d2x-beta\d2x-beta.bat
if %ciosversion% GEQ 21009 set diffpath=%diffpath:~0,-3%d2x-v9
goto:downloadstart

:cIOS250[37]-d2x-v8-final
set name=cIOS250[37]-d2x-v8-final
set wadname=cIOS250[37]-d2x-v8-final
set ciosslot=250
set ciosversion=21008
set md5=ae84bfa60623907bb8e427b2152bf644
set md5alt=%md5%
set basewad=IOS37-64-v5662
set md5base=bdeb8d02ba1f3de7b430fbe12560a3eb
set md5basealt=%md5base%
set code1=00000001
set code2=00000025
set version=5662
set basecios=cIOS249[37]-d2x-v8-final
set diffpath=cIOS249[37]-v21
set code2new=000000f9
set lastbasemodule=0000000e
if exist support\d2x-beta\d2x-beta.bat call support\d2x-beta\d2x-beta.bat
if %ciosversion% GEQ 21009 set diffpath=%diffpath:~0,-3%d2x-v9
goto:downloadstart

:cIOS249[38]-d2x-v8-final
set name=cIOS249[38]-d2x-v8-final
set wadname=cIOS249[38]-d2x-v8-final
set ciosslot=249
set ciosversion=21008
set md5=3f6fb796a0f7353b2abdec94d54c848f
set md5alt=%md5%
set basewad=IOS38-64-v4123
set md5base=fb3db1afa0685a5778cd83b148f74723
set md5basealt=%md5base%
set code1=00000001
set code2=00000026
set version=4123
set basecios=cIOS249[38]-d2x-v8-final
set diffpath=cIOS249[38]-v21
set code2new=000000f9
set lastbasemodule=0000000e
if exist support\d2x-beta\d2x-beta.bat call support\d2x-beta\d2x-beta.bat
if %ciosversion% GEQ 21009 set diffpath=%diffpath:~0,-3%d2x-v9
goto:downloadstart

:cIOS250[38]-d2x-v8-final
set name=cIOS250[38]-d2x-v8-final
set wadname=cIOS250[38]-d2x-v8-final
set ciosslot=250
set ciosversion=21008
set md5=828434bf32e8955604fd97f279679ea4
set md5alt=%md5%
set basewad=IOS38-64-v4123
set md5base=fb3db1afa0685a5778cd83b148f74723
set md5basealt=%md5base%
set code1=00000001
set code2=00000026
set version=4123
set basecios=cIOS249[38]-d2x-v8-final
set diffpath=cIOS249[38]-v21
set code2new=000000f9
set lastbasemodule=0000000e
if exist support\d2x-beta\d2x-beta.bat call support\d2x-beta\d2x-beta.bat
if %ciosversion% GEQ 21009 set diffpath=%diffpath:~0,-3%d2x-v9
goto:downloadstart


:cIOS249[53]-d2x-v8-final
set name=cIOS249[53]-d2x-v8-final
set wadname=cIOS249[53]-d2x-v8-final
set ciosslot=249
set ciosversion=21008
set md5=45cacba5c6ec4354fdfc1897e181d0a9
set md5alt=%md5%
set basewad=IOS53-64-v5662
set md5base=ce7a5174a863488655f9c97b59e1b380
set md5basealt=%md5base%
set code1=00000001
set code2=00000035
set version=5662
set basecios=cIOS249[53]-d2x-v8-final
set diffpath=cIOS249[53]-v21
set code2new=000000f9
set lastbasemodule=0000000e
if exist support\d2x-beta\d2x-beta.bat call support\d2x-beta\d2x-beta.bat
if %ciosversion% GEQ 21009 set diffpath=%diffpath:~0,-3%d2x-v9
goto:downloadstart

:cIOS250[53]-d2x-v8-final
set name=cIOS250[53]-d2x-v8-final
set wadname=cIOS250[53]-d2x-v8-final
set ciosslot=250
set ciosversion=21008
set md5=82bae3f38f80fb75283ea8b3f9f0dcf3
set md5alt=%md5%
set basewad=IOS53-64-v5662
set md5base=ce7a5174a863488655f9c97b59e1b380
set md5basealt=%md5base%
set code1=00000001
set code2=00000035
set version=5662
set basecios=cIOS249[53]-d2x-v8-final
set diffpath=cIOS249[53]-v21
set code2new=000000f9
set lastbasemodule=0000000e
if exist support\d2x-beta\d2x-beta.bat call support\d2x-beta\d2x-beta.bat
if %ciosversion% GEQ 21009 set diffpath=%diffpath:~0,-3%d2x-v9
goto:downloadstart


:cIOS249[55]-d2x-v8-final
set name=cIOS249[55]-d2x-v8-final
set wadname=cIOS249[55]-d2x-v8-final
set ciosslot=249
set ciosversion=21008
set md5=6b89794840db07268969e42eadff65d3
set md5alt=%md5%
set basewad=IOS55-64-v5662
set md5base=cf19171ee90455917e5da3ca56c52612
set md5basealt=%md5base%
set code1=00000001
set code2=00000037
set version=5662
set basecios=cIOS249[55]-d2x-v8-final
set diffpath=cIOS249[55]-v21
set code2new=000000f9
set lastbasemodule=0000000e
if exist support\d2x-beta\d2x-beta.bat call support\d2x-beta\d2x-beta.bat
if %ciosversion% GEQ 21009 set diffpath=%diffpath:~0,-3%d2x-v9
goto:downloadstart

:cIOS250[55]-d2x-v8-final
set name=cIOS250[55]-d2x-v8-final
set wadname=cIOS250[55]-d2x-v8-final
set ciosslot=250
set ciosversion=21008
set md5=d8e2af0dc66b304e4a91ef02931681c1
set md5alt=%md5%
set basewad=IOS55-64-v5662
set md5base=cf19171ee90455917e5da3ca56c52612
set md5basealt=%md5base%
set code1=00000001
set code2=00000037
set version=5662
set basecios=cIOS249[55]-d2x-v8-final
set diffpath=cIOS249[55]-v21
set code2new=000000f9
set lastbasemodule=0000000e
if exist support\d2x-beta\d2x-beta.bat call support\d2x-beta\d2x-beta.bat
if %ciosversion% GEQ 21009 set diffpath=%diffpath:~0,-3%d2x-v9
goto:downloadstart


:cIOS249[56]-d2x-v8-final
set name=cIOS249[56]-d2x-v8-final
set wadname=cIOS249[56]-d2x-v8-final
set ciosslot=249
set ciosversion=21008
set md5=15b4f42b7c174bc59dde005d6308174b
set md5alt=%md5%
set basewad=IOS56-64-v5661
set md5base=726d464aa08fee191e76119ab0e0dc00
set md5basealt=%md5base%
set code1=00000001
set code2=00000038
set version=5661
set basecios=cIOS249[56]-d2x-v8-final
set diffpath=cIOS249[56]-v21
set code2new=000000f9
set lastbasemodule=0000000e
if exist support\d2x-beta\d2x-beta.bat call support\d2x-beta\d2x-beta.bat
if %ciosversion% GEQ 21009 set diffpath=%diffpath:~0,-3%d2x-v9
goto:downloadstart

:cIOS250[56]-d2x-v8-final
set name=cIOS250[56]-d2x-v8-final
set wadname=cIOS250[56]-d2x-v8-final
set ciosslot=250
set ciosversion=21008
set md5=7768708751021d1726c0776b805e3a6f
set md5alt=%md5%
set basewad=IOS56-64-v5661
set md5base=726d464aa08fee191e76119ab0e0dc00
set md5basealt=%md5base%
set code1=00000001
set code2=00000038
set version=5661
set basecios=cIOS249[56]-d2x-v8-final
set diffpath=cIOS249[56]-v21
set code2new=000000f9
set lastbasemodule=0000000e
if exist support\d2x-beta\d2x-beta.bat call support\d2x-beta\d2x-beta.bat
if %ciosversion% GEQ 21009 set diffpath=%diffpath:~0,-3%d2x-v9
goto:downloadstart

:cIOS249[57]-d2x-v8-final
set name=cIOS249[57]-d2x-v8-final
set wadname=cIOS249[57]-d2x-v8-final
set ciosslot=249
set ciosversion=21008
set md5=7acd515c425b45172f909c2c8d95ff40
set md5alt=%md5%
set basewad=IOS57-64-v5918
set md5base=85e8101949d48a646448bde93640cdef
set md5basealt=%md5base%
set code1=00000001
set code2=00000039
set version=5918
set basecios=cIOS249[57]-d2x-v8-final
set diffpath=cIOS249[57]-v21
set code2new=000000f9
set lastbasemodule=00000012
if exist support\d2x-beta\d2x-beta.bat call support\d2x-beta\d2x-beta.bat
if %ciosversion% GEQ 21009 set diffpath=%diffpath:~0,-3%d2x-v9
goto:downloadstart

:cIOS250[57]-d2x-v8-final
set name=cIOS250[57]-d2x-v8-final
set wadname=cIOS250[57]-d2x-v8-final
set ciosslot=250
set ciosversion=21008
set md5=7f3d117827fcd955f5675d895ae2a962
set md5alt=%md5%
set basewad=IOS57-64-v5918
set md5base=85e8101949d48a646448bde93640cdef
set md5basealt=%md5base%
set code1=00000001
set code2=00000039
set version=5918
set basecios=cIOS249[57]-d2x-v8-final
set diffpath=cIOS249[57]-v21
set code2new=000000f9
set lastbasemodule=00000012
if exist support\d2x-beta\d2x-beta.bat call support\d2x-beta\d2x-beta.bat
if %ciosversion% GEQ 21009 set diffpath=%diffpath:~0,-3%d2x-v9
goto:downloadstart


:cIOS249[58]-d2x-v8-final
set name=cIOS249[58]-d2x-v8-final
set wadname=cIOS249[58]-d2x-v8-final
set ciosslot=249
set ciosversion=21008
set md5=ff2a70cb57f8e87298748b78fb28a11c
set md5alt=%md5%
set basewad=IOS58-64-v6175
set md5base=791907a4993bf018cb52bf8f963cff92
set md5basealt=%md5base%
set code1=00000001
set code2=0000003a
set version=6175
set basecios=cIOS249[58]-d2x-v8-final
set diffpath=cIOS249[58]-v21
set code2new=000000f9
set lastbasemodule=00000012
if exist support\d2x-beta\d2x-beta.bat call support\d2x-beta\d2x-beta.bat
if %ciosversion% GEQ 21009 set diffpath=%diffpath:~0,-3%d2x-v9
goto:downloadstart

:cIOS250[58]-d2x-v8-final
set name=cIOS250[58]-d2x-v8-final
set wadname=cIOS250[58]-d2x-v8-final
set ciosslot=250
set ciosversion=21008
set md5=6388a7fb31a40c13ac8e4eff5b1e25a5
set md5alt=%md5%
set basewad=IOS58-64-v6175
set md5base=791907a4993bf018cb52bf8f963cff92
set md5basealt=%md5base%
set code1=00000001
set code2=0000003a
set version=6175
set basecios=cIOS249[58]-d2x-v8-final
set diffpath=cIOS249[58]-v21
set code2new=000000f9
set lastbasemodule=00000012
if exist support\d2x-beta\d2x-beta.bat call support\d2x-beta\d2x-beta.bat
if %ciosversion% GEQ 21009 set diffpath=%diffpath:~0,-3%d2x-v9
goto:downloadstart


:cIOS249[60]-d2x-v8-final
set name=cIOS249[60]-d2x-v8-final
set wadname=cIOS249[60]-d2x-v8-final
set ciosslot=249
set ciosversion=21008
set md5=5b6e7d60e43de908286255c8562c8705
set md5alt=%md5%
set basewad=IOS60-64-v6174
set md5base=a8cfd7a77016227203639713db5ac34e
set md5basealt=%md5base%
set code1=00000001
set code2=0000003c
set version=6174
set basecios=cIOS249[60]-d2x-v8-final
set diffpath=cIOS249[60]-v21
set code2new=000000f9
set lastbasemodule=0000000e
if exist support\d2x-beta\d2x-beta.bat call support\d2x-beta\d2x-beta.bat
if %ciosversion% GEQ 21009 set diffpath=%diffpath:~0,-3%d2x-v9
goto:downloadstart

:cIOS250[60]-d2x-v8-final
set name=cIOS250[60]-d2x-v8-final
set wadname=cIOS250[60]-d2x-v8-final
set ciosslot=250
set ciosversion=21008
set md5=54cdceddde554a2a8ca4147cda903cdf
set md5alt=%md5%
set basewad=IOS60-64-v6174
set md5base=a8cfd7a77016227203639713db5ac34e
set md5basealt=%md5base%
set code1=00000001
set code2=0000003c
set version=6174
set basecios=cIOS249[60]-d2x-v8-final
set diffpath=cIOS249[60]-v21
set code2new=000000f9
set lastbasemodule=0000000e
if exist support\d2x-beta\d2x-beta.bat call support\d2x-beta\d2x-beta.bat
if %ciosversion% GEQ 21009 set diffpath=%diffpath:~0,-3%d2x-v9
goto:downloadstart


:cIOS249[70]-d2x-v8-final
set name=cIOS249[70]-d2x-v8-final
set wadname=cIOS249[70]-d2x-v8-final
set ciosslot=249
set ciosversion=21008
set md5=3feb0755ca2ddb4b13e68eaadf990959
set md5alt=%md5%
set basewad=IOS70-64-v6687
set md5base=c38ff50344c00e17b7fe58c05d35a91c
set md5basealt=%md5base%
set code1=00000001
set code2=00000046
set version=6687
set basecios=cIOS249[70]-d2x-v8-final
set diffpath=cIOS249[70]-v21
set code2new=000000f9
set lastbasemodule=0000000e
if exist support\d2x-beta\d2x-beta.bat call support\d2x-beta\d2x-beta.bat
if %ciosversion% GEQ 21009 set diffpath=%diffpath:~0,-3%d2x-v9
goto:downloadstart

:cIOS250[70]-d2x-v8-final
set name=cIOS250[70]-d2x-v8-final
set wadname=cIOS250[70]-d2x-v8-final
set ciosslot=250
set ciosversion=21008
set md5=f51402e9d65c522bcb248d16dbc5c1ed
set md5alt=%md5%
set basewad=IOS70-64-v6687
set md5base=c38ff50344c00e17b7fe58c05d35a91c
set md5basealt=%md5base%
set code1=00000001
set code2=00000046
set version=6687
set basecios=cIOS249[70]-d2x-v8-final
set diffpath=cIOS249[70]-v21
set code2new=000000f9
set lastbasemodule=0000000e
if exist support\d2x-beta\d2x-beta.bat call support\d2x-beta\d2x-beta.bat
if %ciosversion% GEQ 21009 set diffpath=%diffpath:~0,-3%d2x-v9
goto:downloadstart

:cIOS249[80]-d2x-v8-final
set name=cIOS249[80]-d2x-v8-final
set wadname=cIOS249[80]-d2x-v8-final
set ciosslot=249
set ciosversion=21008
set md5=04d83f1ae06e6f078a1ad62c8980ae14
set md5alt=%md5%
set basewad=IOS80-64-v6943
set md5base=b6741d50aef2fde557d4e16901cf6346
set md5basealt=%md5base%
set code1=00000001
set code2=00000050
set version=6943
set basecios=cIOS249[80]-d2x-v8-final
set diffpath=cIOS249[80]-v21
set code2new=000000f9
set lastbasemodule=0000000e
if exist support\d2x-beta\d2x-beta.bat call support\d2x-beta\d2x-beta.bat
if %ciosversion% GEQ 21009 set diffpath=%diffpath:~0,-3%d2x-v9
goto:downloadstart

:cIOS250[80]-d2x-v8-final
set name=cIOS250[80]-d2x-v8-final
set wadname=cIOS250[80]-d2x-v8-final
set ciosslot=250
set ciosversion=21008
set md5=84fbd1f37ea17585e41cd3d1fcf4fee2
set md5alt=%md5%
set basewad=IOS80-64-v6943
set md5base=b6741d50aef2fde557d4e16901cf6346
set md5basealt=%md5base%
set code1=00000001
set code2=00000050
set version=6943
set basecios=cIOS249[80]-d2x-v8-final
set diffpath=cIOS249[80]-v21
set code2new=000000f9
set lastbasemodule=0000000e
if exist support\d2x-beta\d2x-beta.bat call support\d2x-beta\d2x-beta.bat
if %ciosversion% GEQ 21009 set diffpath=%diffpath:~0,-3%d2x-v9
goto:downloadstart

::------------------CMIOSs--------------------

:RVL-cMIOS-v65535(v10)_WiiGator_WiiPower_v0.2
set name=WiiGator+WiiPower cMIOS-v65535(v10)
set wadname=RVL-cMIOS-v65535(v10)_WiiGator_WiiPower_v0.2
set ciosslot=unchanged
set ciosversion=
set md5=d04d8743f86df8699f872304493f6b3a
set basewad=RVL-mios-v10
set md5base=851c27dae82bc1c758be07fa964d17cb
set code1=00000001
set code2=00000101
set version=10
set basecios=RVL-cMIOS-v65535(v10)_WiiGator_WiiPower_v0.2
set diffpath=%basecios%
set code2new=00000101
goto:downloadstart


:RVL-cmios-v4_WiiGator_GCBL_v0.2
set name=cMIOS-v4 WiiGator GCBL v0.2
set wadname=RVL-cmios-v4_WiiGator_GCBL_v0.2
set ciosslot=unchanged
set ciosversion=
set md5=3ea68908f6fdea52de2a2a2561074660
set basewad=RVL-mios-v4
set md5base=60502dbd092d941cf627ac6db95a35cf
set code1=00000001
set code2=00000101
set version=4
set basecios=RVL-cmios-v4_WiiGator_GCBL_v0.2
set diffpath=%basecios%
set code2new=00000101
goto:downloadstart

:RVL-cmios-v4_Waninkoko_rev5
set name=cMIOS-v4 Waninkoko rev5
set wadname=RVL-cmios-v4_Waninkoko_rev5
set ciosslot=unchanged
set ciosversion=
set md5=c392d59f10fbd9f3f3f2ad405c43464a
set basewad=RVL-mios-v4
set md5base=60502dbd092d941cf627ac6db95a35cf
set code1=00000001
set code2=00000101
set version=4
set basecios=RVL-cmios-v4_Waninkoko_rev5
set diffpath=%basecios%
set code2new=00000101
goto:downloadstart


::-----------THEMES-------------

:DarkWii_Red_4.1U
set name=DarkWii Red Theme (4.1U) - %effect%
set wadname=DarkWii_Red_%effect%_4.1U
if /i "%effect%" EQU "No-Spin" set md5=0f430839aefc568fa3484adc4268ad00
if /i "%effect%" EQU "Spin" set md5=cd4a8eeba57ab571b73aa5fcef832ce0
if /i "%effect%" EQU "Fast-Spin" set md5=e21155ec254b79e475e92bfb243957ee
set mym1=DarkWii_Red_No-Spin_4.XU_V2.mym
set md5mym1=d25623ec4c687bb528fad499f385983f
::000000**.app
set version=7b
set md5base=6b939de8222800733f4c44ae4eadb325
set category=themes
goto:downloadstart

:DarkWii_Red_4.2U
set name=DarkWii Red Theme (4.2U) - %effect%
set wadname=DarkWii_Red_%effect%_4.2U
if /i "%effect%" EQU "No-Spin" set md5=80e497625ac665ae6c7da2b10aca02dc
if /i "%effect%" EQU "Spin" set md5=7b6cd24a2b514438c786fdd7d973cd2c
if /i "%effect%" EQU "Fast-Spin" set md5=f90e496179292c3ee0e6e873c237b5b2
set mym1=DarkWii_Red_No-Spin_4.XU_V2.mym
set md5mym1=d25623ec4c687bb528fad499f385983f
::000000**.app
set version=87
set md5base=7079948c6aed8aae6009e4fdf27c7171
set category=themes
goto:downloadstart

:DarkWii_Red_4.3U
set name=DarkWii Red Theme (4.3U) - %effect%
set wadname=DarkWii_Red_%effect%_4.3U
if /i "%effect%" EQU "No-Spin" set md5=af96662f2e9c1d1dd5a4202287baa7b7
if /i "%effect%" EQU "Spin" set md5=b2a4eada0b3a9294d3e16606315e90a2
if /i "%effect%" EQU "Fast-Spin" set md5=8ec0145f5eb2d6c4a7454302ca8d303f
set mym1=DarkWii_Red_No-Spin_4.XU_V2.mym
set md5mym1=d25623ec4c687bb528fad499f385983f
::000000**.app
set version=97
set md5base=f388c9b11543ac2fe0912ab96064ee37
set category=themes
goto:downloadstart

:DarkWii_Red_4.1E
set name=DarkWii Red Theme (4.1E) - %effect%
set wadname=DarkWii_Red_%effect%_4.1E
if /i "%effect%" EQU "No-Spin" set md5=5d2808f2ada0febd5cb25e6b27ee73ec
if /i "%effect%" EQU "Spin" set md5=23a867a7bb009150306e65a727f60397
if /i "%effect%" EQU "Fast-Spin" set md5=5fead311c48b57434c23c97448472ace
set mym1=DarkWii_Red_No-Spin_4.XE_V2.mym
set md5mym1=543130dbc6ece1d4a666586ed084d714
::000000**.app
set version=7e
set md5base=574a3a144971ea0ec61bf8cef8d7ff80
set category=themes
goto:downloadstart

:DarkWii_Red_4.2E
set name=DarkWii Red Theme (4.2E) - %effect%
set wadname=DarkWii_Red_%effect%_4.2E
if /i "%effect%" EQU "No-Spin" set md5=98ce754a9892ecdb0a49684051eaef79
if /i "%effect%" EQU "Spin" set md5=b652028a6570f45690d8685efa15c6d1
if /i "%effect%" EQU "Fast-Spin" set md5=85b71837f9ae655ebbb8e052cfd327b8
set mym1=DarkWii_Red_No-Spin_4.XE_V2.mym
set md5mym1=543130dbc6ece1d4a666586ed084d714
::000000**.app
set version=8a
set md5base=7e7994f78941afb51e9a20085deac305
set category=themes
goto:downloadstart

:DarkWii_Red_4.3E
set name=DarkWii Red Theme (4.3E) - %effect%
set wadname=DarkWii_Red_%effect%_4.3E
if /i "%effect%" EQU "No-Spin" set md5=b856d3a18101d3bf1d0032c981f434ea
if /i "%effect%" EQU "Spin" set md5=10c3660efe3b1d46a5371ea5e55f8eb5
if /i "%effect%" EQU "Fast-Spin" set md5=7e4ed76b41a6ded82f791f379e3ef464
set mym1=DarkWii_Red_No-Spin_4.XE_V2.mym
set md5mym1=543130dbc6ece1d4a666586ed084d714
::000000**.app
set version=9a
set md5base=41310f79497c56850c37676074ee1237
set category=themes
goto:downloadstart

:DarkWii_Red_4.1J
set name=DarkWii Red Theme (4.1J) - %effect%
set wadname=DarkWii_Red_%effect%_4.1J
if /i "%effect%" EQU "No-Spin" set md5=f0dc187f779cd37c82de98825b0f92d3
if /i "%effect%" EQU "Spin" set md5=a0c767deb4eaaca1e30c792f36aa9ecf
if /i "%effect%" EQU "Fast-Spin" set md5=983f9b51fff92b6d87ad1c7c67274d7e
set mym1=DarkWii_Red_No-Spin_4.XJ_V2.mym
set md5mym1=ff34815d750afa045381a922366e85e2
::000000**.app
set version=78
set md5base=f2eadf12d18e793373060222b870057d
set category=themes
goto:downloadstart

:DarkWii_Red_4.2J
set name=DarkWii Red Theme (4.2J) - %effect%
set wadname=DarkWii_Red_%effect%_4.2J
if /i "%effect%" EQU "No-Spin" set md5=d6c1d942b2529ea4d202ae29c42b5f89
if /i "%effect%" EQU "Spin" set md5=671caf4a1902c4aa206f844a3a48bc8a
if /i "%effect%" EQU "Fast-Spin" set md5=5abef476307f95e7568b6fcf1347685c
set mym1=DarkWii_Red_No-Spin_4.XJ_V2.mym
set md5mym1=ff34815d750afa045381a922366e85e2
::000000**.app
set version=84
set md5base=b08998e582c48afba3a14f6d9e1e9373
set category=themes
goto:downloadstart

:DarkWii_Red_4.3J
set name=DarkWii Red Theme (4.3J) - %effect%
set wadname=DarkWii_Red_%effect%_4.3J
if /i "%effect%" EQU "No-Spin" set md5=31908e602aca4792246672c47c365d05
if /i "%effect%" EQU "Spin" set md5=213c0c6af94b03b151c5fd36241b8d3f
if /i "%effect%" EQU "Fast-Spin" set md5=f111a56156a84f0d89e44dfcc66cbccc
set mym1=DarkWii_Red_No-Spin_4.XJ_V2.mym
set md5mym1=ff34815d750afa045381a922366e85e2
::000000**.app
set version=94
set md5base=5b3ee6942a3cda716badbce3665076fc
set category=themes
goto:downloadstart

:DarkWii_Red_4.1K
set name=DarkWii Red Theme (4.1K) - %effect%
set wadname=DarkWii_Red_%effect%_4.1K
if /i "%effect%" EQU "No-Spin" set md5=0d02e9b608250100f57adf961b289b8f
if /i "%effect%" EQU "Spin" set md5=5c33518011fceaab7711b033cd801a71
if /i "%effect%" EQU "Fast-Spin" set md5=1d132063312b9f1df8d9a04683025859
set mym1=DarkWii_Red_No-Spin_4.XK_V2.mym
set md5mym1=39621a542fb6870286c0fb672084ab05
::000000**.app
set version=81
set md5base=7eedbf1a146b29b63edbb55e04f81f98
set category=themes
goto:downloadstart

:DarkWii_Red_4.2K
set name=DarkWii Red Theme (4.2K) - %effect%
set wadname=DarkWii_Red_%effect%_4.2K
if /i "%effect%" EQU "No-Spin" set md5=3f7f7b0f6724bc14dc64d545b7fcea35
if /i "%effect%" EQU "Spin" set md5=13742e852400523120dba4868d244db5
if /i "%effect%" EQU "Fast-Spin" set md5=f24fdcb08b4ffd683da07279fd298a59
set mym1=DarkWii_Red_No-Spin_4.XK_V2.mym
set md5mym1=39621a542fb6870286c0fb672084ab05
::000000**.app
set version=8d
set md5base=9d72a1966370e44cb4c456c17a077bec
set category=themes
goto:downloadstart

:DarkWii_Red_4.3K
set name=DarkWii Red Theme (4.3K) - %effect%
set wadname=DarkWii_Red_%effect%_4.3K
if /i "%effect%" EQU "No-Spin" set md5=d58a46aea5f54b046e6cc852d24824ff
if /i "%effect%" EQU "Spin" set md5=32436f754ba6ae46c683c282d68d0a42
if /i "%effect%" EQU "Fast-Spin" set md5=a8f0d889830318d5dc16c0502a5b27da
set mym1=DarkWii_Red_No-Spin_4.XK_V2.mym
set md5mym1=39621a542fb6870286c0fb672084ab05
::000000**.app
set version=9d
set md5base=e6f2b0d4d5e0c095895f186009bf9516
set category=themes
goto:downloadstart

:DarkWii_Green_4.1U
set name=DarkWii Green Theme (4.1U) - %effect%
set wadname=DarkWii_Green_%effect%_4.1U
if /i "%effect%" EQU "No-Spin" set md5=9c8a1da95cc54f6bfd1faf5ae1d4e021
if /i "%effect%" EQU "Spin" set md5=d126560bd9d4612e8525df976ad49b45
if /i "%effect%" EQU "Fast-Spin" set md5=e1f41c450b4af317552f9748b2ab3d6f
set mym1=DarkWii_Green_No-Spin_4.XU_V2.mym
set md5mym1=69cbc2704736d99c2011d023794b0ac0
::000000**.app
set version=7b
set md5base=6b939de8222800733f4c44ae4eadb325
set category=themes
goto:downloadstart

:DarkWii_Green_4.2U
set name=DarkWii Green Theme (4.2U) - %effect%
set wadname=DarkWii_Green_%effect%_4.2U
if /i "%effect%" EQU "No-Spin" set md5=a21a373931c1a75d371d9d4a1f138e43
if /i "%effect%" EQU "Spin" set md5=ba45a375eabd287f6359ddaedf607b3e
if /i "%effect%" EQU "Fast-Spin" set md5=8d02351f224798f3f2128554aa06a656
set mym1=DarkWii_Green_No-Spin_4.XU_V2.mym
set md5mym1=69cbc2704736d99c2011d023794b0ac0
::000000**.app
set version=87
set md5base=7079948c6aed8aae6009e4fdf27c7171
set category=themes
goto:downloadstart

:DarkWii_Green_4.3U
set name=DarkWii Green Theme (4.3U) - %effect%
set wadname=DarkWii_Green_%effect%_4.3U
if /i "%effect%" EQU "No-Spin" set md5=a95a92666e108784e0bff6440457e31a
if /i "%effect%" EQU "Spin" set md5=c0918ae513c261dda53604b1b771b32b
if /i "%effect%" EQU "Fast-Spin" set md5=f5801cd8e94531a5541c78820c9e805d
set mym1=DarkWii_Green_No-Spin_4.XU_V2.mym
set md5mym1=69cbc2704736d99c2011d023794b0ac0
::000000**.app
set version=97
set md5base=f388c9b11543ac2fe0912ab96064ee37
set category=themes
goto:downloadstart

:DarkWii_Green_4.1E
set name=DarkWii Green Theme (4.1E) - %effect%
set wadname=DarkWii_Green_%effect%_4.1E
if /i "%effect%" EQU "No-Spin" set md5=55978344479c3abf6c9648e92c58209c
if /i "%effect%" EQU "Spin" set md5=7593de2d43e4b774747e0139e6be2cc1
if /i "%effect%" EQU "Fast-Spin" set md5=dcffb6be25e2b0fa75e6cfb04070cf7a
set mym1=DarkWii_Green_No-Spin_4.XE_V2.mym
set md5mym1=34c991872b67273307c7bc7aa522b09d
::000000**.app
set version=7e
set md5base=574a3a144971ea0ec61bf8cef8d7ff80
set category=themes
goto:downloadstart

:DarkWii_Green_4.2E
set name=DarkWii Green Theme (4.2E) - %effect%
set wadname=DarkWii_Green_%effect%_4.2E
if /i "%effect%" EQU "No-Spin" set md5=bb2a3f079ca17b19a5953aff98e8ba9d
if /i "%effect%" EQU "Spin" set md5=fc5145a1a019b53373a551db4975716b
if /i "%effect%" EQU "Fast-Spin" set md5=3ea3db1216e391acb3f697b2d60e9205
set mym1=DarkWii_Green_No-Spin_4.XE_V2.mym
set md5mym1=34c991872b67273307c7bc7aa522b09d
::000000**.app
set version=8a
set md5base=7e7994f78941afb51e9a20085deac305
set category=themes
goto:downloadstart

:DarkWii_Green_4.3E
set name=DarkWii Green Theme (4.3E) - %effect%
set wadname=DarkWii_Green_%effect%_4.3E
if /i "%effect%" EQU "No-Spin" set md5=4cc51aec0f96c28cfe512027b9e555aa
if /i "%effect%" EQU "Spin" set md5=6fb674c723178f7ea498bf074f9f0608
if /i "%effect%" EQU "Fast-Spin" set md5=8a60eff1a5fa8317d488b18f804a225a
set mym1=DarkWii_Green_No-Spin_4.XE_V2.mym
set md5mym1=34c991872b67273307c7bc7aa522b09d
::000000**.app
set version=9a
set md5base=41310f79497c56850c37676074ee1237
set category=themes
goto:downloadstart

:DarkWii_Green_4.1J
set name=DarkWii Green Theme (4.1J) - %effect%
set wadname=DarkWii_Green_%effect%_4.1J
if /i "%effect%" EQU "No-Spin" set md5=123b0aaa666130870ea1429a41fe6c3b
if /i "%effect%" EQU "Spin" set md5=79777d404510de7daaa644d52098b9aa
if /i "%effect%" EQU "Fast-Spin" set md5=3f8ece6fc24c4a7282420dd577b1e33b
set mym1=DarkWii_Green_No-Spin_4.XJ_V2.mym
set md5mym1=61a8d22e0211a3c5d09cb4cf61594f7b
::000000**.app
set version=78
set md5base=f2eadf12d18e793373060222b870057d
set category=themes
goto:downloadstart

:DarkWii_Green_4.2J
set name=DarkWii Green Theme (4.2J) - %effect%
set wadname=DarkWii_Green_%effect%_4.2J
if /i "%effect%" EQU "No-Spin" set md5=94a5574332ffb10202cc4a96bce2929f
if /i "%effect%" EQU "Spin" set md5=e281370faf9f4df752c2434939578821
if /i "%effect%" EQU "Fast-Spin" set md5=efedef0be7dd31e9ad04929b2b7cc2dd
set mym1=DarkWii_Green_No-Spin_4.XJ_V2.mym
set md5mym1=61a8d22e0211a3c5d09cb4cf61594f7b
::000000**.app
set version=84
set md5base=b08998e582c48afba3a14f6d9e1e9373
set category=themes
goto:downloadstart

:DarkWii_Green_4.3J
set name=DarkWii Green Theme (4.3J) - %effect%
set wadname=DarkWii_Green_%effect%_4.3J
if /i "%effect%" EQU "No-Spin" set md5=e455ffe8dc5f014424fd409bf22482fc
if /i "%effect%" EQU "Spin" set md5=a347897ea4e6382adcf4e4d50d21f7bf
if /i "%effect%" EQU "Fast-Spin" set md5=438e431f41b447a04467657670741300
set mym1=DarkWii_Green_No-Spin_4.XJ_V2.mym
set md5mym1=61a8d22e0211a3c5d09cb4cf61594f7b
::000000**.app
set version=94
set md5base=5b3ee6942a3cda716badbce3665076fc
set category=themes
goto:downloadstart

:DarkWii_Green_4.1K
set name=DarkWii Green Theme (4.1K) - %effect%
set wadname=DarkWii_Green_%effect%_4.1K
if /i "%effect%" EQU "No-Spin" set md5=72ea69f2c27fd0f794ac4293e8218261
if /i "%effect%" EQU "Spin" set md5=3a8aff97f364512d212873f21859df65
if /i "%effect%" EQU "Fast-Spin" set md5=7d8f8fc8e82326a177caacfef8ef42b5
set mym1=DarkWii_Green_No-Spin_4.XK_V2.mym
set md5mym1=46e8ff2f49142ea3b6877a4a636de941
::000000**.app
set version=81
set md5base=7eedbf1a146b29b63edbb55e04f81f98
set category=themes
goto:downloadstart

:DarkWii_Green_4.2K
set name=DarkWii Green Theme (4.2K) - %effect%
set wadname=DarkWii_Green_%effect%_4.2K
if /i "%effect%" EQU "No-Spin" set md5=1da76c9d9bdb4e38040c9005e9e6625d
if /i "%effect%" EQU "Spin" set md5=62615599504b3766fb48ca9a3d4bd98d
if /i "%effect%" EQU "Fast-Spin" set md5=4c00d803ecc007a35bc80f82bd279285
set mym1=DarkWii_Green_No-Spin_4.XK_V2.mym
set md5mym1=46e8ff2f49142ea3b6877a4a636de941
::000000**.app
set version=8d
set md5base=9d72a1966370e44cb4c456c17a077bec
set category=themes
goto:downloadstart

:DarkWii_Green_4.3K
set name=DarkWii Green Theme (4.3K) - %effect%
set wadname=DarkWii_Green_%effect%_4.3K
if /i "%effect%" EQU "No-Spin" set md5=456e48400c03669afbb8b01037414476
if /i "%effect%" EQU "Spin" set md5=79332285facf4d15be00a29208cc5360
if /i "%effect%" EQU "Fast-Spin" set md5=28f8fe2472eba0c5e01964d395a7ac08
set mym1=DarkWii_Green_No-Spin_4.XK_V2.mym
set md5mym1=46e8ff2f49142ea3b6877a4a636de941
::000000**.app
set version=9d
set md5base=e6f2b0d4d5e0c095895f186009bf9516
set category=themes
goto:downloadstart

::---Dark Wii Blue Themes and SM WADs----

:DarkWii_Blue_4.1U
set name=DarkWii Blue Theme (4.1U) - %effect%
set wadname=DarkWii_Blue_%effect%_4.1U
if /i "%effect%" EQU "No-Spin" set md5=210c117c8f83703fd285908766de0174
if /i "%effect%" EQU "Spin" set md5=d2033d8225dcc871fc425e83963ffaf6
if /i "%effect%" EQU "Fast-Spin" set md5=9369c387c51a82d6394072b86100239c
set mym1=DarkWii_Blue_No-Spin_4.XU_V2.mym
set md5mym1=3c40c39f4de5a9a60ca02b5a2b997378
::000000**.app
set version=7b
set md5base=6b939de8222800733f4c44ae4eadb325
set category=themes
goto:downloadstart

:DarkWii_Blue_4.2U
set name=DarkWii Blue Theme (4.2U) - %effect%
set wadname=DarkWii_Blue_%effect%_4.2U
if /i "%effect%" EQU "No-Spin" set md5=bad63e617f576483858a8180c109f4a7
if /i "%effect%" EQU "Spin" set md5=870e9c1b262c147f2f21b404840e6c20
if /i "%effect%" EQU "Fast-Spin" set md5=8322da4895c6a4e0eeeebd96f3b0ebdb
set mym1=DarkWii_Blue_No-Spin_4.XU_V2.mym
set md5mym1=3c40c39f4de5a9a60ca02b5a2b997378
::000000**.app
set version=87
set md5base=7079948c6aed8aae6009e4fdf27c7171
set category=themes
goto:downloadstart

:DarkWii_Blue_4.3U
set name=DarkWii Blue Theme (4.3U) - %effect%
set wadname=DarkWii_Blue_%effect%_4.3U
if /i "%effect%" EQU "No-Spin" set md5=a138e0e5c3c8dc2126ee0944c009e6e7
if /i "%effect%" EQU "Spin" set md5=dac3b3da8049c40e32789a9e343cbbca
if /i "%effect%" EQU "Fast-Spin" set md5=900440dc47ce8124bf4450c1a7bf3b87
set mym1=DarkWii_Blue_No-Spin_4.XU_V2.mym
set md5mym1=3c40c39f4de5a9a60ca02b5a2b997378
::000000**.app
set version=97
set md5base=f388c9b11543ac2fe0912ab96064ee37
set category=themes
goto:downloadstart

:DarkWii_Blue_4.1E
set name=DarkWii Blue Theme (4.1E) - %effect%
set wadname=DarkWii_Blue_%effect%_4.1E
if /i "%effect%" EQU "No-Spin" set md5=d37933cef8d38042b75a194ec4fe8c86
if /i "%effect%" EQU "Spin" set md5=a5d7ba4af7ab5a890a8eb290dee55e08
if /i "%effect%" EQU "Fast-Spin" set md5=067ac1f3442479b4a482cf326220a997
set mym1=DarkWii_Blue_No-Spin_4.XE_V2.mym
set md5mym1=26f80d142dec2451e65f8ef03d108413
::000000**.app
set version=7e
set md5base=574a3a144971ea0ec61bf8cef8d7ff80
set category=themes
goto:downloadstart

:DarkWii_Blue_4.2E
set name=DarkWii Blue Theme (4.2E) - %effect%
set wadname=DarkWii_Blue_%effect%_4.2E
if /i "%effect%" EQU "No-Spin" set md5=7e2711437a4845f54da8155f6927943e
if /i "%effect%" EQU "Spin" set md5=3e224810851860a98fc29fb52e818182
if /i "%effect%" EQU "Fast-Spin" set md5=d44a1d716e1970ea2855536b09430a41
set mym1=DarkWii_Blue_No-Spin_4.XE_V2.mym
set md5mym1=26f80d142dec2451e65f8ef03d108413
::000000**.app
set version=8a
set md5base=7e7994f78941afb51e9a20085deac305
set category=themes
goto:downloadstart

:DarkWii_Blue_4.3E
set name=DarkWii Blue Theme (4.3E) - %effect%
set wadname=DarkWii_Blue_%effect%_4.3E
if /i "%effect%" EQU "No-Spin" set md5=16d6022b7ed02be1ece7532e0e194e61
if /i "%effect%" EQU "Spin" set md5=0359e736f2ec0bf0a66172bf4ef1bb96
if /i "%effect%" EQU "Fast-Spin" set md5=5610abac827b30dc6243ae5e05b4101c
set mym1=DarkWii_Blue_No-Spin_4.XE_V2.mym
set md5mym1=26f80d142dec2451e65f8ef03d108413
::000000**.app
set version=9a
set md5base=41310f79497c56850c37676074ee1237
set category=themes
goto:downloadstart

:DarkWii_Blue_4.1J
set name=DarkWii Blue Theme (4.1J) - %effect%
set wadname=DarkWii_Blue_%effect%_4.1J
if /i "%effect%" EQU "No-Spin" set md5=14f74e0341bbf4a533dd569a0f25ebd5
if /i "%effect%" EQU "Spin" set md5=234a4677c0f0cb6e76dfb30cdcf9d8da
if /i "%effect%" EQU "Fast-Spin" set md5=d1372f1b5fd39436f9d58c0c4c6e701e
set mym1=DarkWii_Blue_No-Spin_4.XJ_V2.mym
set md5mym1=eecc84e34a5a1462b382f44df6d8d802
::000000**.app
set version=78
set md5base=f2eadf12d18e793373060222b870057d
set category=themes
goto:downloadstart

:DarkWii_Blue_4.2J
set name=DarkWii Blue Theme (4.2J) - %effect%
set wadname=DarkWii_Blue_%effect%_4.2J
if /i "%effect%" EQU "No-Spin" set md5=4fbcc2b31d147eaaa1745cb97b3ef5ee
if /i "%effect%" EQU "Spin" set md5=d8052800ce506c2024af6633c243b4c6
if /i "%effect%" EQU "Fast-Spin" set md5=a31f665db7d033ce7baadded8b32bec2
set mym1=DarkWii_Blue_No-Spin_4.XJ_V2.mym
set md5mym1=eecc84e34a5a1462b382f44df6d8d802
::000000**.app
set version=84
set md5base=b08998e582c48afba3a14f6d9e1e9373
set category=themes
goto:downloadstart

:DarkWii_Blue_4.3J
set name=DarkWii Blue Theme (4.3J) - %effect%
set wadname=DarkWii_Blue_%effect%_4.3J
if /i "%effect%" EQU "No-Spin" set md5=4ce11520cb808ec371009c4f3510d9c2
if /i "%effect%" EQU "Spin" set md5=12012bd6991ddc47296944fb3aa5adef
if /i "%effect%" EQU "Fast-Spin" set md5=e415a0992b424d61681df7d6de34046e
set mym1=DarkWii_Blue_No-Spin_4.XJ_V2.mym
set md5mym1=eecc84e34a5a1462b382f44df6d8d802
::000000**.app
set version=94
set md5base=5b3ee6942a3cda716badbce3665076fc
set category=themes
goto:downloadstart

:DarkWii_Blue_4.1K
set name=DarkWii Blue Theme (4.1K) - %effect%
set wadname=DarkWii_Blue_%effect%_4.1K
if /i "%effect%" EQU "No-Spin" set md5=0be900532ba6a4c6325d461ec0baf840
if /i "%effect%" EQU "Spin" set md5=de5b614d6396cdc757de30d7c557c40d
if /i "%effect%" EQU "Fast-Spin" set md5=52d1e1c1e4be4d889c7e319f4cea1d64
set mym1=DarkWii_Blue_No-Spin_4.XK_V2.mym
set md5mym1=7b227edb0c3bfe21a299c86404d47410
::000000**.app
set version=81
set md5base=7eedbf1a146b29b63edbb55e04f81f98
set category=themes
goto:downloadstart

:DarkWii_Blue_4.2K
set name=DarkWii Blue Theme (4.2K) - %effect%
set wadname=DarkWii_Blue_%effect%_4.2K
if /i "%effect%" EQU "No-Spin" set md5=a0e63ca6ca5b434da47df55eb034990d
if /i "%effect%" EQU "Spin" set md5=5876807beca95ea0aa81d36e0a0d6fb8
if /i "%effect%" EQU "Fast-Spin" set md5=7ed2fcfa8c3d00eb9367a0c2a09b3a5f
set mym1=DarkWii_Blue_No-Spin_4.XK_V2.mym
set md5mym1=7b227edb0c3bfe21a299c86404d47410
::000000**.app
set version=8d
set md5base=9d72a1966370e44cb4c456c17a077bec
set category=themes
goto:downloadstart

:DarkWii_Blue_4.3K
set name=DarkWii Blue Theme (4.3K) - %effect%
set wadname=DarkWii_Blue_%effect%_4.3K
if /i "%effect%" EQU "No-Spin" set md5=9deb7dba3aea0c7e735ffbe06e8b7cb1
if /i "%effect%" EQU "Spin" set md5=5470b57328fdead6fd18a1e880b1ed6f
if /i "%effect%" EQU "Fast-Spin" set md5=68c16e3df7aeb131b6ee20c5cf89db84
set mym1=DarkWii_Blue_No-Spin_4.XK_V2.mym
set md5mym1=7b227edb0c3bfe21a299c86404d47410
::000000**.app
set version=9d
set md5base=e6f2b0d4d5e0c095895f186009bf9516
set category=themes
goto:downloadstart


::----------------------------------


:SM4.3U-DWB
set name=System Menu 4.3U with Dark Wii Blue Theme - %effect%
set wadname=SystemMenu_4.3U_v513_DarkWiiBlue_%effect%
set ciosslot=unchanged
if /i "%effect%" EQU "No-Spin" set md5=b1ab3742967ac562d3e16213365acff0
if /i "%effect%" EQU "Spin" set md5=cc280370723d7a0cf0f13167653dd943
if /i "%effect%" EQU "Fast-Spin" set md5=ea2513e5cbcdd1b6f21c2054813fcca1
set md5alt=%md5%
set basewad=SystemMenu_4.3U_v513
set basecios=%basewad%
set md5base=4f5c63e3fd1bf732067fa4c439c68a97
set md5basealt=%md5base%
set code1=00000001
set code2=00000002
set mym1=DarkWii_Blue_No-Spin_4.XU_V2.mym
set md5mym1=3c40c39f4de5a9a60ca02b5a2b997378
set version=513
set lastbasemodule=00000001
set category=SMTHEME
goto:downloadstart

:SM4.2U-DWB
set name=System Menu 4.2U with Dark Wii Blue Theme - %effect%
set wadname=SystemMenu_4.2U_v481_DarkWiiBlue_%effect%
set ciosslot=unchanged
if /i "%effect%" EQU "No-Spin" set md5=75bad5b1d03a6342bdad4c98199574cb
if /i "%effect%" EQU "Spin" set md5=c7297adee75b725590b110c5bbd70e4a
if /i "%effect%" EQU "Fast-Spin" set md5=ee834dd946089fdc54e7d1aa462b6803
set md5alt=%md5%
set basewad=SystemMenu_4.2U_v481
set basecios=%basewad%
set md5base=4ac52b981845473bd3655e4836d7442b
set md5basealt=%md5base%
set code1=00000001
set code2=00000002
set mym1=DarkWii_Blue_No-Spin_4.XU_V2.mym
set md5mym1=3c40c39f4de5a9a60ca02b5a2b997378
set version=481
set lastbasemodule=00000001
set category=SMTHEME
goto:downloadstart

:SM4.1U-DWB
set name=System Menu 4.1U with Dark Wii Blue Theme - %effect%
set wadname=SystemMenu_4.1U_v449_DarkWiiBlue_%effect%
set ciosslot=unchanged
if /i "%effect%" EQU "No-Spin" set md5=5232566b8671b2f1042605fd7a6601b1
if /i "%effect%" EQU "Spin" set md5=953bf5e808428ddbe9f1b5bd40520c2a
if /i "%effect%" EQU "Fast-Spin" set md5=f9244e74e238bd4a229858c3812d2ce5
set md5alt=%md5%
set basewad=SystemMenu_4.1U_v449
set basecios=%basewad%
set md5base=38a95a9acd257265294be41b796f6239
set md5basealt=%md5base%
set code1=00000001
set code2=00000002
set mym1=DarkWii_Blue_No-Spin_4.XU_V2.mym
set md5mym1=3c40c39f4de5a9a60ca02b5a2b997378
set version=449
set lastbasemodule=00000001
set category=SMTHEME
goto:downloadstart

:SM4.3E-DWB
set name=System Menu 4.3E with Dark Wii Blue Theme - %effect%
set wadname=SystemMenu_4.3E_v514_DarkWiiBlue_%effect%
set ciosslot=unchanged
if /i "%effect%" EQU "No-Spin" set md5=46c3a6cde1b78402169c4a81af8a4d66
if /i "%effect%" EQU "Spin" set md5=8d9a36a01ac98ceec8e11768371fc186
if /i "%effect%" EQU "Fast-Spin" set md5=85a881e197aba4476d3c5dd03e705b9d
set md5alt=%md5%
set basewad=SystemMenu_4.3E_v514
set basecios=%basewad%
set md5base=2ec2e6fbdfc52fe5174749e7032f1bad
set md5basealt=%md5base%
set code1=00000001
set code2=00000002
set mym1=DarkWii_Blue_No-Spin_4.XE_V2.mym
set md5mym1=26f80d142dec2451e65f8ef03d108413
set version=514
set lastbasemodule=00000001
set category=SMTHEME
goto:downloadstart

:SM4.2E-DWB
set name=System Menu 4.2E with Dark Wii Blue Theme - %effect%
set wadname=SystemMenu_4.2E_v482_DarkWiiBlue_%effect%
set ciosslot=unchanged
if /i "%effect%" EQU "No-Spin" set md5=2484f10fee5c9aeebbf2edccb7c368e4
if /i "%effect%" EQU "Spin" set md5=ece08aabb3465d8fb783ed4a2b53093a
if /i "%effect%" EQU "Fast-Spin" set md5=87ccfd648c3c1ffe351f7b67745d2892
set md5alt=%md5%
set basewad=SystemMenu_4.2E_v482
set basecios=%basewad%
set md5base=7d77be8b6df5ac893d24652db33d02cd
set md5basealt=%md5base%
set code1=00000001
set code2=00000002
set mym1=DarkWii_Blue_No-Spin_4.XE_V2.mym
set md5mym1=26f80d142dec2451e65f8ef03d108413
set version=482
set lastbasemodule=00000001
set category=SMTHEME
goto:downloadstart

:SM4.1E-DWB
set name=System Menu 4.1E with Dark Wii Blue Theme - %effect%
set wadname=SystemMenu_4.1E_v450_DarkWiiBlue_%effect%
set ciosslot=unchanged
if /i "%effect%" EQU "No-Spin" set md5=bb2cc00ef2240f9ee30f96923c8ec10f
if /i "%effect%" EQU "Spin" set md5=0de7cce13ddc60b12ea03fc4ebb443c2
if /i "%effect%" EQU "Fast-Spin" set md5=54e597368370778548d09ee2b557ae81
set md5alt=%md5%
set basewad=SystemMenu_4.1E_v450
set basecios=%basewad%
set md5base=688cc78b8eab4e30da04f01a81a3739f
set md5basealt=%md5base%
set code1=00000001
set code2=00000002
set mym1=DarkWii_Blue_No-Spin_4.XE_V2.mym
set md5mym1=26f80d142dec2451e65f8ef03d108413
set version=450
set lastbasemodule=00000001
set category=SMTHEME
goto:downloadstart

:SM4.3J-DWB
set name=System Menu 4.3J with Dark Wii Blue Theme - %effect%
set wadname=SystemMenu_4.3J_v512_DarkWiiBlue_%effect%
set ciosslot=unchanged
if /i "%effect%" EQU "No-Spin" set md5=a02af61f9181ddd846af137c721b2166
if /i "%effect%" EQU "Spin" set md5=45e9bdb66c284220084f63d41bd26bf7
if /i "%effect%" EQU "Fast-Spin" set md5=b9862f07bc406f347134b3a363e8414f
set md5alt=%md5%
set basewad=SystemMenu_4.3J_v512
set basecios=%basewad%
set md5base=df67ed4bd8f8f117741fef7952ee5c17
set md5basealt=%md5base%
set code1=00000001
set code2=00000002
set mym1=DarkWii_Blue_No-Spin_4.XJ_V2.mym
set md5mym1=eecc84e34a5a1462b382f44df6d8d802
set version=512
set lastbasemodule=00000001
set category=SMTHEME
goto:downloadstart

:SM4.2J-DWB
set name=System Menu 4.2J with Dark Wii Blue Theme - %effect%
set wadname=SystemMenu_4.2J_v480_DarkWiiBlue_%effect%
set ciosslot=unchanged
if /i "%effect%" EQU "No-Spin" set md5=c0115123bc94fdbb3b66a87a266346c3
if /i "%effect%" EQU "Spin" set md5=8c1fdc5b1428869879f5f2a8ca5424e6
if /i "%effect%" EQU "Fast-Spin" set md5=0f71bd8583d6fc89773f484a33515a35
set md5alt=%md5%
set basewad=SystemMenu_4.2J_v480
set basecios=%basewad%
set md5base=0413a9aed208b193fea85db908bbdabf
set md5basealt=%md5base%
set code1=00000001
set code2=00000002
set mym1=DarkWii_Blue_No-Spin_4.XJ_V2.mym
set md5mym1=eecc84e34a5a1462b382f44df6d8d802
set version=480
set lastbasemodule=00000001
set category=SMTHEME
goto:downloadstart

:SM4.1J-DWB
set name=System Menu 4.1J with Dark Wii Blue Theme - %effect%
set wadname=SystemMenu_4.1J_v448_DarkWiiBlue_%effect%
set ciosslot=unchanged
if /i "%effect%" EQU "No-Spin" set md5=25b0e426fd959272d7af3fc49473b05b
if /i "%effect%" EQU "Spin" set md5=e8ebc2998717a4dd0842c1c87db6dac3
if /i "%effect%" EQU "Fast-Spin" set md5=4764cbc97b0bd0e685b6505c325dc1ce
set md5alt=%md5%
set basewad=SystemMenu_4.1J_v448
set basecios=%basewad%
set md5base=6edb4b3f7ca26c643c6bc662d159ec2e
set md5basealt=%md5base%
set code1=00000001
set code2=00000002
set mym1=DarkWii_Blue_No-Spin_4.XJ_V2.mym
set md5mym1=eecc84e34a5a1462b382f44df6d8d802
set version=448
set lastbasemodule=00000001
set category=SMTHEME
goto:downloadstart


:SM4.3K-DWB
set name=System Menu 4.3K with Dark Wii Blue Theme - %effect%
set wadname=SystemMenu_4.3K_v518_DarkWiiBlue_%effect%
set ciosslot=unchanged
if /i "%effect%" EQU "No-Spin" set md5=fe6e416cad7c48b9a22956ce3e9e68c8
if /i "%effect%" EQU "Spin" set md5=2b9de6c1ee1ef36f3ac841ae186cb936
if /i "%effect%" EQU "Fast-Spin" set md5=12307e017adb1a1d3e38c13c760fe357
set md5alt=%md5%
set basewad=SystemMenu_4.3K_v518
set basecios=%basewad%
set md5base=6ed8f9e75b0a54eacfbacce57c20136d
set md5basealt=%md5base%
set code1=00000001
set code2=00000002
set mym1=DarkWii_Blue_No-Spin_4.XK_V2.mym
set md5mym1=7b227edb0c3bfe21a299c86404d47410
set version=518
set lastbasemodule=00000001
set category=SMTHEME
goto:downloadstart

:SM4.2K-DWB
set name=System Menu 4.2K with Dark Wii Blue Theme - %effect%
set wadname=SystemMenu_4.2K_v486_DarkWiiBlue_%effect%
set ciosslot=unchanged
if /i "%effect%" EQU "No-Spin" set md5=bf894e921f6927728fd63b61abada9b6
if /i "%effect%" EQU "Spin" set md5=f61f7b2e362bf6a07c79fc1afd2117ff
if /i "%effect%" EQU "Fast-Spin" set md5=0790c9de652c768d0c67637fff8aa650
set md5alt=%md5%
set basewad=SystemMenu_4.2K_v486
set basecios=%basewad%
set md5base=40c0bf90ea07b02d610edae1d7aea39f
set md5basealt=%md5base%
set code1=00000001
set code2=00000002
set mym1=DarkWii_Blue_No-Spin_4.XK_V2.mym
set md5mym1=7b227edb0c3bfe21a299c86404d47410
set version=486
set lastbasemodule=00000001
set category=SMTHEME
goto:downloadstart

:SM4.1K-DWB
set name=System Menu 4.1K with Dark Wii Blue Theme - %effect%
set wadname=SystemMenu_4.1K_v454_DarkWiiBlue_%effect%
set ciosslot=unchanged
if /i "%effect%" EQU "No-Spin" set md5=b23d86122bd94cef68e9fcbfccc8a151
if /i "%effect%" EQU "Spin" set md5=ecd3c7e946bb9ed9760e4b3a5dda39c4
if /i "%effect%" EQU "Fast-Spin" set md5=96cc0e7164ae52397716b2d7f756b605
set md5alt=%md5%
set basewad=SystemMenu_4.1K_v454
set basecios=%basewad%
set md5base=c0e5d5c4914e76e7df7495ccf28ef869
set md5basealt=%md5base%
set code1=00000001
set code2=00000002
set mym1=DarkWii_Blue_No-Spin_4.XK_V2.mym
set md5mym1=7b227edb0c3bfe21a299c86404d47410
set version=454
set lastbasemodule=00000001
set category=SMTHEME
goto:downloadstart



::---Dark Wii Orange Themes and SM WADs----

:darkwii_orange_4.1U
set name=DarkWii Orange Theme (4.1U) - %effect%
set wadname=darkwii_orange_%effect%_4.1U
if /i "%effect%" EQU "No-Spin" set md5=0ccdaf1cea50aa0f50bf350482dd9eec
if /i "%effect%" EQU "Spin" set md5=cdf65564258d355bfbb07be2b29aaa74
if /i "%effect%" EQU "Fast-Spin" set md5=9db7762c83a8e3f9f9ce71d016a7d805
set mym1=DarkWii_Orange_No-Spin_4.XU_V2.mym
set md5mym1=6628cd89af0f5f1ba33c7f20c2efede3
::000000**.app
set version=7b
set md5base=6b939de8222800733f4c44ae4eadb325
set category=themes
goto:downloadstart

:darkwii_orange_4.2U
set name=DarkWii Orange Theme (4.2U) - %effect%
set wadname=darkwii_orange_%effect%_4.2U
if /i "%effect%" EQU "No-Spin" set md5=bf5f35013e78ecef5388587beaf702e1
if /i "%effect%" EQU "Spin" set md5=2aac16a0b3d58357a284f9eea57bc390
if /i "%effect%" EQU "Fast-Spin" set md5=fa69addfad761b26bb95a722fcff78da
set mym1=DarkWii_Orange_No-Spin_4.XU_V2.mym
set md5mym1=6628cd89af0f5f1ba33c7f20c2efede3
::000000**.app
set version=87
set md5base=7079948c6aed8aae6009e4fdf27c7171
set category=themes
goto:downloadstart

:darkwii_orange_4.3U
set name=DarkWii Orange Theme (4.3U) - %effect%
set wadname=darkwii_orange_%effect%_4.3U
if /i "%effect%" EQU "No-Spin" set md5=eb4aebbf5f1bebaf7eead2a8688bbfff
if /i "%effect%" EQU "Spin" set md5=69f6ffe5b45f78eafc796467f9fb4fc0
if /i "%effect%" EQU "Fast-Spin" set md5=4f65367ef07a98e646f704d3884ac60a
set mym1=DarkWii_Orange_No-Spin_4.XU_V2.mym
set md5mym1=6628cd89af0f5f1ba33c7f20c2efede3
::000000**.app
set version=97
set md5base=f388c9b11543ac2fe0912ab96064ee37
set category=themes
goto:downloadstart

:darkwii_orange_4.1E
set name=DarkWii Orange Theme (4.1E) - %effect%
set wadname=darkwii_orange_%effect%_4.1E
if /i "%effect%" EQU "No-Spin" set md5=e0d27a68ad4f4f50c55cd0a1c0c6a9c1
if /i "%effect%" EQU "Spin" set md5=b9518220d2fa78cf341463fb45038570
if /i "%effect%" EQU "Fast-Spin" set md5=af7b016edb12b5a3d14fd10cc1cf38b1
set mym1=DarkWii_Orange_No-Spin_4.XE_V2.mym
set md5mym1=25862c24642701a0fd2548d1e7565d5d
::000000**.app
set version=7e
set md5base=574a3a144971ea0ec61bf8cef8d7ff80
set category=themes
goto:downloadstart

:darkwii_orange_4.2E
set name=DarkWii Orange Theme (4.2E) - %effect%
set wadname=darkwii_orange_%effect%_4.2E
if /i "%effect%" EQU "No-Spin" set md5=1b49d810a964d44dacb447561879ab46
if /i "%effect%" EQU "Spin" set md5=58f18efcb6c02f520ee1d080790e9483
if /i "%effect%" EQU "Fast-Spin" set md5=6a105c6474a1515550cdc9070a0f5d82
set mym1=DarkWii_Orange_No-Spin_4.XE_V2.mym
set md5mym1=25862c24642701a0fd2548d1e7565d5d
::000000**.app
set version=8a
set md5base=7e7994f78941afb51e9a20085deac305
set category=themes
goto:downloadstart

:darkwii_orange_4.3E
set name=DarkWii Orange Theme (4.3E) - %effect%
set wadname=darkwii_orange_%effect%_4.3E
if /i "%effect%" EQU "No-Spin" set md5=80ec7694bbcfa772726e9f512d13f96a
if /i "%effect%" EQU "Spin" set md5=91fc4750a43727324752d9718ed65af4
if /i "%effect%" EQU "Fast-Spin" set md5=968052e16890a982c66a697c4d8d249d
set mym1=DarkWii_Orange_No-Spin_4.XE_V2.mym
set md5mym1=25862c24642701a0fd2548d1e7565d5d
::000000**.app
set version=9a
set md5base=41310f79497c56850c37676074ee1237
set category=themes
goto:downloadstart

:darkwii_orange_4.1J
set name=DarkWii Orange Theme (4.1J) - %effect%
set wadname=darkwii_orange_%effect%_4.1J
if /i "%effect%" EQU "No-Spin" set md5=f554f938b98177becece7cf9ea2925d9
if /i "%effect%" EQU "Spin" set md5=a28e22d5379707cf39fee87314513412
if /i "%effect%" EQU "Fast-Spin" set md5=feab5a1079db0468c3e41f2d5fe255ef
set mym1=DarkWii_Orange_No-Spin_4.XJ_V2.mym
set md5mym1=03fa4094deb93a2a4c1de56053cb8534
::000000**.app
set version=78
set md5base=f2eadf12d18e793373060222b870057d
set category=themes
goto:downloadstart

:darkwii_orange_4.2J
set name=DarkWii Orange Theme (4.2J) - %effect%
set wadname=darkwii_orange_%effect%_4.2J
if /i "%effect%" EQU "No-Spin" set md5=e41e21139739257247b500002096e4dc
if /i "%effect%" EQU "Spin" set md5=340e8d94859f04993b4d5786c796c3fc
if /i "%effect%" EQU "Fast-Spin" set md5=f38fb11459a59960dd088c12dd02e9c0
set mym1=DarkWii_Orange_No-Spin_4.XJ_V2.mym
set md5mym1=03fa4094deb93a2a4c1de56053cb8534
::000000**.app
set version=84
set md5base=b08998e582c48afba3a14f6d9e1e9373
set category=themes
goto:downloadstart

:darkwii_orange_4.3J
set name=DarkWii Orange Theme (4.3J) - %effect%
set wadname=darkwii_orange_%effect%_4.3J
if /i "%effect%" EQU "No-Spin" set md5=a4ffb1fc1e8bf3cd2108348aa202eb90
if /i "%effect%" EQU "Spin" set md5=cb71cac76a92e5a542a0ab8273309c6c
if /i "%effect%" EQU "Fast-Spin" set md5=f2b31263d0a1f2d0eba344c2a2046ef6
set mym1=DarkWii_Orange_No-Spin_4.XJ_V2.mym
set md5mym1=03fa4094deb93a2a4c1de56053cb8534
::000000**.app
set version=94
set md5base=5b3ee6942a3cda716badbce3665076fc
set category=themes
goto:downloadstart

:darkwii_orange_4.1K
set name=DarkWii Orange Theme (4.1K) - %effect%
set wadname=darkwii_orange_%effect%_4.1K
if /i "%effect%" EQU "No-Spin" set md5=5ec4c0718a75d8b760d4b38e490347e7
if /i "%effect%" EQU "Spin" set md5=ad2aa0af3cc5233ddbce4ef38b99661d
if /i "%effect%" EQU "Fast-Spin" set md5=c9943588c34d376f471bb91db863a12d
set mym1=DarkWii_Orange_No-Spin_4.XK_V2.mym
set md5mym1=6b9755f746e15d8409de0420850548ac
::000000**.app
set version=81
set md5base=7eedbf1a146b29b63edbb55e04f81f98
set category=themes
goto:downloadstart

:darkwii_orange_4.2K
set name=DarkWii Orange Theme (4.2K) - %effect%
set wadname=darkwii_orange_%effect%_4.2K
if /i "%effect%" EQU "No-Spin" set md5=d21f55b19395f7ca56a274f3e0ccbf6c
if /i "%effect%" EQU "Spin" set md5=a4572ffb93bf32b9dd79564db121a915
if /i "%effect%" EQU "Fast-Spin" set md5=cba612660b83e29c09686d4be556ba61
set mym1=DarkWii_Orange_No-Spin_4.XK_V2.mym
set md5mym1=6b9755f746e15d8409de0420850548ac
::000000**.app
set version=8d
set md5base=9d72a1966370e44cb4c456c17a077bec
set category=themes
goto:downloadstart

:darkwii_orange_4.3K
set name=DarkWii Orange Theme (4.3K) - %effect%
set wadname=darkwii_orange_%effect%_4.3K
if /i "%effect%" EQU "No-Spin" set md5=181ffe119c5404ce68c7716aa7e93d0f
if /i "%effect%" EQU "Spin" set md5=a41efea463543819fb10d4c1b4d825f4
if /i "%effect%" EQU "Fast-Spin" set md5=3543782dc2b194b0562e60b68ad4724e
set mym1=DarkWii_Orange_No-Spin_4.XK_V2.mym
set md5mym1=6b9755f746e15d8409de0420850548ac
::000000**.app
set version=9d
set md5base=e6f2b0d4d5e0c095895f186009bf9516
set category=themes
goto:downloadstart


::----------------------------------


:SM4.3U-DWO
set name=System Menu 4.3U with Dark Wii Orange Theme - %effect%
set wadname=SystemMenu_4.3U_v513_DarkWiiOrange_%effect%
set ciosslot=unchanged
if /i "%effect%" EQU "No-Spin" set md5=1e025945ec12543a05b678369a0b68b2
if /i "%effect%" EQU "Spin" set md5=da9a9dcd047ec704284127b92d9182de
if /i "%effect%" EQU "Fast-Spin" set md5=a059a7b9e7b38e485ef469e4dbc82a07
set md5alt=%md5%
set basewad=SystemMenu_4.3U_v513
set basecios=%basewad%
set md5base=4f5c63e3fd1bf732067fa4c439c68a97
set md5basealt=%md5base%
set code1=00000001
set code2=00000002
set mym1=DarkWii_Orange_No-Spin_4.XU_V2.mym
set md5mym1=6628cd89af0f5f1ba33c7f20c2efede3
set version=513
set lastbasemodule=00000001
set category=SMTHEME
goto:downloadstart

:SM4.2U-DWO
set name=System Menu 4.2U with Dark Wii Orange Theme - %effect%
set wadname=SystemMenu_4.2U_v481_DarkWiiOrange_%effect%
set ciosslot=unchanged
if /i "%effect%" EQU "No-Spin" set md5=66f7e09104cad40de6620d5c73340a85
if /i "%effect%" EQU "Spin" set md5=f421cfc58bbbdd009f46e01f84138e8b
if /i "%effect%" EQU "Fast-Spin" set md5=efca46eedb3faa281f76641ba4ae1fc1
set md5alt=%md5%
set basewad=SystemMenu_4.2U_v481
set basecios=%basewad%
set md5base=4ac52b981845473bd3655e4836d7442b
set md5basealt=%md5base%
set code1=00000001
set code2=00000002
set mym1=DarkWii_Orange_No-Spin_4.XU_V2.mym
set md5mym1=6628cd89af0f5f1ba33c7f20c2efede3
set version=481
set lastbasemodule=00000001
set category=SMTHEME
goto:downloadstart

:SM4.1U-DWO
set name=System Menu 4.1U with Dark Wii Orange Theme - %effect%
set wadname=SystemMenu_4.1U_v449_DarkWiiOrange_%effect%
set ciosslot=unchanged
if /i "%effect%" EQU "No-Spin" set md5=0c8899c5e465c0c43462381193e2e6fb
if /i "%effect%" EQU "Spin" set md5=1054ec9a86daa21ae33e7120ae5c220a
if /i "%effect%" EQU "Fast-Spin" set md5=931c1287d54d0a939f8952636a9ab2fe
set md5alt=%md5%
set basewad=SystemMenu_4.1U_v449
set basecios=%basewad%
set md5base=38a95a9acd257265294be41b796f6239
set md5basealt=%md5base%
set code1=00000001
set code2=00000002
set mym1=DarkWii_Orange_No-Spin_4.XU_V2.mym
set md5mym1=6628cd89af0f5f1ba33c7f20c2efede3
set version=449
set lastbasemodule=00000001
set category=SMTHEME
goto:downloadstart

:SM4.3E-DWO
set name=System Menu 4.3E with Dark Wii Orange Theme - %effect%
set wadname=SystemMenu_4.3E_v514_DarkWiiOrange_%effect%
set ciosslot=unchanged
if /i "%effect%" EQU "No-Spin" set md5=e6dc92bb61f56b5e029c05d8c2249e45
if /i "%effect%" EQU "Spin" set md5=cce715e212729b0e078c74cd14268d71
if /i "%effect%" EQU "Fast-Spin" set md5=ecba9c4e0e3b3df726b6198bce593e04
set md5alt=%md5%
set basewad=SystemMenu_4.3E_v514
set basecios=%basewad%
set md5base=2ec2e6fbdfc52fe5174749e7032f1bad
set md5basealt=%md5base%
set code1=00000001
set code2=00000002
set mym1=DarkWii_Orange_No-Spin_4.XE_V2.mym
set md5mym1=25862c24642701a0fd2548d1e7565d5d
set version=514
set lastbasemodule=00000001
set category=SMTHEME
goto:downloadstart

:SM4.2E-DWO
set name=System Menu 4.2E with Dark Wii Orange Theme - %effect%
set wadname=SystemMenu_4.2E_v482_DarkWiiOrange_%effect%
set ciosslot=unchanged
if /i "%effect%" EQU "No-Spin" set md5=e5236e781556c6e47cb2dfb4b2f2cc2e
if /i "%effect%" EQU "Spin" set md5=f231210dc59398a356c5798979d7b8f5
if /i "%effect%" EQU "Fast-Spin" set md5=4414dba63f5f92b8500f224523d25683
set md5alt=%md5%
set basewad=SystemMenu_4.2E_v482
set basecios=%basewad%
set md5base=7d77be8b6df5ac893d24652db33d02cd
set md5basealt=%md5base%
set code1=00000001
set code2=00000002
set mym1=DarkWii_Orange_No-Spin_4.XE_V2.mym
set md5mym1=25862c24642701a0fd2548d1e7565d5d
set version=482
set lastbasemodule=00000001
set category=SMTHEME
goto:downloadstart

:SM4.1E-DWO
set name=System Menu 4.1E with Dark Wii Orange Theme - %effect%
set wadname=SystemMenu_4.1E_v450_DarkWiiOrange_%effect%
set ciosslot=unchanged
if /i "%effect%" EQU "No-Spin" set md5=976e3e99cdd810fa9686b5b26bf5795b
if /i "%effect%" EQU "Spin" set md5=ee941d140b8f9c6c0709fb4b90dab34a
if /i "%effect%" EQU "Fast-Spin" set md5=2c0cfaaa0cd584aa32e83c555c2a6817
set md5alt=%md5%
set basewad=SystemMenu_4.1E_v450
set basecios=%basewad%
set md5base=688cc78b8eab4e30da04f01a81a3739f
set md5basealt=%md5base%
set code1=00000001
set code2=00000002
set mym1=DarkWii_Orange_No-Spin_4.XE_V2.mym
set md5mym1=25862c24642701a0fd2548d1e7565d5d
set version=450
set lastbasemodule=00000001
set category=SMTHEME
goto:downloadstart

:SM4.3J-DWO
set name=System Menu 4.3J with Dark Wii Orange Theme - %effect%
set wadname=SystemMenu_4.3J_v512_DarkWiiOrange_%effect%
set ciosslot=unchanged
if /i "%effect%" EQU "No-Spin" set md5=b957c8f4fc538ec52e1c855498e29190
if /i "%effect%" EQU "Spin" set md5=031ba3a181bc94a68ef8c540195ab938
if /i "%effect%" EQU "Fast-Spin" set md5=f11b2092a4d9c8efb97e1fa62da5a7c6
set md5alt=%md5%
set basewad=SystemMenu_4.3J_v512
set basecios=%basewad%
set md5base=df67ed4bd8f8f117741fef7952ee5c17
set md5basealt=%md5base%
set code1=00000001
set code2=00000002
set mym1=DarkWii_Orange_No-Spin_4.XJ_V2.mym
set md5mym1=03fa4094deb93a2a4c1de56053cb8534
set version=512
set lastbasemodule=00000001
set category=SMTHEME
goto:downloadstart

:SM4.2J-DWO
set name=System Menu 4.2J with Dark Wii Orange Theme - %effect%
set wadname=SystemMenu_4.2J_v480_DarkWiiOrange_%effect%
set ciosslot=unchanged
if /i "%effect%" EQU "No-Spin" set md5=8b019e7d8ec6881781e315e19ac2176b
if /i "%effect%" EQU "Spin" set md5=f826ca52fc95ba45bad17b283b72fb35
if /i "%effect%" EQU "Fast-Spin" set md5=323a4724fb11a7d901096a7a2c04dda2
set md5alt=%md5%
set basewad=SystemMenu_4.2J_v480
set basecios=%basewad%
set md5base=0413a9aed208b193fea85db908bbdabf
set md5basealt=%md5base%
set code1=00000001
set code2=00000002
set mym1=DarkWii_Orange_No-Spin_4.XJ_V2.mym
set md5mym1=03fa4094deb93a2a4c1de56053cb8534
set version=480
set lastbasemodule=00000001
set category=SMTHEME
goto:downloadstart

:SM4.1J-DWO
set name=System Menu 4.1J with Dark Wii Orange Theme - %effect%
set wadname=SystemMenu_4.1J_v448_DarkWiiOrange_%effect%
set ciosslot=unchanged
if /i "%effect%" EQU "No-Spin" set md5=cfc98bb537216dc10a4bcf935db0bdb4
if /i "%effect%" EQU "Spin" set md5=352416715b440f9db63232c2d5ff06c6
if /i "%effect%" EQU "Fast-Spin" set md5=9e5f348d8b544230af2b6702ae82b6f7
set md5alt=%md5%
set basewad=SystemMenu_4.1J_v448
set basecios=%basewad%
set md5base=6edb4b3f7ca26c643c6bc662d159ec2e
set md5basealt=%md5base%
set code1=00000001
set code2=00000002
set mym1=DarkWii_Orange_No-Spin_4.XJ_V2.mym
set md5mym1=03fa4094deb93a2a4c1de56053cb8534
set version=448
set lastbasemodule=00000001
set category=SMTHEME
goto:downloadstart


:SM4.3K-DWO
set name=System Menu 4.3K with Dark Wii Orange Theme - %effect%
set wadname=SystemMenu_4.3K_v518_DarkWiiOrange_%effect%
set ciosslot=unchanged
if /i "%effect%" EQU "No-Spin" set md5=15166e367f7cb0243e3b6d4f3b11de4a
if /i "%effect%" EQU "Spin" set md5=8daf45b6adba015c05c3ed0d86eda5b9
if /i "%effect%" EQU "Fast-Spin" set md5=97e2c5e1d3c1093cdcde515b090035c7
set md5alt=%md5%
set basewad=SystemMenu_4.3K_v518
set basecios=%basewad%
set md5base=6ed8f9e75b0a54eacfbacce57c20136d
set md5basealt=%md5base%
set code1=00000001
set code2=00000002
set mym1=DarkWii_Orange_No-Spin_4.XK_V2.mym
set md5mym1=6b9755f746e15d8409de0420850548ac
set version=518
set lastbasemodule=00000001
set category=SMTHEME
goto:downloadstart

:SM4.2K-DWO
set name=System Menu 4.2K with Dark Wii Orange Theme - %effect%
set wadname=SystemMenu_4.2K_v486_DarkWiiOrange_%effect%
set ciosslot=unchanged
if /i "%effect%" EQU "No-Spin" set md5=576b9a4ad91cddf1e9370d63bb5d2308
if /i "%effect%" EQU "Spin" set md5=77e3529122009251c94a6c6655dd6578
if /i "%effect%" EQU "Fast-Spin" set md5=15716f40f99a496cae423a7af9149a88
set md5alt=%md5%
set basewad=SystemMenu_4.2K_v486
set basecios=%basewad%
set md5base=40c0bf90ea07b02d610edae1d7aea39f
set md5basealt=%md5base%
set code1=00000001
set code2=00000002
set mym1=DarkWii_Orange_No-Spin_4.XK_V2.mym
set md5mym1=6b9755f746e15d8409de0420850548ac
set version=486
set lastbasemodule=00000001
set category=SMTHEME
goto:downloadstart

:SM4.1K-DWO
set name=System Menu 4.1K with Dark Wii Orange Theme - %effect%
set wadname=SystemMenu_4.1K_v454_DarkWiiOrange_%effect%
set ciosslot=unchanged
if /i "%effect%" EQU "No-Spin" set md5=3913e2e1098279b1c303ad73511d399c
if /i "%effect%" EQU "Spin" set md5=20a5443b9f008336e555386817aa3e81
if /i "%effect%" EQU "Fast-Spin" set md5=ad3169d590ff5b908b32140193ea4ea1
set md5alt=%md5%
set basewad=SystemMenu_4.1K_v454
set basecios=%basewad%
set md5base=c0e5d5c4914e76e7df7495ccf28ef869
set md5basealt=%md5base%
set code1=00000001
set code2=00000002
set mym1=DarkWii_Orange_No-Spin_4.XK_V2.mym
set md5mym1=6b9755f746e15d8409de0420850548ac
set version=454
set lastbasemodule=00000001
set category=SMTHEME
goto:downloadstart


::--------------------------------------Custom Guide (for DL Wizard only)-------------------------------------

:spoileropeningtag
support\sfk echo -spat \x3cdiv style=\x22margin: 5px 10px 10px;\x22\x3e>>"%Drive%"\%guidename%
support\sfk echo -spat \x3cdiv class=\x22smallfont\x22 style=\x22margin-bottom: 2px;\x22\x3e\x3cinput value=\x22%spoilername%\x22 style=\x22margin: 0px; padding: 0px; width: >>"%Drive%"\%guidename% 
support\sfk echo -spat 200px; font-size: 11px;\x22 onclick=\x22if (this.parentNode.parentNode.getElementsByTagName('div')[1].getElementsByTagName('div')[0].style.display != >>"%Drive%"\%guidename% 
support\sfk echo -spat '') { this.parentNode.parentNode.getElementsByTagName('div')[1].getElementsByTagName('div')[0].style.display = ''; this.innerText = ''; >>"%Drive%"\%guidename% 
support\sfk echo -spat this.value = '%spoilername%'; } else { this.parentNode.parentNode.getElementsByTagName('div')[1].getElementsByTagName('div')[0].style.display = >>"%Drive%"\%guidename% 
support\sfk echo -spat 'none'; this.innerText = ''; this.value = '%spoilername%'; }\x22 type=\x22button\x22\x3e>>"%Drive%"\%guidename%
support\sfk echo -spat \x3c/div\x3e>>"%Drive%"\%guidename%
support\sfk echo -spat \x3cdiv class=\x22alt2\x22 style=\x22border: 0px inset ; margin: 0px; padding: 2px;\x22\x3e>>"%Drive%"\%guidename%
support\sfk echo -spat \x3cdiv style=\x22display: none;\x22\x3e>>"%Drive%"\%guidename%
goto:%spoilerback%




::---------------------------EXPLOITS GUIDES------------------------------
:EXPLOITS

::title for multiple exploits
if /i "%EXPLOIT%" EQU "?" support\sfk echo -spat \x3cfont size="4"\x3e\x3cb\x3eLaunch an Exploit\x3c/b\x3e\x3c/font\x3e\x3cbr\x3e>>"%Drive%"\%guidename%
if /i "%EXPLOIT%" EQU "?" support\sfk echo -spat You only need to perform ONE of the following exploits\x3cbr\x3e>>"%Drive%"\%guidename%


::BB1
If /i "%BB1%" NEQ "*" goto:noBB1
if /i "%EXPLOIT%" NEQ "?" goto:afterBB1spoiler
set spoilername=BannerBomb v1 Exploit Instructions
set spoilerback=afterBB1spoiler
goto:spoileropeningtag
:afterBB1spoiler
copy /y "%Drive%"\%guidename%+Support\Guide\BBv1.001 "%Drive%"\%guidename%>nul
::spoilerclosingtag
if /i "%EXPLOIT%" EQU "?" support\sfk echo -spat \x3c/div\x3e\x3c/div\x3e\x3c/div\x3e>>"%Drive%"\%guidename%
:noBB1




::BB2
If /i "%BB2%" NEQ "*" goto:noBB2
if /i "%EXPLOIT%" NEQ "?" goto:afterBB2spoiler
set spoilername=BannerBomb v2 Exploit Instructions
set spoilerback=afterBB2spoiler
goto:spoileropeningtag
:afterBB2spoiler
copy /y "%Drive%"\%guidename%+Support\Guide\BBv2.001 "%Drive%"\%guidename%>nul
::spoilerclosingtag
if /i "%EXPLOIT%" EQU "?" support\sfk echo -spat \x3c/div\x3e\x3c/div\x3e\x3c/div\x3e>>"%Drive%"\%guidename%
:noBB2



::SMASH
If /i "%SMASH%" NEQ "*" goto:noSMASH
if /i "%EXPLOIT%" NEQ "?" goto:afterSMASHspoiler
set spoilername=Smash Stack Exploit Instructions
set spoilerback=afterSMASHspoiler
goto:spoileropeningtag
:afterSMASHspoiler
copy /y "%Drive%"\%guidename%+Support\Guide\SmashStack.001 "%Drive%"\%guidename%>nul
::spoilerclosingtag
if /i "%EXPLOIT%" EQU "?" support\sfk echo -spat \x3c/div\x3e\x3c/div\x3e\x3c/div\x3e>>"%Drive%"\%guidename%
:noSMASH




::PWNS
If /i "%PWNS%" NEQ "*" goto:noPWNS
if /i "%EXPLOIT%" NEQ "?" goto:afterPWNSspoiler
set spoilername=Indiana Pwns Exploit Instructions
set spoilerback=afterPWNSspoiler
goto:spoileropeningtag
:afterPWNSspoiler
copy /y "%Drive%"\%guidename%+Support\Guide\PWNS.001 "%Drive%"\%guidename%>nul
::spoilerclosingtag
if /i "%EXPLOIT%" EQU "?" support\sfk echo -spat \x3c/div\x3e\x3c/div\x3e\x3c/div\x3e>>"%Drive%"\%guidename%
:noPWNS



::YUGI
If /i "%YUGI%" NEQ "*" goto:noYUGI
if /i "%EXPLOIT%" NEQ "?" goto:afterYUGIspoiler
set spoilername=Yu-Gi Owned Exploit Instructions
set spoilerback=afterYUGIspoiler
goto:spoileropeningtag
:afterYUGIspoiler
copy /y "%Drive%"\%guidename%+Support\Guide\YUGI.001 "%Drive%"\%guidename%>nul
::spoilerclosingtag
if /i "%EXPLOIT%" EQU "?" support\sfk echo -spat \x3c/div\x3e\x3c/div\x3e\x3c/div\x3e>>"%Drive%"\%guidename%
:noYUGI



::Bathaxx
If /i "%Bathaxx%" NEQ "*" goto:noBathaxx
if /i "%EXPLOIT%" NEQ "?" goto:afterBathaxxspoiler
set spoilername=Bathaxx Exploit Instructions
set spoilerback=afterBathaxxspoiler
goto:spoileropeningtag
:afterBathaxxspoiler
copy /y "%Drive%"\%guidename%+Support\Guide\Bathaxx.001 "%Drive%"\%guidename%>nul
::spoilerclosingtag
if /i "%EXPLOIT%" EQU "?" support\sfk echo -spat \x3c/div\x3e\x3c/div\x3e\x3c/div\x3e>>"%Drive%"\%guidename%
:noBathaxx



::ROTJ
If /i "%ROTJ%" NEQ "*" goto:noROTJ
if /i "%EXPLOIT%" NEQ "?" goto:afterROTJspoiler
set spoilername=Return of the Jodi Exploit Instructions
set spoilerback=afterROTJspoiler
goto:spoileropeningtag
:afterROTJspoiler
copy /y "%Drive%"\%guidename%+Support\Guide\ROTJ.001 "%Drive%"\%guidename%>nul
::spoilerclosingtag
if /i "%EXPLOIT%" EQU "?" support\sfk echo -spat \x3c/div\x3e\x3c/div\x3e\x3c/div\x3e>>"%Drive%"\%guidename%
:noROTJ




::TOS
If /i "%TOS%" NEQ "*" goto:noTOS
if /i "%EXPLOIT%" NEQ "?" goto:afterTOSspoiler
set spoilername=Eri HaKawai Exploit Instructions
set spoilerback=afterTOSspoiler
goto:spoileropeningtag
:afterTOSspoiler
copy /y "%Drive%"\%guidename%+Support\Guide\EriHaKawai.001 "%Drive%"\%guidename%>nul
::spoilerclosingtag
if /i "%EXPLOIT%" EQU "?" support\sfk echo -spat \x3c/div\x3e\x3c/div\x3e\x3c/div\x3e>>"%Drive%"\%guidename%
:noTOS




::TWI
If /i "%TWI%" NEQ "*" goto:noTWI
if /i "%EXPLOIT%" NEQ "?" goto:afterTWIspoiler
set spoilername=Twilight Hack Exploit Instructions
set spoilerback=afterTWIspoiler
goto:spoileropeningtag
:afterTWIspoiler
copy /y "%Drive%"\%guidename%+Support\Guide\Twilight.001 "%Drive%"\%guidename%>nul
::spoilerclosingtag
if /i "%EXPLOIT%" EQU "?" support\sfk echo -spat \x3c/div\x3e\x3c/div\x3e\x3c/div\x3e>>"%Drive%"\%guidename%
:noTWI



::Wilbrand
if /i "%Exploit%" NEQ "W" goto:noWilbrand
if /i "%EXPLOIT%" NEQ "?" goto:afterWilbrandspoiler
set spoilername=Wilbrand Exploit Instructions
set spoilerback=afterWilbrandspoiler
goto:spoileropeningtag
:afterWilbrandspoiler
copy /y "%Drive%"\%guidename%+Support\Guide\Wilbrand.001 "%Drive%"\%guidename%>nul
::spoilerclosingtag
if /i "%EXPLOIT%" EQU "?" support\sfk echo -spat \x3c/div\x3e\x3c/div\x3e\x3c/div\x3e>>"%Drive%"\%guidename%
:noWilbrand



::If /i "%MENU1%" EQU "H" goto:HMsolution2

goto:%afterexploit%




:guide
set installwads=

:guidestart
set guidename=ModMii_Wizard_Guide.html
set tabname=ModMii Wizard Guide

if /i "%MENU1%" EQU "H" (set guidename=ModMii_HackMii_Solutions_Guide.html) & (set tabname=ModMii HackMii Solutions Guide)
if /i "%MENU1%" EQU "U" (set guidename=ModMii_USBLoader_Setup_Guide.html) & (set tabname=ModMii USB-Loader Setup Guide)
if /i "%MENU1%" EQU "SU" (set guidename=ModMii_sysCheck_Updater_Guide.html) & (set tabname=ModMii sysCheck Updater Guide)
if /i "%MENU1%" EQU "RC" (set guidename=ModMii_Region_Change_Guide.html) & (set tabname=ModMii Region Change Guide)
if /i "%AbstinenceWiz%" EQU "Y" (set guidename=ModMii_Abstinence_Guide.html) & (set tabname=ModMii Abstinence Guide)

SET COUNT7=1
cls
if /i "%SETTINGS%" EQU "G" echo Generating Guide, please wait.
if /i "%SETTINGS%" NEQ "G" echo Generating Guide, please wait, your downloads will begin shortly.


::---------------SKIN MODE-------------
if /i "%SkinMode%" EQU "Y" start support\wizapp PB UPDATE 50



if not exist "%DRIVE%" mkdir "%DRIVE%" >nul
if not exist "%Drive%"\%guidename% goto:norename
SET /a COUNT6=%COUNT6%+1
if exist "%DRIVE%"\%guidename:~0,-5%%COUNT6%.html goto:guide
move /y "%Drive%"\%guidename% "%DRIVE%"\%guidename:~0,-5%%COUNT6%.html >nul
:norename


::HTML HEADER


support\sfk echo -spat \x3chtml\x3e >"%Drive%"\%guidename%
support\sfk echo -spat \x3chead\x3e >>"%Drive%"\%guidename%
support\sfk echo -spat \x3ctitle\x3e%tabname%\x3c/title\x3e >>"%Drive%"\%guidename%
support\sfk echo -spat \x3clink rel=\x22icon\x22 type=\x22image/ico\x22 href=\x22https://googledrive.com/host/0BzWzf-jnAnp1YkFURFF0cDdsRUE/ModMii/icon.ico\x22\x3e\x3c/link\x3e>>"%Drive%"\%guidename%

support\sfk echo -spat \x3cstyle type=\x22text/css\x22\x3e>>"%Drive%"\%guidename%
support\sfk echo -spat body { font-family: Calibri, Arial, Helvetica, \x22Century Gothic\x22, sans-serif; }>>"%Drive%"\%guidename%
support\sfk echo -spat \x3c/style\x3e>>"%Drive%"\%guidename%

support\sfk echo -spat \x3c/head\x3e >>"%Drive%"\%guidename%
support\sfk echo -spat \x3cbody style=\x22margin:5px 5px 5px 35px;\x22\x3e >>"%Drive%"\%guidename%
support\sfk echo -spat Guide Generated by ModMii v%currentversion% on %DATE% - %TIME:~0,-6% \x3cbr\x3e\x3cbr\x3e >>"%Drive%"\%guidename%



copy /y "%Drive%"\%guidename%+Support\Guide\sprint-paramstart.001 "%Drive%"\%guidename%>nul


if /i "%MENU1%" NEQ "RC" goto:notRC
support\sfk echo -spat \x3cli\x3eDesired System Menu is %FIRM%%REGION%\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%ThemeSelection%" EQU "R" support\sfk echo -spat \x3cli\x3eInstall Dark Wii Red Theme\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%ThemeSelection%" EQU "G" support\sfk echo -spat \x3cli\x3eInstall Dark Wii Green Theme\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%ThemeSelection%" EQU "BL" support\sfk echo -spat \x3cli\x3eInstall Dark Wii Blue Theme\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%ThemeSelection%" EQU "O" support\sfk echo -spat \x3cli\x3eInstall Dark Wii Orange Theme\x3c/li\x3e>>"%Drive%"\%guidename%
goto:skipusb
:notRC


::------Abstinence parameters---------------
if /i "%AbstinenceWiz%" NEQ "Y" goto:notAbstinenceWiz
if /i "%FIRMSTART%" NEQ "o" support\sfk echo -spat \x3cli\x3eCurrent System Menu is %FIRMSTART%%REGION%\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%FIRMSTART%" EQU "o" support\sfk echo -spat \x3cli\x3eCurrent System Menu is less than 2.2%REGION%\x3c/li\x3e>>"%Drive%"\%guidename%

support\sfk echo -spat \x3cli\x3eBuild %SNKVERSION%%SNKREGION% Emulated NAND\x3c/li\x3e>>"%Drive%"\%guidename%

if /i "%SNEEKTYPE%" EQU "SD" support\sfk echo -spat \x3cli\x3eBuild SNEEK+DI Rev%CurrentRev%\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%SNEEKTYPE%" EQU "UD" support\sfk echo -spat \x3cli\x3eBuild UNEEK+DI Rev%CurrentRev%\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%SNEEKTYPE%" EQU "U" support\sfk echo -spat \x3cli\x3eBuild UNEEK Rev%CurrentRev%\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%SNEEKTYPE%" EQU "S" support\sfk echo -spat \x3cli\x3eBuild SNEEK Rev%CurrentRev%\x3c/li\x3e>>"%Drive%"\%guidename%

if /i "%neek2o%" EQU "on" support\sfk echo -spat \x3cli\x3eneek2o Enabled (can be changed in options)\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%neek2o%" NEQ "on" support\sfk echo -spat \x3cli\x3eneek2o Disabled (can be changed in options)\x3c/li\x3e>>"%Drive%"\%guidename%


if /i "%SNEEKTYPE:~0,1%" NEQ "U" goto:miniskip
if /i "%FORMAT%" EQU "1" support\sfk echo -spat \x3cli\x3eExternal Hard Drive to be Formatted as FAT32\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%FORMAT%" EQU "3" support\sfk echo -spat \x3cli\x3eExternal Hard Drive to be Formatted as Part FAT32 and Part NTFS\x3c/li\x3e>>"%Drive%"\%guidename%
:miniskip


if /i "%SNEEKTYPE:~0,1%" EQU "U" goto:miniskip
if /i "%SSD%" EQU "on" support\sfk echo -spat \x3cli\x3eSNEEK and SNEEK+DI SD Access Enabled (can be changed in options)\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%SSD%" NEQ "on" support\sfk echo -spat \x3cli\x3eSNEEK and SNEEK+DI SD Access Disabled (can be changed in options)\x3c/li\x3e>>"%Drive%"\%guidename%
:miniskip

if /i "%SNKSERIAL%" NEQ "current" support\sfk echo -spat \x3cli\x3esetting.txt will be created using this serial number: %SNKSERIAL%\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%SNKSERIAL%" EQU "current" support\sfk echo -spat \x3cli\x3eExisting setting.txt will be kept\x3c/li\x3e>>"%Drive%"\%guidename%

if /i "%SNKPRI%" EQU "Y" support\sfk echo -spat \x3cli\x3eInstall Priiloader to Emulated NAND\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%SNKCIOS%" EQU "Y" support\sfk echo -spat \x3cli\x3eInstall cIOS249 rev14 to Emulated NAND\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%SNKPLC%" EQU "Y" support\sfk echo -spat \x3cli\x3eInstall Post Loader Channel to Emulated NAND\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%SNKFLOW%" EQU "Y" support\sfk echo -spat \x3cli\x3eInstall WiiFlow Channel to Emulated NAND\x3c/li\x3e>>"%Drive%"\%guidename%

if /i "%ThemeSelection%" EQU "R" support\sfk echo -spat \x3cli\x3eInstall Dark Wii Red Theme to Emulated NAND\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%ThemeSelection%" EQU "G" support\sfk echo -spat \x3cli\x3eInstall Dark Wii Green Theme to Emulated NAND\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%ThemeSelection%" EQU "BL" support\sfk echo -spat \x3cli\x3eInstall Dark Wii Blue Theme to Emulated NAND\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%ThemeSelection%" EQU "O" support\sfk echo -spat \x3cli\x3eInstall Dark Wii Orange Theme to Emulated NAND\x3c/li\x3e>>"%Drive%"\%guidename%

if /i "%PIC%" EQU "Y" support\sfk echo -spat \x3cli\x3eInstall Photo Channel to Emulated NAND\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%NET%" EQU "Y" support\sfk echo -spat \x3cli\x3eInstall Internet Channel to Emulated NAND\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%WEATHER%" EQU "Y" support\sfk echo -spat \x3cli\x3eInstall Weather Channel to Emulated NAND\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%NEWS%" EQU "Y" support\sfk echo -spat \x3cli\x3eInstall News Channel to Emulated NAND\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%MIIQ%" EQU "Y" support\sfk echo -spat \x3cli\x3eInstall Mii Channel to Emulated NAND\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%Shop%" EQU "Y" support\sfk echo -spat \x3cli\x3eInstall Shopping Channel to Emulated NAND\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%Speak%" EQU "Y" support\sfk echo -spat \x3cli\x3eInstall Wii Speak Channel to Emulated NAND\x3c/li\x3e>>"%Drive%"\%guidename%

if not "%addwadfolder%"=="" support\sfk echo -spat \x3cli\x3eInstall wads to Emulated NAND from custom folder: %addwadfolder%\x3c/li\x3e>>"%Drive%"\%guidename%

goto:skipusb

:notAbstinenceWiz



if /i "%MENU1%" EQU "U" (set USBGUIDE=Y) & (goto:usbparam)

if /i "%VIRGIN%" EQU "Y" support\sfk echo -spat \x3cli\x3eInstall and\or update all recommended softmods\x3c/li\x3e>>"%Drive%"\%guidename%


if /i "%MENU1%" EQU "SU" goto:miniskip
if /i "%FIRMSTART%" NEQ "o" support\sfk echo -spat \x3cli\x3eCurrent System Menu is %FIRMSTART%%REGION%\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%FIRMSTART%" EQU "o" support\sfk echo -spat \x3cli\x3eCurrent System Menu is less than 2.2%REGION%\x3c/li\x3e>>"%Drive%"\%guidename%


if /i "%MENU1%" EQU "H" goto:skipusb


support\sfk echo -spat \x3cli\x3eDesired System Menu is %FIRM%%REGION%\x3c/li\x3e>>"%Drive%"\%guidename%




if /i "%PIC%" EQU "Y" support\sfk echo -spat \x3cli\x3eInstall Photo Channel\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%NET%" EQU "Y" support\sfk echo -spat \x3cli\x3eInstall Internet Channel\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%WEATHER%" EQU "Y" support\sfk echo -spat \x3cli\x3eInstall Weather Channel\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%NEWS%" EQU "Y" support\sfk echo -spat \x3cli\x3eInstall News Channel\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%MIIQ%" EQU "Y" support\sfk echo -spat \x3cli\x3eInstall Mii Channel\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%Shop%" EQU "Y" support\sfk echo -spat \x3cli\x3eInstall Shopping Channel (and IOS56)\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%Speak%" EQU "Y" support\sfk echo -spat \x3cli\x3eInstall Wii Speak Channel\x3c/li\x3e>>"%Drive%"\%guidename%

:miniskip

if /i "%VIRGIN%" EQU "Y" goto:skipvirginstandard
if /i "%HM%" EQU "*" support\sfk echo -spat \x3cli\x3eInstall and\or update the Homebrew Channel and BootMii\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%RECCIOS%" NEQ "Y" goto:smallskip
if /i "%CMIOSOPTION%" EQU "on" (support\sfk echo -spat \x3cli\x3eInstall recommended cIOSs and cMIOS\x3c/li\x3e>>"%Drive%"\%guidename%) else (support\sfk echo -spat \x3cli\x3eInstall recommended cIOSs\x3c/li\x3e>>"%Drive%"\%guidename%)
:smallskip
if /i "%yawm%" EQU "*" support\sfk echo -spat \x3cli\x3eDownload Yet Another Wad Manager Mod (YAWMM)\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%IOS236Installer%" EQU "*" support\sfk echo -spat \x3cli\x3eInstall IOS236 \x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%pri%" EQU "*" support\sfk echo -spat \x3cli\x3eInstall and\or update Priiloader\x3c/li\x3e>>"%Drive%"\%guidename%
:skipvirginstandard

if /i "%ThemeSelection%" EQU "R" support\sfk echo -spat \x3cli\x3eInstall Dark Wii Red Theme\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%ThemeSelection%" EQU "G" support\sfk echo -spat \x3cli\x3eInstall Dark Wii Green Theme\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%ThemeSelection%" EQU "BL" support\sfk echo -spat \x3cli\x3eInstall Dark Wii Blue Theme\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%ThemeSelection%" EQU "O" support\sfk echo -spat \x3cli\x3eInstall Dark Wii Orange Theme\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%ACTIVEIOS%" NEQ "ON" goto:skipupdatelog
if /i "%UpdatesIOSQ%" EQU "N" goto:skipupdatelog
support\sfk echo -spat \x3cli\x3eUpdate active IOSs (can be disabled in options)\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%OPTION36%" EQU "off" support\sfk echo -spat \x3cli\x3eDo not update IOS36 (can be enabled in options)\x3c/li\x3e>>"%Drive%"\%guidename%
goto:skip
:skipupdatelog
support\sfk echo -spat \x3cli\x3eDo not update active IOSs (can be enabled in options)\x3c/li\x3e>>"%Drive%"\%guidename%
:skip

if /i "%RECCIOS%" EQU "Y" goto:semiskip
if /i "%VIRGIN%" EQU "N" goto:tinyskip
if /i "%CMIOSOPTION%" EQU "on" support\sfk echo -spat \x3cli\x3eInstall a cMIOS (can be disabled in options)\x3c/li\x3e>>"%Drive%"\%guidename%
:semiskip
if /i "%CMIOSOPTION%" EQU "off" support\sfk echo -spat \x3cli\x3eDo not Install a cMIOS (can be enabled in options)\x3c/li\x3e>>"%Drive%"\%guidename%
:tinyskip

if /i "%FWDOPTION%" EQU "off" support\sfk echo -spat \x3cli\x3eDo not install a USB-Loader Forwarder Channel (can be enabled in options)\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%FWDOPTION%" EQU "on" support\sfk echo -spat \x3cli\x3eInstall a USB-Loader Forwarder Channel (can be disabled in options)\x3c/li\x3e>>"%Drive%"\%guidename%



::---------
if /i "%USBGUIDE%" NEQ "Y" goto:skipusb
:usbparam

if /i "%FORMAT%" EQU "1" set FORMATNAME=FAT32
if /i "%FORMAT%" EQU "2" set FORMATNAME=NTFS
if /i "%FORMAT%" EQU "3" set FORMATNAME=Part FAT32 and Part NTFS
if /i "%FORMAT%" EQU "4" set FORMATNAME=WBFS
if /i "%FORMAT%" EQU "5" set FORMATNAME=Part FAT32 and Part WBFS

if /i "%FORMAT%" EQU "4" goto:skip
if /i "%FORMAT%" EQU "5" goto:skip
support\sfk echo -spat \x3cli\x3eExternal Hard Drive to be Formatted as %FORMATNAME%\x3c/li\x3e>>"%Drive%"\%guidename%
goto:skip2
:skip
support\sfk echo -spat \x3cli\x3eExternal Hard Drive already Formatted as %FORMATNAME%\x3c/li\x3e>>"%Drive%"\%guidename%
:skip2

if /i "%LOADER%" EQU "CFG" support\sfk echo -spat \x3cli\x3eDownload Configurable USB-Loader\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%LOADER%" EQU "FLOW" support\sfk echo -spat \x3cli\x3eDownload WiiFlow\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%LOADER%" EQU "ALL" support\sfk echo -spat \x3cli\x3eDownload Configurable USB-Loader and WiiFlow\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%USBCONFIG%" EQU "USB" support\sfk echo -spat \x3cli\x3eUSB-Loader Settings and config files saved to USB Hard Drive\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%USBCONFIG%" NEQ "USB" support\sfk echo -spat \x3cli\x3eUSB-Loader Settings and config files saved to SD Card\x3c/li\x3e>>"%Drive%"\%guidename%
:skipusb


::closing tag and linebreak: </ul><br>
support\sfk echo -spat \x3c/ul\x3e\x3cbr\x3e>>"%Drive%"\%guidename%


:Important notes title and bullet opening tag
support\sfk echo -spat \x3cfont size=\x226\x22\x3e\x3cli\x3e\x3ca name=\x22Notes\x22\x3eImportant Notes\x3c/a\x3e\x3c/li\x3e\x3c/font\x3e\x3cbr\x3e\x3cul\x3e>>"%Drive%"\%guidename%

if /i "%AbstinenceWiz%" EQU "Y" copy /y "%Drive%"\%guidename%+Support\Guide\AbstinenceNotes.001 "%Drive%"\%guidename%>nul
if /i "%AbstinenceWiz%" EQU "Y" goto:skipthis

if /i "%MENU1%" EQU "RC" copy /y "%Drive%"\%guidename%+Support\Guide\RegionChangenotes.001 "%Drive%"\%guidename%>nul

if /i "%MENU1%" NEQ "U" copy /y "%Drive%"\%guidename%+Support\Guide\softmodnotes.001 "%Drive%"\%guidename%>nul



::----USB-Loader Notes----
if /i "%USBGUIDE%" NEQ "Y" goto:skipall
if /i "%cIOS223[37-38]-v4%" EQU "*" goto:skipthis


support\sfk echo -spat \x3cli\x3ecIOS(s) required to use USB-Loaders, if you are missing cIOS(s) run the ModMii Wizard function to softmod your Wii before setting up your USB-Loader and/or external Hard-Drive.\x3c/li\x3e>>"%Drive%"\%guidename%

support\sfk echo -spat \x3cli\x3ecIOS249 rev18 or higher required to use Hard Drives Formatted as FAT32 or NTFS (cIOS222\223\224 rev4 or higher also works).\x3c/li\x3e>>"%Drive%"\%guidename%

:skipthis

support\sfk echo -spat \x3cli\x3eNot all external hard drive's are compatible with the Wii, for a list of which USB hard drive's are compatible, see this webpage: \x3ca href="http://wiki.gbatemp.net/wiki/USB_Devices_Compatibility_List" target="_blank"\x3ehttp://wiki.gbatemp.net/wiki/USB_Devices_Compatibility_List\x3c/a\x3e\x3c/li\x3e>>"%Drive%"\%guidename%

:skipall
::-------------------------

::common important note, end bullet tag and line break
support\sfk echo -spat \x3cli\x3eIf you have questions, a more detailed guide can be found at \x3ca href=\x22http://www.sites.google.com/site/completesg/\x22 taget=\x22_blank\x22\x3ewww.sites.google.com/site/completesg/\x3c/a\x3e\x3c/li\x3e\x3c/ul\x3e\x3cbr\x3e>>"%Drive%"\%guidename%





::Start of AbstinenceWizGUIDE steps listings. This must be here for the guide
if /i "%AbstinenceWiz%" NEQ "Y" goto:NotAbstinenceWiz

support\sfk echo -spat \x3cfont size=\x226\x22\x3e\x3cli\x3e\x3ca name=\x22Hacking\x22\x3eLaunch %neekname% Without Hacking Your Wii\x3c/a\x3e\x3c/li\x3e\x3c/font\x3e\x3cbr\x3e\x3col\x3e>>"%Drive%"\%guidename%

goto:CasperPickUp
:NotAbstinenceWiz


if /i "%MENU1%" EQU "U" goto:USBGUIDESTEP1


::Start of hacking steps listings. This must be here for the hacking guide
copy /y "%Drive%"\%guidename%+Support\Guide\softmodheader.001 "%Drive%"\%guidename%>nul


if /i "%MENU1%" EQU "RC" copy /y "%Drive%"\%guidename%+Support\Guide\NANDBACKUP.001 "%Drive%"\%guidename%>nul
if /i "%MENU1%" EQU "RC" goto:installwads



::-----------------------------------------virgin Korean non-4.3 Wiis-----------------------------------
If /i "%MENU1%" NEQ "H" goto:nothackmiisolutions

::launch MMM using an exploit

copy /y "%Drive%"\%guidename%+Support\Guide\HMSolutions.001 "%Drive%"\%guidename%>nul

::---------CREATE MMMCONFIG To Autoload 36--------
set patchIOSnum=36
if /i "%SETTINGS%" EQU "G" goto:skipmmmfly
if /i "%SETTINGSHM%" EQU "G" goto:skipmmmfly
echo ;MMMCONFIG (By ModMii)> "%Drive%"\mmmconfig.txt
echo AutoLoadIOS=%patchIOSnum%>> "%Drive%"\mmmconfig.txt
:skipmmmfly

set afterexploit=continueHMsolutions
goto:exploits
:continueHMsolutions

support\sfk echo -spat This will launch Multi-Mod Manager.\x3cbr\x3e\x3cbr\x3e>>"%Drive%"\%guidename%


copy /y "%Drive%"\%guidename%+Support\Guide\WADHMheader.001 "%Drive%"\%guidename%>nul

goto:wadlist

:HMafterwadlist

copy /y "%Drive%"\%guidename%+Support\Guide\HMSolutions2.001 "%Drive%"\%guidename%>nul

::--------End of hacking steps listings (and line break). This must be here for the hacking guide------------
support\sfk echo -spat \x3c/ol\x3e\x3cbr\x3e>>"%Drive%"\%guidename%

GOTO:supportxflak

:nothackmiisolutions



::-----------------------------------------virgin Korean non-4.3 Wiis-----------------------------------
If /i "%VIRGIN%" NEQ "Y" goto:nonkorean
If /i "%REGION%" NEQ "K" goto:nonkorean
If /i "%FIRMSTART%" EQU "4.3" goto:nonkorean

::launch MMM using an exploit
support\sfk echo -spat \x3cfont size="5"\x3e\x3cli\x3eLaunch Multi-Mod Manager\x3c/li\x3e\x3c/font\x3e\x3cbr\x3e>>"%Drive%"\%guidename%

set afterexploit=continueKorean
goto:exploits
:continueKorean

copy /y "%Drive%"\%guidename%+Support\Guide\KoreanStart.001 "%Drive%"\%guidename%>nul

goto:nandbackup



::---------------------------virgin NON-Korean Wiis-----------------------------------

::---------------------------------HACKMII INSTALLER-----------------------------

:nonkorean

If /i "%HM%" NEQ "*" goto:TBRGUIDE

If /i "%MENU1%" NEQ "SU" goto:miniskip
If /i "%IOS236Installer%" NEQ "*" goto:TBRGUIDE
:miniskip

copy /y "%Drive%"\%guidename%+Support\Guide\HBC.001 "%Drive%"\%guidename%>nul

set afterexploit=continueHBC
goto:exploits
:continueHBC


copy /y "%Drive%"\%guidename%+Support\Guide\HBC2.001 "%Drive%"\%guidename%>nul



:nandbackup
copy /y "%Drive%"\%guidename%+Support\Guide\NANDBACKUP.001 "%Drive%"\%guidename%>nul


::----------------------------RESTORING THE TRUCHA BUG (using IOS236 Installer)--------------------------
:TBRGUIDE

If /i "%IOS236Installer%" NEQ "*" goto:PRIIGUIDE


copy /y "%Drive%"\%guidename%+Support\Guide\IOS236.001 "%Drive%"\%guidename%>nul


::--------------------------INSTALL PRIILOADER-------------------------------
:PRIIGUIDE

if /i "%installwads%" EQU "done" goto:skip
if /i "%FIRM%" NEQ "%FIRMSTART%" goto:installwads
if /i "%PRI%" NEQ "*" goto:installwads
:skip
if /i "%PRI%" NEQ "*" goto:reinstallHBC

copy /y "%Drive%"\%guidename%+Support\Guide\Priiloader.001 "%Drive%"\%guidename%>nul

if /i "%MENU1%" EQU "RC" goto:ARCGUIDE

if /i "%installwads%" EQU "done" goto:reinstallHBC

goto:installwads


::----------------------ANY REGION CHANGER (ARC)-----------------------------
:ARCGUIDE

copy /y "%Drive%"\%guidename%+Support\Guide\ARC.001 "%Drive%"\%guidename%>nul

if /i "%REGION%" EQU "U" echo change the region to USA.>>"%Drive%"\%guidename%
if /i "%REGION%" EQU "E" echo change the region to Europe.>>"%Drive%"\%guidename%
if /i "%REGION%" EQU "J" echo change the region to Jap.>>"%Drive%"\%guidename%
if /i "%REGION%" EQU "K" echo change the region to Korean.>>"%Drive%"\%guidename%

copy /y "%Drive%"\%guidename%+Support\Guide\ARC2.001 "%Drive%"\%guidename%>nul


goto:noMyM


::----------------------Install Wads (MMM)-----------------------------

:installwads

if /i "%MMM%" NEQ "*" goto:SKIPWAD


::---------CREATE MMMCONFIG To Autoload 236--------
set patchIOSnum=236
if /i "%SETTINGS%" EQU "G" goto:skipmmmfly
if /i "%SETTINGSHM%" EQU "G" goto:skipmmmfly
echo ;MMMCONFIG (By ModMii)> "%Drive%"\mmmconfig.txt
echo AutoLoadIOS=%patchIOSnum%>> "%Drive%"\mmmconfig.txt
:skipmmmfly


copy /y "%Drive%"\%guidename%+Support\Guide\WADheader.001 "%Drive%"\%guidename%>nul

:wadlist

if /i "%IOS11P60%" EQU "*" support\sfk echo -spat \x3cli\x3eIOS11v16174(IOS60v6174[FS-ES-NP-VP-DIP])\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%IOS20P60%" EQU "*" support\sfk echo -spat \x3cli\x3eIOS20v16174(IOS60v6174[FS-ES-NP-VP-DIP])\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%IOS30P60%" EQU "*" support\sfk echo -spat \x3cli\x3eIOS30v16174(IOS60v6174[FS-ES-NP-VP-DIP])\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%IOS40P60%" EQU "*" support\sfk echo -spat \x3cli\x3eIOS40v16174(IOS60v6174[FS-ES-NP-VP-DIP])\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%IOS50P%" EQU "*" support\sfk echo -spat \x3cli\x3eIOS50v16174(IOS60v6174[FS-ES-NP-VP-DIP])\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%IOS52P%" EQU "*" support\sfk echo -spat \x3cli\x3eIOS52v16174(IOS60v6174[FS-ES-NP-VP-DIP])\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%IOS60P%" EQU "*" support\sfk echo -spat \x3cli\x3eIOS60v16174(IOS60v6174[FS-ES-NP-VP-DIP])\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%IOS70K%" EQU "*" support\sfk echo -spat \x3cli\x3eIOS70v16174(IOS60v6174[FS-ES-NP-VP-DIP])\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%IOS80K%" EQU "*" support\sfk echo -spat \x3cli\x3eIOS80v16174(IOS60v6174[FS-ES-NP-VP-DIP])\x3c/li\x3e>>"%Drive%"\%guidename%



if /i "%SM4.1U%" EQU "*" support\sfk echo -spat \x3cli\x3eSystemMenu_4.1U_v449\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%SM4.2U%" EQU "*" support\sfk echo -spat \x3cli\x3eSystemMenu_4.2U_v481\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%SM4.3U%" EQU "*" support\sfk echo -spat \x3cli\x3eSystemMenu_4.3U_v513\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%SM4.1E%" EQU "*" support\sfk echo -spat \x3cli\x3eSystemMenu_4.1E_v450\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%SM4.2E%" EQU "*" support\sfk echo -spat \x3cli\x3eSystemMenu_4.2E_v482\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%SM4.3E%" EQU "*" support\sfk echo -spat \x3cli\x3eSystemMenu_4.3E_v514\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%SM4.1J%" EQU "*" support\sfk echo -spat \x3cli\x3eSystemMenu_4.1J_v448\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%SM4.2J%" EQU "*" support\sfk echo -spat \x3cli\x3eSystemMenu_4.2J_v480\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%SM4.3J%" EQU "*" support\sfk echo -spat \x3cli\x3eSystemMenu_4.3J_v512\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%SM4.1K%" EQU "*" support\sfk echo -spat \x3cli\x3eSystemMenu_4.1K_v454\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%SM4.2K%" EQU "*" support\sfk echo -spat \x3cli\x3eSystemMenu_4.2K_v486\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%SM4.3K%" EQU "*" support\sfk echo -spat \x3cli\x3eSystemMenu_4.3K_v518\x3c/li\x3e>>"%Drive%"\%guidename%

if /i "%SM4.1U-DWR%" EQU "*" support\sfk echo -spat \x3cli\x3eSystemMenu_4.1U_v449_DarkWiiRed\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%SM4.2U-DWR%" EQU "*" support\sfk echo -spat \x3cli\x3eSystemMenu_4.2U_v481_DarkWiiRed\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%SM4.3U-DWR%" EQU "*" support\sfk echo -spat \x3cli\x3eSystemMenu_4.3U_v513_DarkWiiRed\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%SM4.1E-DWR%" EQU "*" support\sfk echo -spat \x3cli\x3eSystemMenu_4.1E_v450_DarkWiiRed\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%SM4.2E-DWR%" EQU "*" support\sfk echo -spat \x3cli\x3eSystemMenu_4.2E_v482_DarkWiiRed\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%SM4.3E-DWR%" EQU "*" support\sfk echo -spat \x3cli\x3eSystemMenu_4.3E_v514_DarkWiiRed\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%SM4.1J-DWR%" EQU "*" support\sfk echo -spat \x3cli\x3eSystemMenu_4.1J_v448_DarkWiiRed\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%SM4.2J-DWR%" EQU "*" support\sfk echo -spat \x3cli\x3eSystemMenu_4.2J_v480_DarkWiiRed\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%SM4.3J-DWR%" EQU "*" support\sfk echo -spat \x3cli\x3eSystemMenu_4.3J_v512_DarkWiiRed\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%SM4.1K-DWR%" EQU "*" support\sfk echo -spat \x3cli\x3eSystemMenu_4.1K_v454_DarkWiiRed\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%SM4.2K-DWR%" EQU "*" support\sfk echo -spat \x3cli\x3eSystemMenu_4.2K_v486_DarkWiiRed\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%SM4.3K-DWR%" EQU "*" support\sfk echo -spat \x3cli\x3eSystemMenu_4.3K_v518_DarkWiiRed\x3c/li\x3e>>"%Drive%"\%guidename%

if /i "%SM4.1U-DWG%" EQU "*" support\sfk echo -spat \x3cli\x3eSystemMenu_4.1U_v449_DarkWiiGreen\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%SM4.2U-DWG%" EQU "*" support\sfk echo -spat \x3cli\x3eSystemMenu_4.2U_v481_DarkWiiGreen\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%SM4.3U-DWG%" EQU "*" support\sfk echo -spat \x3cli\x3eSystemMenu_4.3U_v513_DarkWiiGreen\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%SM4.1E-DWG%" EQU "*" support\sfk echo -spat \x3cli\x3eSystemMenu_4.1E_v450_DarkWiiGreen\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%SM4.2E-DWG%" EQU "*" support\sfk echo -spat \x3cli\x3eSystemMenu_4.2E_v482_DarkWiiGreen\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%SM4.3E-DWG%" EQU "*" support\sfk echo -spat \x3cli\x3eSystemMenu_4.3E_v514_DarkWiiGreen\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%SM4.1J-DWG%" EQU "*" support\sfk echo -spat \x3cli\x3eSystemMenu_4.1J_v448_DarkWiiGreen\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%SM4.2J-DWG%" EQU "*" support\sfk echo -spat \x3cli\x3eSystemMenu_4.2J_v480_DarkWiiGreen\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%SM4.3J-DWG%" EQU "*" support\sfk echo -spat \x3cli\x3eSystemMenu_4.3J_v512_DarkWiiGreen\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%SM4.1K-DWG%" EQU "*" support\sfk echo -spat \x3cli\x3eSystemMenu_4.1K_v454_DarkWiiGreen\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%SM4.2K-DWG%" EQU "*" support\sfk echo -spat \x3cli\x3eSystemMenu_4.2K_v486_DarkWiiGreen\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%SM4.3K-DWG%" EQU "*" support\sfk echo -spat \x3cli\x3eSystemMenu_4.3K_v518_DarkWiiGreen\x3c/li\x3e>>"%Drive%"\%guidename%

if /i "%SM4.1U-DWB%" EQU "*" support\sfk echo -spat \x3cli\x3eSystemMenu_4.1U_v449_DarkWiiBlue\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%SM4.2U-DWB%" EQU "*" support\sfk echo -spat \x3cli\x3eSystemMenu_4.2U_v481_DarkWiiBlue\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%SM4.3U-DWB%" EQU "*" support\sfk echo -spat \x3cli\x3eSystemMenu_4.3U_v513_DarkWiiBlue\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%SM4.1E-DWB%" EQU "*" support\sfk echo -spat \x3cli\x3eSystemMenu_4.1E_v450_DarkWiiBlue\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%SM4.2E-DWB%" EQU "*" support\sfk echo -spat \x3cli\x3eSystemMenu_4.2E_v482_DarkWiiBlue\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%SM4.3E-DWB%" EQU "*" support\sfk echo -spat \x3cli\x3eSystemMenu_4.3E_v514_DarkWiiBlue\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%SM4.1J-DWB%" EQU "*" support\sfk echo -spat \x3cli\x3eSystemMenu_4.1J_v448_DarkWiiBlue\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%SM4.2J-DWB%" EQU "*" support\sfk echo -spat \x3cli\x3eSystemMenu_4.2J_v480_DarkWiiBlue\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%SM4.3J-DWB%" EQU "*" support\sfk echo -spat \x3cli\x3eSystemMenu_4.3J_v512_DarkWiiBlue\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%SM4.1K-DWB%" EQU "*" support\sfk echo -spat \x3cli\x3eSystemMenu_4.1K_v454_DarkWiiBlue\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%SM4.2K-DWB%" EQU "*" support\sfk echo -spat \x3cli\x3eSystemMenu_4.2K_v486_DarkWiiBlue\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%SM4.3K-DWB%" EQU "*" support\sfk echo -spat \x3cli\x3eSystemMenu_4.3K_v518_DarkWiiBlue\x3c/li\x3e>>"%Drive%"\%guidename%

if /i "%SM4.1U-DWO%" EQU "*" support\sfk echo -spat \x3cli\x3eSystemMenu_4.1U_v449_DarkWiiOrange\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%SM4.2U-DWO%" EQU "*" support\sfk echo -spat \x3cli\x3eSystemMenu_4.2U_v481_DarkWiiOrange\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%SM4.3U-DWO%" EQU "*" support\sfk echo -spat \x3cli\x3eSystemMenu_4.3U_v513_DarkWiiOrange\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%SM4.1E-DWO%" EQU "*" support\sfk echo -spat \x3cli\x3eSystemMenu_4.1E_v450_DarkWiiOrange\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%SM4.2E-DWO%" EQU "*" support\sfk echo -spat \x3cli\x3eSystemMenu_4.2E_v482_DarkWiiOrange\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%SM4.3E-DWO%" EQU "*" support\sfk echo -spat \x3cli\x3eSystemMenu_4.3E_v514_DarkWiiOrange\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%SM4.1J-DWO%" EQU "*" support\sfk echo -spat \x3cli\x3eSystemMenu_4.1J_v448_DarkWiiOrange\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%SM4.2J-DWO%" EQU "*" support\sfk echo -spat \x3cli\x3eSystemMenu_4.2J_v480_DarkWiiOrange\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%SM4.3J-DWO%" EQU "*" support\sfk echo -spat \x3cli\x3eSystemMenu_4.3J_v512_DarkWiiOrange\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%SM4.1K-DWO%" EQU "*" support\sfk echo -spat \x3cli\x3eSystemMenu_4.1K_v454_DarkWiiOrange\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%SM4.2K-DWO%" EQU "*" support\sfk echo -spat \x3cli\x3eSystemMenu_4.2K_v486_DarkWiiOrange\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%SM4.3K-DWO%" EQU "*" support\sfk echo -spat \x3cli\x3eSystemMenu_4.3K_v518_DarkWiiOrange\x3c/li\x3e>>"%Drive%"\%guidename%


if /i "%cIOS202[60]-v5.1R%" EQU "*" support\sfk echo -spat \x3cli\x3ecIOS202[60]-v5.1R\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%cIOS222[38]-v4%" EQU "*" support\sfk echo -spat \x3cli\x3ecIOS222[38]-v4\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%cIOS223[37-38]-v4%" EQU "*" support\sfk echo -spat \x3cli\x3ecIOS223[37-38]-v4\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%cIOS224[57]-v5.1R%" EQU "*" support\sfk echo -spat \x3cli\x3ecIOS224[57]-v5.1R\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%cIOS249[56]-d2x-v8-final%" EQU "*" support\sfk echo -spat \x3cli\x3ecIOS249[56]-d2x-v%d2x-beta-rev%\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%cIOS250[57]-d2x-v8-final%" EQU "*" support\sfk echo -spat \x3cli\x3ecIOS250[57]-d2x-v%d2x-beta-rev%\x3c/li\x3e>>"%Drive%"\%guidename%

if /i "%RVL-cMIOS-v65535(v10)_WiiGator_WiiPower_v0.2%" EQU "*" support\sfk echo -spat \x3cli\x3eRVL-cMIOS-v65535(v10)_WiiGator_WiiPower_v0.2\x3c/li\x3e>>"%Drive%"\%guidename%


if /i "%EULAU%" EQU "*" support\sfk echo -spat \x3cli\x3eEULA-NUS-v3[U]\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%RSU%" EQU "*" support\sfk echo -spat \x3cli\x3eRegion-Select-NUS-v2[U]\x3c/li\x3e>>"%Drive%"\%guidename%

if /i "%EULAE%" EQU "*" support\sfk echo -spat \x3cli\x3eEULA-NUS-v3[E]\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%RSE%" EQU "*" support\sfk echo -spat \x3cli\x3eRegion-Select-NUS-v2[E]\x3c/li\x3e>>"%Drive%"\%guidename%

if /i "%EULAJ%" EQU "*" support\sfk echo -spat \x3cli\x3eEULA-NUS-v3[J]\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%RSJ%" EQU "*" support\sfk echo -spat \x3cli\x3eRegion-Select-NUS-v2[J]\x3c/li\x3e>>"%Drive%"\%guidename%

if /i "%EULAK%" EQU "*" support\sfk echo -spat \x3cli\x3eEULA-NUS-v3[K]\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%RSK%" EQU "*" support\sfk echo -spat \x3cli\x3eRegion-Select-NUS-v2[K]\x3c/li\x3e>>"%Drive%"\%guidename%



if /i "%MII%" EQU "*" support\sfk echo -spat \x3cli\x3eMii-Channel-NUS-v6\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%P%" EQU "*" support\sfk echo -spat \x3cli\x3ePhoto-Channel-1.1-NUS-v3\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%PK%" EQU "*" support\sfk echo -spat \x3cli\x3ePhoto-Channel-1.1-NUS-v3[K]\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%S%" EQU "*" support\sfk echo -spat \x3cli\x3eShopping-Channel-NUS-v21\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%SK%" EQU "*" support\sfk echo -spat \x3cli\x3eShopping-Channel-NUS-v21[K]\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%IU%" EQU "*" support\sfk echo -spat \x3cli\x3eOpera-Internet-Channel-NUS[U]\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%IE%" EQU "*" support\sfk echo -spat \x3cli\x3eOpera-Internet-Channel-NUS[E]\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%IJ%" EQU "*" support\sfk echo -spat \x3cli\x3eOpera-Internet-Channel-NUS[J]\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%WU%" EQU "*" support\sfk echo -spat \x3cli\x3eWeather-Channel-NUS-v7[U]\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%WE%" EQU "*" support\sfk echo -spat \x3cli\x3eWeather-Channel-NUS-v7[E]\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%WJ%" EQU "*" support\sfk echo -spat \x3cli\x3eWeather-Channel-NUS-v7[J]\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%NU%" EQU "*" support\sfk echo -spat \x3cli\x3eNEWS-Channel-NUS-v7[U]\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%NE%" EQU "*" support\sfk echo -spat \x3cli\x3eNEWS-Channel-NUS-v7[E]\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%NJ%" EQU "*" support\sfk echo -spat \x3cli\x3eNEWS-Channel-NUS-v7[J]\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%WSU%" EQU "*" support\sfk echo -spat \x3cli\x3eWii-Speak-Channel-NUS[U]\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%WSE%" EQU "*" support\sfk echo -spat \x3cli\x3eWii-Speak-Channel-NUS[E]\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%WSJ%" EQU "*" support\sfk echo -spat \x3cli\x3eWii-Speak-Channel-NUS[J]\x3c/li\x3e>>"%Drive%"\%guidename%

if /i "%M10%" EQU "*" support\sfk echo -spat \x3cli\x3eRVL-mios-v10\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%IOS9%" EQU "*" support\sfk echo -spat \x3cli\x3eIOS9-64-v1034\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%IOS12%" EQU "*" support\sfk echo -spat \x3cli\x3eIOS12-64-v526\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%IOS13%" EQU "*" support\sfk echo -spat \x3cli\x3eIOS13-64-v1032\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%IOS14%" EQU "*" support\sfk echo -spat \x3cli\x3eIOS14-64-v1032\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%IOS15%" EQU "*" support\sfk echo -spat \x3cli\x3eIOS15-64-v1032\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%IOS17%" EQU "*" support\sfk echo -spat \x3cli\x3eIOS17-64-v1032\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%IOS21%" EQU "*" support\sfk echo -spat \x3cli\x3eIOS21-64-v1039\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%IOS22%" EQU "*" support\sfk echo -spat \x3cli\x3eIOS22-64-v1294\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%IOS28%" EQU "*" support\sfk echo -spat \x3cli\x3eIOS28-64-v1807\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%IOS31%" EQU "*" support\sfk echo -spat \x3cli\x3eIOS31-64-v3608\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%IOS33%" EQU "*" support\sfk echo -spat \x3cli\x3eIOS33-64-v3608\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%IOS34%" EQU "*" support\sfk echo -spat \x3cli\x3eIOS34-64-v3608\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%IOS35%" EQU "*" support\sfk echo -spat \x3cli\x3eIOS35-64-v3608\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%IOS36v3608%" EQU "*" support\sfk echo -spat \x3cli\x3eIOS36-64-v3608\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%IOS37%" EQU "*" support\sfk echo -spat \x3cli\x3eIOS37-64-v5663\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%IOS38%" EQU "*" support\sfk echo -spat \x3cli\x3eIOS38-64-v4124\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%IOS41%" EQU "*" support\sfk echo -spat \x3cli\x3eIOS41-64-v3607\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%IOS43%" EQU "*" support\sfk echo -spat \x3cli\x3eIOS43-64-v3607\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%IOS45%" EQU "*" support\sfk echo -spat \x3cli\x3eIOS45-64-v3607\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%IOS46%" EQU "*" support\sfk echo -spat \x3cli\x3eIOS46-64-v3607\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%IOS48v4124%" EQU "*" support\sfk echo -spat \x3cli\x3eIOS48-64-v4124\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%IOS53%" EQU "*" support\sfk echo -spat \x3cli\x3eIOS53-64-v5663\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%IOS55%" EQU "*" support\sfk echo -spat \x3cli\x3eIOS55-64-v5663\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%IOS56%" EQU "*" support\sfk echo -spat \x3cli\x3eIOS56-64-v5662\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%IOS57%" EQU "*" support\sfk echo -spat \x3cli\x3eIOS57-64-v5919\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%IOS58%" EQU "*" support\sfk echo -spat \x3cli\x3eIOS58-64-v6176\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%IOS61%" EQU "*" support\sfk echo -spat \x3cli\x3eIOS61-64-v5662\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%IOS62%" EQU "*" support\sfk echo -spat \x3cli\x3eIOS62-64-v6430\x3c/li\x3e>>"%Drive%"\%guidename%
if /i "%IOS236%" EQU "*" support\sfk echo -spat \x3cli\x3eIOS236v65535(IOS36v3351[FS-ES-NP-VP])\x3c/li\x3e>>"%Drive%"\%guidename%

::add closing bullet tag and line break if no usbloader
if /i "%USBX%" NEQ "*" support\sfk echo -spat \x3c/ul\x3e\x3cbr\x3e>>"%Drive%"\%guidename%

if /i "%USBX%" EQU "*" copy /y "%Drive%"\%guidename%+Support\Guide\ForwarderWAD.001 "%Drive%"\%guidename%>nul


if /i "%MENU1%" EQU "H" goto:HMafterwadlist


if /i "%FIRM%" NEQ "%FIRMSTART%" support\sfk echo -spat \x3cbr\x3e\x3cb\x3eNote:\x3c/b\x3e Whenever you install a new System Menu, Priiloader is uninstalled. So be sure to reinstall it afterwards (especially if you do not have bootmii as boot2)\x3cbr\x3e>>"%Drive%"\%guidename%

::extra line break
support\sfk echo -spat \x3cbr\x3e>>"%Drive%"\%guidename%

set installwads=done
if /i "%FIRM%" NEQ "%FIRMSTART%" goto:PRIIGUIDE

:SKIPWAD

::------------------------reinstall HBC / Fix Upsidedown homebrew channel----------------------------
:reinstallHBC
If /i "%HM%" NEQ "*" goto:MyMGuide



if /i "%MENU1%" NEQ "SU" support\sfk echo -spat \x3cfont size=\x225\x22\x3e\x3cli\x3eReinstall the Homebrew Channel (if applicable)\x3c/li\x3e\x3c/font\x3e\x3cbr\x3e>>"%Drive%"\%guidename%

if /i "%MENU1%" EQU "SU" support\sfk echo -spat \x3cfont size=\x225\x22\x3e\x3cli\x3eReinstall the Homebrew Channel\x3c/li\x3e\x3c/font\x3e\x3cbr\x3e>>"%Drive%"\%guidename%


copy /y "%Drive%"\%guidename%+Support\Guide\HBCreinstall.001 "%Drive%"\%guidename%>nul


if /i "%MENU1%" NEQ "SU" support\sfk echo -spat If the HBC is failing to load the HackMii_Installer (just blackscreens), instead launch the Hackmii Installer using the method described in the first Step.\x3cbr\x3e>>"%Drive%"\%guidename%

support\sfk echo -spat \x3cbr\x3e>>"%Drive%"\%guidename%





::------------------------Install Custom Theme Using MyMenuify----------------------------
:MyMGuide

If /i "%MyM%" NEQ "*" goto:noMyM

support\sfk echo -spat \x3cfont size=\x225\x22\x3e\x3cli\x3eInstall Custom Wii Menu Theme using MyMenuifyMod (optional)\x3c/li\x3e\x3c/font\x3e\x3cbr\x3e>>"%Drive%"\%guidename%

copy /y "%Drive%"\%guidename%+Support\Guide\MyMenuify.001 "%Drive%"\%guidename%>nul

support\sfk echo -spat Navigate to the theme you would like to install that corresponds to your specific System Menu Version (%FIRM%%REGION%) then press A to install it.\x3cbr\x3e\x3cbr\x3e>>"%Drive%"\%guidename%

support\sfk echo -spat If you ever decide to restore the original Menu Wii theme, simply launch MyMenuifyMod again, navigate to 000000XX_%FIRM%%REGION%.app and press \x22A\x22 to install it.\x3cbr\x3e\x3cbr\x3e>>"%Drive%"\%guidename%

:noMyM



::--------End of hacking steps listings (and line break). This must be here for the hacking guide------------
support\sfk echo -spat \x3c/ol\x3e\x3cbr\x3e>>"%Drive%"\%guidename%


if /i "%USBGUIDE%" EQU "Y" goto:USBGUIDESTEP1




::--------------------After Modding-----------------------
:AFTERMODDING

copy /y "%Drive%"\%guidename%+Support\Guide\AfterModding.001 "%Drive%"\%guidename%>nul


::---------------------credits and support XFLAK-----------------------
:supportxflak

copy /y "%Drive%"\%guidename%+Support\Guide\Credits-XFlak-End.001 "%Drive%"\%guidename%>nul



::guide finish, remove carriage returns and open
support\sfk filter "%Drive%"\%guidename% -lsrep _.__ -rep _"printbutton {"_".printbutton {"_ -write -yes>nul



start /D "%Drive%" %guidename%


::---------------CMD LINE MODE-------------
if /i "%cmdlinemode%" NEQ "Y" goto:notcmdfinish
if /i "%cmdguide%" NEQ "G" goto:notcmdfinish
if exist support\settings.bak move /y support\settings.bak support\settings.bat>nul
exit
:notcmdfinish


if /i "%AbstinenceWiz%" NEQ "Y" goto:notAbstinenceWiz
set casper=
set BB1=
set BB2=
set SMASH=
set PWNS=
set Twi=
set YUGI=
set Bathaxx=
set ROTJ=
set TOS=
set Twi=
set FORMAT=
set f32=
if /i "%SETTINGS%" EQU "G" goto:SNKNANDCONFIRM
goto:SNEEKINSTALLER
:notAbstinenceWiz

if /i "%SETTINGS%" EQU "G" goto:DOWNLOADQUEUE
if /i "%SETTINGSHM%" EQU "G" goto:HACKMIISOLUTION


goto:DLSETTINGS2


::-------------USB-Loader Setup Steps--------------
:USBGUIDESTEP1

support\sfk echo -spat \x3cfont size=\x226\x22\x3e\x3cli\x3eUSB Loader and Hard Drive setup\x3c/li\x3e\x3c/font\x3e\x3cbr\x3e>>"%Drive%"\%guidename%

if /i "%MENU1%" EQU "W" support\sfk echo -spat The rest of the guide is performed on your computer in order to set up your USB-Loader\x3cbr\x3e>>"%Drive%"\%guidename%

:CasperPickUp

support\sfk echo -spat \x3col\x3e>>"%Drive%"\%guidename%



::-------------FAT32 + NTFS-----------------------
if /i "%FORMAT%" NEQ "3" goto:skippartition

copy /y "%Drive%"\%guidename%+Support\Guide\FAT32-NTFS.001 "%Drive%"\%guidename%>nul


if /i "%PCSAVE%" EQU "Portable" goto:portableF32
if /i "%PCSAVE%" NEQ "Auto" goto:skip
if /i "%Homedrive%" NEQ "%cd:~0,2%" goto:portableF32
:skip

echo Launch FAT32 GUI Formatter from shortcuts on your Start Menu or Desktop>>"%Drive%"\%guidename%
goto:noportableF32

:portableF32
support\sfk echo -spat Launch FAT32_GUI_Formatter.exe saved here:\x3cbr\x3e>>"%Drive%"\%guidename%
if /i "%USBCONFIG%" EQU "USB" echo %DRIVEU%\FAT32_GUI_Formatter\FAT32_GUI_Formatter.exe>>"%Drive%"\%guidename%
if /i "%USBCONFIG%" NEQ "USB" echo %DRIVE%\FAT32_GUI_Formatter\FAT32_GUI_Formatter.exe>>"%Drive%"\%guidename%
:noportableF32

copy /y "%Drive%"\%guidename%+Support\Guide\FAT32-NTFSend.001 "%Drive%"\%guidename%>nul

:skippartition



::-------------FAT32---------------
if /i "%FORMAT%" NEQ "1" goto:notfat32

copy /y "%Drive%"\%guidename%+Support\Guide\FAT32.001 "%Drive%"\%guidename%>nul


if /i "%PCSAVE%" EQU "Portable" goto:portableF32
if /i "%PCSAVE%" NEQ "Auto" goto:skip
if /i "%Homedrive%" NEQ "%cd:~0,2%" goto:portableF32
:skip

echo Launch FAT32 GUI Formatter from shortcuts on your Start Menu or Desktop>>"%Drive%"\%guidename%
goto:noportableF32

:portableF32
if /i "%USBCONFIG%" EQU "USB" echo Launch FAT32_GUI_Formatter.exe saved here: %DRIVEU%\FAT32_GUI_Formatter\FAT32_GUI_Formatter.exe>>"%Drive%"\%guidename%
if /i "%USBCONFIG%" NEQ "USB" echo Launch FAT32_GUI_Formatter.exe saved here: %DRIVE%\FAT32_GUI_Formatter\FAT32_GUI_Formatter.exe>>"%Drive%"\%guidename%
:noportableF32

copy /y "%Drive%"\%guidename%+Support\Guide\FAT32end.001 "%Drive%"\%guidename%>nul

:notfat32


if /i "%AbstinenceWiz%" EQU "Y" goto:AbstinenceWizGUIDE


::-------------NTFS---------------
if /i "%FORMAT%" EQU "2" copy /y "%Drive%"\%guidename%+Support\Guide\NTFS.001 "%Drive%"\%guidename%>nul



::------------copy file to usb--------
if /i "%FORMAT%" EQU "4" goto:skipcopytousb
if /i "%FORMAT%" EQU "5" goto:skipcopytousb

if /i "%USBCONFIG%" NEQ "USB" goto:skipcopytousb

support\sfk echo -spat \x3cfont size=\x225\x22\x3e\x3cli\x3eCopy Files to the Hard Drive\x3c/li\x3e\x3c/font\x3e\x3cbr\x3eCopy everything inside the %DRIVEU% folder to the root of your FAT32 hard-drive\partition.\x3cbr\x3e\x3cbr\x3e>>"%Drive%"\%guidename%

:skipcopytousb

::-------------WiiBackupManager--------------
support\sfk echo -spat \x3cfont size=\x225\x22\x3e\x3cli\x3eManage Wii backups using Wii Backup Manager (optional)\x3c/li\x3e\x3c/font\x3e\x3cbr\x3e>>"%Drive%"\%guidename%



if /i "%PCSAVE%" EQU "Portable" goto:portableWBM
if /i "%PCSAVE%" NEQ "Auto" goto:skip
if /i "%Homedrive%" NEQ "%cd:~0,2%" goto:portableWBM
:skip

support\sfk echo -spat Launch WiiBackupManager from shortcuts on your Start Menu or Desktop\x3cbr\x3e>>"%Drive%"\%guidename%
goto:noportableWBM

:portableWBM
if /i "%USBCONFIG%" EQU "USB" support\sfk echo -spat Launch WiiBackupManager.exe saved here: %DRIVEU%\WiiBackupManager\x3cbr\x3e>>"%Drive%"\%guidename%
if /i "%USBCONFIG%" NEQ "USB" support\sfk echo -spat Launch WiiBackupManager.exe saved here: %DRIVE%\WiiBackupManager\x3cbr\x3e>>"%Drive%"\%guidename%
:noportableWBM


copy /y "%Drive%"\%guidename%+Support\Guide\WBM.001 "%Drive%"\%guidename%>nul


if /i "%USBFOLDER%" EQU "*" support\sfk echo -spat To copy \x3cu\x3eoriginal\x3c/u\x3e Wii Disc's, insert the disc into your Wii and Launch Configurable USB-Loader, and hit the plus sign \x22\x2b\x22. \x3cbr\x3e>>"%Drive%"\%guidename%

if /i "%FLOW%" EQU "*" support\sfk echo -spat To copy \x3cu\x3eoriginal\x3c/u\x3e Wii Disc's, insert the disc into your Wii and Launch WiiFlow, go to page 2 of WiiFlow's Settings and select \x22Install\x22, then select \x22Go\x22.\x3cbr\x3e>>"%Drive%"\%guidename%

support\sfk echo -spat \x3cbr\x3e>>"%Drive%"\%guidename%

if /i "%FORMAT%" EQU "2" support\sfk echo -spat \x3cb\x3eWarning\x3c/b\x3e: Ripping to NTFS is \x3cu\x3every\x3c/u\x3e unstable, it is highly recommended to only add games to an NTFS hard drive using your computer.\x3cbr\x3e\x3cbr\x3e>>"%Drive%"\%guidename%


if /i "%FORMAT%" EQU "3" support\sfk echo -spat \x3cb\x3eWarning\x3c/b\x3e: Ripping to NTFS is \x3cu\x3every\x3c/u\x3e unstable, it is highly recommended to only add games to an NTFS hard drive using your computer.\x3cbr\x3e\x3cbr\x3e>>"%Drive%"\%guidename%


::-------------CONFIGURE/CUSTOMIZE CONFIGURABLE USB-LOADER (OPTIONAL)-------------
if /i "%USBFOLDER%" NEQ "*" goto:skip

support\sfk echo -spat \x3cfont size=\x225\x22\x3e\x3cli\x3eConfigure/Customize Configurable USB-Loader (optional)\x3c/li\x3e\x3c/font\x3e\x3cbr\x3e>>"%Drive%"\%guidename%

if /i "%USBCONFIG%" EQU "USB" support\sfk echo -spat To Configure/Customize your USB-Loader, use the Configurator for Configurable USB-Loader found here: %DRIVEU%\usb-loader\CfgLoaderConfigurator.exe\x3cbr\x3e>>"%Drive%"\%guidename%

if /i "%USBCONFIG%" NEQ "USB" support\sfk echo -spat To Configure/Customize your USB-Loader, use the Configurator for Configurable USB-Loader found here: %DRIVE%\usb-loader\CfgLoaderConfigurator.exe\x3cbr\x3e>>"%Drive%"\%guidename%


copy /y "%Drive%"\%guidename%+Support\Guide\CustomizeCFG.001 "%Drive%"\%guidename%>nul
:skip


::ADD end of ordered list and line break for ALL usb-loader guides (</ol><br>)
support\sfk echo -spat \x3c/ol\x3e\x3cbr\x3e>>"%Drive%"\%guidename%


if /i "%MENU1%" EQU "W" goto:AFTERMODDING

GOTO:supportxflak


::---------AbstinenceWizguide (after USB SETUP)----------
:AbstinenceWizGUIDE


::copy files to USB
if /i "%SNEEKTYPE:~0,1%" EQU "U" support\sfk echo -spat \x3cfont size=\x225\x22\x3e\x3cli\x3eCopy Files to the Hard Drive\x3c/li\x3e\x3c/font\x3e\x3cbr\x3eCopy everything inside the %DRIVEU% folder to the root of your FAT32 hard-drive\partition.\x3cbr\x3e\x3cbr\x3e>>"%Drive%"\%guidename%


support\sfk echo -spat \x3cfont size=\x225\x22\x3e\x3cli\x3eLaunch an Exploit on Your Wii\x3c/li\x3e\x3c/font\x3e\x3cbr\x3e\x3cbr\x3e>>"%Drive%"\%guidename%



::goto exploit
set afterexploit=continueAbstinenceguide
goto:exploits
:continueAbstinenceguide


::Install IOS51 if required
if /i "%FIRMSTART%" EQU "4.3" goto:skipWADIOS53
if /i "%FIRMSTART%" EQU "4.2" goto:skipWADIOS53

copy /y "%Drive%"\%guidename%+Support\Guide\WADIOS53.001 "%Drive%"\%guidename%>nul

:skipWADIOS53

support\sfk echo -spat This runs Casper which is configured to start %neekname%.\x3cbr\x3e\x3cbr\x3e>>"%Drive%"\%guidename%


::NEEK TIPS

support\sfk echo -spat \x3cfont size=\x225\x22\x3e\x3cli\x3eHelpful Hints on Using %neekname%\x3c/li\x3e\x3c/font\x3e\x3cbr\x3e\x3cbr\x3e>>"%Drive%"\%guidename%

copy /y "%Drive%"\%guidename%+Support\Guide\NEEKTIPS.001 "%Drive%"\%guidename%>nul
if /i "%SNEEKTYPE:~-1%" EQU "D" copy /y "%Drive%"\%guidename%+Support\Guide\NEEKDITIPS.001 "%Drive%"\%guidename%>nul
copy /y "%Drive%"\%guidename%+Support\Guide\NEEKTIPSEND.001 "%Drive%"\%guidename%>nul


::ADD end of ordered list and line break (</ol><br>)
support\sfk echo -spat \x3c/ol\x3e\x3cbr\x3e>>"%Drive%"\%guidename%

::ADD end of ordered list and line break (</ol><br>)
support\sfk echo -spat \x3c/ol\x3e\x3cbr\x3e>>"%Drive%"\%guidename%

GOTO:supportxflak
