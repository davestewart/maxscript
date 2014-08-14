

function PMI_initThreeD(fooThreeD){
	fooThreeD[0] = 0;
	fooThreeD[1] = 0;
	fooThreeD[2] = 0;
}
function PMI_copyThreeD(fromVec, toVec){
	toVec[0] = fromVec[0];
	toVec[1] = fromVec[1];
	toVec[2] = fromVec[2];
}
// fooThreeD = Avector - Bvector;
function PMI_subtractThreeD(fooThreeD, Avector, Bvector) {
	fooThreeD[0] = Avector[0] - Bvector[0];
	fooThreeD[1] = Avector[1] - Bvector[1];
	fooThreeD[2] = Avector[2] - Bvector[2];
}
function PMI_addScaledThreeD(fooThreeD, scale, vector) {
	fooThreeD[0] += scale * vector[0];
	fooThreeD[1] += scale * vector[1];
	fooThreeD[2] += scale * vector[2];
}
function PMI_divideThreeD(fooThreeD, divideBy) {
	fooThreeD[0] /= divideBy;
	fooThreeD[1] /= divideBy;
	fooThreeD[2] /= divideBy;
}

function PMI_multiplyThreeD(fooThreeD, multiplyBy) {
	fooThreeD[0] *= multiplyBy;
	fooThreeD[1] *= multiplyBy;
	fooThreeD[2] *= multiplyBy;
}
function PMI_dotProductThreeD(fooThreeD, barThreeD) {
	return (fooThreeD[0] * barThreeD[0] +
		fooThreeD[1] * barThreeD[1] +
		fooThreeD[2] * barThreeD[2]);
}
function PMI_lengthThreeD(fooThreeD) {
	var length = PMI_dotProductThreeD(fooThreeD, fooThreeD);
	if (length == 0) {
		return 0;
	} else {
		return Math.sqrt(length);
	}
}
function PMI_normalizeThreeD(fooThreeD)
{
	var length = PMI_lengthThreeD(fooThreeD);
	if (length != 0) {
		PMI_multiplyThreeD(fooThreeD, (1.0 / length));
	}
	return length;
}
