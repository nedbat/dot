# Secure environment variables from 1password.
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
    op item get ${PWD/#$HOME/'~'} --fields label=vars --vault "Environment variables" --format json
}

# Define the local secure variables.
opvars() {
    eval $(_opvar_data | python ~/.config/shellrc/opvars.py export)
}

# Undefine the local secure variables.
unopvars() {
    eval $(_opvar_data | python ~/.config/shellrc/opvars.py unset)
}
