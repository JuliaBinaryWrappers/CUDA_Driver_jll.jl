using Base.BinaryPlatforms

function _is_tegra()
    if isfile("/etc/nv_tegra_release")
        return true
    end
    if isfile("/proc/device-tree/compatible") &&
        contains(read("/proc/device-tree/compatible", String), "tegra")
        return true
    end
    return false
end

# the NVIDIA Linux for Tegra release, e.g. v"35.6.5", or `nothing`
function _l4t_version()
    try
        isfile("/etc/nv_tegra_release") || return nothing
        release = read("/etc/nv_tegra_release", String)
        m = match(r"^# R(\d+) \(release\), REVISION: ([0-9]+(?:\.[0-9]+)*)", release)
        m === nothing && return nothing
        return tryparse(VersionNumber, string(m.captures[1], ".", m.captures[2]))
    catch
        return nothing
    end
end

# The value of the `tegra` platform tag for the current host: "none" on non-Tegra
# systems, or the L4T major version (the kernel-mode driver generation, e.g. "35"
# for JetPack 5) bucketed into the generations we distinguish: "32" (JetPack 4 and
# earlier: no compat driver exists), "35" (JetPack 5: compat drivers up to CUDA
# 12.2), "36" (JetPack 6: up to CUDA 12.9), and "38" (JetPack 7 and later, and
# unidentifiable L4T versions: no compat driver applies). Only "35" and "36" have
# an artifact; the others match nothing, which is the point: a Tegra host must
# never receive the SBSA compat driver. This function never throws.
function _tegra_artifact_generation()
    tegra = try
        _is_tegra()
    catch
        false
    end
    tegra || return "none"

    try
        l4t = _l4t_version()
        l4t === nothing && return "38"
        if l4t.major < 35
            return "32"
        elseif l4t.major == 35
            return "35"
        elseif 36 <= l4t.major < 38
            return "36"
        else
            return "38"
        end
    catch
        return "38"
    end
end

function augment_platform!(platform::Platform)
    haskey(platform, "tegra") && return platform
    platform["tegra"] = _tegra_artifact_generation()
    return platform
end