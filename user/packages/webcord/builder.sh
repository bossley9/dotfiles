#!/bin/sh

set -e
PATH="$coreutils/bin"

bin=$out/bin
exe=$bin/webcord

mkdir -p $bin

echo "#!/bin/sh" >> $exe
chmod +x $exe
echo "$appimage/bin/* --enable-features=UseOzonePlatform --ozone-platform=wayland" >> $exe
