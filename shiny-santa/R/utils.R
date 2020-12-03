to_title_case = function(x) {
  x = tolower(x)
  substr(x, 1, 1) = toupper(substr(x, 1, 1))
  return(x)
}

get_default_env_var = function(var_name, default_val) {
  if (Sys.getenv(var_name) == "") {
    res = default_val
  } else {
    res = Sys.getenv(var_name)
  }
  return(res)
}
