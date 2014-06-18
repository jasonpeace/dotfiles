#!/usr/bin/env python
import fnmatch
from os import listdir, walk, path, environ
from os.path import isfile, join
import sys


def main(argv):
    if not environ.has_key('VIRTUAL_ENV'):
        print "Switch into a virtual env first."
        sys.exit()

    if len(argv)==0:
        print "You need to supply a string to match on."
        sys.exit()
    match = argv[0]
    print "Case insensitive match on '%s'" % match
    virtual_env = environ.get('VIRTUAL_ENV')
    print 'Virtual Env is: %s' % virtual_env
    virtual_env += "/lib/python2.7/site-packages"
    paths = [ virtual_env ]
    # grab a list of files from the directory
    linkfiles = [ f for f in listdir(virtual_env) if
        isfile(join(virtual_env,f)) and f[-9:] == '.egg-link'  ]

    for f in linkfiles:
        fpath = join(virtual_env,f)
        fileObj=open(fpath, 'rb')
        egg_path = fileObj.readline()
        paths.append(egg_path.rstrip('\n'))
        fileObj.close()

    def find_files(directory, pattern):
        for root, dirs, files in walk(directory):
            for basename in files:
                if fnmatch.fnmatch(basename, pattern):
                    filename = path.join(root, basename)
                    yield filename

    for fpath in paths:
        for filename in find_files(fpath, 'requires.txt'):
            f = open(filename, 'r')
            for line in f:
                if match.lower() in line.lower():
                    print filename.split("/")[-3].rstrip('-py2.7.egg')
                    print "\t%s" % line.rstrip('\n')

if __name__ == "__main__":
   main(sys.argv[1:])
