
# coding: utf-8

# In[1]:


using Distributed
addprocs(15)


# In[2]:


using Plots
#using PyPlot
using JSON
@everywhere include("./Percolation.jl")
@everywhere using .Percolation
using UUIDs
using Dates
using SQLite


# In[3]:


@everywhere begin
    using Formatting
    using SymPy
    using Images
    using FileIO
    using Distributed
    using Plots
end


# In[4]:


@everywhere using DistributedArrays


# In[5]:


@everywhere pyplot()


# In[ ]:


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


# In[ ]:


C = procs()
D = distribute(C)


# In[6]:


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
    return rslts, startTime, now()
end


# In[11]:


rslts, startTime, endTime = runSurfaces([0.45, 0.85], numSurf=400);


# In[9]:


length(rslts), startTime, endTime


# In[ ]:


areaFractions = [r[1] for r in rslts];
PAall = reduce(append!, [r[2] for r in rslts]);
NPAall = reduce(append!, [r[3] for r in rslts]);


# In[ ]:


odir = "data/b9afa54a-efdb-4d32-a860-d3ca43ae6988"


# In[ ]:


graphPc(odir, 0.001, [0.45, 0.75], PAall, NPAall, 
                     4, 500, decRound=2)


# In[ ]:


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
function MainCodeS(p; numSurf=500, labeling_neighborhood=4, graphs=["histogram", "percgraph"], 
                     decRound=2, deltaX=0.001, accuracy=0.1, perc_direction="vertical")

    user = ENV["USER"]
    
    ddir = string(uuid4())
    odir = joinpath("data", ddir)
    if ! isdir(odir)
        mkpath(odir)
    end
    areaFracs = []
    PAall =[]
    NPAall =[]
    z = nothing 
    joinpath(odir, "levelsets")
    startTime = now()
    ssurfaces = collect(1:numSurf);
    a = (r -> process_surface(p, joinpath(odir, 
                    string("levelsets", format(r, width=4, zeropadding=true ))),
                         labeling_neighborhood=labeling_neighborhood,
                         accuracy=accuracy,
                         n=20, r=r, levels=100,
                         perc_direction=perc_direction))
    rslts = map(a, ssurfaces)
    return rslts
end


# In[ ]:


@time walk(100)


# In[ ]:


Percolation.walk

