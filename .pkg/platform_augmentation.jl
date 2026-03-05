# Precompile the process-spawning and version-parsing hot path
precompile(Tuple{typeof(Base.cmd_gen), Tuple{Tuple{Base.Cmd}, Tuple{String}, Tuple{Bool}, Tuple{Array{String, 1}}}})
precompile(Tuple{typeof(Base.arg_gen), Bool})
precompile(Tuple{typeof(Base.read), Base.Cmd, Type{String}})
precompile(Tuple{typeof(Base.readlines), Base.IOBuffer})
precompile(Tuple{typeof(Base.push!), Array{Base.VersionNumber, 1}, Base.VersionNumber})
precompile(Tuple{typeof(Base.Iterators.enumerate), Array{Base.VersionNumber, 1}})
precompile(Tuple{typeof(Base.iterate), Base.Iterators.Enumerate{Array{Base.VersionNumber, 1}}})
precompile(Tuple{typeof(Base.iterate), Base.Iterators.Enumerate{Array{Base.VersionNumber, 1}}, Tuple{Int64, Int64}})
precompile(Tuple{typeof(Base.indexed_iterate), Tuple{Int64, Base.VersionNumber}, Int64})
precompile(Tuple{typeof(Base.indexed_iterate), Tuple{Int64, Base.VersionNumber}, Int64, Int64})

augment_platform! = identity
