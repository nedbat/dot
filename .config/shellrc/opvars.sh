# Secure environment variables from 1password.
# In vault "Environment variables", create entries named for directories (like
# "~/coverage").  The "vars" field is formatted like this:
#
#       # Comments are fine
#       VARIABLE_NAME=secret_value_123123123123123
#       OTHER_KEY=moar_secrets
#

_opvar_data() {
    op item get ${PWD/#$HOME/'~'} --fields label=vars --vault "Environment variables" --format json |
    jq -r .value |
    sed -e '/^#/d' -e '/^$/d'
}

# Define the local secure variables.
opvars() {
    local jdata=$(_opvar_data)
    if [[ -n $jdata ]]; then
        export $jdata
    fi
}

# Undefine the local secure variables.
unopvars() {
    local jdata=$(_opvar_data)
    if [[ -n $jdata ]]; then
        unset $(echo $jdata | sed -e '/./s/=.*$//')
    fi
}
