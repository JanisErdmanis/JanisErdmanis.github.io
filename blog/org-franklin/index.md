+++
date = "2023-08-11"
rss = "Like many, I serve my website with GitHub Pages, greatly reducing the burden. I don't need to maintain a server, pay a subscription fee or update certificates every six months, and I can focus on the content. However, now and then, technologies change, and I started to look at my website as a burden to keep it updated and publish new blog posts."
tags = ["julia"]

+++

# Transitioning from Org to Franklin

Like many, I serve my website with GitHub Pages, greatly reducing the burden. I don't need to maintain a server, pay a subscription fee or update certificates every six months, and I can focus on the content. However, now and then, technologies change, and I started to look at my website as a burden to keep it updated and publish new blog posts.

I used to use `org-mode` with my emacs but transitioned to markdown as time passed. Although Markdown is similar to org-mode, and I wish everyone would adopt ASCIIDOC, everyone has invested substantial resources in it, and there is just a better ecosystem in it. For example, I am now writing this in Markdown editor and editing my grammar and spelling with Grammarly in one place. It is immensely satisfying compared to copy-paste stuff in the Grammarly WEB interface, as I used to do. And trust me; you don't want to read me without AI in between!

So this website was built using the emacs `org-publish` package, and I did actually make a blog post about how I did, which I can happily include:

{{blog_item "blog/org-publish.md"}}

Pretty cool, right? Stay with me, and I will show you some more.

The transition took me the last 12 days. About half of the time did take to update the content. In particular, as I have moved my focus to making software, I wanted that to reflect on my website. Also, my CV was forgotten for years since I got my job as a PhD candidate at TU Delft, and it was such a spectacular hack where to get a look; I wrote it all in `#+HTML`. As I converted my blog post `.org` files to `.md` after opening them in my markdown editor, I realised it was so bad I no longer could bear anyone looking at them. Thus for everyone, I did click-click-click with Grammarly until something like English came out ;D.

The other half, I spent writing a new template and making a project section on my homepage. I decided to drop the existing template and style of the website, which was not bad but did need to see some CSS love:

![](old-page.png)

In particular, I liked having titles above page navigation and the colour balance I settled up. But other things just made me run away.

I started with Franklin's basic template as I knew it could be made rather beautiful from experience with [peacefounder.org](peacefounder.org) and adopted some good ideas I could find on the internet. In particular, I got inspired by card design:

![](cards.png)

which was fluid and offered a remedy for avoiding spending hours/days condensing my previous work experience into two sentences if I had written that on the side. A problem, though, was that it did not look as good with light images, and I spent the first two days making it look as it is now.

In modifying the template, I got a little traction on how to get CSS layout work for me. Although most of the time, it still does not, and I resort to hammering with everything I can find on StackExchange there. I wish I could have done this in QML instead, but I see the appeal of CSS to support drastically different screen sizes with the same HTML. 

The second part was to modify the Franklin basic template:

![](franklin-basic.png) 

Although it looks pretty discouraging from the beginning, the CSS file from Franklin is quite structured. The important part is that Franklin already comes in with `highlight.js` and `katex.js` for mathematical formulas and styles them decently. Also, this template comes with adapting layout depending on the screen size; thus, I could immediately look in on how it is done, modify some values here and there and take inspiration from the internet. I get the look I want, and you are looking at. 

A pretty cool thing with Franklin is that I can generate dynamic content with Julia, which I know quite well. For instance, I can now list all my blog items in sorted order and discard those which are tagged as invisible with a simple method:

```julia
function hfun_blog()
   
    buffer = IOBuffer()

    for info in get_blog_items()
        if !("invisible" in info.tags)
            item_html = item2html(info)
            println(buffer, item_html)
        end

  	return String(take!(buffer))
end
```

and insert that in the markdown easily with the following:

```html
{{blog}}
```

which is pretty neat. It is also possible to have arguments to this function in which I use a particular blog item by giving a filename or listing multiple posts with a specific tag which is terrific.

To conclude, updating this website has again become fun. Perhaps it is the future I could explore by adding a taglist or finding a nonobstructive place for socials, but for now, I am happy with what I made that burdened me in thought in the last few years. The feeling of having a roadblock has started to settle in me. I guess we will see some new blog posts here in the future :)

## References

- [A card design template on CodePen](https://codepen.io/hexagoncircle/pen/XWbWKwL)
