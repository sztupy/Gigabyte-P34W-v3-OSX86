Dual boot Windows 8.1&10 / OSX El Captain 10.11.1 guide for Gigabyte P34W v3
============================================================================

If you would like to install El Capitan instead please check out [https://github.com/sztupy/Gigabyte-P34W-v3-OSX86/tree/yosemite](this guide).

Quick compatibility chart and overview
--------------------------------------

    Name            Type                                  Comp  Comments
    Device          Gigabyte P34W v3                      ✓
    BIOS            UEFI Aptio FB05 / F002                ✓     Needs OsxAptioFixDrv
    CPU             Intel i7-4720HQ                       ✓
    Memory          8GB (+ 4GB from old machine)          ✓
    Video           Intel HD 4600                         ✓     Needs Clover patch and FakePCIID.
                    GTX 970M                              X     Needs DSDT patch to disable
    USB             2.0                                   ✓
                    3.0                                   ✓     Without injector kext only the USB Charge port (left top) works for USB 3.0 devices
    Display         built-in                              ✓
                    HDMI                                  ✓
    Audio           ALC282                                ✓     Works with AppleHDA-272.18.1-ALC282_v2
                    HDMI                                  ?     untested
    Ethernet        RTL8111                               ✓     Needs Realtek RTL8111.kext
    Wireless        Intel 7260                            X
                    AR9287 (from old machine)             ✓
                    BCM94352HMB (bought separately)       ✓     Needs FakePCIID patch
    Bluetooth       Intel 7260                            X
                    BCM94352HMB (bought separately)       ✓     Needs BcrmPatchRam2.kext
    ACPI            Battery                               ✓     Needs ACPIBatteryManager and DSDT fixes
                    Sleep                                 ✓     Needs DSDT fixes
                    Deep sleep                            X
    Disk            1TB HDD                               ✓
                    256Gb mSATA SSD (installed later)     ✓     Using trimforce enable
    USB             Intel 8 / C220 XHCI                   ✓
    Webcam          UVC Camera                            ✓
    SD card reader  RTS5227                               X
    Keyboard        PS2                                   ✓     Needs DSDT patch for brightness controls
    Touchpad        ELAN v3                               ✓     Needs ApplePS2SmartTouchPad

[Resources (kexts, DSDT, patches, etc) for the installation can be found here](https://github.com/sztupy/Gigabyte-P34W-v3-OSX86). They might be out of date, so the guide will link to the original source for these files instead.

TL;DR
-----

The Gigabyte P34W v3 is a strong but lightweight 14" gaming notebook, which is almost ideal for El Capitan. Most functionality work out of the box, and the only two concerns that are hard to rectify is the ELAN touchpad (which needs the non open source SmartTouchPad kext), and the SD card reader, which is unfortunately not USB based. Also the wifi card needs replacement, and deep sleep doesn't seem to be working for now.

Most of the described functionality should still work with the Schenker XMG C405 with GTX965 as well, as they are the same barebone. The P34W v2 should also be okay. The P34W v4, and the XMG C405 with GTX970 however already have Broadwell CPUs, so some of the described functionality here might not apply to them.

Pre-install
-----------

I have bought the P34W V3-CF2 version, which is similar to the CF1, but doesn't have an SSD (as I wanted to buy it separately). I have installed the SSD (Samsung Evo 850 250GB), and the AR9287 wifi chipset. You have to dismantle the notebook for these, [here is a disassembly video](https://www.youtube.com/watch?v=Lbn3PMfogzk) you can use for reference.

Also have two USB devices ready, [one with the Windows installer,](http://windows.microsoft.com/en-GB/windows-8/create-reset-refresh-media) the other one with El Capitan. [You can use this guide](http://www.tonymacx86.com/yosemite-laptop-support/148093-guide-booting-os-x-installer-laptops-clover.html) to prepare the El Capitan installer, with the following notes:

- I am using clover v3330
- I have used the unibeast method to create the installation media, and installed clover on top of it.
- You can use [this `config.plist` for install](https://github.com/sztupy/Gigabyte-P34W-v3-OSX86/blob/master/Clover_Config/1-Install/config.plist),   which is basically the default clover config with the KernelPM and AICPM patches enabled.
- The `VoodooPS2Controller` will not work properly with the touchpad, and sometimes it won't even load up the keyboard in case the touchpad initialisation fails, so until there is a better kext, use [SmartTouchPad v4.5](http://forum.osxlatitude.com/index.php?/topic/1948-elan-focaltech-and-synaptics-smart-touchpad-driver-mac-os-x/) Alternatively you can just connect an USB keyboard and mouse during installation.
- Don't forget to add the `OsxAptioFixDrv` driver, and to replace the `VBoxHFS` with the `HFSPlus` driver. For installation you might need to use `OsxAptioFixDrv2`, for running the system the first version is also okay.
- Additional kexts you'll need:

    - [`FakeSMC.kext`](https://github.com/RehabMan/OS-X-FakeSMC-kozlek)
    - [`RealtekRTL8111.kext`](https://github.com/RehabMan/OS-X-Realtek-Network)

- [You can find all kexts to install into Clover here](https://github.com/sztupy/Gigabyte-P34W-v3-OSX86/tree/master/Kexts/Clover)

Since the licence key of the preinstalled Windows 8.1 is not glued on to the notebook it might be wise to use a [key finder](https://wpkf.codeplex.com) to save it for later, although it won't be needed as the key is stored in the BIOS as well.

BIOS settings:
--------------

For install change the following settings in the BIOS (press <kbd>F2</kbd> during boot to enter setup)

- `Save&Exit` -> `Restore Win8.1 defaults` (computer will restart after this)
- `Security` -> `Delete all secure boot variables` (computer will restart after this)
- `Advanced` -> `3D Graphic Acceleration` -> `Disabled`
- `Advanced` -> `USB Configuration` -> `XHCI Mode` -> `Disabled`

Partitioning
------------

I will be installing the two OSs on the SSD, giving 120/120GB each, so I'm going to partition the device accordingly. For now I'm skipping the HDD. I had better luck with partitioning from Windows, so I'll use that.

Insert your Windows 8.1 installation media, and press <kbd>F12</kbd> during boot to chose it. Make sure you're selecting the line that says UEFI:, otherwise it will boot in legacy mode. After selecting install press <kbd>SHIFT</kbd>+<kbd>F10</kbd> to enter command line.

On the command line please enter the following (the indented lines starting with dashes are only comments):

    diskpart          - wait after this a while for diskpart to load
    list disk         - check the result. disk 0 should be the SSD, you can easily check by the size of the disk
    select disk 0     - in case your SSD was not disk 0, use that instead
    clean             - THIS WILL EREASE EVERYTHING ON THE DEVICE. You have been warned
    convert gpt
    create partition efi size=256
    format quick fs=fat32 label="EFI"
    create partition msr size=128
    create partition primary size=119000          - this is around half the remaining size on the disk. If you have smaller / larger SSD modify it accordingly.
    format fs=ntfs quick
    exit
    exit

Windows 8.1
-----------

After this you should be able to install Windows 8.1 onto the newly created 119GB partition. If not please make sure you have started the installation media in UEFI mode. Once Windows 8.1 is installed you can upgrade it to Windows 10 if you want to, this guide will not describe these steps.

Once Windows 8.1 is installed, and you are sure that you can reinstall it anytime without issues you might want to delete everything on the HDD, and repartition it. Note that this will delete the recovery partition on your HDD. If you can reinstall Windows 8.1 from an USB then you'll probably won't need it though.

El Capitan Install
------------------

Once Windows 8.1 is installed, and you're happy with it (note that USB3 and Nvidia is still disabled in the BIOS, we'll enable it after the OSX install), you can move onto the El Capitan install. Insert your OSX installation media, Press <kbd>F12</kbd> during start, and select it. Please make sure again that you are selecting the UEFI option, otherwise the installation will not work.

During installation use Disk Utility to add a HFS+ Journaled, case insensitive partition on the free space we have left on the SSD during Windows 8.1 install, and install OSX there. [You can use this guide](http://www.tonymacx86.com/yosemite-laptop-support/148093-guide-booting-os-x-installer-laptops-clover.html) if you need help for these steps. If the installer does not start up, or reboots when the apple logo comes up, then make sure that:

- Clover has KernelPM and AICPM patches enabled (if they are not set inside the config.plist, you have to enable them every time inside the Options panel during boot)
- You have 3D Graphics disabled in the bios (alternatively you can also try using `nv_disable=1` boot flag as well)

Once installation finishes, boot Clover from the USB drive (again, make sure to use UEFI in the boot screen), and boot into your new installation.

Set clover as boot manager
--------------------------

Once booted into the new installation you can download and install Clover onto your main SSD as well. Don't forget to do the same steps as you did with the El Capitan install media (enable KernelPM patches inside config.plist and installing the necessary kexts)

Unfortunately the BIOS will not pick up the clover installation, so you'll need to use the "bootmgr" trick: go to your EFI partition, `Microsoft` -> `Boot`, rename `bootmgfw.efi` to `bootmgfw-orig.efi`. Then copy `Clover` -> `CloverX64.efi` into `Microsoft` -> `Boot`. Finally rename `CloverX64.efi` inside `Microsoft` -> `Boot` to `bootmgfw.efi`

Restart, go to setup, and make sure that the first boot option is `Windows Boot Manager` and the OS Type is set to `UEFI`. You can also remove all other boot options that are not related to this. Check if OSX and Windows can both be booted through Clover, and work fine.

Enable TRIM on the SSD
----------------------

Open up a terminal, and type 

    sudo trimforce enable

Accept the changes, and the computer will restart

Enable HD4600 QE/CI
-------------------

Install [`FakePCIID.kext` and `FakePCIID_HD4600_HD4400.kext`](https://github.com/RehabMan/OS-X-Fake-PCI-ID) into Clover's kext folder. [Also use this `config.plist`](https://github.com/sztupy/Gigabyte-P34W-v3-OSX86/blob/master/Clover_Config/2-No_DSDT/config.plist) inside Clover, which, compared to the original `config.plist` contains the proper platform-id, fake intel ids and patches to fix the garbled screen.

If you can't see the EFI partition anymore you can mount it using a terminal the following way:

    mkdir /Volumes/efi
    sudo mount_msdos /dev/disk0s1 /Volumes/efi

Enable AppleHDA
---------------

[Download and install `AppleHDA-272.18.1-ALC282_v2.zip`](http://www.insanelymac.com/forum/topic/298663-applehda-for-yosemite/). Don't forget to fix permissions after this. The previous config.plist already includes the layout changes that need to be applied.

Note: in El Capitan to repair permissions you can use the following command from the command line:

    sudo /usr/libexec/repair_packages --repair --standard-pkgs /

Also [Download and install `CodecCommander`](https://github.com/RehabMan/EAPD-Codec-Commander), which will be used to make sure sound still works after the device has went to sleep. You might need to modify it's `Info.plist` to force reloading of the codec on ALC282 devices.

Touch pad fixes
---------------

If you're not using the `ApplePS2SmartTouchPad` from my repository, you should patch it's configs [with these files](https://github.com/sztupy/Gigabyte-P34W-v3-OSX86/tree/master/Kexts/Clover/Config). They will disable most of the functionality, and only keep the basics for a more consistent multi touch experience. They will also disable most of the keyboard magic, which is needed for the brightness keys to work (they will also require DSDT patches). At the end only these gestures will remain:

- Two finger multi touch scroll. Note that because of the driver's quirks this only works properly if your left finger's position is above your right finger's  position on the trackpad :(
- Three finger swipes: switch desktops left/right, application windows and mission control

Note that for two finger scroll to work, you have to first go to the Trackpad settings in System Prferences, and change the speed of scroll at least once. Once this is done two finger scroll should be enabled and working.

DSDT patches
------------

These patches will fix the following problems:

- General sleep / wake related issues
- Disabling Dedicated graphics so it won't use power
- Enabling ACPI Battery Manager
- Fixing backlight keyboard buttons

Restart the computer, go to setup, and enable both XHCI and 3D graphics:

- `Advanced` -> `3D Graphic Acceleration` -> `Enabled`
- `Advanced` -> `USB Configuration` -> `XHCI Mode` -> `Enabled`

If you are using BIOS version `FB05`, then you **MIGHT** be able to use [my pre patched, precompiled DSDT files](https://github.com/sztupy/Gigabyte-P34W-v3-OSX86/tree/master/DSDT_patched_FB05), just put the compiled files onto `EFI/Clover/ACPI/patched`. Also use this [dsdt patch `config.plist`](https://github.com/sztupy/Gigabyte-P34W-v3-OSX86/blob/master/Clover_Config/3-DSDT/config.plist) in clover, which has `DropSSDT` enabled compared to the previous ones.

If you have a different BIOS version, or the above files do not work for you, then you have to patch them manually. If you use the `config.plist` provided it should already have `nv_disable=1`, so your computer should boot up, but consume more power, as we have enabled the dedicated graphics card. We'll fix that soon. While you're still in Clover, press <kbd>F4</kbd>, so it will save your DSDT and SSDT files onto `EFI/Clover/ACPI/origin`. Mount the EFI partition again, and save the following files to your desktop:

- `DSDT.aml`
- `SSDT-0.aml`
- `SSDT-1.aml`
- `SSDT-7.aml`
- `SSDT-8.aml`
- `SSDT-9.aml`
- `SSDT-10.aml`

You should copy over SSDT-2 and SSDT-3 as well during decompilation, but then you'll won't need them again, as they are s CPU only. SSDT-4x,5x and 6x are loaded dynamically, and can be discarded.

Note: if you don't have SSDT-9 and SSDT-10, then you probably forgot to enable NVidia in the setup. Please enable it, restart the computer and try again. Patching DSDT/SSDT files will only work with the full set of files, which you only get when Dedicated graphics is enabled.

[Download iasl](https://bitbucket.org/RehabMan/acpica/downloads), move it to the desktop, and use it to decompile the provided files from the terminal:

    cd ~/Desktop
    ./iasl -da -dl *.aml

If everything goes okay you should get the `.dsl` files, which can be opened [in MaciASL](https://github.com/RehabMan/OS-X-MaciASL-patchmatic). Don't worry about the tons of error messages, most of the files have only slight issues with data after RETURN commands, which can be easily fixed.

Let's start with getting rid of the massive `Object does not exist (LNKF)`, `Object does not exist (LNKA)`, etc. messages. They are caused by a huge block of `Zero` fields. Check for the first error message, that says `unexpected PARSEOP_ZERO` instead of the `Object does not exist` one, and just remove the block of `Zero`s from that position.

Once this is done you should only have one error message, some value are there after a RETURN command. You can simply remove the offending line.

The SSDT files will mostly compile fine, they will only have stray `Arg0` and `Zero` commands after Returns, which can be removed without problems.

Once you have manually fixed the files, and they all compile fine, let's start patching them. We should start with the basics from RehabMan's [patch respository](https://github.com/RehabMan/Laptop-DSDT-Patch). You should go to MaciASL's properties settings and add them to the sources, so they can be easily applied to the files (check the readme on the previous link on how to do this).

You should also add my repository: `http://raw.github.com/sztupy/Gigabyte-P34W-v3-OSX86/master` as well which contains some additional patches.

You have to apply the following patches on the files.

     Patch name                         File to apply         Notes
     Remove _DSM Methods                DSDT, SSDT0,1,8,10    Does not apply cleanly on SSDT-1, you have to remove two additional lines manually
     Fix _WAK Arg0 v2                   DSDT
     HPET Fix                           DSDT
     SMBUS Fix                          DSDT
     IRQ Fix                            DSDT
     RTC Fix                            DSDT
     Fix operating system check         DSDT (,SSDT9)         (from my respository) Applying onto SSDT9 is optional
     Fix Mutex with non-zero SyncLevel  DSDT
     Fix PNOT/PPNT                      DSDT
     Add IMEI                           DSDT
     7-series/8-series USB              DSDT
     Rename GFX0 to IGPU                DSDT, SSDT8,9,10      (this doesn't work on FB05 BIOS completely, you have to rename some remaining GFX0 results to IGPU manually)
     Disable graphics in EC             DSDT                  (from my repository)
     Fix ACPI management                DSDT                  (from my repository)
     Enable brightness keys             DSDT                  (from my repository)
     Disable graphics in _INI           SSDT9                 (from my repository)


(the ones that say `from my repository` [can be obtained from here](https://github.com/sztupy/Gigabyte-P34W-v3-OSX86/tree/master/Patches), or preferably added to MaciASL's repositories using the link mentioned above)

Also if you have sleep issues (computer wakes up immediately after sleep), then you can try changing the first parameter in the `_PRW` methods from `0x0D` to `0x09` whenever it's not `0x09` already manually.

Once the patches have been applied, use `Save as` on all files, and Save them into `ACPI Machine Language Binary`, and copy them over to Clover's `EFI/Clover/ACPI/patched` directory. Don't forget to enable DropSSDT inside [`config.plist`](https://github.com/sztupy/Gigabyte-P34W-v3-OSX86/blob/master/Clover_Config/3-DSDT/config.plist), and restart the machine.

CPU SSDT
--------

Next step is making sure the CPU's SSDT is patched for a better power management. Download [`ssdtPRgen`](https://github.com/Piker-Alpha/ssdtPRGen.sh), and generate an SSDT for the i7-4720HQ based on the 4710HQ, with fixed frequency and turbo boost values:

    cd ~/Desktop
    mkdir ssdt
    curl -o ./ssdtPRGen.sh https://raw.githubusercontent.com/Piker-Alpha/ssdtPRGen.sh/master/ssdtPRGen.sh
    chmod +x ./ssdtPRGen.sh
    ./ssdtPRGen.sh  -p 'i7-4710HQ' -f 2600 -turbo 3600

Say no when asked to copy the SSDT. It will be put into `~/Library/ssdtPRgen/SSDT.aml`. Alternatively you can try to use the generated SSDT inside the `DSDT_patched/CPU` folder.

For this to work, you should also modify `config.plist` to use this SSDT, and not generate P and C states on it's own. This [`config.plist`](https://github.com/sztupy/Gigabyte-P34W-v3-OSX86/blob/master/Clover_Config/4-CPU/config.plist) should do the job.

Disabling hibernation
---------------------

As hibernation does not work, it's best to disable it. The following commands should do the job:

    sudo pmset -a hibernatemode 0
    sudo rm /var/vm/sleepimage
    sudo mkdir /var/vm/sleepimage

BCM94352HMB
-----------

If you have installed a BCM94352HMB chip separately, then install the [`FakePCIID_BCM94352Z_as_BCM94360CS2.kext`](https://github.com/RehabMan/OS-X-Fake-PCI-ID) if you need Wifi, and the [`BcrmPatchRam2.kext`](https://github.com/RehabMan/OS-X-BrcmPatchRAM)
if you need BT functionality into the EFI kexts store, and restart your computer. This should give you basic Wifi (2.4Ghz) and BT4 functionality.

To enable 5Ghz and BT Handoff support you can use the this [`config.plist`](https://github.com/sztupy/Gigabyte-P34W-v3-OSX86/blob/master/Clover_Config/5-BCM-Wifi/config.plist). Note that this will set the country code of your wifi to `GB`. If you would like
to change this then you have to open this patch in XCode, go to `KernelAndKextPatches/KextsToPatch`, find the one which says `10.10-BCM94352-5GHz-GB` (should be Item 3), and modify a few numbers in the `Replace` section.

You have to modify the two numbers `47 42` in the middle of the replace section to one of the following (based on your country code):

    AE - 41 45 | AF - 41 46 | AR - 41 52 | AT - 41 54 | AU - 41 55 | AZ - 41 5A | BD - 42 44 | BE - 42 45 | BG - 42 47 | BN - 42 4E
    BR - 42 52 | BT - 42 54 | BY - 42 59 | CA - 43 41 | CH - 43 48 | CL - 43 4C | CN - 43 4E | CO - 43 4F | CR - 43 52 | CY - 43 59
    CZ - 43 5A | DE - 44 45 | DK - 44 4B | DO - 44 4F | EC - 45 43 | EE - 45 45 | EG - 45 47 | ES - 45 53 | FI - 46 49 | FR - 46 52
    GB - 47 42 | GR - 47 52 | GT - 47 54 | GU - 47 55 | HK - 48 4B | HN - 48 4E | HR - 48 52 | HU - 48 55 | ID - 49 44 | IE - 49 45
    IL - 49 4C | IN - 49 4E | IS - 49 53 | IT - 49 54 | JM - 4A 4D | JO - 4A 4F | JP - 4A 50 | KH - 4B 48 | KZ - 4B 5A | LA - 4C 41
    LI - 4C 49 | LK - 4C 4B | LT - 4C 54 | LU - 4C 55 | LV - 4C 56 | MA - 4D 41 | MM - 4D 4D | MN - 4D 4E | MO - 4D 4F | MT - 4D 54
    MV - 4D 56 | MX - 4D 58 | MY - 4D 59 | NI - 4E 49 | NL - 4E 4C | NO - 4E 4F | NP - 4E 50 | NZ - 4E 5A | PA - 50 41 | PE - 50 45
    PH - 50 48 | PK - 50 4B | PL - 50 4C | PR - 50 52 | PT - 50 54 | PY - 50 59 | RO - 52 4F | RS - 52 53 | RU - 52 55 | SA - 53 41
    SE - 53 45 | SG - 53 47 | SI - 53 49 | SK - 53 4B | SV - 53 56 | TH - 54 48 | TR - 54 52 | TT - 54 54 | TW - 54 57 | UA - 55 41
    US - 55 53 | UY - 55 59 | VE - 56 45 | VI - 56 49 | VN - 56 4E | ZA - 5A 41

So for example if you live in the USA (`US`) change `47 42` to `55 53`. If you live in France (`FR`), change it to `46 52`, etc. If you don't know the code for your country you can check [`ISO_3166-1` on Wikipedia](http://www.wikiwand.com/en/ISO_3166-1_alpha-2).
Note that not all country codes on the above list might be completely supported, if you experience issues it might be better to fall back to a supported version, like `US`.

You might also want to change the patch's `Name` from `-GB` into the country of your chosing, but that's optional.

USB 3.0
-------

By default all USB 2 ports work, but for USB 3 devices you can only use the top left one, the rest are not working. This is because the device has already set up 14 USB 2 ports internally, so only one is left for USB 3 connectivity. To fix this an injector kext is required that only enables the prots that are actually used in the devices, which are:

* HS01, HS02, HS09, HS10: The four external USB 2.0 ports (top left, bottom left, top right, bottom right)
* HS03: The internal port used by BCM94352HMB for Bluetooth functionality
* HS04: The internal port used by the webcam
* SSP1, SSP2, SSP5, SSP6: The four external USB 3.0 ports (top left, bottom left, top right, bottom right)

To enable SSP2-SSP6, you can simply put the [`USBXHCI-P34Wv3.kext`](https://github.com/sztupy/Gigabyte-P34W-v3-OSX86/blob/master/Kexts/Clover/USBXHCI-P34Wv3.kext.zip) into Clover's kext directory, and restart the computer.

Final words
-----------

While the functionality is okay, some things are still not working, and I'm looking into them:

- Only one USB 3 port works for now (the powered one, which is the left topmost one). This can probably be fixed with some portmapping config and DSDT patches.
- ELAN touchpad driver has some quirks with two finger scrolling that is annoying. Also the driver is not open source, so fixing it won't be easy
- Brightness keys still generate characters while using them. Similarly to the touchpad driver, this is closed source, so no easy fix yet.
- SD Card reader doesn't work at all, and probably won't unless someone creates a driver from scratch.

I'll try working on these issues when I have the time. I'll hope you've found the guide useful.
