Rebol [
	Title: {Arecibo Ascii Generator}

	Purpose: {Generates Character Set USCII-5x7-ENGLISH-C0}

	Description: {
		A USCII system ("Universal Semiotic Coding for Information
		Interchange", pronounced "you-ski") is a method of embedding 2-D
		visual representations of letters, numbers, and control signals
		into the coded numbers agreed upon to represent them.

		For instance, instead of using 65 for A and 66 for B as ASCII does,
		we might consider using 15621226033 for A and 16400753439 for B.
		The reason this could be interesting is that when converted into
		binary, these are:

			15621226033 (base 10) = 01110100011000110001111111000110001 (base 2)
			16400753439 (base 10) = 11110100011000111110100011000111110 (base 2)

		When transmitted in a medium which hints at the significance of a
		35-bit pattern, the semiprime nature of that number hints at factoring
		it into 5 and 7 to make a rectangle of those dimensions.  If we do,
		then it will reveal the letters they represent as a picture:

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
		I've informally labeled this standard "Arecibo Ascii" as an homage to
		SETI's Arecibo Message, which employed a similar strategy:

			http://en.wikipedia.org/wiki/Arecibo_message

		5x7-ENGLISH-C0 has pictoral representations of *all* ASCII characters
		which include the uppercase and lowercase English alphabet, numbers,
		and some symbols...as well as the "C0 control codes":

			http://en.wikipedia.org/wiki/C0_and_C1_control_codes

		It is therefore possible to losslessly convert a stream of ASCII
		characters into USCII-5x7-ENGLISH-C0 and back.
	}

	Author: {Hostile Fork}
	Home: http://hostilefork.com/uscii/
	License: 'gpl ; GPL Version 3

	File: %uscii-5x7-english-c0.r
	Date: 29-Sep-2013
	Version: 0.2.0

	; Header conventions: http://www.rebol.org/one-click-submission-help.r
	Type: 'fun
	Level: 'intermediate

	Usage: {
		Just run the script using a Rebol interpreter.  Get one here:

			http://rebolsource.net

		The script will print versions of the Arecibo Ascii table in a format
		for the web (HTML table) as well as a version to use in Javascript
		code.  With just a little bit of Rebol know-how, you can make other
		outputs as well...
	}

	History: [
		0.1.0 [20-Oct-2008 {Initial version created to decode PIC CPU font
		and make table for HostileFork.com blog.  Not released to general
		public.} "Fork"]

		0.1.1 [24-Jun-2009 {Reorganized to support the easy addition and
		tweaking of characters for the C0 control codes.  Modified for Rebol.org
		header conventions, but working draft placed on GitHub.} "Fork"]

		0.2.0 [29-Sep-2013 {Picked back up and ported to the open source
		Rebol 3 interpreter.  Improvements such as using BINARY! data type
		for PIC CPU data, TAG! string type in HTML generation, and general
		cleanup to use new locals-gathering FUNCTION construct.} "Fork"]

	]
]

; In case people aren't using community builds, temporary until mainlining of
;   http://curecode.org/rebol3/ticket.rsp?id=1973
function: :funct
space: #" "

override-data: [
	; Overridden characters in Arecibo ASCII-35 standard
	; Names from http://en.wikipedia.org/wiki/ASCIIASCII_control_characters
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

; 5x7 Character Font Code for PIC CPU Assemblers
; Taken from http://www.noritake-itron.com/Softview/fontspic.htm
; The bytes are organised vertically and sequentially for each char's column.
; D7 is at the top with the space being at D0 for 5x7 characters
font-data: #{
	00000000000000000000000000000000000000 
	00000000000000000000000000000000000000
	00000000000000000000000000000000000000
	00000000000000000000000000000000000000 
	00000000000000000000000000000000000000 
	00000000000000000000000000000000000000 
	00000000000000000000000000000000000000 
	00000000000000000000000000000000000000 
	000000000000000000000000000000F2000000 
	E000E00028FE28FE282454FE5448C4C8102646 
	6C92AA440A00A0C00000003844820000824438 
	0028107C102810107C1010000A0C0000101010 
	1010000606000004081020407C8A92A27C0042
	FE020042868A92628482A2D28C182848FE08E4
	A2A2A29C3C5292920C808E90A0C06C9292926C
	6092929478006C6C0000006A6C000010284482
	002828282828008244281040808A90604C929E
	827C7E8888887EFE9292926C7C82828244FE82
	824438FE92929282FE909090807C8292925EFE
	101010FE0082FE8200040282FC80FE10284482
	FE02020202FE403040FEFE201008FE7C828282
	7CFE909090607C828A847AFE90989462629292
	928C8080FE8080FC020202FCF8040204F8FC02
	0C02FCC6281028C6E0100E10E0868A92A2C200
	FE8282004020100804008282FE002040804020
	02020202020080402000042A2A2A1EFE121212
	0C1C222222220C121212FE1C2A2A2A1A00107E
	9040122A2A2A3CFE1010100E00005E00000402
	02BC0000FE0814220082FE02003E201C203E3E
	1020201E1C2222221C3E28282810102828283E
	3E10202010122A2A2A242020FC22243C020202
	3C38040204383C020C023C221408142220120C
	102022262A322200106C82820000EE00008282
	6C10002040404080A8683E68A8BE2A2A2AA200
	2050A00004227CA04084FC040020FE02021202
	1C221408364E3E6040400C1252B21C081C2A2A
	2AF840403C027C92927C004244380402203E20
	3E2210203C222018247E24181C220C221C82C6
	AA92823A4640463A5454545454442810284410
	10541010007088887060908A8040FEFE929292
	0A1A2A4A8A8A4A2A1A0A282C38682804FE8080
	804C92927C0004027C80403844384438AA54AA
	54AA00000000000000BE00003844FE4400127E
	929242BA444444BAA8683E68A80000EE000050
	AAAAAA1400800080007CBAAAAA7C12AAAAAA7A
	102854AA4480808080C000000000007CAABA82
	7C808080808000E0A0E0002222FA2222004898
	A8480000A8A870000040800004F81010E060FE
	80FE80000010100008000204000048F8080000
	E8A8E80044AA542810F0040C142EF00012261A
	FEFEFEFEFE0C12A202041EA868281E1E2868A8
	1E1EA8A8A81E9EA8A8A89E9E2828289E1E68A8
	681E7E90FE9292708A8C88883EAA6A2A223E2A
	6AAA223EAAAAAA22BE2A2A2AA200A27E220000
	227EA20000A2BEA20000A23EA20010FE92827C
	BE908884BE1CA262221C1C2262A21C1CA2A2A2
	1C9CA2A2A29C9C2222229C44281028443A4C54
	64B83C8242023C3C0242823C3C8282823CBC02
	0202BC60104E9060FE444444387EA4A4580004
	AA6A2A1E042A6AAA1E04AAAAAA1E84AAAAAA9E
	04AA2AAA1E046AAA6A1E2E2A1C2A3A304A4C48
	001CAA6A2A1A1C2A6AAA1A1CAAAAAA1A1CAA2A
	AA1A00805E000000005E800000405E40000040
	1E40000C1252B21CBE90A0A09E0C9252120C0C
	1252920C0C5252520C4C5252524C0C5212520C
	101010541018263C64181C8242021C1C024282
	1C1C4242421C1C4202421C20124C9020FE4848
	300020920C9020
} 


;
; Returns table of objects made from the PIC CPU font and the override data
; 
; For more on bitstreams, see:
; http://www.rebolforces.com/articles/compression/4/
;
make-arecibo-ascii-table: function [
	font-data [binary!] {PIC CPU font data}
	override-data [block!] {Block of override descriptors}
] [
	current-char: 0
	arecibo-table: copy [] 
	font-iter: head font-data

	; NOTE: We decode all the data for kicks, but only use values for 0-127
	loop 256 [
		if font-iter = tail font-data [
			throw make error! "Too few bytes in 5x7 font data"
		]

		; To make it easier to turn Arecibo ASCII into a picture of a letter
		; by inserting a line break after every 5th bit, we switch from the
		; column-major order used by the PIC CPU to row-major order.
		;
		;    http://en.wikipedia.org/wiki/Row-major_order
		;
		row-major-bits: copy []
		loop 7 [
			append row-major-bits copy {}
		]

		; 5 columns per character...
		loop 5 [
			font-byte: first font-iter
			font-byte-bits: enbase/base (append copy #{} font-byte) 2
			; 7 meaningful row bits per character...
			repeat bit-index 7 [
				append (pick row-major-bits bit-index) (pick font-byte-bits bit-index)
			]
			
			font-iter: next font-iter
		]

		bitstring: rejoin row-major-bits

		; do not insert any empty bitstrings, we need pictures for everything
		; besides space (which is an override)

		append arecibo-table make object! compose [
			name: to string! to char! current-char			
			bitstring: (if find bitstring "1" [bitstring])
		]
		++ current-char
	]
	if font-iter <> tail font-data [
		throw make error! "Too many bytes in 5x7 font data"
	]
	
	; So erase all the higher records we created
	remove/part (skip arecibo-table 128) (tail arecibo-table)
	
	foreach override-block override-data [
		override-obj: make object! override-block
		print [{Processing override:} override-obj/name]
		
		unless in override-obj 'image [
			throw make error! {No "image:" field in override}
		]

		bitstring: rejoin override-obj/image
		replace/all bitstring space "0"
		replace/all bitstring "X" "1"

		unless {01} == union {01} (sort unique bitstring) [
			throw make error! "Override image may only contain X and (space)"
		]
		if (length? bitstring) <> (5 * 7) [
			throw make error! "Override image not 5x7"
		]

		change (skip arecibo-table override-obj/code) make object! compose [
			name: override-obj/name
			bitstring: (bitstring)
		]
	]
	return arecibo-table
]

;
; Make a header message with comment delimiters, useful for any date/time info
; or general warnings you want to insert.  For intance, warning people this is
; just a draft of this fledgling and bizarre specification!
;
make-header: function [
	start-comment
	end-comment
] [
	reform [
		start-comment	
		reform [
			"Generated with"
			system/script/header/file
			"version"
			system/script/header/version
		]
		end-comment
		newline
	
		start-comment
		reform [
			"See:" system/script/header/home
		]
		end-comment
		newline
	
		start-comment
		reform [
			"WARNING: THIS IS A WORKING DRAFT AS OF" 
			system/script/header/date 
		]
		end-comment
		newline
		
		start-comment
		"C0 control codes are especially likely to change!"
		end-comment
		newline
	]
]

;
; Generate HTML variation of the Arecibo ASCII table
;
generate-html-table: function [
	filename [file!]
	arecibo-table
] [
	lines: copy []

	append lines <!-- HTML format of Arecibo ASCII Table -->
	append lines make-header "<!--" "-->"
	append lines <table>	
	append lines reform [
		<thead>
		<tr>
		<td> <b> {ASCII} </b> </td>
		<td> <b> {Character} </b> </td>
		<td> <b> {Arecibo ASCII (35-bit binary)} </b> </td>
		</tr>
		</thead>
	]

	append lines <tbody>
	current-char: 0
	foreach arecibo-object arecibo-table [
		append lines reform [
			<tr>
			<td> to integer! current-char </td>
			<td> arecibo-object/name </td>
			<td> arecibo-object/bitstring </td>
			</tr>
		]
		++ current-char
	]
	append lines </tbody>
	append lines </table>

	write/lines filename lines
]

;
; Generate Javascript version of the Arecibo ASCII Table
;
generate-javascript-table: function [
	filename [file!]
	arecibo-table
] [
	lines: copy []

	append lines "/* Javascript format of Arecibo ASCII Table */"
	append lines make-header "/*" "*/"
	append lines "var AreciboAscii = {"
	foreach blk [
		[tab {name:} space {"} {USCII-5x7-ENGLISH-C0} {"} {,}]
		[tab {version:} space {"} system/script/header/version {"} {,}]
		[tab {date:} space {"} system/script/header/date {"} {,}]
		[tab {bitstrings:} space "["]
	] [
		append lines rejoin blk
	]
	current-char: 0
	foreach arecibo-object arecibo-table [
		lastChar?: current-char = ((length? arecibo-table) - 1)
		append lines rejoin [
			tab tab
			{"} arecibo-object/bitstring {"}
			either lastChar? [space] [{,}]
			space "//" space "(" to integer! current-char ")" {:} space arecibo-object/name
		]
		++ current-char
	]
	append lines rejoin [tab "]"]
	append lines "};"
	append lines ""

	write/lines filename lines
]

;
; Generates images of the characters and the CSS sprite of all of them
; http://css-tricks.com/css-sprites/
;
; See Rebol's image documentation here:
; 	http://www.rebol.com/docs/image.html
;
generate-all-image-files: function [
	arecibo-table
	directory
	scale-factors [block!] {block of integers for scale factors to be generated}
] [
	foreach scale scale-factors [
		print ["Generating images for scale factor:" scale]
		scale-dir: to file! rejoin [directory "x" to string! scale "/"]
		
		if not exists? scale-dir [
			make-dir/deep scale-dir
		]

		all-images: make image! to pair! reduce [5 * scale ((length? arecibo-table) * 7) * scale]
		all-images/alpha: 255 ; make entire image opaque
		all-images-index: 1

		current-char: 0
		foreach arecibo-object arecibo-table [
			if in arecibo-object 'bitstring [
				image: make image! to pair! reduce [(5 * scale) (7 * scale)]
				image/rgb: 255.255.0 ; make it easier to see mistakes in draw code as red
				image/alpha: 255 ; make entire image opaque
				image-index: 1

				bit-row: 0 
				bit-column:	0		
				foreach bit arecibo-object/bitstring [
					color: either bit == #"1" [0.0.0] [255.255.255]
					change/dup skip image (to pair! reduce [
						(bit-column * scale) (bit-row * scale)
					]) color to pair! reduce [
						(scale) (scale)
					]
					change/dup skip all-images to pair! reduce [
						bit-column * scale
						(bit-row + (current-char * 7)) * scale
					] color to pair! reduce [
						scale scale
					]
										
					++ image-index
					++ all-images-index
					++ bit-column
					if bit-column == 5 [
						++ bit-row
						bit-column: 0
					]
				]
				filename: to file! rejoin [scale-dir current-char {.png}]
				print [{Writing} arecibo-object/bitstring {to:} clean-path filename]
				save filename image 
			]
			++ current-char
		]
		
		all-images-filename: to file! reduce [scale-dir "all.png"]
		print [{Writing all images to single CSS sprite:} clean-path filename]
		save all-images-filename all-images
		
		; The condition of "all bits set" is reserved for setting up the "meter",
		; e.g. helping to hint at the significance of the 35 bit pattern.  This
		; cannot be used inside of the signal.
		meter-image: make image! [5x7]
		image/alpha: 0 ; set all image opaque
		image/rgb: 0.0.0 ; set all image black
		meter-image-file: to file! reduce [scale-dir "meter.png"]
		print [{Writing meter to:} clean-path meter-image-file]
		save meter-image-file meter-image
	]
]


print-output-separator: function [] [
	print rejoin [
		newline
		newline
		{----------}
		newline
		newline
	]
]


;
; Main routine called by the script which invokes all the others
;
print-arecibo-ascii-table: function [
	font-data [binary!]
	override-data [block!]
] [
	arecibo-table: make-arecibo-ascii-table font-data override-data 

	print-output-separator

	generate-all-image-files arecibo-table rejoin [system/options/path %/build/images/5x7/] [1 4]

	print "Outputting HTML table"
		
	generate-html-table rejoin [system/options/path %build/uscii-5x7-english-c0.html] arecibo-table

	print-output-separator
	
	print "Outputting JavaScript table"

	generate-javascript-table rejoin [system/options/path %build/uscii-5x7-english-c0.js] arecibo-table
	
	print-output-separator
		
	current-char: 0
	foreach arecibo-object arecibo-table [
		if not (in arecibo-object 'bitstring) [
			print rejoin [
				"WARNING - No bitstring defined for "
				"(" current-char "):" space arecibo-object/name
			]
		]
		current-char: current-char + 1
	]
]

print-arecibo-ascii-table font-data override-data
