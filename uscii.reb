Rebol [
    Title: {Arecibo Ascii Generator}

    Purpose: {Generates Character Set For a USCII Specification}

    Author: {Hostile Fork}
    Home: http://hostilefork.com/uscii/
    License: mit

    File: %uscii.reb
    Date: 12-Sep-2021
    Version: 0.4.0

    ; Header conventions: http://www.rebol.org/one-click-submission-help.r
    Type: fun
    Level: intermediate

    Usage: {
        The script will output its results in the %/build directory.
        This includes:

            * a CSS sprite of all the characters as one file
            * individual PNG files of all the symbols, at x1 and x4 size
            * an HTML version of the table
            * a Javascript version of the table for using in programs
    }
]

scale-factors: [1 4]  ; Should be a parameter to the script


=== LOAD FONT AND OVERRIDE DATA ===

override-list: uparse load %uscii-5x7-english-c0.reb [
    collect some keep gather [
        '===
        emit abbreviation: [
            temp: set-word! (as text! temp)  ; e.g. `LF`
            |
            temp: set-path! (as block! temp)  ; e.g. `DC1/XON`
        ]
        emit name: between <here> [emit code: subparse group! integer!]
        '===

        emit image: collect 7 [w: word!, keep (as text! w)]

        maybe ['description:, emit description: text!]
        maybe ['notes:, emit notes: text!]
        maybe ['rating:, emit rating: word!]
    ]
] else [
    fail ["Could not parse %uscii-5x7-english-c0.reb"]
]

font-data: load-value %pic-cpu-5x7-font.reb


=== MAKE ARECIBO-TABLE FROM PIC FONT AND OVERRIDES ===

current-char: 0
arecibo-table: copy []
font-iter: head font-data

; NOTE: We decode all the data for kicks, but only use values for 0-127
repeat 256 [
    if font-iter = tail font-data [
        fail "Too few bytes in 5x7 font data"
    ]

    ; To make it easier to turn Arecibo ASCII into a picture of a letter
    ; by inserting a line break after every 5th bit, we switch from the
    ; column-major order used by the PIC CPU to row-major order.
    ;
    ;    http://en.wikipedia.org/wiki/Row-major_order
    ;
    row-major-bits: copy []
    repeat 7 [
        append row-major-bits copy {}
    ]

    ; 5 columns per character...
    repeat 5 [
        font-byte: first font-iter
        font-byte-bits: enbase/base (append copy #{} font-byte) 2

        ; 7 meaningful row bits per character...
        count-up bit-index 7 [
            append (pick row-major-bits bit-index) (pick font-byte-bits bit-index)
        ]

        font-iter: next font-iter
    ]

    bitstring: join text! row-major-bits

    ; do not insert any empty bitstrings, we need pictures for everything
    ; besides space (which is an override)

    append arecibo-table make object! compose [
        name: either current-char = 0 ["(NUL)"] [
            to text! make char! current-char
        ]
        bitstring: (either find bitstring "1" [bitstring] ['~empty~])
    ]
    current-char: current-char + 1
]
if font-iter <> tail font-data [
    fail "Too many bytes in 5x7 font data"
]

; So erase all the higher records we created
remove/part (skip arecibo-table 128) (tail arecibo-table)

for-each override override-list [
    print [{Processing override:} override.name]

    bitstring: join text! override.image
    replace/all bitstring "▢" "0"
    replace/all bitstring "◼" "1"
    print mold bitstring

    if {01} != union {01} (sort unique bitstring) [
        fail "Override image may only contain ◼ and ▢"
    ]
    if (length of bitstring) <> (5 * 7) [
        fail "Override image not 5x7"
    ]

    change (skip arecibo-table override.code) make object! compose [
        name: override.name
        bitstring: (bitstring)
    ]
]


=== CHECK ALL CHARACTERS HAVE IMAGES ===

current-char: 0
for-each arecibo-object arecibo-table [
    if not (in arecibo-object 'bitstring) [
        print [
            "WARNING - No bitstring defined for "
            "(" current-char "):" space arecibo-object.name
        ]
    ]
    current-char: current-char + 1
]


=== SHARED FUNCTION FOR GENERATING JAVASCRIPT/HTML HEADER COMMENTS ===

; Make a header message with comment delimiters, useful for any date/time info
; or general warnings you want to insert.  For intance, warning people this is
; just a draft of this fledgling and bizarre specification!

make-header: function [
    start-comment {either `/*` if JavaScript, or `<!--` if HTML}
    end-comment {either `*/` if JavaScript, or `-->` if HTML}
][
    return spaced [
        start-comment
        "Generated with"
        system.script.header.file
        "version"
        system.script.header.version
        end-comment
        newline

        start-comment
        "See:" system.script.header.home
        end-comment
        newline

        start-comment
        "WARNING: THIS IS A WORKING DRAFT AS OF"
        system.script.header.date
        end-comment
        newline

        start-comment
        "C0 control codes are especially likely to change!"
        end-comment
        newline
    ]
]


=== GENERATE IMAGE FILES FOR ALL REQUESTED SCALE FACTORS ===

; Generates images of the characters and the CSS sprite of all of them
; http://css-tricks.com/css-sprites/
;
; See Rebol's image documentation here:
;   http://www.rebol.com/docs/image.html
;

directory: join system.options.path %build/images/5x7/

for-each scale scale-factors [
    print ["Generating images for scale factor:" scale]
    scale-dir: join directory reduce ["x" to text! scale "/"]

    if not exists? scale-dir [
        make-dir/deep scale-dir
    ]

    all-images: make image! to pair! reduce [5 * scale ((length? arecibo-table) * 7) * scale]
    all-images.alpha: 255  ; make entire image opaque
    all-images-index: 1

    current-char: 0
    for-each arecibo-object arecibo-table [
        if in arecibo-object 'bitstring [
            image: make image! to pair! reduce [(5 * scale) (7 * scale)]
            image.rgb: 255.0.0  ; red to make it easier to see mistakes
            image.alpha: 255  ; make entire image opaque
            image-index: 1

            bit-row: 0
            bit-column: 0
            for-each bit arecibo-object.bitstring [
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

                image-index: image-index + 1
                all-images-index: all-images-index + 1
                bit-column: bit-column + 1
                if bit-column == 5 [
                    bit-row: bit-row + 1
                    bit-column: 0
                ]
            ]
            filename: join scale-dir reduce [current-char {.png}]
            print [{Writing} arecibo-object.bitstring {to:} clean-path filename]
            save filename image
        ]
        current-char: current-char + 1
    ]

    all-images-filename: to file! reduce [scale-dir "all.png"]
    print [{Writing all images to single CSS sprite:} clean-path filename]
    save all-images-filename all-images

    ; The condition of "all bits set" is reserved for setting up the "meter",
    ; e.g. helping to hint at the significance of the 35 bit pattern.  This
    ; cannot be used inside of the signal.
    meter-image: make image! 5x7
    image.alpha: 0  ; set all image opaque
    image.rgb: 0.0.0  ; set all image black
    meter-image-file: to file! reduce [scale-dir "meter.png"]
    print [{Writing meter to:} clean-path meter-image-file]
    save meter-image-file meter-image
]


=== GENERATE HTML VARIATION OF THE ARECIBO ASCII TABLE ===

print "Outputting HTML table"

lines: copy []

append lines <!-- HTML format of Arecibo ASCII Table -->
append lines make-header "<!--" "-->"
append lines <table>
append lines [
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
for-each arecibo-object arecibo-table [
    append lines [
        <tr>
        <td> to integer! current-char </td>
        <td> arecibo-object.name </td>
        <td> arecibo-object.bitstring </td>
        </tr>
    ]
    current-char: current-char + 1
]
append lines </tbody>
append lines </table>

write/lines (join system.options.path %build/uscii-5x7-english-c0.html) lines


=== GENERATE JAVASCRIPT VARIATION OF THE ARECIBO ASCII TABLE ===

print "Outputting JavaScript table"

lines: copy []

append lines "/* Javascript format of Arecibo ASCII Table */"
append lines make-header "/*" "*/"
append lines "var AreciboAscii = {};"

for-each blk [
    [{AreciboAscii["name"] = } {"} {USCII-5x7-ENGLISH-C0} {"} {;}]
    [{AreciboAscii["version"] = } {"} system.script.header.version {"} {;}]
    [{AreciboAscii["date"] = } space {"} system.script.header.date {"} {;}]
    [{AreciboAscii["width"] = } space 5 {;}]
    [{AreciboAscii["height"] = } space 7 {;}]
    [{AreciboAscii["bitstrings"] = } space "["]
] [
    append lines unspaced blk
]
current-char: 0
for-each arecibo-object arecibo-table [
    lastChar?: current-char = ((length? arecibo-table) - 1)
    append lines unspaced [
        tab
        {"} arecibo-object.bitstring {"}
        either lastChar? [space] [{,}]
        space "//" space "(" to integer! current-char ")" {:} space arecibo-object.name
    ]
    current-char: current-char + 1
]
append lines "];"

write/lines (join system.options.path %build/uscii-5x7-english-c0.js) lines
