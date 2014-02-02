//
// encode.js - Arecibo ASCII encoding module
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


var AreciboEncode = {};

document.observe("dom:loaded", function() {
 	// put startup code that doesn't need window state here
	
	var lastInputChange = undefined; // msec since Jan 1, 1970
	var lastInput = undefined;
	var lastFormat = undefined;
	var inputProcessed = false;
	
	AreciboEncode.inputChanged = function() {
		if (($('mystring').value == lastInput) && ($('format_spin').value == lastFormat)) {
			return; // nothing changed, maybe they just moved the cursor?
		}
		
		lastInput = $('mystring').value;
		lastFormat = $('format_spin').value;
		inputProcessed = false;
		lastInputChange = (new Date()).getTime();
		window.setTimeout(AreciboEncode.update, 100);
		$('conversion').hide();
		$('bitmaps').hide();
		$('message_content').update('<center><img src="/media/demo/images/ajax-loader.gif" /></center>');
		$('message').show();
	};
	
	AreciboEncode.update = function() {
		if (inputProcessed) {
			return;
		}
		
		if ((new Date()).getTime() - lastInputChange < 500) {
			window.setTimeout(AreciboEncode.update, 100);
			return;
		} 
			
		var result = undefined;
		try {
			result = AreciboEncode.updateCore(lastInput, lastFormat);
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
	
	AreciboEncode.updateCore = function(str, format) {
		if (str === "") {
			// REVIEW: is there such a thing as an empty Arecibo Ascii String?
			// If there is no data in between the meter, the 5 leading and 7 trailing
			// meter will just look like 12 blocks.
			return {
				ok: false,
				type: "info",
				msg: '<p>While ASCII uses small arbitrary values (e.g. 65 for "A", 66 for "B"), ' +
				'USCII encodings use <i>much</i> larger values (e.g. 15621226033 for "A", 16400753439 for "B"). ' + 
				'These unusual numbers were chosen because they mathematically ' +
				'contain <i>bitmaps of the symbols they represent</i>!  Using a technique modeled ' +
				'after SETI\'s Arecibo Message, semiprimes are employed to suggest the ' +
				'two-dimensional decoding of these bit patterns.</p>' +
				'<br />' +
				'<p>USCII signals are able to carry meaning to a receiver independent of ' +
				'any table.  However, transmitters agree to use standard values.  This way they can ' +
				'also be used like conventional character codes&mdash;for instance, to pick which ' +
				'character to draw from a vector font!</p>' +
				'<br />' +		
				'<p><i>Type some text in the box above to try it out, or ' +
				'<a href="http://uscii.hostilefork.com/" target="_blank">learn more</a></i></p>' 
			};
		}
			
		var binary = AreciboAscii.encodeAsBinary(str);
		if (binary.length % 8 !== 0) {
			throw {
				ok: false,
				type: "error",
				msg: "Length " + binary.length + " not evenly divisible by 8 bits! " +
					"Should not happen with 40-bit elements..."
			};
		}

		var index = undefined;
		var converted = undefined;
		switch (format) {
			case "Hexadecimal":
				converted = "";
				for (index = 0; index < binary.length; index += 4) {
					var hexDigit = undefined;
					switch (binary.substr(index, 4)) {
						case "0000": hexDigit = '0'; break;
						case "0001": hexDigit = '1'; break;
						case "0010": hexDigit = '2'; break;
						case "0011": hexDigit = '3'; break;
						case "0100": hexDigit = '4'; break;
						case "0101": hexDigit = '5'; break;
						case "0110": hexDigit = '6'; break;
						case "0111": hexDigit = '7'; break;
						case "1000": hexDigit = '8'; break;
						case "1001": hexDigit = '9'; break;
						case "1010": hexDigit = 'A'; break;
						case "1011": hexDigit = 'B'; break;
						case "1100": hexDigit = 'C'; break;
						case "1101": hexDigit = 'D'; break;
						case "1110": hexDigit = 'E'; break;
						case "1111": hexDigit = 'F'; break;
						default:
							throw {
								ok: false,
								type: "error",
								msg: "Internal error &mdash; bad binary sequence, report to webmaster!"
							};
					}
					converted += hexDigit;
				}
				break;
				
			case "Binary":
				converted = binary;
				break;
				
			default:
				throw {
					ok: false,
					type: "error",
					msg: "unknown target numeric base"
				};
		}
		
		/* Firefox can't break lines without invisible unicode "break 
		   opportunities".  I once used character entity &#8203; to offer it
		   those opportunities every 5 characters.  On the downside of this,
		   it means that people copying the text to the clipboard will end
		   up getting the weird characters too.  For that reason, I decided
		   to break every 40 symbols with a newline instead. */
		var breakable = "";
		var breakSpacing =
			AreciboAscii.width * AreciboAscii.height + /* char size */
			AreciboAscii.width /* gap */;
		for (var index = 0; index < converted.length; index += breakSpacing) {
			// substr() method takes an index and a length
			breakable += converted.substr(index, breakSpacing);
			/* breakable += "&#8203;"; */ // nasty clipboard properties
			breakable += "<br />";
			
		}
		// substring() method takes two indices
		if (index < converted.length - 1) {
			breakable += converted.substring(index, converted.length - 1);
		}
		
		$('conversion_content').update('<tt>' + breakable + '</tt>');
		$('bitmaps_content').update(AreciboAscii.htmlForBitmaps(str));

		return {
			ok: true,
			type: "success",
			msg: 'USCII-5x7-ENGLISH-C0 data is ' + converted.length + ' ' + format + ' digits long'
		};
	};
	
	$('mystring').focus();
 	$('spec-name').update(AreciboAscii.name);
 	$('spec-version').update(AreciboAscii.version);
 	$('spec-date').update(AreciboAscii.date);

	// textarea may not be empty if page is reloaded...browser caches it
 	AreciboEncode.inputChanged();
 	
 	var formats = 'Binary Hexadecimal'.split(' ');
 		var spin = new SpinnerControl('format_spin', 'up3', 'dn3', {
 			data: formats,
 	 		afterUpdate: function() {
 				AreciboEncode.inputChanged();
 			}
 		});
});