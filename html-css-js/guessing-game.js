function fce(param) {
    console.log(param);
}

let isAlive = true;
let isWin = false;
let guess = -1;
let range = 1024;
let rounds = Math.floor(Math.log(range) / Math.log(2));
let rnum = Math.ceil(Math.random() * range);

console.log('guess which number i am thinkg!');

while (isAlive && !isWin) {
	console.log('guesses remaining: ' + rounds);
	guess = readline();

	if (guess == rnum) {
		isWin = true;
	}
	else if (guess < rnum) {
		console.log('guess higher');
	}
	else if (guess > rnum) {
		console.log('guess lower');
	}

	rounds--;
	if (rounds <= 0) {
		isAlive = false;
	}
}

if (isWin) {
	console.log('you won!');
} else {
	console.log('you lost!');
}

