--UI Tidy test rollout

try(destroyDialog vmsTidyTestRo);catch()

rollout vmsTidyTestRo "vmsTidy Test Rollout" width:400 height:672
(
	label lbl1 "Overview" pos:[8,8] width:312 height:16 bold:true
	
	label lbl2 "Visual Max Script is a great tool for quickly fleshing out a user interface for your latest script, but the code it writes is messy to say the least.

VMS Tidy will take that mess and order it into something structured and readable, making it easy to start coding around it.
" pos:[24,24] width:368 height:72
	label lbl19 "Instructions" pos:[8,104] width:312 height:16 bold:true
	label lbl23 "To start with, VMS Tidy needs to have some rollout code to work with, so copy and paste some existing code from an editor window into the text box, or use the Sample Code included in the interface for a quick test.

Now, click 'Tidy...' and watch your code magically re-arrange itself!

Interface elements are rearranged in the order that they are found in the interface - reading from left to right, top to bottom, with groups taking priority, and nesting controls found within them.

Click 'Test...' to create a new rollout and check that everything has worked.

Click 'Edit...' to open the newly tided code in a new (blank) rollout, so you can continue to add, edit, or move items easily, using the Visual Max Script editor.

" pos:[24,120] width:368 height:184

	label lbl28 "Adding manual line breaks" pos:[8,312] width:312 height:16 bold:true
	label lbl29 "To insert a line break before a rollout controls, for example to create a new block of controls, add a comment (--) to the end of the line." pos:[24,328] width:368 height:32
	label lbl30 "Working methodology" pos:[8,360] width:312 height:16 bold:true
	label lbl31 "It's up to you how you want to work with VMS Tidy. You can tidy existing code, or start a rollout from scratch by clicking 'Edit...'.

My personal preference is to:
 - Create a new script by clicking 'Edit...'
 - Open it in Visual Max Script and start designing visually
 - Once happy, name the controls logically
 - When finished, paste the script into VMS Tidy and tidy it
 - Re-output the code and start associating handlers and functions to rollout controls.
" pos:[24,376] width:368 height:136
	label lbl64 "What VMS Tidy is" pos:[8,519] width:312 height:16 bold:true
	label lbl65 "A accompanying tool to Visual Max Script that allows you to concentrate on the task of designing functional user interfaces (rather than deciphering clumsy code)" pos:[16,536] width:368 height:40
	label lbl66 "What VMS Tidy is not" pos:[8,592] width:312 height:16 bold:true
	label lbl67 "A replacement for the Visual Max Script Editor" pos:[16,609] width:368 height:15
	label lbl68 "Credits" pos:[8,632] width:312 height:16 bold:true
	button btn13 ">" pos:[88,648] width:16 height:16
	label lbl70 "Dave Stewart" pos:[16,648] width:72 height:15
)
createdialog vmsTidyTestRo

