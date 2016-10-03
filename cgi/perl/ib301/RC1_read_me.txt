Updating to the latest RC1 revision
...................................

This package contains all the needed files to update to the latest version of the
release candidate.

Bugs Fixed in this update:

mySQL -> table schematic bug fixes (By: Matt)
pgSQL -> table schematic bug fixes (By: Infection)
mySQL -> Member searching via adminCP fix (By: Matt)
mySQL -> Add moderator bug fix  (By: Matt)
mySQL -> Searching bug fix (By: Matt)
ALL   -> Forwardslash killing search bug fix (By: Matt)
ALL   -> Active users hi-liting bug fix (By: Justin [MaverickX])
ALL   -> Sent items Messenger bug fixes (By: Infection)
ALL   -> Broken Images when force log in switched on (By: Matt)
DBM   -> Sub category bug fixes (By: Matt)
ALL   -> Admin/Session resetting bug fix (By: Matt)


Step 1: Uploading the new files.
--------------------------------

In the folder "upload" you'll see the updated files preserved in their file tree. Simply
upload these files to your server - its safe to overwrite the ones on your server.

Step 2: mySQL users.
--------------------

There were quite a few errors in the original table schematics for mySQL. The new schematic is
included in this package.

In the folder called "mySQL-table-updater" you'll see a script called "alter_table.cgi". This
will automagically update your Ikonboard mySQL database tables, fixing the bugs and adding a 
few more needed fields.

Simply upload this file to the same directory that ikonboard.cgi is in, and call it via your
webbrowser (you may need to CHMOD it to 0755 first).
If you get any errors, open up the alter_tables.cgi script and follow the instructions to add in
your full path to the current directory (the directory the script is sitting in).

Clicking on the link will run the program and it will output what it's changed.


Step 3: Log into your admin CP
-----------------------------

Now you'll need to log into your admin CP. If you were already in the CP, close the browser
window and re-log in. It will then simply update your categories table to fix a bug with sub-categories.


That's it, you should now be able to add, edit moderators and add, edit members without a problem.
