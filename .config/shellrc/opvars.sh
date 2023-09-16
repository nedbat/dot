# Secure environment variables from 1password.
#
# In vault "Environment variables", create entries named for directories (like
# "~/coverage").  The "vars" field is formatted like this:
#
#       # Comments are fine
#       VARIABLE_NAME=secret_value_123123123123123
#       OTHER_KEY=moar_secrets
#
#       # Blank lines are fine. The value after = is used exactly.
#       # Only use quotes if you want quotes in the value.
#       CRAZY=this needs to be a whole string
#

_opvar_data() {
    op item get ${1:-${PWD/#$HOME/'~'}} --fields label=vars --vault "Environment variables" --format json
}

# Define the local secure variables.
#
#   opvars [name]
#
#   Loads the variables stored from the "name" item in the "Environment variables"
#   vault.  "name" defaults to the current directory, with $HOME replaced by "~".
#
opvars() {
    eval $(_opvar_data "$@" | python3 ~/.config/shellrc/opvars.py export)
}

# Undefine the local secure variables.
# 
#   deopvars
#
#   Unset all of the variables that have ever been set by `opvars`.
#
deopvars() {
    eval $(python3 ~/.config/shellrc/opvars.py unset)
}

# Other 1Password shell plugins.
if [[ -r ~/.config/op/plugins.sh ]]; then
    source ~/.config/op/plugins.sh
fi
