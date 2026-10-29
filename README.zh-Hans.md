<div align="center">

# tmux-pain-control-revamped

<strong>tmux 的窗格和窗口管理按键，适配 tmux 版本，兼容 vim，每个 prefix 按键都可禁用。</strong>

[English](README.md) | [日本語](README.ja.md) | 简体中文 | [繁體中文（香港）](README.zh-HK.md)

[![family](https://img.shields.io/github/actions/workflow/status/tmux-revamped/tmux-pain-control-revamped/family.yml?branch=main&style=flat-square&label=family)](https://github.com/tmux-revamped/tmux-pain-control-revamped/actions/workflows/family.yml)
[![tests](https://img.shields.io/github/actions/workflow/status/tmux-revamped/tmux-pain-control-revamped/tests.yml?branch=main&style=flat-square&label=tests)](https://github.com/tmux-revamped/tmux-pain-control-revamped/actions/workflows/tests.yml)
[![release](https://img.shields.io/github/v/release/tmux-revamped/tmux-pain-control-revamped?style=flat-square&label=release)](https://github.com/tmux-revamped/tmux-pain-control-revamped/releases/latest)
[![openssf scorecard](https://img.shields.io/ossf-scorecard/github.com/tmux-revamped/tmux-pain-control-revamped?style=flat-square&label=openssf%20scorecard)](https://scorecard.dev/viewer/?uri=github.com/tmux-revamped/tmux-pain-control-revamped)
[![license](https://img.shields.io/github/license/tmux-revamped/tmux-pain-control-revamped?style=flat-square&label=license)](LICENSE)

<p align="center">
  <a href="#what-it-does">功能</a> |
  <a href="#installation">安装</a> |
  <a href="#usage">用法</a> |
  <a href="#configuration">配置</a> |
  <a href="#key-bindings">按键绑定</a> |
  <a href="#how-it-works">工作原理</a>
</p>

</div>

默认绑定 **27** 个 prefix 按键，另有 **12** 个可选按键，**28** 个选项，支持 tmux **3.2** 及以上版本。

---

<a id="what-it-does"></a>

## 功能

本插件绑定窗格导航、调整大小、保留当前目录的分割，以及窗格和窗口的移动。它是 [tmux-pain-control](https://github.com/tmux-plugins/tmux-pain-control) 的重写版，增加了更多操作，并有意替换了 tmux 自带的部分按键。

| 功能 | 选项 |
|:-----|:-----|
| 分割和新窗口在当前窗格的目录中打开，包括 `"` 和 `%` | `c` 由 `@new_window_path` 控制 |
| 按设定的单元格数调整大小 | `@pane_resize` |
| 沿窗格较长的一边分割 | `@pane_control_smart_split_key` |
| 合并、拆出、交换、提升和标记窗格 | `@pane_control_join_key` 等窗格按键 |
| 无需 prefix 的 `Ctrl+h/j/k/l` 在 vim 分屏和 tmux 窗格之间移动 | `@pane_control_vim_navigation` |
| 窗格选择在窗口边缘停止 | `@pane_control_no_wrap` |
| 关闭列表中的任意按键 | `@pane_control_disabled_keys` |

<a id="requirements"></a>

## 环境要求

| 依赖 | 版本 |
|:-----|:-----|
| tmux | 3.2 及以上 |
| bash | 3.2 及以上 |

可在 Linux 和 macOS 上运行，支持 BSD、GNU 或 uutils coreutils。智能 vim 导航使用 `ps` 和 `grep` 检测窗格中的 vim。

<a id="installation"></a>

## 安装

使用 [TPM](https://github.com/tmux-plugins/tpm) 时，把插件加入 `~/.tmux.conf`，然后按 `prefix + I`：

```tmux
set -g @plugin 'tmux-revamped/tmux-pain-control-revamped'
```

手动安装时，克隆仓库，并在 `~/.tmux.conf` 中运行入口脚本：

```bash
git clone https://github.com/tmux-revamped/tmux-pain-control-revamped ~/.tmux/plugins/tmux-pain-control-revamped
```

```tmux
run-shell ~/.tmux/plugins/tmux-pain-control-revamped/pain-control-revamped.tmux
```

<a id="usage"></a>

## 用法

安装后，[按键绑定](#key-bindings)中的按键在 prefix 之后生效。`prefix + |` 向右分割，`prefix + -` 向下分割，都使用当前目录。`prefix + h/j/k/l` 在窗格之间移动，`prefix + H/J/K/L` 调整窗格大小。

开启你需要的可选操作，并关闭你在别处要用的按键：

```tmux
set -g @pane_control_sync_key 'S'
set -g @pane_control_swap_window_left_key '<'
set -g @pane_control_swap_window_right_key '>'
set -g @pane_control_scratch_key 'g'
set -g @pane_control_scratch_command 'htop'

set -g @pane_control_disabled_keys 'c, *'
set -g @pane_resize 10
```

替换 [vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator) 的 tmux 部分：

```tmux
set -g @pane_control_vim_navigation 'on'
```

之后，vim 获得焦点时 `Ctrl+h/j/k/l` 移动 vim 分屏，否则移动 tmux 窗格，`Ctrl+\` 回到上一个窗格。由于这会占用无 prefix 的 `Ctrl+l`，`prefix + C-l` 改为发送清屏。vim 一侧仍需要在编辑器中安装 vim-tmux-navigator 插件。

<a id="configuration"></a>

## 配置

| 选项 | 默认值 | 含义 |
|:-----|:-------|:-----|
| `@pane_resize` | `5` | 每次按调整大小键移动的单元格数 |
| `@new_window_path` | `true` | 为 `true`、`on` 或 `1` 时，`c` 在当前目录打开新窗口；其他值不改动 `c` |
| `@pane_control_disabled_keys` | 空 | 不绑定的按键，以空格或逗号分隔，例如 `c, <` |
| `@pane_control_no_wrap` | `off` | 设为 `on` 时，`h/j/k/l` 选择在窗口边缘停止，而不是绕到另一侧 |
| `@pane_control_pane_titles` | `off` | 设为 `on` 时，在窗格上边框显示窗格编号和标题 |
| `@pane_control_vim_navigation` | `off` | 设为 `on` 时，绑定带 vim 检测的无 prefix `Ctrl+h/j/k/l` 和 `Ctrl+\` |
| `@pane_control_vim_pattern` | vim-tmux-navigator 的模式 | 判断窗格正在运行 vim 的进程名正则表达式 |
| `@pane_control_scratch_command` | 空 | 临时弹出窗口运行的命令；为空时打开 shell |
| `@pane_control_smart_split_key` | `*` | 智能分割 |
| `@pane_control_join_key` | `@` | 提示后从另一个窗口合并窗格 |
| `@pane_control_break_key` | `!` | 把当前窗格拆成独立窗口 |
| `@pane_control_swap_prev_key` | `{` | 与上一个窗格交换 |
| `@pane_control_swap_next_key` | `}` | 与下一个窗格交换 |
| `@pane_control_promote_key` | `+` | 把窗格交换到左上位置 |
| `@pane_control_mark_key` | `m` | 标记窗格 |
| `@pane_control_swap_mark_key` | `=` | 与已标记的窗格交换 |
| `@pane_control_sync_key` | 空 | 切换 `synchronize-panes` 并显示其状态 |
| `@pane_control_swap_window_left_key` | 空 | 把窗口左移一位 |
| `@pane_control_swap_window_right_key` | 空 | 把窗口右移一位 |
| `@pane_control_move_window_key` | 空 | 提示后把窗口移到另一个会话 |
| `@pane_control_kill_window_key` | 空 | 确认后关闭窗口 |
| `@pane_control_layout_even_h_key` | 空 | `even-horizontal` 布局 |
| `@pane_control_layout_even_v_key` | 空 | `even-vertical` 布局 |
| `@pane_control_layout_main_v_key` | 空 | `main-vertical` 布局 |
| `@pane_control_respawn_key` | 空 | 确认后重新启动窗格 |
| `@pane_control_capture_key` | 空 | 提示（默认 `~/tmux-scrollback.log`）后把整个回滚缓冲区保存到文件 |
| `@pane_control_pane_name_key` | 空 | 提示后设置窗格标题 |
| `@pane_control_scratch_key` | 空 | 在当前目录打开占 80% 的弹出 shell |

按键选项设为空值时不绑定任何按键。本插件没有内部状态选项。

<a id="key-bindings"></a>

## 按键绑定

### 默认绑定

以下按键都在 prefix 之后按。导航、调整大小、分割和 `c` 的按键不能更改，只能用 `@pane_control_disabled_keys` 关闭。

| 按键 | 操作 | 可连按 |
|:-----|:-----|:------:|
| `h` `j` `k` `l`、`C-h` `C-j` `C-k` `C-l` | 选择左、下、上、右侧的窗格 | 否 |
| `H` `J` `K` `L` | 按 `@pane_resize` 个单元格调整窗格大小 | 是 |
| `\|` 和 `%` | 在当前目录向右分割 | 否 |
| `-` 和 `"` | 在当前目录向下分割 | 否 |
| `\` | 按整个窗口宽度分割 | 否 |
| `_` | 按整个窗口高度分割 | 否 |
| `*` | 沿较长的一边分割 | 否 |
| `c` | 在当前目录新建窗口 | 否 |
| `@` | 从另一个窗口合并窗格 | 否 |
| `!` | 把窗格拆成独立窗口 | 否 |
| `{` `}` | 与上一个或下一个窗格交换 | 是 |
| `+` | 把窗格提升到左上位置 | 否 |
| `m` | 标记窗格 | 否 |
| `=` | 与已标记的窗格交换 | 否 |

`pain-control` 是 tmux-revamped 插件家族中声明的覆盖者，所以这些按键按设计替换 tmux 的默认绑定。

### 可选按键

2.0.0 版取消了这些绑定。把选项设为原来的按键即可恢复：

| 选项 | 原按键 | 操作 |
|:-----|:------:|:-----|
| `@pane_control_sync_key` | `S` | 切换窗格同步输入 |
| `@pane_control_swap_window_left_key` | `<` | 窗口左移 |
| `@pane_control_swap_window_right_key` | `>` | 窗口右移 |
| `@pane_control_move_window_key` | `.` | 把窗口移到另一个会话 |
| `@pane_control_kill_window_key` | `&` | 关闭窗口 |
| `@pane_control_layout_even_h_key` | `E` | `even-horizontal` 布局 |
| `@pane_control_layout_even_v_key` | `V` | `even-vertical` 布局 |
| `@pane_control_layout_main_v_key` | `B` | `main-vertical` 布局 |
| `@pane_control_respawn_key` | `R` | 重新启动窗格 |
| `@pane_control_capture_key` | `C` | 保存回滚缓冲区 |
| `@pane_control_pane_name_key` | `P` | 为窗格命名 |
| `@pane_control_scratch_key` | `g` | 临时弹出窗口 |

### 智能 vim 导航

`@pane_control_vim_navigation` 设为 `on` 时，插件还会在 root 表和 `copy-mode-vi` 中绑定 `C-h`、`C-j`、`C-k`、`C-l` 和 `C-\`，并把 `prefix + C-l` 改绑为清屏。`@pane_control_disabled_keys` 对这些按键不起作用。

<a id="how-it-works"></a>

## 工作原理

tmux 加载插件时，[`pain-control-revamped.tmux`](pain-control-revamped.tmux) 会运行一次 [`src/pain.sh`](src/pain.sh)。该脚本读取选项和 tmux 版本，然后为每个按键执行 `bind-key`。之后没有任何后台运行的内容。

每个绑定都带有 `-N` 说明，所以 `prefix + ?` 会连同说明一起列出它们。在 tmux 3.2 以下版本中，脚本的版本检查仍会去掉该 tmux 不支持的功能：整宽和整高分割需要 2.3，标记需要 2.1，窗格命名和边缘不环绕需要 2.6，使用 `{top-left}` 的提升需要 3.0，临时弹出窗口需要 3.2。

开启 vim 导航后，每个组合键都会对窗格的 TTY 运行 `ps`，并用 `@pane_control_vim_pattern` 匹配进程名。匹配时按键发送给 vim，否则由 tmux 选择窗格。

版本和按键的辅助函数位于 [`src/lib/pain/pain.sh`](src/lib/pain/pain.sh)。设置 `PAIN_DRY_RUN` 后，脚本会打印每条 tmux 命令而不执行，测试套件就是用这种方式检查按键绑定的。

<a id="development"></a>

## 开发

| 命令 | 作用 |
|:-----|:-----|
| `make test` | 运行 bats 测试套件 |
| `make lint` | 对所有 shell 文件运行 shellcheck |
| `make coverage` | 在 Linux 上用 kcov 测量行覆盖率，低于 95% 时失败 |

变更记录见 [CHANGELOG.md](CHANGELOG.md)。

<a id="license"></a>

## 许可证

[MIT](LICENSE)

<!-- family:begin -->

## tmux-revamped 插件家族

本插件是 tmux-revamped 插件家族的一员。每个成员都带有 [`FAMILY.md`](FAMILY.md) 中的同一份约定、`family/` 下的同一套工具和同一个共享库，并由校验和清单保证逐字节一致。这些成员可以一起安装：任何成员都不会占用其他成员使用的按键或 tmux 选项。

在一个成员中发现的缺陷，要在全部成员中排查之后才算修复完成。这项义务写在约定里，而不是靠记忆，`family/bin/sweep` 负责执行它。

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
| [`tmux-plugin-template`](https://github.com/tmux-revamped/tmux-plugin-template) | tmux-revamped 插件的起点：共享库、bats 测试框架、CI 和系列工具 |
| [`tmux-pomodoro-revamped`](https://github.com/tmux-revamped/tmux-pomodoro-revamped) | tmux 状态栏中的番茄钟计时器，所有状态都保存在 tmux 选项中，不使用临时文件 |
| [`tmux-ram-revamped`](https://github.com/tmux-revamped/tmux-ram-revamped) | 在 tmux 状态栏显示内存、交换空间和内存压力，在后台采样，渲染从不等待 |
| [`tmux-reorder-revamped`](https://github.com/tmux-revamped/tmux-reorder-revamped) | 用鼠标在 tmux 状态栏上拖动窗口标签来移动该窗口 |
| [`tmux-scroll-revamped`](https://github.com/tmux-revamped/tmux-scroll-revamped) | 将鼠标滚轮交给能自行滚动的应用，其他情况下进入 tmux 复制模式 |
| [`tmux-sensible-revamped`](https://github.com/tmux-revamped/tmux-sensible-revamped) | 按 tmux 版本和终端区分的合理默认设置，不改动你自己设置的选项 |
| [`tmux-tiling-revamped`](https://github.com/tmux-revamped/tmux-tiling-revamped) | tmux 的平铺窗口管理：八种布局，包括 BSP dwindle 和 spiral，并支持撤销布局 |
| [`tmux-time-revamped`](https://github.com/tmux-revamped/tmux-time-revamped) | 状态栏中的本地时钟和世界时钟，按一天中的时段着色，并提供倒计时和夏令时提醒 |
| [`tmux-weather-revamped`](https://github.com/tmux-revamped/tmux-weather-revamped) | 在后台从 wttr.in 获取天气并显示在状态栏，状态栏无需等待 |

### 检查安装

所有成员都在磁盘上时，一条命令即可报告它们之间的任何冲突：

```sh
family/bin/doctor --live
```

它读取每个成员和正在运行的 tmux 服务器，报告重复的按键、重复的状态占位符、不符合命名规则的选项，以及约定版本落后的成员。

<!-- family:end -->
