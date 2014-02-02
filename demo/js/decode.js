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
	
	AreciboDecode.updateCore = function(encoded, format) {
		if (encoded === "") {
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
		encoded = encoded.replace(/\s+/g,'');

		// convert input string to binary for processing
		var binary = undefined;
		var index = undefined;
		switch (format) {
			case "Hexadecimal":
				binary = "";
				for (index = 0; index < encoded.length; index++) {
					switch (encoded[index]) {
						case '0': binary += "0000"; break;
						case '1': binary += "0001"; break;
						case '2': binary += "0010"; break;
						case '3': binary += "0011"; break;
						case '4': binary += "0100"; break;
						case '5': binary += "0101"; break;
						case '6': binary += "0110"; break;
						case '7': binary += "0111"; break;
						case '8': binary += "1000"; break;
						case '9': binary += "1001"; break;
						case 'A': case 'a': binary += "1010"; break;
						case 'B': case 'b': binary += "1011"; break;
						case 'C': case 'c': binary += "1100"; break;
						case 'D': case 'd': binary += "1101"; break;
						case 'E': case 'e': binary += "1110"; break;
						case 'F': case 'f': binary += "1111"; break;
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
				for (index = 0; index < encoded.length; index++) {
					switch (encoded[index]) {
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
				binary = encoded;
				break;
				
			default:
				throw {
					ok: false,
					type: "error",
					msg: 'Unknown source numeric base: "' + format + '"'
				};
		}
	
		var decoded = AreciboAscii.decodeBinary(binary);

		if (0) {		
			/* Firefox can't break lines without invisible unicode "break 
			   opportunities".  I once used character entity &#8203; to offer it
			   those opportunities every 5 characters.  On the downside of this,
			   it means that people copying the text to the clipboard will end
			   up getting the weird characters too.  For that reason, I decided
			   to break every 36 symbols with a newline instead. */
			var breakableString = "";
			var breakSpacing = 36;
			for (var breakableIndex = 0; breakableIndex < decoded.length; breakableIndex += breakSpacing) {
				// substr() method takes an index and a length
				breakableString += decoded.substr(breakableIndex, breakSpacing);
				/* breakableString += "&#8203;"; */ // nasty clipboard properties
				breakableString += "<br />";
				
			}
			// substring() method takes two indices
			if (breakableIndex < decoded.length - 1) {
				breakableString += decoded.substring(breakableIndex, decoded.length - 1);
			}
		}
		
		$('conversion_content').update(decoded);
		$('bitmaps_content').update(AreciboAscii.htmlForBitmaps(decoded));

		return {
			ok: true,
			type: "success",
			msg: 'ASCII is ' + decoded.length + ' characters long'
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