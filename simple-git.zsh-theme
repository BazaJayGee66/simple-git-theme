ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[cyan]%}("
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg[cyan]%})%{$reset_color%} "

ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg[magenta]%}"
ZSH_THEME_GIT_PROMPT_STAGED="%{$FG[178]%}"
ZSH_THEME_GIT_PROMPT_UNSTAGED="%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[red]%}"

function path_prompt {
  echo $(pwd | sed -e "s,^$HOME,~,")
}

function git_custom_prompt {
  local cb=$(git_current_branch)
  local GIT_STATUS=$(git status 2> /dev/null)

  STATUS_COLOR="$ZSH_THEME_GIT_PROMPT_CLEAN"

  if $(echo "$GIT_STATUS" | grep -i 'nothing to commit' &> /dev/null) ; then
    STATUS_COLOR="$ZSH_THEME_GIT_PROMPT_CLEAN"
  fi

  # is branch ahead?
  if $(echo "$(git log origin/$(current_branch)..HEAD 2> /dev/null)" | grep '^commit' &> /dev/null); then
    STATUS_COLOR="$ZSH_THEME_GIT_PROMPT_AHEAD"
  fi

  # is anything staged?
  if $(echo "$GIT_STATUS" | grep -E -e 'Changes to be committed' &> /dev/null); then
    STATUS_COLOR="$ZSH_THEME_GIT_PROMPT_STAGED"
  fi

  # is anything unstaged?
  if $(echo "$GIT_STATUS" | grep -E -e 'Changes not staged' &> /dev/null); then
    STATUS_COLOR="$ZSH_THEME_GIT_PROMPT_UNSTAGED"
  fi

  # is anything untracked?
  if $(echo "$GIT_STATUS" | grep 'Untracked files' &> /dev/null); then
    STATUS_COLOR="$ZSH_THEME_GIT_PROMPT_UNTRACKED"
  fi

  # is anything unmerged?
  if $(echo "$GIT_STATUS" | grep -E -e 'unmerged' &> /dev/null); then
    STATUS_COLOR="$ZSH_THEME_GIT_PROMPT_UNMERGED"
  fi

  if [ -n "$cb" ]; then
    echo "$ZSH_THEME_GIT_PROMPT_PREFIX$STATUS_COLOR${cb}$ZSH_THEME_GIT_PROMPT_SUFFIX"
  fi
}

local ret_status="%(?:%{$fg[green]%}>:%{$fg[red]%}>%s)"

PROMPT='%{$fg_bold[cyan]%}%c $(git_custom_prompt)${ret_status}%{$reset_color%} '