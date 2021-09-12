Rebol [
    Title: {Arecibo Ascii Generator}

    Purpose: {Generates Character Set For a USCII Specification}

    Author: {Hostile Fork}
    Home: http://hostilefork.com/uscii/
    License: mit

    File: %uscii.reb
    Date: 2-Feb-2014
    Version: 0.3.0

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

import <redbol>  ; Emulation of Rebol2/Red

override-data: uparse load %uscii-5x7-english-c0.reb [
    collect [while keep ^ collect [
        '===
        [
            abbr: set-word! (abbr: as text! abbr)
            |
            abbr: set-path! (abbr: as block! abbr)
        ]
        name: between <here> [code: into group! integer!]
        '===

        keep (lib.compose [
            code: (code)
            name: (spaced inert name)
            abbr: (abbr)
            image:  ; coming up...
        ])

        keep ^ collect 7 [w: word!, keep (as text! w)]

        opt [keep ^ 'description:, keep text!]
        opt [keep ^ 'notes:, keep text!]
        opt [keep ^ 'rating:, keep ^ ^ word!]
    ]]
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
            ;
            ; Note: "Redbol" emulation favors R3-Alpha/Red here, by making the
            ; append of INTEGER! to BINARY! add the byte.  Rebol2 would add
            ; the character, e.g. INTEGER! of 0 appends the ASCII for `0`.
            ;
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
            name: either current-char = 0 ["(NUL)"] [
                to string! to char! current-char
            ]
            bitstring: (either find bitstring "1" [bitstring] [none])
        ]
        current-char: current-char + 1
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
        replace/all bitstring "▢" "0"
        replace/all bitstring "◼" "1"

        unless {01} == union {01} (sort unique bitstring) [
            throw make error! "Override image may only contain ◼ and ▢"
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
        current-char: current-char + 1
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
    append lines "var AreciboAscii = {};"

    foreach blk [
        [{AreciboAscii["name"] = } {"} {USCII-5x7-ENGLISH-C0} {"} {;}]
        [{AreciboAscii["version"] = } {"} system/script/header/version {"} {;}]
        [{AreciboAscii["date"] = } space {"} system/script/header/date {"} {;}]
        [{AreciboAscii["width"] = } space 5 {;}]
        [{AreciboAscii["height"] = } space 7 {;}]
        [{AreciboAscii["bitstrings"] = } space "["]
    ] [
        append lines rejoin blk
    ]
    current-char: 0
    foreach arecibo-object arecibo-table [
        lastChar?: current-char = ((length? arecibo-table) - 1)
        append lines rejoin [
            tab
            {"} arecibo-object/bitstring {"}
            either lastChar? [space] [{,}]
            space "//" space "(" to integer! current-char ")" {:} space arecibo-object/name
        ]
        current-char: current-char + 1
    ]
    append lines rejoin ["];"]

    write/lines filename lines
]

;
; Generates images of the characters and the CSS sprite of all of them
; http://css-tricks.com/css-sprites/
;
; See Rebol's image documentation here:
;   http://www.rebol.com/docs/image.html
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
                image/rgb: 255.0.0 ; make it easier to see mistakes in draw code as red
                image/alpha: 255 ; make entire image opaque
                image-index: 1

                bit-row: 0
                bit-column: 0
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

                    image-index: image-index + 1
                    all-images-index: all-images-index + 1
                    bit-column: bit-column + 1
                    if bit-column == 5 [
                        bit-row: bit-row + 1
                        bit-column: 0
                    ]
                ]
                filename: to file! rejoin [scale-dir current-char {.png}]
                print [{Writing} arecibo-object/bitstring {to:} clean-path filename]
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
