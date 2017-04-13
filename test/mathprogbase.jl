@testset "Linear tests" begin
    include(joinpath(Pkg.dir("MathProgBase"),"test","linproginterface.jl"))
    linprogsolvertest(SDPASolver(), 1e-5)
end
@testset "Conic tests" begin
    include(joinpath(Pkg.dir("MathProgBase"),"test","conicinterface.jl"))

    @testset "Conic linear tests" begin
        coniclineartest(SDPASolver(), duals=true, tol=1e-5)
    end

    @testset "Conic SOC tests" begin
        conicSOCtest(SDPASolver(write_prob="soc.prob"), duals=true, tol=1e-5)
    end

    @testset "Conic SOC rotated tests" begin
        conicSOCRotatedtest(SDPASolver(), duals=true, tol=1e-5)
    end

    @testset "Conic SDP tests" begin
        conicSDPtest(SDPASolver(), duals=false, tol=1e-5)
    end
end

using SemidefiniteModels, MathProgBase
@testset "MPB interface" begin
    solver = SDPASolver()
    @test supportedcones(solver) == [:Free,:Zero,:NonNeg,:NonPos,:SOC,:RSOC,:SDP]
    m = SDModel(solver)
    @test_throws ErrorException loadproblem!(m, "in.dat-s")
    loadproblem!(m, [1], 0)
    @test_throws ErrorException setvartype!(m, :Int, 1, 1, 1)
    @test status(m) == :Uninitialized
end