alias_add() {
  postload_eval "alias $1='$2'"
  preunload_eval "unalias $1"
}
