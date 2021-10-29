#!/bin/bash

# This script is from ADeltaX(https://github.com/ADeltaX)'s WSAGAScript(https://github.com/ADeltaX/WSAGAScript).
# Modify your variables here to corretly reference your directory and subdir

Root="/mnt/c/GAppsWSA"

MiscRoot="$Root/misc"

GAppsRoot="$Root/#GAPPS"
GAppsOutputFolder="$GAppsRoot/output"
GAppsExtractFolder="$GAppsRoot/extract"
GAppsTmpFolder="$GAppsRoot/tmp"

ImagesRoot="$Root/#IMAGES"
MountPointProduct="/mnt/product"
MountPointSystemExt="/mnt/system_ext"
MountPointSystem="/mnt/system"
MountPointVendor="/mnt/vendor"

InstallPartition="/mnt/system"
InstallDir="$InstallPartition/system"

rm -rf $GAppsOutputFolder
rm -rf $GAppsTmpFolder
rm -rf $GAppsExtractFolder

mkdir -p $GAppsOutputFolder
mkdir -p $GAppsTmpFolder
mkdir -p $GAppsExtractFolder

echo "Unzipping OpenGApps"
for file in "$GAppsRoot/"*.zip; do unzip -q "$file" -d $GAppsExtractFolder; done

echo "Extracting Core Google Apps"
for f in "$GAppsExtractFolder/Core/"*.lz; do tar --lzip -xvf "$f" -C $GAppsTmpFolder &>/dev/null; done

echo "Extracting Google Apps"
for f in "$GAppsExtractFolder/GApps/"*.lz; do tar --lzip -xvf "$f" -C $GAppsTmpFolder &>/dev/null; done

echo "Deleting duplicates & conflicting apps"
rm -rf "$GAppsTmpFolder/setupwizardtablet-x86_64" # We already have setupwizard "default"
rm -rf "$GAppsTmpFolder/packageinstallergoogle-all" # The image already has a package installer, and we are not allowed to have two.

echo "Merging folders"
for D in $GAppsTmpFolder/*; do [ -d "${D}" ] && cp -r ${D}/* $GAppsOutputFolder; done

echo "Merging subfolders"
for D in $GAppsOutputFolder/*; do [ -d "${D}" ] && cp -r ${D}/* $GAppsOutputFolder && rm -rf ${D}; done

echo "Post merge operation"
cp -r $GAppsOutputFolder/product/* $GAppsOutputFolder && rm -rf "$GAppsOutputFolder/product";

echo "Deleting temporary files"
rm -rf $GAppsTmpFolder
rm -rf $GAppsExtractFolder

echo "!! GApps folder ready !!"

echo "chk product.img"
e2fsck -f $ImagesRoot/product.img

echo "Resizing product.img"
resize2fs $ImagesRoot/product.img 240M

echo "chk system.img"
e2fsck -f $ImagesRoot/system.img

echo "Resizing system.img"
resize2fs $ImagesRoot/system.img 1280M

echo "chk system_ext.img"
e2fsck -f $ImagesRoot/system_ext.img

echo "Resizing system_ext.img"
resize2fs $ImagesRoot/system_ext.img 108M

echo "chk vendor.img"
e2fsck -f $ImagesRoot/vendor.img

echo "Resizing vendor.img"
resize2fs $ImagesRoot/vendor.img 300M

echo "Creating mount point for product"
mkdir -p $MountPointProduct

echo "Creating mount point for system_ext" 
mkdir -p $MountPointSystemExt

echo "Creating mount point for system"
mkdir -p $MountPointSystem

echo "Creating mount point for vendor"
mkdir -p $MountPointVendor

echo "Mounting product"
mount -o rw $ImagesRoot/product.img $MountPointProduct

echo "Mounting system_ext"
mount -o rw $ImagesRoot/system_ext.img $MountPointSystemExt

echo "Mounting system"
mount -o rw $ImagesRoot/system.img $MountPointSystem

echo "Mounting vendor"
mount -o rw $ImagesRoot/vendor.img $MountPointVendor

echo "!! Images mounted !!"

echo "Downloading misc"
rm -rf misc
mkdir misc
cd "$MiscRoot"
mkdir prop
cd "$MiscRoot/prop"
wget https://raw.githubusercontent.com/aroxu/WSAGAScript/main/misc/prop/x64/build_product.prop
wget https://raw.githubusercontent.com/aroxu/WSAGAScript/main/misc/prop/x64/build_system.prop
wget https://raw.githubusercontent.com/aroxu/WSAGAScript/main/misc/prop/x64/build_system_ext.prop
wget https://raw.githubusercontent.com/aroxu/WSAGAScript/main/misc/prop/x64/build_vendor.prop
wget https://raw.githubusercontent.com/aroxu/WSAGAScript/main/misc/prop/x64/build_vendor_odm.prop
cd "$Root"

echo "Copying build.prop for each image"
cp "$MiscRoot/prop/build_system_ext.prop" /mnt/system_ext/build.prop
cp "$MiscRoot/prop/build_system.prop" /mnt/system/build.prop
cp "$MiscRoot/prop/build_system.prop" /mnt/system/system/build.prop
cp "$MiscRoot/prop/build_product.prop" /mnt/product/build.prop
cp "$MiscRoot/prop/build_vendor.prop" /mnt/vendor/build.prop
cp "$MiscRoot/prop/build_vendor_odm.prop" /mnt/vendor/odm/etc/vendor.prop

echo "Copying GApps files to system..."
cp -f -a $GAppsOutputFolder/app/* $InstallDir/app
cp -f -a $GAppsOutputFolder/etc/* $InstallDir/etc
cp -f -a $GAppsOutputFolder/overlay/* $InstallDir/overlay
cp -f -a $GAppsOutputFolder/priv-app/* $InstallDir/priv-app
cp -f -a $GAppsOutputFolder/framework/* $InstallDir/framework

echo "Applying root file ownership"
find $InstallDir/app -exec chown root:root {} &>/dev/null \;
find $InstallDir/etc -exec chown root:root {} &>/dev/null \;
find $InstallDir/overlay -exec chown root:root {} &>/dev/null \;
find $InstallDir/priv-app -exec chown root:root {} &>/dev/null \;
find $InstallDir/framework -exec chown root:root {} &>/dev/null \;
find $InstallDir/lib -exec chown root:root {} &>/dev/null \;
find $InstallDir/lib64 -exec chown root:root {} &>/dev/null \;

echo "Setting directory permissions"
find $InstallDir/app -type d -exec chmod 755 {} \;
find $InstallDir/etc -type d -exec chmod 755 {} \;
find $InstallDir/overlay -type d -exec chmod 755 {} \;
find $InstallDir/priv-app -type d -exec chmod 755 {} \;
find $InstallDir/framework -type d -exec chmod 755 {} \;
find $InstallDir/lib -type d -exec chmod 755 {} \;
find $InstallDir/lib64 -type d -exec chmod 755 {} \;

echo "Setting file permissions"
find $InstallDir/app -type f -exec chmod 644 {} \;
find $InstallDir/overlay -type f -exec chmod 644 {} \;
find $InstallDir/priv-app -type f -exec chmod 644 {} \;
find $InstallDir/framework -type f -exec chmod 644 {} \;
find $InstallDir/lib -type f -exec chmod 644 {} \;
find $InstallDir/lib64 -type f -exec chmod 644 {} \;
find $InstallDir/etc/permissions -type f -exec chmod 644 {} \;
find $InstallDir/etc/default-permissions -type f -exec chmod 644 {} \;
find $InstallDir/etc/preferred-apps -type f -exec chmod 644 {} \;
find $InstallDir/etc/sysconfig -type f -exec chmod 644 {} \;

echo "Applying SELinux security contexts to directories"
find $InstallDir/app -type d -exec chcon --reference=$InstallDir/app {} \;
find $InstallDir/overlay -type d -exec chcon --reference=$InstallDir/overlay {} \;
find $InstallDir/priv-app -type d -exec chcon --reference=$InstallDir/priv-app {} \;
find $InstallDir/framework -type d -exec chcon --reference=$InstallDir/framework {} \;
find $InstallDir/lib -type d -exec chcon --reference=$InstallDir/lib {} \;
find $InstallDir/lib64 -type d -exec chcon --reference=$InstallDir/lib64 {} \;
find $InstallDir/etc/permissions -type d -exec chcon --reference=$InstallDir/etc/permissions {} \;
find $InstallDir/etc/default-permissions -type d -exec chcon --reference=$InstallDir/etc/permissions {} \;
find $InstallDir/etc/preferred-apps -type d -exec chcon --reference=$InstallDir/etc/permissions {} \;
find $InstallDir/etc/sysconfig -type d -exec chcon --reference=$InstallDir/etc/sysconfig {} \;

echo "Applying SELinux security contexts to files"
find $InstallDir/framework -type f -exec chcon --reference=$InstallDir/framework/ext.jar {} \;
find $InstallDir/overlay -type f -exec chcon --reference=$InstallDir/app/CertInstaller/CertInstaller.apk {} \;
find $InstallDir/app -type f -exec chcon --reference=$InstallDir/app/CertInstaller/CertInstaller.apk {} \;
find $InstallDir/priv-app -type f -exec chcon --reference=$InstallDir/priv-app/Shell/Shell.apk {} \;
find $InstallDir/lib -type f -exec chcon --reference=$InstallDir/lib/libcap.so {} \;
find $InstallDir/lib64 -type f -exec chcon --reference=$InstallDir/lib64/libcap.so {} \;
find $InstallDir/etc/permissions -type f -exec chcon --reference=$InstallDir/etc/fs_config_dirs {} \;
find $InstallDir/etc/default-permissions -type f -exec chcon --reference=$InstallDir/etc/fs_config_dirs {} \;
find $InstallDir/etc/preferred-apps -type f -exec chcon --reference=$InstallDir/etc/fs_config_dirs {} \;
find $InstallDir/etc/sysconfig -type f -exec chcon --reference=$InstallDir/etc/fs_config_dirs {} \;

echo "!! Apply completed !!"

echo "Unmounting product.img"
umount $MountPointProduct

echo "Unmounting system_ext.img"
umount $MountPointSystemExt

echo "Unmounting system.img"
umount $MountPointSystem

echo "Unmounting vendor.img"
umount $MountPointVendor

echo "!! Unmounting completed !!"
