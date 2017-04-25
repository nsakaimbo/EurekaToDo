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

import Eureka

class ToDoCategoryCell: PushSelectorCell<String> {
  
  lazy var categoryLabel: UILabel = {
    let lbl = UILabel()
    lbl.textAlignment = .center
    return lbl
  }()
  
  override func setup() {
    height = { 60 }
    row.title = nil
    super.setup()
    selectionStyle = .none
    
    contentView.addSubview(categoryLabel)
    categoryLabel.translatesAutoresizingMaskIntoConstraints = false
    let margin: CGFloat = 10.0
    categoryLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, constant: -(margin * 2)).isActive = true
    categoryLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -(margin * 2)).isActive = true
    categoryLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
    categoryLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
  }
  
  override func update() {
    row.title = nil
    accessoryType = .disclosureIndicator
    editingAccessoryType = accessoryType
    selectionStyle = row.isDisabled ? .none : .default
    categoryLabel.text = row.value
  }
}

final class ToDoCategoryRow: _PushRow<ToDoCategoryCell>, RowType { }
