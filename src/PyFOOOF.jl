module PyFOOOF

using PyCall

#####
##### init
#####

const fooof = PyNULL()

function __init__()
    # all of this is __init__() so that it plays nice with precompilation
    # see https://github.com/JuliaPy/PyCall.jl/#using-pycall-from-julia-modules
    copy!(fooof, pyimport("fooof"))
    # don't eval into the module while precompiling; this breaks precompilation
    # of downstream modules
    if ccall(:jl_generating_output, Cint, ()) == 0
        # delegate everything else to fooof
        for pn in propertynames(fooof)
            isdefined(@__MODULE__, pn) && continue
            prop = getproperty(fooof, pn)
            @eval $pn = $prop
        end
    end
    return nothing
end

end #module
