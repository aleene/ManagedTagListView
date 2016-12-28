//
//  ViewController.swift
//  TagListViewDemo
//
//  Created by Dongyuan Liu on 2015-05-09.
//  Copyright (c) 2015 Ela. All rights reserved.
//
import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tagListView: TagListView! {
        didSet {
            tagListView.allowsMultipleSelection = multipleSelectionIsAllowed
        }
    }

    @IBOutlet weak var biggerTagListView: TagListView! {
        didSet {
            biggerTagListView.allowsMultipleSelection = multipleSelectionIsAllowed
        }
    }

    @IBOutlet weak var biggestTagListView: TagListView! {
        didSet {
            if multipleSelectionSwitch != nil {
                multipleSelectionSwitch.setOn(multipleSelectionIsAllowed, animated: true)
            }
        }
    }
    @IBOutlet weak var scrollViewTagListView: TagListView!
    

    @IBAction func multipleSelectionSwitch(_ sender: UISwitch) {
        multipleSelectionIsAllowed = !multipleSelectionIsAllowed
    }
    
    @IBOutlet weak var multipleSelectionSwitch: UISwitch! {
        didSet {
            multipleSelectionSwitch.setOn(multipleSelectionIsAllowed, animated: true)
        }
    }

    private var multipleSelectionIsAllowed = false {
        didSet {
            tagListView.allowsMultipleSelection = multipleSelectionIsAllowed
            biggerTagListView.allowsMultipleSelection = multipleSelectionIsAllowed
            biggestTagListView.allowsMultipleSelection = multipleSelectionIsAllowed
        }
    }
    
    fileprivate var tagListViewTags = ["TagListViewTEST", "TEAChart", "To Be Removed", "To Be Removed", "Quark Shell", "On tap will be removed", "TLV "]
    fileprivate var biggerTagListViewTags = ["Inboard", "Pomotodo", "Halo Word"]
    fileprivate var biggestTagListViewTags = ["These", "tags", "can", "be", "reordered", "by", "drag&drop", "NOT this one"]
    fileprivate var scrollViewTagListViewTags = ["This","is","a","TagListView","within","a","scrollView.","If", "the","data","do","not","fit","the","view","you","should","be","able","to","scroll","around.","This","is","a","TagListView","within","a","scrollView.","If", "the","data","do","not","fit","the","view","you","should","be","able","to","scroll","around.","This","is","a","TagListView","within","a","scrollView.","If", "the","data","do","not","fit","the","view","you","should","be","able","to","scroll","around.","This","is","a","TagListView","within","a","scrollView.","If", "the","data","do","not","fit","the","view","you","should","be","able","to","scroll","around."]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tagListView.delegate = self
        tagListView.datasource = self
        tagListView.allowsCreation = true
        // tagListView.textColor = .red
        
        // setup biggerTagListView
        
        biggerTagListView.delegate = self
        biggerTagListView.datasource = self
        biggerTagListView.textFont = UIFont.systemFont(ofSize: 15)
        biggerTagListView.shadowRadius = 2
        biggerTagListView.shadowOpacity = 0.4
        biggerTagListView.shadowColor = UIColor.black
        biggerTagListView.shadowOffset = CGSize(width: 1, height: 1)
        // biggerTagListView.alignment = .center
        biggerTagListView.prefixLabelText = "BTLV "
        biggerTagListView.allowsRemoval = true
        
        // This is an example of a TagListView, wich allows reordering
        // The data is found in biggestTagListViewTags
        // the data is reordered as the tags move around
        // However the last tag is fixed: it can not be moved or replaced
        
        biggestTagListView.delegate = self
        biggestTagListView.datasource = self
        biggestTagListView.textFont = UIFont.systemFont(ofSize: 24)
        // biggestTagListView.alignment = .right
        // set to editable to allow reordering
        biggestTagListView.allowsReordering = true
        biggestTagListView.allowsRemoval = false
        
        // This is an example of a TagListView inside a UIScrollView
        // You should fix the height of the UIScrollView
        // It only uses the default settings of a TagListView.
        scrollViewTagListView.delegate = self
        scrollViewTagListView.datasource = self
        
        multipleSelectionIsAllowed = false
    }

    @IBAction func updateTitleDemo(_ sender: UIButton) {
        biggerTagListViewTags[1] = "New Title"
        biggerTagListView.reloadData()
    }
    
    @IBAction func collapseButtonTapped(_ sender: UIButton) {
        // tagListView.isCollapsed = !tagListView.isCollapsed
        tagListView.borderWidth = 5.0
    }
    
    @IBAction func unwindToViewController(_ segue:UIStoryboardSegue) {
    }

}

// MARK: TagListViewDelegate Functions

extension ViewController: TagListViewDelegate {
    
    
    func tagListView(_ tagListView: TagListView, willDisplay tagView: TagView, at index: Int) -> TagView? {
        if tagListView === biggestTagListView {
            if index == 2 {
                tagView.normalColorScheme.backgroundColor = .gray
                return tagView
            }
        }
        return nil
    }
    
    func tagListView(_ tagListView: TagListView, targetForMoveFromTagAt sourceIndex: Int,
                     toProposed proposedDestinationIndex: Int) -> Int {
        if tagListView === biggestTagListView {
            return proposedDestinationIndex == biggestTagListViewTags.count - 1 ? biggestTagListViewTags.count - 2 : proposedDestinationIndex
        } else {
            return proposedDestinationIndex
        }
    }
    
    func tagListView(_ tagListView: TagListView, didAddTagWith title: String) {
        if tagListView === biggerTagListView {
            biggerTagListViewTags.append(title)
        } else if tagListView === self.tagListView {
            tagListViewTags.append(title)
        } else if tagListView === biggestTagListView {
            biggestTagListViewTags.append(title)
        }
    }
    
    func tagListView(_ tagListView: TagListView, canEditTagAt index: Int) -> Bool {
        if tagListView === self.tagListView {
            switch index {
            case 0, 1, 4, 6:
                return false
            default:
                return true
            }
        } else if tagListView === self.biggerTagListView {
            return biggerTagListView.allowsRemoval
        } else if tagListView === self.biggestTagListView {
            return biggestTagListView.allowsRemoval
        } else if tagListView === self.scrollViewTagListView {
            return scrollViewTagListView.allowsRemoval
        }
        return false
    }

    func tagListView(_ tagListView: TagListView, didDeleteTagAt index: Int) {
        if tagListView === self.tagListView {
            tagListViewTags.remove(at: index)
        } else if tagListView === biggerTagListView {
            biggerTagListViewTags.remove(at: index)
        } else if tagListView === biggestTagListView {
            biggestTagListViewTags.remove(at: index)
        }
    }

    /*
    
    func tagListView(_ tagListView: TagListView, willBeginEditingTagAt index: Int) {
    }
    
    func tagListView(_ tagListView: TagListView, didEndEditingTagAt index: Int) {
    }

    public func tagListView(_ tagListView: TagListView, didSelectTagAt index: Int) {
    }
    
    public func tagListView(_ tagListView: TagListView, willSelectTagAt index: Int) {
    }
    
    public func tagListView(_ tagListView: TagListView, didDeselectTagAt index: Int) {
    }
    
    public func tagListView(_ tagListView: TagListView, willDeselectTagAt index: Int) {
    }
    /// Called when the TagListView's content height changes.
    public func tagListView(_ tagListView: TagListView, didChange height: CGFloat) {
    }
 */

}
// MARK: - TagListView dataSource functions

extension ViewController: TagListViewDataSource {
    
    func tagListView(_ tagListView: TagListView, titleForTagAt index: Int) -> String {
        if tagListView === self.tagListView {
            return tagListViewTags[index]
        } else if tagListView === self.biggerTagListView {
            return biggerTagListViewTags[index]
        } else if tagListView === self.biggestTagListView {
            return biggestTagListViewTags[index]
        } else if tagListView === self.scrollViewTagListView {
            return scrollViewTagListViewTags[index]
        } else {
            return ""
        }
    }
    
    func numberOfTagsIn(_ tagListView: TagListView) -> Int {
        if tagListView === self.tagListView {
            return tagListViewTags.count
        } else if tagListView === self.biggerTagListView {
            return biggerTagListViewTags.count
        } else if tagListView === self.biggestTagListView {
            return biggestTagListViewTags.count
        } else if tagListView === self.scrollViewTagListView {
            return scrollViewTagListViewTags.count
        } else {
            return 0
        }
    }
    
    func tagListView(_ tagListView: TagListView, canMoveTagAt index: Int) -> Bool {
        if tagListView === biggestTagListView {
            return index == biggestTagListViewTags.count - 1 ? false : true
        } else {
            return true
        }
    }
    
    func tagListView(_ tagListView: TagListView, moveTagAt sourceIndex: Int, to destinationIndex: Int) {
        if tagListView === biggestTagListView {
            biggestTagListViewTags.insert(biggestTagListViewTags.remove(at: sourceIndex), at: destinationIndex)
            print(biggestTagListViewTags)
        }
    }
    
    func didClear(_ tagListView: TagListView) {
        if tagListView === biggerTagListView {
            biggerTagListViewTags = []
        }
    }

    /// Which text should be displayed when the TagListView is collapsed?
    public func tagListViewCollapsedText(_ tagListView: TagListView) -> String {
        return "Collapsed"
    }

}
