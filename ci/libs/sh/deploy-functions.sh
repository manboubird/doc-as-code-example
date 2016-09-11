source "${LIB_DIR}/sh/common-functions.sh"

build_mkdocs() {
  local doc_root="$1"
  local output_dir="$2"
  cd "${doc_root}"
  echo mkdocs build --clean --site-dir "${output_dir}"
  mkdocs build --clean --site-dir "${output_dir}"
}

rsync_uplaod() {
  log rsync_uplaod is not implemented yet
}

