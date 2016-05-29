import Foundation
import TelegramBot
import SwiftyJSON

let bot = TelegramBot(token: "....")
let router = Router(bot: bot)



class Controller {
    let bot: TelegramBot
    var message: Message { return bot.lastMessage }
    var startedInChatId = Set<Int>()
    var started: Bool {
        get { return startedInChatId.contains(message.chat.id) }
        set {
            switch newValue {
            case true: startedInChatId.insert(message.chat.id)
            case false: startedInChatId.remove(message.chat.id)
            }
        }
    }
    
    init(bot: TelegramBot) {
        self.bot = bot
    }
    
    func start() {
        guard !started else {
            bot.respondAsync("\(message.from.first_name), dont get me started again!")
            return
        }
        started = true
        
        var startText: String
        if message.chat.type != .privateChat {
            startText = "Take me out of this chat. I dont answer questions in public, If you want to speak with me talk to my seretary or contact me at telegram.me/trumptalkbot"
        } else {
            startText = "Hi there, \(message.from.first_name). My name is Donald J. Trump. I landed on third base and hit a triple to get there. Feel free to talk to me about anything. "
        }
        startText += "I will also happily stop listening to you if you type /stop"
        
        bot.respondAsync(startText)
    }
    
    func stop() {
        guard started else {
            bot.respondAsync("\(message.from.first_name), Dont you dare waste my time, you already said /stop and you are saying it again!")
            return
        }
        started = false
        bot.respondSync("\(message.from.first_name), thank you, I can finally relieve myself of your voice")
    }
    
    func help() {
        let helpText = "I already told you doofis! Remember this, 'Hi there, \(message.from.first_name). My name is Donald J. Trump. I landed on third base and hit a triple to get there. Feel free to talk to me about anything. '"
        
        bot.respondPrivatelyAsync(helpText,
                                  groupText: "\(message.from.first_name), tell whoever put me in this chat that I want out  NOW!")
    }
    
    func settings() {
        let settingsText = "Settings\n" +
            "\n" +
        "I cant be changed. I have one goal, and that goal is to make america great again"
        
        bot.respondPrivatelyAsync(settingsText,
                                  groupText: "\(message.from.first_name), tell whoever put me in this chat that I want out  NOW!")
    }
    
    func partialMatchHandler(args: Arguments) {
        bot.respondSync("❗ Part of your input was ignored: \(args.scanRestOfString())")
    }
    
    func listen(args: Arguments) -> Bool {
        guard started else { return false }
        
        let text = args.scanRestOfString()
        
        3
        if text.range(of: "i am dumb") != nil {
        
            bot.respondAsync("I love people like you!")
        
        } else if text.range(of: "clinton") != nil && text.range(of: "hillary") != nil {
        
            bot.respondAsync("Hillary Clinton is a disgrace to out nation. She is probably hiding bribes from ISIS in her email. Besides, I won't even have to go up against her because she is going to get indited")
            
        } else if text.range(of: "rich") != nil {
            
            bot.respondAsync("There isnt any denying it. I am god in human form. Why do you think I am the richest man on Earth? My self funded campagn ensures no bribery while I am in office, only my thoughts, and nobody can think like me. \(message.from.first_name), I know everything about you. Your last name is \(message.from.last_name!) which makes me want to throw up. I also know you are behind on your loans so do us all a favor and dissapear.")
        
        } else if text.range(of: "how are the primaries") != nil {
            
            
        
        }else {
        
            bot.respondAsync("\(message.from.first_name), I couldn't understand that so I'm guessing it wasnt english. Go back over the wall.")
            print("yo: \(bot.lastMessage)")
            
        }
        return true
    }
}

let controller = Controller(bot: bot)
router["start"] = controller.start
router["stop"] = controller.stop
router["help"] = controller.help
router["settings"] = controller.settings
router["listen", slash: .Required] = controller.listen
router.unknownCommand = controller.listen

while let message = bot.nextMessageSync() {
    print("--- update_id: \(bot.lastUpdate!.update_id)")
    print("message: \(message.debugDescription)")
    print("command: \(bot.lastCommand.unwrapOptional)")
    
    if let command = bot.lastCommand {
        
        let text = command
        
        if text.range(of: "i am dumb") != nil {
            
            bot.respondAsync("I love people like you!")
            
        } else if text.range(of: "Clinton") != nil && text.range(of: "Hillary") != nil {
            
            bot.respondAsync("Hillary Clinton is a disgrace to our nation. She is probably hiding bribes from ISIS in her email. Besides, I won't even have to go up against her because she is going to get indited")
            
        } else if text.range(of: "rich") != nil && text.range(of: "i") == nil {
            
            bot.respondAsync("There isn't any denying it. I am god in human form. Why do you think I am the richest man on Earth? My self funded campagn ensures no bribery while I am in office, only my thoughts, and nobody can think like me. Sean, I know everything about you. Your last name is Marfiogras which makes me want to throw up. I also know you are behind on your loans so do us all a favor and dissapear.")
            
        } else {
            
             try router.process(command)
            print("fatty: \(bot.lastUpdate)")
            
        }

    }
}

fatalError("Server stopped due to error: \(bot.lastError)")
