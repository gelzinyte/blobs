using Test, blobs

greet()

"""
Unrols 3D array as defined for cube files
https://h5cube-spec.readthedocs.io/en/latest/cubeformat.html
http://paulbourke.net/dataformats/cube/
"""
function flatten_like_cube(density; dens_shape=(40, 40, 40))
	flattened=zeros(0)	
	for ix in 1:dens_shape[1]
		for iy in 1:dens_shape[2]
			for iz in 1:dens_shape[3]
				val = density[ix, iy, iz]
				append!(flattened, val)
			end
		end
	end
	return flattened
end

# get density from file 
density_file="orca_density.3d"
density = read_orca_3D(density_file)

# read just unflattened values
string_values = readlines(density_file)[5:end-1]
original_flat_array = parse.(Float64, string_values)

# flatten the constructed density and check it matches how 
# it's written to file
flattened = flatten_like_cube(density)
@test flattened == original_flat_array


# check can read in cube file 
density = read_orca_cube("orca_density.cube")
