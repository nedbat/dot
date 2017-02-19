#! /usr/bin/python
"""hexdump.py - hex dump

Ned Batchelder
http://www.nedbatchelder.com
"""

# Broadly adapted from: http://www.kitebird.com/mysql-cookbook/

__version__ = "20070722"    # Change history at end of file.

import getopt, sys

def ascii(x):
    """Determine how to show a byte in ascii."""
    if 32 <= x <= 126:
        return chr(x)
    elif 160 <= x <= 255:
        return '.'
    else:
        return '.'

def hexdump(f, width=16, verbose=0, start=0):
    pos = 0

    ascmap = [ ascii(x) for x in range(256) ]
    
    lastbuf = ''
    lastline = ''
    nStarLen = 0

    if width > 4:
        spaceCol = width//2
    else:
        spaceCol = -1

    if start:
        f.seek(start)
        pos = start
        
    while 1:
        buf = f.read(width)

        length = len(buf)
        if length == 0:
            if nStarLen:
                if nStarLen > 1:
                    print "* %d" % (nStarLen-1)
                elif nStarLen == 1:
                    print lastline
                print lastline
            return

        bShowBuf = 1
        
        if not verbose and buf == lastbuf:
            nStarLen += 1
            bShowBuf = 0
        else:
            if nStarLen:
                if nStarLen == 1:
                    print lastline
                else:
                    print "* %d" % nStarLen
            nStarLen = 0

        # Compose output line           
        hex = ""
        asc = ""
        for i in range(length):
            c = buf[i]
            if i == spaceCol:
                hex = hex + " "
            hex = hex + ("%02x" % ord(c)) + " "
            asc = asc + ascmap[ord(c)]
        line = "%06x: %-49s %s" % (pos, hex, asc)

        if bShowBuf:
            print line
            
        pos = pos + length
        lastbuf = buf
        lastline = line

def main(args):

    def usage():
        for l in [
            "hexdump: display data in hex",
            "hexdump [opts] [file ...]",
            "opts:",
            " -s offset   start dumping from this offset",
            " -v          show all data (else collapse duplicate lines)",
            " -w width    show data this many bytes at a time (default 16)",
            ]: print l
        sys.exit()
        
    try:
        opts, args = getopt.getopt(args, "vw:s:")
    except getopt.GetoptError:
        # print help information and exit:
        usage()

    options = {}
    
    for o, a in opts:
        if o == '-s':
            start = eval(a)
            if type(start) != type(1) or start < 0:
                usage()
            options['start'] = start
        elif o == '-v':
            options['verbose'] = 1
        elif o == '-w':
            width = eval(a)
            if type(width) != type(1) or not (1 <= width <= 100):
                usage()
            options['width'] = width
        else:
            usage()
        
    # Read stdin if no files were named, otherwise read each named file

    if len(args) == 0:
        hexdump(sys.stdin, **options)
    else:
        for name in args:
            try:
                f = open(name, "rb")
            except IOError:
                print >>sys.stderr, "Couldn't open %s" % name
                continue
            hexdump(f, **options)
            f.close()

if __name__ == '__main__':
    try:
        main(sys.argv[1:])
    except KeyboardInterrupt:
        print '\n-- interrupted --'
    except IOError:
        print '\n-- broken pipe --'
        
# Change history:
# 20070722:
# Use integer division.
# Better error trapping, thanks Tim Hatch.
