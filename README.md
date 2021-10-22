# WSA(Windows Subsystem for Android™️) Root + Google Play 가이드 [WIP]

### 최소 요구 조건

- Windows 11<br>
- `제어판` -> `프로그램 및 기능` 에서`Windows 하이퍼바이저 플랫폼`, `가상 머신 플랫폼` 두 항목이 모두 활성화 되어있는 상태<br>
- BIOS 에서 가상화 기능이 켜져있는 상태<br>

### 사전 고지

- Sideload 작업시 `%AppData%\SideloadedWSA` 폴더를 삭제한 후 재생성합니다. 해당 경로에 존재하는 파일을 지우므로 만약 해당 경로에 사용자의 파일이 있다면 백업을 하거나, 다른 경로로 이동해주세요.
- Sideload 작업 이후 `%AppData%\SideloadedWSA` 폴더를 삭제할 경우 `Windows Subsystem for Android™️`가 정상적으로 작동하지 않을 수 있습니다.
- ps1 파일을 `실행` 할때는 `우클릭을 한 뒤 Powershell에서 실행` 하는것을 기본으로 합니다.

## 1. WSA 설치

1. [https://store.rg-adguard.net](https://store.rg-adguard.net)에 접속한 후 `https://www.microsoft.com/store/productId/9P3395VX91NR` 를 링크 입력란에 첨부.<br>
2. 링크 입력 란에 `https://www.microsoft.com/store/productId/9P3395VX91NR` 입력 후 SLOW 선택하고 `✔` 클릭<br>
3. 파일 이름의 형태가 `MicrosoftCorporationII.WindowsSubsystemForAndroid`로 시작하고 끝이 `.msixbundle`로 끝나는 파일을 다운로드.<br>
4. 다운로드 받은 파일의 이름을 `wsa.msixbundle`로 변경<br>
5. 동봉된 `1. install wsa.ps1` 파일을 `wsa.msixbundle` 파일과 동일한 경로에 복사한 다음 실행<br>
6. (선택) 시작메뉴에서 `Windows Subsystem for Android™️`을 클릭하여 실행 한 뒤, `파일` 항목을 눌러서 정상적으로 켜지나 테스트<br>

## 2. 수정된 WSA Sideload

1.  설정 -> 업데이트 및 보안 -> 개발자 모드 스위치 눌러서 활성화<br>
2.  다운로드 받은 파일을 압축프로그램으로 열거나, 파일의 확장자를 zip으로 변경<br>
3.  파일 이름의 형태가 `WsaPackage_버전_Release-Nightly` 형태를 띄는 msix 파일 복사<br>
4.  복사한 msix 파일의 이름을 `modified.zip`로 변경 후 압축 해제<br>
5.  해제된 폴더 안의 `AppxMetadata` 폴더와 `AppxSignature.p7x` 파일 삭제<br>
6.  notepad++ 또는 VSCode 등의 편집기를 이용하여 `AppxManifest.xml`파일을 아래를 참고하여 수정<br>

    > ```xml
    > ...
    > <Identity Name="MicrosoftCorporationII.WindowsSubsystemForAndroid" Publisher="CN=Microsoft Corporation, O=Microsoft Corporation, L=Redmond, S=Washington, C=US" Version="1.7.32815.0" ProcessorArchitecture="x64" />
    > #위 항목을 아래와 같이 변경합니다:
    > <Identity Name="aroxu.SideloadedWindowsSubsystemForAndroid" Publisher="CN=aroxu" Version="1.7.32815.0" ProcessorArchitecture="x64" />
    >
    > ...
    >
    > <DisplayName>ms-resource:WsaDisplayName</DisplayName>
    > #위 항목을 아래와 같이 변경합니다:
    > <DisplayName>Windows Subsystem for Android™️ (Sideloaded)</DisplayName>
    >
    > ...
    >
    > <uap:VisualElements DisplayName="ms-resource:WsaDisplayName" Description="ms-resource:WsaDescription" BackgroundColor="transparent" Square150x150Logo="Images\MedTile.png" Square44x44Logo="Images\AppList.png" AppListEntry="none">
    > #위 항목을 아래와 같이 변경합니다:
    > <uap:VisualElements DisplayName="Windows Subsystem for Android™️ (Sideloaded)" Description="ms-resource:WsaDescription" BackgroundColor="transparent" Square150x150Logo="Images\MedTile.png" Square44x44Logo="Images\AppList.png" AppListEntry="none">
    >
    > ...
    >
    > <uap:VisualElements DisplayName="ms-resource:WsaDisplayName" Description="ms-resource:WsaSettingsDescription" Square150x150Logo="Images\MedTile.png" Square44x44Logo="Images\AppList.png" BackgroundColor="transparent">
    > #위 항목을 아래와 같이 변경합니다:
    > <uap:VisualElements DisplayName="Windows Subsystem for Android™️ (Sideloaded)" Description="ms-resource:WsaSettingsDescription" Square150x150Logo="Images\MedTile.png" Square44x44Logo="Images\AppList.png" BackgroundColor="transparent">
    >
    > ...
    >
    > <rescap:Capability Name="customInstallActions" />
    > <uap4:CustomCapability Name="Microsoft.classicAppInstaller_8wekyb3d8bbwe" />
    > # 위 항목을 삭제합니다.
    >
    > ...
    >
    > <desktop6:Extension Category="windows.customInstall">
    >   <desktop6:CustomInstall Folder="CustomInstall" desktop8:RunAsUser="true">
    >     <desktop6:RepairActions>
    >         <desktop6:RepairAction File="WsaSetup.exe" Name="Repair" Arguments="repair" />
    >     </desktop6:RepairActions>
    >     <desktop6:UninstallActions>
    >         <desktop6:UninstallAction File="WsaSetup.exe" Name="Uninstall" Arguments="uninstall" />
    >         </desktop6:UninstallActions>
    >     </desktop6:CustomInstall>
    > </desktop6:Extension>
    > # 위 항목을 삭제합니다.
    > ```

7.  첨부된 `2. sideload.ps1`파일을 `modified` 폴더 안에 복사한 후 실행<br>
    > 오류가 발생 하는 경우 `하위 시스템 리소스` 메뉴에서 `필요시`로 설정한 후, 디바이스를 다시시작 하세요.
    > <br>
8.  (선택) 시작메뉴에서 `Windows Subsystem for Android™️`을 클릭하여 실행 한 뒤, `파일` 항목을 눌러서 정상적으로 켜지나 테스트<br>

## 3. WSA Linux 커널 수정

1. [https://3rdpartysource.microsoft.com/downloads](https://3rdpartysource.microsoft.com/downloads)에 접속하여 `Windows%20Subsystem%for%Android` 검색후 URL 찾기
   > URL은 다음과 같은 형태로 생겼습니다: `https://3rdpartycodeprod.blob.core.windows.net/download/Windows%20Subsystem%20for%20Android%2FPreview%20Oct%202020%2FWSA-Linux-Kernel.zip?sv=2020-06-12&st=2021-10-22T14%3A30%3A21Z&se=2021-10-22T16%3A10%3A21Z&sr=` > <br>
2. [https://github.com/LSPosed/WSA-Kernel-SU](https://github.com/LSPosed/WSA-Kernel-SU)에서 WSA용 SU 파일을 다운로드<br>
3.
