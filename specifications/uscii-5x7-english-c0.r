REBOL [
	Title: {"Arecibo Ascii Generator"}
	Purpose: "Generates Charset USCII-5x7-ENGLISH-C0"
	Description: { A USCII system ("Universal Standard Coding for Intergalactic
	Information"--pronounced "you-ski") is a method of embedding 2-D visual
	representations of letters, numbers, and control signals into the coded
	numbers agreed upon to represent them.

	For instance, instead of using 65 for A and 66 for B as ASCII does...we 
	might consider using 15621226033 for A and 16400753439 for B.  The reason
	this could be interesting is that when converted into binary, these are:

		15621226033 (base 10) = 01110100011000110001111111000110001 (base 2)
		16400753439 (base 10) = 11110100011000111110100011000111110 (base 2)
    	
	When transmitted in a medium which hints at the significance of a 35-bit
	pattern, the semiprime nature of that number hints at factoring it into
	5 and 7 to make a rectangle of those dimensions.  If we do, then it will
	reveal the letters they represent as a picture:

	01110100011000110001111111000110001:

			01110
			10001
			10001
			10001 => "A"
			11111
			10001
			10001

	11110100011000111110100011000111110:

			11110
			10001
			10001
			11110 => "B"
			10001
			10001
			11110

	This script generates a *draft* of the USCII variation "5x7-ENGLISH-C0".
	I've informally labeled this standard "Arecibo Ascii" as an homage to SETI's
	Arecibo Message, which employed a similar strategy:
	
		http://en.wikipedia.org/wiki/Arecibo_message
		
	5x7-ENGLISH-C0 has pictoral representations of *all* ASCII characters&mdash;
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

	Usage: { Just run the script using a REBOL/View version 2 interpreter.  Get
	one here:

		http://rebol.com/download.html

	The script will print versions of the Arecibo Ascii table in a format for
	the web (HTML table) as well as a version to use in Javascript code.  With
	just a little bit of REBOL know-how, you can make other outputs as well...
	}

	History: [
	0.1.0 [20-Oct-2008 {Initial version created to decode PIC CPU font
	and make table for HostileFork.com blog.  Not released to general
	public.} "Fork"]

	0.1.1 [24-Jun-2009 {Reorganized to support the easy addition and
	tweaking of characters for the C0 control codes.  Modified for REBOL.org
	header conventions, but working draft placed on GitHub.} "Fork"]
	]
]

overrideData: [
	; Overridden characters in Arecibo ASCII-35 standard
	; Names from http://en.wikipedia.org/wiki/ASCII#ASCII_control_characters
	; Labels from http://en.wikipedia.org/wiki/C0_and_C1_control_codes
	
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

fontData: [
	; 5x7 Character Font Code for PIC CPU Assemblers
	; Taken from http://www.noritake-itron.com/Softview/fontspic.htm
	; The bytes are organised vertically and sequentially for each char's column.
	; D7 is at the top with the space being at D0 for 5x7 characters
	#00 #00 #00 #00 #00 #00 #00 #00 #00 #00 #00 #00 #00 #00 #00 #00 #00 #00 #00 
	#00 #00 #00 #00 #00 #00 #00 #00 #00 #00 #00 #00 #00 #00 #00 #00 #00 #00 #00
	#00 #00 #00 #00 #00 #00 #00 #00 #00 #00 #00 #00 #00 #00 #00 #00 #00 #00 #00
	#00 #00 #00 #00 #00 #00 #00 #00 #00 #00 #00 #00 #00 #00 #00 #00 #00 #00 #00 
	#00 #00 #00 #00 #00 #00 #00 #00 #00 #00 #00 #00 #00 #00 #00 #00 #00 #00 #00 
	#00 #00 #00 #00 #00 #00 #00 #00 #00 #00 #00 #00 #00 #00 #00 #00 #00 #00 #00 
	#00 #00 #00 #00 #00 #00 #00 #00 #00 #00 #00 #00 #00 #00 #00 #00 #00 #00 #00 
	#00 #00 #00 #00 #00 #00 #00 #00 #00 #00 #00 #00 #00 #00 #00 #00 #00 #00 #00 
	#00 #00 #00 #00 #00 #00 #00 #00 #00 #00 #00 #00 #00 #00 #00 #F2 #00 #00 #00 
	#E0 #00 #E0 #00 #28 #FE #28 #FE #28 #24 #54 #FE #54 #48 #C4 #C8 #10 #26 #46 
	#6C #92 #AA #44 #0A #00 #A0 #C0 #00 #00 #00 #38 #44 #82 #00 #00 #82 #44 #38 
	#00 #28 #10 #7C #10 #28 #10 #10 #7C #10 #10 #00 #0A #0C #00 #00 #10 #10 #10 
	#10 #10 #00 #06 #06 #00 #00 #04 #08 #10 #20 #40 #7C #8A #92 #A2 #7C #00 #42
	#FE #02 #00 #42 #86 #8A #92 #62 #84 #82 #A2 #D2 #8C #18 #28 #48 #FE #08 #E4
	#A2 #A2 #A2 #9C #3C #52 #92 #92 #0C #80 #8E #90 #A0 #C0 #6C #92 #92 #92 #6C
	#60 #92 #92 #94 #78 #00 #6C #6C #00 #00 #00 #6A #6C #00 #00 #10 #28 #44 #82
	#00 #28 #28 #28 #28 #28 #00 #82 #44 #28 #10 #40 #80 #8A #90 #60 #4C #92 #9E
	#82 #7C #7E #88 #88 #88 #7E #FE #92 #92 #92 #6C #7C #82 #82 #82 #44 #FE #82
	#82 #44 #38 #FE #92 #92 #92 #82 #FE #90 #90 #90 #80 #7C #82 #92 #92 #5E #FE
	#10 #10 #10 #FE #00 #82 #FE #82 #00 #04 #02 #82 #FC #80 #FE #10 #28 #44 #82
	#FE #02 #02 #02 #02 #FE #40 #30 #40 #FE #FE #20 #10 #08 #FE #7C #82 #82 #82
	#7C #FE #90 #90 #90 #60 #7C #82 #8A #84 #7A #FE #90 #98 #94 #62 #62 #92 #92
	#92 #8C #80 #80 #FE #80 #80 #FC #02 #02 #02 #FC #F8 #04 #02 #04 #F8 #FC #02
	#0C #02 #FC #C6 #28 #10 #28 #C6 #E0 #10 #0E #10 #E0 #86 #8A #92 #A2 #C2 #00
	#FE #82 #82 #00 #40 #20 #10 #08 #04 #00 #82 #82 #FE #00 #20 #40 #80 #40 #20
	#02 #02 #02 #02 #02 #00 #80 #40 #20 #00 #04 #2A #2A #2A #1E #FE #12 #12 #12
	#0C #1C #22 #22 #22 #22 #0C #12 #12 #12 #FE #1C #2A #2A #2A #1A #00 #10 #7E
	#90 #40 #12 #2A #2A #2A #3C #FE #10 #10 #10 #0E #00 #00 #5E #00 #00 #04 #02
	#02 #BC #00 #00 #FE #08 #14 #22 #00 #82 #FE #02 #00 #3E #20 #1C #20 #3E #3E
	#10 #20 #20 #1E #1C #22 #22 #22 #1C #3E #28 #28 #28 #10 #10 #28 #28 #28 #3E
	#3E #10 #20 #20 #10 #12 #2A #2A #2A #24 #20 #20 #FC #22 #24 #3C #02 #02 #02
	#3C #38 #04 #02 #04 #38 #3C #02 #0C #02 #3C #22 #14 #08 #14 #22 #20 #12 #0C
	#10 #20 #22 #26 #2A #32 #22 #00 #10 #6C #82 #82 #00 #00 #EE #00 #00 #82 #82
	#6C #10 #00 #20 #40 #40 #40 #80 #A8 #68 #3E #68 #A8 #BE #2A #2A #2A #A2 #00
	#20 #50 #A0 #00 #04 #22 #7C #A0 #40 #84 #FC #04 #00 #20 #FE #02 #02 #12 #02
	#1C #22 #14 #08 #36 #4E #3E #60 #40 #40 #0C #12 #52 #B2 #1C #08 #1C #2A #2A
	#2A #F8 #40 #40 #3C #02 #7C #92 #92 #7C #00 #42 #44 #38 #04 #02 #20 #3E #20
	#3E #22 #10 #20 #3C #22 #20 #18 #24 #7E #24 #18 #1C #22 #0C #22 #1C #82 #C6
	#AA #92 #82 #3A #46 #40 #46 #3A #54 #54 #54 #54 #54 #44 #28 #10 #28 #44 #10
	#10 #54 #10 #10 #00 #70 #88 #88 #70 #60 #90 #8A #80 #40 #FE #FE #92 #92 #92
	#0A #1A #2A #4A #8A #8A #4A #2A #1A #0A #28 #2C #38 #68 #28 #04 #FE #80 #80
	#80 #4C #92 #92 #7C #00 #04 #02 #7C #80 #40 #38 #44 #38 #44 #38 #AA #54 #AA
	#54 #AA #00 #00 #00 #00 #00 #00 #00 #BE #00 #00 #38 #44 #FE #44 #00 #12 #7E
	#92 #92 #42 #BA #44 #44 #44 #BA #A8 #68 #3E #68 #A8 #00 #00 #EE #00 #00 #50
	#AA #AA #AA #14 #00 #80 #00 #80 #00 #7C #BA #AA #AA #7C #12 #AA #AA #AA #7A
	#10 #28 #54 #AA #44 #80 #80 #80 #80 #C0 #00 #00 #00 #00 #00 #7C #AA #BA #82
	#7C #80 #80 #80 #80 #80 #00 #E0 #A0 #E0 #00 #22 #22 #FA #22 #22 #00 #48 #98
	#A8 #48 #00 #00 #A8 #A8 #70 #00 #00 #40 #80 #00 #04 #F8 #10 #10 #E0 #60 #FE
	#80 #FE #80 #00 #00 #10 #10 #00 #08 #00 #02 #04 #00 #00 #48 #F8 #08 #00 #00
	#E8 #A8 #E8 #00 #44 #AA #54 #28 #10 #F0 #04 #0C #14 #2E #F0 #00 #12 #26 #1A
	#FE #FE #FE #FE #FE #0C #12 #A2 #02 #04 #1E #A8 #68 #28 #1E #1E #28 #68 #A8
	#1E #1E #A8 #A8 #A8 #1E #9E #A8 #A8 #A8 #9E #9E #28 #28 #28 #9E #1E #68 #A8
	#68 #1E #7E #90 #FE #92 #92 #70 #8A #8C #88 #88 #3E #AA #6A #2A #22 #3E #2A
	#6A #AA #22 #3E #AA #AA #AA #22 #BE #2A #2A #2A #A2 #00 #A2 #7E #22 #00 #00
	#22 #7E #A2 #00 #00 #A2 #BE #A2 #00 #00 #A2 #3E #A2 #00 #10 #FE #92 #82 #7C
	#BE #90 #88 #84 #BE #1C #A2 #62 #22 #1C #1C #22 #62 #A2 #1C #1C #A2 #A2 #A2
	#1C #9C #A2 #A2 #A2 #9C #9C #22 #22 #22 #9C #44 #28 #10 #28 #44 #3A #4C #54
	#64 #B8 #3C #82 #42 #02 #3C #3C #02 #42 #82 #3C #3C #82 #82 #82 #3C #BC #02
	#02 #02 #BC #60 #10 #4E #90 #60 #FE #44 #44 #44 #38 #7E #A4 #A4 #58 #00 #04
	#AA #6A #2A #1E #04 #2A #6A #AA #1E #04 #AA #AA #AA #1E #84 #AA #AA #AA #9E
	#04 #AA #2A #AA #1E #04 #6A #AA #6A #1E #2E #2A #1C #2A #3A #30 #4A #4C #48
	#00 #1C #AA #6A #2A #1A #1C #2A #6A #AA #1A #1C #AA #AA #AA #1A #1C #AA #2A
	#AA #1A #00 #80 #5E #00 #00 #00 #00 #5E #80 #00 #00 #40 #5E #40 #00 #00 #40
	#1E #40 #00 #0C #12 #52 #B2 #1C #BE #90 #A0 #A0 #9E #0C #92 #52 #12 #0C #0C
	#12 #52 #92 #0C #0C #52 #52 #52 #0C #4C #52 #52 #52 #4C #0C #52 #12 #52 #0C
	#10 #10 #10 #54 #10 #18 #26 #3C #64 #18 #1C #82 #42 #02 #1C #1C #02 #42 #82
	#1C #1C #42 #42 #42 #1C #1C #42 #02 #42 #1C #20 #12 #4C #90 #20 #FE #48 #48
	#30 #00 #20 #92 #0C #90 #20
] 


;
; Returns table of objects made from the PIC CPU font and the override data
; 
; For more on bitstreams, see:
; http://www.rebolforces.com/articles/compression/4/
;
make-arecibo-ascii-table: function [ ; params
	fontData [block!] "PIC CPU font data"
	overrideData [block!] "Block of override descriptors"
] [ ; locals
	curChar
	areciboTable
	fontIter fontByte fontByteBits curBitIndex rowMajorBits bitstringRep
	overrideBlock overrideObject
] [ ; body
	curChar: 0
	areciboTable: copy [] 
	fontIter: head fontData
	loop 256 [
		if fontIter = tail fontData [
			throw make error! "Too few bytes in 5x7 font data"
		]
		; To make it easier to turn Arecibo ASCII into a picture of a letter
		; by inserting a line break after every 5th bit, we switch from the
		; column-major order used by the PIC CPU to row-major order.
		; http://en.wikipedia.org/wiki/Row-major_order
		rowMajorBits: copy []
		loop 7 [
			append rowMajorBits copy ""
		]

		; 5 columns per character...
		loop 5 [
			fontByte: first fontIter
			fontByteBits: enbase/base (to-string to-char to-integer fontByte) 2
			
			; 7 meaningful row bits per character...
			repeat curBitIndex 7 [
				append (pick rowMajorBits curBitIndex) (pick fontByteBits curBitIndex)
			]
			
			fontIter: next fontIter
		]
		bitstringRep: rejoin rowMajorBits
		either (find bitstringRep "1") [
			append areciboTable make object! [
				name: to-string to-char curChar
				bitstring: bitstringRep
			]
		] [
			; do not insert any empty bitstrings, we need pictures for everything
			; besides space (which is an override)
			append areciboTable make object! [
				name: to-string to-char curChar
			]
		]
		curChar: curChar + 1
	]
	if fontIter <> tail fontData [
		throw make error! "Too many bytes in 5x7 font data"
	]
	
	; NOTE: We decode all the data for kicks, but only use values for 0-127
	; So erase all the higher records we created
	remove/part (skip areciboTable 128) (tail areciboTable)
	
	foreach overrideBlock overrideData [
		overrideObject: make object! overrideBlock
		print ["Processing override: "]
		print overrideObject
		
		either (in overrideObject 'image) [ 
			bitstringRep: rejoin overrideObject/image
			if not find [" " "X" " X"] (sort unique bitstringRep) [
				throw make error! "Override image may only contain X and (space)"
			]
			replace/all bitstringRep #" " #"0"
			replace/all bitstringRep #"X" #"1"
			if (length? bitstringRep) <> (5 * 7) [
				throw make error! "Override image not 5x7"
			]
			change (skip areciboTable overrideObject/code) make object! [
				name: overrideObject/name
				bitstring: bitstringRep
			]
		] [
			change (skip areciboTable overrideObject/code) make object! [
				name: overrideObject/name
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
	print "var AreciboAsciiTable = {"
	curChar: 0
	foreach areciboObject areciboTable [
		lastChar?: curChar = ((length? areciboTable) - 1)
		print rejoin [
			"^-" ; tab character in REBOL
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
	print "};"
]

;
; Generates images of the characters
;
; See REBOL's image documentation here:
; 	http://www.rebol.com/docs/image.html
;
generate-all-image-files: function [
	areciboTable
	directory
] [
	areciboObject curChar img imgIndex filename
] [
	if not exists? directory [
		make-dir directory
	]
	 
	curChar: 0
	foreach areciboObject areciboTable [
		if (in areciboObject 'bitstring) [
			img: make image! [5x7]
			img/alpha: 0 ; make entire image opaque
			imgIndex: 1
			foreach bit areciboObject/bitstring [
				either (bit == #"1") [
					poke img imgIndex black
				] [
					poke img imgIndex white
				]
				imgIndex: imgIndex + 1
			]
			filename: to-file reduce [directory rejoin [curChar ".png"]] 
			print ["Writing" areciboObject/bitstring "to: " filename]
			save/png filename img 
		]
		curChar: curChar + 1
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
	overrideData [block!]
] [
	areciboTable curChar areciboString
] [
	areciboTable: make-arecibo-ascii-table fontData overrideData 

	print-output-separator

	generate-all-image-files areciboTable %./5x7/

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

print-arecibo-ascii-table fontData overrideData
