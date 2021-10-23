# WSA(Windows Subsystem for Android™️) GApps + Root 가이드

### 최소 요구 조건

- Windows 11 64bit (x86_64)<br>
- `제어판` -> `프로그램 및 기능` 에서`Windows 하이퍼바이저 플랫폼`, `가상 머신 플랫폼`, `Linux용 Windows 하위 시스템` 3가지 항목이 모두 활성화 되어있는 상태<br>
- BIOS 에서 가상화 기능이 켜져있는 상태<br>
- `WSL2`, `WSL2용 리눅스 배포판, Ubuntu 18.04 권장`
- WSL2 설치 방법은 구글에 검색해보세요.

### 사전 고지

- GApps 설치 부분 스크립트는 [ADeltaX](https://github.com/ADeltaX)의 [WSAGAScript](https://github.com/ADeltaX/WSAGAScript)를 참고하였습니다.
- Sideload 작업시 `%AppData%\SideloadedWSA` 폴더를 삭제한 후 재생성합니다. 해당 경로에 존재하는 파일을 지우므로 만약 해당 경로에 사용자의 파일이 있다면 백업을 하거나, 다른 경로로 이동해주세요.
- Sideload 작업 이후 `%AppData%\SideloadedWSA` 폴더를 삭제할 경우 `Windows Subsystem for Android™️`가 정상적으로 작동하지 않을 수 있습니다.
- ps1 파일을 `실행` 할때는 `우클릭을 한 뒤 Powershell에서 실행` 하는것을 기본으로 합니다.

## 0. 설치 준비

1. 이 Repository를 복제(`"git clone https://github.com/aroxu/wsa-root-gapps-guide.git" 명령어를 실행`) 하거나 [다운로드](https://github.com/aroxu/wsa-root-gapps-guide/archive/refs/heads/main.zip) 합니다.
   > 다운로드시 파일 이름을 `wsa-root-gapps-guide.zip` 으로 변경한 후 압축을 풀어주세요.

## 1. WSA 파일 준비

1. [https://store.rg-adguard.net](https://store.rg-adguard.net)에 접속한 후 `https://www.microsoft.com/store/productId/9P3395VX91NR` 를 링크 입력란에 붙여넣습니다.<br>
2. 링크 입력 란에 `https://www.microsoft.com/store/productId/9P3395VX91NR` 입력 후 SLOW 선택하고 `✔`를 클릭합니다.<br>
3. 파일 이름의 형태가 `MicrosoftCorporationII.WindowsSubsystemForAndroid`로 시작하고 끝이 `.msixbundle`로 끝나는 파일을 다운로드 합니다.<br>
4. 다운로드 받은 파일의 이름을 `wsa.msixbundle`로 변경합니다.<br>

## 2. 수정된 WSA Sideload

1.  설정 -> 업데이트 및 보안 -> 개발자 모드 스위치 눌러서 활성화 합니다.<br>
2.  `wsa.msixbundle` 파일을 압축프로그램으로 열거나, 파일의 확장자를 zip으로 변경합니다.<br>
3.  `wsa.msixbundle`파일 내부의 파일들 중에서 이름의 형태가 `WsaPackage_버전_Release-Nightly` 형태를 띄는 msix 파일을 현재 폴더에 복사 하거나 압축 해제 합니다.<br>
4.  복사한 msix 파일의 이름을 `modified.zip`로 변경 후 압축 해제 합니다.<br>
5.  해제된 폴더 안의 `AppxMetadata` 폴더와 `AppxSignature.p7x`, `appxblockmap.xml`, `[content_types]` 파일들을 삭제합니다.<br>
6.  첨부된 `1. sideload.ps1`파일을 `modified` 폴더 안에 복사한 후 실행합니다.<br>

## 3. GApps 설치

> 여기서부터 WSL2가 필요합니다. 배포판은 상관 없지만, Ubuntu 18.04를 권장합니다.<br>
> WSL2 환경에서 작업해야 하는 항목에는 `🐧` 이모지가 붙습니다.<br>

1. [OpenGApps](https://opengapps.org/)에 접속하여 `x86_64`, `11.0`, `pico`를 순서대로 누른 후, ⬇️ (다운로드) 버튼을 눌러 GApps를 다운로드 합니다.<br>
2. WSA를 수정중인 폴더에 `#IMAGES`, `#GAPPS` 라는 이름을 가진 폴더 2개를 생성합니다. (#을 빼서는 안됩니다.)
3. 다운로드한 GApps를 `#GAPPS` 폴더에 복사합니다.
4. `Win + R` 키를 눌러 `explorer %AppData%\SideloadedWSA`를 입력한 후 `product.img`, `system.img`, `system_ext.img`, `vendor.img` 파일을 WSA를 수정중인 폴더 내의 `#IMAGES` 폴더로 복사합니다.
5. `2._install_gapps.sh` 파일을 notepad++ 또는 VSCode 등의 편집기를 이용하여 연 뒤, 아래와 같이 수정합니다:
   > ```bash
   > Root="/mnt/c/GAppsWSA"
   > # 위 항목을 WSA를 수정중인 경로로 변경
   > # 예: `C:\Users\user\Desktop\wsa-root-gapps-guide` 일 경우:
   > Root="/mnt/c/Users/user/Desktop/wsa-root-gapps-guide"
   > ```
6. 🐧 설치된 WSL2 배포판을 켠 뒤, `sudo -i` 명령어를 입력하여 root 사용자 모드로 진입합니다.<br>
7. 🐧 다음 명령어를 입력합니다:
   > ```bash
   > apt update -y && apt upgrade -y && apt-get update -y && apt-get upgrade -y && apt-get install -y unzip lzip wget
   > ```
8. 🐧 WSL2 에서 WSA를 수정중인 경로로 이동합니다. 예: `C:\Users\user\Desktop\wsa-root-gapps-guide` 일 경우:
   > ```bash
   > cd /mnt/c/Users/user/Desktop/wsa-root-gapps-guide
   > ```
9. 🐧 다음 명령어를 입력합니다:
   > ```bash
   > chmod a+x 2._install_gapps.sh && ./2._install_gapps.sh
   > ```
10. WSA를 수정중인 폴더 내의 `#IMAGES` 폴더 안에 있는 모든 항목을 `Win + R` 키를 눌러 `explorer %AppData%\SideloadedWSA`을 실행한 후 나오는 파일 탐색기에 붙여넣습니다.
11. adb를 준비합니다. ([https://dl.google.com/android/repository/platform-tools_r31.0.3-windows.zip](https://dl.google.com/android/repository/platform-tools_r31.0.3-windows.zip) 에서 받을 수 있습니다.)
12. `Windows Subsystem for Android™️`를 시작하고 `Developer Option`을 켠 뒤 맨 위의 `Files`를 눌러 실행합니다.
13. `platform-tools` 압축 파일의 압축을 해제 한 뒤, 해당 경로에서 Windows Terminal을 열어 `adb connect 172.0.0.1;adb shell` 명령어를 입력한 뒤 다음 명령어를 입력합니다:
    > ```shell
    > su
    > setenforce 0 && exit
    > ```
14. 시작메뉴에서 `Play 스토어`를 클릭하여 실행 한 뒤, 로그인을 합니다. 이 과정에서 오류가 발생할 수도 있으니, 앱을 껐다 켠 후 재로그인을 하면 됩니다.<br>

## 4. Root

1. adb를 이용하여 다음 명령어를 입력합니다:
   > ```shell
   > su
   > # 여기에 관리자 권한으로 실행할 명령어 입력
   > ```
