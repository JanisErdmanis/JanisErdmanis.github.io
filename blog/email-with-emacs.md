+++
date = "2017-07-09"
tags = ["linux", "emacs"]
rss = "The user faced usability issues with the Gmail web application, which led me to explore email client alternatives on Ubuntu like Geary and Nylas1, but those also had limitations and bugs. Eventually, I discovered mu4e in Emacs, which provided efficient and distraction-free email management with offline capabilities. However, I had to overcome various challenges to set up my almost perfect email system."
+++

# Email with emacs

Gmail web application is generally very good with many features. However, I struggled with its usability - the need to interact with a mouse in many places, browser spell checker, fast notification of a new email, multiple account management and lack of emacs way of writing the text. In the process, I tried Geary, which was good but sometimes crashed, and Nylas1, which had instant email notifications but became buggy and needed to be actively developed.

With getting to know emacs better, I was pushed into its keyboard binding, a beautiful way of extending functionality that made writing efficient and distraction-free. I looked up how email works on emacs and came across `mu4e` with which I now work with three accounts. I can write, search and read emails very fast and do no need an internet connection. That sometimes is convenient, for example, to look at the booking of a hostel or a flight.

To get my almost perfect setup, I struggled a lot. I had to fight a bug which corrupted the index database; I had to develop a way to have multiple accounts while not having them all in one pot; Because emails were stored locally, I had to create a cron job to update them and the account for network connection failures; Learn to store them under encrypted folder; Dealing with emacs failures due to mu4e plugin running in the background; There are many problems which had overwhelmed me since last In October when I started to take email clients in emacs seriously. Fortunately, it has worked flawlessly for the previous two months, and I have solved my frustration with usability.

## Syncing email accounts

Before downloading an email, we need a [safe encrypted place](https://help.ubuntu.com/community/EncryptedPrivateDirectory) to store it. That can be easily done with Ubuntu, where you need to execute the following commands:

```bash
sudo apt-get install ecryptfs-utils
ecrypt-setup-private
```
and follow the instructions in a terminal to create an encrypted `Private` folder in your home directory.

To sync emails, I use `mbsync`, which is installed with:
```bash
sudo apt-get install isysnc
```
This command asks for a configuration file which for my Gmail account looks as follows:
```plaintext
IMAPStore master
Host imap.gmail.com
User akels14@gmail.com
Pass XXXXXXX
UseIMAPS yes
RequireSSL yes
CertificateFile /etc/ssl/certs/ca-certificates.crt

MaildirStore slave
Path ~/Private/Email/akels14/

Channel inbox
Master ":master:INBOX"
Slave ":slave:inbox"
Create Both
Expunge Both
SyncState *

Channel sent
Master ":master:[Gmail]/Sent Mail"
Slave ":slave:sent"
Create Both
Expunge Both
SyncState *
```

for the fields written, go to the man page of `mbsync` (`man mbsync`). I name this file `mbsync-ak.conf` and then synchronise all my email into `~/Private/Email/akels14` folder with a command (since password is written in plaintext, I also put that in my `Private` folder)

```bash
mbsync -c ~/Private/.config/mbsync-ak.conf inbox sent
```
The first run takes about an hour for me, but then it is done. One warning must be given **Since `mbsync` does synchronise emails between master and slave, it can also delete emails at master if a file is deleted locally (slave).** Fortunately, all emails deleted except the trash directory can be found in the `Archive` folder. That saved my ass a couple of times when I tried to make sense of `mbsync` settings.

To be useful, synchronisation needs to work all the time (but some may prefer to do it on demand), which I accomplish with a cronjob. To start writing commands in crontab, execute `crontab -e,` and write the following lines in it:

```plaintext
PATH=/opt/someApp/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
* * * * * flock -n /tmp/mbsync-ak.lock timeout 300 mbsync -c /home/janiserdmanis/Private/.config//mbsync-ak.conf inbox sent
```
The path variable is a neat workaround for avoiding writing full paths of applications - flock, timeout, `mbsync`. This script will synchronise email every minute, and if the network connection fails or if large files need to be downloaded, cron will wait (flock) for full synchronisation for 300 seconds (timeout) until the command is executed again. And that is about all needed to have synchronisation at every minute to be set up, and adding multiple accounts follows the same pattern.

## Reading and sending emails

To read synchronised emails, we will need emacs and `mu4e` installed by:
```bash
sudo apt-get install mu emacs
```
Now to run mu4e, we create an `init.el` file with the following contents:
```plaintext
(require 'mu4e')
(setq mu4e-maildir (expand-file-name "~/Private/Email/akels14"))
```
and run that with a simple command:
```bash
emacs --load init-simple.el --eval "(mu4e)"
```
where command after `--eval`, which can be put at the end of `init.el`, is executed after initial `init.el` is loaded. To see new emails, you have to index them, which is done with keybinding `U` (next time would be instantaneous). That updates by default db under `~/.mu`.

The last step to having a functional email client is configuring SMTP, responsible for sending emails. That can be done in the `init.el` by adding the following lines:
```plaintext
(require 'smtpmail)
(setq user-full-name  "Janis Erdmanis")
(setq mu4e-user-mail-address-list '("akels14@gmail.com" "XXXX@gmail.com"))
(setq user-mail-address "akels14@gmail.com")
(setq mu4e-reply-to-address "akels14@gmail.com")
```
One address list so mu4e know your mail addresses, one for mu4e to know which address to use for composing and the last address to be given to the recipient, so he is pushed to reply to a given address, which is a fairly good spot for your protected spam-free email address.

Then when I move into the navigation and find an email I want to reply to, I press `R`. With the configuration so far presented, I would be asked for my account details to send a mail with SMTP, which would be stored in plaintext in `~/.authinfo`. The contents of the file are as follows:

```plaintext
machine smtp.gmail.com login graphitewriter port 587 password xxxxxxx
machine smtp.gmail.com login akels14 port 587 password xxxxxxxx
```
where the corresponding line to your email address used for sending will is picked up automatically, one warning must be emphasised **do not store passwords in plaintext**. To avoid that move, I moved `.authinfo` file to the Private folder and symlink that with a command.

```bash
ln -s ~/Private/.config/authinfo ~/.authinfo
```
Similarly, one can move `~/.mu` to the Private folder for a complete
security.

So far, this is the most basic and helpful starting point for using emacs for mail reading and sending. One can pick up this setup and modify depending on his needs and put some snippets in `init.el`, which can be found in Google as I usually do. Multiple account management and desktop integration are the most obvious next steps, which I will continue to reveal.

## Multiple account management

To simply manage multiple accounts, one can start emacs with a different`init.el` files by adding/modifying the following lines:

```plaintext
(setq mu4e-maildir (expand-file-name "~/Private/Email/akels14"))
(setq mu4e-mu-home (expand-file-name "~/Private/.mu/akels14"))
```
where the last one is needed to have a separate index for each maildir, that should work flawlessly as long as you would be satisfied with changing windows for each account.

I wanted to use multiple accounts in a single window with a keyboard shortcut. Thus, I wrote/modified some scripts on the internet to have the behaviour I wanted. Firstly I put my accounts in variables (I still append this to `init.el`)
```plaintext
(setq mu4e-user-mail-address-list '("XXXXXX@gmail.com" "je11011@lu.lv" "akels14@gmail.com"))
(setq user-full-name  "Janis Erdmanis")

(defvar my-mu4e-account-alist
  `(("graphitewriter"
     (user-mail-address "XXXXX@gmail.com")
     (mu4e-reply-to-address "XXXXX@gmail.com")
     (mu4e-maildir ,(expand-file-name "~/Private/Email/graphitewriter"))
     (mu4e-mu-home ,(expand-file-name "~/Private/.mu/graphitewriter"))
     )
    ("je11011"
     (user-mail-address "je11011@lu.lv")
     (mu4e-reply-to-address "je11011@lu.lv")
     (mu4e-maildir ,(expand-file-name "~/Private/Email/je11011"))
     (mu4e-mu-home ,(expand-file-name "~/Private/.mu/je11011"))
     )
    ("akels14"
     (user-mail-address "akels14@gmail.com")
     (mu4e-reply-to-address "akels14@gmail.com")
     (mu4e-maildir ,(expand-file-name "~/Private/Email/akels14"))
     (mu4e-mu-home ,(expand-file-name "~/Private/.mu/akels14"))
     )))
```
Then to change the account I simply have to execute a following function with an account name:
```plaintext
(defun mu4e-set-account (account-name)
  (interactive)
  (mu4e~proc-kill)
  (let ((vars (cdr (assoc account-name my-mu4e-account-alist))))
    (if vars
        (mapc #'(lambda (var)
                  (set (car var) (cadr var)))
              vars)
      (error "No email account '%s' was found" account-name)))
  ;; For having fancy mode-line
  (setq mode-line-end-spaces
        (list (propertize " " 'display `(space :align-to (- right ,(length account-name))))
              account-name))
  ;; Also need to remove lock file which sometimes messes up
  (shell-command  (concat "rm -rf " mu4e-mu-home "/xapian/flintlock"))
  )
```
which can be executed at any point in emacs with `M-x + mu4e-set-account + Enter + akels14`.

By adding competition of account names and a keyboard shortcut `;` to change accounts, I was satisfied with my setup:

```plaintext
(setq my-accounts nil)
(defun printlist (mylist)
  "Filling my-accounts with alist keys from mylist"
  (push (car (car mylist)) my-accounts)
  (if (not (eq (length mylist) 1)) (printlist (cdr mylist))))
(printlist my-mu4e-account-alist)

(defun mu4e-set-account-interactive ()
  "Changes the email account"
  (interactive)
  ;(mu4e-set-account (read-string "Enter the account name:"))
  (setq mu4e-account (ido-completing-read "Enter the account name: " my-accounts))
  (mu4e-set-account mu4e-account)
  )

(add-hook 'mu4e-main-mode-hook
          (lambda () (local-set-key (kbd ";") #'mu4e-set-account-interactive)))
```
This code part needs some reviewing, which would make it shorter, as I use global variables and make functions where I do not need them. Nevertheless, it works flawlessly.

## Desktop integration

The last step was to make desktop integration - to see instantaneously that a new email had arrived. I wanted an icon and badge showing the number of unread emails in Ubuntu. My approach uses DBus for that purpose, with which I make a daemon process and its ability to change `*.desktop` icons in the panel. Thus first, we need to make a `.desktop` icon for the emacs command.

The following init script is needed to let the X-window system know that a separate application is being started:
```plaintext
APPNAME=mu4e
emacs --name $APPNAME -q --load  init-simple.el &
sleep 1 && xprop -name $APPNAME -f WM_CLASS 8s -set WM_CLASS "$APPNAME, $APPNAME"
```
In this script, I store this in `~/bin/mu4e,` for which I add execution permissions with `chmod +x \~/bin/mu4e`. A .desktop file is being stored in `\~/.local/share/applications/mu4e.desktop` which has a following contents:
```plaintext
#!/usr/bin/env xdg-open
[Desktop Entry]
Version=1.0
Type=Application
Terminal=false
Exec=mu4e
Name=Mu4e
Comment=Simple email client based on emacs
Icon=envelope
StartupWMClass=mu4e
```
where icon is stored in `~/.local/share/icons/envelope.png`. Then this application can be found in Unity Dash as `mu4e`.

The next step is adding a badge for this application in the taskbar to show the email count. That I do with the following script:
```python
#!/usr/bin/python

ccommand = "ls ~/Private/Email/graphitewriter/inbox/new | wc -l"

from gi.repository import Unity, Gio, GObject, Dbusmenu

# The mu4e must be put into ~/.local/share/applicactions
launcher = Unity.LauncherEntry.get_for_desktop_id("mu4e.desktop")

launcher.set_property("count", 0)
launcher.set_property("count_visible", True)

### Defining the loop in right way

import commands
def update_mail_count():
    count = int(commands.getstatusoutput(ccommand)[1])
    launcher.set_property("count", count)
    launcher.set_property("count_visible", True)

    if count>0:
        launcher.set_property("urgent", True)
    else:
        launcher.set_property("urgent",False)

    return True

loop = GObject.MainLoop()
GObject.timeout_add_seconds(1, update_mail_count)
loop.run()
```
which is stored in `~/bin/mu4e-counter` with `chmod +x`. When this script is started, it will add a badge icon showing several files in `~/Private/Email/graphitewriter/inbox/new` where unread emails are stored and will update for changes each second. For convenience, I start this script on login by adding it in "Startup Applications".

## Fancy features and A list of USEFUL keybindings

This barebones version is good but needs some additional snippets for
better use

```plaintext
(require 'mu4e-contrib)

;; For processing html emails
(setq mu4e-html2text-command 'mu4e-shr2text)
(setq shr-color-visible-luminance-min 80)

;; show images
(setq mu4e-show-images t)

;; Allows to view email in browser
(add-to-list 'mu4e-view-actions
  '("ViewInBrowser" . mu4e-action-view-in-browser) t)

;; No need to showing email twice
(setq mu4e-headers-skip-duplicates t)  
```
Useful keybindings in the mu4e are as follows:

```plaintext
  ----------------- ----------------------------------------------
  a + V             To view email in the browser
  C                 To compose a message
  R                 To reply
  F                 To forward
  E                 To edit a draft message
  Ctrl-c + Ctrl-c   To send a message
  A + w             To open an attachment with some application
  A + e             To open an attachment with emacs
  e                 To save an attachment
  o                 To open an attachment with a default application
  ;                 To change an account
  q                 To quit, go back
  C-g               To stop whatever
  d + x             To delete a message
  P                 Toggle between thread view
  H                 for help
  W                 Includes related messages in view
  w                 On a link, copies it to the clipboard
  ----------------- ----------------------------------------------
```
## Troubleshooting

Sometimes mu4e corrupts its indexed database. Then reindexing is being
needed, which can be accomplished by removing `~/.mu` folder. 

