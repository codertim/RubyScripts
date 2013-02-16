ruby-utils
==========

Misc utilities with Ruby


Entomb
  Uses gpg with symmetric cipher option (-c) to encrypt a file twice.

  Chooses AES256 for first encryption, and randomly chooses another cipher encryption algorithm for the second encryption.

  If AES256 is not available, the script will randomly choose both encryption algorithms, but will not use the same algorithm twice.

  Example: ruby entomb.rb test.txt


Stopwatch
  Very simple command line timer

  Example (output elapsed time every 3 seconds): ruby stopwatch.rb 3


