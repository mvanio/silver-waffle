library(R6)
library(rlist)

# Define the MessageHistory class.
MessageHistory <- R6Class("MessageHistory",
                  private = list(
                    # Private list that will contain the history of messages
                    .history = list()
                  ),
                  public = list(
                    # Public reference to the private .history list
                    message_history = list(),
                    
                    # Constructor for the MessageHistory class which initialises the .history list
                    initialize = function() {
                      private$.history <- list()
                    },
                    
                    # Method to add a new message to the history.
                    # The role and content of the message are passed as arguments.
                    add_message = function(role, content) {
                      private$.history <- c(private$.history, list(list(role = role, content = content)))
                    },
                    
                    # Method to return the full message history
                    get_history = function() {
                      return(private$.history)
                    },
                    
                    # Method to return the last message from a given role.
                    # The method iterates over the history from the end until it finds a message
                    # from the specified role and then returns it.
                    # If no message from the specified role is found, the method returns NULL.
                    get_last_message = function(role) {
                      for (i in length(private$.history):1) {
                        if (private$.history[[i]]$role == role) {
                          return(private$.history[[i]]$content)
                        }
                      }
                      return(NULL)
                    }
                  )
)
