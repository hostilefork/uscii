// http://ejohn.org/blog/ecmascript-5-strict-mode-json-and-more/
"strict mode"


// Add to AreciboAscii object which contains the table
// Declared in uscii-5x7-english-c0.js


//
// Ensure string has no codepoints higher than the table
// has been defined to support.
//
AreciboAscii.ensureCodepointsValid = function(str) {
	var index = undefined;

	//
	// Start by ensuring it's a string at all
	// http://stackoverflow.com/a/9436948/211160
	//
	if (!(typeof str === 'string' || str instanceof String)) {
		throw Error("ensureCodepointsValid received non-string");
	}

	//
	// Test each character and save the list of bad codes
	//
	var nonascii = [];
	for (index = 0; index < str.length; index++) {
		var codepoint = str.charCodeAt(index);
		if (codepoint >= this.bitstrings.length) {
			nonascii.push(codepoint);
		}
	}

	//
	// Remove duplicates of the bad codepoints and sort
	// http://stackoverflow.com/a/1961068/211160
	//
	var removeDuplicates = function(arr) {
		var u = {}, a = [];
		for (var i = 0, l = arr.length; i < l; ++i) {
			if(u.hasOwnProperty(arr[i])) {
				continue;
      		}
			a.push(arr[i]);
			u[arr[i]] = 1;
		}
		return a;
	}
	nonascii = removeDuplicates(nonascii.sort());

	//
	// Throw error message and include codepoints
	//
	if (nonascii.length > 0) {
		var message = "String contains non-ASCII codepoints:";
		for (index = 0; index < nonascii.length; nonascii++) {
			message += " ";
			message += String.fromCharCode(nonascii[index]);
		}
		throw Error(message);
	}
};


//
// Make gap strings, meter strings, silence strings
// http://stackoverflow.com/a/202627
//

AreciboAscii.repeatedString = function(str, times) {
	return new Array(times + 1).join(str);
};


AreciboAscii.zeroSilence = AreciboAscii.repeatedString(
	"0", AreciboAscii.width * AreciboAscii.height + AreciboAscii.width
);

AreciboAscii.meter = AreciboAscii.repeatedString(
	"1", AreciboAscii.width * AreciboAscii.height
);

AreciboAscii.gap = AreciboAscii.repeatedString(
	"0", AreciboAscii.width
);

AreciboAscii.oneSilence = AreciboAscii.repeatedString(
	"1", AreciboAscii.width * AreciboAscii.height + AreciboAscii.width
);



//
// Return the binary Arecibo Ascii encoding of the given string
// 
AreciboAscii.encodeAsBinary = function(str) {

	this.ensureCodepointsValid(str);

	var binary = "";
	var index;
		
	for (index = 0; index < this.height; index++) {
		binary += this.zeroSilence;
	}

	for (index = 0; index < this.width; index++) {
		binary += this.meter + this.gap;
	}

	for (index = 0; index < str.length; index++) {
		binary += this.bitstrings[str.charCodeAt(index)];
		binary += this.gap;
	}

	for (index = 0; index < this.height; index++) {
		binary += this.meter + this.gap;
	}

	for (index = 0; index < this.width; index++) {
		binary += this.oneSilence;
	}

	return binary;
};


AreciboAscii.decodeBinary = function(binary) {

	//
	// A good decoder should be able to tolerate any amount of
	// junk before the "leading silence" and after the "trailing
	// silence", but for the moment we'll expect no noise
	//

	var blocksize = this.width * this.height + this.width;

	if (binary.length % blocksize !== 0) {
		throw Error('Your input is ' + binary.length + 
			' bits long, but must be an even multiple of ' +
			blocksize + ' bits.'
		);
	}

	//
	// Split the binary string into an array of strings with
	// length equal to blocksize.
	// http://stackoverflow.com/questions/8359905/
	// http://stackoverflow.com/a/874722/211160
	//
	var blockExpr = ".{1," + blocksize + "}";
	var blocks = binary.match(new RegExp(blockExpr, "g"));

	if (blocks.length < (
		this.height /* leading silence */
		+ this.width /* leading meter */
		+ 1 /* one symbol minimum, possibly a null message indicator? */
		+ this.height /* trailing meter */
		+ this.width /* trailing silence */
	)) {
		throw Error(
			'Your input is ' + blocks.length + ' ' +
			blocksize + '-bit blocks long but must have at least ' +
			this.height + ' silence (all 0) blocks at the beginning,' +
			this.width + ' leading meter blocks, ' +
			1 + ' one block of actual data, ' +
			this.height + ' trailing meter blocks and' +
			this.width + '  silence (all 1) blocks at the end'
		);
	}

	var index = undefined;
	var decoded = "";

	// Take care of the silence on front and back...
	for (index = 0; index < this.height; index++) {
		if (blocks[0] != this.zeroSilence) {
			throw Error("Fewer than " + this.height + 
				" silence blocks at beginning of signal."
			);
		}
		blocks.shift();
	}
	for (index = 0; index < this.width; index++) {
		if (blocks[blocks.length - 1] != this.oneSilence) {
			throw Error(
				"Fewer than " + this.width + " silence blocks at end of signal."
			);
		}
		blocks.pop();
	}

	// Take care of the meter on front and back...
	for (index = 0; index < this.width; index++) {
		if (blocks[0] != this.meter + this.gap) {
			throw Error(
				"Fewer than " + this.width + " leading meter blocks in signal."
			);
		}
		blocks.shift();
	}
	for (index = 0; index < this.height; index++) {
		if (blocks[blocks.length - 1] != this.meter + this.gap) {
			throw Error(
				"Fewer than " + this.height + " trailing meter blocks in signal."
			);
		}
		blocks.pop();
	}

	// Build reverse table so we can convert quickly from bitstring to char index
	var reverseTable = {};
	for (index = 0; index < this.bitstrings.length; index++) {
		reverseTable[AreciboAscii.bitstrings[index]] = index;
	}

	var cellExpr = "^(.{1," + this.width * this.height + "})" + this.gap + "$";
	var cellRegex = new RegExp(cellExpr);

	// Should be down to just the message now...
	for (var index = 0; index < blocks.length; index ++) {
		var cell = cellRegex.exec(blocks[index]);
		if (!cell) {
			throw Error(
				'Arecibo ASCII payload must have units separated by ' +
				this.width + ' zeros.'
			);
		}
		if (!(cell[1] in reverseTable)) {
			throw Error(
				"Bit pattern found not in the USCII-5x7-ENGLISH-C0 table: " +
				cell[1]
			);
		}
		decoded += String.fromCharCode(reverseTable[cell[1]]);
	}

	return decoded;	
};


AreciboAscii.htmlForBitmaps = function(str, scaling, useCssSprite, scaleInBrowser) {

	var table = this.table;

	if (typeof(scaling) === 'undefined')
		scaling = 4;
	if (typeof(useCssSprite) === 'undefined')
		useCssSprite = true;
	if (typeof(scaleInBrowser) === 'undefined')
		scaleInBrowser = false;

	this.ensureCodepointsValid(str);

	var dblQuote = function(str) {
		return '"' + str + '"';
	}

	var cssAttr = function(attr, value) {
		return attr + ':' + ' ' + value + ';' + ' ';
	}

	var tagAttr = function(attr, value) {
		return attr + '=' + ' ' + '"' + value + '"' + ' ';
	}

	// Note: IE7 does not know lightgray is #D3D3D3
	var htmlForCodepointImage = function(codepoint) {
		var html = undefined;
		var imgSrc = undefined;

		if (useCssSprite) {
			// http://css-tricks.com/css-sprites/
			if (scaleInBrowser) {
				throw Error("Can't use browser scaling for CSS sprites.");
			} else {
				imgSrc = '../build/images/5x7/x' + scaling + '/all.png';

				// Would have used a span or div with width/height attributes
				// But css likes to ignore the height in those cases
				html = '<img ' +
					tagAttr('style',
						cssAttr('width', '' + this.width * scaling + 'px') +
						cssAttr('height', '' + this.height * scaling + 'px') +
						cssAttr('border', '1px solid #D3D3D3;') +
						cssAttr('background-image', "url('" + imgSrc + "')") +
						cssAttr('background-position',
							'0px' +
							' ' + // space separates x/y coords
							'-' + this.height * codepoint * scaling + 'px'
						)
					) +
					tagAttr('width', this.width * scaling) +
					tagAttr('height', this.height * scaling) +
					tagAttr('src', 'images/1x1.png') +
				'/>';
			}
		} else {
			if (scaleInBrowser) {
				imgSrc = '../build/images/5x7/x1/' + codepoint + '.png';
			} else {
				imgSrc = '../build/images/5x7/x' + scaleFactor + '/' + codepoint + '.png';
			}

			html = '<img ' +
				tagAttr('style', cssAttr('border', '1px solid #D3D3D3')) +
				tagAttr('width', this.width * scaling) +
				tagAttr('height', this.height * scaling) +
				tagAttr('src', imgSrc)
			'/>';
		}
		return html;
	}
	
	var htmlForMeterImage = function() {
		var html = undefined;
		var imgSrc = undefined;

		if (scaleInBrowser) {
			imgSrc = "../build/images/5x7/x1/meter.png";
		} else {
			imgSrc = "../build/images/5x7/x' + scaleFactor + '/meter.png";
		}

		html = '<img ' +
			tagAttr('style', cssAttr("border", "1px solid #D3D3D3")) +
			tagAttr('width', this.width * scaling) +
			tagAttr('height', this.height * scaling) +
			tagAttr('src', "../build/images/5x7/x1/meter.png") +
		'/>';

		return html;
	}

	var html = "";
	var index = undefined;

	for (index = 0; index < this.width; index++) {
		html += htmlForMeterImage.call(this);
	}

	for (index = 0; index < str.length; index++) {
		html += htmlForCodepointImage.call(this, str.charCodeAt(index));
	}

	for (index = 0; index < this.height; index++) {
		html += htmlForMeterImage.call(this);
	}

	return html;
};