![USCII logo](https://raw.githubusercontent.com/hostilefork/uscii/master/uscii-logo.png)

---

Note: Please see [http://uscii.hostilefork.com](http://uscii.hostilefork.com)
for information about this project, including an explanatory video.

---

A USCII system ("Universal Semiotic Coding for Information Interchange",
pronounced "you-ski") is a method of embedding 2-D visual representations of
letters, numbers, and control signals into the coded numbers agreed upon to
represent them.

For instance, instead of using 65 for A and 66 for B as ASCII does, we might
consider using 15621226033 for A and 16400753439 for B.  The reason this could
be interesting is that when converted into binary, these are:

    15621226033 (base 10) = 01110100011000110001111111000110001 (base 2)
    16400753439 (base 10) = 11110100011000111110100011000111110 (base 2)

When transmitted in a medium which hints at the significance of a 35-bit
pattern, the semiprime nature of that number hints at factoring it into 5 and 7
to make a rectangle of those dimensions.  If we do, then it will reveal the
letters they represent as a picture:

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

This script generates a *draft* of the USCII variation "5x7-ENGLISH-C0".  I've
informally labeled this standard "Arecibo Ascii" as an homage to SETI's Arecibo
Message, which employed a similar strategy:

    http://en.wikipedia.org/wiki/Arecibo_message

5x7-ENGLISH-C0 has pictoral representations of *all* ASCII characters which
include the uppercase and lowercase English alphabet, numbers, and some
symbols...as well as the "C0 control codes":

    http://en.wikipedia.org/wiki/C0_and_C1_control_codes

It is therefore possible to losslessly convert a stream of ASCII characters
into USCII-5x7-ENGLISH-C0 and back.
