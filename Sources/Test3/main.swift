
import Helpers

print("Enter a username to search for its repository.\n")

var needClose = false

while(!needClose) {

    if let command = readLine() {

        ActionHandler.handle(command: command) { actionType in
            switch actionType {
            case .close:
                needClose = true
            case let .message(message):
                print(message)
            }
        }
    }
}
