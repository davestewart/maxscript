//
// This function constructs a BouncingBallSimulation.
//
//
// Note: all points are expressed in an AE coordinate system:
//	  -X to +X goes from left to right
// 	  -Y to +Y goes from up to down
//
function BouncingBallSimulation() {

	// World's properties and starting conditions:
	//
	this.gravity       = [ 0.0,   98.0, 0.0 ];	
	// Boundaries for bouncing
	this.boundsLeft = 0;
	this.boundsRight = 100;
	this.boundsTop = 0;
	this.boundsBottom = 100;

	// Time Recording Info
	this.startTime = 0.0;
	this.endTime   = 10.0;
	this.frameRate = 30.0;
	this.frameDuration = 1.0 / 30.0;

	//
	// World's state, which changes over time.
	//
	this.curTime   = 0.0;


	// Ball's properties and  starting conditions:
	//
	this.mass          = 400.0;
	this.density       = 10;
	this.width	   = 100;
	this.height        = 100;
	this.drag	   = 0.0;  			// 1 means complete opposing force
	this.elasticity    = 0.75;  			// 1 means perfect bounce
	this.startPosition = [ 0.0,   0.0, 0.0 ];
	this.startVelocity = [ 0.0,   0.0, 0.0 ];
	//
	// Ball's state, which changes over time.
	//
	this.position       = [   0.0,   0.0,   0.0];
	this.velocity       = [   0.0,   0.0,   0.0];
	this.acceleration   = [   0.0,   0.0,   0.0];
	this.appliedForce   = [   0.0,   0.0,   0.0];

	// 
	// Storing the results:
	//
	this.keyframeTimeResults = [];
	this.ballPositionResults = [];
	// 
	// Destination for the results:
	//
	this.ballLayer   = null;

	function my_initializeSimulation() {
		with(this) {
			// Width and height come from the ball layer
			width  = ballLayer.width  * 0.01 * ballLayer.scale.valueAtTime(startTime,true)[0];
			height = ballLayer.height * 0.01 * ballLayer.scale.valueAtTime(startTime,true)[1];

			// Mass comes from density times area
			mass = width * height * density;

			// Starting position comes from the ball layer:
			PMI_copyThreeD(ballLayer.position.valueAtTime(startTime,true),startPosition);
			// Starting velocity is difference between position at 1st and 2nd frames
			var frameTwoPos = ballLayer.position.valueAtTime(startTime+frameDuration,true);
			PMI_subtractThreeD(startVelocity,frameTwoPos,startPosition);
			// multiply by frameRate to change difference into velocity
			PMI_multiplyThreeD(startVelocity, frameRate);

			PMI_copyThreeD(startPosition, position);
			PMI_copyThreeD(startVelocity, velocity);
			PMI_initThreeD(acceleration);

			curTime = startTime;

			// Allocate the results buffers
			var num_frames_to_store = ((endTime - startTime) * frameRate ) + 1;

			// If the buffers are longer than we require, clear them out
			// so that we don't get leftover stuff from last time:
			if (keyframeTimeResults.length > num_frames_to_store) {
				keyframeTimeResults = [];
				ballPositionResults = [];
			}

			for (var i = 0; i < num_frames_to_store; i++) {
				keyframeTimeResults[i] = curTime + i * frameDuration;
				if (!ballPositionResults[i] || ballPositionResults[i] == null) {
					ballPositionResults[i] = [0,0,0];
				}
				// Not required since overrwritten, and not efficient.
				// PMI_copyThreeD([0,0,0], ballPositionResults[num_frames_to_store-1]);
			}
		}
	}

	function my_setBounds(newLeft, newRight, newTop, newBottom)
	{
		this.boundsLeft    = newLeft;
		this.boundsRight   = newRight;
		this.boundsTop     = newTop;
		this.boundsBottom  = newBottom;
	}

	function my_setBallLayer(layer) {
		this.ballLayer = layer;
	}

	function my_outputResults() {
		with(this) {
			if (ballLayer != null && ballLayer.position != null) {
				ballLayer.position.setValuesAtTimes(keyframeTimeResults, ballPositionResults);
			}
		}
	}

	function my_bounceOffWalls()
	{
		var did_bounce = false;
		with(this) {
			var half_height = height * 0.5;
			var half_width  = width  * 0.5;

			var lowest_height = boundsBottom - half_height;
			if (position[1] >= lowest_height) {
				velocity[1] = velocity[1] * -1;
				position[1] = lowest_height - (position[1] - lowest_height);
				PMI_multiplyThreeD(velocity, elasticity);
				did_bounce = true;
			}
			var highest_height = boundsTop + half_height;
			if (position[1] <= highest_height) {
				velocity[1] = velocity[1] * -1;
				position[1] = highest_height + (highest_height - position[1]);
				PMI_multiplyThreeD(velocity, elasticity);
				did_bounce = true;
			}
			var leftest_left = boundsLeft + half_width;
			if (position[0] <= leftest_left) {
				velocity[0] = velocity[0] * -1;
				position[0] = leftest_left + (leftest_left - position[0]);
				PMI_multiplyThreeD(velocity, elasticity);
				did_bounce = true;
			}
			var rightest_right = boundsRight - half_width;
			if (position[0] >= rightest_right) {
				velocity[0] = velocity[0] * -1;
				position[0] = rightest_right - (position[0] - rightest_right);
				PMI_multiplyThreeD(velocity, elasticity);
				did_bounce = true;
			}
		}
		return did_bounce;
	}

	function my_simulateTimeStep(stepSize) {
		// Calculate applied force at time "curTime", the beginning of the step.
		//
		// Initialize applied force:   F = (0,0,0)
		PMI_initThreeD(this.appliedForce);
		//
		// Add gravitational force:    F += m*a
		PMI_addScaledThreeD(this.appliedForce, this.mass, this.gravity);

		// Add drag force:             F += -drag*v*v
		var velo_direction = [0,0,0];
		PMI_copyThreeD(this.velocity, velo_direction);
		var velo_magnitude = PMI_normalizeThreeD(velo_direction);
		var drag_multiplier = this.drag * -1 * velo_magnitude * velo_magnitude;
		PMI_addScaledThreeD(this.appliedForce, drag_multiplier, velo_direction);

		// Calculate acceleration  at "curTime"
		//
		PMI_copyThreeD(this.appliedForce, this.acceleration);
		PMI_divideThreeD(this.acceleration, this.mass);

		// Apply acceleration over time step to get velocity at end of time step
		//
		PMI_addScaledThreeD(this.velocity, stepSize, this.acceleration);
		
		// Apply velocity over time step to get position at end of time step
		//
		PMI_addScaledThreeD(this.position, stepSize, this.velocity);

		// Keep bouncing til done, but cap the number of bounces to 4, in
		// case the bal is moving incredibly fast relative to the bounds of the walls.
		var num_bounces = 0;
		var did_bounce  = false;
		do {
			did_bounce = this.bounceOffWalls();
			num_bounces++;
		} while(num_bounces <= 4 && did_bounce == true);
	}

	function my_outputTimeStep(stepNum, atTime) {
		this.keyframeTimeResults[stepNum] = atTime;
		with(this) {
			PMI_copyThreeD(position, ballPositionResults[stepNum]);
			var show_diagnostics = false;
			if (show_diagnostics) {
				alert("t = " + atTime.toString() + ", position = " + this.position.toString());
			}
		}
	}

	function my_runSimulation() {
		if (this.ballLayer == null || this.ballLayer.position == null) {
			return;
		}
		this.initializeSimulation();
		var stepSize = this.frameDuration;
		this.stepNum = 0;
		this.curTime = this.startTime;
		this.outputTimeStep(this.stepNum, this.curTime);
		for (this.curTime = this.startTime; (this.curTime + stepSize) <= this.endTime; ) {
			this.simulateTimeStep(stepSize);
			this.curTime += stepSize
			this.stepNum++;
			this.outputTimeStep(this.stepNum, this.curTime);
		}
		this.outputResults();
	}

	// [3] assign all the functions to be method-type attributes.
	//
	this.runSimulation = my_runSimulation;
	this.setBounds	   = my_setBounds;
	this.setBallLayer  = my_setBallLayer;
	this.initializeSimulation = my_initializeSimulation;
	this.outputResults =  my_outputResults;
	this.bounceOffWalls   =  my_bounceOffWalls;
	this.simulateTimeStep =  my_simulateTimeStep;
	this.outputTimeStep =  my_outputTimeStep;

}

// var bouncingBallSimulation = new BouncingBallSimulation();
