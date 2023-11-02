using DataFrames,CSV,FileIO,Pipe



"""
    get_files_list(path::String)
    读取数据集表名
TBW
"""
function get_files_list(path::String)
    nameArr=[];dfArr=[]
    for (_, _, files) in walkdir(path)
        for file in files
            name,suffix = split(file, ".")
            if suffix == "csv"
                res = CSV.File(joinpath(path, file)) |> DataFrame
                push!(dfArr, res)
                push!(nameArr, name)
            else
                continue
            end
        end
        
    end
    return nameArr
end
#get_files_list("./books/Lock5Data3eCSV")|>DataFrame(name=_)|>write("./books/list.csv",_)

function load_csv(str::String)
   return CSV.File("../Lock5Data3eCSV/$str.csv") |> DataFrame |> dropmissing
end

"""
    freq_table(df;typename=nothing)
    返回 df 的列联表
    typename 为可选参数为第一列,表示列联表的目录项和合计
    typename=["Agree","Disagree","Don't know","Total"]
TBW
"""
function freq_table(df;typename=nothing)
        if typename === nothing
            typename = [["cat$i" for i in 1:size(df,1)]...,"Total"]
        end
       transform!(df, (names(df)) => ByRow(+) => :Total)
       d=sum.(eachcol(df))
       push!(df,d)
       df.Type=typename
       df=select(df,[:Type,Symbol.(names(df[!,1:end-1]))...])
       #@pt df
       return df
    end




## struct

"""
define  table structure
"""
Base.@kwdef struct  Lock5Table
    page::Int
    name::AbstractString
    question:: AbstractString
    feature::Vector{Union{AbstractString,Symbol}}
end



