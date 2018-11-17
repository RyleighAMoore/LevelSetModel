"""
A module for simulating perculation
"""
module Percolation

using Formatting
using SymPy
using Images
using FileIO
using Distributed
using Plots

export getz, getzv2, getzp3, normalize_surface, label_lattice, check_percolates, meshgrid, getSurface, FindAreaFraction, process_surface,
graphPc, populateAreaFractionArrays

"""
    getz(Coef, Cx, Cy, xbunch, ybunch)

Computes z using nested list comprehension

"""
function getz(Coef, Off, Cx, Cy, xbunch, ybunch)
    return sum([Coef[i,j]*cos.(2*pi*(Cx[i,j]*xbunch .+ Cy[i,j]*ybunch .+ Off[i,j]))
                  for i = 1:size(Cx,1),
                      j = 1:size(Cx,2)];)
end

"""
    getzv2(Coef, Cx, Cy, xbunch, ybunch)

Computes z using nested for loops
"""
function getzv2(Coef, Off, Cx, Cy, xbunch, ybunch)
    z = zeros(size(xbunch));
    for i = 1:size(Cx,1)
        for j = 1:size(Cx,2)
            z = z + Coef[i,j]*cos.(2*pi*(Cx[i,j]*xbunch .+ Cy[i,j]*ybunch .+ Off[i,j]));

        end
    end
    return z
end

"""
    getzp(Coef, Cx, Cy, xbunch, ybunch)

Computes z using nested for loops
"""
function getzp3(Coef, Off, Cx, Cy, xbunch, ybunch)
    zp3 = SharedArray{Float64}(r, r)
    zp3[:,:] .= 0;
    @distributed for i = 1:size(Cx,1)
        for j = 1:size(Cx,2)
            zp3 .+= Coef[i,j]*cos.(2*pi*(Cx[i,j]*xbunch .+ Cy[i,j]*ybunch .+ Off[i,j]));
        end
    end
    return sdata(zp3)
end

"""
    normalize_surface(z)
"""
function normalize_surface(z)
    h=z .- (maximum(z)+minimum(z))/2
    maxh = maximum(h)
    g= h ./ (maxh+0.01)
    return g
end

"""
    label_lattice(lattice, lneigh=4)
"""
function label_lattice(lattice, lneigh=4)
    if lneigh==4
        k = [false true false; true true true; false true false]
    else
        k = trues(3,3)
    end
    return label_components(lattice, k); #Find the clusters
end

"""
    check_percolates(lablattice, perc_direction="vertical")    ```

* Lattice --- the surface we are looking at
* perc_direction - 0 for top to bottom, 1 for left to right check of percolation

* Set lattice values to 0 or 1 based on plane height

"""
function check_percolates(lablattice; perc_direction="vertical")

    if lowercase(perc_direction)[1] == 'v'
        last_row_labels =setdiff(lablattice[end,:],[0])
        if length(intersect(lablattice[1,:], last_row_labels)) !=0
            percolates = true
        else
            percolates = false
        end
    else
        last_col_labels =setdiff(lablattice[:,end],[0])
        if length(intersect(lablattice[:,1], last_col_labels)) != 0
            percolates = true
        else
            percolates = false
        end
    end

    return percolates
end

meshgrid(v::AbstractVector) = meshgrid(v, v)

function meshgrid(vx::AbstractVector, vy::AbstractVector)
#function meshgrid(vx, vy)
  m, n = length(vy), length(vx)
  vx = reshape(vx, 1, n)
  vy = reshape(vy, m, 1)
  (repeat(vx, m, 1), repeat(vy, 1, n))
end

function maptoimage(data; scale=255)
    tmp = data .- minimum(data)
    tmp = tmp ./ maximum(tmp)
    return Gray.(tmp)
end

"""
    getSurface(p; save_pngs=true, n=20, r=500, levels=100, outdir="levelsets")
"""
function getSurface(p; save_pngs=true, n=20, r=500, levels=100, outdir="levelsets")

    x, y = Sym("x, y")
    Off=rand(2*n+1, n+1)*2*pi

    #Red noise amplitude generator 2
    s=1/n
    coefn, coefm = meshgrid(0:s:1,-1:s:1)
    Lh = sqrt.(1.0 ./ ((1+p[1]^2 .- 2*p[1]*cos.(pi*coefn)).*(1+p[2]^2 .- 2*p[2]*cos.(pi*coefm))))
    Lh[n+1:2*n+1,1] .= 0
    Cx, Cy = meshgrid(0:1:n,-n:1:n)
    xbunch, ybunch = meshgrid((1/r):(1/r):1)

    #Generating Surface
    Coef = Lh

    z = normalize_surface(getz(Coef, Off, Cx, Cy, xbunch, ybunch))
    #levelset generation
    if save_pngs==true
        if ! isdir(outdir)
            mkpath(outdir)
        end
        for j=0:1:levels
            levelset=ceil.(z .+ (1-2/levels*j))
            filename=string(outdir, "/", format(j, width=3, zeropadding=true), ".png")
            save(filename, maptoimage(levelset))
        end
    end

    return [z, Off, Coef]
end

"""
    FindAreaFraction(z, PlaneHeight)
"""
function FindAreaFraction(z, PlaneHeight)

    # Is the `real` call necessary?
    NormalCount = sum(real(z .< PlaneHeight))
    a, b =size(z)
    AreaFraction = NormalCount/(a*b)
    return AreaFraction
end

end


"""
    getFirstPercLevel(z, startingLevel; accuracy=0.1, neighbors=4,
                           perc_direction="vertical", decRound=10)

z --is the surface (lattice?) we are looking at
startingLevel --a number representing the starting level of the plane that
                intersects the lattice.
accuracy -- a number used for delta height
#neighbors - 4 or 8 for nearest neighbor [4] or next nearest neighbor [8]
#horzvert - 0 for top to bottom, 1 for left to right check of percolation
#2 for either

decRound=10, deltaX=0.001, accuracy=0.1
"""
function getFirstPercLevel(z, startingLevel; accuracy=0.1,
                           neighbors=4,
                           perc_direction="vertical", decRound=10)

    count = 0
    surfaceLevel = startingLevel
    iterations = ceil(sqrt(2/accuracy))
    while count <= iterations
        count = count +1
        tmp = label_lattice(z .<= surfaceLevel, neighbors)
        if check_percolates(tmp, perc_direction=perc_direction)
            surfaceLevel = round(surfaceLevel - (1/(2^count)), digits=decRound)
        else
            surfaceLevel = round(surfaceLevel + (1/(2^count)), digits=decRound)
        end
    end

    return surfaceLevel
end

"""
    ```
    populateAreaFractionArrays(z, first_pc_level; decRound=10)
    ```

z: surface
first_pc_level: this is the level where percolation first occurs.
                decreasing the surfaceLevel from this value results in no percolation
                increasing the surfaceLevel above this results in continuing percolation
"""
function populateAreaFractionArrays(z, first_pc_level; decRound=10)

    PA=[]; # Vector of percolating area fractions
    NPA=[]; # Vector of non percolating area fractions
    surfaceLevel = first_pc_level; # save the first perc surface
    while surfaceLevel < 1
        PA=append!(PA, round(FindAreaFraction(z,surfaceLevel+0.1), digits=decRound))
        surfaceLevel = surfaceLevel + 0.1;
    end
    surfaceLevel = first_pc_level; #reset the surface level to perc level
    while surfaceLevel > -1
        NPA= append!(NPA, round(FindAreaFraction(z,surfaceLevel-0.1), digits=decRound))
        surfaceLevel = surfaceLevel - 0.1;
    end
    return PA, NPA
end


function process_surface(p, odir; labeling_neighborhood=4, accuracy=0.1,
                         n=20, r=500, levels=100,
                         save_pngs=true,
                         perc_direction="vertical")
    z, Off, Coef = getSurface(p, save_pngs=save_pngs, n=n, r=r, levels=levels, outdir=odir);
    startingLevel = 0
    surfaceLevel = getFirstPercLevel(z, startingLevel, accuracy=accuracy,
                                     neighbors=labeling_neighborhood,
                                     perc_direction=perc_direction)
    Af = FindAreaFraction(z, surfaceLevel)
    PA, NPA = populateAreaFractionArrays(z, surfaceLevel)
    return Af, PA, NPA
end


function graphPc(odir, deltaX, p, _PAall, _NPAall, labeling_neighborhood, numSurf; decRound=2)
    xx=[]
    yy=[]

    # What is the expected relationship (if any) between PAall and NPAall?
    PAall = round.(_PAall, digits=decRound)
    NPAall = round.(_NPAall, digits=decRound)

    for i=0:deltaX:1
        x=sum(PAall .== i)
        y=sum(NPAall .== i)
        percentage = x/(x+y)

        xx = append!(xx, i)
        yy = append!(yy, percentage)
    end
    sortIndex = sortperm(yy)
    sortedY = yy[sortIndex]
    sortedX = xx[sortIndex]
    col = findfirst(isequal(1), sortedY)
    Pc=sortedX[col-1]

    scatter(sortedX, sortedY, leg=false, marker=(:circle, 6, 0.1,  nothing,
                                                 Plots.stroke(1, :black)))


    xlabel!("Area Fraction")
    ylabel!("# Percolation")
    title!(string("Pc=",Pc, "p=[", p[1], ",", p[2], "], #neighbors= ", labeling_neighborhood,
      ",\nSurface count= ", numSurf, " ", "deltaX = ", deltaX, ",\nrounding decimal = ", decRound, " digits"))

    fname = string("pc_plot_",format(p[1], precision=2),"_",format(p[2], precision=2),
       "_n", format(labeling_neighborhood, width=1), "_s",
        format(numSurf, width=5, zeropadding=true), "_d",
        format(deltaX, precision=4), "_r",
        format(decRound, width=4, zeropadding=true), ".png")

    savefig(joinpath(odir,fname))
    return Pc

end
