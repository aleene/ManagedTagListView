# ManagedTagListView

A way to create a view with tags. Management of the tags is done through delegate- and datasource-functions. If you are familiar with UITableView, the you will have no problem with ManagedTagListView. The user can be allowed to select, remove, add and reorder tags. An optional prefix label might be added in front of the tags.

Supports Storyboard, Autolayout, and @IBDesignable.

## Setting up the interface

The most convenient way is to use Storyboard. Drag a view to Storyboard and set Class to `TagListView` (if you use CocoaPods, also set Module to `TagListView`). Then you can play with the attributes in the right pane, and see the preview in real time thanks to [@IBDesignable](http://nshipster.com/ibinspectable-ibdesignable/).

If you do not want to setup the interface elements in storyboard, you can also do it in code with:
```swift
tagListView.textColor = UIColor.white
tagListView.tagBackgroundColor = UIColor.gray
tagListView.tagHighlightedBackgroundColor = UIColor.blue
tagListView.cornerRadius = 0
tagListView.borderWidth = 0
tagListView.borderColor = UIColor.black
tagListView.verticalPadding = 2
tagListView.horizontalPadding = 5
tagListView.verticalMargin = 2
tagListView.horizontalMargin = 5
tagListView.textFont = UIFont.systemFontOfSize(24)
tagListView.prefixLabelTextColor = UIColor.white
tagListView.prefixLabelBackgroundColor = UIColor.red
tagListView.prefixLabelText = "This is prefix text" // if not defined there will be no prefix label
```
## Setting up Delegate/Datasource functions
TagViewList support several delegate and datasource functions, which you can use. First setup your viewController as delegate:
```swift
class YourViewController: UIViewController, TagListViewDelegate
```
Then assign yourself as a delegate of TagListView. For instance in a didSet of your TagListView outlet:
```swift
tagListView.delegate = self
tagListView.datasource = self
```
## Setting up the data
You need to support two datasource functions, otherwise ManagedTagListView will not work:
```swift
func numberOfTagsInTagListView(_ tagListView: TagListView) -> Int
func tagListView(_ tagListView: TagListView, titleForTagAt index: Int) -> String
```
All other delegate- and datasource-functions are optional.
## Setting the mode
ManagedTagListView can work in two modes: select- (non-edit) and edit-mode. You can set the mode of a tagListView with `isEditable = false` (default).

### Select-mode
In select-mode the user can tap tags in order to select them. With `tagListView.allowsMultipleSelection = false` (default) the user is allowed to select multiple tags.

The user can set up the layout of selected tags with:
```swift
tagListView.selectedTextColor = UIColor.white // (default)
tagListView.tagSelectedBackgroundColor = UIColor.blue // (default)
tagListView.selectedBorderColor: UIColor = UIColor.blue // (default)
```

The user can change the selection status tags programmatically:
```swift
let indices = tagListView.selectedTagIndices() // will give you the indices of all the tags.
tagListView.deselectTag(at:4) // deselect tag at index 4
tagListView.selectTag(at:3) // select tag at index 3
tagListView.deselectAllTags() // deselect all tags
```

What the user is doing can be followed through delegate functions:
```swift
func tagListView(_ tagListView: TagListView, willSelectTagAt index: Int) -> Int
func tagListView(_ tagListView: TagListView, didSelectTagAt index: Int) -> Void
func tagListView(_ tagListView: TagListView, willDeselectTagAt index: Int) -> Int
func tagListView(_ tagListView: TagListView, didDeselectTagAt index: Int) -> Void
```

### Edit-mode
If a TagListView is set in edit-mode with `isEditable = true`, the user can remove, add and reorder tags. 
It is possible to finetune what is allowed with: 
- `allowsRemoval = true` (default), which allows/disallows removal of tags;
- `clearButtonIsEnabled = true` (default), which adds a clear all Tags button;
- `removeButtonIsEnabled = true` (default), which adds a remove tag accessory next to the tag's text. If the keyboard is enabled, tags can also be deleted by backspacing;
- `allowsCreation = true` (default), which allows the user to add tags, by tapping on the tagViewList;
- `allowsReordering = true` (default), which allows the user to reorder tags by drag&drop; 

If the user is allowed to remove a tag, its appearance can be adjusted with:
```swift
tagListView.highlightedTextColor = .white // (default) defines the colour of the text of highlighted tags
tagListView.tagHighlightedBackgroundColor = .blue // (default) defines the background colours of highlighted tags
tagListView.highlightedBorderColor = .blue // (default) defines the border colour of highlighted tags
```
You can intercept the edit-instructions with several delegate functions:
```swift
func tagListView(_ tagListView: TagListView, canEditTagAt index: Int) -> Bool // called before a tag will be edited
func tagListView(_ tagListView: TagListView, canMoveTagAt index: Int) -> Bool // called before a tag is moved
func tagListView(_ tagListView: TagListView, moveTagAt sourceIndex: Int, to destinationIndex: Int) // called after a tag is moved
```
You can follow the actions around edit actions with:
```swift
func tagListView(_ tagListView: TagListView, willBeginEditingTagAt index: Int)
func tagListView(_ tagListView: TagListView, didEndEditingTagAt index: Int)
```
If you allow the user to move tags:
```swift
func tagListView(_ tagListView: TagListView, targetForMoveFromTagAt sourceIndex: Int, toProposed proposedDestinationIndex: Int) -> Int
```
## Installation

Drag the **TagListView** folder into your project.

## Acknowledgments
This repository is inspired by several other repositores found on Github:
- TagListView (https://github.com/ElaWorkshop/TagListView)
- TokenField (https://github.com/rchatham/TokenField)
These repositories have been merged into one, which makes attribution very difficult. However you can see a lot of TagListView, hence the name of this repository.

## License

MIT
