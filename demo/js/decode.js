//
// decode.js - Arecibo ASCII decoding module
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

		var encoded = $('#mystring').val();
		if (encoded === "") {
			$('#message_default').show();
			return;
		}

		$('#message_default').hide();

		// Remove all whitespace.
		// http://www.xploredotnet.com/2007/08/remove-white-space-in-string-using.html
		encoded = encoded.replace(/\s+/g,'');

		// convert input string to binary for processing
		var binary = undefined;
		var index = undefined;
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
					throw Error("Hex data may only contain 0-9 and A-F (or a-f)");
			}
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

		$('#binary_content').html(breakable);

		var decoded = AreciboAscii.decodeBinary(binary);
		
		$('#conversion_length').text('' + decoded.length);

		// To get carraige returns to show up we need to replace the
		// Line feeds with breaks.  Handling all the other weird things
		// like bells and tabs and such is left as an exercise for
		// the reader.  :-/
		$('#conversion_content').html(decoded.replace(/\n/g, '<br />'));
		$('#bitmaps_content').html(AreciboAscii.htmlForBitmaps(decoded));

		$('#message').show();
	};
	
	
	$('#mystring').focus();
 	$('#spec-name').text(AreciboAscii.name);
 	$('#spec-version').text(AreciboAscii.version);
 	$('#spec-date').text(AreciboAscii.date);

	// textarea may not be empty if page is reloaded...browser caches it
 	update();
 	
});