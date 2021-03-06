define-command -hidden file-detection %{ evaluate-commands %sh{
    if [ -z "${kak_opt_filetype}" ]; then
        mime=$(file -b --mime-type -L "${kak_buffile}")
        mime=${mime%;*}
        case "${mime}" in
            application/*+xml) filetype="xml" ;;
            image/*+xml) filetype="xml" ;; #SVG
            message/rfc822) filetype="mail" ;;
            text/x-shellscript) filetype="sh" ;;
            text/x-script.*) filetype="${mime#text/x-script.}" ;;
            text/x-*) filetype="${mime#text/x-}" ;;
            text/plain) exit ;;
            text/*)   filetype="${mime#text/}" ;;
            application/x-*) filetype="${mime#application/x-}" ;;
            application/*) filetype="${mime#application/}" ;;
            *) exit ;;
        esac
        if [ -n "${filetype}" ]; then
            printf "set-option buffer filetype '%s'\n" "${filetype}"
        fi
    fi
} }

hook global BufOpenFile .* file-detection
hook global BufWritePost .* file-detection
