//
//  TagListViewDatasource.swift
//  ManagedTagListView
//
//  Created by arnaud on 28/12/16.
//  Copyright © 2016 Hovering Above. All rights reserved.
//

import Foundation

// MARK: - TagListView DataSource Functions

public protocol TagListViewDataSource {
    /// Is it allowed to edit a Tag object at a given index?
    func tagListView(_ tagListView: TagListView, canEditTagAt index: Int) -> Bool
    
    /// Is it allowed to move a Tag object at a given index?
    func tagListView(_ tagListView: TagListView, canMoveTagAt index: Int) -> Bool
    
    /// The Tag object at the source index has been moved to a destination index.
    func tagListView(_ tagListView: TagListView, moveTagAt sourceIndex: Int, to destinationIndex: Int)
    
    /// What is the title for the Tag object at a given index?
    func tagListView(_ tagListView: TagListView, titleForTagAt index: Int) -> String
    
    /// What are the number of Tag objects in the TagListView?
    func numberOfTagsIn(_ tagListView: TagListView) -> Int
    
    /// Called if the user wants to delete all tags
    func didClear(_ tagListView: TagListView)
    
    /// Which text should be displayed when the TagListView is collapsed?
    func tagListViewCollapsedText(_ tagListView: TagListView) -> String
}

extension TagListViewDataSource {
    
    /// Called when the user changes the text in the textField.
    ///func tagListView(_ tagListView: TagListView, didChange text: String)
    /// Called when the TagListView did begin editing.
    ///func tagListViewDidBeginEditing(_ tagListView: TagListView)
    
    /// Is it allowed to edit a Tag object at a given index?
    public func tagListView(_ tagListView: TagListView, canEditTagAt index: Int) -> Bool {
        return false
    }
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
        return "Collapsed Stub Title"
    }
}
