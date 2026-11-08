build: 
	git commit -a -m "build"
	git push

ADB := $(if $(DEVICE),adb -s $(DEVICE),adb)
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
	$(ADB) shell mkdir -p $(ANDROID_RIME)
	$(ADB) push $(ANDROID_FILES) $(ANDROID_RIME)/
	$(ADB) shell am broadcast -a com.osfans.trime.action.DEPLOY
	$(ADB) shell am force-stop com.osfans.trime
	$(ADB) shell am start -n com.osfans.trime/.ui.main.MainActivity
	@echo "已重启同文触发部署(3.3.13 无 deploy 广播接收器, 靠启动时配置比对新旧); 新版同文广播即可生效"
	@echo "多设备时指定: make android DEVICE=<adb serial>"

.PHONY: build android