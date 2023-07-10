library(R6)
library(httr)
library(jsonlite)
source("./classes/MessageHistory.R")

# Define the ChatGPT class.
ChatGPT <- R6Class("ChatGPT",
                   private = list(
                     # Private string that will store the API token
                     .api_token = NULL,  
                     # Private string that will store the model name
                     .model = NULL,  
                     # API endpoint
                     .url = "https://api.openai.com/v1/chat/completions",  
                     # Instance of the MessageHistory class to store messages
                     .message_list = NULL,  
                     
                     # Private method to generate the headers for the HTTP request
                     get_headers = function() {
                       httr::add_headers(
                         "Content-Type" = "application/json",
                         "Authorization" = paste("Bearer", private$.api_token)
                       )
                     }
                   ),
                   
                   public = list(
                     # Public object to store the raw response from the API
                     response = NULL,  
                     
                     # Constructor for the ChatGPT class
                     initialize = function(api_token, model) {
                       private$.api_token <- api_token
                       private$.model <- model
                       private$.message_list <- MessageHistory$new()
                     },
                     
                     # Method to send a message to the API and get a response
                     chat = function(message) {
                       
                       # Add user message to the message list
                       private$.message_list$add_message("user", message)
                       
                       # Prepare the body for the API request
                       body <- list(
                         "model" = private$.model,
                         "messages" = private$.message_list$get_history()
                       )
                       
                       # Send the API request and store the response
                       self$response <- POST(private$.url, private$get_headers(), body = toJSON(body, auto_unbox = TRUE), encode = "json")
                       
                       # Extract the assistant's message from the response
                       content <- content(self$response, "parsed")
                       
                       # Add the assistant's response to our message list
                       private$.message_list$add_message("assistant", content$choices[[1]]$message$content)
                       
                       # Return the assistant's message
                       return(content$choices[[1]]$message$content)
                     },
                     
                     # Method to retrieve the conversation history
                     history = function(){
                       return(private$.message_list$get_history())
                     }
                   )
)
