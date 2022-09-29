+++
title = "Tables output with Literate.jl"
date = "2022-09-28"
tags = ["julia", "markdown", "announcement", ]
rss = "."
+++

I recently wrote a very lightweight package called [MarkdownTables.jl](https://github.com/tpapp/MarkdownTables.jl) that makes it easy to embed tables using Literate.jl. It handles anything that works with [Tables.jl](https://tables.juliadata.org):

````julia
using MarkdownTables
my_table = [(animal = "cat", legs = 4),
            (animal = "catfish", legs = 0),
            (animal = "canary", legs = 2)]
my_table |> markdown_table()
````

| animal  | legs |
|---------|------|
|     cat |    4 |
| catfish |    0 |
|  canary |    2 |


Under the hood, it just wraps some basic Markdown with [DisplayAs.jl](https://github.com/tkf/DisplayAs.jl):

````julia
my_table |> markdown_table(String) |> print
````

````
| animal  | legs |
|---------|------|
|     cat |    4 |
| catfish |    0 |
|  canary |    2 |

````

The default output is pretty basic — while the function has some options for formatting, it is recommended that you use CSS instead.

I expect that this pretty much rounds out the tooling I need for blogging with [Franklin.jl](https://franklinjl.org/). Feedback and PRs are of course welcome, but I intend to keep this package very basic.

~~~
<div class="source_footer">
~~~
This page was generated using [Literate.jl](https://github.com/fredrikekre/Literate.jl).\
Download [the source, project, and manifest](markdown-tables_source.tar).
~~~
</div>
~~~
