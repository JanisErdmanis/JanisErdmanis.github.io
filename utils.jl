using Infiltrator
using Franklin
using Dates

struct PostInfo
    title::String
    description::String
    date::Date
    link::String
    word_count::Int
    tags::Vector{String}
end


function hfun_bar(vname)
  val = Meta.parse(vname[1])
  return round(sqrt(val), digits=2)
end

function hfun_m1fill(vname)
  var = vname[1]
  return pagevar("index", var)
end


# 
function item2html(info::PostInfo)
    
    (; title, link, description, date, word_count) = info

    date_str = Dates.format(date, "u d, yyyy")

    entry = """<div class=post-display><div class=post-meta>$date_str | $word_count Words</div><div class=post-title><a href=$link>$title</a></div><div class=post-description>$description</div></div>"""

    return entry
end


function count_words(file)
    return length(split(join(readlines(file), "\n"), " "))
end

function blog_link(file)
    @assert file[end-2:end] == ".md" "$file is not a markdown file"

    if basename(file) == "index.md"
        return dirname(file)
    else
        return file[1:end-3] # removing md extension
    end
end


@delay function get_item_metadata(path)

    title = Franklin.pagevar(path, "title")
    description = Franklin.pagevar(path, "rss_description")
    date = Date(Franklin.pagevar(path, "date"), DateFormat("yyyy-m-d"))
    link = blog_link("/" * path)
    word_count = count_words(path)
    tags = Franklin.pagevar(path, "tags")

    return PostInfo(title, description, date, link, word_count, tags)
end


function get_blog_items()
    
    blog_items = String[]
    for i in readdir("blog")
        if isfile(joinpath("blog", i))
            push!(blog_items, i)
        elseif isfile(joinpath("blog", i, "index.md"))
            push!(blog_items, joinpath(i, "index.md"))
        end
    end

    metadata = PostInfo[]

    for i in blog_items
        path = joinpath("blog", i)
        try
            data = get_item_metadata(path)
            push!(metadata, data)
        catch e
            @warn "A file with $path is discarded due to errors. $e"
        end

    end

    sort!(metadata, lt = (x, y) -> x.date > y.date)
    
    return metadata
end


function hfun_insert_info()

    path = locvar("fd_rpath")
    
    word_count = count_words(path)
    date = Date(locvar("date"), DateFormat("yyyy-m-d"))

    date_str = Dates.format(date, "u d, yyyy")    

    return "<div class=\"post-meta\">$date_str | $word_count Words</div>"
end

function hfun_blog_item(vname)
    try
        path = vname[1]
        metadata = get_item_metadata(path)
        return item2html(metadata)
    catch e
        return string(e)
    end
end


@delay function hfun_blog()

    try

        buffer = IOBuffer()

        for info in get_blog_items()
            if !("invisible" in info.tags)
                item_html = item2html(info)
                println(buffer, item_html)
            end
        end

        return String(take!(buffer))

    catch e

        return string(e)
    end
end


@delay function hfun_blog_tagged(vname)

    tag = vname[1]

    try

        buffer = IOBuffer()    

        for info in get_blog_items()
            if tag in info.tags
                item_html = item2html(info)
                println(buffer, item_html)
            end
        end

        return String(take!(buffer))
    catch e
        return string(e)

    end
end


@delay function hfun_blog_all()

    try

        buffer = IOBuffer()

        for info in get_blog_items()
            item_html = item2html(info)
            println(buffer, item_html)
        end

        return String(take!(buffer))

    catch e
        return string(e)
    end
end



function hfun_include(vname)

    fname = vname[1]
    try
        return join(readlines(joinpath(@__DIR__, fname)), "\n")
    catch e
        return string(e)
    end
end


function lx_baz(com, _)
  # keep this first line
  brace_content = Franklin.content(com.braces[1]) # input string
  # do whatever you want here
  return uppercase(brace_content)
end
