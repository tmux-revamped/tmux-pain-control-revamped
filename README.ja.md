<div align="center">

# tmux-pain-control-revamped

<strong>tmux のペインとウィンドウの操作キー。tmux のバージョンに対応し、vim と共存でき、どの prefix キーも無効にできます。</strong>

[English](README.md) | 日本語 | [简体中文](README.zh-Hans.md) | [繁體中文（香港）](README.zh-HK.md)

[![family](https://img.shields.io/github/actions/workflow/status/tmux-revamped/tmux-pain-control-revamped/family.yml?branch=main&style=flat-square&label=family)](https://github.com/tmux-revamped/tmux-pain-control-revamped/actions/workflows/family.yml)
[![tests](https://img.shields.io/github/actions/workflow/status/tmux-revamped/tmux-pain-control-revamped/tests.yml?branch=main&style=flat-square&label=tests)](https://github.com/tmux-revamped/tmux-pain-control-revamped/actions/workflows/tests.yml)
[![release](https://img.shields.io/github/v/release/tmux-revamped/tmux-pain-control-revamped?style=flat-square&label=release)](https://github.com/tmux-revamped/tmux-pain-control-revamped/releases/latest)
[![openssf scorecard](https://img.shields.io/ossf-scorecard/github.com/tmux-revamped/tmux-pain-control-revamped?style=flat-square&label=openssf%20scorecard)](https://scorecard.dev/viewer/?uri=github.com/tmux-revamped/tmux-pain-control-revamped)
[![license](https://img.shields.io/github/license/tmux-revamped/tmux-pain-control-revamped?style=flat-square&label=license)](LICENSE)

<p align="center">
  <a href="#what-it-does">機能</a> |
  <a href="#installation">インストール</a> |
  <a href="#usage">使い方</a> |
  <a href="#configuration">設定</a> |
  <a href="#key-bindings">キーバインド</a> |
  <a href="#how-it-works">仕組み</a>
</p>

</div>

既定で割り当てる prefix キーは **27** 個、任意で有効にできるキーは **12** 個、オプションは **28** 個、tmux **3.2** 以降に対応します。

---

<a id="what-it-does"></a>

## 機能

ペインの移動、サイズ変更、現在のディレクトリを引き継ぐ分割、ペインとウィンドウの移動を割り当てます。[tmux-pain-control](https://github.com/tmux-plugins/tmux-pain-control) を書き直して操作を増やしたもので、tmux 自身のキーの一部を意図的に置き換えます。

| 機能 | オプション |
|:-----|:-----------|
| 分割と新しいウィンドウを現在のペインのディレクトリで開く。`"` と `%` も対象 | `c` には `@new_window_path` |
| 指定したセル数だけサイズを変える | `@pane_resize` |
| ペインの長い辺の方向に分割する | `@pane_control_smart_split_key` |
| ペインの取り込み、切り出し、入れ替え、昇格、マーク | `@pane_control_join_key` などのペイン用キー |
| prefix なしの `Ctrl+h/j/k/l` で vim の分割と tmux のペインを移動する | `@pane_control_vim_navigation` |
| ペインの選択をウィンドウの端で止める | `@pane_control_no_wrap` |
| 一覧にある任意のキーを無効にする | `@pane_control_disabled_keys` |

<a id="requirements"></a>

## 動作要件

| 要件 | バージョン |
|:-----|:-----------|
| tmux | 3.2 以降 |
| bash | 3.2 以降 |

Linux と macOS で、BSD、GNU、uutils のいずれの coreutils でも動作します。vim の検出を伴うナビゲーションは、`ps` と `grep` でペイン内の vim を判定します。

<a id="installation"></a>

## インストール

[TPM](https://github.com/tmux-plugins/tpm) を使う場合は、`~/.tmux.conf` にプラグインを追加して `prefix + I` を押します。

```tmux
set -g @plugin 'tmux-revamped/tmux-pain-control-revamped'
```

手動でインストールする場合は、リポジトリをクローンし、`~/.tmux.conf` からエントリポイントを実行します。

```bash
git clone https://github.com/tmux-revamped/tmux-pain-control-revamped ~/.tmux/plugins/tmux-pain-control-revamped
```

```tmux
run-shell ~/.tmux/plugins/tmux-pain-control-revamped/pain-control-revamped.tmux
```

<a id="usage"></a>

## 使い方

インストール後は、[キーバインド](#key-bindings)にあるキーを prefix の後に押して使います。`prefix + |` は右に、`prefix + -` は下に、どちらも現在のディレクトリで分割します。`prefix + h/j/k/l` でペインを移動し、`prefix + H/J/K/L` でサイズを変えます。

使いたい任意のキーを有効にし、ほかで使うキーは無効にします。

```tmux
set -g @pane_control_sync_key 'S'
set -g @pane_control_swap_window_left_key '<'
set -g @pane_control_swap_window_right_key '>'
set -g @pane_control_scratch_key 'g'
set -g @pane_control_scratch_command 'htop'

set -g @pane_control_disabled_keys 'c, *'
set -g @pane_resize 10
```

[vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator) の tmux 側を置き換えるには次のように設定します。

```tmux
set -g @pane_control_vim_navigation 'on'
```

これで `Ctrl+h/j/k/l` は、vim にフォーカスがあるときは vim の分割を、それ以外は tmux のペインを移動し、`Ctrl+\` は直前のペインに移ります。prefix なしの `Ctrl+l` を使うため、`prefix + C-l` で画面のクリアを送ります。vim 側には、エディターに vim-tmux-navigator プラグインが引き続き必要です。

<a id="configuration"></a>

## 設定

| オプション | 既定値 | 意味 |
|:-----------|:-------|:-----|
| `@pane_resize` | `5` | サイズ変更キー 1 回で動かすセル数 |
| `@new_window_path` | `true` | `true`、`on`、`1` のとき、`c` に現在のディレクトリで新しいウィンドウを開く操作を割り当てます。それ以外の値では `c` を変更しません |
| `@pane_control_disabled_keys` | 空 | 割り当てないキー。スペースかカンマで区切ります。例：`c, <` |
| `@pane_control_no_wrap` | `off` | `on` にすると、`h/j/k/l` の選択が反対側に回り込まず、ウィンドウの端で止まります |
| `@pane_control_pane_titles` | `off` | `on` にすると、ペインの上の枠にペイン番号とタイトルを表示します |
| `@pane_control_vim_navigation` | `off` | `on` にすると、vim を検出する prefix なしの `Ctrl+h/j/k/l` と `Ctrl+\` を割り当てます |
| `@pane_control_vim_pattern` | vim-tmux-navigator のパターン | ペインで vim が動いていると判定するプロセス名の正規表現 |
| `@pane_control_scratch_command` | 空 | スクラッチポップアップで実行するコマンド。空ならシェルを開きます |
| `@pane_control_smart_split_key` | `*` | スマート分割 |
| `@pane_control_join_key` | `@` | プロンプトの後、別のウィンドウからペインを取り込みます |
| `@pane_control_break_key` | `!` | 現在のペインを独立したウィンドウに切り出します |
| `@pane_control_swap_prev_key` | `{` | 前のペインと入れ替えます |
| `@pane_control_swap_next_key` | `}` | 次のペインと入れ替えます |
| `@pane_control_promote_key` | `+` | ペインを左上の位置に入れ替えます |
| `@pane_control_mark_key` | `m` | ペインをマークします |
| `@pane_control_swap_mark_key` | `=` | マークしたペインと入れ替えます |
| `@pane_control_sync_key` | 空 | `synchronize-panes` を切り替えて状態を表示します |
| `@pane_control_swap_window_left_key` | 空 | ウィンドウを 1 つ左に移動します |
| `@pane_control_swap_window_right_key` | 空 | ウィンドウを 1 つ右に移動します |
| `@pane_control_move_window_key` | 空 | プロンプトの後、ウィンドウを別のセッションに移動します |
| `@pane_control_kill_window_key` | 空 | 確認の後、ウィンドウを終了します |
| `@pane_control_layout_even_h_key` | 空 | `even-horizontal` レイアウト |
| `@pane_control_layout_even_v_key` | 空 | `even-vertical` レイアウト |
| `@pane_control_layout_main_v_key` | 空 | `main-vertical` レイアウト |
| `@pane_control_respawn_key` | 空 | 確認の後、ペインを再起動します |
| `@pane_control_capture_key` | 空 | `~/tmux-scrollback.log` を候補とするプロンプトの後、スクロールバック全体をファイルに保存します |
| `@pane_control_pane_name_key` | 空 | プロンプトの後、ペインのタイトルを設定します |
| `@pane_control_scratch_key` | 空 | 現在のディレクトリで 80% のポップアップシェルを開きます |

キーのオプションを空にすると何も割り当てません。このプラグインは内部状態のオプションを持ちません。

<a id="key-bindings"></a>

## キーバインド

### 既定で割り当てるキー

いずれも prefix の後に押します。移動、サイズ変更、分割、`c` のキーは変更できず、`@pane_control_disabled_keys` で無効にすることだけができます。

| キー | 動作 | 連打 |
|:-----|:-----|:----:|
| `h` `j` `k` `l`、`C-h` `C-j` `C-k` `C-l` | 左、下、上、右のペインを選択 | 不可 |
| `H` `J` `K` `L` | ペインのサイズを `@pane_resize` セル変更 | 可 |
| `\|` と `%` | 現在のディレクトリで右に分割 | 不可 |
| `-` と `"` | 現在のディレクトリで下に分割 | 不可 |
| `\` | ウィンドウの全幅で分割 | 不可 |
| `_` | ウィンドウの全高で分割 | 不可 |
| `*` | 長い辺の方向に分割 | 不可 |
| `c` | 現在のディレクトリで新しいウィンドウ | 不可 |
| `@` | 別のウィンドウからペインを取り込む | 不可 |
| `!` | ペインを独立したウィンドウに切り出す | 不可 |
| `{` `}` | 前または次のペインと入れ替える | 可 |
| `+` | ペインを左上の位置に昇格 | 不可 |
| `m` | ペインをマーク | 不可 |
| `=` | マークしたペインと入れ替える | 不可 |

`pain-control` は tmux-revamped ファミリーで宣言された上書き役のため、これらのキーは意図的に tmux の標準キーを置き換えます。

### 任意で有効にするキー

バージョン 2.0.0 でこれらの割り当ては解除されました。オプションに以前のキーを設定すると元に戻ります。

| オプション | 以前のキー | 動作 |
|:-----------|:----------:|:-----|
| `@pane_control_sync_key` | `S` | ペインの同期入力を切り替え |
| `@pane_control_swap_window_left_key` | `<` | ウィンドウを左に移動 |
| `@pane_control_swap_window_right_key` | `>` | ウィンドウを右に移動 |
| `@pane_control_move_window_key` | `.` | ウィンドウを別のセッションに移動 |
| `@pane_control_kill_window_key` | `&` | ウィンドウを終了 |
| `@pane_control_layout_even_h_key` | `E` | `even-horizontal` レイアウト |
| `@pane_control_layout_even_v_key` | `V` | `even-vertical` レイアウト |
| `@pane_control_layout_main_v_key` | `B` | `main-vertical` レイアウト |
| `@pane_control_respawn_key` | `R` | ペインを再起動 |
| `@pane_control_capture_key` | `C` | スクロールバックを保存 |
| `@pane_control_pane_name_key` | `P` | ペインに名前を付ける |
| `@pane_control_scratch_key` | `g` | スクラッチポップアップ |

### vim を検出するナビゲーション

`@pane_control_vim_navigation` を `on` にすると、ルートテーブルと `copy-mode-vi` に `C-h`、`C-j`、`C-k`、`C-l`、`C-\` も割り当て、`prefix + C-l` を画面のクリアに割り当て直します。これらには `@pane_control_disabled_keys` は適用されません。

<a id="how-it-works"></a>

## 仕組み

tmux がプラグインを読み込むと、[`pain-control-revamped.tmux`](pain-control-revamped.tmux) が [`src/pain.sh`](src/pain.sh) を 1 回実行します。スクリプトはオプションと tmux のバージョンを読み取り、各キーに `bind-key` を実行します。その後、バックグラウンドで動くものはありません。

各キーには `-N` の説明が付くため、`prefix + ?` で説明付きの一覧を表示できます。tmux 3.2 未満でも、スクリプトのバージョン確認によって、その tmux にない機能は割り当てません。全幅・全高の分割は 2.3、マークは 2.1、ペイン名と端での停止は 2.6、`{top-left}` を使う昇格は 3.0、スクラッチポップアップは 3.2 が必要です。

vim を検出するナビゲーションを有効にすると、各キーはペインの TTY に対して `ps` を実行し、プロセス名を `@pane_control_vim_pattern` と照合します。一致すればキーを vim に送り、一致しなければ tmux がペインを選択します。

バージョンとキーの補助関数は [`src/lib/pain/pain.sh`](src/lib/pain/pain.sh) にあります。`PAIN_DRY_RUN` を設定すると、スクリプトは tmux のコマンドを実行せずに表示します。テストスイートはこれを使ってキーの割り当てを確認します。

<a id="development"></a>

## 開発

| コマンド | 内容 |
|:---------|:-----|
| `make test` | bats のテストスイートを実行します |
| `make lint` | すべてのシェルファイルに shellcheck を実行します |
| `make coverage` | Linux で kcov を使って行カバレッジを測定し、95% 未満なら失敗します |

変更点は [CHANGELOG.md](CHANGELOG.md) にあります。

<a id="license"></a>

## ライセンス

[MIT](LICENSE)

<!-- family:begin -->

## tmux-revamped ファミリー

このプラグインは tmux-revamped ファミリーの一員です。すべてのメンバーが [`FAMILY.md`](FAMILY.md) の同じ規約、`family/` 配下の同じツール、同じ共有ライブラリを持ち、チェックサムの一覧によってバイト単位で同一に保たれています。メンバーは一緒にインストールする前提で作られており、ほかのメンバーが使うキーや tmux オプションを使うメンバーはありません。

あるメンバーで見つかった不具合は、修正完了とする前に全メンバーで同じ不具合を探します。この義務は記憶に頼らず規約に書かれており、`family/bin/sweep` がその作業を行います。

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
| [`tmux-plugin-template`](https://github.com/tmux-revamped/tmux-plugin-template) | tmux-revampedプラグインの出発点です。共有ライブラリ、batsハーネス、CI、ファミリーのツールを含みます |
| [`tmux-pomodoro-revamped`](https://github.com/tmux-revamped/tmux-pomodoro-revamped) | すべての状態をtmuxオプションに保持し、一時ファイルを使わない、tmuxステータスバーのポモドーロタイマーです |
| [`tmux-ram-revamped`](https://github.com/tmux-revamped/tmux-ram-revamped) | RAM、スワップ、メモリプレッシャーをtmuxのステータスバーに表示します。計測はバックグラウンドで行うため描画を待たせません |
| [`tmux-reorder-revamped`](https://github.com/tmux-revamped/tmux-reorder-revamped) | tmuxのステータスバー上でウィンドウのタブをマウスでドラッグして、そのウィンドウを移動します |
| [`tmux-scroll-revamped`](https://github.com/tmux-revamped/tmux-scroll-revamped) | 自分でスクロールできるアプリにはマウスホイールを渡し、それ以外ではtmuxのコピーモードに入ります |
| [`tmux-sensible-revamped`](https://github.com/tmux-revamped/tmux-sensible-revamped) | tmuxのバージョンと端末に合わせて適用され、ユーザーが設定したオプションには触れない、妥当な初期設定です |
| [`tmux-tiling-revamped`](https://github.com/tmux-revamped/tmux-tiling-revamped) | tmuxのタイル型ウィンドウ管理です。BSPのdwindleとspiralを含む8つのレイアウトと、レイアウトの取り消しがあります |
| [`tmux-time-revamped`](https://github.com/tmux-revamped/tmux-time-revamped) | ステータスバーにローカル時計と世界時計を時間帯ごとの色で表示し、カウントダウンと夏時間の警告も出します |
| [`tmux-weather-revamped`](https://github.com/tmux-revamped/tmux-weather-revamped) | wttr.inの天気をバックグラウンドで取得し、ステータスバーを待たせずに表示します |

### インストールの確認

全メンバーがディスク上にあれば、1 つのコマンドでメンバー間の衝突を報告できます。

```sh
family/bin/doctor --live
```

各メンバーと実行中の tmux サーバーを読み取り、重複したキー、重複したステータスのプレースホルダー、命名規則に合わないオプション、規約のバージョンが古いメンバーを報告します。

<!-- family:end -->
