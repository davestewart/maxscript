callbacks.addScript #nodeCreated "PRINT \"NODE CREATED\" " id:#nodeRelated
callbacks.addScript #sceneNodeAdded  "PRINT \"SCENE NODE ADDED\" " id:#nodeRelated
callbacks.addScript #selectionSetChanged  "PRINT \"SELECTION SET CHANGED\" " id:#nodeRelated


callbacks.removeScripts id:#nodeRelated
