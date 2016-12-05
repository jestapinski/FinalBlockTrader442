import Foundation
let val = "12.5"
print(val.components(separatedBy: "."))
var newArr = val.components(separatedBy: ".")
if (newArr[1].characters.count == 0){
    newArr[1] = "00"
    print(newArr.joined(separator: ""))
} else if (newArr[1].characters.count == 1) {
    newArr[1] = newArr[1] + "0"
    print(newArr.joined(separator: ""))
} else {
    print(newArr.joined(separator: ""))
}