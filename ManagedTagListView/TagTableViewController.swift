//
//  TagTableViewController.swift
//  TagListViewDemo
//
//  Created by arnaud on 23/11/16.
//  Copyright © 2016 Ela. All rights reserved.
//

import UIKit

class TagTableViewController: UITableViewController {


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    fileprivate var tags = ["This", "is", "a", "set", "of", "tags", "in", "a", "tableViewCell", ".", "There", "are", "a", "lot", "of", "tags", "defined", "here", "in", "order", "to", "show", "the", "dynamic", "cell", "height", "LAST ONE"]
    
    fileprivate struct Storyboard {
        static let TagListViewCellIdentifier = "TagListView Cell"
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.TagListViewCellIdentifier, for: indexPath) as! TagsTableViewCell
        cell.tagListView?.delegate = self
        cell.tagListView?.datasource = self
        cell.editMode = editMode
        return cell
    }

    // MARK: editMode functions and outlet/actions
    
    fileprivate var editMode = false {
        didSet {
            if editMode != oldValue {
                setEditModeBarButtonItemTitle()
            }
        }
    }
    
    private func setEditModeBarButtonItemTitle() {
        if editModeBarButtonItem != nil {
            editModeBarButtonItem.title = editMode ? "Select" : "Edit"
        }
    }

    @IBOutlet weak var editModeBarButtonItem: UIBarButtonItem! {
        didSet {
            setEditModeBarButtonItemTitle()
        }
    }
    
    // This button allows to toggle between editMode and non-editMode

    @IBAction func editBarButtonTapped(_ sender: UIBarButtonItem) {
        editMode = !editMode
        tableView.reloadData()
    }

    // MARK: - View Controller Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // See http://stackoverflow.com/questions/18746929/using-auto-layout-in-uitableview-for-dynamic-cell-layouts-variable-row-heights#18746930
        
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // This repaints the view, so the cells get the right height.
        // This is not always needed, try it out.
        tableView.layoutIfNeeded()
        // tableView.reloadData()
    }
}

// MARK: - TagListView Delegates Functions

extension TagTableViewController: TagListViewDelegate {
    
    
    func tagListView(_ tagListView: TagListView, didDeleteTagAt index: Int) {
        print("The tag with index", index, "has been selected")
        print(tagListView.selectedTags.count, "tags have been selected")
        if editMode {
            tags.remove(at: index)
            tableView.reloadData()
        }
    }
    
    func tagListView(_ tagListView: TagListView, willSelectTagAt index: Int) {
        print("The tag with index ", index, "will be selected")
    }
    
    func tagListView(_ tagListView: TagListView, didDeselectTagAt index: Int) {
        print("The tag with index ", index, "has been DEselected")
    }
    
    func tagListView(_ tagListView: TagListView, willDeselectTagAt index: Int) {
        print("The tag with index ", index, "will be DEselected")
    }
    
    func tagListView(_ tagListView: TagListView, canEditTagAt index: Int) -> Bool {
        print("The tag with ", index, "can be edited")
        if index == 3 {
            // tag with index 3 may not be edited (deleted)
            return false
        } else {
            return true
        }
    }
    
    func tagListView(_ tagListView: TagListView, willBeginEditingTagAt index: Int) {
        print("The tag with ", index, "will be edited")
        // you can delete the corresponding data here
    }
    
    func tagListView(_ tagListView: TagListView, didEndEditingTagAt index: Int) {
        print("The tag with ", index, "has been edited")
    }

    /*
    public func tagListView(_ tagListView: TagListView, didSelectTagAt index: Int) {
    }
    
    public func tagListView(_ tagListView: TagListView, targetForMoveFromTagAt sourceIndex: Int,
                            toProposed proposedDestinationIndex: Int) -> Int {
        return proposedDestinationIndex
    }
    
    public func tagListView(_ tagListView: TagListView, didAddTagWith title: String) {
    }
    
    /// Called when the TagListView's content height changes.
    public func tagListView(_ tagListView: TagListView, didChange height: CGFloat) {
    }
*/
}

// MARK: - TagListView DataSource Functions

extension TagTableViewController: TagListViewDataSource {
    
    func tagListView(_ tagListView: TagListView, titleForTagAt index: Int) -> String {
        return tags[index]
    }
    
    func numberOfTagsIn(_ tagListView: TagListView) -> Int {
        return tags.count
    }
    
    /*
    /// Is it allowed to move a Tag object at a given index?
    public func tagListView(_ tagListView: TagListView, canMoveTagAt index: Int) -> Bool {
        return false
    }
    /// The Tag object at the source index has been moved to a destination index.
    public func tagListView(_ tagListView: TagListView, moveTagAt sourceIndex: Int, to destinationIndex: Int) {
    }
    
    /// Called if the user wants to delete all tags
    public func didClear(_ tagListView: TagListView) {
    }
    
    /// Which text should be displayed when the TagListView is collapsed?
    public func tagListViewCollapsedText(_ tagListView: TagListView) -> String {
        return "Collapsed"
    }
     */
}
