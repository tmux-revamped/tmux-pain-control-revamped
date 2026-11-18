<div align="center">

# tmux-pain-control-revamped

<strong>tmux のペインとウィンドウの操作キー。tmux のバージョンに対応し、vim と共存でき、どの prefix キーも無効にできます。</strong>

[English](README.md) &nbsp;|&nbsp; 日本語 &nbsp;|&nbsp; [简体中文](README.zh-Hans.md) &nbsp;|&nbsp; [繁體中文（香港）](README.zh-HK.md)

[![ci](https://img.shields.io/github/actions/workflow/status/tmux-revamped/tmux-pain-control-revamped/ci.yml?branch=main&style=flat-square&label=ci)](https://github.com/tmux-revamped/tmux-pain-control-revamped/actions/workflows/ci.yml)
[![release](https://img.shields.io/github/v/release/tmux-revamped/tmux-pain-control-revamped?style=flat-square&label=release)](https://github.com/tmux-revamped/tmux-pain-control-revamped/releases/latest)
[![openssf scorecard](https://img.shields.io/ossf-scorecard/github.com/tmux-revamped/tmux-pain-control-revamped?style=flat-square&label=openssf%20scorecard)](https://scorecard.dev/viewer/?uri=github.com/tmux-revamped/tmux-pain-control-revamped)
[![license](https://img.shields.io/github/license/tmux-revamped/tmux-pain-control-revamped?style=flat-square&label=license)](LICENSE)

<p align="center">
  <a href="#クイックスタート"><strong>クイックスタート</strong></a> &nbsp;|&nbsp;
  <a href="#使い方">使い方</a> &nbsp;|&nbsp;
  <a href="#キー">キー</a> &nbsp;|&nbsp;
  <a href="#画面">画面</a>
</p>

</div>

<p align="center">
  <img src="screens/hero.gif" alt="プラグインのキーでペインを分割し、移動し、サイズを変え、昇格させる tmux" width="800">
</p>

```console
$ pain-control-revamped list
bind-key -N Select pane left h select-pane -L
bind-key -N Select pane left C-h select-pane -L
bind-key -N Select pane below j select-pane -D
bind-key -N Select pane below C-j select-pane -D
```

どのキーも tmux のバージョンに合わせて確認され、`prefix ?` に表示される説明を持ち、無効にできます。キーはプラグインの読み込み時に 1 回の呼び出しで tmux に渡され、その後は何も動きません。

---

## クイックスタート

### 前提条件

| ツール | バージョン | 用途 |
|:-----|:--------|:---------|
| tmux | 3.2 以降 | ファミリー共通の最低バージョン。古い版ではその版にないキーが外れます |
| `ps` | 任意 | vim ナビゲーションを有効にしたとき |
| gum | 任意 | `pain-control-revamped` のメニュー、表、色。なくてもすべてのコマンドがプレーンテキストで動きます |

### インストール

```tmux
set -g @plugin 'tmux-revamped/tmux-pain-control-revamped'
```

続けて `prefix + I` を押します。TPM を使わない場合は、リポジトリをクローンし、`~/.tmux.conf` からエントリーポイントを実行します。

```bash
git clone https://github.com/tmux-revamped/tmux-pain-control-revamped ~/.tmux/plugins/tmux-pain-control-revamped
```

```tmux
run-shell ~/.tmux/plugins/tmux-pain-control-revamped/pain-control-revamped.tmux
```

クローンで `make install` を実行すると、`pain-control-revamped` が `~/.local/bin` に、manページと補完が `~/.local/share` の下に入ります。

### 確認

```bash
~/.tmux/plugins/tmux-pain-control-revamped/bin/pain-control-revamped doctor
```

## 使い方

| コマンド | 動作 |
|:--------|:-------------|
| `pain-control-revamped apply` | すべてのキーをいま割り当てます。tmux がプラグインを読み込むとエントリーポイントがこれを実行します |
| `pain-control-revamped list` | apply が行う割り当てをすべて表示します。`--json` で 1 つのオブジェクトを出力します |
| `pain-control-revamped zoom` | ペインを専用のウィンドウへ移し、元の場所にプレースホルダーを残します。どちらかでもう一度実行すると元に戻します |
| `pain-control-revamped doctor` | 依存するツールごとに 1 行 |
| `pain-control-revamped version` | バージョンと、tmux のバージョン |
| `pain-control-revamped help` | ヘルプページ。`man pain-control-revamped` も同じコマンドと設定を説明します |
| `pain-control-revamped` | 端末ではメニューを表示します |

| tmux オプション | 既定値 | 意味 |
|:------------|:--------|:--------|
| `@pain_control_revamped_resize` | `5` | 1 回のリサイズで動くセル数 |
| `@pain_control_revamped_new_window_path` | `true` | `c` で開く新しいウィンドウをペインのフォルダーで開きます |
| `@pain_control_revamped_disabled_keys` | なし | 割り当てないキー。空白かカンマで区切ります |
| `@pain_control_revamped_no_wrap` | `off` | `on` でペインの移動をウィンドウの端で止めます |
| `@pain_control_revamped_vim_navigation` | `off` | `on` で prefix なしの `C-h` から `C-l` と `C-\` を割り当て、ペインで vim が動いているか、[smart-splits.nvim](https://github.com/mrjones2014/smart-splits.nvim) のようにペインの `@pane-is-vim` オプションが設定されていれば vim に送ります |
| `@pain_control_revamped_vim_pattern` | vim、nvim、view、fzf | vim ナビゲーションが vim とみなすプロセス名 |
| `@pain_control_revamped_pane_titles` | `off` | `on` で各ペインの番号とタイトルを枠に表示します |
| `@pain_control_revamped_scratch_command` | シェル | スクラッチポップアップで実行するもの |
| `@pain_control_revamped_zoom_key` | なし | `zoom` を実行するキー |
| `@pain_control_revamped_focus_size` | なし | 50 から 99 の整数。ペインの選択と分割のたびに、フォーカスしたペインをウィンドウの幅と高さのこの割合まで広げます。解除は tmux サーバーの再起動後に反映されます |

次の節の各キーにも、`@pain_control_revamped_join_key` のような専用のオプションがあります。どのオプションも、`--join-key J` のようなダッシュ区切りのコマンドのオプションとしても、`PAIN_CONTROL_REVAMPED_JOIN_KEY` のような環境変数としても指定できます。コマンドラインが環境変数に優先し、環境変数が tmux オプションに優先します。空の tmux オプションは既定値を意味します。

3.0.0 より前のオプション名 `@pane_control_*`、`@pane_resize`、`@new_window_path` は使えなくなりました。

<a id="キー"></a>

## キー

どれも prefix のあとに押します。pain-control は tmux-revamped ファミリーで宣言された上書き役なので、これらのキーは意図して tmux 標準のキーを置き換えます。

| キー | 動作 | オプション |
|:----|:-------|:-------|
| `h` `j` `k` `l`、`C-h` `C-j` `C-k` `C-l` | 左、下、上、右のペインを選びます | なし |
| `H` `J` `K` `L` | ペインのサイズを変えます。繰り返し可能 | なし |
| `\|` と `%`、`-` と `"` | 現在のフォルダーで右か下に分割します | なし |
| `\` と `_` | ウィンドウの全幅か全高で分割します | なし |
| `*` | 長い辺に沿って分割します | `_smart_split_key` |
| `c` | 現在のフォルダーで新しいウィンドウを開きます | `_new_window_path` |
| `@` | 別のウィンドウからペインを結合します | `_join_key` |
| `!` | ペインを独立したウィンドウに分けます | `_break_key` |
| `{` `}` | 前か次のペインと入れ替えます。繰り返し可能 | `_swap_prev_key`、`_swap_next_key` |
| `+` | ペインを左上に昇格させます | `_promote_key` |
| `m`、`=` | ペインに印を付け、印のペインと入れ替えます | `_mark_key`、`_swap_mark_key` |

次のキーは、オプションで指定するまで割り当てられません。`_sync_key` はペインの同期を切り替え、`_swap_window_left_key` と `_swap_window_right_key` はウィンドウを動かし、`_move_window_key` は別のセッションへ移し、`_kill_window_key` は閉じ、`_layout_even_h_key`、`_layout_even_v_key`、`_layout_main_v_key` はレイアウトを選び、`_respawn_key` はペインを再起動し、`_capture_key` はスクロールバックを保存し、`_pane_name_key` はペインに名前を付け、`_scratch_key` はスクラッチポップアップを開き、`_zoom_key` はパワーズームを実行します。

古い tmux にない機能はバージョン確認で外れます。全幅の分割は 2.3、印は 2.1、ペイン名と端での停止は 2.6、`{top-left}` への昇格は 3.0、スクラッチポップアップは 3.2、パワーズームは 3.0、フォーカスサイズは 3.1、説明は 3.1 が必要です。

<a id="画面"></a>

## 画面

<details>
<summary><code>make screens</code>で本物のtmuxの中から録画したすべての画面。押したキーはステータスラインに表示されます</summary>
<br>

<table>
<tr>
<td width="50%" valign="top"><img src="screens/splits.png" alt="pain-control-revamped: 分割、移動、リサイズ、昇格、長い辺での分割"><br><sub>分割、移動、リサイズ、昇格、長い辺での分割。<code>hero.tape</code>より</sub></td>
<td width="50%" valign="top"><img src="screens/window.png" alt="pain-control-revamped: 現在のフォルダーでの新しいウィンドウ"><br><sub>現在のフォルダーでの新しいウィンドウ。<code>keys.tape</code>より</sub></td>
</tr>
<tr>
<td width="50%" valign="top"><img src="screens/break.png" alt="pain-control-revamped: 独立したウィンドウに分けたペイン"><br><sub>独立したウィンドウに分けたペイン。<code>keys.tape</code>より</sub></td>
<td width="50%" valign="top"><img src="screens/join.png" alt="pain-control-revamped: 別のウィンドウからのペインの結合"><br><sub>別のウィンドウからのペインの結合。<code>keys.tape</code>より</sub></td>
</tr>
<tr>
<td width="50%" valign="top"><img src="screens/mark.png" alt="pain-control-revamped: 印を付けて入れ替え"><br><sub>印を付けて入れ替え。<code>keys.tape</code>より</sub></td>
<td width="50%" valign="top"><img src="screens/swap.png" alt="pain-control-revamped: 前と次のペインとの入れ替え"><br><sub>前と次のペインとの入れ替え。<code>keys.tape</code>より</sub></td>
</tr>
<tr>
<td width="50%" valign="top"><img src="screens/titles.png" alt="pain-control-revamped: 枠のペインタイトル"><br><sub>枠のペインタイトル。<code>options.tape</code>より</sub></td>
<td width="50%" valign="top"><img src="screens/sync.png" alt="pain-control-revamped: 同期したペイン"><br><sub>同期したペイン。<code>options.tape</code>より</sub></td>
</tr>
<tr>
<td width="50%" valign="top"><img src="screens/vim-nowrap.png" alt="pain-control-revamped: vim ナビゲーションと端での停止"><br><sub>vim ナビゲーションと端での停止。<code>options.tape</code>より</sub></td>
<td width="50%" valign="top"><img src="screens/scratch-popup.png" alt="pain-control-revamped: スクラッチポップアップ"><br><sub>スクラッチポップアップ。<code>options.tape</code>より</sub></td>
</tr>
<tr>
<td width="50%" valign="top"><img src="screens/list.png" alt="pain-control-revamped: list"><br><sub><code>list</code>。<code>stills.tape</code>より</sub></td>
<td width="50%" valign="top"><img src="screens/json.png" alt="pain-control-revamped: list --json"><br><sub><code>list --json</code>。<code>stills.tape</code>より</sub></td>
</tr>
<tr>
<td width="50%" valign="top"><img src="screens/doctor.png" alt="pain-control-revamped: doctor"><br><sub><code>doctor</code>。<code>stills.tape</code>より</sub></td>
<td width="50%" valign="top"><img src="screens/menu.png" alt="pain-control-revamped: メニュー"><br><sub>メニュー。<code>stills.tape</code>より</sub></td>
</tr>
<tr>
<td width="50%" valign="top"><img src="screens/plain-menu.png" alt="pain-control-revamped: gumなしのメニュー"><br><sub>gumなしのメニュー。<code>stills.tape</code>より</sub></td>
<td width="50%" valign="top"><img src="screens/plain-apply.png" alt="pain-control-revamped: メニューからの apply"><br><sub>メニューからの <code>apply</code>。<code>stills.tape</code>より</sub></td>
</tr>
<tr>
<td width="50%" valign="top"><img src="screens/version.png" alt="pain-control-revamped: バージョン"><br><sub>バージョン。<code>stills.tape</code>より</sub></td>
<td width="50%" valign="top"><img src="screens/error.png" alt="pain-control-revamped: 不明なコマンド"><br><sub>不明なコマンド。<code>stills.tape</code>より</sub></td>
</tr>
<tr>
<td width="50%" valign="top"><img src="screens/themes.png" alt="pain-control-revamped: 6つのテーマのヘッダー"><br><sub>6つのテーマのヘッダー。<code>themes.tape</code>より</sub></td>
<td width="50%" valign="top"><img src="screens/help.png" alt="pain-control-revamped: ヘルプページ"><br><sub>ヘルプページ。<code>help.tape</code>より</sub></td>
</tr>
<tr>
<td width="50%" valign="top"><img src="screens/accent.png" alt="pain-control-revamped: PAIN_CONTROL_REVAMPED_ACCENTによるアクセント"><br><sub><code>PAIN_CONTROL_REVAMPED_ACCENT</code>によるアクセント。<code>stills.tape</code>より</sub></td>
<td width="50%" valign="top"><img src="screens/zoom.png" alt="pain-control-revamped: 専用のウィンドウに移したペインと、その隣に開いたペイン"><br><sub>専用のウィンドウに移したペインと、その隣に開いたペイン。<code>zoom.tape</code>より</sub></td>
</tr>
<tr>
<td width="50%" valign="top"><img src="screens/zoom-placeholder.png" alt="pain-control-revamped: ペインの場所を保つプレースホルダー"><br><sub>ペインの場所を保つプレースホルダー。<code>zoom.tape</code>より</sub></td>
<td width="50%" valign="top"><img src="screens/zoom-back.png" alt="pain-control-revamped: 元の場所に戻ったペイン"><br><sub>元の場所に戻ったペイン。<code>zoom.tape</code>より</sub></td>
</tr>
<tr>
<td width="50%" valign="top"><img src="screens/focus.png" alt="pain-control-revamped: 70% に広がったフォーカス中のペイン"><br><sub>70% に広がったフォーカス中のペイン。<code>zoom.tape</code>より</sub></td>
<td width="50%" valign="top"></td></tr>
</table>

</details>

## 移植性

プラグインは POSIX `sh` です。CI は下の各行ですべてのテストを実行します。

| シェル | 状態 |
|:------|:-------|
| `dash`、macOS の `/bin/sh` | 対応 |
| `bash` 3.2 と 5.x、システムの `zsh` と Homebrew の `zsh` | 対応 |

| システム | 状態 |
|:-------|:-------|
| macOS | Apple Silicon と Intel の Tahoe。付属のツール、Homebrew の GNU ツール、Homebrew の uutils で確認 |
| Linux | x86_64 と arm64 の Ubuntu 26.04。GNU coreutils、uutils、BusyBox で確認 |

## 開発

| コマンド | 実行内容 |
|:--------|:-------------|
| `make fmt` | すべてのスクリプトに shfmt `-i 2` をかけます |
| `make lint` | shfmt、ShellCheck、mandoc、yamllint、actionlint を、指摘ゼロで通します |
| `make test` | システムの `sh` で bats のテスト |
| `make test-all` | インストール済みのすべてのシェルでテスト。macOS では bash と zsh の両方のビルドを含みます |
| `make test-linux` | Ubuntu のコンテナでテスト |
| `make coverage` | この Mac と Ubuntu のコンテナで bashcov を実行し、合算して 100 パーセントで判定します |
| `make screens` | 上の画面を、本物のプラグインから tmux の中で VHS で録画します。macOS で実行します |
| `make install` | コマンド、manページ、補完を `PREFIX` の下に置きます |

macOS では、`brew bundle` を実行すると、これらのターゲットが使うツールがすべて [`Brewfile`](Brewfile) からインストールされます。

コミットは Conventional Commits の形式に従い、そのまま `main` に入ります。`main` で `ci` が成功すると、`release.yml` が semantic-release を実行します。前回のタグ以降に `feat` か `fix` があればリリースを公開し、バージョン定数を更新し、変更内容を [`CHANGELOG.md`](CHANGELOG.md) に追加します。

## ライセンス

[MIT](LICENSE)、copyright Gustavo Franco。

<!-- family:begin -->

## tmux-revamped ファミリー

このプラグインは tmux-revamped ファミリーの一員です。すべてのメンバーが [`FAMILY.md`](FAMILY.md) の同じ規約と同じ共有ライブラリを持ちます。メンバーは一緒にインストールする前提で作られており、ほかのメンバーが使うキーや tmux オプションを使うメンバーはありません。

あるメンバーで見つかった不具合は、修正完了とする前に全メンバーで同じ不具合を探します。

| メンバー | 機能 |
|---|---|
| [`tmux-autoreload-revamped`](https://github.com/tmux-revamped/tmux-autoreload-revamped) | tmuxの設定を編集して保存するだけで、キーもコマンドも使わずに自動で再読み込みされます |
| [`tmux-battery-revamped`](https://github.com/tmux-revamped/tmux-battery-revamped) | tmuxのステータスバーに電池の状態を表示し、ステータスの描画を一切止めません |
| [`tmux-bluetooth-revamped`](https://github.com/tmux-revamped/tmux-bluetooth-revamped) | 接続中のすべてのBluetooth機器とその電池残量をtmuxのステータスバーに表示し、描画を止めません |
| [`tmux-cpu-revamped`](https://github.com/tmux-revamped/tmux-cpu-revamped) | CPUの負荷、温度、周波数をtmuxのステータスバーに表示し、描画を一切止めません |
| [`tmux-disk-revamped`](https://github.com/tmux-revamped/tmux-disk-revamped) | tmuxのステータスバーにディスク使用量を表示し、ステータスの描画を一切止めません |
| [`tmux-extract-revamped`](https://github.com/tmux-revamped/tmux-extract-revamped) | 画面上の URL、パス、ハッシュなどのトークンを fzf で選び、カーソル位置に入力します。純粋なシェルだけで動きます |
| [`tmux-fzf-revamped`](https://github.com/tmux-revamped/tmux-fzf-revamped) | ポップアップ内の fzf ピッカーから、tmux のセッション、ウィンドウ、ペインの切り替え、終了、名前変更、作成を行います |
| [`tmux-git-revamped`](https://github.com/tmux-revamped/tmux-git-revamped) | アクティブなペインのgitブランチ、変更、プロバイダーの件数を、描画を止めずにtmuxのステータスバーに表示します |
| [`tmux-gpu-revamped`](https://github.com/tmux-revamped/tmux-gpu-revamped) | NVIDIA、AMD、Intel、Apple の GPU の負荷、温度、クロック、電力、メモリを tmux のステータスバーに表示します |
| [`tmux-kube-revamped`](https://github.com/tmux-revamped/tmux-kube-revamped) | 現在の Kubernetes コンテキストと名前空間を、kubectl を使わずに kubeconfig から解析して tmux のステータスバーに表示します |
| [`tmux-launcher-revamped`](https://github.com/tmux-revamped/tmux-launcher-revamped) | 任意の TUI アプリを、現在のペインのディレクトリでポップアップまたはウィンドウとして起動します。アプリごとにキーを設定できます |
| [`tmux-logging-revamped`](https://github.com/tmux-revamped/tmux-logging-revamped) | 任意のペインをファイルに保存します。ライブのログ記録、スクロールバック全体、1 回限りのスクリーンショットに対応します |
| [`tmux-music-revamped`](https://github.com/tmux-revamped/tmux-music-revamped) | 再生中の曲をステータスバーに表示し、ステータスの描画を止めません |
| [`tmux-network-revamped`](https://github.com/tmux-revamped/tmux-network-revamped) | ネットワークのスループットをステータスバーに表示し、描画を止めません |
| [`tmux-pain-control-revamped`](https://github.com/tmux-revamped/tmux-pain-control-revamped) | **このプラグイン**、tmux のペインとウィンドウの操作キー。tmux のバージョンに対応し、vim と共存でき、どの prefix キーも無効にできます |
| [`tmux-persist-revamped`](https://github.com/tmux-revamped/tmux-persist-revamped) | tmuxのすべてのセッション、ウィンドウ、ペインを保存し、タイマーで自動保存して、再起動後にすべて復元します |
| [`tmux-plugin-template`](https://github.com/tmux-revamped/tmux-plugin-template) | tmux-revampedプラグインの出発点です。共有ライブラリ、batsハーネス、CIを含みます |
| [`tmux-pomodoro-revamped`](https://github.com/tmux-revamped/tmux-pomodoro-revamped) | すべての状態をtmuxオプションに保持し、一時ファイルを使わない、tmuxステータスバーのポモドーロタイマーです |
| [`tmux-ram-revamped`](https://github.com/tmux-revamped/tmux-ram-revamped) | RAM、スワップ、メモリプレッシャーをtmuxのステータスバーに表示します。計測はバックグラウンドで行うため描画を待たせません |
| [`tmux-reorder-revamped`](https://github.com/tmux-revamped/tmux-reorder-revamped) | tmuxのステータスバー上でウィンドウのタブをマウスでドラッグして、そのウィンドウを移動します |
| [`tmux-scroll-revamped`](https://github.com/tmux-revamped/tmux-scroll-revamped) | 自分でスクロールできるアプリにはマウスホイールを渡し、それ以外ではtmuxのコピーモードに入ります |
| [`tmux-sensible-revamped`](https://github.com/tmux-revamped/tmux-sensible-revamped) | tmuxのバージョンと端末に合わせて適用され、ユーザーが設定したオプションには触れない、妥当な初期設定です |
| [`tmux-tiling-revamped`](https://github.com/tmux-revamped/tmux-tiling-revamped) | tmuxのタイル型ウィンドウ管理です。BSPのdwindleとspiralを含む8つのレイアウトと、レイアウトの取り消しがあります |
| [`tmux-time-revamped`](https://github.com/tmux-revamped/tmux-time-revamped) | ステータスバーにローカル時計と世界時計を時間帯ごとの色で表示し、カウントダウンと夏時間の警告も出します |
| [`tmux-weather-revamped`](https://github.com/tmux-revamped/tmux-weather-revamped) | wttr.inの天気をバックグラウンドで取得し、ステータスバーを待たせずに表示します |

<!-- family:end -->
