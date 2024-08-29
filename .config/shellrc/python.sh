# Pythons
alias p='python3'
alias te='tox -q -e'

ten0k() {
    tox -q -e $1 -- -n 0 -k $2 $3 $4 $5
}

# For special cases, define a local function:
#   ten0kq() {
#       .tox/$1/bin/python3 igor.py test_with_tracer c -n 0 -k $2
#   }

export PYTHONSTARTUP=$XDG_CONFIG_HOME/startup.py
export _PYTHON_BIN="$(python3 -c "import sysconfig; print(sysconfig.get_path('scripts'))")"
export PATH="$PATH:$_PYTHON_BIN"
if [[ -w /tmp ]]; then
    export PYTHONPYCACHEPREFIX=/tmp/$(whoami)-pyc
    mkdir -p $PYTHONPYCACHEPREFIX
    chmod 700 $PYTHONPYCACHEPREFIX
fi

# Virtualenvwrapper support.
# Use ~/bin/install-pip-etc.sh to get virtualenv and virtualenvwrapper installed
# in all versions of Python.  Shouldn't need anything in .local.
virtualenvwrappersh=$(command -v virtualenvwrapper.sh)
workon_homes=(
    /usr/local/virtualenvs
    $HOME/.virtualenvs
    )
workon_home=$(_first_of "${workon_homes[@]}")
if [[ -r "$virtualenvwrappersh" ]] && [[ -d "$workon_home" ]]; then
    export WORKON_HOME=$workon_home
    export VIRTUALENVWRAPPER_PYTHON=$(python3 -c "import os.path,sys; print(os.path.realpath(sys.executable))")
    source $virtualenvwrappersh
else
    if [[ -n $PS1 ]]; then
        echo "No virtualenvwrapper for $(python3 -V): $_PYTHON_BIN"
        echo "  to fix:"
        echo "  PIP_REQUIRE_VIRTUALENV= python3 -m pip install virtualenvwrapper"
    fi
fi

if [[ -d /usr/local/pipx ]]; then
    export PIPX_HOME=/usr/local/pipx
fi

export PIP_REQUIRE_VIRTUALENV=true
export PIP_DISABLE_PIP_VERSION_CHECK=1

unset _PYTHON_BIN

# miniconda
# Conda likes to change the prompt, use this to stop it so other fancier prompts win:
#   conda config --set changeps1 False
if [[ -d /usr/local/miniconda ]]; then
    eval "$(/usr/local/miniconda/bin/conda shell.$SHELL_TYPE hook)"
fi

if [[ -n $PS1 ]]; then
    # If we are already in a Python virtualenv, re-activate it to make sure it wins
    # the $PATH wars.
    if [[ -n $VIRTUAL_ENV ]]; then
        echo "Reactivating $VIRTUAL_ENV.."
        source $VIRTUAL_ENV/bin/activate
    fi
fi
