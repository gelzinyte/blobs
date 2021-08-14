
function greet()
    println("Hello you guys")
end

"""
Goes from a flattened density read from .cube or orca's .3D to a 
3D array. 
"""
function unflatten(flat_array; shape=(40, 40, 40))
	return permutedims(reshape(flat_array, (40, 40, 40)), [3, 2, 1])
end

"""
Reads in orca's .3d density files
"""
function read_orca_3D(filename)

    file = readlines(filename)[5:end-1]
    flat_array = parse.(Float64, file)
    return unflatten(original_flat_array)
end    


"""
Reads cube files produced by ORCA
https://h5cube-spec.readthedocs.io/en/latest/cubeformat.html
http://paulbourke.net/dataformats/cube/
"""
function read_orca_cube(filename)

    file = readlines(filename)

    # two lines of comments
    # third line: number of atoms (int) and origin (3 x float)
    # read in number of atoms and do nothing with the origin (for now?)
    n_atoms = parse(Int64, split(file[3])[1])

    # fourth-sixth lines - number of voxels along each axis and the axis. 
    # Take only number of voxels (for now?)    
    dens_shape = Tuple([parse(Int64, split(file[i])[1]) for i in 4:6])

    # density data starts after `n_atoms` lines of geometry data
    flat_values=zeros(0)	
    for line in file[7+n_atoms:end]:
        numbers = parse.(Float64, split(line))
        append!(flat_values, numbers)
    end

    return unflatten(flat_values, shape=dens_shape)


end


