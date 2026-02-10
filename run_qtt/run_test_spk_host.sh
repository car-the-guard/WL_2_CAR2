#!/bin/bash
# test_spk_host 전용 실행 스크립트 (sudoers NOPASSWD용)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
cd "$SCRIPT_DIR"
# Weston = topst → /run/user/1000 (현재 사용자로 실행 시 $(id -u)=1000)
export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
export WAYLAND_DISPLAY="${WAYLAND_DISPLAY:-wayland-0}"
# UID를 1000으로 강제 지정하여 Weston 소켓 경로 고정
export XDG_RUNTIME_DIR=/run/user/0
#export WAYLAND_DISPLAY=wayland-0

# [추가] ALSA 설정 파일 경로를 직접 지정 (권한 문제 방지)
#export ALSA_CONFIG_PATH=/etc/asound.conf
#export ALSA_CARD=1
#export QT_ALSA_DEVICE=hw:1

# [추가] GStreamer가 사용할 오디오 싱크 명시
#export GST_ALSA_DEFAULT_DEVICE=hw:1
# 스크립트 상단에 추가
export ALSA_CONFIG_PATH=/etc/asound.conf
export ALSA_CARD=1
# GStreamer가 ALSA 장치를 명확히 인식하도록 설정
export GST_ALSA_DEFAULT_DEVICE=plug:default

# /mnt/sdcard 경로를 읽기/쓰기(rw) 모드로 다시 마운트
sudo mount -o remount,rw /mnt/sdcard
export QT_QUICK_BACKEND=software  # Qt Quick에게 CPU 렌더링 강제
export QT_QPA_PLATFORM=wayland    # 화면 전송은 Wayland 사용

# EGL 0x3005 회피: SSH 세션에서 GPU 접근 불가 → 소프트웨어 렌더링 사용
export QT_OPENGL=software
export LIBGL_ALWAYS_SOFTWARE=1
exec env QT_QPA_FONTDIR=/usr/share/fonts/truetype QT_WAYLAND_DISABLE_WINDOWDECORATION=1 ./test_spk_host -platform wayland
