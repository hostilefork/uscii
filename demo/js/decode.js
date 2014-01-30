//
// decode.js - Arecibo ASCII decoding module
// Copyright (C) 2009 HostileFork.com
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as
// published by the Free Software Foundation, either version 3 of the
// License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program. If not, see <http://www.gnu.org/licenses/>.
//
// See http://hostilefork.com/uscii for documentation.
//


var AreciboDecode = {};

document.observe("dom:loaded", function() {
 	// put startup code that doesn't need window state here
	
	// Build reverse table so we can convert quickly from bitstring to char index
	var areciboAsciiHash = {};
	for (var hashIndex = 0; hashIndex < AreciboAscii.bitstrings.length; hashIndex++) {
		areciboAsciiHash[AreciboAscii.bitstrings[hashIndex]] = hashIndex;
	}

	var lastInputChange = undefined; // msec since Jan 1, 1970
	var lastInput = undefined;
	var lastFormat = undefined;
	var inputProcessed = false;
	
	AreciboDecode.inputChanged = function() {
		if (($('mystring').value == lastInput) && ($('format_spin').value == lastFormat)) {
			return; // nothing changed, maybe they just moved the cursor?
		}
		
		lastInput = $('mystring').value;
		lastFormat = $('format_spin').value;
		inputProcessed = false;
		lastInputChange = (new Date()).getTime();
		window.setTimeout(AreciboDecode.update, 100);
		$('conversion').hide();
		$('bitmaps').hide();
		$('message_content').update('<center><img src="/media/demo/images/ajax-loader.gif" /></center>');
		$('message').show();
	};
	
	AreciboDecode.update = function() {
		if (inputProcessed) {
			return;
		}
		
		if ((new Date()).getTime() - lastInputChange < 500) {
			window.setTimeout(AreciboDecode.update, 100);
			return;
		}
		
		var result = undefined;
		try {
			result = AreciboDecode.updateCore(lastInput, lastFormat);
		} catch(err) {
			if ('ok' in err) {
				result = err;
			} else {
				result = {
					ok: false,
					type: "error",
					msg: 'Javascript Error: ' + err
				};
			}
		}
		if (!result.ok) {
			$('conversion').hide();
			$('bitmaps').hide();
		} else {
			$('conversion').show();
			$('bitmaps').show();
		}
		$('message_content').update('<div class="' + result.type + '">' + 
			((result.type == "info") ? '' : '<b>' + result.type.toUpperCase() + ':</b> ') + 
			result.msg + '</div>');
		$('message').show();
		
		inputProcessed = true;
	};
	
	AreciboDecode.updateCore = function(encodedString, format) {
		if (encodedString === "") {
			return {
				ok: false,
				type: "info",
				msg: '<p>This is a decoder for information in ' + 
					'USCII-5x7-ENGLISH-C0 format.  If you don\'t have anything in this format, ' +
					'then you can generate something using the encoder ' +
					'(which also does a pretty good job of explaining what this is all about!)</p>' +
					'<br />' +
					'<p><i>Type some data in the box above, or ' +
					'<a href="../encode/">try the encoder</a></i></p>' 
			};
		}

		// remove all whitespace: http://www.xploredotnet.com/2007/08/remove-white-space-in-string-using.html
		encodedString = encodedString.replace(/\s+/g,'');

		// convert input string to binary for processing
		var binaryString = undefined;
		switch (format) {
			case "Hexadecimal":
				binaryString = "";
				for (var hexIndex = 0; hexIndex < encodedString.length; hexIndex++) {
					switch (encodedString[hexIndex]) {
						case '0': binaryString += "0000"; break;
						case '1': binaryString += "0001"; break;
						case '2': binaryString += "0010"; break;
						case '3': binaryString += "0011"; break;
						case '4': binaryString += "0100"; break;
						case '5': binaryString += "0101"; break;
						case '6': binaryString += "0110"; break;
						case '7': binaryString += "0111"; break;
						case '8': binaryString += "1000"; break;
						case '9': binaryString += "1001"; break;
						case 'A': case 'a': binaryString += "1010"; break;
						case 'B': case 'b': binaryString += "1011"; break;
						case 'C': case 'c': binaryString += "1100"; break;
						case 'D': case 'd': binaryString += "1101"; break;
						case 'E': case 'e': binaryString += "1110"; break;
						case 'F': case 'f': binaryString += "1111"; break;
						default: 
							throw {
								ok: false,
								type: "error",
								msg: "Hex data may only contain 0-9 and A-F (or a-f)"
							};
					}
				}
				break;
				
			case "Binary":
				for (var binaryCheckIndex = 0; binaryCheckIndex < encodedString.length; binaryCheckIndex++) {
					switch (encodedString[binaryCheckIndex]) {
						case "1":
						case "0":
							break;
						default:
							// error message here.
							throw {
								ok: false,
								type: "error",
								msg: "Binary data may only contain 0 and 1"
							};
					}
				}
				binaryString = encodedString;
				break;
				
			default:
				throw {
					ok: false,
					type: "error",
					msg: 'Unknown source numeric base: "' + format + '"'
				};
		}

		var origWidth = 5;
		var origHeight = 7;
		var blocksize = (origWidth * origHeight + 1);
		
		if (binaryString.length % blocksize !== 0) {
			throw {
				ok: false,
				type: "error",
				msg: 'Your ' + format + ' input is ' + binaryString.length + 
					' bits long, but must be an even multiple of ' + blocksize + ' bits.'
			};
		}

		if ((binaryString.length / 36) < (7 + 5)) {
			throw {
				ok: false,
				type: "error",
				msg: 'Your input is ' + (binaryString.length / blocksize) + ' ' + blocksize + '-bit blocks long but must have at least ' + origWidth + ' meter blocks at the beginning and ' + origHeight + ' meter blocks at the end.'
			};
		}

		for (var checkZerosIndex = blocksize - 1; checkZerosIndex < binaryString.length; checkZerosIndex += blocksize) {
			if (binaryString[checkZerosIndex] != "0") {
				throw {
					ok: false,
					type: "error",
					msg: 'Every ' + blocksize + 'th bit in an Arecibo ASCII message must be 0.'
				};
			}
		}
		
		var meterBitstring = "";
		for (var meterIndex = 0; meterIndex < origWidth*origHeight; meterIndex++) {
			meterBitstring += "1";
		}
		
		var asciiString = "";
		var bitmapsString = "";

		var scaleFactor = 4;
		var useCssSprite = true;
		var scaleInBrowser = false;
		
		function imageHtmlString(charNum) {
			var elementString = undefined;
			if (useCssSprite) {
				// http://css-tricks.com/css-sprites/
				if (scaleInBrowser) {
					throw {
						ok: false,
						type: "error",
						msg: "Can't use browser scaling for CSS sprites, see http://stackoverflow.com/questions/376253/stretch-and-scale-css-background"
					};
				} else {
					// would have used a span or div with width/height attributes but css likes to ignore the height in those cases
					elementString = '<img style="width: ' + origWidth * scaleFactor + 'px; height: ' + origHeight * scaleFactor + 'px; border:1px solid #D3D3D3; background-image:url(\'/media/build/images/5x7/x' + scaleFactor + '/all.png\'); background-position:0px -' + origHeight * charNum * scaleFactor + 'px;" width="' + origWidth*scaleFactor + '" height="' + origHeight*scaleFactor + '" src="/media/demo/images/1x1.png" />';
				}
			} else {
				if (scaleInBrowser) {
					elementString = '<img style="border:1px solid #D3D3D3;" width="' + origWidth*scaleFactor + '" height="' + origHeight*scaleFactor + '" src="/media/build/images/5x7/x1/' + charNum + '.png" />';
				} else {
					elementString = '<img style="border:1px solid #D3D3D3;" width="' + origWidth*scaleFactor + '" height="' + origHeight*scaleFactor + '" src="/media/build/images/5x7/x' + scaleFactor + '/' + charNum + '.png" />';
				}
			}
			return elementString;
		}
		
		function meterHtmlString() {
			var elementString = undefined;
			if (scaleInBrowser) {
				elementString = '<img style="border:1px solid #D3D3D3;" width="' + origWidth*scaleFactor + '" height="' + origHeight*scaleFactor + '" src="/media/build/images/5x7/x1/meter.png" />';
			} else {
				elementString = '<img style="border:1px solid #D3D3D3;" width="' + origWidth*scaleFactor + '" height="' + origHeight*scaleFactor + '" src="/media/build/images/5x7/x' + scaleFactor + '/meter.png" />';
			}
			return elementString;
		}

		var convertBitIndex = 0;
		for (; convertBitIndex < blocksize * origWidth; convertBitIndex += 36) {
			var bitstringPreMeter = binaryString.substr(convertBitIndex, blocksize - 1);
			if (bitstringPreMeter != meterBitstring) {
				throw {
					ok: false,
					type: "error",
					msg: "Fewer than " + origWidth + " meter blocks at beginning of signal."
				};
			}
			bitmapsString += meterHtmlString();
		}
		
		for (; convertBitIndex < binaryString.length - blocksize * origHeight; convertBitIndex += blocksize) {
			var bitstring = binaryString.substr(convertBitIndex, blocksize - 1);
			if (!(bitstring in areciboAsciiHash)) {
				throw {
					ok: false,
					type: 'error',
					msg: "Bit pattern found that isn't in the USCII-5x7-ENGLISH-C0 table: " + bitstring
				};
			}
			var curCharConvert = areciboAsciiHash[bitstring];
			asciiString += String.fromCharCode(curCharConvert);
			bitmapsString += imageHtmlString(curCharConvert);
		}

		for (; convertBitIndex < binaryString.length; convertBitIndex += blocksize) {
			var bitstringPostMeter = binaryString.substr(convertBitIndex, blocksize - 1);
			if (bitstringPostMeter != meterBitstring) {
				throw {
					ok: false,
					type: "error",
					msg: "Fewer than " + origHeight + " meter blocks at end of signal."
				};
			}
			bitmapsString += meterHtmlString();
		}	
	
		if (0) {		
			/* Firefox can't break lines without invisible unicode "break 
			   opportunities".  I once used character entity &#8203; to offer it
			   those opportunities every 5 characters.  On the downside of this,
			   it means that people copying the text to the clipboard will end
			   up getting the weird characters too.  For that reason, I decided
			   to break every 36 symbols with a newline instead. */
			var breakableString = "";
			var breakSpacing = 36;
			for (var breakableIndex = 0; breakableIndex < convertedString.length; breakableIndex += breakSpacing) {
				// substr() method takes an index and a length
				breakableString += convertedString.substr(breakableIndex, breakSpacing);
				/* breakableString += "&#8203;"; */ // nasty clipboard properties
				breakableString += "<br />";
				
			}
			// substring() method takes two indices
			if (breakableIndex < convertedString.length - 1) {
				breakableString += convertedString.substring(breakableIndex, convertedString.length - 1);
			}
		}
		
		$('conversion_content').update(asciiString);
		$('bitmaps_content').update(bitmapsString);

		return {
			ok: true,
			type: "success",
			msg: 'ASCII is ' + asciiString.length + ' characters long'
		};
	};
	
	
	$('mystring').focus();
 	$('spec-name').update(AreciboAscii.name);
 	$('spec-version').update(AreciboAscii.version);
 	$('spec-date').update(AreciboAscii.date);

	// textarea may not be empty if page is reloaded...browser caches it
 	AreciboDecode.inputChanged();
 	
 	var formats = 'Binary Hexadecimal'.split(' ');
 		var spin = new SpinnerControl('format_spin', 'up3', 'dn3', {
 			data: formats,
 	 		afterUpdate: function() {
 				AreciboDecode.inputChanged();
 			}
 		});
 		
});