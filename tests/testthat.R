library(autotest)
options(autotest.use_colours = FALSE)

error_test <- function(error_code_vec){
  count = 0; mid_count = 0
  handle_msg = function(e) {
    mid_count <<- count + 1
    if (!startsWith(e$message, 'AutoTestCaseError')) {
      msg = sprintf('Here is the code: %s\n', code)
      cat('Unexpect error: ', e$message, '\n')
      stop(msg)
    }
    cat(paste(rep('-', 30), collapse = ''), '\n')
    cat(code, '\n\n')
    cat(e$message, '\n')
  }
  for (code in error_code_vec){
    tryCatch(
      eval(parse(text=code)),
      expectation = handle_msg,
      error = handle_msg,
      finally = {
        if (mid_count - count != 1){
          msg = sprintf('The code does not raise an error: %s', code)
          stop(msg)
        }
        count = mid_count
      }
    )
  }
}

testthat::test_check("autotest")

