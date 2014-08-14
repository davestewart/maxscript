POS_Fltr = newRolloutFloater "POS Tools , Xoff 2005 v0.0.1 230305 " (150) (190) 

rollout skin_rollout "POS saver - Xoff 2005" 
( 
   spinner spnStart "Start Frame" type:#integer range:[0,100000,0] 
   spinner spnEnd "End Frame" type:#integer range:[0,100000,0] 
   label lbl0 
   checkbox chkAfter "After Effect" checked:true 
   label lbl1 
   button btnSaveModifier "Save POS" 
   button btnSaveCameraFOV "Save FOV" 
   on skin_rollout open do 
   (    
      Global MyPath = maxfilepath 
      spnStart.value = animationRange.start 
      spnEnd.value = animationRange.end 
      -------------------------------------------------------------  F U N C T I O N S  ----------------------- 
      Global GetWeights 
      fn GetWeights obj = 
      ( 
         WeightsArray = #() 
         max modify mode 
         if classof obj[4][1].value == skin then 
         ( 
            for vtxID = 1 to skinops.getnumbervertices obj[4][1] do 
            ( 
               for vtxCount = 1 to  skinops.getvertexweightcount obj[4][1] vtxID do 
               ( 
                  BoneID = skinops.getvertexweightboneID obj[4][1] vtxID vtxCount 
                  MyWeight = skinOps.GetVertexWeight obj[4][1] vtxID vtxCount 
                  append WeightsArray vtxID 
                  append WeightsArray BoneID 
                  append WeightsArray myWeight 
               )          
            ) 
         ) 
      return WeightsArray 
      ) 
       
      global copyVtxweight 
      fn copyVtxweight obj = 
      ( 
         CopyArray = #() 
         if classof obj[4][1].value == skin then 
         ( 
            for vtxID = 1 to skinops.getnumbervertices obj[4][1] do 
            ( 
               if skinops.isvertexselected obj[4][1] vtxID == 1 then 
               ( 
                  for vtxCount = 1 to  skinops.getvertexweightcount obj[4][1] vtxID do 
                  ( 
                     BoneID = skinops.getvertexweightboneID obj[4][1] vtxID vtxCount 
                     MyWeight = skinOps.GetVertexWeight obj[4][1] vtxID vtxCount 
                     append CopyArray BoneID 
                     append CopyArray myWeight 
                  ) 
               ) 
            ) 
         ) 
         return CopyArray 
      ) 
       
      Global pasteVtxweight 
      fn pasteVtxweight obj tmpBones tmpWeights = 
      ( 
         for vtxID = 1 to skinops.getnumbervertices obj[4][1] do 
         ( 
            if skinops.isvertexselected obj[4][1] vtxID == 1 then 
            (       
               skinOps.ReplaceVertexWeights obj[4][1] VTXID tmpBones tmpWeights 
            ) 
         ) 
      ) 
       
      ------------------------------------------------------------------------------------------------------------ 
      Global InitializeEnv 
      fn InitializeEnv obj = 
      ( 
         max modify mode 
         if classof obj[4][1].value == skin then 
         ( 
            for vtxID = 1 to skinops.getnumbervertices obj[4][1] do 
            ( 
               for thisBone = 1 to  skinops.getnumberBones obj[4][1] do 
               ( 
                  for CSCount = 1 to skinOps.GetNumberCrossSections obj[4][1] thisBone do 
                  ( 
                     skinOps.setOuterRadius obj[4][1] thisBone CSCount 0 
                     skinOps.setInnerRadius obj[4][1] thisBone CSCount 0 
                  ) 
                  skinOps.ReplaceVertexWeights obj[4][1] vtxID thisbone 0 
               ) 
            ) 
         ) 
      ) 
      ------------------------------------------------------------------------------------------------------------    
    
      Global Write_File            -- W R I T E 
      fn Write_File MyPOSFileName MyDataArray = 
      ( 
         try 
         ( 
            myFSValue = createfile MyPOSFileName          
            if myFSValue != undefined  then 
            ( 
               print MyDataArray 
               print (MyPOSFileName + " created") 
               myFSValue = openfile MyPOSFileName mode:"w+" 
               Seek myFSValue 0 
               for MyData in MyDataArray do print MyData to:myFSValue 
               try 
               ( 
                  flush myFSValue 
                  close myFSValue 
               ) 
               catch (print "can't close") 
            ) 
            else print "Error" 
         ) 
         catch(print "Error creating file")    
      ) 
       
      Global Read_File            -- R E A D 
      fn Read_File MyPOSFileName = 
      ( 
         MyDataArray = #() 
         try 
         ( 
            myReadFSValue = openfile MyPOSFileName 
            if myReadFSValue != undefined then 
            ( 
               print ("reading... " + MyPOSFileName) 
               while not(eof myReadFSValue) do 
               ( 
                  MyData = readvalue myReadFSValue 
--                  MyData = readline myReadFSValue 
--                  MyData = readChar myReadFSValue 
                  append MyDataArray MyData 
               ) 
            ) 
         ) 
         Catch(messageBox "Problem reading file";MyDataArray=#()) 
         return MyDataArray 
      ) 
      -------------------------------------------------------------  F U N C T I O N S  -----------------------    
   ) 

   on skin_rollout close do 
   ( 
      callBacks.removeScripts #selectionSetChanged 
      gc() 
    ) 

   on btnSaveCameraFOV pressed do 
   ( 
         FOVArray = #() 
         MyPOSFileName = MyPath + $cam.name + "FOV" + ".txt" 
         for t = spnStart.value to spnEnd.value do at time t 
         ( 
            str = t as string 
            str2 = str + "   "  +  $cam[4][1].value as string 
--            append FOVArray   $cam[4][1].value 
            append FOVArray str2 
         ) 
          

         try 
         ( 
            Write_File MyPOSFileName FOVArray 
            print (MyPOSFileName + " saved...") 
         ) 
         catch(print ("Error saving modifier for : " + obj.name + ". Check env dir"))       
   ) 
    
   on btnSaveModifier pressed do 
   ( 

      clearlistener() 
      for obj in selection do 
      ( 
         POSITIONArray = #() 
         MyPath = maxfilepath 
         MyPOSFileName = MyPath + obj.name + ".txt" 
         append POSITIONArray "Adobe After Effects 6.5 Keyframe Data\n" 
         append POSITIONArray "   Unit Per Second   25" 
         append POSITIONArray "   Source Width   740" 
         append POSITIONArray "   Source Height   410" 
         append POSITIONArray "   Source Pixel Aspect Ratio   1" 
         append POSITIONArray "   Comp Pixel Aspect Ratio   1\n" 
         append POSITIONArray "Position" 
         append POSITIONArray "   Frame   X pixels   Y pixels   Z pixels" 
         for t = spnStart.value to spnEnd.value do at time t 
         ( 
            strFrame = t as string 
            strX = obj.center.x as string 
            strY = obj.center.y as string 
            strZ = obj.center.z as string 
            Negative_centerZ = (-1 * obj.center.z) as string 
            if chkAfter.checked then 
            ( 
               strZ = Negative_centerZ as string 
               str = "   " + strFrame + "   " + strX + "   " + Negative_centerZ + "   " + strY  as string 
            ) 
            else 
            ( 
                
               str = "   " + strFrame + "   " + strX + "   " + strY + "   " + strZ 
            ) 
            append POSITIONArray str 
         ) 
         append POSITIONArray "\n\nEnd of Keyframe Data" 
         try 
         ( 
            Write_File MyPOSFileName POSITIONArray 
            print (MyPOSFileName + " saved...") 
         ) 
         catch(print ("Error saving modifier for : " + obj.name + ". Check env dir")) 
      ) 
   ) 
    
) 
addRollOut skin_rollout POS_Fltr 
