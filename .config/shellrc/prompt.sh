# Set shell prompt, if we're interactive.
if [[ -n $PS1 ]]; then
    if command -v starship >/dev/null; then
        export STARSHIP_CONFIG=$XDG_CONFIG_HOME/starship.toml
        plain_prompt() {
            export PS1=$(printf "\n$ ")
        }
        fancy_prompt() {
            eval "$(starship init $SHELL_TYPE)"
        }
    else
        plain_prompt() {
            prompt_OFF
            export PS1=$(printf "\n$ ")
        }
        fancy_prompt() {
            source ~/bin/liquidprompt/liquidprompt
            lp_terminal_format 8
            export LP_PS1_PREFIX="${lp_terminal_format}██████ "
            if [[ $SHELL_TYPE != zsh ]]; then
                export LP_PS1_PREFIX="${SHELL_TYPE:0:1} "
            fi
        }
    fi
    fancy_prompt
fi
