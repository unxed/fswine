#!/bin/bash

convert_wine_path_to_unix() {
    wine_path="$1"
    drive="${wine_path:0:1}"
    drive_lower=$(echo "$drive" | tr '[:upper:]' '[:lower:]')
    path="${wine_path:2}"
    unix_path="/home/unxed/.wine/drive_$drive_lower$path"
    unix_path="${unix_path//\\//}"
    echo "$unix_path"
}

# clear things
rm -f FSViewerSetup57.exe
rm -f CC32inst.exe

# get FastStone 5.7 and install it
wget -O FSViewerSetup57.exe "http://web.archive.org/web/20210211222841if_/http://www.faststonesoft.net/DN/FSViewerSetup57.exe"
wine ./FSViewerSetup57.exe /S

# get path to installed app
wine reg query "HKEY_LOCAL_MACHINE\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\App Paths\FSViewer.exe" > /tmp/fspath
fspath_win=$(LANG=en_US.UTF-8 wine reg query 'HKEY_LOCAL_MACHINE\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\App Paths\FSViewer.exe' | grep 'REG_SZ' |  sed 's/    (Default)    REG_SZ    //g')
fspath=$(convert_wine_path_to_unix "$fspath_win")
fspath=$(dirname "$fspath")

# get comctl32.dll
wget https://downloads.sourceforge.net/project/pocmin/Win%2095_98%20Controls/Win%2095_98%20Controls/CC32inst.exe
wine ./CC32inst.exe /T:C:\comctl32.tmp /C /Q
unzip ~/.wine/drive_c/comctl32.tmp/comctl32.tmp/comctl32.exe -d ~/.wine/drive_c/comctl32.tmp/comctl32.tmp
wine ~/.wine/drive_c/comctl32.tmp/comctl32.tmp/x86/50ComUpd.Exe /T:C:\comctl32.tmp.1 /C /Q

# copy to FastStone folder and rename
cp ~/.wine/drive_c/comctl32.tmp.1/comctl32.tmp.1/comcnt.dll "$fspath/comctr32.dll"

# patch FastStone binary
perl -i -pe 's/comctl32\.dll/comctr32\.dll/g' "$fspath/FSViewer.exe"

# switch system comctl32 to builtin as it is needed for FastStone to work properly
wine reg add 'HKEY_CURRENT_USER\Software\Wine\DllOverrides' /v comctl32 /t REG_SZ /d builtin /f
wine reg add 'HKEY_CURRENT_USER\Software\Wine\DllOverrides' /v *comctl32 /t REG_SZ /d builtin /f

# clear things
rm -rf "$fspath/../../comctl32.tmp"
rm -rf "$fspath/../../comctl32.tmp.1"
rm -f FSViewerSetup57.exe
rm -f CC32inst.exe
