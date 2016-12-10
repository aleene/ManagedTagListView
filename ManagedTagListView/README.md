# ManagedTagListView

A way to create a view with tags. Management of the tages is done through delegate- and datasource-functions. If you are familiar with UITableView, the you will have no problem with ManagedTagListView.

Supports Storyboard, Auto Layout, and @IBDesignable.

<img alt="Screenshot" src="Screenshots/Screenshot.png" width="310">

## Setting up the interface

The most convenient way is to use Storyboard. Drag a view to Storyboard and set Class to `TagListView` (if you use CocoaPods, also set Module to `TagListView`). Then you can play with the attributes in the right pane, and see the preview in real time thanks to [@IBDesignable](http://nshipster.com/ibinspectable-ibdesignable/).

<img alt="Interface Builder" src="Screenshots/InterfaceBuilder.png" width="566">
If you do not want to setup the interface elements in storyboard, you can also do it in code.

## Setting up the data
You need to support two datasource functions, otherwise ManagedTagListView will not work:
```swift
func numberOfTagsInTagListView(_ tagListView: TagListView) -> Int
func tagListView(_ tagListView: TagListView, titleForTagAt index: Int) -> String
```
All other delegate- and datasource-functions are optional.
### Modes
ManagedTagListView can work in two modes: select- (non-edit) and edit-mode. You can set the mode of a tagListWiew with isEditable.

### Select-mode
I
```swift
tagListView.selectedTags() // will give you the tagView of all the tags.
tagListView.deselectTag(at:4) // deselect tag at index 4
tagListView.selectTag(at:3) // select tag at index 3
tagListView.deselectAllTags() // deselect all tags
tagListView.allowsMultipleSelection = true // allow the user to select multiple tags
```
### Edit mode
TagListView can be set as editable or not. If the TagListView is editable, any tapping on a tag will be interpreted as a removal instruction. 
As default a tagListView is not editable.
```swift
tagListView.isEditable = true // sets tagListView in editable-mode.
```
In editMode the removability of a tag will be highlighted with a special icon. You can set some characteristics of this icon with:
```swift
tagListView.removeIconLineWidth = 1
tagListView.removeButtonIconSize = 12
tagListView.removeIconLineColor = UIColor.white.withAlphaComponent(0.54)
```
### Finding tags
You can find the index of specific tags or titles with:
```swift
- tagListView.indexForSelectedTag: Int? {
- tagListView.indecesForSelectedTags: [Int] {
- tagListView.indecesWithTag(_ title: String) -> [Int] {
```
## Managed functions
The managed functions allow you to use TagListView from delegate and datasource-functions.
### Delegate/Datasource functions
TagViewList support several delegate and datasource functions, which you can use. First setup your viewController as delegate:
```swift
class YourViewController: UIViewController, TagListViewDelegate
```
Then assign yourself as a delegate of TagListView. For instance in a didSet of your TagListView outlet:
```swift
tagListView.delegate = self
tagListView.datasource = self

```
#### Delegate functions

You can intercept events around tapping on tags. This will set a tag to being selected.
```swift
func tagListView(_ tagListView: TagListView, didSelectTagAtIndex index: Int) -> Void
func tagListView(_ tagListView: TagListView, willSelectTagAtIndex index: Int) -> Int
func tagListView(_ tagListView: TagListView, didDeselectTagAtIndex index: Int) -> Void
func tagListView(_ tagListView: TagListView, willDeselectTagAtIndex index: Int) -> Int
func tagPressed(title: String, tagView: TagView, sender: TagListView)
```
You can intercept the edit-instructions with the appropriate delegate functions.
```swift
func tagListView(_ tagListView: TagListView, willBeginEditingTagAt index: Int)
func tagListView(_ tagListView: TagListView, didEndEditingTagAt index: Int)
```
If you allow the user to move tags:
```swift
func tagListView(_ tagListView: TagListView, targetForMoveFromTagAt sourceIndex: Int, toProposed proposedDestinationIndex: Int) -> Int
```
#### Datasource functions
```swift
func tagListView(_ tagListView: TagListView, canEditTagAt index: Int) -> Bool
func tagListView(_ tagListView: TagListView, canMoveTagAt index: Int) -> Bool
func tagListView(_ tagListView: TagListView, moveTagAt sourceIndex: Int, to destinationIndex: Int)
```
### Layouting tags
It is also possible to layout the tagViews is a tagListView with:
```swift
tagListView.textColor = UIColor.white
tagListView.selectedTextColor = UIColor.white
tagListView.tagBackgroundColor = UIColor.gray
tagListView.tagHighlightedBackgroundColor = UIColor.blue
tagListView.tagSelectedBackgroundColor = UIcolor.green
tagListView.cornerRadius = 0
tagListView.borderWidth = 0
tagListView.borderColor = UIColor.black
tagListView.selectedBorderColor: UIColor?
tagListView.vertcalPadding = 2
tagListView.horizontalPadding = 5
tagListView.verticalMargin = 2
tagListView.horizontalMargin = 5
tagListView.textFont = UIFont.systemFontOfSize(24)
tagListView.alignment = .Center // possible values are .Left, .Center, and .Right
tagListView.alignment = UIFont.systemFont(ofSize: 15)
tagListView.alignment.shadowRadius = 2
tagListView.alignment.shadowOpacity = 0.4
tagListView.alignment.shadowColor = UIColor.black
tagListView.alignment.shadowOffset = CGSize(width: 1, height: 1)
tagListView.hasPrefixLabel = true
```

You can also customize a particular tag, or set tap handler for it by manipulating the `TagView` object returned by `addTag(_:)`:

```swift
let tagView = tagListView.addTag("blue")
tagView.tagBackgroundColor = UIColor.blueColor()
tagView.onTap = { tagView in
print("Don’t tap me!")
}
```

Be aware that if you update a property (e.g. `tagBackgroundColor`) for a `TagListView`, all the inner `TagView`s will be updated.

## Installation

Drag the **TagListView** folder into your project.

## Acknowledgments
This repository is inspired by several other repositores found on Github:
- TagListView (https://github.com/ElaWorkshop/TagListView)
- TokenField (https://github.com/rchatham/TokenField)
These repositories have been merged into one, which makes attribution very difficult. However you can see a lot of TagListView, hence the name of this repository.

## License

MIT
