## Historical Emulated Version of the USCII Images Generator

USCII was an experiment written in Rebol3's Alpha version in 2008.  It was some
relatively naive code hacked together that took advantage of Rebol's built-in
image type and PNG saving ability.

The file received a small amount of cleanup when R3-Alpha was open-sourced, and
was adjusted to a slight rethink of the design of the "meter" and "silence".

In the intervening years, the Ren-C branch of the interpreter changed the state
of practice significantly.  However, it still aims to provide the ability to
"skin" the interpreter to be able to run code more-or-less compatibly with what
would run in 2008.  This ability to twist the behavior of the system to its
older self via usermode code is interesting in its own right.  It is done with
a module called "Redbol" (a somewhat compatible subset of Rebol2, Red, and
R3-Alpha.)

It is being kept frozen in this state and run as a test of that emulation,
while the main project is adapted and evolved with modern Ren-C.
