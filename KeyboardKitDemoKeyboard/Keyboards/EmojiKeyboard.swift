
import KeyboardKit

/**
 This demo keyboard mimics the native iOS emoji keyboard. It
 uses the `EmojiCategory` enum to add all available category
 items and their emojis to the keyboard.
 
 The keyboard actions are handled by the demo action handler.
 */
struct EmojiKeyboard: DemoKeyboard {
    
    init(in viewController: KeyboardViewController) {}
    
    private let categories = EmojiCategory.all
    private var emoji: [KeyboardAction] = []
    
    public func orderEmojis(rowsPerPage: Int, pageSize: Int) -> [KeyboardAction] {
        
        /** This function sorts the array of emojis from top to bottom
         1   4   7
         2   5   8
         3   6   9
         */
        var orderEmoji: [KeyboardAction] = []
        var groups = emoji.count / pageSize
        groups += emoji.count % pageSize == 0 ? 0 : 1
        for indexGroup in 0..<groups {
            let start = pageSize * indexGroup
            var end = start + pageSize
            end = end > emoji.count ? emoji.count : end
            let emojisGroup = emoji[start..<end]
            var tempArray = [KeyboardAction](repeating: .none, count: pageSize)
            var currentColumn = 0
            var currentRow = 0
            for indexEmoji in 0..<emojisGroup.count {
                if currentRow >= rowsPerPage {
                    currentColumn += 1
                    currentRow = 0
                }
                let row = currentRow == 0 ? "" : currentRow.description
                let stringValue = row + currentColumn.description
                tempArray[Int(stringValue)!] = emojisGroup[indexEmoji + start]
                currentRow += 1
                
            }
            orderEmoji += tempArray
        }
        return orderEmoji
    }
    
    func getNameCategoryEmoji(currentPage: Int,bottomActions:KeyboardActionRow) -> String{
        var label = ""
        for  pagination in bottomActions {
            if case let KeyboardAction.switchEmoji(category, startPage, endPage, _) = pagination {
                if currentPage >= startPage && currentPage < endPage{
                    label = category
                    break
                }
            }
        }
        return label
    }
    
    public mutating func bottomActionsEmojiCategories(pageSize: Int) -> KeyboardActionRow  {
        var bottomActions: KeyboardActionRow = []
        bottomActions.append(.switchToKeyboard(.alphabetic(uppercased: false)))
        for (index,typeCategory) in categories.enumerated() {
            let startPage = emoji.count / pageSize
            emoji += typeCategory.emojiActions
            var endPage = (emoji.count / pageSize)
            endPage += index == (categories.count - 1) ? 1: 0
            bottomActions.append(.switchEmoji(category: typeCategory.title, startPage: startPage, endPage: endPage, type: typeCategory))
        }
        bottomActions.append(.backspace)
        return bottomActions
    }
}
