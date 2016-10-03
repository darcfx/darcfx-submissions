Updating to the latest RC2 revision
...................................

Step 1: Uploading the new files.
--------------------------------

Read the file in this folder called "RC2_changed_files.txt" to determine which files
need updating. Extract the tar files locally and simply upload these extracted files 
that are listed in "RC2_changed_files.txt" to your server - its safe to overwrite the
ones on your server.

Also, don't forget to update "ikonboard.cgi" - if you don't, the search won't work.

Step 2: mySQL/pgSQL users.
--------------------------

There were quite a few errors in the original table schematics for mySQL. The new schematic is
included in this package.

In the folder called "mySQL-table-updater" you'll see a script called "alter_table.cgi". This
will automagically update your Ikonboard mySQL database tables, fixing the bugs and adding a 
few more needed fields. (pgSQL users look in "pgSQL-table-updater")

Simply upload this file to the same directory that ikonboard.cgi is in, and call it via your
webbrowser (you may need to CHMOD it to 0755 first).
If you get any errors, open up the alter_tables.cgi script and follow the instructions to add in
your full path to the current directory (the directory the script is sitting in).

Clicking on the link will run the program and it will output what it's changed.


Step 3: Log into your admin CP
-----------------------------

Now you'll need to log into your admin CP. If you were already in the CP, close the browser
window and re-log in. It will then simply update your categories table to fix a bug with sub-categories.


