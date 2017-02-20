source ./build/envsetup.sh
lunch $(cat  ./target_selected.log)
echo $TARGET_PRODUCT'-'$TARGET_BUILD_VARIANT > ./target_selected.log
