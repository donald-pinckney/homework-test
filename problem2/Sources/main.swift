import Foundation

// Uncomment to test either slower execution for timing values
//sleep(1)
// or to test forceful kill after too long
//sleep(10)

// For this problem, you need to read in a name, and print out a hello message with it
let name = readLine() ?? "NO_NAME"
sleep(UInt32(name.characters.count))
print("Hello, \(name)!")
