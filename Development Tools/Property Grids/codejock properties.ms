.Categories : IPropertyGridItems, read-only
.Selected : IPropertyGridItem, read-only
.Verbs : IPropertyGridVerbs, read-only
.ToolBarVisible : boolean
.HelpVisible : boolean
.PropertySort : PropertySort( #Categorized | #Alphabetical | #NoSort )
.HelpBackColor : OLE_COLOR
.HelpForeColor : OLE_COLOR
.ViewBackColor : OLE_COLOR
.ViewForeColor : OLE_COLOR
.LineColor : OLE_COLOR
.ViewCategoryForeColor : OLE_COLOR
.ViewReadOnlyForeColor : OLE_COLOR
.VisualTheme : XTPPropertyGridVisualTheme( #xtpGridThemeDefault | #xtpGridThemeNativeWinXP | #xtpGridThemeOffice2003 | #xtpGridThemeCool | #xtpGridThemeSimple | #xtpGridThemeDelphi | #xtpGridThemeWhidbey )
.HelpHeight : integer
.SplitterPos : float
.VerbsHeight : integer
.NavigateItems : boolean
.HighlightChangedItems : boolean
.VariableItemsHeight : boolean
.hWnd : OLE_HANDLE
.Enabled : boolean
.Font : Font
.Icons : IImageManagerIcons
.RightToLeft : boolean
.TopIndex : integer
.VariableHelpHeight : boolean
.VariableSplitterPos : boolean


.AboutBox()
.AddCategory Title:string
.FindItem CaptionOrId:undefined
.InsertCategory Index:undefined Title:string
.BeginUpdate()
.EndUpdate Context:IPropertyGridUpdateContext


on <control_name> PropertySortChanged do ( ... )
on <control_name> SelectionChanged Item:IPropertyGridItem do ( ... )
on <control_name> ValueChanged Item:IPropertyGridItem do ( ... )
on <control_name> InplaceButtonDown Item:IPropertyGridItem do ( ... )
on <control_name> DblClick Item:IPropertyGridItem do ( ... )
on <control_name> RClick Item:IPropertyGridItem do ( ... )
on <control_name> VerbClick Verb:IPropertyGridVerb do ( ... )
on <control_name> KeyUp KeyCode:integer Shift:integer do ( ... )
on <control_name> KeyDown KeyCode:integer Shift:integer do ( ... )
on <control_name> CancelEdit Item:IPropertyGridItem do ( ... )
on <control_name> RequestEdit Item:IPropertyGridItem &Cancel:boolean do ( ... )
on <control_name> AfterEdit Item:IPropertyGridItem &NewValue:string &Cancel:boolean do ( ... )
