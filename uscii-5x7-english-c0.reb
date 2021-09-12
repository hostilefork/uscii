Rebol [
    Title: {USCII-5x7-ENGLISH-C0}

    Author: {Hostile Fork}
    Home: http://hostilefork.com/uscii/
    License: mit

    File: %uscii-5x7-english-c0.reb
    Date: 12-Sep-2021
    Version: 0.3.0

    ; Header conventions: http://www.rebol.org/one-click-submission-help.r
    Type: fun
    Level: intermediate

    Description: {
        These are the overridden characters in Arecibo ASCII-35 standard,
        which are typically non-printable.  (The printable characters use the
        PIC CPU 5x7 font.)

        Names here are taken from:
        http://en.wikipedia.org/wiki/ASCIIASCII_control_characters

        Labels from:
        http://en.wikipedia.org/wiki/C0_and_C1_control_codes
    }

    Usage: {Process using the %uscii.reb script}

    Notes: {
        Though some of these are going to look pretty bad, my attempt is to
        derive the graphics from symbols that could also be used in higher
        resolutions.  So imagine these as being scaled down versions of those
        same graphics.

        Many of these choices are questionable and should be revisited, but I
        had to start somewhere to get it out for review.  They are currently
        rated as "good", "fair", and "poor"
    }
]


=== NUL: Null Character (0) ===

◼▢◼▢◼
▢◼▢◼▢
◼▢◼▢◼
▢◼▢◼▢
◼▢◼▢◼
▢◼▢◼▢
◼▢◼▢◼

description: {
    Originally used to allow gaps to be left on paper tape for edits.
    Later used for padding after a code that might take a terminal some
    time to process (e.g. a carriage return or line feed on a printing
    terminal).  Now often used as a string terminator, especially in the
    C programming language.
}
notes: {
    Using a dither pattern, to avoid confusion with all empty (space)
    and all full (transmission end/boundary).
}
rating: good


=== SOH: Start of Header (1) ===

◼▢◼▢◼
◼▢◼◼◼
◼▢◼▢◼
◼▢◼◼◼
◼▢◼▢◼
◼▢◼◼◼
◼▢◼▢◼

description: {
    From: http://www.lammertbies.nl/comm/info/ascii-characters.html
    Nowadays we often see the SOH used in serial RS232 communications
    where there is a master-slave configuration. Each command from the
    master starts with the SOH. This makes it possible for the slave or
    slaves to resynchronize on the next command when data errors
    occured.  Without a clear marking of the start of each command a
    resync might be problematic to implement.
}
notes: {
    vertical line next to dotted vertical line in reverse video
}
rating: poor


=== STX: Start of Text (2) ===

◼◼▢◼◼
◼◼◼◼◼
◼◼▢◼◼
◼◼◼◼◼
◼◼▢◼◼
◼◼◼◼◼
◼◼▢◼◼

description: {
    First character of message text, and may be used to terminate the
    message heading.
}
notes: {
    dotted vertical line in reverse video
}
rating: poor


=== ETX: End of Text (3) ===

◼◼▢◼◼
◼◼▢◼◼
◼◼▢◼◼
◼◼▢◼◼
◼◼▢◼◼
◼◼◼◼◼
◼◼▢◼◼

description: {
    Often used as a "break" character (Ctrl-C) to interrupt or terminate
    a program or process.
}
notes: {
    an exclamation point in reverse video
}
rating: fair


=== EOT: End of Transmission (4) ===

◼◼◼◼◼
◼◼◼◼◼
◼◼◼◼◼
◼◼◼◼◼
◼◼◼◼◼
◼▢▢◼◼
◼▢▢◼◼

description: {
    Used on Unix to signal end-of-file condition on, or to logout from,
    a terminal.
}
notes: {
    A period in reverse video
}
rating: fair


=== ENQ: Enquiry (5) ===

◼◼◼◼◼
◼◼◼▢◼
▢▢▢▢▢
◼◼◼▢◼
◼▢◼◼◼
▢▢▢▢▢
◼▢◼◼◼

description: {
    Signal intended to trigger a response at the receiving end, to see
    if it is still present.
}
notes: {
    Two opposing arrows in reverse video...a good network connectivity
    notion, but guess the question is implicit
}
rating: poor


=== ACK: Acknowledgment (6) ===

◼◼◼◼◼
◼▢◼▢◼
◼◼◼◼◼
◼◼◼◼◼
▢◼◼◼▢
◼▢▢▢◼
◼◼◼◼◼

description: {
    Response to an ENQ, or an indication of successful receipt of a
    message.
}
notes: {
    A happy face :) in reverse video
}
rating: good


=== BEL: Bell (7) ===

◼◼▢◼◼
◼▢▢▢◼
◼▢▢▢◼
◼▢▢▢◼
▢▢▢▢▢
◼◼◼◼◼
◼◼▢◼◼

description: {
    Originally used to sound a bell on the terminal. Later used for a
    beep on systems that didn't have a physical bell. May also quickly
    turn on and off inverse video (a visual bell).
}
notes: {
    An icon of a bell in reverse video
}
rating: good


=== BS: Backspace (8) ===

◼◼◼◼◼
◼◼▢◼◼
◼▢◼◼◼
▢▢▢▢▢
◼▢◼◼◼
◼◼▢◼◼
◼◼◼◼◼

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
notes: {
    arrow pointing back in reverse video
}
rating: fair


=== HT: Horizontal Tab (9) ===

▢▢▢▢▢
▢▢▢▢▢
▢▢▢▢◼
◼◼◼▢◼
▢▢▢▢◼
▢▢▢▢▢
▢▢▢▢▢

description: {
    Position to the next character tab stop.
}
notes: {
    sort of a horizontal "T" shape that has a vertical line like a
    tab stop in MS word
}
rating: fair


=== LF: Line Feed (10) ===

◼◼◼▢▢
▢▢◼▢▢
▢▢◼▢▢
▢▢◼▢▢
◼◼◼◼◼
▢◼◼◼▢
▢▢◼▢▢

description: {
    On typewriters, printers, and some terminal emulators, moves the
    cursor down one row without affecting its column position. On Unix,
    used to mark end-of-line. In MS-DOS, Windows, and various network
    standards, used following CR as part of the end-of-line mark.
}
notes: {
    A spin on the carraige return which emphasizes the "downness" of
    a feed, but also with a horizontal suggestion of the current line
}
rating: good


=== VT: Vertical Tab (11) ===

▢▢◼▢▢
▢▢◼▢▢
▢▢◼▢▢
▢▢◼▢▢
▢▢◼▢▢
▢▢▢▢▢
▢◼◼◼▢

description: {
    Position the form at the next line tab stop.
    The vertical tab is not allowed in SGML, including HTML and XML 1.0.
}
notes: {
    vertical analogue of the choice for horizontal tab
}
rating: good


=== FF: Form Feed (12) ===

◼◼◼◼◼
▢◼◼◼▢
▢▢◼▢▢
▢▢▢▢▢
◼◼◼◼◼
▢◼◼◼▢
▢▢◼▢▢

description: {
    On printers, load the next page. Treated as whitespace in many
    programming languages, and may be used to separate logical divisions
    in code. In some terminal emulators, it clears the screen.
}
notes: {
    Two "arrows" pointing downward to suggest "go far down", but should
    it be in reverse video?
}
rating: fair


=== CR: Carriage Return (13) ===

▢▢▢▢◼
▢▢▢▢◼
▢▢◼▢◼
▢◼◼▢◼
◼◼◼◼◼
▢◼◼▢▢
▢▢◼▢▢

description: {
    Originally used to move the cursor to column zero while staying on
    the same line. On Mac OS (pre-Mac OS X), as well as in earlier
    systems such as the Apple II and Commodore 64, used to mark
    end-of-line. In MS-DOS, Windows, and various network standards, it
    is used preceding LF as part of the end-of-line mark. The Enter or
    Return key on a keyboard will send this character, but it may be
    converted to a different end-of-line sequence by a terminal program.
}
notes: {
    This symbol has been established as meaning "carriage return"...
    which does not always feed to the next line
}
rating: good


=== SO: Shift Out (14) ===

▢▢◼▢▢
◼▢◼◼◼
◼◼▢◼◼
◼◼▢◼◼
◼◼▢◼◼
◼◼◼▢◼
◼◼◼▢▢

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
notes: {
    Apple's option icon (a switch) in reverse video
}
rating: poor


=== SI: Shift In (15) ===

◼◼◼▢▢
◼◼◼▢◼
◼◼▢◼◼
◼◼▢◼◼
◼◼▢◼◼
◼▢◼◼◼
▢▢◼▢▢

description: {
    Return to regular character set after Shift Out.
}
notes: {
    Apple's option icon (a switch) in reverse video, upside down
}
rating: poor


=== DLE: Data Link Escape (16) ===

◼◼◼◼◼
◼◼◼◼◼
▢▢◼▢▢
▢◼▢◼▢
▢▢◼▢▢
◼◼◼◼◼
◼◼◼◼◼

description: {
    Cause the following octets to be interpreted as raw data, not as
    control codes or graphic characters. Returning to normal usage would
    be implementation dependent.
}
notes: {
    A "chain" or link?  Infinity symbol, maybe, to suggest opening
    the door to a new data world?  Both would apply.  reverse video
}
rating: fair


=== DC1/XON: Device Control 1 (17) ===

◼◼◼◼◼
◼▢◼◼◼
◼▢▢◼◼
◼▢▢▢◼
◼▢▢◼◼
◼▢◼◼◼
◼◼◼◼◼

description: {
    These four control codes are reserved for device control, with the
    interpretation dependent upon the device they were connected. DC1
    and DC2 were intended primarily to indicate activating a device
    while DC3 and DC4 were intended primarily to indicate pausing or
    turning off a device.  In actual practice DC1 and DC3 (known also as
    XON and XOFF respectively in this usage) quickly became the de facto
    standard for software flow control.
}
notes: {
    VCR Play Symbol in reverse video
}
rating: good


=== DC2: Device Control 2 (18) ===

◼◼▢◼◼
◼◼▢◼◼
▢◼▢◼▢
▢◼▢◼▢
▢◼◼◼▢
▢◼◼◼▢
◼▢▢▢◼

description: {
    From: http://www.cs.tut.fi/~jkorpela/chars/c0.html
    A device control character which is primarily intended for turning
    on or starting an ancillary device. If it is not required for this
    purpose, it may be used to set a device to a special mode of
    operation (in which case DC1 is used to restore normal operation),
    or for any other device control function not provided by other DCs.
}
notes: {
    power on symbol in reverse video
}
rating: fair


=== DC3/XOFF: Device Control 3 (19) ===

◼◼◼◼◼
◼▢◼▢◼
◼▢◼▢◼
◼▢◼▢◼
◼▢◼▢◼
◼▢◼▢◼
◼◼◼◼◼

notes: {
    Pause symbol in reverse video
}
rating: good


=== DC4: Device Control 4 (20) ===

◼◼◼◼◼
◼▢▢▢◼
◼▢▢▢◼
◼▢▢▢◼
◼▢▢▢◼
◼▢▢▢◼
◼◼◼◼◼

description: {
    From: http://www.cs.tut.fi/~jkorpela/chars/c0.html
    A device control character which is primarily intended for turning
    off, stopping or interrupting an ancillary device. If it is not
    required for this purpose, it may be used for any other device
    control function not provided by other DCs.
}
notes: {
    Stop symbol in reverse video
}
rating: good


=== NAK: Negative Acknowledegment (21) ===

◼◼◼◼◼
◼▢◼▢◼
◼◼◼◼◼
◼◼◼◼◼
◼▢▢▢◼
▢◼◼◼▢
◼◼◼◼◼

description: {
    Sent by a station as a negative response to the station with which the
    connection has been set up. In binary synchronous communication
    protocol, the NAK is used to indicate that an error was detected in
    the previously received block and that the receiver is ready to accept
    retransmission of that block. In multipoint systems, the NAK is used
    as the not-ready reply to a poll.
}
notes: {
    A frowny face :( in reverse video
}
rating: good


=== SYN: Synchronous Idle (22) ===

◼◼◼◼◼
◼◼◼◼◼
◼◼◼◼◼
◼◼◼◼◼
◼◼◼◼◼
▢◼▢◼▢
◼◼◼◼◼

description: {
    Used in synchronous transmission systems to provide a signal from
    which synchronous correction may be achieved between data terminal
    equipment, particularly when no other character is being transmitted.
}
notes: {
    an ellipsis in reverse video
}
rating: good


=== ETB: End of Trans. Block (23) ===

◼◼◼◼◼
▢▢▢▢▢
▢◼◼◼▢
▢◼▢◼▢
▢◼◼◼▢
▢▢▢▢▢
◼◼◼◼◼

description: {
    Indicates the end of a transmission block of data when data are
    divided into such blocks for transmission purposes.
}
notes: {
    Grasping at straws with this.  Funny hollow "block" in reverse
    video?  Also considered three vertical pipes in reverse video, to
    go to a deeper level than file separator, but it looks too much
    like two vertical pipes in non-reverse video
}
rating: poor


=== CAN: Cancel (24) ===

◼▢▢▢◼
▢▢▢▢▢
▢◼▢◼▢
▢▢◼▢▢
▢◼▢◼▢
▢▢▢▢▢
◼▢▢▢◼

description: {
    Indicates that the data preceding it are in error or are to be
    disregarded.
}
notes: {
    Inspired by use of a circle with a cross through it, usually
    red circle with white X.  In reverse video
}
rating: fair


=== EM: End of Medium (25) ===

◼◼◼◼◼
◼▢▢▢◼
▢◼◼▢▢
▢◼▢◼▢
▢▢◼◼▢
◼▢▢▢◼
◼◼◼◼◼

description: {
    Intended as means of indicating on paper or magnetic tapes that the
    end of the usable portion of the tape had been reached.
}
notes: {
    Would *like* to approximate a hand holding up it's palm, like
    whoa, "stop!".  But trying the circle with a slash through it
    as a "no" icon
}
rating: fair


=== SUB: Substitute (26) ===

◼▢▢▢◼
▢◼◼◼▢
◼◼◼◼▢
◼◼◼▢◼
◼◼▢◼◼
◼◼◼◼◼
◼◼▢◼◼

description: {
    Originally intended for use as a transmission control character to
    indicate that garbled or invalid character had been received. It has
    often been put to use for other purposes when the in-band signaling
    of errors it provides is unneeded, especially where robust methods
    of error detection and correction are used, or where errors are
    expected to be rare enough to make using the character for other
    purposes advisable.
}
notes: {
    A question mark in reverse video
}
rating: good


=== ESC: Escape (27) ===

▢▢▢◼◼
▢▢◼◼▢
▢◼▢◼▢
◼◼◼◼▢
▢◼◼◼▢
▢◼◼◼▢
◼▢▢▢◼

description: {
    The ESC key on the keyboard will cause this character to be sent on
    most systems. It can be used in software user interfaces to exit
    from a screen, menu, or mode, or in device-control protocols (e.g.,
    printers and terminals) to signal that what follows is a special
    command sequence rather than normal text. In systems based on
    ISO/IEC 2022, even if another set of C0 control codes are used, this
    octet is required to always represent the escape character.
}
notes: {
    Inspired by Apple's choice of a circle with an arrow pointing out
    of its upper left corner (hard to do in 5x7), in reverse video
}
rating: poor


=== FS: File Separator (28) ===

◼▢◼▢◼
◼▢◼▢◼
◼▢◼▢◼
◼▢◼▢◼
◼▢◼▢◼
◼▢◼▢◼
◼▢◼▢◼

description: {
    Can be used as delimiters to mark fields of data structures. If used
    for hierarchical levels, Unit Separator is the lowest level
    (dividing plain-text data items), while Record Separator, Group
    Separator, and File Separator are of increasing level to divide
    groups made up of items of the level beneath it.
}
notes: {
    double pipe--two vertical lines in reverse video
}
rating: fair


=== GS: Group Separator (29) ===

◼◼▢◼◼
◼◼▢◼◼
◼◼▢◼◼
◼◼▢◼◼
◼◼▢◼◼
◼◼▢◼◼
◼◼▢◼◼

notes: {
    pipe symbol in reverse video
}
rating: fair


=== RS: Record Separator (30) ===

◼◼◼◼▢
◼◼◼◼▢
◼◼▢◼▢
◼▢▢◼▢
▢▢▢▢▢
◼▢▢◼◼
◼◼▢◼◼

notes: {
    carraige return in reverse video, trying to be like how
    comma delimited files use carraige returns to separate records
    could be confusing, and I'm wondering if carriage returns should
    be in reverse video in the first place...right now I want to
    treat them as "normal" characters instead of control codes
}
rating: fair


=== US: Unit Separator (31) ===

◼◼◼◼◼
◼◼◼◼◼
◼◼◼◼◼
◼◼◼◼◼
◼▢▢◼◼
◼◼▢◼◼
◼▢◼◼◼

notes: {
    a comma in reverse video, to suggest a comma delimited file
}
rating: fair


=== SP: Space (32) ===

▢▢▢▢▢
▢▢▢▢▢
▢▢▢▢▢
▢▢▢▢▢
▢▢▢▢▢
▢▢▢▢▢
▢▢▢▢▢

description: {
    Space is a graphic character. It has a visual representation
    consisting of the absence of a graphic symbol. It causes the active
    position to be advanced by one character position. In some
    applications, Space can be considered a lowest-level "word
    separator" to be used with the adjacent separator characters.
}
rating: good


=== DEL: Delete (127) ===

◼◼◼◼◼
◼◼▢▢▢
◼▢◼▢◼
▢▢▢◼▢
◼▢◼▢◼
◼◼▢▢▢
◼◼◼◼◼

description: {
    Not technically part of the C0 control character range, this was
    originally used to mark deleted characters on paper tape, since any
    character could be changed to all ones by punching holes everywhere.
    On VT100 compatible terminals, this is the character generated by
    the backspace on modern machines, and does not correspond to the PC
    delete key.
}
notes: {
    delete key logo icon (x inside a left pentagon) in reverse video
}
rating: fair
