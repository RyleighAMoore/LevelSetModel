using Distributed
numprocs = parse(Int, ARGS[4])
println("Adding $numprocs workers")
addprocs(numprocs)

using Plots
using JSON
@everywhere include("./Percolation.jl")
@everywhere using .Percolation
using UUIDs
using Dates
using SQLite

@everywhere begin
    using Formatting
    using SymPy
    using Images
    using FileIO
    using Distributed
    using Plots
end

@everywhere using DistributedArrays

@everywhere pyplot()

function write_sqlite(r;dbname="perc.sqlite")
    conn = SQLite.DB("perc.sqlite")
    SQLite.query(conn, """INSERT INTO
                         simulations(
                         pc,
                         p1,
                         p2,
                         num_surfaces,
                         start_time,
                         end_time,
                         labeling_neighborhood,
                         dec_round, 
                         deltax,
                         accuracy, 
                         perc_direction,
                         data_dir,
                         user)
    VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?)""",
    values=[r["pc"], r["p"][1], r["p"][2], r["numSurf"], 
            string(r["startTime"]), string(r["endTime"]), 
            r["labeling_neighborhood"], r["decRound"],
            r["deltaX"], r["accuracy"], r["perc_direction"], 
            r["data_dir"], r["user"]])
end

C = procs()
D = distribute(C)

"""
    ```MainCode(p; numSurf=500, labeling_neighborhood=4, graphs=["histogram", "percgraph"], 
                     decRound=10, deltaX=0.001, accuracy=0.1, perc_direction="vertical")
    ```
p=[p1,p2] which are between 0 and 1.
numSurf: Number of surfaces to test
labeling_neighborhood: 4 nearest neighbor, 8 next nearest neighbor
graphNums: list of graph types to generate
deltaX:
accuracy:
perc_direction:
"""
function runSurfaces(p; numSurf=500, labeling_neighborhood=4, graphs=["histogram", "percgraph"], 
                     decRound=2, deltaX=0.001, accuracy=0.1, perc_direction="vertical")

    user = ENV["USER"]
    
    ddir = string(uuid4())
    odir = joinpath("data", ddir)
    if ! isdir(odir)
        mkpath(odir)
    end

    startTime = now()
    ssurfaces = collect(1:numSurf);
    psurfaces = distribute(ssurfaces);
    a = (r -> process_surface(p, joinpath(odir, 
                    string("levelsets", format(r, width=4, zeropadding=true ))),
                         labeling_neighborhood=labeling_neighborhood,
                         accuracy=accuracy,
                         n=20, r=500, levels=100,
                         perc_direction=perc_direction))
    rslts = map(a, psurfaces)
    return rslts, startTime, now(), odir
end

function main()

    plow = parse(Float64, ARGS[1])
    phigh = parse(Float64, ARGS[2])
    numSurf = parse(Int, ARGS[3])
    println("Running $numSurf surfaces")
    rslts, startTime, endTime, odir = runSurfaces([plow, phigh], numSurf=numSurf);

    println(length(rslts), startTime, endTime)

    areaFractions = [r[1] for r in rslts];
    PAall = reduce(append!, [r[2] for r in rslts]);
    NPAall = reduce(append!, [r[3] for r in rslts]);

    graphPc(odir, 0.001, [plow, phigh], PAall, NPAall, 
                        4, numSurf, decRound=2)
end 

main()
