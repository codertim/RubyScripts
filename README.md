ruby-utils
==========

Misc utilities with Ruby

- Entomb

  Uses gpg with symmetric cipher option (-c) to encrypt a file twice.

  Chooses AES256 for first encryption, and randomly chooses another cipher encryption algorithm for the second encryption.

  If AES256 is not available, the script will randomly choose both encryption algorithms, but will not use the same algorithm twice.

  Example: ruby entomb.rb test.txt



- Site Light

  Mobile phone browsers can be slow and have data limits, so use Nokogiri to filter out unimportant info



- Stopwatch

  Very simple command line timer

  Example (output elapsed time every 3 seconds): ruby stopwatch.rb 3


- The Watchers

  Ruby script to notify when content of web page changes 


- Flash Cards

  text-based flash cards

  ability to randomize and flip


