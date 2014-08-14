fn colorChanged=format "Colour's changed!\n"

--callbacks.addScript #colorChanged "colorChanged()" id:#uiColChange

callbacks.addScript #colorChanged "messagebox \"hello!\"" id:#uiColChange

callbacks.removeScripts id:#uiColChange

