# Load default repo
local({r <- getOption("repos")
       r["CRAN"] <- "http://cran.r-project.org" 
       options(repos=r)
})

# Set options for Rscript -e calls
if (requireNamespace("rprofile", quietly = TRUE)) {
  # Call here if needed
  # rprofile::set_repos()
  rprofile::set_startup_options()
}

if (interactive() && requireNamespace("rprofile", quietly = TRUE)) {
  rprofile::create_make_functions()
  # Not RStudio OR RStudio console
  if (rprofile::is_terminal()) {
    rprofile::set_terminal()
  } else {
    rprofile::set_rstudio()
  }
  .env = rprofile::set_functions()
  attach(.env)
  # Display wifi and no of R sessions
  # Linux only
  rprofile::set_startup_info()
}

# Prints RStudio project on start-up
setHook("rstudio.sessionInit", function(newSession) {
  active_rproj = rprofile::get_active_rproj()
  if (!is.null(active_rproj)) {
    message(glue::glue("{crayon::yellow('R-project:')} {active_rproj}"))
  }
}, action = "append")
