+++
date = "2017-2-13"
rss = "This web page is hosted with Github Pages from my GitHub repository for free. The tradeoff is that you can serve only static pages and content. This is where I and many others develop creative solutions since no one likes to write plain HTML. I use .org files for my journal and other note-taking things; thus, taking inspiration from others, I compile my org sources to static HTML with a single Elisp script."
tags = ["emacs", "invisible"]
+++

# How I used to make this page

This web page is hosted with Github Pages from my [GitHub repository](https://github.com/akels/akels.github.io) for free. The tradeoff is that you can serve only static pages and content. This is where I and many others develop creative solutions since no one likes to write plain HTML. I use .org files for my journal and other note-taking things; thus, taking inspiration from others, I compile my [org sources](https://github.com/akels/akels.github.io/tree/master/page-sources/org-page-sources) to static HTML with [a single Elisp script](https://gist.github.com/JanisErdmanis/94da86eecfeeef7b9e38f2c0a7abf367).

## Interface

Before diving into configuration details, I will show what I can do. I can write LATEX formulas in a `.org` file, add images with special HTML formatting, videos, code, links to the outside world and links to org, which are changed automatically to their counterparts on HTML export. You can see all these features with the following .org source text file.

```
#+TITLE: Tests
#+DATE: 2017-2-16
* Header
- list item 1
- list item 2
- *bold* /italic/ =verbatim= ~code~ +strike tghrough+ 
** SubHeader
$\LaTeX$ [[file:ideas.org][Ideas]] 
\[ e^{i\pi} = -1 \]
#+ATTR_HTML: :style float:left; :height 200
[[file:../contents/profile.png]]
#+HTML: <video height="200" controls>
#+HTML: <source src="../contents/optimal-pulse.mp4#t=2" type="video/mp4">
#+HTML: </video>
```

When I finish the `.org` file writing, I compile it with a single command in the `page-sources` directory `emacs --script publish.el --eval "(blog-publish)"~ or from my emacs ~M-x blog-publish` where for output see [test page](https://janiserdmanis.org/blog/tests). Then I test if a page looks fine locally and do the usual push to the GitHub repository from where Github Pages take sources for hosting. Features like your domain name are also possible, as I can see from my page. 

## Behind the SCENES

Many tools are available for generating static web pages from simpler source files like markdown, reStructuredText, and org files. For example, you can use `pandoc` for almost any such conversation to HTML and, even more, Jekyl for generating static web pages from markdown files or `jinja2` for making html template and filling it with content ([see as an example](http://flask.pocoo.org/snippets/19/)). I picked up the `org-publish` feature from `org-mode` mainly because I use emacs daily for my note-taking but also because it is written in the mature programming language `elisp`.

When I started considering emacs as a tool for my programming, I was exposed to `elisp,` which initially looked like one of the dirtiest languages I had worked with. But after learning some essential bits of it, I get to like it, and the ugliest part of it, sexps, becomes one of the most productive parts of it. For example, code in `elisp` will have much fewer local variables for the same task, and you save time thinking of the best programming paradigm for your problem. Elisp and many other languages like them are also becoming increasingly more popular with the functional programming paradigm shift, where one benefit I see is code becoming more modular. Thus it's valuable to understand why and when it is better. 

[As seen here](https://gist.github.com/JanisErdmanis/94da86eecfeeef7b9e38f2c0a7abf367), all my configuration is written in emacs lisp, so prepare your eyes well while I break it into parts. As an example, we might consider the following project tree:

```
.
├── input
│   └── example.org
├── output
│   └── example.html
├── publish.el
```

`input` is where all `.org` files are stored, `output` for converted `.html` files, and `publish.el` is the `elisp` compilation script. The following example of `publish.el` illustrate the basic building block for converting all `.org` files to `.html` counterparts:

```
(require 'ox)
(setq make-backup-files nil) ;; No need for backup files

(defvar my-base-directory (concat (file-name-directory load-file-name) "input")
  "Org sources are taken from folder input relative to this file")

(defvar my-publishing-directory (concat (file-name-directory load-file-name) "output")
  "Converted org files are in folder output relative to this file")

;; Right place for a personalized template

(setq org-publish-project-alist
      `(
        ("publish"
         :base-directory ,my-base-directory ;; Path to your org files.
         :base-extension "org"
         :publishing-directory ,my-publishing-directory 
         ;;:publishing-function pd-html-publish-to-html 
         :publishing-function org-html-publish-to-html
         :html-extension "html"
         )
        )
      )

(defun blog-publish ()
    (interactive)
    (org-publish "publish" t)
    )
```

The first line `(require 'ox)` loads the module from `org-mode,` which has the publishing feature `org-publish`. Configuration of the publishing project happens under the assignment of the global variable `org-publish-project-alist,` which is used when the publishing function is called inline `(org-publish "publish" t)`. When the code above is executed with the command `emacs --script publish.el --eval "(blog-publish)"~ it will produce ~.html` files in the `output` directory with a functional but not very nice-looking default template.

Many configure default templates to suit their needs. I wanted to go the other way, producing templates from my chosen [perfect web page](http://www.juliadiff.org/). Fortunately, I found an answer on *emacs stack exchange on how to do it with `org-publish`. In `org-publish-project-alist,` I can bind my publishing function `pd-html-publish-to-html` which defines how content and metadata are written to an HTML file:

```
(defun pd-html-template (contents info)
  (concat
   "<!DOCTYPE html>\n"
   (format "<html lang=\"%s\">\n" (plist-get info :language))
   "<head>\n"
   (format "<meta charset=\"%s\">\n"
           (coding-system-get org-html-coding-system 'mime-charset))
   (format "<title>%s</title>\n"
           (org-export-data (or (plist-get info :title) "") info))
   (format "<meta name=\"author\" content=\"%s\">\n"
           (org-export-data (plist-get info :author) info))
   "<link href=\"/css/style.css\" rel=\"stylesheet\" style=\"text/css\" />\n"
   "</head>\n"
   "<body>\n"
   (format "<h1 class=\"title\">%s</h1>\n"
           (org-export-data (or (plist-get info :title) "") info))
   contents
   "</body>\n"
   "</html>\n"))


(org-export-define-derived-backend 'pd-html 'html
  :translate-alist '((template . pd-html-template))
  )

(defun pd-html-publish-to-html (plist filename pub-dir)
(org-publish-org-to 'pd-html filename ".html" plist pub-dir))
```

This function is passed to `org-publish-project-alist` variable with `publishing-function pd-html-publish-to-html`(commented line previously).

To conclude, I am delighted with my setup. It keeps me confident that I can use this setup for a long time since I don't have to compile the code, the `elisp` is not changing much, and I use only a single dependency which I can load locally without installing if significant changes happen.

## References

- https://ogbe.net/blog/blogging_with_org.html 
-  http://blog.binchen.org/posts/how-to-publish-static-html-blog-in-emacs-as-a-programmer.html 
- http://www.john2x.com/blog/blogging-with-orgmode.html 
