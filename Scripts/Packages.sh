#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2026 VIKINGYFY

# =========================================================
# 安装和更新软件包
# =========================================================
UPDATE_PACKAGE() {
	local PKG_NAME="$1"
	local PKG_REPO="$2"
	local PKG_BRANCH="$3"
	local PKG_SPECIAL="$4"
	local PKG_LIST=("$PKG_NAME" $5)
	local REPO_NAME="${PKG_REPO#*/}"
	local REPO_PATH="./package/$REPO_NAME"

	echo " "
	echo "========================================================="
	echo "Install package: $PKG_NAME"
	echo "Repository: $PKG_REPO"
	echo "Branch: $PKG_BRANCH"
	echo "========================================================="

	# 删除本地可能存在的不同名称的软件包
	for NAME in "${PKG_LIST[@]}"; do
		[ -z "$NAME" ] && continue

		echo "Search directory: $NAME"

		local FOUND_DIRS
		FOUND_DIRS=$(find ./feeds/luci/ ./feeds/packages/ \
			-maxdepth 3 \
			-type d \
			-iname "*$NAME*" \
			2>/dev/null)

		if [ -n "$FOUND_DIRS" ]; then
			while IFS= read -r DIR; do
				[ -z "$DIR" ] && continue
				rm -rf "$DIR"
				echo "Delete directory: $DIR"
			done <<< "$FOUND_DIRS"
		else
			echo "Not found directory: $NAME"
		fi
	done

	# 如果目标目录已经存在，先删除
	rm -rf "$REPO_PATH"

	# 克隆 GitHub 仓库
	if ! git clone \
		--depth=1 \
		--single-branch \
		--branch "$PKG_BRANCH" \
		"https://github.com/$PKG_REPO.git" \
		"$REPO_PATH"; then

		echo "ERROR: Failed to clone $PKG_REPO"
		rm -rf "$REPO_PATH"
		return 1
	fi

	# 处理克隆的仓库
	if [[ "$PKG_SPECIAL" == "pkg" ]]; then

		find "$REPO_PATH"/*/ \
			-maxdepth 3 \
			-type d \
			-iname "*$PKG_NAME*" \
			-prune \
			-exec cp -rf {} ./package \;

		rm -rf "$REPO_PATH"

	else
		echo "Package repository kept at: $REPO_PATH"
	fi
}


# =========================================================
# 调用示例
# =========================================================

# UPDATE_PACKAGE "OpenAppFilter" "destan19/OpenAppFilter" "master" "" "custom_name1 custom_name2"

# 例如：
# UPDATE_PACKAGE "open-app-filter" \
# 	"destan19/OpenAppFilter" \
# 	"master" \
# 	"" \
# 	"luci-app-appfilter oaf"
#
# 这样会先删除原有的：
# open-app-filter
# luci-app-appfilter
# oaf
# 相关组件，避免重复包导致 coremark / package 冲突。


# =========================================================
# 主题
# =========================================================

UPDATE_PACKAGE "argon" \
	"sbwml/luci-theme-argon" \
	"openwrt-25.12"

UPDATE_PACKAGE "aurora" \
	"eamonxg/luci-theme-aurora" \
	"master"

UPDATE_PACKAGE "aurora-config" \
	"eamonxg/luci-app-aurora-config" \
	"master"

UPDATE_PACKAGE "kucat" \
	"sirpdboy/luci-theme-kucat" \
	"master"

UPDATE_PACKAGE "kucat-config" \
	"sirpdboy/luci-app-kucat-config" \
	"master"

UPDATE_PACKAGE "noobwrt" \
	"nooblk-98/luci-theme-noobwrt" \
	"master"

UPDATE_PACKAGE "shadcn" \
	"eamonxg/luci-theme-shadcn" \
	"main"

UPDATE_PACKAGE "theme-fluent" \
	"LazuliKao/luci-theme-fluent" \
	"main"


# =========================================================
# 科学 / 网络
# =========================================================

UPDATE_PACKAGE "momo" \
	"nikkinikki-org/OpenWrt-momo" \
	"main"

UPDATE_PACKAGE "nikki" \
	"nikkinikki-org/OpenWrt-nikki" \
	"main"

UPDATE_PACKAGE "openclash" \
	"vernesong/OpenClash" \
	"dev" \
	"pkg"

UPDATE_PACKAGE "passwall" \
	"Openwrt-Passwall/openwrt-passwall" \
	"main" \
	"pkg"

UPDATE_PACKAGE "passwall2" \
	"Openwrt-Passwall/openwrt-passwall2" \
	"main" \
	"pkg"


# =========================================================
# 系统 / 工具
# =========================================================

UPDATE_PACKAGE "diskmanager" \
	"4IceG/luci-app-mini-diskmanager" \
	"main"

UPDATE_PACKAGE "easytier" \
	"EasyTier/luci-app-easytier" \
	"main"

UPDATE_PACKAGE "qmodem" \
	"FUjr/QModem" \
	"main"

UPDATE_PACKAGE "viking" \
	"VIKINGYFY/packages" \
	"main" \
	"" \
	"axonhub gecoosac sing-box luci-app-homeproxy luci-app-timewol luci-app-wolplus luci-app-wolultra"

UPDATE_PACKAGE "vnt" \
	"lmq8267/luci-app-vnt" \
	"main"


# =========================================================
# 磁盘 / 下载 / 文件
# =========================================================

UPDATE_PACKAGE "diskman" \
	"sbwml/luci-app-diskman" \
	"main"

UPDATE_PACKAGE "mosdns" \
	"sbwml/luci-app-mosdns" \
	"v5" \
	"" \
	"v2dat"

# 修复 luci-app-mosdns 与 mosdns 的
# /etc/init.d/mosdns 文件冲突
find ./package/luci-app-mosdns \
	-type f \
	-name "Makefile" \
	-exec sed -i '/\/etc\/init\.d\/mosdns/d' {} +

UPDATE_PACKAGE "openlist2" \
	"sbwml/luci-app-openlist2" \
	"main"

UPDATE_PACKAGE "qbittorrent" \
	"sbwml/luci-app-qbittorrent" \
	"master" \
	"" \
	"qt6base qt6tools rblibtorrent"

UPDATE_PACKAGE "quickfile" \
	"sbwml/luci-app-quickfile" \
	"main"


# =========================================================
# sirpdboy
# =========================================================

UPDATE_PACKAGE "ddns-go" \
	"sirpdboy/luci-app-ddns-go" \
	"main"

UPDATE_PACKAGE "netspeedtest" \
	"sirpdboy/netspeedtest" \
	"main" \
	"" \
	"homebox ookla-speedtest"

UPDATE_PACKAGE "netwizard" \
	"sirpdboy/luci-app-netwizard" \
	"main"

UPDATE_PACKAGE "partexp" \
	"sirpdboy/luci-app-partexp" \
	"main"

UPDATE_PACKAGE "timecontrol" \
	"sirpdboy/luci-app-timecontrol" \
	"main"


# =========================================================
# NatMapT / Stuntman
# =========================================================

UPDATE_PACKAGE "natmapt" \
	"muink/openwrt-natmapt" \
	"master"

UPDATE_PACKAGE "stuntman" \
	"muink/openwrt-stuntman" \
	"master"

UPDATE_PACKAGE "luci-app-natmapt" \
	"muink/luci-app-natmapt" \
	"master"


# =========================================================
# 其他
# =========================================================

UPDATE_PACKAGE "airpi3000m" \
	"LianXia233/luci-app-airpi3000m-fancontrol" \
	"main"

UPDATE_PACKAGE "h5000m" \
	"LianXia233/luci-app-h5000m-netmode" \
	"main"

UPDATE_PACKAGE "qmodem-generic" \
	"LianXia233/luci-app-qmodem-generic" \
	"main"


# =========================================================
# 更新软件包版本
# =========================================================
UPDATE_VERSION() {
	local PKG_NAME="$1"
	local PKG_MARK="${2:-false}"

	local PKG_FILES
	PKG_FILES=$(find ./ ./feeds/packages/ \
		-maxdepth 3 \
		-type f \
		-wholename "*/$PKG_NAME/Makefile" \
		2>/dev/null)

	if [ -z "$PKG_FILES" ]; then
		echo "$PKG_NAME not found!"
		return 0
	fi

	echo
	echo "$PKG_NAME version update has started!"
	echo

	while IFS= read -r PKG_FILE; do

		[ -z "$PKG_FILE" ] && continue

		# 获取 GitHub 仓库
		local PKG_REPO
		PKG_REPO=$(grep -Po \
			'PKG_SOURCE_URL:=https://.*github.com/\K[^/]+/[^/]+(?=.*)' \
			"$PKG_FILE" \
			| head -n 1)

		if [ -z "$PKG_REPO" ]; then
			echo "$PKG_FILE: GitHub repository not found!"
			continue
		fi

		# 获取 GitHub Release 版本
		local PKG_TAG
		PKG_TAG=$(curl -fsSL \
			"https://api.github.com/repos/$PKG_REPO/releases" \
			| jq -r \
			"map(select(.prerelease == $PKG_MARK)) | first | .tag_name")

		if [ -z "$PKG_TAG" ] || [ "$PKG_TAG" = "null" ]; then
			echo "$PKG_FILE: Release version not found!"
			continue
		fi

		# 当前版本信息
		local OLD_VER
		local OLD_URL
		local OLD_FILE
		local OLD_HASH

		OLD_VER=$(grep -Po 'PKG_VERSION:=\K.*' "$PKG_FILE" | head -n 1)
		OLD_URL=$(grep -Po 'PKG_SOURCE_URL:=\K.*' "$PKG_FILE" | head -n 1)
		OLD_FILE=$(grep -Po 'PKG_SOURCE:=\K.*' "$PKG_FILE" | head -n 1)
		OLD_HASH=$(grep -Po 'PKG_HASH:=\K.*' "$PKG_FILE" | head -n 1)

		# 生成下载地址
		local PKG_URL

		if [[ "$OLD_URL" == *"releases"* ]]; then
			PKG_URL="${OLD_URL%/}/$OLD_FILE"
		else
			PKG_URL="${OLD_URL%/}"
		fi

		# Release Tag 转换为纯数字版本
		# 例如：
		# v1.2.3       -> 1.2.3
		# release-1.2.3 -> 1.2.3
		local NEW_VER
		NEW_VER=$(echo "$PKG_TAG" \
			| sed -E 's/[^0-9]+/./g; s/^\.|\.$//g')

		if [ -z "$NEW_VER" ]; then
			echo "$PKG_FILE: Invalid version: $PKG_TAG"
			continue
		fi

		# 替换版本变量
		local NEW_URL
		NEW_URL=$(echo "$PKG_URL" \
			| sed \
			-e "s/\$(PKG_VERSION)/$NEW_VER/g" \
			-e "s/\$(PKG_NAME)/$PKG_NAME/g")

		# 下载并计算 SHA256
		local NEW_HASH
		NEW_HASH=$(curl -fsSL "$NEW_URL" \
			| sha256sum \
			| cut -d ' ' -f 1)

		if [ -z "$NEW_HASH" ]; then
			echo "$PKG_FILE: Failed to calculate SHA256!"
			continue
		fi

		echo "Package : $PKG_NAME"
		echo "File    : $PKG_FILE"
		echo "Release : $PKG_TAG"
		echo "Old     : $OLD_VER"
		echo "New     : $NEW_VER"
		echo "Old Hash: $OLD_HASH"
		echo "New Hash: $NEW_HASH"

		# 比较版本并更新
		if [[ "$NEW_VER" =~ ^[0-9].* ]] \
			&& dpkg --compare-versions "$OLD_VER" lt "$NEW_VER"; then

			sed -i \
				"s/PKG_VERSION:=.*/PKG_VERSION:=$NEW_VER/g" \
				"$PKG_FILE"

			sed -i \
				"s/PKG_HASH:=.*/PKG_HASH:=$NEW_HASH/g" \
				"$PKG_FILE"

			echo "$PKG_FILE version has been updated!"

		else
			echo "$PKG_FILE version is already the latest!"
		fi

		echo

	done <<< "$PKG_FILES"
}


# =========================================================
# UPDATE_VERSION 使用示例
# =========================================================

# UPDATE_VERSION "软件包名"
# UPDATE_VERSION "sing-box"

# 测试版：
# UPDATE_VERSION "sing-box" "true"


# =========================================================
# 引入私有扩展脚本
# =========================================================

if [ -f "$GITHUB_WORKSPACE/Scripts/PRIVATE.sh" ]; then
	echo "Loading PRIVATE.sh..."
	source "$GITHUB_WORKSPACE/Scripts/PRIVATE.sh"
fi
