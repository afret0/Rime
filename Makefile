build: 
	git commit -a -m "build"
	git push

ANDROID_RIME ?= /storage/emulated/0/Android/data/com.osfans.trime/files/rime
ANDROID_FILES := \
	default.custom.yaml \
	double_pinyin.schema.yaml \
	double_pinyin.custom.yaml \
	luna_pinyin_kk.dict.yaml \
	custom_phrase.txt \
	rime.lua \
	trime.custom.yaml

android:
	adb shell mkdir -p $(ANDROID_RIME)
	adb push $(ANDROID_FILES) $(ANDROID_RIME)/
	adb shell am broadcast -a com.osfans.trime.action.DEPLOY
	@echo "deploy 广播已发, 约 20s 生效; 键盘没变就在同文设置里手动点一次部署"

.PHONY: build android