//
//    Copyright (c) 2015 Max Sokolov https://twitter.com/max_sokolov
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy of
//    this software and associated documentation files (the "Software"), to deal in
//    the Software without restriction, including without limitation the rights to
//    use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//    the Software, and to permit persons to whom the Software is furnished to do so,
//    subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in all
//    copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//    FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//    COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//    IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//    CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import UIKit

public protocol CellHeightCalculatable {

    var tableView: UITableView? { get set }

    func height(row: Row, path: NSIndexPath) -> CGFloat
    func estimatedHeight(row: Row, path: NSIndexPath) -> CGFloat
}

public class PrototypeHeightStrategy: CellHeightCalculatable {

    public weak var tableView: UITableView?
    private var cachedHeights = [Int: CGFloat]()
    private var separatorHeight = 1 / UIScreen.mainScreen().scale
    
    init(tableView: UITableView?) {
        self.tableView = tableView
    }
    
    public func height(row: Row, path: NSIndexPath) -> CGFloat {
        
        if let height = cachedHeights[row.hashValue] {
            return height
        }

        guard let cell = tableView?.dequeueReusableCellWithIdentifier(row.reusableIdentifier) else { return 0 }
        
        cell.bounds = CGRectMake(0, 0, tableView?.bounds.size.width ?? 0, cell.bounds.height)

        row.configure(cell)
        
        cell.setNeedsLayout()
        cell.layoutIfNeeded()

        let height = cell.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height + (tableView?.separatorStyle != .None ? separatorHeight : 0)

        cachedHeights[row.hashValue] = height

        return height
    }

    public func estimatedHeight(row: Row, path: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}