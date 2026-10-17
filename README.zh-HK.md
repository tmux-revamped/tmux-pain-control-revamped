<div align="center">

# tmux-pain-control-revamped

<strong>tmux 的窗格和視窗管理按鍵，配合 tmux 版本，與 vim 相容，每個 prefix 按鍵都可停用。</strong>

[English](README.md) | [日本語](README.ja.md) | [简体中文](README.zh-Hans.md) | 繁體中文（香港）

[![Tests](https://github.com/tmux-revamped/tmux-pain-control-revamped/actions/workflows/tests.yml/badge.svg)](https://github.com/tmux-revamped/tmux-pain-control-revamped/actions/workflows/tests.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Version](https://img.shields.io/badge/version-2.0.0-blue.svg)](CHANGELOG.md)

<p align="center">
  <a href="#what-it-does">功能</a> |
  <a href="#installation">安裝</a> |
  <a href="#usage">用法</a> |
  <a href="#configuration">設定</a> |
  <a href="#key-bindings">按鍵綁定</a> |
  <a href="#how-it-works">運作原理</a>
</p>

</div>

預設綁定 **27** 個 prefix 按鍵，另有 **12** 個可選按鍵，**28** 個選項，支援 tmux **3.2** 或以上版本。

---

<a id="what-it-does"></a>

## 功能

本插件綁定窗格導覽、調整大小、保留目前目錄的分割，以及窗格和視窗的移動。它是 [tmux-pain-control](https://github.com/tmux-plugins/tmux-pain-control) 的重寫版本，加入了更多操作，並刻意取代 tmux 本身的部分按鍵。

| 功能 | 選項 |
|:-----|:-----|
| 分割和新視窗在目前窗格的目錄中開啟，包括 `"` 和 `%` | `c` 由 `@new_window_path` 控制 |
| 按設定的儲存格數目調整大小 | `@pane_resize` |
| 沿窗格較長的一邊分割 | `@pane_control_smart_split_key` |
| 合併、拆出、交換、提升和標記窗格 | `@pane_control_join_key` 等窗格按鍵 |
| 毋須 prefix 的 `Ctrl+h/j/k/l` 在 vim 分割畫面和 tmux 窗格之間移動 | `@pane_control_vim_navigation` |
| 窗格選擇在視窗邊緣停止 | `@pane_control_no_wrap` |
| 關閉清單中的任何按鍵 | `@pane_control_disabled_keys` |

<a id="requirements"></a>

## 系統要求

| 要求 | 版本 |
|:-----|:-----|
| tmux | 3.2 或以上 |
| bash | 3.2 或以上 |

可在 Linux 和 macOS 上執行，支援 BSD、GNU 或 uutils coreutils。智能 vim 導覽使用 `ps` 和 `grep` 偵測窗格中的 vim。

<a id="installation"></a>

## 安裝

使用 [TPM](https://github.com/tmux-plugins/tpm) 時，將插件加入 `~/.tmux.conf`，然後按 `prefix + I`：

```tmux
set -g @plugin 'tmux-revamped/tmux-pain-control-revamped'
```

手動安裝時，複製儲存庫，並在 `~/.tmux.conf` 中執行入口腳本：

```bash
git clone https://github.com/tmux-revamped/tmux-pain-control-revamped ~/.tmux/plugins/tmux-pain-control-revamped
```

```tmux
run-shell ~/.tmux/plugins/tmux-pain-control-revamped/pain-control-revamped.tmux
```

<a id="usage"></a>

## 用法

安裝後，[按鍵綁定](#key-bindings)中的按鍵在 prefix 之後生效。`prefix + |` 向右分割，`prefix + -` 向下分割，兩者都使用目前目錄。`prefix + h/j/k/l` 在窗格之間移動，`prefix + H/J/K/L` 調整窗格大小。

開啟你需要的可選操作，並關閉你在其他地方要用的按鍵：

```tmux
set -g @pane_control_sync_key 'S'
set -g @pane_control_swap_window_left_key '<'
set -g @pane_control_swap_window_right_key '>'
set -g @pane_control_scratch_key 'g'
set -g @pane_control_scratch_command 'htop'

set -g @pane_control_disabled_keys 'c, *'
set -g @pane_resize 10
```

取代 [vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator) 的 tmux 部分：

```tmux
set -g @pane_control_vim_navigation 'on'
```

之後，vim 取得焦點時 `Ctrl+h/j/k/l` 移動 vim 分割畫面，否則移動 tmux 窗格，`Ctrl+\` 回到上一個窗格。由於這會佔用毋須 prefix 的 `Ctrl+l`，`prefix + C-l` 改為傳送清除畫面。vim 一方仍須在編輯器中安裝 vim-tmux-navigator 插件。

<a id="configuration"></a>

## 設定

| 選項 | 預設值 | 意思 |
|:-----|:-------|:-----|
| `@pane_resize` | `5` | 每次按調整大小鍵移動的儲存格數目 |
| `@new_window_path` | `true` | 為 `true`、`on` 或 `1` 時，`c` 在目前目錄開啟新視窗；其他值不改動 `c` |
| `@pane_control_disabled_keys` | 空 | 不綁定的按鍵，以空格或逗號分隔，例如 `c, <` |
| `@pane_control_no_wrap` | `off` | 設為 `on` 時，`h/j/k/l` 選擇在視窗邊緣停止，而不是繞到另一邊 |
| `@pane_control_pane_titles` | `off` | 設為 `on` 時，在窗格上邊框顯示窗格編號和標題 |
| `@pane_control_vim_navigation` | `off` | 設為 `on` 時，綁定帶 vim 偵測、毋須 prefix 的 `Ctrl+h/j/k/l` 和 `Ctrl+\` |
| `@pane_control_vim_pattern` | vim-tmux-navigator 的模式 | 判斷窗格正在執行 vim 的程序名稱正規表示式 |
| `@pane_control_scratch_command` | 空 | 臨時彈出視窗執行的指令；空白時開啟 shell |
| `@pane_control_smart_split_key` | `*` | 智能分割 |
| `@pane_control_join_key` | `@` | 提示後從另一個視窗合併窗格 |
| `@pane_control_break_key` | `!` | 將目前窗格拆成獨立視窗 |
| `@pane_control_swap_prev_key` | `{` | 與上一個窗格交換 |
| `@pane_control_swap_next_key` | `}` | 與下一個窗格交換 |
| `@pane_control_promote_key` | `+` | 將窗格交換到左上位置 |
| `@pane_control_mark_key` | `m` | 標記窗格 |
| `@pane_control_swap_mark_key` | `=` | 與已標記的窗格交換 |
| `@pane_control_sync_key` | 空 | 切換 `synchronize-panes` 並顯示其狀態 |
| `@pane_control_swap_window_left_key` | 空 | 將視窗向左移一位 |
| `@pane_control_swap_window_right_key` | 空 | 將視窗向右移一位 |
| `@pane_control_move_window_key` | 空 | 提示後將視窗移到另一個工作階段 |
| `@pane_control_kill_window_key` | 空 | 確認後關閉視窗 |
| `@pane_control_layout_even_h_key` | 空 | `even-horizontal` 版面配置 |
| `@pane_control_layout_even_v_key` | 空 | `even-vertical` 版面配置 |
| `@pane_control_layout_main_v_key` | 空 | `main-vertical` 版面配置 |
| `@pane_control_respawn_key` | 空 | 確認後重新啟動窗格 |
| `@pane_control_capture_key` | 空 | 提示（預設 `~/tmux-scrollback.log`）後將整個捲動緩衝區儲存到檔案 |
| `@pane_control_pane_name_key` | 空 | 提示後設定窗格標題 |
| `@pane_control_scratch_key` | 空 | 在目前目錄開啟佔 80% 的彈出 shell |

按鍵選項設為空值時不會綁定任何按鍵。本插件沒有內部狀態選項。

<a id="key-bindings"></a>

## 按鍵綁定

### 預設綁定

以下按鍵都在 prefix 之後按。導覽、調整大小、分割和 `c` 的按鍵不能更改，只能用 `@pane_control_disabled_keys` 關閉。

| 按鍵 | 動作 | 可連按 |
|:-----|:-----|:------:|
| `h` `j` `k` `l`、`C-h` `C-j` `C-k` `C-l` | 選擇左、下、上、右面的窗格 | 否 |
| `H` `J` `K` `L` | 按 `@pane_resize` 個儲存格調整窗格大小 | 是 |
| `\|` 和 `%` | 在目前目錄向右分割 | 否 |
| `-` 和 `"` | 在目前目錄向下分割 | 否 |
| `\` | 按整個視窗闊度分割 | 否 |
| `_` | 按整個視窗高度分割 | 否 |
| `*` | 沿較長的一邊分割 | 否 |
| `c` | 在目前目錄開新視窗 | 否 |
| `@` | 從另一個視窗合併窗格 | 否 |
| `!` | 將窗格拆成獨立視窗 | 否 |
| `{` `}` | 與上一個或下一個窗格交換 | 是 |
| `+` | 將窗格提升到左上位置 | 否 |
| `m` | 標記窗格 | 否 |
| `=` | 與已標記的窗格交換 | 否 |

`pain-control` 是 tmux-revamped 插件家族中聲明的覆寫者，所以這些按鍵按設計取代 tmux 的預設綁定。

### 可選按鍵

2.0.0 版取消了這些綁定。將選項設為原來的按鍵即可還原：

| 選項 | 原按鍵 | 動作 |
|:-----|:------:|:-----|
| `@pane_control_sync_key` | `S` | 切換窗格同步輸入 |
| `@pane_control_swap_window_left_key` | `<` | 視窗向左移 |
| `@pane_control_swap_window_right_key` | `>` | 視窗向右移 |
| `@pane_control_move_window_key` | `.` | 將視窗移到另一個工作階段 |
| `@pane_control_kill_window_key` | `&` | 關閉視窗 |
| `@pane_control_layout_even_h_key` | `E` | `even-horizontal` 版面配置 |
| `@pane_control_layout_even_v_key` | `V` | `even-vertical` 版面配置 |
| `@pane_control_layout_main_v_key` | `B` | `main-vertical` 版面配置 |
| `@pane_control_respawn_key` | `R` | 重新啟動窗格 |
| `@pane_control_capture_key` | `C` | 儲存捲動緩衝區 |
| `@pane_control_pane_name_key` | `P` | 為窗格命名 |
| `@pane_control_scratch_key` | `g` | 臨時彈出視窗 |

### 智能 vim 導覽

`@pane_control_vim_navigation` 設為 `on` 時，插件亦會在 root 表和 `copy-mode-vi` 中綁定 `C-h`、`C-j`、`C-k`、`C-l` 和 `C-\`，並將 `prefix + C-l` 改為清除畫面。`@pane_control_disabled_keys` 對這些按鍵不起作用。

<a id="how-it-works"></a>

## 運作原理

tmux 載入插件時，[`pain-control-revamped.tmux`](pain-control-revamped.tmux) 會執行一次 [`src/pain.sh`](src/pain.sh)。該腳本讀取選項和 tmux 版本，然後為每個按鍵執行 `bind-key`。之後沒有任何在背景執行的內容。

每個綁定都附有 `-N` 說明，所以 `prefix + ?` 會連同說明一併列出。在 tmux 3.2 以下版本中，腳本的版本檢查仍會略去該 tmux 不支援的功能：全闊和全高分割需要 2.3，標記需要 2.1，窗格命名和邊緣不環繞需要 2.6，使用 `{top-left}` 的提升需要 3.0，臨時彈出視窗需要 3.2。

開啟 vim 導覽後，每個組合鍵都會對窗格的 TTY 執行 `ps`，並以 `@pane_control_vim_pattern` 比對程序名稱。相符時按鍵傳送給 vim，否則由 tmux 選擇窗格。

版本和按鍵的輔助函數位於 [`src/lib/pain/pain.sh`](src/lib/pain/pain.sh)。設定 `PAIN_DRY_RUN` 後，腳本會列印每個 tmux 指令而不執行，測試套件就是用這方法檢查按鍵綁定。

<a id="development"></a>

## 開發

| 指令 | 作用 |
|:-----|:-----|
| `make test` | 執行 bats 測試套件 |
| `make lint` | 對所有 shell 檔案執行 shellcheck |
| `make coverage` | 在 Linux 上用 kcov 量度行覆蓋率，低於 95% 時失敗 |

變更紀錄見 [CHANGELOG.md](CHANGELOG.md)。

<a id="license"></a>

## 授權

[MIT](LICENSE)

<!-- family:begin -->

## tmux-revamped 插件家族

本插件是 tmux-revamped 插件家族的成員。每個成員都帶有 [`FAMILY.md`](FAMILY.md) 中的同一份約定、`family/` 下的同一套工具和同一個共用程式庫，並由校驗和清單確保逐位元組一致。這些成員可以一併安裝：任何成員都不會佔用其他成員使用的按鍵或 tmux 選項。

在一個成員中發現的缺陷，要在全部成員中排查後才算修正完成。這項責任寫在約定之中，而不是依靠記憶，`family/bin/sweep` 負責執行。

| 成員 | 功能 |
|---|---|
| [`tmux-autoreload-revamped`](https://github.com/tmux-revamped/tmux-autoreload-revamped) | 編輯並儲存 tmux 設定後，它會自動重新載入，毋須按鍵，也毋須指令 |
| [`tmux-battery-revamped`](https://github.com/tmux-revamped/tmux-battery-revamped) | 在 tmux 狀態列顯示電池狀態，從不阻塞狀態列繪製 |
| [`tmux-bluetooth-revamped`](https://github.com/tmux-revamped/tmux-bluetooth-revamped) | 在 tmux 狀態列顯示每部已連接的藍牙裝置及其電量，不阻塞繪製 |
| [`tmux-cpu-revamped`](https://github.com/tmux-revamped/tmux-cpu-revamped) | 在 tmux 狀態列顯示 CPU 負載、溫度及頻率，從不阻塞繪製 |
| [`tmux-disk-revamped`](https://github.com/tmux-revamped/tmux-disk-revamped) | 在 tmux 狀態列顯示磁碟用量，從不阻塞狀態列繪製 |
| [`tmux-extract-revamped`](https://github.com/tmux-revamped/tmux-extract-revamped) | 用 fzf 從畫面上揀選 URL、路徑、雜湊值或任何其他字詞，並輸入到游標位置，全部以純 shell 實現 |
| [`tmux-fzf-revamped`](https://github.com/tmux-revamped/tmux-fzf-revamped) | 在彈出視窗的 fzf 選擇器中切換、關閉、重新命名或建立 tmux 工作階段、視窗和窗格 |
| [`tmux-git-revamped`](https://github.com/tmux-revamped/tmux-git-revamped) | 在 tmux 狀態列顯示當前窗格的 git 分支、改動和託管平台數目，而不會阻塞顯示 |
| [`tmux-gpu-revamped`](https://github.com/tmux-revamped/tmux-gpu-revamped) | 在 tmux 狀態列顯示 NVIDIA、AMD、Intel 及 Apple GPU 的負載、溫度、時脈、功耗及記憶體 |
| [`tmux-kube-revamped`](https://github.com/tmux-revamped/tmux-kube-revamped) | 在 tmux 狀態列顯示目前的 Kubernetes 上下文及命名空間，毋須 kubectl，直接解析 kubeconfig |
| [`tmux-launcher-revamped`](https://github.com/tmux-revamped/tmux-launcher-revamped) | 在彈出視窗或新視窗中啟動任何 TUI 應用程式，從目前窗格的目錄開始，每個應用程式可設定一個按鍵 |
| [`tmux-logging-revamped`](https://github.com/tmux-revamped/tmux-logging-revamped) | 將任何窗格儲存到檔案：即時記錄、完整捲動緩衝區或一次性截圖 |
| [`tmux-music-revamped`](https://github.com/tmux-revamped/tmux-music-revamped) | 在 tmux 狀態列顯示正在播放的歌曲，從不阻塞狀態列的繪製 |
| [`tmux-network-revamped`](https://github.com/tmux-revamped/tmux-network-revamped) | 在 tmux 狀態列顯示網絡傳輸量，從不阻塞繪製 |
| [`tmux-pain-control-revamped`](https://github.com/tmux-revamped/tmux-pain-control-revamped) | **本插件**，tmux 的窗格和視窗管理按鍵，配合 tmux 版本，與 vim 相容，每個 prefix 按鍵都可停用 |
| [`tmux-persist-revamped`](https://github.com/tmux-revamped/tmux-persist-revamped) | 儲存 tmux 的所有工作階段、視窗及窗格，按計時器自動儲存，並在重新開機後全部還原 |
| [`tmux-plugin-template`](https://github.com/tmux-revamped/tmux-plugin-template) | tmux-revamped 插件的起點：共用程式庫、bats 測試框架、CI 和系列工具 |
| [`tmux-pomodoro-revamped`](https://github.com/tmux-revamped/tmux-pomodoro-revamped) | tmux 狀態列中的番茄鐘計時器，所有狀態都儲存在 tmux 選項中，不使用暫存檔 |
| [`tmux-ram-revamped`](https://github.com/tmux-revamped/tmux-ram-revamped) | 在 tmux 狀態列顯示記憶體、交換空間及記憶體壓力，在背景取樣，繪製從不等待 |
| [`tmux-reorder-revamped`](https://github.com/tmux-revamped/tmux-reorder-revamped) | 用滑鼠在 tmux 狀態列上拖動視窗標籤來移動該視窗 |
| [`tmux-scroll-revamped`](https://github.com/tmux-revamped/tmux-scroll-revamped) | 將滑鼠滾輪交給能自行捲動的應用程式，其他情況下進入 tmux 複製模式 |
| [`tmux-sensible-revamped`](https://github.com/tmux-revamped/tmux-sensible-revamped) | 按 tmux 版本和終端機區分的合理預設設定，不會改動你自己設定的選項 |
| [`tmux-tiling-revamped`](https://github.com/tmux-revamped/tmux-tiling-revamped) | tmux 的平鋪視窗管理：八種版面，包括 BSP dwindle 和 spiral，並支援復原版面 |
| [`tmux-time-revamped`](https://github.com/tmux-revamped/tmux-time-revamped) | 狀態列中的本地時鐘和世界時鐘，按一天中的時段著色，並提供倒數和夏令時間提示 |
| [`tmux-weather-revamped`](https://github.com/tmux-revamped/tmux-weather-revamped) | 在背景從 wttr.in 取得天氣並顯示在狀態列，狀態列毋須等待 |

### 檢查安裝

所有成員都在磁碟上時，一個指令即可報告它們之間的任何衝突：

```sh
family/bin/doctor --live
```

它讀取每個成員和正在運行的 tmux 伺服器，報告重複的按鍵、重複的狀態佔位符、不符合命名規則的選項，以及約定版本落後的成員。

<!-- family:end -->
