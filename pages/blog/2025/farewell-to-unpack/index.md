+++
title = "My farewell to `@unpack`"
date = "2025-01-28"
tags = ["julia", "emacs", "packages"]
rss = "."
+++

First, a bit of Julia history. When [Parameters.jl](https://github.com/mauro3/Parameters.jl/) introduced the `@unpack` macro in 2015, it scratched an imporant itch for Julia users at the time, especially those coming from (Common) Lisp who were used to [`cl:with-slots`](https://novaspec.org/cl/f_with-slots) and similar macros. Given any object with properties, say `foo` and `bar`, one could bring them into scope with

```julia
@unpack foo, bar = x
```
instead of a clumsy
```julia
foo = x.foo
bar = x.bar
```

The functionality was so useful that it was later (around 2019) factored out into its own tiny package, [UnPack.jl](https://github.com/mauro3/UnPack.jl). 

Of course the Julia developers recognized how great this feature was, and Julia 1.7 (in 2021) brought us the property destructuring syntax
```julia
(; foo, bar) = x
```

But since 1.7 was not an LTS, many packages did not require that version and kept relying on `@unpack`. In 2023, [SimpleUnPack.jl](https://github.com/devmotion/SimpleUnPack.jl "SimpleUnPack.jl") was written as a drop-in replacement for the most common use case while being easier on the compiler.

Since Julia 1.10 is an LTS,  I am gradually removing `@unpack` from my packages whenever I happen to refactor them. This is, strictly speaking, not necessary (it would just work forever), but I like to simplify code when I happen to refactor it for some other reason. I am taking this opportunity to reflect on how useful it was.

There are quite a few lessons there about software development in general, and specifically for Julia:

1. Macros are amazingly powerful. No wonder that Lisp users consider them a killer feature, they can extend the language with very useful syntax at essentially zero runtime and negligible compile time cost. It was a great decision for Julia to include them.

2. The best way to extend a language with new features is to first implement them as a package. This allows experimentation and quick turnaround, leading to a polished end product that the language can include.

3. Once your Julia code works, it will keep working for a long time, potentially forever in 1.x land.  UnPack.jl [still has 200 dependents](https://juliahub.com/ui/Packages/General/UnPack). This allows developers to make upgrades at their own pace, prioritizing more urgent issues.

### Bonus feature

This little Emacs snippet does the conversion from `@unpack ...` to `(; ...)`, also working on multiline code etc, either on standalone files or whole packages opened in [`dired`](https://www.gnu.org/software/emacs/manual/html_node/emacs/Dired.html).

```emacs-lis
(defun my-julia-remove-unpack ()
  "Go from `@unpack' to `(; ...)` destructuring syntax. Works in dired mode and buffer."
  (interactive)
  (let* ((from (rx "@unpack"
                   (one-or-more space)
                   (or (seq "(" (group-n 1 (one-or-more (not "@"))) ")")
                       (group-n 1 (one-or-more (not (or ?@ ?\n))))
                       )
                   (one-or-more space)
                   "="))
         (to "(; \\1) ="))
    (cond
     ((eq major-mode 'julia-mode) (query-replace-regexp from to))
     ((eq major-mode 'dired-mode) (dired-do-query-replace-regexp from to))
     (t (message "Don't know what to do with mode %s" major-mode)))))
```

### P.S.

(I am reviving my blog after a long break.)
