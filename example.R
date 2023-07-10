# Load necessary libraries...
source("./classes/MessageHistory.R")
source("./classes/ChatGPT.R")

# Create an instance of the ChatGPT class
chat_instance <- ChatGPT$new(api_token = Sys.getenv("OPENAI_API_TOKEN"), model = "gpt-3.5-turbo-0301")

# Send a message and get a response
chat_instance$chat("Tell me a joke.")

# Send another message and get a response
chat_instance$chat("Tell me another joke.")

# Print the entire conversation history
history <- chat_instance$history()
print(history)
