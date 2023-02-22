+++
title = "TransformVariables.jl gets pretty printing"
date = "2023-02-22"
tags = ["julia", "package", "TransformVariables.jl", ]
rss = "."
+++

A recent update (version 0.8.2) to [TransformVariables.jl](https://github.com/tpapp/TransformVariables.jl) adds pretty printing of (nested) transformations. Eg what used to be

```julia
julia> using StaticArrays, TransformVariables

julia> t = as((a = asℝ₊, b = as(Array, asℝ₋, 3, 3),
               c = corr_cholesky_factor(13),
               d = as((asℝ, corr_cholesky_factor(SMatrix{3,3}),
                       UnitSimplex(3), UnitVector(4)))))
TransformVariables.TransformTuple{NamedTuple{(:a, :b, :c, :d), Tuple{TransformVariables.ShiftedExp{true, Int64}, TransformVariables.ArrayTransformation{TransformVariables.ShiftedExp{false, Int64}, 2}, CorrCholeskyFactor, TransformVariables.TransformTuple{Tuple{TransformVariables.Identity, TransformVariables.StaticCorrCholeskyFactor{3, 3}, UnitSimplex, UnitVector}}}}}((a = asℝ₊, b = TransformVariables.ArrayTransformation{TransformVariables.ShiftedExp{false, Int64}, 2}(asℝ₋, (3, 3)), c = CorrCholeskyFactor(13), d = TransformVariables.TransformTuple{Tuple{TransformVariables.Identity, TransformVariables.StaticCorrCholeskyFactor{3, 3}, UnitSimplex, UnitVector}}((asℝ, TransformVariables.StaticCorrCholeskyFactor{3, 3}(), UnitSimplex(3), UnitVector(4)), 9)), 97)
```

which is a single line of 700+ characters (which your browser mercifully hides behind a scrollbar), we now have

```julia
julia> using StaticArrays, TransformVariables
[ Info: Precompiling TransformVariables [84d833dd-6860-57f9-a1a7-6da5db126cff]

julia> t = as((a = asℝ₊, b = as(Array, asℝ₋, 3, 3),
                      c = corr_cholesky_factor(13),
                      d = as((asℝ, corr_cholesky_factor(SMatrix{3,3}),
                              UnitSimplex(3), UnitVector(4)))))
[1:97] NamedTuple of transformations
  [1:1] :a → asℝ₊
  [2:10] :b → 3×3×asℝ₋ (dimension 1)
  [11:88] :c → 13×13 correlation cholesky factor
  [89:97] :d → Tuple of transformations
    [98:98] 1 → asℝ
    [108:110] 2 → SMatrix{3,3} correlation cholesky factor
    [120:121] 3 → 3 element unit simplex transformation
    [131:133] 4 → 4 element unit vector transformation
```

which tells you which indices map to which part of the result.
