# External ISV Partners Messaging Framework

To interact with the messaging framework, which allows components to respond to the Global Location Filter on the Command Center, a component may subscribe to the Command Center standard Lightning Message Service channels:  

## Using LMS within Lightning Web Components:

To reference a message channel in LWC, import it from the new `@salesforce/messageChannel` scoped module. To use the LMS APIs, `import` the functions we’re interested in — `subscribe`, `unsubscribe`, `MessageContext`, and `APPLICATION_SCOPE` — from `lightning/messageService`. Then import the Command Center Message Channel. Below is an example of subscribing/unsubscribing to the message channel and listening for events fired.
