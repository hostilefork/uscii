//
// encode.js - Arecibo ASCII encoding module
// Copyright (C) 2009-2014 HostileFork.com
//
// MIT license:
//	 http://www.opensource.org/licenses/mit-license.php
//
// For more information, see http://uscii.hostilefork.com
//

$(function() {
 	// put startup code that doesn't need window state here
	
	var lastInputChange = undefined; // msec since Jan 1, 1970
	var inputProcessed = false;
	var lastInput = "";
	
	// http://stackoverflow.com/a/14148825/211160
	// (We don't care about cursor position)
	$("#mystring").bind("input propertychange paste cut", function() {
		if ($('#mystring').val() == lastInput) {
			return;
		}
		lastInput = $('#mystring').val();

		inputProcessed = false;
		lastInputChange = (new Date()).getTime();
		setTimeout(update, 100);
		$('#loader_container').show();
		$('#message_container').hide();
	});
	
	var update = function() {
		if (inputProcessed) {
			return;
		}
		
		if ((new Date()).getTime() - lastInputChange < 500) {
			setTimeout(update, 100);
			return;
		} 

		$('#message_error').hide();
		try {
			updateCore();
		} catch (err) {
			$('#message_error').text(err.toString());
			$('#message_error').show();
		}

		inputProcessed = true;
		$('#loader_container').hide();
		$('#message_container').show();
	};
	
	var updateCore = function() {
		$('#message').hide();

		var str = $('#mystring').val();
		if (str === "") {
			// REVIEW: is there such a thing as an empty Arecibo Ascii String?
			// If there is no data in between the meter, the 5 leading and 7 trailing
			// meter will just look like 12 blocks.
			$('#message_default').show();
			return;
		}
		
		$('#message_default').hide();

		var binary = AreciboAscii.encodeAsBinary(str);
		if (binary.length % 8 !== 0) {
			throw Error(
				"Length " + binary.length + " not evenly divisible by 8 bits! " +
					"Should not happen with 40-bit elements..."
			);
		}

		var index = undefined;
		var converted = "";
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
					throw Error("Internal USCII error: bad binary sequence");
			}
			converted += hexDigit;
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
		for (var index = 0; index < binary.length; index += breakSpacing) {
			// substr() method takes an index and a length
			breakable += binary.substr(index, breakSpacing);
			breakable += "<br>";
		}

		// substring() method takes two indices
		if (index < converted.length - 1) {
			breakable += converted.substring(index, converted.length - 1);
		}
		
		$('#binary_content').html(breakable);
		$('#conversion_length').text('' + converted.length / 2);
		$('#conversion_content').html(converted);
		$('#bitmaps_content').html(AreciboAscii.htmlForBitmaps(str));

		$('#message').show();
	};
	
	$('#mystring').focus();
 	$('#spec-name').text(AreciboAscii.name);
 	$('#spec-version').text(AreciboAscii.version);
 	$('#spec-date').text(AreciboAscii.date);

	// textarea may not be empty if page is reloaded...browser caches it
 	update(); 	
});