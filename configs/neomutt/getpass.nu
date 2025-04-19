#/usr/bin/env nu

let key = 'bryleyhayter@gmail.com'

def main [name: string] {
    let pw = (cat $'($env.HOME)/.config/mutt/($key).secret' | complete)

    if (($pw | get exit_code) == 1) {
        print $'password not found, please save csv file at ~/.config/mutt/($key).secret'
    } else {
        $pw | get stdout | from csv | get $name | first
    }
}


# ╭───┬─────────────────────╮
# │ 0 │ SOME SECRET PASSWRD │
# ╰───┴─────────────────────╯
