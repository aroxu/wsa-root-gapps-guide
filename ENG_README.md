# WSA(Windows Subsystem for Android™️) GApps + Root Guide

### Minimum Requirements

- Windows 11 64bit (x86_64)<br>
- `Control Panel` -> From `Programs and Features`, Check all three `Windows Hypervisor Platform`, `Virtual Machine Platform`, `Windows Subsystem for Linux` is all enabled<br>
- Virtualization enabled in BIOS<br>
- `WSL2`, `Linux Distribution for WSL, Ubuntu 18.04 is Recommended.`
- Please search Google for WSL Installations.

### Pre-notice

- GApps installation script part is referenced from [ADeltaX](https://github.com/ADeltaX)의 [WSAGAScript](https://github.com/ADeltaX/WSAGAScript).
- For modified kernel, I used and built [LSPosed/WSA-Kernel-SU](https://github.com/LSPosed/WSA-Kernel-SU/tree/kernel) which license is GPLv2.
- While working on Sideload, It regenerates `%AppData%\SideloadedWSA` folder. It deletes files which exists in the directory, so if there is a file in the directory, please backup or move it to another place.
- After working on Sideload, If you delete `%AppData%\SideloadedWSA` folder `Windows Subsystem for Android™️` will not work as intended.
- When `running` the ps1 file, `Right click and Run in PowerShell` is default.

## 0. Getting Ready for installation

1. Clone this Repository(`Run "git clone https://github.com/aroxu/wsa-root-gapps-guide.git"`), or [Download it](https://github.com/aroxu/wsa-root-gapps-guide/archive/refs/heads/main.zip).
   > If you downloaded this repository please change it's name to `wsa-root-gapps-guide.zip` and extract it.

## 1. Getting Ready for WSA File

1. Enter [https://store.rg-adguard.net](https://store.rg-adguard.net), and paste `https://www.microsoft.com/store/productId/9P3395VX91NR` into link input line.<br>
2. On Link input, enter `https://www.microsoft.com/store/productId/9P3395VX91NR`, select SLOW option, and press `✔`.<br>
3. Download the file which starts with `MicrosoftCorporationII.WindowsSubsystemForAndroid` and ends with `.msixbundle`.<br>
4. Change the downloaded file name into `wsa.msixbundle`.<br>

## 2. Modified WSA Sideload

1.  Settings → Updates & Security → Enable Developer Mode.<br>
2.  Open `wsa.msixbundle` with your archive manager, or change the extension to `.zip`.<br>
3.  Copy or decompress the msix file which name is `WsaPackage_<version>_Release-Nightly` among the files inside the `wsa.msixbundle` file to the current folder.<br>
4.  Changed the copied msix file name to `modified.zip` and decompress it.<br>
5.  Remove files and folder which is `AppxMetadata` folder, `AppxSignature.p7x`, `appxblockmap.xml`, `[content_types]` in extracted contents.<br>
6.  Copy and execute `1. sideload.ps1` file in the `modified` folder which comes from clone source<br>

## 3. Install GApps

> From here you need WSL2. Any distribution is fine, But I recommend Ubuntu 18.04.<br>
> Items with WSL2 works comes with `🐧` emoji.<br>

1. Enter [OpenGApps](https://opengapps.org/) and press `x86_64`, `11.0`, `pico` in order, and click ⬇️ (Download) button to download GApps.<br>
2. On Modified WSA Folder, Create folders named `#IMAGES`, `#GAPPS`. (Do not remove #.) At this point, you should create it not in `modified`, but in root of the `modified` directory.
3. Copy GApps into`#GAPPS` folder which you have donwloaded. At this point you should not extract it.
4. Press `Win + R` and enter `explorer %AppData%\SideloadedWSA`, from there copy `product.img`, `system.img`, `system_ext.img`, `vendor.img` files into `#IMAGES` folder which is in your Modified WSA Directory.
5. Open `2._install_gapps.sh` as Notepad++ or VSCode, etc. and edit like this:
   > ```bash
   > Root="/mnt/c/GAppsWSA"
   > # Change the upper one into Modified WSA direcotry which you are working on.
   > # For Example: If the working Modified WSA directory is `C:\Users\user\Desktop\wsa-root-gapps-guide`:
   > Root="/mnt/c/Users/user/Desktop/wsa-root-gapps-guide"
   > ```
6. 🐧 Open WSA2 Distribution which is installed, and use `sudo -i` to enter root.<br>
7. 🐧 Enter following command:
   > ```bash
   > apt update -y && apt upgrade -y && apt-get update -y && apt-get upgrade -y && apt-get install -y unzip lzip wget
   > ```
8. 🐧 Move to the Modified WSA directory which you are working on. For Example: If the working Modified WSA directory is `C:\Users\user\Desktop\wsa-root-gapps-guide`:
   > ```bash
   > cd /mnt/c/Users/user/Desktop/wsa-root-gapps-guide
   > ```
9. 🐧 Enter following command:
   > ```bash
   > chmod a+x 2._install_gapps.sh && ./2._install_gapps.sh
   > ```
10. Copy all contents in `#IMAGES` which is in Modified WSA Folder. Press `Win + R`, enter `explorer %AppData%\SideloadedWSA`, and paste into it.
11. Prepare adb. (You can download it from here: [https://dl.google.com/android/repository/platform-tools_r31.0.3-windows.zip](https://dl.google.com/android/repository/platform-tools_r31.0.3-windows.zip))
12. Start `Windows Subsystem for Android™️`, enable `Developer Option`, and execute `Files` right at the top.
13. Extract `platform-tools`, and open Windows Terminal at current direcotyr and type `adb connect <WSA_IP_ADDRESS>`, `adb shell` in order and enter the following command:
    > ```shell
    > su
    > setenforce 0 && exit
    > ```
14. On Start Menu click `Play store`, and Log In. There may be error happening, at then relaunch the program and relogin.<br>

## 4. Root

1. Run adb and enter the following command:
   > ```shell
   > su
   > # Enter the command which you want to run as root.
   > ```

## Frequently happening Errors

- Powershell script does not run / it cannot be run. What should I do?
  > It related with Execution Policy problem with PowerShell. You can allow ps1 scrips for a moment with this following command:
  >
  > ```ps1
  > Set-ExecutionPolicy Unrestricted
  > # For your security, do all the tasks you have to do and change it back when it's done.
  > Set-ExecutionPolicy RemoteSigned
  > ```
