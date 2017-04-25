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

import UIKit

fileprivate extension Selector {
  static let footerTapped = #selector(EditToDoTableFooter.footerTapped(_:))
}

class EditToDoTableFooter: UIView {
  
  typealias TappedClosure = (EditToDoTableFooter)->Void
  
  var action: TappedClosure?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
  }
  
  func commonInit() {
    self.isHidden = false
    let button = UIButton(type: .custom)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.addTarget(self, action: .footerTapped, for: .touchUpInside)
    
    addSubview(button)
    
    button.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
    button.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
    button.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    button.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    
    button.layer.backgroundColor = UIColor.white.cgColor
    button.layer.shadowColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.7).cgColor
    button.layer.shadowRadius = 0.5
    button.setTitle("Add Category", for: .normal)
    button.setTitleColor(.darkText, for: .normal)
  }
  
  @objc fileprivate func footerTapped(_ sender: UIButton) {
    action?(self)
  }
}
