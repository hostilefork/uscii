REBOL [
	Title: {"Arecibo Ascii Generator"}
	Purpose: "Generates Character Set USCII-5x7-ENGLISH-C0"
	Description: { A USCII system ("Universal Semiotic Coding for
		Information Interchange"--pronounced "you-ski") is a method of
		embedding 2-D visual representations of letters, numbers, and
		control signals into the coded numbers agreed upon to represent them.

		For instance, instead of using 65 for A and 66 for B as ASCII does...
		we might consider using 15621226033 for A and 16400753439 for B.  The
		reason this could be interesting is that when converted into binary,
		these are:

		15621226033 (base 10) = 01110100011000110001111111000110001 (base 2)
		16400753439 (base 10) = 11110100011000111110100011000111110 (base 2)

		When transmitted in a medium which hints at the significance of a
		35-bit pattern, the semiprime nature of that number hints at factoring
		it into 5 and 7 to make a rectangle of those dimensions.  If we do,
		then it will reveal the letters they represent as a picture:

		01110100011000110001111111000110001:

			0 1 1 1 0
			1 0 0 0 1
			1 0 0 0 1
			1 0 0 0 1 => "A"
			1 1 1 1 1
			1 0 0 0 1
			1 0 0 0 1

		11110100011000111110100011000111110:

			1 1 1 1 0
			1 0 0 0 1
			1 0 0 0 1
			1 1 1 1 0 => "B"
			1 0 0 0 1
			1 0 0 0 1
			1 1 1 1 0

	This script generates a *draft* of the USCII variation "5x7-ENGLISH-C0".
	I've informally labeled this standard "Arecibo Ascii" as an homage to SETI's
	Arecibo Message, which employed a similar strategy:

		http://en.wikipedia.org/wiki/Arecibo_message

	5x7-ENGLISH-C0 has pictoral representations of *all* ASCII characters--
	which include the uppercase and lowercase English alphabet, numbers, and
	some symbols...as well as the "C0 control codes":

		http://en.wikipedia.org/wiki/C0_and_C1_control_codes

	It is therefore possible to losslessly convert a stream of ASCII characters
	into USCII-5x7-ENGLISH-C0 and back.
	}

	Author: "Hostile Fork"
	Home: http://hostilefork.com/uscii/
	License: gpl ; GPL Version 3

	File: %uscii-5x7-english-c0.r
	Date: 24-Jun-2009
	Version: 0.1.1

	; Header conventions: http://www.rebol.org/one-click-submission-help.r
	Type: fun
	Level: intermediate

	Usage: { Just run the script using a REBOL/View version 2 interpreter.
		Get one here:

		http://rebol.com/download.html

		The script will print versions of the Arecibo Ascii table in a format
		for the web (HTML table) as well as a version to use in Javascript 
		code.  With just a little bit of REBOL know-how, you can make other
		outputs as well...
	}

	History: [
		0.1.0 [20-Oct-2008 {Initial version created to decode PIC CPU font
		and make table for HostileFork.com blog.  Not released to general
		public.} "Fork"]

		0.1.1 [24-Jun-2009 {Reorganized to support the easy addition and
		tweaking of characters for the C0 control codes.  Modified for 
		REBOL.org header conventions, but working draft placed on GitHub.}
		"Fork"]
	
		0.2.0 [20-Dec-2010 {Moved from using bytes for PIC font to actually
		representing character images so they could be customized.} "Fork"]
	]
]

allSymbolData: [
	; Characters in Arecibo ASCII-35 standard
	; Names from http://en.wikipedia.org/wiki/ASCII#ASCII_control_characters
	; Labels from http://en.wikipedia.org/wiki/C0_and_C1_control_codes
	
	; The 5x7 printable characters were originally from the Font Code for 
	; PIC CPU Assemblers:
	;     http://www.noritake-itron.com/Softview/fontspic.htm
	; Character modifications are noted in the comments.
	
	; Though some of these are going to look pretty bad, my attempt is to
	; derive the graphics from symbols that could also be used in higher 
	; resolutions.  So imagine these as being scaled down versions of those
	; same graphics.
	
	; Many of these choices are questionable and should be revisited, but I
	; had to start somewhere to get it out for review.  They are currently
	; rated as "good", "fair", and "poor"
	[
		code: 0
		name: "Null character"
		abbr: "NUL"
		description: {
			Originally used to allow gaps to be left on paper tape for edits.
			Later used for padding after a code that might take a terminal some 
			time to process (e.g. a carriage return or line feed on a printing
			terminal). Now often used as a string terminator, especially in the
			C programming language.
		}
		image: [
			"X X X"
			" X X "
			"X X X"
			" X X "
			"X X X"
			" X X "
			"X X X"
		]
		notes: {
			Using a dither pattern, to avoid confusion with all empty 
			(space) and all full (transmission end/boundary)
		}
		rating: 'good
	] [
		code: 1
		name: "Start of Header"
		abbr: "SOH"
		description: {
			From: http://www.lammertbies.nl/comm/info/ascii-characters.html
			Nowadays we often see the SOH used in serial RS232 communications 
			where there is a master-slave configuration. Each command from the 
			master starts with the SOH. This makes it possible for the slave or 
			slaves to resynchronize on the next command when data errors 
			occured.  Without a clear marking of the start of each command a
			resync might be problematic to implement.
		}
		image: [
			"X X X"
			"X XXX"
			"X X X"
			"X XXX"
			"X X X"
			"X XXX"
			"X X X"
		]
		notes: {
			vertical line next to dotted vertical line in reverse video
		}
		rating: 'poor
	] [		
		code: 2
		name: "Start of Text"
		abbr: "STX"
		description: {
			First character of message text, and may be used to terminate the 
			message heading.
		}
		image: [
			"XX XX"
			"XXXXX"
			"XX XX"
			"XXXXX"
			"XX XX"
			"XXXXX"
			"XX XX"
		]
		notes: {
			dotted vertical line in reverse video
		}
		rating: 'poor
	] [		
		code: 3
		name: "End of Text"
		abbr: "ETX"
		description: {
			Often used as a "break" character (Ctrl-C) to interrupt or terminate
			a program or process.
		}
		image: [
			"XX XX"
			"XX XX"
			"XX XX"
			"XX XX"
			"XX XX"
			"XXXXX"
			"XX XX"
		]
		notes: {
			an exclamation point in reverse video
		}
		rating: 'fair
	] [		
		code: 4
		name: "End of Transmission"
		abbr: "EOT"
		description: {
			Used on Unix to signal end-of-file condition on, or to logout from,
			a terminal.
		}
		image: [
			"XXXXX"
			"XXXXX"
			"XXXXX"
			"XXXXX"
			"XXXXX"
			"X  XX"
			"X  XX"
		]
		notes: {
			A period in reverse video
		}
		rating: 'fair
	] [		
		code: 5
		name: "Enquiry"
		abbr: "ENQ"
		description: {
			Signal intended to trigger a response at the receiving end, to see 
			if it is still present.
		}
		image: [
			"XXXXX"
			"XXX X"
			"     "
			"XXX X"
			"X XXX"
			"     "
			"X XXX"
		]
		notes: {
			Two opposing arrows in reverse video...a good network connectivity
			notion, but guess the question is implicit
		}
		rating: 'poor
	] [		
		code: 6
		name: "Acknowledgment"
		abbr: "ACK"
		description: {
			Response to an ENQ, or an indication of successful receipt of a
			message.
		}
		image: [
			"XXXXX"
			"X X X"
			"XXXXX"
			"XXXXX"
			" XXX "
			"X   X"
			"XXXXX"
		]
		notes: {
			A happy face :) in reverse video
		}
		rating: 'good
	] [		
		code: 7
		name: "Bell"
		abbr: "BEL"
		description: {
			Originally used to sound a bell on the terminal. Later used for a 
			beep on systems that didn't have a physical bell. May also quickly 
			turn on and off inverse video (a visual bell).
		}
		image: [
			"XX XX"
			"X   X"
			"X   X"
			"X   X"
			"     "
			"XXXXX"
			"XX XX"
		]
		notes: {
			An icon of a bell in reverse video
		}
		rating: 'good
	] [		
		code: 8
		name: "Backspace"
		abbr: "BS"
		description: {
			Move the cursor one position leftwards. On input, this may delete
			the character to the left of the cursor. On output, where in early 
			computer technology a character once printed could not be erased,
			the backspace was sometimes used to generate accented characters in
			ASCII.  For example, a with a reverse accent could be produced 
			using the three character sequence a BS ` (0x61 0x08 0x60). This
			usage is now deprecated and generally not supported. To provide
			disambiguation between the two potential uses of backspace, the
			cancel character control code was made part of the standard C1
			control set.
		}
		image: [
			"XXXXX"
			"XX XX"
			"X XXX"
			"     "
			"X XXX"
			"XX XX"
			"XXXXX"
		]
		notes: {
			arrow pointing back in reverse video
		}
		rating: 'fair
	] [		
		code: 9
		name: "Horizontal Tab"
		abbr: "HT"
		description: {
			Position to the next character tab stop.
		}
		image: [
			"     "
			"     "
			"    X"
			"XXX X"
			"    X"
			"     "
			"     "
		]
		notes: {
			sort of a horizontal "T" shape that has a vertical line like a
			tab stop in MS word
		}
		rating: 'fair
	] [
		code: 10
		name: "Line Feed"
		abbr: "LF"
		description: {
			On typewriters, printers, and some terminal emulators, moves the
			cursor down one row without affecting its column position. On Unix, 
			used to mark end-of-line. In MS-DOS, Windows, and various network 
			standards, used following CR as part of the end-of-line mark.
		}
		image: [
			"XXX  "
			"  X  "
			"  X  "
			"  X  "
			"XXXXX"
			" XXX "
			"  X  "
		]
		notes: {
			A spin on the carraige return which emphasizes the "downness" of 
			a feed, but also with a horizontal suggestion of the current line
		}
		rating: 'good
	] [
		code: 11
		name: "Vertical Tab"
		abbr: "VT"
		description: {
			Position the form at the next line tab stop.
			The vertical tab is not allowed in SGML, including HTML and XML 1.0.
		}
		image: [
			"  X  "
			"  X  "
			"  X  "
			"  X  "
			"  X  "
			"     "
			" XXX "
		]
		notes: {
			vertical analogue of the choice for horizontal tab
		}
		rating: 'good
	] [		
		code: 12
		name: "Form feed"
		abbr: "FF"
		description: {
			On printers, load the next page. Treated as whitespace in many 
			programming languages, and may be used to separate logical divisions
			in code. In some terminal emulators, it clears the screen.
		}
		image: [
			"XXXXX"
			" XXX "
			"  X  "
			"     "
			"XXXXX"
			" XXX "
			"  X  "
		]
		notes: {
			Two "arrows" pointing downward to suggest "go far down", but should
			it be in reverse video?
		}
		rating: 'fair
	] [		
		code: 13
		name: "Carriage return"
		abbr: "CR"
		description: {
			Originally used to move the cursor to column zero while staying on 
			the same line. On Mac OS (pre-Mac OS X), as well as in earlier 
			systems such as the Apple II and Commodore 64, used to mark 
			end-of-line. In MS-DOS, Windows, and various network standards, it 
			is used preceding LF as part of the end-of-line mark. The Enter or
			Return key on a keyboard will send this character, but it may be 
			converted to a different end-of-line sequence by a terminal program.
		}
		image: [
			"    X"
			"    X"
			"  X X"
			" XX X"
			"XXXXX"
			" XX  "
			"  X  "
		]
		notes: {
			This symbol has been established as meaning "carriage return"...
			which does not always feed to the next line
		}
		rating: 'good
	] [		
		code: 14
		name: "Shift Out"
		abbr: "SO"
		description: {
			From http://en.wikipedia.org/wiki/Shift_Out_and_Shift_In_characters	
			Shifting characters were used, for instance, in the Russian 
			character set known as KOI7, where "Shift Out" starts printing 
			Russian letters, and "Shift In" starts printing Latin letters again.
			Some older printers used these characters to control special
			features, such as changing the font or ink color. On the Model 38
			Teletype, SO switched to red printing while SI switched back to
			black printing.
		}
		image: [
			"  X  "
			"X XXX"
			"XX XX"
			"XX XX"
			"XX XX"
			"XXX X"
			"XXX  "
		]
		notes: {
			Apple's option icon (a switch) in reverse video
		}
		rating: 'poor
	] [		
		code: 15
		name: "Shift In"
		abbr: "SI"
		description: {
			Return to regular character set after Shift Out.
		}
		image: [
			"XXX  "
			"XXX X"
			"XX XX"
			"XX XX"			
			"XX XX"
			"X XXX"
			"  X  "
		]
		notes: {
			Apple's option icon (a switch) in reverse video, upside down
		}
		rating: 'poor
	] [		
		code: 16
		name: "Data Link Escape"
		abbr: "DLE"
		description: {
			Cause the following octets to be interpreted as raw data, not as
			control codes or graphic characters. Returning to normal usage would
			be implementation dependent.
		}
		image: [
			"XXXXX"
			"XXXXX"
			"  X  "
			" X X "
			"  X  "
			"XXXXX"
			"XXXXX"
		]
		notes: {
			A "chain" or link?  Infinity symbol, maybe, to suggest opening
			the door to a new data world?  Both would apply.  reverse video
		}
		rating: 'fair
	] [		
		code: 17
		name: "Device Control 1"
		abbr: ["DC1" "XON"]
		description: {
			These four control codes are reserved for device control, with the 
			interpretation dependent upon the device they were connected. DC1
			and DC2 were intended primarily to indicate activating a device 
			while DC3 and DC4 were intended primarily to indicate pausing or
			turning off a device.  In actual practice DC1 and DC3 (known also as
			XON and XOFF respectively in this usage) quickly became the de facto
			standard for software flow control.
		}
		image: [
			"XXXXX"
			"X XXX"
			"X  XX"
			"X   X"
			"X  XX"
			"X XXX"
			"XXXXX"
		]
		notes: {
			VCR Play Symbol in reverse video
		}
		rating: 'good
	] [		
		code: 18
		name: "Device Control 2"
		abbr: "DC2"
		description: {
			From: http://www.cs.tut.fi/~jkorpela/chars/c0.html
			A device control character which is primarily intended for turning
			on or starting an ancillary device. If it is not required for this
			purpose, it may be used to set a device to a special mode of 
			operation (in which case DC1 is used to restore normal operation),
			or for any other device control function not provided by other DCs.
		}
		image: [
			"XX XX"
			"XX XX"
			" X X "
			" X X "
			" XXX "
			" XXX "
			"X   X"
		] 
		notes: {
			power on symbol in reverse video
		}
		rating: 'fair
	] [		
		code: 19
		name: "Device Control 3"
		abbr: ["DC3" "XOFF"]
		image: [
			"XXXXX"
			"X X X"
			"X X X"
			"X X X"
			"X X X"
			"X X X"
			"XXXXX"
		]
		notes: {
			Pause symbol in reverse video
		}
		rating: 'good
	] [		
		code: 20
		name: "Device Control 4"
		abbr: "DC4"
		description: {
			From: http://www.cs.tut.fi/~jkorpela/chars/c0.html
			A device control character which is primarily intended for turning 
			off, stopping or interrupting an ancillary device. If it is not 
			required for this purpose, it may be used for any other device 
			control function not provided by other DCs. 
		}
		image: [
			"XXXXX"
			"X   X"
			"X   X"
			"X   X"
			"X   X"
			"X   X"
			"XXXXX"
		]
		notes: {
			Stop symbol in reverse video
		}
		rating: 'good
	] [		
		code: 21
		name: "Negative Acknowledgement"
		abbr: "NAK"
		description: {
			Sent by a station as a negative response to the station with which the
			connection has been set up. In binary synchronous communication 
			protocol, the NAK is used to indicate that an error was detected in
			the previously received block and that the receiver is ready to accept
			retransmission of that block. In multipoint systems, the NAK is used
			as the not-ready reply to a poll.
		}
		image: [
			"XXXXX"
			"X X X"
			"XXXXX"
			"XXXXX"
			"X   X"
			" XXX "
			"XXXXX"
		]
		notes: {
			A frowny face :( in reverse video
		}
		rating: 'good
	] [		
		code: 22
		name: "Synchronous Idle"
		abbr: "SYN"
		description: {
			Used in synchronous transmission systems to provide a signal from
			which synchronous correction may be achieved between data terminal
			equipment, particularly when no other character is being transmitted.
		}
		image: [
			"XXXXX"
			"XXXXX"
			"XXXXX"
			"XXXXX"
			"XXXXX"
			" X X "
			"XXXXX"	
		]
		notes: {
			an ellipsis in reverse video
		}
		rating: 'good
	] [		
		code: 23
		name: "End of Trans. Block"
		abbr: "ETB"
		description: {
			Indicates the end of a transmission block of data when data are
			divided into such blocks for transmission purposes.
		}
		image: [
			"XXXXX"
			"     "
			" XXX "
			" X X "
			" XXX "
			"     "
			"XXXXX"	
		]
		notes: {
			Grasping at straws with this.  Funny hollow "block" in reverse
			video?  Also considered three vertical pipes in reverse video, to
			go to a deeper level than file separator, but it looks too much
			like two vertical pipes in non-reverse video
		}
		rating: 'poor
	] [		
		code: 24
		name: "Cancel"
		abbr: "CAN"
		description: {
			Indicates that the data preceding it are in error or are to be
			disregarded.
		}
		image: [
			"X   X"
			"     "
			" X X "
			"  X  "
			" X X "
			"     "
			"X   X"
		]
		notes: {
			Inspired by use of a circle with a cross through it, usually
			red circle with white X.  In reverse video
		}
		rating: 'fair
	] [		
		code: 25
		name: "End of Medium"
		abbr: "EM"
		description: {
			Intended as means of indicating on paper or magnetic tapes that the
			end of the usable portion of the tape had been reached.
		}
		image: [
			"XXXXX"
			"X   X"
			" XX  "
			" X X "
			"  XX "
			"X   X"
			"XXXXX"
		]
		notes: {
			Would *like* to approximate a hand holding up it's palm, like
			whoa, "stop!".  But trying the circle with a slash through it
			as a "no" icon
		}
		rating: 'fair
	] [		
		code: 26
		name: "Substitute"
		abbr: "SUB"
		description: {
			Originally intended for use as a transmission control character to
			indicate that garbled or invalid character had been received. It has
			often been put to use for other purposes when the in-band signaling
			of errors it provides is unneeded, especially where robust methods
			of error detection and correction are used, or where errors are
			expected to be rare enough to make using the character for other
			purposes advisable.
		}
		image: [
			"X   X"
			" XXX "
			"XXXX "
			"XXX X"
			"XX XX"
			"XXXXX"
			"XX XX"
		]
		notes: {
			A question mark in reverse video
		}
		rating: 'good
	] [		
		code: 27
		name: "Escape"
		abbr: "ESC"
		description: {
			The ESC key on the keyboard will cause this character to be sent on
			most systems. It can be used in software user interfaces to exit
			from a screen, menu, or mode, or in device-control protocols (e.g.,
			printers and terminals) to signal that what follows is a special
			command sequence rather than normal text. In systems based on 
			ISO/IEC 2022, even if another set of C0 control codes are used, this
			octet is required to always represent the escape character.
		}
		image: [
			"   XX"
			"  XX "
			" X X "
			"XXXX "
			" XXX "
			" XXX "
			"X   X"
		]
		notes: {
			Inspired by Apple's choice of a circle with an arrow pointing out
			of its upper left corner (hard to do in 5x7), in reverse video
		}
		rating: 'poor
	] [		
		code: 28
		name: "File Separator"
		abbr: "FS"
		description: {
			Can be used as delimiters to mark fields of data structures. If used
			for hierarchical levels, Unit Separator is the lowest level
			(dividing plain-text data items), while Record Separator, Group
			Separator, and File Separator are of increasing level to divide
			groups made up of items of the level beneath it.
		}
		image: [
			"X X X"
			"X X X"
			"X X X"
			"X X X"
			"X X X"
			"X X X"
			"X X X"
		]
		notes: {
			double pipe--two vertical lines in reverse video
		}
		rating: 'fair
	] [		
		code: 29
		name: "Group Separator"
		abbr: "GS"
		image: [
			"XX XX"
			"XX XX"
			"XX XX"
			"XX XX"
			"XX XX"
			"XX XX"
			"XX XX"
		]
		notes: {
			pipe symbol in reverse video
		}
		rating: 'fair
	] [		
		code: 30
		name: "Record Separator"
		abbr: "RS"
		image: [
			"XXXX "
			"XXXX "
			"XX X "
			"X  X "
			"     "
			"X  XX"
			"XX XX"
		]
		notes: {
			carraige return in reverse video, trying to be like how
			comma delimited files use carraige returns to separate records
			could be confusing, and I'm wondering if carriage returns should
			be in reverse video in the first place...right now I want to 
			treat them as "normal" characters instead of control codes
		}
		rating: 'fair
	] [		
		code: 31
		name: "Unit Separator"
		abbr: "US"
		image: [
			"XXXXX"
			"XXXXX"
			"XXXXX"
			"XXXXX"
			"X  XX"
			"XX XX"
			"X XXX"
		]
		notes: {
			a comma in reverse video, to suggest a comma delimited file
		}
		rating: 'fair
	] [
		code: 32
		name: "Space"
		abbr: "SP"
		description: {
			Space is a graphic character. It has a visual representation
			consisting of the absence of a graphic symbol. It causes the active
			position to be advanced by one character position. In some
			applications, Space can be considered a lowest-level "word 
			separator" to be used with the adjacent separator characters.
		}
		image: [
			"     "
			"     "
			"     "
			"     "
			"     "
			"     "
			"     "
		]
		rating: 'good
	] [
		code: 33
		image: [
			"  X  "
			"  X  "
			"  X  "
			"  X  "
			"     "
			"     "
			"  X  "
		]
	] [
		code: 34
		image: [
			" X X "
			" X X "
			" X X "
			"     "
			"     "
			"     "
			"     "
		]
	] [
		code: 35
		image: [
			" X X "
			" X X "
			"XXXXX"
			" X X "
			"XXXXX"
			" X X "
			" X X "
		]
	] [
		code: 36
		image: [
			"  X  "
			" XXXX"
			"X X  "
			" XXX "
			"  X X"
			"XXXX "
			"  X  "
		]
	] [
		code: 37
		image: [
			"XX   "
			"XX  X"
			"   X "
			"  X  "
			" X   "
			"X  XX"
			"   XX"
		]
	] [
		code: 38
		image: [
			" XX  "
			"X  X "
			"X X  "
			" X   "
			"X X X"
			"X  X "
			" XX X"
		]
	] [
		code: 39
		image: [
			" XX  "
			"  X  "
			" X   "
			"     "
			"     "
			"     "
			"     "
		]
	] [
		code: 40
		image: [
			"   X "
			"  X  "
			" X   "
			" X   "
			" X   "
			"  X  "
			"   X "
		]
	] [
		code: 41
		image: [
			" X   "
			"  X  "
			"   X "
			"   X "
			"   X "
			"  X  "
			" X   "
		]
	] [
		code: 42
		image: [
			"     "
			"  X  "
			"X X X"
			" XXX "
			"X X X"
			"  X  "
			"     "
		]
	] [
		code: 43
		image: [
			"     "
			"  X  "
			"  X  "
			"XXXXX"
			"  X  "
			"  X  "
			"     "
		]
	] [
		code: 44
		image: [
			"     "
			"     "
			"     "
			"     "
			" XX  "
			"  X  "
			" X   "
		]
	] [
		code: 45
		image: [
			"     "
			"     "
			"     "
			"XXXXX"
			"     "
			"     "
			"     "
		]
	] [
		code: 46
		image: [
			"     "
			"     "
			"     "
			"     "
			"     "
			" XX  "
			" XX  "
		]
	] [
		code: 47
		image: [
			"     "
			"    X"
			"   X "
			"  X  "
			" X   "
			"X    "
			"     "
		]
	] [
		code: 48
		image: [
			" XXX "
			"X   X"
			"X  XX"
			"X X X"
			"XX  X"
			"X   X"
			" XXX "
		]
	] [
		code: 49
		image: [
			"  X  "
			" XX  "
			"  X  "
			"  X  "
			"  X  "
			"  X  "
			" XXX "
		]
	] [
		code: 50
		image: [
			" XXX "
			"X   X"
			"    X"
			"   X "
			"  X  "
			" X   "
			"XXXXX"
		]
	] [
		code: 51
		image: [
			"XXXXX"
			"   X "
			"  X  "
			"   X "
			"    X"
			"X   X"
			" XXX "
		]
	] [
		code: 52
		image: [
			"   X "
			"  XX "
			" X X "
			"X  X "
			"XXXXX"
			"   X "
			"   X "
		]
	] [
		code: 53
		image: [
			"XXXXX"
			"X    "
			"XXXX "
			"    X"
			"    X"
			"X   X"
			" XXX "
		]
	] [
		code: 54
		image: [
			"  XX "
			" X   "
			"X    "
			"XXXX "
			"X   X"
			"X   X"
			" XXX "
		]
	] [
		code: 55
		image: [
			"XXXXX"
			"    X"
			"   X "
			"  X  "
			" X   "
			" X   "
			" X   "
		]
	] [
		code: 56
		image: [
			" XXX "
			"X   X"
			"X   X"
			" XXX "
			"X   X"
			"X   X"
			" XXX "
		]
	] [
		code: 57
		image: [
			" XXX "
			"X   X"
			"X   X"
			" XXXX"
			"    X"
			"   X "
			" XX  "
		]
	] [
		code: 58
		image: [
			"     "
			" XX  "
			" XX  "
			"     "
			" XX  "
			" XX  "
			"     "
		]
	] [
		code: 59
		image: [
			"     "
			" XX  "
			" XX  "
			"     "
			" XX  "
			"  X  "
			" X   "
		]
	] [
		code: 60
		image: [
			"   X "
			"  X  "
			" X   "
			"X    "
			" X   "
			"  X  "
			"   X "
		]
	] [
		code: 61
		image: [
			"     "
			"     "
			"XXXXX"
			"     "
			"XXXXX"
			"     "
			"     "
		]
	] [
		code: 62
		image: [
			" X   "
			"  X  "
			"   X "
			"    X"
			"   X "
			"  X  "
			" X   "
		]
	] [
		code: 63
		image: [
			" XXX "
			"X   X"
			"    X"
			"   X "
			"  X  "
			"     "
			"  X  "
		]
	] [
		code: 64
		image: [
			" XXX "
			"X   X"
			"    X"
			" XX X"
			"X X X"
			"X X X"
			" XXX "
		]
	] [
		code: 65
		image: [
			" XXX "
			"X   X"
			"X   X"
			"X   X"
			"XXXXX"
			"X   X"
			"X   X"
		]
	] [
		code: 66
		image: [
			"XXXX "
			"X   X"
			"X   X"
			"XXXX "
			"X   X"
			"X   X"
			"XXXX "
		]
	] [
		code: 67
		image: [
			" XXX "
			"X   X"
			"X    "
			"X    "
			"X    "
			"X   X"
			" XXX "
		]
	] [
		code: 68
		image: [
			"XXX  "
			"X  X "
			"X   X"
			"X   X"
			"X   X"
			"X  X "
			"XXX  "
		]
	] [
		code: 69
		image: [
			"XXXXX"
			"X    "
			"X    "
			"XXXX "
			"X    "
			"X    "
			"XXXXX"
		]
	] [
		code: 70
		image: [
			"XXXXX"
			"X    "
			"X    "
			"XXXX "
			"X    "
			"X    "
			"X    "
		]
	] [
		code: 71
		image: [
			" XXX "
			"X   X"
			"X    "
			"X XXX"
			"X   X"
			"X   X"
			" XXXX"
		]
	] [
		code: 72
		image: [
			"X   X"
			"X   X"
			"X   X"
			"XXXXX"
			"X   X"
			"X   X"
			"X   X"
		]
	] [
		code: 73
		image: [
			" XXX "
			"  X  "
			"  X  "
			"  X  "
			"  X  "
			"  X  "
			" XXX "
		]
	] [
		code: 74
		image: [
			"  XXX"
			"   X "
			"   X "
			"   X "
			"   X "
			"X  X "
			" XX  "
		]
	] [
		code: 75
		image: [
			"X   X"
			"X  X "
			"X X  "
			"XX   "
			"X X  "
			"X  X "
			"X   X"
		]
	] [
		code: 76
		image: [
			"X    "
			"X    "
			"X    "
			"X    "
			"X    "
			"X    "
			"XXXXX"
		]
	] [
		code: 77
		image: [
			"X   X"
			"XX XX"
			"X X X"
			"X X X"
			"X   X"
			"X   X"
			"X   X"
		]
	] [
		code: 78
		image: [
			"X   X"
			"X   X"
			"XX  X"
			"X X X"
			"X  XX"
			"X   X"
			"X   X"
		]
	] [
		code: 79
		image: [
			" XXX "
			"X   X"
			"X   X"
			"X   X"
			"X   X"
			"X   X"
			" XXX "
		]
	] [
		code: 80
		image: [
			"XXXX "
			"X   X"
			"X   X"
			"XXXX "
			"X    "
			"X    "
			"X    "
		]
	] [
		code: 81
		image: [
			" XXX "
			"X   X"
			"X   X"
			"X   X"
			"X X X"
			"X  X "
			" XX X"
		]
	] [
		code: 82
		image: [
			"XXXX "
			"X   X"
			"X   X"
			"XXXX "
			"X X  "
			"X  X "
			"X   X"
		]
	] [
		code: 83
		image: [
			" XXXX"
			"X    "
			"X    "
			" XXX "
			"    X"
			"    X"
			"XXXX "
		]
	] [
		code: 84
		image: [
			"XXXXX"
			"  X  "
			"  X  "
			"  X  "
			"  X  "
			"  X  "
			"  X  "
		]
	] [
		code: 85
		image: [
			"X   X"
			"X   X"
			"X   X"
			"X   X"
			"X   X"
			"X   X"
			" XXX "
		]
	] [
		code: 86
		image: [
			"X   X"
			"X   X"
			"X   X"
			"X   X"
			"X   X"
			" X X "
			"  X  "
		]
	] [
		code: 87
		image: [
			"X   X"
			"X   X"
			"X   X"
			"X   X"
			"X X X"
			"X X X"
			" X X "
		]
	] [
		code: 88
		image: [
			"X   X"
			"X   X"
			" X X "
			"  X  "
			" X X "
			"X   X"
			"X   X"
		]
	] [
		code: 89
		image: [
			"X   X"
			"X   X"
			"X   X"
			" X X "
			"  X  "
			"  X  "
			"  X  "
		]
	] [
		code: 90
		image: [
			"XXXXX"
			"    X"
			"   X "
			"  X  "
			" X   "
			"X    "
			"XXXXX"
		]
	] [
		code: 91
		image: [
			" XXX "
			" X   "
			" X   "
			" X   "
			" X   "
			" X   "
			" XXX "
		]
	] [
		code: 92
		image: [
			"     "
			"X    "
			" X   "
			"  X  "
			"   X "
			"    X"
			"     "
		]
	] [
		code: 93
		image: [
			" XXX "
			"   X "
			"   X "
			"   X "
			"   X "
			"   X "
			" XXX "
		]
	] [
		code: 94
		image: [
			"  X  "
			" X X "
			"X   X"
			"     "
			"     "
			"     "
			"     "
		]
	] [
		code: 95
		image: [
			"     "
			"     "
			"     "
			"     "
			"     "
			"     "
			"XXXXX"
		]
	] [
		code: 96
		image: [
			" X   "
			"  X  "
			"   X "
			"     "
			"     "
			"     "
			"     "
		]
	] [
		code: 97
		image: [
			"     "
			"     "
			" XXX "
			"    X"
			" XXXX"
			"X   X"
			" XXXX"
		]
	] [
		code: 98
		image: [
			"X    "
			"X    "
			"X    "
			"XXXX "
			"X   X"
			"X   X"
			"XXXX "
		]
	] [
		code: 99
		image: [
			"     "
			"     "
			" XXXX"
			"X    "
			"X    "
			"X    "
			" XXXX"
		]
	] [
		code: 100
		image: [
			"    X"
			"    X"
			"    X"
			" XXXX"
			"X   X"
			"X   X"
			" XXXX"
		]
	] [
		code: 101
		image: [
			"     "
			"     "
			" XXX "
			"X   X"
			"XXXXX"
			"X    "
			" XXXX"
		]
	] [
		code: 102
		image: [
			"   X "
			"  X X"
			"  X  "
			" XXX "
			"  X  "
			"  X  "
			"  X  "
		]
	] [
		code: 103
		image: [
			"     "
			"     "
			" XXXX"
			"X   X"
			" XXXX"
			"    X"
			"XXXX "
		]
	] [
		code: 104
		image: [
			"X    "
			"X    "
			"X    "
			"XXXX "
			"X   X"
			"X   X"
			"X   X"
		]
	] [
		code: 105
		image: [
			"     "
			"  X  "
			"     "
			"  X  "
			"  X  "
			"  X  "
			"  X  "
		]
	] [
		code: 106
		image: [
			"   X "
			"     "
			"   X "
			"   X "
			"   X "
			"X  X "
			" XX  "
		]
	] [
		code: 107
		image: [
			" X   "
			" X   "
			" X  X"
			" X X "
			" XX  "
			" X X "
			" X  X"
		]
	] [
		code: 108
		image: [
			" XX  "
			"  X  "
			"  X  "
			"  X  "
			"  X  "
			"  X  "
			" XXX "
		]
	] [
		code: 109
		image: [
			"     "
			"     "
			"XX XX"
			"X X X"
			"X X X"
			"X X X"
			"X   X"
		]
	] [
		code: 110
		image: [
			"     "
			"     "
			"X XX "
			"XX  X"
			"X   X"
			"X   X"
			"X   X"
		]
	] [
		code: 111
		image: [
			"     "
			"     "
			" XXX "
			"X   X"
			"X   X"
			"X   X"
			" XXX "
		]
	] [
		code: 112
		image: [
			"     "
			"     "
			"XXXX "
			"X   X"
			"XXXX "
			"X    "
			"X    "
		]
	] [
		code: 113
		image: [
			"     "
			"     "
			" XXXX"
			"X   X"
			" XXXX"
			"    X"
			"    X"
		]
	] [
		code: 114
		image: [
			"     "
			"     "
			"X XX "
			"XX  X"
			"X    "
			"X    "
			"X    "
		]
	] [
		code: 115
		image: [
			"     "
			"     "
			" XXXX"
			"X    "
			" XXX "
			"    X"
			"XXXX "
		]
	] [
		code: 116
		image: [
			"  X  "
			"  X  "
			"XXXXX"
			"  X  "
			"  X  "
			"  X X"
			"   X "
		]
	] [
		code: 117
		image: [
			"     "
			"     "
			"X   X"
			"X   X"
			"X   X"
			"X   X"
			" XXX "
		]
	] [
		code: 118
		image: [
			"     "
			"     "
			"X   X"
			"X   X"
			"X   X"
			" X X "
			"  X  "
		]
	] [
		code: 119
		image: [
			"     "
			"     "
			"X   X"
			"X   X"
			"X X X"
			"X X X"
			" X X "
		]
	] [
		code: 120
		image: [
			"     "
			"     "
			"X   X"
			" X X "
			"  X  "
			" X X "
			"X   X"
		]
	] [
		code: 121
		image: [
			"     "
			"     "
			"X   X"
			" X X "
			"  X  "
			"  X  "
			" X   "
		]
	] [
		code: 122
		image: [
			"     "
			"     "
			"XXXXX"
			"   X "
			"  X  "
			" X   "
			"XXXXX"
		]
	] [
		code: 123
		image: [
			"   XX"
			"  X  "
			"  X  "
			" X   "
			"  X  "
			"  X  "
			"   XX"
		]
	] [
		code: 124
		image: [
			"  X  "
			"  X  "
			"  X  "
			"     "
			"  X  "
			"  X  "
			"  X  "
		]
	] [
		code: 125
		image: [
			"XX   "
			"  X  "
			"  X  "
			"   X "
			"  X  "
			"  X  "
			"XX   "
		]
	] [
		code: 126
		image: [
			"    X"
			" XXX "
			"X    "
			"     "
			"     "
			"     "
			"     "
		]
	] [
		code: 127
		name: "Delete"
		abbr: "DEL"
		description: {
			Not technically part of the C0 control character range, this was
			originally used to mark deleted characters on paper tape, since any
			character could be changed to all ones by punching holes everywhere.
			On VT100 compatible terminals, this is the character generated by 
			the backspace on modern machines, and does not correspond to the PC
			delete key.
		}
		image: [
			"XXXXX"
			"XX   "
			"X X X"
			"   X "
			"X X X"
			"XX   "
			"XXXXX"
		]
		notes: {
			delete key logo icon (x inside a left pentagon) in reverse video 
		}
		rating: 'fair
	]
] 



;
; Returns table of objects made from the PIC CPU font and the override data
; 
; For more on bitstreams, see:
; http://www.rebolforces.com/articles/compression/4/
;
make-arecibo-ascii-table: function [ ; params
	fontData [block!] "PIC CPU font data"
	allSymbolData [block!] "Block of character descriptors"
] [ ; locals
	curChar
	areciboTable
	fontIter fontByte fontByteBits curBitIndex rowMajorBits bitstringRep
	symbolBlock symbolObject
] [ ; body
	curChar: 0
	areciboTable: copy [] 

	foreach symbolBlock allSymbolData [
		symbolObject: make object! symbolBlock
		print symbolObject
		
		either (in symbolObject 'image) [ 
			bitstringRep: rejoin symbolObject/image
			if not find [" " "X" " X"] (sort unique bitstringRep) [
				throw make error! "Override image may only contain X and (space)"
			]
			replace/all bitstringRep #" " #"0"
			replace/all bitstringRep #"X" #"1"
			if (length? bitstringRep) <> (5 * 7) [
				throw make error! "Override image not 5x7"
			]
			change (skip areciboTable symbolObject/code) make object! [
				name: either in symbolObject 'name [
					symbolObject/name
				] [
					to-string to-char symbolObject/code
				]
				bitstring: bitstringRep
			]
		] [
			change (skip areciboTable symbolObject/code) make object! [
				name: symbolObject/name
				; no bitstring :(
			]
		]
	]
	return areciboTable
]

;
; Make a header message with comment delimiters, useful for any date/time info
; or general warnings you want to insert.  For intance, warning people this is
; just a draft of this fledgling and bizarre specification!
;
make-header: function [
	startComment
	endComment
] [
	; no locals yet...
] [
	return reform [
		startComment	
		reform [
			"Generated with"
			system/script/header/file
			"version"
			system/script/header/version
		]
		endComment
		"^/"
	
		startComment
		reform [
			"See:" system/script/header/home
		]
		endComment
		"^/"
	
		startComment
		reform [
			"WARNING: THIS IS A WORKING DRAFT AS OF" 
			system/script/header/date 
		]
		endComment
		"^/"
		
		startComment
		"C0 control codes are especially likely to change!"
		endComment
		"^/"
	]
]

;
; Generate HTML variation of the Arecibo ASCII table
;
print-for-html: function [
	areciboTable
] [
	areciboObject curChar
] [
	print "<!-- HTML format of Arecibo ASCII Table -->"
	print make-header "<!--" "-->"
	print "<table>"	
	print rejoin [
		"<thead>"
		"<tr>"
		"<td><b>ASCII</b></td>"
		"<td><b>Character</b></td>"
		"<td><b>Arecibo ASCII (35-bit binary)</b></td>"
		"</tr>"
		"</thead>"
	]

	print "<tbody>"
	curChar: 0
	foreach areciboObject areciboTable [	
		print rejoin [
			"<tr>"
			"<td>" to-integer curChar "</td>"
			"<td>" areciboObject/name "</td>"
			"<td>"
			either (in areciboObject 'bitstring) [
				areciboObject/bitstring
			] [
				"(not yet defined)"
			]
			"</td>"
			"</tr>"
		]
		curChar: curChar + 1
	]
	print "</tbody>"
	print "</table>"
]

;
; Generate Javascript version of the Arecibo ASCII Table
;
print-for-javascript: function [
	areciboTable
] [
	areciboObject curChar lastChar?
] [
	print "/* Javascript format of Arecibo ASCII Table */"
	print make-header "/*" "*/"
	print "var AreciboAscii = {"
	print rejoin [{^-name: "} "USCII-5x7-ENGLISH-C0" {",}]
	print rejoin [{^-version: "} system/script/header/version {",}]
	print rejoin [{^-date: "} system/script/header/date  {",}]
	print rejoin [{^-bitstrings: [}]
	curChar: 0
	foreach areciboObject areciboTable [
		lastChar?: curChar = ((length? areciboTable) - 1)
		print rejoin [
			"^-^-" ; tab character in REBOL
			either (in areciboObject 'bitstring) [
				rejoin [{"} areciboObject/bitstring {"}]
			] [
				"null"
			]
			(either lastChar? [{ }] [{,}])
			" // (" to-integer curChar "): " areciboObject/name
		]
		curChar: curChar + 1
	]
	print "^-]"
	print "};"
]

;
; Generates images of the characters and the CSS sprite of all of them
; http://css-tricks.com/css-sprites/
;
; See REBOL's image documentation here:
; 	http://www.rebol.com/docs/image.html
;
generate-all-image-files: function [
	areciboTable
	directory
	scaleFactors [block!] "block of scaled versions to create"
] [
	areciboObject curChar scaleFactor
	img imgIndex imgAll imgAllIndex
	directoryForScale filename filenameMeter filenameAll
] [
	foreach scale scaleFactors [
		print ["Generating images for scale factor:" scale]
		directoryForScale: to-file reduce [directory rejoin ["x" (to-string scale)]]
		
		if not exists? directoryForScale [
			make-dir/deep directoryForScale
		]

		imgAll: make image! to-pair reduce [5 * scale ((length? areciboTable) * 7) * scale]
		imgAll/alpha: 0 ; make entire image opaque
		imgAllIndex: 1

		curChar: 0
		foreach areciboObject areciboTable [
			if (in areciboObject 'bitstring) [
				img: make image! to-pair reduce [(5 * scale) (7 * scale)]
				img/rgb: red ; make it easier to see mistakes in draw code as red
				img/alpha: 0 ; make entire image opaque
				imgIndex: 1

				bitRow: 0 
				bitCol:	0		
				foreach bit areciboObject/bitstring [
					color: either (bit == #"1") [black] [white]
					change/dup skip img (to-pair reduce [
						(bitCol * scale) (bitRow * scale)
					]) color to-pair reduce [
						(scale) (scale)
					]
					change/dup skip imgAll (to-pair reduce [
						(bitCol * scale) ((bitRow + (curChar * 7)) * scale)
					]) color to-pair reduce [
						(scale) (scale)
					]
										
					imgIndex: imgIndex + 1
					imgAllIndex: imgAllIndex + 1
					bitCol: bitCol + 1
					if (bitCol == (5)) [
						bitRow: bitRow + 1
						bitCol: 0
					]
				]
				filename: to-file reduce [directoryForScale rejoin [curChar ".png"]] 
				print ["Writing" areciboObject/bitstring "to: " clean-path filename]
				save/png filename img 
			]
			curChar: curChar + 1
		]
		
		filenameAll: to-file reduce [directoryForScale "all.png"]
		print ["Writing all images to single CSS sprite: " clean-path filename]
		save/png filenameAll imgAll
		
		; The condition of "all bits set" is reserved for setting up the "meter",
		; e.g. helping to hint at the significance of the 35 bit pattern.  This
		; cannot be used inside of the signal.
		imgMeter: make image! [5x7]
		img/alpha: 0 ; set all image opaque
		img/rgb: black ; set all image black
		filenameMeter: to-file reduce [directoryForScale "meter.png"]
		print ["Writing meter to: " clean-path filenameMeter]
		save/png filenameMeter imgMeter
	]
]


print-output-separator: function [] [] [
	print "^/^/----------^/^/" ; "^/" is REBOL's notation for line breaks
]


;
; Main routine called by the script which invokes all the others
;
print-arecibo-ascii-table: function [
	fontData [block!]
	allSymbolData [block!]
] [
	areciboTable curChar areciboString
] [
	areciboTable: make-arecibo-ascii-table fontData allSymbolData 

	print-output-separator

	generate-all-image-files areciboTable %./images/5x7/ [1 4]

	print-output-separator
		
	print-for-html areciboTable

	print-output-separator
	
	print-for-javascript areciboTable
	
	print-output-separator
		
	curChar: 0
	foreach areciboObject areciboTable [
		if not (in areciboObject 'bitstring) [
			print rejoin [
				"WARNING - No bitstring defined for "
				"(" curChar "): "
				areciboObject/name
			]
		]
		curChar: curChar + 1
	]
]

print-arecibo-ascii-table fontData allSymbolData
