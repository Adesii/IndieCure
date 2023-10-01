extends Node

# a Message/Event system that can register and send messages to other nodes
# a node can send a message and other nodes can register to receive that message and handle it

var messagedictionary = {}

func registernode(message :String,node :Node,callback :Callable):
    if not messagedictionary.has(message):
        messagedictionary[message] = {}
    messagedictionary[message].append([node,callback])

func sendmessage(message :String,args :Array = []):
    if messagedictionary.has(message):
        for node in messagedictionary[message]:
            node[1].call(args)
