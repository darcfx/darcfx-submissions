########################################################
#                                                      #
# EasyList v2.2 by Thomas J. Delorme                   #
# E-mail : webmaster@getperl.com                       #
# Created : Saturday, August 14, 1999                  #
# Revisions : See History Below                        #
#                                                      #
########################################################
#                                                      #
# HISTORY                                              #
#                                                      #
# Ver 1.0 - Base script released                       #
#           on Saturday, August 14, 1999               #
#                                                      #
# Ver 1.1 - Fixed bug that erased e-mail data upon     #
#           first unsubscribe.                         #
#                                                      #
# Ver 1.2 - Fixed time-out error by using second       #
#           process for mailings.                      #
#                                                      #
#         - Any attempt to subscribe an e-mail         #
#           address without an @ symbol is now simply  #
#           re-directed back to your homepage with no  #
#           addition made to the mailing list.         #
#                                                      #
# Ver 1.3 - Fixed browser error caused by sending      #
#           extra long messages. Long messages are     #
#           now fully supported.                       #
#                                                      #
# Ver 2.0 - Script now configures itself to use        #
#           sendmail.                                  #
#                                                      #
#         - E-mail addresses are now fully checked for #
#           proper format.                             #
#                                                      #
#         - Easy add/subtract e-mail function added to #
#           the admin screen.                          #
#                                                      #
#         - Mailing subject line now configurable from #
#           the admin screen.                          #
#                                                      #
#         - Subscriber total added to admin screen for #
#           instant knowledge.                         #
#                                                      #
#         - Automatic removal of duplicate e-mail      #
#           addresses from the admin screen.           #
#                                                      #
#         - Header/footer feature introduced to match  #
#           site's 'look and feel'.                    #
#                                                      #
#         - Error message added for unrecognized       #
#           hyperlink commands.                        #
#                                                      #
#         - Error message added for the unsubscribe of #
#           an address not in the database.            #
#                                                      #
#         - Error message replaces the error           #
#           re-direction introduced in v1.2.           #
#                                                      #
# Ver 2.1 - Fixed bug which unsubscribes all e-mail    #
#           addresses below the intended address.      #
#                                                      #
# Ver 2.2 - Underscore in the username portion of an   #
#           e-mail address is now accepted.            #
#                                                      #
#         - Added support for sleep between each block #
#           of e-mails sent for users of hosts that    #
#           require it.                                #
#                                                      #
########################################################
#
# WHAT THE SCRIPT DOES
# 
# Mailing Lists are an important part of any marketing 
# campaign on the internet. It will tell you exactly who
# your potential customers are since they are the ones
# who must first take the time to subscribe to your 
# mailing list. EasyList makes it easy to run your very
# own mailing list so you can find out who YOUR
# potential customers are!
#
# Using an HTML form (code provided) visitors can
# subscribe or unsubscribe to your mailing list! It
# does the following :
#
# 1. When a visitor subscribes the script sends an 
#    e-mail to the visitor telling them that they have
#    been subscribed to your mailing list and displays
#    information on how to unsubscribe from your 
#    mailing list.
#
# 2. When a visitor unsubscribes the script sends an 
#    e-mail to the visitor telling them that they have
#    been unsubscribed to your mailing list and 
#    displays information on how to subscribe to your 
#    mailing list.
#
# 3. It prints a "Subscribed/Unsubscribed" message to 
#    the visitor's browser with a link back to your 
#    homepage.
#
# 4. It prints the e-mail address to a log file for 
#    your reference, and also acts as your database
#    for communicating with your mailing list.
#
# 5. The admin screen allows you to easily send your 
#    message to everyone on your list with the touch
#    of a button.
#
#####################################################
#                                                   #
# This script was written for UNIX so I won't       #
# guarantee it's performance on other platforms.    #
#                                                   #
# See the easylist.cgi file for info on how to set  #
# it up to work with your server.                   #
#                                                   #
# Once you have changed the variables in the        #
# easylist.cgi file to work with your server,       #
# do the following :                                #
#                                                   #
# 1. Upload easylist.cgi into your cgi-bin.         #
#    (Be sure to set chmod to 755.)                 #
#                                                   #
# 2. Put easylist.log, head.txt and foot.txt into a #
#    non-cgi directory of your choice. (Be sure to  #
#    set chmod to 777 on both the directory and the #
#    files.)                                        #
#                                                   #
# 3. Paste the contents of the code.html file into  #
#    whatever HTML page you want to allow people to #
#    subscribe/unsubscribe to your mailing list     #
#    from. You will also need to change the ACTION  #
#    attribute of the <FORM> tag in the HTML code   #
#    to the url of easylist.cgi.                    #
#                                                   #
# 4. You can access the admin screen by entering    #
#    the url of the script with ?action=admin on    #
#    the end of it and entering the password you    #
#    set up in the easylist.cgi file. For example : #
#                                                   #
# http://you.com/cgi-bin/easylist.cgi?action=admin  #
#                                                   #
# I hope this script brings you lots of traffic!    #
#                                                   #
################   THAT'S IT!   #####################

