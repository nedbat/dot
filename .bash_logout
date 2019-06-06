# Run when logging out

if [[ -n $VIRTUAL_ENV ]]; then
    # Deactivate virtualenvs, so that temporary ones are cleaned up.
    deactivate
fi
