#'Get board using its ID
#'
#'Get information about a pinterest board using the board ID.
#'
#'Takes a board ID and an access token, returns a data.frame.
#'@param boardID a character string with a board ID.
#'@param token a character string with an access token generated at \url{https://developers.pinterest.com/tools/access_token/}
#'@return Always returns a data.frame, with a warning when appropriate.
#'@export
#'@examples
#'BoardSpecByID(boardID = "42080646457333782", token = "your_token")

BoardSpecByID <- function(boardID, token) {
  . <- NULL 
  default <- data.frame(name = vector("character"), 
                        board_id = vector("character"), 
                        board_desc = vector("character"), 
                        creator_first_name = vector("character"), 
                        creator_last_name = vector("character"), 
                        creator_url = vector("character"), 
                        creator_id = vector("character"), 
                        created_at = vector("character"), 
                        pins_count = vector("character"), 
                        pins_collaborators = vector("character"), 
                        pins_followers = vector("character"))
  url <- paste0("https://api.pinterest.com/v1/boards/", boardID, "/?access_token=", token, "&fields=id%2Cname%2Curl%2Ccounts%2Ccreated_at%2Ccreator%2Cdescription%2Cimage%2Cprivacy%2Creason")
  board <- httr::GET(url)
  if (board$status_code == 200){
    content <- rjson::fromJSON(rawToChar(board$content))
    content <- content$data
    contentlist <- list()
    contentlist[[1]] <- content
    identity <- lapply(contentlist, function(obj) {
      data.frame(name = obj$name %||% NA, 
                 board_id = obj$id %||% NA, 
                 board_desc = obj$description %||% NA, 
                 creator_first_name = obj$creator$first_name %||% NA, 
                 creator_last_name = obj$creator$last_name %||% NA, 
                 creator_url = obj$creator$url %||% NA, 
                 creator_id = obj$creator$id %||% NA, 
                 created_at = obj$created_at %||% NA, 
                 pins_count = obj$counts$pins %||% NA, 
                 pins_collaborators = obj$counts$collaborators %||% NA, 
                 pins_followers = obj$counts$followers %||% NA, 
                 stringsAsFactors = FALSE)
    }) %>% do.call(rbind, .)  
  } else {
    warning("Request error: your token may not be valid, or your input not an actual board ID")
    identity <- default
  }
  return(identity)
}
