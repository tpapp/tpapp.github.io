+++
title = "Reproducible examples in blog posts"
date = "2022-09-14"
tags = ["julia", "franklin", ]
rss = "."
+++

When migrating this blog recently from Hugo to Franklin.jl, the main difficulty I faced was reproducing old examples (so effectively I didn't rerun anything, and just moved the old generated HTML pages). I have been bothered by this for a long time, so I wrote a quick hack which I packaged up in [ReproducibleLiteratePage.jl](https://github.com/tpapp/ReproducibleLiteratePage.jl).

This page was processed using that package. Here is how it works:

1. take a Julia code file marked up with [Literate.jl](https://fredrikekre.github.io/Literate.jl/),

2. add a `Project.toml` and a `Manifest.toml` (eg activate the directory as a project and add packages)

3. produce a markdown file using `ReproducibleLiteratePage.compile_directory()`.

Here is some code:

````julia
using UnPack # the lightest package I could think of
struct Foo
    a
    b
end
@unpack a, b = Foo(1, 2)
a, b
````

````
(1, 2)
````

The Julia source (again, marked up with Literate.jl), `Project.toml`, and `Manifest.toml`
should be available as a `tar` archive at the bottom of the page.

~~~
<div class="source_footer">
~~~
This page was generated using [Literate.jl](https://github.com/fredrikekre/Literate.jl).\
Download [the source, project, and manifest](09-14-reproducible-examples_source.tar).
~~~
</div>
~~~
