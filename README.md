# WSA(Windows Subsystem for Android™️) GApps + Root 가이드

[English Translation](./ENG_README.md)

### 최소 요구 조건

- Windows 11 64bit (x86_64)<br>
- `제어판` -> `프로그램 및 기능`에서 `Windows 하이퍼바이저 플랫폼`, `가상 머신 플랫폼`, `Linux용 Windows 하위 시스템` 3가지 항목이 모두 활성화되어있는 상태<br>
- BIOS 에서 가상화 기능이 켜져 있는 상태<br>
- `WSL2`, `WSL2용 리눅스 배포판, Ubuntu 18.04 권장`
- WSL2 설치 방법은 구글에 검색해 보세요.

### 사전 고지

- GApps 설치 부분 스크립트는 [ADeltaX](https://github.com/ADeltaX)의 [WSAGAScript](https://github.com/ADeltaX/WSAGAScript)를 참고하였습니다.
- 수정된 커널 이미지는 GPLv2 라이센스를 사용하는 [LSPosed/WSA-Kernel-SU](https://github.com/LSPosed/WSA-Kernel-SU/tree/kernel)를 사용하여 빌드하였습니다.
- Sideload 작업 시, `%AppData%\SideloadedWSA` 폴더를 삭제한 후 재생성합니다. 해당 경로에 존재하는 파일을 지우므로 만약 해당 경로에 사용자의 파일이 있다면 백업을 하거나, 다른 경로로 이동해주세요.
- Sideload 작업 이후 `%AppData%\SideloadedWSA` 폴더를 삭제할 경우 `Windows Subsystem for Android™️`가 정상적으로 작동하지 않을 수 있습니다.
- ps1 파일을 `실행`할 때는 `우클릭을 한 뒤 Powershell에서 실행` 하는 것을 기본으로 합니다.

## 0. 설치 준비

1. 이 Repository를 복제(`"git clone https://github.com/aroxu/wsa-root-gapps-guide.git" 명령어를 실행`)하거나, [다운로드](https://github.com/aroxu/wsa-root-gapps-guide/archive/refs/heads/main.zip)합니다.
   > 다운로드 시 파일 이름을 `wsa-root-gapps-guide.zip`으로 변경한 후 압축을 풀어 주세요.

## 1. WSA 파일 준비

1. [https://store.rg-adguard.net](https://store.rg-adguard.net)에 접속한 후, `https://www.microsoft.com/store/productId/9P3395VX91NR`를 링크 입력란에 붙여 넣습니다.<br>
2. 링크 입력란에 `https://www.microsoft.com/store/productId/9P3395VX91NR` 입력 후 SLOW 선택하고, `✔`를 클릭합니다.<br>
3. 파일 이름의 형태가 `MicrosoftCorporationII.WindowsSubsystemForAndroid`로 시작하고 끝이 `.msixbundle`로 끝나는 파일을 다운로드합니다.<br>
4. 다운로드받은 파일의 이름을 `wsa.msixbundle`로 변경합니다.<br>

## 2. 수정된 WSA Sideload

1.  설정 → 업데이트 및 보안 → 개발자 모드 스위치 눌러서 활성화합니다.<br>
2.  `wsa.msixbundle` 파일을 압축 프로그램으로 열거나, 파일의 확장자를 zip으로 변경합니다.<br>
3.  `wsa.msixbundle` 파일 내부의 파일 중에서 이름의 형태가 `WsaPackage_버전_Release-Nightly` 형태를 띄는 msix 파일을 현재 폴더에 복사하거나 압축 해제합니다.<br>
4.  복사한 msix 파일의 이름을 `modified.zip`으로 변경 후 압축 해제합니다.<br>
5.  해제된 폴더 안의 `AppxMetadata` 폴더와 `[content_types].xml`, `appxblockmap.xml`, `AppxSignature.p7x` 파일들을 삭제합니다.<br>
6.  첨부된 `1. sideload.ps1` 파일을 `modified` 폴더 안에 복사한 후 실행합니다.<br>

## 3. GApps 설치

> 여기서부터 WSL2가 필요합니다. 배포판은 상관없지만, Ubuntu 18.04를 권장합니다.<br>
> WSL2 환경에서 작업해야 하는 항목에는 `🐧` 이모지가 붙습니다.<br>

1. [OpenGApps](https://opengapps.org/)에 접속하여 `x86_64`, `11.0`, `pico`를 순서대로 누른 후, ⬇️ (다운로드) 버튼을 눌러 GApps를 다운로드합니다.<br>
2. WSA를 수정 중인 폴더에 `#IMAGES`, `#GAPPS`라는 이름을 가진 폴더 2개를 생성합니다. (#을 빼서는 안 됩니다) 이때, `modified` 폴더가 아닌, `modified` 폴더의 상위 폴더에 생성해야 함을 유의하세요.
3. 다운로드한 GApps를 `#GAPPS` 폴더에 복사합니다. 이때 압축 파일 그대로 복사해야 합니다.
4. `Win + R` 키를 눌러 `explorer %AppData%\SideloadedWSA`를 입력한 후, `product.img`, `system.img`, `system_ext.img`, `vendor.img` 파일을 WSA를 수정 중인 폴더 내의 `#IMAGES` 폴더로 복사합니다.
5. `2._install_gapps.sh` 파일을 notepad++ 또는 VSCode 등의 편집기를 이용하여 연 뒤, 아래와 같이 수정합니다:
   > ```bash
   > Root="/mnt/c/GAppsWSA"
   > # 위 항목을 WSA를 수정 중인 경로로 변경
   > # 예: `C:\Users\user\Desktop\wsa-root-gapps-guide`일 경우:
   > Root="/mnt/c/Users/user/Desktop/wsa-root-gapps-guide"
   > ```
6. 🐧 설치된 WSL2 배포판을 켠 뒤, `sudo -i` 명령어를 입력하여 root 사용자 모드로 진입합니다.<br>
7. 🐧 다음 명령어를 입력합니다:
   > ```bash
   > apt update -y && apt upgrade -y && apt-get update -y && apt-get upgrade -y && apt-get install -y unzip lzip wget
   > ```
8. 🐧 WSL2 에서 WSA를 수정 중인 경로로 이동합니다. 예: `C:\Users\user\Desktop\wsa-root-gapps-guide`일 경우:
   > ```bash
   > cd /mnt/c/Users/user/Desktop/wsa-root-gapps-guide
   > ```
9. 🐧 다음 명령어를 입력합니다:
   > ```bash
   > chmod a+x 2._install_gapps.sh && ./2._install_gapps.sh
   > ```
   이때, `/bin/sh^M: bad interpreter: No such file or directory` 오류가 발생하는 경우에는 `vim`을 이용해 수정합니다:
   >```bash
   > vi 2._install_gapps.sh
   > :set fileformat=unix
   > :wq
   >```
10. WSA를 수정 중인 폴더 내의 `#IMAGES` 폴더 안에 있는 모든 항목을 `Win + R` 키를 눌러 `explorer %AppData%\SideloadedWSA`을 실행한 후 나오는 파일 탐색기에 붙여 넣습니다.
11. adb를 준비합니다. ([https://dl.google.com/android/repository/platform-tools_r31.0.3-windows.zip](https://dl.google.com/android/repository/platform-tools_r31.0.3-windows.zip)에서 받을 수 있습니다.)
12. `Windows Subsystem for Android™️`를 시작하고 `Developer Option`을 켠 뒤, 맨 위의 `Files`를 눌러 실행합니다.
13. `platform-tools` 압축 파일의 압축을 해제한 뒤, 해당 경로에서 Windows Terminal을 열어 `adb connect WSA_IP_주소`, `adb shell` 명령어를 순서대로 입력한 뒤 다음 명령어를 입력합니다:
    > ```shell
    > su
    > setenforce 0 && exit
    > ```
14. 시작 메뉴에서 `Play 스토어`를 클릭하여 실행한 뒤, 로그인합니다. 이 과정에서 오류가 발생할 수도 있으니, 앱을 껐다 켠 후 재 로그인을 하면 됩니다.<br>

## 4. Root

1. adb를 이용하여 다음 명령어를 입력합니다:
   > ```shell
   > su
   > # 여기에 관리자 권한으로 실행할 명령어 입력
   > ```

## 자주 발생하는 오류

- Powershell 스크립트가 정상적으로 열리지 않거나, 실행할 수 없다고 뜹니다. 어떻게 해야 하나요?
  > Powershell의 Execution Policy와 관련된 문제입니다. 아래 명령어를 통해 잠시 동안 ps1 스크립트들을 허용할 수 있습니다.
  >
  > ```ps1
  > Set-ExecutionPolicy Unrestricted
  > # 보안을 위해 작업을 전부 다 한 후 반드시 아래 명령어를 입력하세요.
  > Set-ExecutionPolicy RemoteSigned
  > ```
