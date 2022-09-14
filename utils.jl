using ArgCheck
import Franklin

function hfun_bar(vname)
  val = Meta.parse(vname[1])
  return round(sqrt(val), digits=2)
end

function hfun_m1fill(vname)
  var = vname[1]
  return pagevar("index", var)
end

function lx_baz(com, _)
  # keep this first line
  brace_content = Franklin.content(com.braces[1]) # input string
  # do whatever you want here
  return uppercase(brace_content)
end

"""
All the paths within `folders` that are files ending in `.md`.
"""
function list_pages_in_folders(folders)
    pages = String[]
    cd(Franklin.PATHS[:folder]) do
        for folder in folders
            @argcheck !startswith(folder, "/") "use relative paths"
            foreach(((r, _, fs),) ->  append!(pages, joinpath.(r, fs)), walkdir(folder))
        end
    end
    map(x -> replace(x, r"\.md$" => ""), filter!(x -> endswith(x, ".md"), pages))
end

"""
Page information as a named tuple.
"""
function get_page_information(page)
    title = something(pagevar(page, "markdown_title"), pagevar(page, "title"))
    @argcheck title ≢ nothing "no title found on page $(page)"
    date = pagevar(page, "date")
    @argcheck date ≢ nothing "no date found on page $(page)"
    url = get_url(page)
    tags = something(pagevar(page, "tags"), [""])
    (; title, date = Date(date), url, tags)
end

"""
Return HTML code a list of pages within a given folder.
"""
function hfun_pages_in_folders_by_date(folders)
    sorted = sort!(map(get_page_information, list_pages_in_folders(folders)),
                   by = x -> x.date, rev = true)
    io = IOBuffer()
    println(io, "<ul>")
    for item in sorted
            print(io, """
                    <li class="post-item">
                      <a href=\"$(item.url)\"><span class="post-title">$(item.title)</span></a>
                      &nbsp;&mdash;&nbsp<span class="post-day">$(Dates.format(item.date, "Y u d"))</span>
                    </li>
                """)
    end
    println(io, "</ul>")
    String(take!(io))
end

function format_tag_link(tag)
    "<a href=\"/tag/$(Franklin.refstring(tag))\">$(tag)</a>"
end

"""
Generate a tag cloud as a set of links.

NOTE: currently, descending by frequency. Consider weighted by age.
"""
function hfun_tag_cloud()
    pages = list_pages_in_folders(["pages/blog"])
    tag_count = Dict{String,Int}()
    for page in pages
        for tag in get_page_information(page).tags
            tag_count[tag] = get(tag_count, tag, 0) + 1
        end
    end
    sorted_tags = first.(sort(collect(tag_count); rev = true, by = last))
    io = IOBuffer()
    for tag in sorted_tags
        println(io, format_tag_link(tag))
    end
    String(take!(io))
end

"""
List tags as links, should be wrapped in a relevant `<div>`.
"""
function hfun_list_page_tags()
    tags = locvar("tags")
    tags ≡ nothing && return ""
    io = IOBuffer()
    for tag in tags
        @show tag
        println(io, format_tag_link(tag))
    end
    return String(take!(io))
end
