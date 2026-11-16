<div align="center">

# tmux-pain-control-revamped

<strong>tmux 的窗格和窗口管理按键，适配 tmux 版本，兼容 vim，每个 prefix 按键都可禁用。</strong>

[English](README.md) &nbsp;|&nbsp; [日本語](README.ja.md) &nbsp;|&nbsp; 简体中文 &nbsp;|&nbsp; [繁體中文（香港）](README.zh-HK.md)

[![ci](https://img.shields.io/github/actions/workflow/status/tmux-revamped/tmux-pain-control-revamped/ci.yml?branch=main&style=flat-square&label=ci)](https://github.com/tmux-revamped/tmux-pain-control-revamped/actions/workflows/ci.yml)
[![release](https://img.shields.io/github/v/release/tmux-revamped/tmux-pain-control-revamped?style=flat-square&label=release)](https://github.com/tmux-revamped/tmux-pain-control-revamped/releases/latest)
[![openssf scorecard](https://img.shields.io/ossf-scorecard/github.com/tmux-revamped/tmux-pain-control-revamped?style=flat-square&label=openssf%20scorecard)](https://scorecard.dev/viewer/?uri=github.com/tmux-revamped/tmux-pain-control-revamped)
[![license](https://img.shields.io/github/license/tmux-revamped/tmux-pain-control-revamped?style=flat-square&label=license)](LICENSE)

<p align="center">
  <a href="#快速开始"><strong>快速开始</strong></a> &nbsp;|&nbsp;
  <a href="#用法">用法</a> &nbsp;|&nbsp;
  <a href="#按键">按键</a> &nbsp;|&nbsp;
  <a href="#界面">界面</a>
</p>

</div>

<p align="center">
  <img src="screens/hero.gif" alt="用插件的按键分割、切换、调整大小和提升窗格的 tmux" width="800">
</p>

```console
$ pain-control-revamped list
bind-key -N Select pane left h select-pane -L
bind-key -N Select pane left C-h select-pane -L
bind-key -N Select pane below j select-pane -D
bind-key -N Select pane below C-j select-pane -D
```

每个按键都按 tmux 版本检查，带有 `prefix ?` 显示的说明，并且都可以不绑定。插件加载时，所有按键通过一次调用交给 tmux，之后不再运行任何东西。

---

## 快速开始

### 前提条件

| 工具 | 版本 | 用途 |
|:-----|:--------|:---------|
| tmux | 3.2 或更高 | 家族的最低版本；更旧的版本会少掉它不支持的按键 |
| `ps` | 任意 | 开启 vim 导航时 |
| gum | 可选 | `pain-control-revamped` 的菜单、表格和颜色；没有它时每个命令都输出纯文本 |

### 安装

```tmux
set -g @plugin 'tmux-revamped/tmux-pain-control-revamped'
```

然后按 `prefix + I`。不用 TPM 时，克隆仓库，并在 `~/.tmux.conf` 中运行它的入口文件：

```bash
git clone https://github.com/tmux-revamped/tmux-pain-control-revamped ~/.tmux/plugins/tmux-pain-control-revamped
```

```tmux
run-shell ~/.tmux/plugins/tmux-pain-control-revamped/pain-control-revamped.tmux
```

在克隆的目录中运行 `make install`，还会把 `pain-control-revamped` 放进 `~/.local/bin`，把它的 man 手册和补全放在 `~/.local/share` 下。

### 验证

```bash
~/.tmux/plugins/tmux-pain-control-revamped/bin/pain-control-revamped doctor
```

## 用法

| 命令 | 作用 |
|:--------|:-------------|
| `pain-control-revamped apply` | 立即绑定所有按键；tmux 加载插件时入口文件会运行它 |
| `pain-control-revamped list` | 打印 apply 会做的每个绑定；`--json` 输出一个对象 |
| `pain-control-revamped doctor` | 每个依赖一行 |
| `pain-control-revamped version` | 版本号，然后是 tmux 的版本 |
| `pain-control-revamped help` | 帮助页面。`man pain-control-revamped` 说明同样的命令和设置 |
| `pain-control-revamped` | 在终端中显示菜单 |

| tmux 选项 | 默认值 | 含义 |
|:------------|:--------|:--------|
| `@pain_control_revamped_resize` | `5` | 每次调整大小移动的格数 |
| `@pain_control_revamped_new_window_path` | `true` | `c` 在窗格所在的文件夹打开新窗口 |
| `@pain_control_revamped_disabled_keys` | 无 | 不绑定的按键，用空格或逗号分隔 |
| `@pain_control_revamped_no_wrap` | `off` | `on` 让窗格切换停在窗口边缘 |
| `@pain_control_revamped_vim_navigation` | `off` | `on` 不经 prefix 绑定 `C-h` 到 `C-l` 和 `C-\`，窗格中运行 vim 时把按键交给 vim |
| `@pain_control_revamped_vim_pattern` | vim、nvim、view、fzf | vim 导航视为 vim 的进程名 |
| `@pain_control_revamped_pane_titles` | `off` | `on` 在边框上显示每个窗格的编号和标题 |
| `@pain_control_revamped_scratch_command` | 一个 shell | 临时弹窗运行的内容 |

下一节的每个按键也都有自己的选项，例如 `@pain_control_revamped_join_key`。每个选项也都是用连字符命名的命令选项，例如 `--join-key J`，以及一个环境变量，例如 `PAIN_CONTROL_REVAMPED_JOIN_KEY`；命令行优先于环境变量，环境变量优先于 tmux 选项。空的 tmux 选项表示默认值。

3.0.0 之前的选项名 `@pane_control_*`、`@pane_resize` 和 `@new_window_path` 不再生效。

<a id="按键"></a>

## 按键

这些按键都在 prefix 之后按。pain-control 是 tmux-revamped 家族中声明的覆盖者，所以它们按设计替换 tmux 自带的按键。

| 按键 | 作用 | 选项 |
|:----|:-------|:-------|
| `h` `j` `k` `l`、`C-h` `C-j` `C-k` `C-l` | 选择左、下、上、右的窗格 | 无 |
| `H` `J` `K` `L` | 调整窗格大小，可重复 | 无 |
| `\|` 和 `%`、`-` 和 `"` | 在当前文件夹向右或向下分割 | 无 |
| `\` 和 `_` | 按窗口全宽或全高分割 | 无 |
| `*` | 沿较长的一边分割 | `_smart_split_key` |
| `c` | 在当前文件夹打开新窗口 | `_new_window_path` |
| `@` | 从另一个窗口合并窗格 | `_join_key` |
| `!` | 把窗格拆成单独的窗口 | `_break_key` |
| `{` `}` | 与上一个或下一个窗格交换，可重复 | `_swap_prev_key`、`_swap_next_key` |
| `+` | 把窗格提升到左上位置 | `_promote_key` |
| `m`、`=` | 标记窗格，与标记的窗格交换 | `_mark_key`、`_swap_mark_key` |

下面这些在选项设置之前没有按键：`_sync_key` 切换窗格同步，`_swap_window_left_key` 和 `_swap_window_right_key` 移动窗口，`_move_window_key` 把窗口移到另一个会话，`_kill_window_key` 关闭窗口，`_layout_even_h_key`、`_layout_even_v_key` 和 `_layout_main_v_key` 选择布局，`_respawn_key` 重启窗格，`_capture_key` 保存回滚内容，`_pane_name_key` 给窗格命名，`_scratch_key` 打开临时弹窗。

版本检查会去掉旧版 tmux 不支持的功能：全宽分割需要 2.3，标记需要 2.1，窗格名称和边缘停止需要 2.6，`{top-left}` 提升需要 3.0，临时弹窗需要 3.2，说明需要 3.1。

<a id="界面"></a>

## 界面

<details>
<summary>每个界面都用 <code>make screens</code> 在真实的 tmux 中录制，按下的每个键都显示在状态栏上</summary>
<br>

<table>
<tr>
<td width="50%" valign="top"><img src="screens/splits.png" alt="pain-control-revamped：分割、切换、调整大小、提升和沿长边分割"><br><sub>分割、切换、调整大小、提升和沿长边分割，来自 <code>hero.tape</code></sub></td>
<td width="50%" valign="top"><img src="screens/window.png" alt="pain-control-revamped：在当前文件夹的新窗口"><br><sub>在当前文件夹的新窗口，来自 <code>keys.tape</code></sub></td>
</tr>
<tr>
<td width="50%" valign="top"><img src="screens/break.png" alt="pain-control-revamped：拆成单独窗口的窗格"><br><sub>拆成单独窗口的窗格，来自 <code>keys.tape</code></sub></td>
<td width="50%" valign="top"><img src="screens/join.png" alt="pain-control-revamped：从另一个窗口合并窗格"><br><sub>从另一个窗口合并窗格，来自 <code>keys.tape</code></sub></td>
</tr>
<tr>
<td width="50%" valign="top"><img src="screens/mark.png" alt="pain-control-revamped：标记窗格并与它交换"><br><sub>标记窗格并与它交换，来自 <code>keys.tape</code></sub></td>
<td width="50%" valign="top"><img src="screens/swap.png" alt="pain-control-revamped：与上一个和下一个窗格交换"><br><sub>与上一个和下一个窗格交换，来自 <code>keys.tape</code></sub></td>
</tr>
<tr>
<td width="50%" valign="top"><img src="screens/titles.png" alt="pain-control-revamped：边框上的窗格标题"><br><sub>边框上的窗格标题，来自 <code>options.tape</code></sub></td>
<td width="50%" valign="top"><img src="screens/sync.png" alt="pain-control-revamped：同步的窗格"><br><sub>同步的窗格，来自 <code>options.tape</code></sub></td>
</tr>
<tr>
<td width="50%" valign="top"><img src="screens/vim-nowrap.png" alt="pain-control-revamped：vim 导航和边缘停止"><br><sub>vim 导航和边缘停止，来自 <code>options.tape</code></sub></td>
<td width="50%" valign="top"><img src="screens/scratch-popup.png" alt="pain-control-revamped：临时弹窗"><br><sub>临时弹窗，来自 <code>options.tape</code></sub></td>
</tr>
<tr>
<td width="50%" valign="top"><img src="screens/list.png" alt="pain-control-revamped：list"><br><sub><code>list</code>，来自 <code>stills.tape</code></sub></td>
<td width="50%" valign="top"><img src="screens/json.png" alt="pain-control-revamped：list --json"><br><sub><code>list --json</code>，来自 <code>stills.tape</code></sub></td>
</tr>
<tr>
<td width="50%" valign="top"><img src="screens/doctor.png" alt="pain-control-revamped：doctor"><br><sub><code>doctor</code>，来自 <code>stills.tape</code></sub></td>
<td width="50%" valign="top"><img src="screens/menu.png" alt="pain-control-revamped：菜单"><br><sub>菜单，来自 <code>stills.tape</code></sub></td>
</tr>
<tr>
<td width="50%" valign="top"><img src="screens/plain-menu.png" alt="pain-control-revamped：没有 gum 时的菜单"><br><sub>没有 gum 时的菜单，来自 <code>stills.tape</code></sub></td>
<td width="50%" valign="top"><img src="screens/plain-apply.png" alt="pain-control-revamped：从菜单运行 apply"><br><sub>从菜单运行 <code>apply</code>，来自 <code>stills.tape</code></sub></td>
</tr>
<tr>
<td width="50%" valign="top"><img src="screens/version.png" alt="pain-control-revamped：版本"><br><sub>版本，来自 <code>stills.tape</code></sub></td>
<td width="50%" valign="top"><img src="screens/error.png" alt="pain-control-revamped：未知命令"><br><sub>未知命令，来自 <code>stills.tape</code></sub></td>
</tr>
<tr>
<td width="50%" valign="top"><img src="screens/themes.png" alt="pain-control-revamped：六个主题下的标题"><br><sub>六个主题下的标题，来自 <code>themes.tape</code></sub></td>
<td width="50%" valign="top"><img src="screens/help.png" alt="pain-control-revamped：帮助页面"><br><sub>帮助页面，来自 <code>help.tape</code></sub></td>
</tr>
<tr>
<td width="50%" valign="top"><img src="screens/accent.png" alt="pain-control-revamped：来自 PAIN_CONTROL_REVAMPED_ACCENT 的强调色"><br><sub>来自 <code>PAIN_CONTROL_REVAMPED_ACCENT</code> 的强调色，来自 <code>stills.tape</code></sub></td>
<td width="50%" valign="top"></td></tr>
</table>

</details>

## 可移植性

插件是 POSIX `sh`。CI 在下面每一行上运行全部测试。

| Shell | 状态 |
|:------|:-------|
| `dash`、macOS 上的 `/bin/sh` | 支持 |
| `bash` 3.2 和 5.x、系统自带的 `zsh` 和 Homebrew 的 `zsh` | 支持 |

| 系统 | 状态 |
|:-------|:-------|
| macOS | Apple Silicon 和 Intel 上的 Tahoe，使用系统自带的工具、Homebrew 的 GNU 工具和 Homebrew 的 uutils |
| Linux | x86_64 和 arm64 上的 Ubuntu 26.04，使用 GNU coreutils、uutils 和 BusyBox |

## 开发

| 命令 | 运行内容 |
|:--------|:-------------|
| `make fmt` | 对每个脚本运行 shfmt `-i 2` |
| `make lint` | shfmt、ShellCheck、mandoc、yamllint 和 actionlint，零告警 |
| `make test` | 在系统 `sh` 下运行 bats 测试 |
| `make test-all` | 在每个已安装的 shell 下运行测试，macOS 上包括 bash 和 zsh 的两种构建 |
| `make test-linux` | 在 Ubuntu 容器中运行测试 |
| `make coverage` | 在这台 Mac 和 Ubuntu 容器中运行 bashcov，合并后以 100% 为门槛 |
| `make screens` | 用 VHS 在 tmux 中从真实插件录制上面的界面，在 macOS 上运行 |
| `make install` | 把命令、man 手册和补全安装到 `PREFIX` 下 |

提交遵循 Conventional Commits 格式，直接进入 `main`。`main` 上的 `ci` 通过后，`release.yml` 运行 semantic-release：自上一个标签以来的每个 `feat` 或 `fix` 都会发布新版本，更新版本常量，并把说明写进 [`CHANGELOG.md`](CHANGELOG.md)。

## 许可证

[MIT](LICENSE)，copyright Gustavo Franco。

<!-- family:begin -->

## tmux-revamped 插件家族

这个插件是 tmux-revamped 插件家族的一员。每个成员都带有 [`FAMILY.md`](FAMILY.md) 中相同的约定和相同的共享库，并且设计为一起安装：没有成员占用另一个成员占用的按键或 tmux 选项。

在一个成员中发现的缺陷，要在全部成员中排查之后才算修复完成。

| 成员 | 功能 |
|---|---|
| [`tmux-autoreload-revamped`](https://github.com/tmux-revamped/tmux-autoreload-revamped) | 编辑并保存 tmux 配置后，它会自动重新加载，无需按键，也无需命令 |
| [`tmux-battery-revamped`](https://github.com/tmux-revamped/tmux-battery-revamped) | 在 tmux 状态栏显示电池状态，从不阻塞状态栏渲染 |
| [`tmux-bluetooth-revamped`](https://github.com/tmux-revamped/tmux-bluetooth-revamped) | 在 tmux 状态栏显示每个已连接的蓝牙设备及其电量，不阻塞渲染 |
| [`tmux-cpu-revamped`](https://github.com/tmux-revamped/tmux-cpu-revamped) | 在 tmux 状态栏显示 CPU 负载、温度和频率，从不阻塞渲染 |
| [`tmux-disk-revamped`](https://github.com/tmux-revamped/tmux-disk-revamped) | 在 tmux 状态栏显示磁盘用量，从不阻塞状态栏渲染 |
| [`tmux-extract-revamped`](https://github.com/tmux-revamped/tmux-extract-revamped) | 用 fzf 从屏幕上挑选 URL、路径、哈希或任意其他词元，并输入到光标处，全部用纯 shell 实现 |
| [`tmux-fzf-revamped`](https://github.com/tmux-revamped/tmux-fzf-revamped) | 在弹出窗口中的 fzf 选择器里切换、关闭、重命名或创建 tmux 会话、窗口和窗格 |
| [`tmux-git-revamped`](https://github.com/tmux-revamped/tmux-git-revamped) | 在 tmux 状态栏中显示活动窗格的 git 分支、改动和托管平台计数，且不阻塞渲染 |
| [`tmux-gpu-revamped`](https://github.com/tmux-revamped/tmux-gpu-revamped) | 在 tmux 状态栏中显示 NVIDIA、AMD、Intel 和 Apple GPU 的负载、温度、频率、功耗和显存 |
| [`tmux-kube-revamped`](https://github.com/tmux-revamped/tmux-kube-revamped) | 在 tmux 状态栏中显示当前的 Kubernetes 上下文和命名空间，不依赖 kubectl，直接解析 kubeconfig |
| [`tmux-launcher-revamped`](https://github.com/tmux-revamped/tmux-launcher-revamped) | 在弹出窗口或新窗口中启动任意 TUI 应用，从当前窗格的目录开始，每个应用可配置一个按键 |
| [`tmux-logging-revamped`](https://github.com/tmux-revamped/tmux-logging-revamped) | 将任意窗格保存到文件：实时日志、完整回滚缓冲区或一次性截图 |
| [`tmux-music-revamped`](https://github.com/tmux-revamped/tmux-music-revamped) | 在 tmux 状态栏显示正在播放的曲目，从不阻塞状态栏渲染 |
| [`tmux-network-revamped`](https://github.com/tmux-revamped/tmux-network-revamped) | 在 tmux 状态栏显示网络吞吐量，从不阻塞渲染 |
| [`tmux-pain-control-revamped`](https://github.com/tmux-revamped/tmux-pain-control-revamped) | **本插件**，tmux 的窗格和窗口管理按键，适配 tmux 版本，兼容 vim，每个 prefix 按键都可禁用 |
| [`tmux-persist-revamped`](https://github.com/tmux-revamped/tmux-persist-revamped) | 保存 tmux 的所有会话、窗口和窗格，按定时器自动保存，并在重启后全部恢复 |
| [`tmux-plugin-template`](https://github.com/tmux-revamped/tmux-plugin-template) | tmux-revamped 插件的起点：共享库、bats 测试框架和 CI |
| [`tmux-pomodoro-revamped`](https://github.com/tmux-revamped/tmux-pomodoro-revamped) | tmux 状态栏中的番茄钟计时器，所有状态都保存在 tmux 选项中，不使用临时文件 |
| [`tmux-ram-revamped`](https://github.com/tmux-revamped/tmux-ram-revamped) | 在 tmux 状态栏显示内存、交换空间和内存压力，在后台采样，渲染从不等待 |
| [`tmux-reorder-revamped`](https://github.com/tmux-revamped/tmux-reorder-revamped) | 用鼠标在 tmux 状态栏上拖动窗口标签来移动该窗口 |
| [`tmux-scroll-revamped`](https://github.com/tmux-revamped/tmux-scroll-revamped) | 将鼠标滚轮交给能自行滚动的应用，其他情况下进入 tmux 复制模式 |
| [`tmux-sensible-revamped`](https://github.com/tmux-revamped/tmux-sensible-revamped) | 按 tmux 版本和终端区分的合理默认设置，不改动你自己设置的选项 |
| [`tmux-tiling-revamped`](https://github.com/tmux-revamped/tmux-tiling-revamped) | tmux 的平铺窗口管理：八种布局，包括 BSP dwindle 和 spiral，并支持撤销布局 |
| [`tmux-time-revamped`](https://github.com/tmux-revamped/tmux-time-revamped) | 状态栏中的本地时钟和世界时钟，按一天中的时段着色，并提供倒计时和夏令时提醒 |
| [`tmux-weather-revamped`](https://github.com/tmux-revamped/tmux-weather-revamped) | 在后台从 wttr.in 获取天气并显示在状态栏，状态栏无需等待 |

<!-- family:end -->
