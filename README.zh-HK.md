<div align="center">

# tmux-pain-control-revamped

<strong>tmux 的窗格和視窗管理按鍵，配合 tmux 版本，與 vim 相容，每個 prefix 按鍵都可停用。</strong>

[English](README.md) &nbsp;|&nbsp; [日本語](README.ja.md) &nbsp;|&nbsp; [简体中文](README.zh-Hans.md) &nbsp;|&nbsp; 繁體中文（香港）

[![ci](https://img.shields.io/github/actions/workflow/status/tmux-revamped/tmux-pain-control-revamped/ci.yml?branch=main&style=flat-square&label=ci)](https://github.com/tmux-revamped/tmux-pain-control-revamped/actions/workflows/ci.yml)
[![release](https://img.shields.io/github/v/release/tmux-revamped/tmux-pain-control-revamped?style=flat-square&label=release)](https://github.com/tmux-revamped/tmux-pain-control-revamped/releases/latest)
[![openssf scorecard](https://img.shields.io/ossf-scorecard/github.com/tmux-revamped/tmux-pain-control-revamped?style=flat-square&label=openssf%20scorecard)](https://scorecard.dev/viewer/?uri=github.com/tmux-revamped/tmux-pain-control-revamped)
[![license](https://img.shields.io/github/license/tmux-revamped/tmux-pain-control-revamped?style=flat-square&label=license)](LICENSE)

<p align="center">
  <a href="#快速開始"><strong>快速開始</strong></a> &nbsp;|&nbsp;
  <a href="#用法">用法</a> &nbsp;|&nbsp;
  <a href="#按鍵">按鍵</a> &nbsp;|&nbsp;
  <a href="#畫面">畫面</a>
</p>

</div>

<p align="center">
  <img src="screens/hero.gif" alt="以插件的按鍵分割、切換、調整大小和提升窗格的 tmux" width="800">
</p>

```console
$ pain-control-revamped list
bind-key -N Select pane left h select-pane -L
bind-key -N Select pane left C-h select-pane -L
bind-key -N Select pane below j select-pane -D
bind-key -N Select pane below C-j select-pane -D
```

每個按鍵都按 tmux 版本檢查，附有 `prefix ?` 顯示的說明，亦都可以不綁定。插件載入時，所有按鍵以一次呼叫交給 tmux，之後不會再執行任何東西。

---

## 快速開始

### 前提條件

| 工具 | 版本 | 用途 |
|:-----|:--------|:---------|
| tmux | 3.2 或以上 | 系列的最低版本；較舊的版本會少了它不支援的按鍵 |
| `ps` | 任何 | 開啟 vim 導覽時 |
| gum | 可選 | `pain-control-revamped` 的選單、表格和顏色；沒有它時每個指令都輸出純文字 |

### 安裝

```tmux
set -g @plugin 'tmux-revamped/tmux-pain-control-revamped'
```

然後按 `prefix + I`。不使用 TPM 時，複製儲存庫，並在 `~/.tmux.conf` 中執行它的入口腳本：

```bash
git clone https://github.com/tmux-revamped/tmux-pain-control-revamped ~/.tmux/plugins/tmux-pain-control-revamped
```

```tmux
run-shell ~/.tmux/plugins/tmux-pain-control-revamped/pain-control-revamped.tmux
```

在複製的目錄中執行 `make install`，亦會把 `pain-control-revamped` 放入 `~/.local/bin`，並把它的 man 手冊和自動完成放在 `~/.local/share` 下。

### 驗證

```bash
~/.tmux/plugins/tmux-pain-control-revamped/bin/pain-control-revamped doctor
```

## 用法

| 指令 | 作用 |
|:--------|:-------------|
| `pain-control-revamped apply` | 立即綁定所有按鍵；tmux 載入插件時入口腳本會執行它 |
| `pain-control-revamped list` | 列出 apply 會做的每個綁定；`--json` 輸出一個物件 |
| `pain-control-revamped zoom` | 把窗格移至它自己的視窗，在原位留下佔位窗格；在任何一處再次執行，就把窗格放回原位 |
| `pain-control-revamped doctor` | 每個依賴項目一行 |
| `pain-control-revamped version` | 版本，然後是 tmux 的版本 |
| `pain-control-revamped help` | 說明頁面。`man pain-control-revamped` 說明同樣的指令和設定 |
| `pain-control-revamped` | 在終端機中顯示選單 |

| tmux 選項 | 預設值 | 意思 |
|:------------|:--------|:--------|
| `@pain_control_revamped_resize` | `5` | 每次調整大小移動的格數 |
| `@pain_control_revamped_new_window_path` | `true` | `c` 在窗格所在的資料夾開啟新視窗 |
| `@pain_control_revamped_disabled_keys` | 無 | 不綁定的按鍵，以空格或逗號分隔 |
| `@pain_control_revamped_no_wrap` | `off` | `on` 令窗格切換停在視窗邊緣 |
| `@pain_control_revamped_vim_navigation` | `off` | `on` 不經 prefix 綁定 `C-h` 至 `C-l` 和 `C-\`，窗格中執行 vim 時，或窗格像 [smart-splits.nvim](https://github.com/mrjones2014/smart-splits.nvim) 那樣設定了 `@pane-is-vim` 選項時，把按鍵交給 vim |
| `@pain_control_revamped_vim_pattern` | vim、nvim、view、fzf | vim 導覽視為 vim 的程序名稱 |
| `@pain_control_revamped_pane_titles` | `off` | `on` 在邊框上顯示每個窗格的編號和標題 |
| `@pain_control_revamped_scratch_command` | 一個 shell | 暫存彈出視窗執行的內容 |
| `@pain_control_revamped_zoom_key` | 無 | 執行 `zoom` 的按鍵 |
| `@pain_control_revamped_focus_size` | 無 | 50 至 99 的整數：每次選擇或分割窗格後，取得焦點的窗格擴大至視窗闊度和高度的這個百分比。取消設定要待 tmux 伺服器重新啟動後才生效 |

下一節的每個按鍵亦有自己的選項，例如 `@pain_control_revamped_join_key`。每個選項亦是以連字號命名的指令選項，例如 `--join-key J`，以及一個環境變數，例如 `PAIN_CONTROL_REVAMPED_JOIN_KEY`；指令列優先於環境變數，環境變數優先於 tmux 選項。空的 tmux 選項代表預設值。

3.0.0 之前的選項名稱 `@pane_control_*`、`@pane_resize` 和 `@new_window_path` 已不再生效。

<a id="按鍵"></a>

## 按鍵

這些按鍵都在 prefix 之後按。pain-control 是 tmux-revamped 系列中宣告的覆寫者，因此它們按設計取代 tmux 內建的按鍵。

| 按鍵 | 作用 | 選項 |
|:----|:-------|:-------|
| `h` `j` `k` `l`、`C-h` `C-j` `C-k` `C-l` | 選擇左、下、上、右的窗格 | 無 |
| `H` `J` `K` `L` | 調整窗格大小，可重複 | 無 |
| `\|` 和 `%`、`-` 和 `"` | 在目前資料夾向右或向下分割 | 無 |
| `\` 和 `_` | 按視窗全寬或全高分割 | 無 |
| `*` | 沿較長的一邊分割 | `_smart_split_key` |
| `c` | 在目前資料夾開啟新視窗 | `_new_window_path` |
| `@` | 從另一個視窗合併窗格 | `_join_key` |
| `!` | 把窗格拆成獨立的視窗 | `_break_key` |
| `{` `}` | 與上一個或下一個窗格交換，可重複 | `_swap_prev_key`、`_swap_next_key` |
| `+` | 把窗格提升至左上位置 | `_promote_key` |
| `m`、`=` | 標記窗格，與已標記的窗格交換 | `_mark_key`、`_swap_mark_key` |

以下按鍵在選項設定之前不會綁定：`_sync_key` 切換窗格同步，`_swap_window_left_key` 和 `_swap_window_right_key` 移動視窗，`_move_window_key` 把視窗移至另一個工作階段，`_kill_window_key` 關閉視窗，`_layout_even_h_key`、`_layout_even_v_key` 和 `_layout_main_v_key` 選擇版面配置，`_respawn_key` 重新啟動窗格，`_capture_key` 儲存回捲內容，`_pane_name_key` 為窗格命名，`_scratch_key` 開啟暫存彈出視窗，`_zoom_key` 執行強力縮放。

版本檢查會去掉舊版 tmux 不支援的功能：全寬分割需要 2.3，標記需要 2.1，窗格名稱和邊緣停止需要 2.6，`{top-left}` 提升需要 3.0，暫存彈出視窗需要 3.2，強力縮放需要 3.0，焦點大小需要 3.1，說明需要 3.1。

<a id="畫面"></a>

## 畫面

<details>
<summary>每個畫面都以 <code>make screens</code> 在真實的 tmux 中錄製，按下的每個按鍵都顯示在狀態列上</summary>
<br>

<table>
<tr>
<td width="50%" valign="top"><img src="screens/splits.png" alt="pain-control-revamped：分割、切換、調整大小、提升和沿長邊分割"><br><sub>分割、切換、調整大小、提升和沿長邊分割，來自 <code>hero.tape</code></sub></td>
<td width="50%" valign="top"><img src="screens/window.png" alt="pain-control-revamped：在目前資料夾的新視窗"><br><sub>在目前資料夾的新視窗，來自 <code>keys.tape</code></sub></td>
</tr>
<tr>
<td width="50%" valign="top"><img src="screens/break.png" alt="pain-control-revamped：拆成獨立視窗的窗格"><br><sub>拆成獨立視窗的窗格，來自 <code>keys.tape</code></sub></td>
<td width="50%" valign="top"><img src="screens/join.png" alt="pain-control-revamped：從另一個視窗合併窗格"><br><sub>從另一個視窗合併窗格，來自 <code>keys.tape</code></sub></td>
</tr>
<tr>
<td width="50%" valign="top"><img src="screens/mark.png" alt="pain-control-revamped：標記窗格並與它交換"><br><sub>標記窗格並與它交換，來自 <code>keys.tape</code></sub></td>
<td width="50%" valign="top"><img src="screens/swap.png" alt="pain-control-revamped：與上一個和下一個窗格交換"><br><sub>與上一個和下一個窗格交換，來自 <code>keys.tape</code></sub></td>
</tr>
<tr>
<td width="50%" valign="top"><img src="screens/titles.png" alt="pain-control-revamped：邊框上的窗格標題"><br><sub>邊框上的窗格標題，來自 <code>options.tape</code></sub></td>
<td width="50%" valign="top"><img src="screens/sync.png" alt="pain-control-revamped：同步的窗格"><br><sub>同步的窗格，來自 <code>options.tape</code></sub></td>
</tr>
<tr>
<td width="50%" valign="top"><img src="screens/vim-nowrap.png" alt="pain-control-revamped：vim 導覽和邊緣停止"><br><sub>vim 導覽和邊緣停止，來自 <code>options.tape</code></sub></td>
<td width="50%" valign="top"><img src="screens/scratch-popup.png" alt="pain-control-revamped：暫存彈出視窗"><br><sub>暫存彈出視窗，來自 <code>options.tape</code></sub></td>
</tr>
<tr>
<td width="50%" valign="top"><img src="screens/list.png" alt="pain-control-revamped：list"><br><sub><code>list</code>，來自 <code>stills.tape</code></sub></td>
<td width="50%" valign="top"><img src="screens/json.png" alt="pain-control-revamped：list --json"><br><sub><code>list --json</code>，來自 <code>stills.tape</code></sub></td>
</tr>
<tr>
<td width="50%" valign="top"><img src="screens/doctor.png" alt="pain-control-revamped：doctor"><br><sub><code>doctor</code>，來自 <code>stills.tape</code></sub></td>
<td width="50%" valign="top"><img src="screens/menu.png" alt="pain-control-revamped：選單"><br><sub>選單，來自 <code>stills.tape</code></sub></td>
</tr>
<tr>
<td width="50%" valign="top"><img src="screens/plain-menu.png" alt="pain-control-revamped：沒有 gum 時的選單"><br><sub>沒有 gum 時的選單，來自 <code>stills.tape</code></sub></td>
<td width="50%" valign="top"><img src="screens/plain-apply.png" alt="pain-control-revamped：從選單執行 apply"><br><sub>從選單執行 <code>apply</code>，來自 <code>stills.tape</code></sub></td>
</tr>
<tr>
<td width="50%" valign="top"><img src="screens/version.png" alt="pain-control-revamped：版本"><br><sub>版本，來自 <code>stills.tape</code></sub></td>
<td width="50%" valign="top"><img src="screens/error.png" alt="pain-control-revamped：未知的指令"><br><sub>未知的指令，來自 <code>stills.tape</code></sub></td>
</tr>
<tr>
<td width="50%" valign="top"><img src="screens/themes.png" alt="pain-control-revamped：六個主題下的標題"><br><sub>六個主題下的標題，來自 <code>themes.tape</code></sub></td>
<td width="50%" valign="top"><img src="screens/help.png" alt="pain-control-revamped：說明頁面"><br><sub>說明頁面，來自 <code>help.tape</code></sub></td>
</tr>
<tr>
<td width="50%" valign="top"><img src="screens/accent.png" alt="pain-control-revamped：來自 PAIN_CONTROL_REVAMPED_ACCENT 的強調色"><br><sub>來自 <code>PAIN_CONTROL_REVAMPED_ACCENT</code> 的強調色，來自 <code>stills.tape</code></sub></td>
<td width="50%" valign="top"><img src="screens/zoom.png" alt="pain-control-revamped：移至自己視窗的窗格，旁邊開了另一個窗格"><br><sub>移至自己視窗的窗格，旁邊開了另一個窗格，來自 <code>zoom.tape</code></sub></td>
</tr>
<tr>
<td width="50%" valign="top"><img src="screens/zoom-placeholder.png" alt="pain-control-revamped：守住窗格原位的佔位窗格"><br><sub>守住窗格原位的佔位窗格，來自 <code>zoom.tape</code></sub></td>
<td width="50%" valign="top"><img src="screens/zoom-back.png" alt="pain-control-revamped：回到原位的窗格"><br><sub>回到原位的窗格，來自 <code>zoom.tape</code></sub></td>
</tr>
<tr>
<td width="50%" valign="top"><img src="screens/focus.png" alt="pain-control-revamped：擴大至 70% 的焦點窗格"><br><sub>擴大至 70% 的焦點窗格，來自 <code>zoom.tape</code></sub></td>
<td width="50%" valign="top"></td></tr>
</table>

</details>

## 可攜性

插件是 POSIX `sh`。CI 在下列每一行上執行全部測試。

| Shell | 狀態 |
|:------|:-------|
| `dash`、macOS 上的 `/bin/sh` | 支援 |
| `bash` 3.2 和 5.x、系統內建的 `zsh` 和 Homebrew 的 `zsh` | 支援 |

| 系統 | 狀態 |
|:-------|:-------|
| macOS | Apple Silicon 和 Intel 上的 Tahoe，使用內建的工具、Homebrew 的 GNU 工具和 Homebrew 的 uutils |
| Linux | x86_64 和 arm64 上的 Ubuntu 26.04，使用 GNU coreutils、uutils 和 BusyBox |

## 開發

| 指令 | 執行內容 |
|:--------|:-------------|
| `make fmt` | 對每個腳本執行 shfmt `-i 2` |
| `make lint` | shfmt、ShellCheck、mandoc、yamllint 和 actionlint，零警告 |
| `make test` | 在系統 `sh` 下執行 bats 測試 |
| `make test-all` | 在每個已安裝的 shell 下執行測試，macOS 上包括 bash 和 zsh 的兩種版本 |
| `make test-linux` | 在 Ubuntu 容器中執行測試 |
| `make coverage` | 在這部 Mac 和 Ubuntu 容器中執行 bashcov，合併後以 100% 為門檻 |
| `make screens` | 以 VHS 在 tmux 中從真實插件錄製上述畫面，在 macOS 上執行 |
| `make install` | 把指令、man 手冊和自動完成安裝到 `PREFIX` 下 |

提交遵循 Conventional Commits 格式，直接進入 `main`。`main` 上的 `ci` 通過後，`release.yml` 會執行 semantic-release：自上一個標籤以來的每個 `feat` 或 `fix` 都會發佈新版本，更新版本常數，並把說明寫入 [`CHANGELOG.md`](CHANGELOG.md)。

## 授權

[MIT](LICENSE)，copyright Gustavo Franco。

<!-- family:begin -->

## tmux-revamped 插件家族

這個插件是 tmux-revamped 插件家族的一員。每個成員都帶有 [`FAMILY.md`](FAMILY.md) 中相同的約定和相同的共用程式庫，並且設計為一起安裝：沒有成員佔用另一個成員佔用的按鍵或 tmux 選項。

在一個成員中發現的缺陷，要在全部成員中排查後才算修正完成。

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
| [`tmux-plugin-template`](https://github.com/tmux-revamped/tmux-plugin-template) | tmux-revamped 插件的起點：共用程式庫、bats 測試框架和 CI |
| [`tmux-pomodoro-revamped`](https://github.com/tmux-revamped/tmux-pomodoro-revamped) | tmux 狀態列中的番茄鐘計時器，所有狀態都儲存在 tmux 選項中，不使用暫存檔 |
| [`tmux-ram-revamped`](https://github.com/tmux-revamped/tmux-ram-revamped) | 在 tmux 狀態列顯示記憶體、交換空間及記憶體壓力，在背景取樣，繪製從不等待 |
| [`tmux-reorder-revamped`](https://github.com/tmux-revamped/tmux-reorder-revamped) | 用滑鼠在 tmux 狀態列上拖動視窗標籤來移動該視窗 |
| [`tmux-scroll-revamped`](https://github.com/tmux-revamped/tmux-scroll-revamped) | 將滑鼠滾輪交給能自行捲動的應用程式，其他情況下進入 tmux 複製模式 |
| [`tmux-sensible-revamped`](https://github.com/tmux-revamped/tmux-sensible-revamped) | 按 tmux 版本和終端機區分的合理預設設定，不會改動你自己設定的選項 |
| [`tmux-tiling-revamped`](https://github.com/tmux-revamped/tmux-tiling-revamped) | tmux 的平鋪視窗管理：八種版面，包括 BSP dwindle 和 spiral，並支援復原版面 |
| [`tmux-time-revamped`](https://github.com/tmux-revamped/tmux-time-revamped) | 狀態列中的本地時鐘和世界時鐘，按一天中的時段著色，並提供倒數和夏令時間提示 |
| [`tmux-weather-revamped`](https://github.com/tmux-revamped/tmux-weather-revamped) | 在背景從 wttr.in 取得天氣並顯示在狀態列，狀態列毋須等待 |

<!-- family:end -->
