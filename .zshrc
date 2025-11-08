########################################
# 環境変数
export LANG=ja_JP.UTF-8
 
 
# 色を使用出来るようにする
autoload -Uz colors
colors
 
# ヒストリの設定
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000
 
# プロンプト
# 1行表示
PROMPT="%~ %# "
 
# 単語の区切り文字を指定する
autoload -Uz select-word-style
select-word-style default
# ここで指定した文字は単語区切りとみなされる
# / も区切りと扱うので、^W でディレクトリ１つ分を削除できる
zstyle ':zle:*' word-chars " /=;@:{},|"
zstyle ':zle:*' word-style unspecified
 
########################################
# 補完
# 補完機能を有効にする
autoload -Uz compinit
compinit
 
# 補完で小文字でも大文字にマッチさせる
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
 
# ../ の後は今いるディレクトリを補完しない
zstyle ':completion:*' ignore-parents parent pwd ..
 
# sudo の後ろでコマンド名を補完する
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
                   /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin
 
# ps コマンドのプロセス名補完
zstyle ':completion:*:processes' command 'ps x -o pid,s,args'
 
 
########################################
# オプション
# 日本語ファイル名を表示可能にする
setopt print_eight_bit
 
# beep を無効にする
setopt no_beep
 
# フローコントロールを無効にする
setopt no_flow_control
 
# '#' 以降をコメントとして扱う
setopt interactive_comments
 
# cd したら自動的にpushdする
setopt auto_pushd

# 重複したディレクトリを追加しない
setopt pushd_ignore_dups
 
# 同時に起動したzshの間でヒストリを共有する
setopt share_history
 
# 同じコマンドをヒストリに残さない
setopt hist_ignore_all_dups
 
# スペースから始まるコマンド行はヒストリに残さない
setopt hist_ignore_space
 
# ヒストリに保存するときに余分なスペースを削除する
setopt hist_reduce_blanks
 
# 高機能なワイルドカード展開を使用する
setopt extended_glob
 
########################################
# キーバインド
 
# ^R で履歴検索をするときに * でワイルドカードを使用出来るようにする
bindkey '^R' history-incremental-pattern-search-backward
 
########################################
# エイリアス
 
alias la='ls -a'
alias ll='ls -l'
alias l='ls -1'
 
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
 
alias mkdir='mkdir -p'
 
# sudo の後のコマンドでエイリアスを有効にする
alias sudo='sudo '
 
# グローバルエイリアス
alias -g L='| less'
alias -g G='| grep'
 
# C で標準出力をクリップボードにコピーする
# mollifier delta blog : http://mollifier.hatenablog.com/entry/20100317/p1
if which pbcopy >/dev/null 2>&1 ; then
    # Mac
    alias -g C='| pbcopy'
elif which xsel >/dev/null 2>&1 ; then
    # Linux
    alias -g C='| xsel --input --clipboard'
elif which putclip >/dev/null 2>&1 ; then
    # Cygwin
    alias -g C='| putclip'
fi
 
 
 
########################################
# OS 別の設定
case ${OSTYPE} in
    darwin*)
        #Mac用の設定
        export CLICOLOR=1
        alias ls='ls -G -F'
        ;;
    linux*)
        #Linux用の設定
        alias ls='ls -F --color=auto'
        ;;
esac
 
# vim:set ft=zsh:


function auto_activate_venv() {
    # カラーコードの定義
    local GREEN='\033[0;32m'
    local YELLOW='\033[0;33m'
    local NC='\033[0m' # No Color (リセット)

    # 現在のvenv環境を非アクティブ化
    if [[ -n "$VIRTUAL_ENV" ]]; then
        local current_venv=$(basename "$VIRTUAL_ENV")
        deactivate
        echo -e "${YELLOW}Deactivated virtual environment: ${current_venv}${NC}"
    fi

    # venvディレクトリを探索
    local venv_paths=("./venv/bin/activate" "./.venv/bin/activate" "env/bin/activate")
    
    for venv_path in "${venv_paths[@]}"; do
        if [[ -f "$venv_path" ]]; then
            source "$venv_path"
            echo -e "${GREEN}Activated virtual environment: $(basename $(dirname $(dirname $venv_path)))${NC}"
            return
        fi
    done
}

# cdコマンドのオーバーライド
function cd() {
    # 元のcdコマンドを実行
    builtin cd "$@"
    
    # 移動先のディレクトリでvenv環境をチェック
    auto_activate_venv
}
auto_activate_venv

# プロンプトの設定
if [[ -n "$ZSH_VERSION" ]]; then
    # ZSH用の設定
    setopt PROMPT_SUBST
    #PS1='${VIRTUAL_ENV:+($(basename "$VIRTUAL_ENV")) }'"$PS1"
    #PS1='${VIRTUAL_ENV:+($(basename "$VIRTUAL_ENV")) }'"$PS1"
else
    # Bash用の設定
    PS1='${VIRTUAL_ENV:+($(basename "$VIRTUAL_ENV")) }'"$PS1"
fi

export PATH="/opt/homebrew/opt/unzip/bin:$PATH"

export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

