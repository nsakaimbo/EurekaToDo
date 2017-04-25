/**
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import Foundation

class ToDo: Equatable {
  
  var title: String?
  
  var dueDate: Date
  
  fileprivate var reminderDate: Date?
  fileprivate var priority_raw: String
  fileprivate var category_raw: String?
  fileprivate var repeats_raw: String
  
  var image: Data?
  
  init(title: String? = nil,
       dueDate: Date = Date(),
       priority: String = Priority.low.rawValue,
       reminderDate: Date? = nil,
       category: String? = nil,
       repeats: String = RepeatFrequency.never.rawValue,
       image: Data? = nil) {
   
    self.title = title
    
    self.dueDate = dueDate
    self.repeats_raw = repeats
    
    self.priority_raw = priority
    self.reminderDate = reminderDate
    
    self.image = image
    
    self.category_raw = category
  }
  
  static func ==(_ lhs: ToDo, _ rhs: ToDo) -> Bool {
    return (lhs.title == rhs.title)
      && (lhs.dueDate == rhs.dueDate)
      && (lhs.repeats_raw == rhs.repeats_raw)
      && (lhs.priority_raw == rhs.priority_raw)
      && (lhs.reminderDate == rhs.reminderDate)
      && (lhs.image == rhs.image)
      && (lhs.category_raw == rhs.category_raw)
  }
}

// MARK: - Priority, Category and Repeat Frequency
extension ToDo {
  
  enum Priority: String {
    case low = "!"
    case medium = "!!"
    case high = "!!!"
  }
  
  enum Category: String {
    case personal = "Personal 😄"
    case home = "Home 🏠"
    case work = "Work 💼"
    case play = "Play 🎮"
    case health = "Health 🏋🏻‍♀️"
  }
  
  enum RepeatFrequency: String {
    case never = "Never"
    case daily = "Daily"
    case weekly = "Weekly"
    case monthly = "Monthly"
    case annually = "Annually"
  }
  
  enum Reminder: String {
    case none = "None"
    case halfHour = "30 minutes before"
    case oneHour = "1 hour before"
    case oneDay = "1 day before"
    case oneWeek = "1 week before"
   
    var timeInterval: Double {
      switch self {
      case .none:
        return 0
      case .halfHour:
        return -1800
      case .oneHour:
        return -3600
      case .oneDay:
        return -86400
      case .oneWeek:
        return -604800
      }
    }
    
    static func fromInterval(_ interval: TimeInterval) -> Reminder {
      switch interval {
      case 1800:
        return .halfHour
      case 3600:
        return .oneHour
      case 86400:
        return .oneDay
      case 604800:
        return .oneWeek
      default:
        return .none
      }
    }
  }
}

// MARK: Computed variables
extension ToDo {
  
  var priority: Priority {
    get {
      return Priority(rawValue: self.priority_raw)!
    }
    set {
      self.priority_raw = newValue.rawValue
    }
  }
  var category: Category? {
    get {
      if let value = self.category_raw {
        return Category(rawValue: value)!
      }
      return nil
    }
    set {
      self.category_raw = newValue?.rawValue
    }
  }
  
  var repeats: RepeatFrequency {
    get {
      return RepeatFrequency(rawValue: self.repeats_raw)!
    }
    set {
      self.repeats_raw = newValue.rawValue
    }
  }
  
  var reminder: Reminder {
    get {
      if let date = self.reminderDate {
        let duration = date.seconds(from: self.dueDate)
        return Reminder.fromInterval(duration)
      }
      return .none
    }
    set {
      reminderDate = dueDate.addingTimeInterval(newValue.timeInterval)
    }
  }
}

extension Date {
  /// Returns the amount of seconds from another date
  func seconds(from date: Date) -> TimeInterval {
    let duration =  Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    return Double(abs(duration))
  }
}
