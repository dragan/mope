if [[ ! -o interactive ]]; then
    return
fi

compctl -K _mope mope

_mope() {
    local word words completions
    read -cA words
    word="${words[2]}"

    if [ "${#words}" -eq 2 ]; then
        completions="$(mope commands)"
    else
        completions="$(mope completions "${word}")"
    fi

    reply=("${(ps:\n:)completions}")
}