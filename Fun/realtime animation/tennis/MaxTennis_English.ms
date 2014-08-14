---------------------------------------------------------------------------
/*************************************************************************/
/***************************    Max Tennis   *****************************/
/*************************** by Enrique Gato *****************************/
/************************* www.insidemotion.com **************************/
/*************************************************************************/
---------------------------------------------------------------------------
global raqueta_1, raqueta_2, pelota, campo
global pos -- posición del ratón
global reloj -- para sincronizar a 25 fps
global tiempoTranscurrido --tiempo que ha pasado desde que se ha pintado un frame hasta el siguiente
global posRollout = [2,30]
global terminarJuego = false
global velRaton = 1.5

-----------------------------------------------------------------
--------------------- OPERACIONES PREVIAS -----------------------
-----------------------------------------------------------------

if Objects.count > 0 then
(
	if (querybox "All the objects in the current scene will be deleted. Do you really want to continue?") then
		try (destroyDialog rollTenis) catch()
	else
		terminarJuego = true	
)

-----------------------------------------------------------------
--------------------------- FUNCIONES ---------------------------
-----------------------------------------------------------------
fn colocarRaquetas raq1 raq2 =
(
	raq1.mover [(-campo.largo/2 + 50),0,0]
	raq2.mover [(campo.largo/2 - 50),0,0]
)


fn comprobarEsc =
(
	if keyboard.escPressed then
		if (querybox "¿Terminar juego?") then
		(
			terminarJuego = true
			true
		)
		else
		(
			reloj = timeStamp()
			pos = mouse.screenpos.y
			false
		)
	else
		false
)


fn resetear=
(
	delete objects
	viewport.resetAllViews()
)


-----------------------------------------------------------------
------------------------------ TOOLS ----------------------------
-----------------------------------------------------------------

tool toolSacar
(
	local continuar = false
	local pos = mouse.screenpos.y

	on mousepoint value do
	(
		pelota.generarAngulo 130 230
		stoptool toolSacar
	)
	
	on freemove do
	(	
		if comprobarEsc() then stopTool toolSacar
		setsyscur #arrow
		raqueta_1.actualizarAuto ignorarPosicionBola:true ignorarReloj:true
		raqueta_2.actualizar()
		pelota.mover (raqueta_2.objeto.pos - [pelota.radio,0,0] - [3,0,0])

		redrawViews()
	)
)


--------------------------------------------
----------------- RAQUETA ------------------
--------------------------------------------
struct strRaqueta 
(
	x = 0.0,
	y = 0.0,
	ancho = 50,
	velocidad = 0,
	nivel = 3 * 3,
	puntos = 0,
	objeto = chamferBox name:"Raqueta" pos:[0,0,0] height:10 width:10 length:ancho fillet:5 fillet_segments:3 wirecolor:[255,100,0],
	
	-- actualiza la posición de la raqueta comprobando que no se sale del campo
	fn actualizar =
	(
		objeto.pos.y +=  (velRaton * (pos - mouse.screenpos.y))
		y = objeto.pos.y
		pos = mouse.screenpos.y
		
		if y > (campo.ancho/2 - ancho/2) then
		(
			y = (campo.ancho/2 - ancho/2)
		)
		if y < (-campo.ancho/2 + ancho/2) then 
		(
			y = (-campo.ancho/2 + ancho/2)
		)
		
		objeto.pos.y = y

	),
	
	fn actualizarAuto ignorarPosicionBola:false ignorarReloj:false =
	(
		movimiento = 1 /* 1=der -1=izq */
		if y > pelota.y then movimiento = -1
		cantidadMovimiento = nivel
		if abs (y - pelota.y) < nivel then cantidadMovimiento = abs (y - pelota.y)
		
		if (pelota.x < 0 or ignorarPosicionBola) then 
		(	
			if ignorarReloj then tiempoTranscurrido = 0.5
			objeto.pos.y += (cantidadMovimiento * movimiento * tiempoTranscurrido)
			y = objeto.pos.y
		)
	),
	
	fn mover posicion =
	(
		objeto.pos = posicion
		x = posicion.x
		y = posicion.y
	),
	
	fn sacar = (startTool toolSacar),
	
	fn sacarAuto =
	(
		posSaqueY = random (-campo.ancho/2 + raqueta_1.ancho/2) (campo.ancho/2 - raqueta_2.ancho/2)
		step = -(y - posSaqueY) / 15
		reloj = timeStamp()
		
		while (abs(posSaqueY - y)>5) and (not comprobarEsc()) do
		(
			tiempo = (timeStamp() - reloj)/40.0
			reloj = timeStamp()
			
			objeto.pos.y += step * tiempo
			y = objeto.pos.y
			
			pelota.mover (objeto.pos + [pelota.radio,0,0] + [3,0,0])
			raqueta_2.actualizar()
			
			redrawViews()		
		)
		
		pelota.angulo = random -50 50
		pelota.direccion = [cos pelota.angulo,sin pelota.angulo]

	),
	
	fn ganar puntosOrdenador puntosJugador =
	(
		mensajesCasi = #("It was hard, but you got it.\nTry a harder level!!",
						 "Congratulations! That was a great match!!\nNow try another level!",
						 "What a great match!! Congratulations!!\nTry something harder now!")
		mensajesSobrao = #("Come on, try something harder now! This was so easy!",
						   "Well, you won, that's the fact but, why don't you play\n a higher level so we can see a good match?",
						   "I didn't see you sweat a lot... Come on, get a harder level!!")
						   
		numMensaje = random 1 3
		
		mensaje = mensajesSobrao[numMensaje]
		if puntosJugador - puntosOrdenador < 4 then mensaje = mensajesCasi[numMensaje]
		
		messagebox mensaje title:"You won!!!"
		terminarjuego = true
	),
	
	fn perder puntosOrdenador puntosJugador =
	(
		mensajesCasi = #("It was so close!! You must kick that computer's but!!",
						 "Oh, come on, you almost got it! Try again!",
						 "Very close, but not enougth!")
		mensajes1punto = #("AAAARRG!! Damn computer!!",
						   "FU#&%#$G MACHINE!!! Only one point!!",
						   "OH GOD! I can't believe it!! You lost by only 1 point!!")
		mensajesMal = #("No, no, no, no... You need more practice. ",
						"Come on baby, you were like a toy in computer's hands. ",
						"What the hell are you doing? This is a tennis game!!")
		numMensaje = random 1 3
		
		mensaje = mensajesMal[numMensaje]
		if (puntosOrdenador - puntosJugador) < 3 then mensaje = mensajesCasi[numMensaje]
		if (puntosOrdenador - puntosJugador) == 1 then mensaje = mensajes1punto[numMensaje]

		messagebox mensaje title:"You lost!!"
		terminarjuego = true
	)
	
	
)
	

--------------------------------------------
------------------ PELOTA ------------------
--------------------------------------------
struct strPelota 
(
	x = 0.0,
	y = 0.0,
	radio=10,
	angulo = (if (random -1 1)< 0 then random -50 50 else random 130 230),
	velocidad=3,
	direccion=[(cos angulo),(sin angulo)],
	objeto,
	
	fn crearPelota = 
	(
		objeto = sphere name:"Pelota" pos:[x,y,0] radius:radio wirecolor:[200,0,255]
	),
	
	fn generarAngulo angMin angMax = 
	(
		angulo = random angMin angMax
		direccion = [(cos angulo), (sin angulo)]
	),
	
	fn actualizar = 
	(
		objeto.pos.x += (direccion.x * velocidad * tiempoTranscurrido) as float
		objeto.pos.y += (direccion.y * velocidad * tiempoTranscurrido) as float
		x = objeto.pos.x
		y = objeto.pos.y
	),
	
	fn mover posicion =
	(
		objeto.pos = posicion
		x = posicion.x
		y = posicion.y
	)
)

--------------------------------------------
------------------ CAMPO -------------------
--------------------------------------------
struct strCampo 
(
	ancho=200,
	largo=350,
	objeto,
	cam = targetCamera name:"", 
	camTarget = Dummy boxsize:[0,0,0],
	marcador = text name:"marcador" size:60 pos:[0,ancho/2,30] text:"0 - 0" wirecolor:[224,188,57],
	
	fn crearCampo =
	(
		
		-- creamos las piezas del campo			
		local colorCampo = color 150 177 26
		local colorFondos = color 255 35 15		
		local colorRallas = color 255 255 255
		local colorSuelo = color 10 50 10		
		
		b1 = box name:"campoDer" pos:[largo/2,0,0] length:ancho height:2 width:20 wirecolor:colorFondos
		b2 = box name:"campoIzq" pos:[-largo/2,0,0] length:ancho height:2 width:20 wirecolor:colorFondos
		b3 = box name:"campoSup" pos:[0,ancho/2,0] length:20 height:20 width:largo wirecolor:colorCampo
		b4 = box name:"campoInf" pos:[0,-ancho/2,0] length:20 height:20 width:largo wirecolor:colorCampo
		b5 = plane name:"rallaLarga" pos:[0,0,0] length:5 width:largo wirecolor:colorRallas
		b6 = plane name:"suelo" pos:[0,0,-1] length:ancho width:largo wirecolor:colorSuelo
		b7 = box name:"fondoMarcador" pos:[0,(ancho/2 + 25),20] width:200 height:5 length:60 wirecolor:[38,61,140]
		
 		addModifier marcador (extrude())
		
		-- agrupamos todas las piezas del campo
		objeto = group #(b1,b2,b3,b4,b5,b6)		
		
		-- creamos la cámara de juego
		cam.pos = [0,-100,((campo.ancho + campo.largo)/0.9)]
		camTarget.pos = [0,30,0]
		cam.rotation = quat 0 0 0 1
	),
	
	fn modificarCampo anchura longitud =
	(
		ancho = anchura
		largo = longitud
		$campoDer.pos = [largo/2,0,0]; $campoDer.length = ancho; 
		$campoIzq.pos = [-largo/2,0,0]; $campoIzq.length = ancho;
		$campoSup.pos = [0,ancho/2,0]; $campoSup.width = largo;
		$campoInf.pos = [0,-ancho/2,0]; $campoInf.width = largo;
		$Suelo.width = largo; $suelo.length = ancho
		$rallaLarga.width = largo;
		$marcador.pos = [0,campo.ancho/2,30]
		$fondoMarcador.pos = [0,(ancho/2 + 30),20]
		
		cam.pos.z = (campo.ancho + campo.largo)/0.9
	)
	
)



-----------------------------------------------------------------------------
--------------------------- ROLLOUT INSTRUCCIONES ---------------------------
-----------------------------------------------------------------------------
rollout rollInstrucciones "Instrucciones MaxTennis v1.0" width:256 height:320
(
	
	label lbl3 "    You have to defeat the computer making the ball reach your opponent's red zone.  You can Puedes direct the ball by hiting it with the borders of your racket, or moving the racket quickly in any direction when you hit the ball." pos:[8,8] width:240 height:80
	label lbl4 "    You can setup every kind of parameters in order to make easier or harder the game: playground dimensions, racket's size, ball's speed, opponent's level... The more opponent's level, the more speed you'll have to setup to the ball if you want to be able to make points." pos:[8,96] width:240 height:88


	GroupBox grp1 "Controls" pos:[8,192] width:232 height:72
	label lbl1 "- Move:   Mouse up/down" pos:[16,208] width:160 height:16
	label lbl2 "- Service:    Left Mouse Button" pos:[16,224] width:168 height:18
	label lbl16 "- Stop/Pause:   Esc" pos:[16,240] width:168 height:18


	button btnCerrar "Cerrar" pos:[9,272] width:231 height:34
	
	on btnCerrar pressed do
	(
		destroyDialog rollInstrucciones
	)
)



-----------------------------------------------------------------------------
----------------------------- ROLLOUT PRINCIPAL -----------------------------
-----------------------------------------------------------------------------
rollout rollTenis "MaxTennis v1.0" width:160 height:544
(
	GroupBox grpOpsRaqueta "Racket options" pos:[8,8] width:144 height:64
	spinner spnRaqueta2 "Yours" pos:[56,24] width:51 height:16 range:[25,75,50] type:#integer
	spinner spnRaqueta1 "Computer" pos:[45,48] width:62 height:16 range:[25,75,50] type:#integer
	
	GroupBox grpOpsPelota "Ball options" pos:[8,160] width:144 height:64
	spinner spnVelocidad "Speed" pos:[48,176] width:79 height:16 range:[1,10,4] type:#integer
	spinner spnTamañoBola "Size" pos:[56,200] width:71 height:16 range:[3,20,10] type:#integer
	
	GroupBox grpOpsCampo "Playground options" pos:[8,83] width:144 height:72
	spinner spnAnchoCampo "Width" pos:[50,99] width:76 height:16 range:[200,500,300] type:#integer
	spinner spnLargoCampo "Length" pos:[48,123] width:78 height:16 range:[350,700,400] type:#integer
	
	GroupBox grpOpJuego "Gameplay options" pos:[8,232] width:144 height:96
	spinner spnNivel "Level" pos:[60,272] width:55 height:16 range:[1,10,4] type:#integer
	spinner spnNumPuntos "Play up to" pos:[48,249] width:67 height:16 range:[3,30,10] type:#integer
	label lblAux "points" pos:[117,248] width:30 height:16
	spinner spnVelRaton "Mouse speed" pos:[40,299] range:[1,4,2] width:75 height:16 type:#integer
	
	button btnJugar "Play" pos:[8,392] width:144 height:48
	button btnInstrucciones "Instructions" pos:[8,440] width:88 height:24
	button btnCerrar "Close" pos:[96,440] width:56 height:24
	
	GroupBox grp9 "" pos:[8,472] width:144 height:64
	dropdownList ddlPresets "Presets" pos:[8,332] width:144 height:40 items:#("Extremely easy", "Easy", "Medium level", "Large easy hall", "Large hard hall", "Easy madness", "Medium madness", "Hard madness", "Easy great hall", "Medium great hall", "Hard great hall", "Extremely hard") selection:3
	label lbl2 "By Enrique Gato - oct 2004" pos:[16,488] width:128 height:14
	button btnInsideMotion "www.InsideMotion.com" pos:[16,508] width:128 height:16
	
	on rollTenis open do
	(
		toolMode.coordsys #world
		
		delete objects
		
		cui.expertModeOn()
		
		-- generamos una semilla aleatoria para los random
		seed (timestamp())
		
		-- creamos el campo de juego
		campo = strCampo ancho:spnAnchoCampo.value largo:spnLargoCampo.value
		campo.crearCampo()
		
		-- generamos la configuración de los visores y activamos la cámara de juego
		viewport.resetAllViews()
		viewport.setLayout #layout_1
		viewport.setCamera campo.cam
		viewport.setGridVisibility #all false
		max wire smooth
		
		raqueta_1 = strRaqueta ancho:spnRaqueta1.value nivel:(spnNivel.value*2)
		raqueta_2 = strRaqueta ancho:spnRaqueta2.value --a la raqueta 2 no hay que especificar nivel
		colocarRaquetas raqueta_1 raqueta_2
		
	
		pelota = strPelota velocidad:(spnVelocidad.value * 5) radio:spnTamañoBola.value
		pelota.crearPelota()
		
		campo.cam.target = campo.camTarget
		campo.cam.controller.UseTargetAsUpNode = true
		
		for obj in objects do
		(
			obj.showFrozenInGray = false
			freeze obj
		)
		
	)
	on rollTenis close do
	(
		resetear()
		cui.expertModeOff()
	)
	on spnRaqueta2 changed value do
	(
		raqueta_2.ancho = value
		raqueta_2.objeto.length = raqueta_2.ancho
	)
	on spnRaqueta1 changed value do
	(
		raqueta_1.ancho = value
		raqueta_1.objeto.length = raqueta_1.ancho
	)
	on spnVelocidad changed value do
	(
		pelota.velocidad = value * 5
	)
	on spnTamañoBola changed value do
	(
		pelota.objeto.radius = value
		pelota.radio = value
	)
	on spnAnchoCampo changed value do
	(
		campo.modificarCampo spnAnchoCampo.value spnLargoCampo.value
	)
	on spnLargoCampo changed value do
	(
		campo.modificarCampo spnAnchoCampo.value spnLargoCampo.value
		colocarRaquetas raqueta_1 raqueta_2
	)
	on spnNivel changed value do
	(
		raqueta_1.nivel = value*3
	)
	on spnVelRaton changed value do
	(
		velRaton = (value*1.5)/2 
	)
		on btnInstrucciones pressed do
	(
		createDialog rollInstrucciones "" modal:true
	)
	on btnCerrar pressed do
	(
		if (querybox "Do you really want to close?") then
		(
			resetear()
			destroyDialog rollTenis
		)
	)
	on btnInsideMotion pressed do
	(
		try (shelllaunch "explorer.exe" "http://www.insidemotion.com") catch (messagebox "Couldn't start the web browser. Enter www.insidemotion.com ")
	)
	on ddlPresets selected value do
	(
		valores = #()
		case value of
		(
			1: valores = #(75,25,3,20,300,400,10,2)		-- Extremely easy
			2: valores = #(60,40,4,15,300,400,10,3)		-- Easy
			3: valores = #(50,50,4,10,300,400,10,4)		-- Medium level
			4: valores = #(60,40,4,15,400,700,10,3)		-- Large easy hall
			5: valores = #(40,60,7,10,400,700,10,7)		-- Large hard hall
			6: valores = #(50,40,5,10,350,350,10,5)		-- Easy madness
			7: valores = #(50,50,6,10,350,350,10,8)		-- Medium madness
			8: valores = #(40,50,7,10,350,350,10,10)	-- Hard madness
			9: valores = #(60,40,7,10,500,700,10,8)		-- Easy great hall
			10: valores = #(50,50,8,10,500,700,10,9)  	-- Medium great hall 
			11: valores = #(40,60,8,10,500,700,10,10)	-- Hard great hall
			12: valores = #(50,50,8,10,300,450,10,10)	-- Extremely hard
		)
		
		spnRaqueta2.value = valores[1]; spnRaqueta1.value = valores[2]; spnRaqueta2.changed valores[1]; spnRaqueta1.changed valores[2]; 
		spnVelocidad.value = valores[3]; spnTamañoBola.value = valores[4]; spnVelocidad.changed valores[3]; spnTamañoBola.changed valores[4];
		spnAnchoCampo.value = valores[5]; spnLargoCampo.value = valores[6];	spnAnchoCampo.changed valores[5]; spnLargoCampo.changed valores[6];
		spnNumPuntos.value = valores[7]
		spnNivel.value = valores[8]
		spnNivel.changed valores[8]
	
	)	
	on btnJugar pressed do
	(
	
		campo.marcador.text = "0 - 0"		
		setDialogPos rollTenis [2000,2000]
		
		pos = mouse.screenpos.y
		
		posAnterior1 = raqueta_1.y
		posAnterior2 = raqueta_2.y
	
		pelota.generarAngulo 130 230
		
		raqueta_2.y = 0
		
		terminarJuego = false
		
		-- iniciamos la cámara
		campo.cam.pos.x = raqueta_2.x/4
		campo.cam.target.pos.x = raqueta_2.x/4
	
		raqueta_2.sacar()
		
		reloj = timeStamp()
				
		while (not terminarJuego) do
		(
			
			
			raqueta_1.velocidad = raqueta_2.y - posAnterior1
			raqueta_2.velocidad = raqueta_2.y - posAnterior2
			posAnterior1 = raqueta_1.y
			posAnterior2 = raqueta_2.y
			
			-- número de fotogramas transcurridos a 25fps (1000/40 = 25)
			tiempoTranscurrido = ((timeStamp() - reloj)/40.0)
			
			--actualizamos la posición de la pelota
			pelota.actualizar()
			
			
			-- actualizamos la posición de la raqueta1
			raqueta_1.actualizarAuto()
			
			-- actualizamos la posición de la raqueta 2
			raqueta_2.actualizar()
			
			-- actualizamos la cámara
			campo.cam.pos.x = pelota.x/4
			campo.cam.target.pos.x = pelota.x/4
			
			
			-- actualizamos viewports solo si es necesario
			if tiempoTranscurrido>0 then reloj = timeStamp()

			forceCompleteRedraw()	
			
			-- rebote contra la raqueta derecha
			if ((pelota.direccion.x > 0) and
				(pelota.x > (raqueta_2.objeto.pos.x - 5 - pelota.radio)) and
				(pelota.x < (raqueta_2.x + 5)) and
				(pelota.y > (raqueta_2.y - raqueta_2.ancho/2 - pelota.radio)) and
				(pelota.y < (raqueta_2.y + raqueta_2.ancho/2 + pelota.radio))) then
			   (
			   		-- creamos el vector que modifica la dirección de la bola trazándolo desde el centro de la raqueta
					-- hasta el punto donde está la pelota y se lo sumamos a su dirección 
			   		v = [(pelota.x - (raqueta_2.x + 5)),
						 (pelota.y - raqueta_2.y)]
					
					v = normalize v
					
					contadorGolpes = 0
	
					pelota.direccion.x *= -1
					pelota.direccion.y += v.y
					pelota.direccion = normalize pelota.direccion
				)
	
	
			-- rebote contra la raqueta izquierda
			if ((pelota.direccion.x < 0) and
				(pelota.x < (raqueta_1.x + 5 + pelota.radio)) and
				(pelota.x > (raqueta_1.x - 5)) and
				(pelota.y < (raqueta_1.y + raqueta_1.ancho/2 + pelota.radio)) and
				(pelota.y > (raqueta_1.y - raqueta_1.ancho/2 - pelota.radio))) then
			   (
	
			   		-- creamos el vector que modifica la dirección de la bola trazándolo desde el centro de la raqueta
					-- hasta el punto donde está la pelota y se lo sumamos a su dirección
					v = [(pelota.x - (raqueta_1.x - 5)),
						 (pelota.y - raqueta_1.y)]
					
					v = normalize v
					
					pelota.direccion.x *= -1
					pelota.direccion.y += v.y
					pelota.direccion = normalize pelota.direccion
				)
	
			
			-- rebote en paredes laterales
			if ((pelota.y + pelota.radio) >= (campo.ancho/2 - 10)) and 
				(pelota.direccion.y > 0) then
				pelota.direccion.y *= -1
				
			
			if ((pelota.y - pelota.radio) <= (-campo.ancho/2 + 10)) and
				(pelota.direccion.y < 0) then 
			   	pelota.direccion.y *= -1
				
			--- Generamos un punto ---
			if (pelota.x >= (campo.largo/2-pelota.radio)) or
			   (pelota.x <= (-campo.largo/2+pelota.radio)) then
			(
				if pelota.x > 0 then (raqueta_1.puntos += 1; raq = 2)
				if pelota.x < 0 then (raqueta_2.puntos += 1; raq = 1)
				
				campo.marcador.text = (raqueta_1.puntos as string)+" - " + (raqueta_2.puntos as string)
				redrawViews()
				
				if raqueta_1.puntos == spnNumPuntos.value then (raqueta_2.perder raqueta_1.puntos raqueta_2.puntos)
				if raqueta_2.puntos == spnNumPuntos.value then (raqueta_2.ganar raqueta_1.puntos raqueta_2.puntos)
				
				-- si no ha terminado el juego damos el saque a quien corresponda
				if not terminarJuego then
				(
					-- si sacamos permitimos colocar la raqueta
					if raq == 2 then 
					(
						raqueta_2.sacar()
						pelota.generarAngulo 130 230
						pos = mouse.screenpos.y
					)
					
					-- si saca el ordenador se coloca automáticamente y saca
					if raq == 1 then raqueta_1.sacarAuto()
					
					posAnterior1 = 0
					posAnterior2 = 0
					pos = mouse.screenpos.y
				)
				
				
				-- actualizaos el reloj por el tiempo perdido generando el punto
				reloj = timeStamp()
			)--generar punto
			

			-- controlamos si se ha pulsado Esc
			comprobarEsc()
	
		)-- while
		
		-- controlamos el final del juego
		setDialogPos rollTenis posRollout
		
		pelota.objeto.pos = [0,0,0]
		
		campo.cam.pos.x = 0
		campo.camTarget.pos.x = 0
		
		colocarRaquetas raqueta_1 raqueta_2
		raqueta_1.puntos = 0
		raqueta_2.puntos = 0
			
	)-- btnJugarPressed

)
--------------- INICIAMOS EL SCRIPT ------------------

if not terminarJuego then createDialog rollTenis pos:posRollout --modal:true

