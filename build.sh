# sync rom
repo init --depth=1 --no-repo-verify -u https://github.com/Corvus-AOSP/android_manifest.git -b 12 -g default,-mips,-darwin,-notdefault
git clone https://github.com/zacky46/local_manifest --depth 1 -b corvus-12 .repo/local_manifests
repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j8

# build rom
source $CIRRUS_WORKING_DIR/config
timeStart

source build/envsetup.sh
export TZ=Asia/Jakarta
export WITH_GAPPS=true
export BUILD_USERNAME=zacky
export BUILD_HOSTNAME=android-build
lunch corvus_ginkgo-userdebug
mkfifo reading # Jangan di Hapus
tee "${BUILDLOG}" < reading & # Jangan di Hapus
build_message "Building Started" # Jangan di Hapus
progress & # Jangan di Hapus
make corvus -j8  > reading #& sleep 95m # Jangan di hapus text line (> reading)

retVal=$?
timeEnd
statusBuild
# end
