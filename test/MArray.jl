@testset "MArray" begin
    @testset "Inner Constructors" begin
        @test MArray{Tuple{1},Int,1,1}((1,)).data === (1,)
        @test MArray{Tuple{1},Float64,1,1}((1,)).data === (1.0,)
        @test MArray{Tuple{2,2},Float64,2,4}((1, 1.0, 1, 1)).data === (1.0, 1.0, 1.0, 1.0)
        @test isa(MArray{Tuple{1},Int,1,1}(), MArray{Tuple{1},Int,1,1})
        @test isa(MArray{Tuple{1},Int,1}(), MArray{Tuple{1},Int,1,1})
        @test isa(MArray{Tuple{1},Int}(), MArray{Tuple{1},Int,1,1})

        # Bad input
        @test_throws Exception MArray{Tuple{2},Int,1,2}((1,))
        @test_throws Exception MArray{Tuple{1},Int,1,1}(())

        # Bad parameters
        @test_throws Exception MArray{Tuple{1},Int,1,2}((1,))
        @test_throws Exception MArray{Tuple{1},Int,2,1}((1,))
        @test_throws Exception MArray{Tuple{1},1,1,1}((1,))
        @test_throws Exception MArray{Tuple{2},Int,1,1}((1,))
    end

    @testset "Outer constructors and macro" begin
        @test MArray{Tuple{1},Int,1}((1,)).data === (1,)
        @test MArray{Tuple{1},Int}((1,)).data === (1,)
        @test MArray{Tuple{1}}((1,)).data === (1,)

        @test MArray{Tuple{2,2},Int,2}((1,2,3,4)).data === (1,2,3,4)
        @test MArray{Tuple{2,2},Int}((1,2,3,4)).data === (1,2,3,4)
        @test MArray{Tuple{2,2}}((1,2,3,4)).data === (1,2,3,4)

        @test ((@MArray [1])::MArray{Tuple{1}}).data === (1,)
        @test ((@MArray [1,2])::MArray{Tuple{2}}).data === (1,2)
        @test ((@MArray Float64[1,2,3])::MArray{Tuple{3}}).data === (1.0, 2.0, 3.0)
        @test ((@MArray [1 2])::MArray{Tuple{1,2}}).data === (1, 2)
        @test ((@MArray Float64[1 2])::MArray{Tuple{1,2}}).data === (1.0, 2.0)
        @test ((@MArray [1 ; 2])::MArray{Tuple{2,1}}).data === (1, 2)
        @test ((@MArray Float64[1 ; 2])::MArray{Tuple{2,1}}).data === (1.0, 2.0)
        @test ((@MArray [1 2 ; 3 4])::MArray{Tuple{2,2}}).data === (1, 3, 2, 4)
        @test ((@MArray Float64[1 2 ; 3 4])::MArray{Tuple{2,2}}).data === (1.0, 3.0, 2.0, 4.0)

        @test ((@MArray [i for i = 1:2])::MArray{Tuple{2}}).data === (1, 2)
        @test ((@MArray [i*j for i = 1:2, j = 2:3])::MArray{Tuple{2,2}}).data === (2, 4, 3, 6)
        @test ((@MArray [i*j*k for i = 1:2, j = 2:3, k = 3:4])::MArray{Tuple{2,2,2}}).data === (6, 12, 9, 18, 8, 16, 12, 24)
        @test ((@MArray [i*j*k*l for i = 1:2, j = 2:3, k = 3:4, l = 1:2])::MArray{Tuple{2,2,2,2}}).data === (6, 12, 9, 18, 8, 16, 12, 24, 12, 24, 18, 36, 16, 32, 24, 48)
        @test ((@MArray [i*j*k*l*m for i = 1:2, j = 2:3, k = 3:4, l = 1:2, m = 1:2])::MArray{Tuple{2,2,2,2,2}}).data === (6, 12, 9, 18, 8, 16, 12, 24, 12, 24, 18, 36, 16, 32, 24, 48, 2*6, 2*12, 2*9, 2*18, 2*8, 2*16, 2*12, 2*24, 2*12, 2*24, 2*18, 2*36, 2*16, 2*32, 2*24, 2*48)
        @test ((@MArray [1 for i = 1:2, j = 2:3, k = 3:4, l = 1:2, m = 1:2, n = 1:2])::MArray{Tuple{2,2,2,2,2,2}}).data === ntuple(i->1, 64)
        @test ((@MArray [1 for i = 1:2, j = 2:3, k = 3:4, l = 1:2, m = 1:2, n = 1:2, o = 1:2])::MArray{Tuple{2,2,2,2,2,2,2}}).data === ntuple(i->1, 128) 
        @test ((@MArray [1 for i = 1:2, j = 2:3, k = 3:4, l = 1:2, m = 1:2, n = 1:2, o = 1:2, p = 1:2])::MArray{Tuple{2,2,2,2,2,2,2,2}}).data === ntuple(i->1, 256)
        @test (ex = macroexpand(:(@MArray [1 for i = 1:2, j = 2:3, k = 3:4, l = 1:2, m = 1:2, n = 1:2, o = 1:2, p = 1:2, q = 1:2])); isa(ex, Expr) && ex.head == :error)
        @test ((@MArray Float64[i for i = 1:2])::MArray{Tuple{2}}).data === (1.0, 2.0)
        @test ((@MArray Float64[i*j for i = 1:2, j = 2:3])::MArray{Tuple{2,2}}).data === (2.0, 4.0, 3.0, 6.0)
        @test ((@MArray Float64[i*j*k for i = 1:2, j = 2:3, k =3:4])::MArray{Tuple{2,2,2}}).data === (6.0, 12.0, 9.0, 18.0, 8.0, 16.0, 12.0, 24.0)
        @test ((@MArray Float64[i*j*k*l for i = 1:2, j = 2:3, k = 3:4, l = 1:2])::MArray{Tuple{2,2,2,2}}).data === (6.0, 12.0, 9.0, 18.0, 8.0, 16.0, 12.0, 24.0, 12.0, 24.0, 18.0, 36.0, 16.0, 32.0, 24.0, 48.0)
        @test ((@MArray Float64[i*j*k*l*m for i = 1:2, j = 2:3, k = 3:4, l = 1:2, m = 1:2])::MArray{Tuple{2,2,2,2,2}}).data === (6.0, 12.0, 9.0, 18.0, 8.0, 16.0, 12.0, 24.0, 12.0, 24.0, 18.0, 36.0, 16.0, 32.0, 24.0, 48.0, 2*6.0, 2*12.0, 2*9.0, 2*18.0, 2*8.0, 2*16.0, 2*12.0, 2*24.0, 2*12.0, 2*24.0, 2*18.0, 2*36.0, 2*16.0, 2*32.0, 2*24.0, 2*48.0)
        @test ((@MArray Float64[1 for i = 1:2, j = 2:3, k = 3:4, l = 1:2, m = 1:2, n = 1:2])::MArray{Tuple{2,2,2,2,2,2}}).data === ntuple(i->1.0, 64)
        @test ((@MArray Float64[1 for i = 1:2, j = 2:3, k = 3:4, l = 1:2, m = 1:2, n = 1:2, o = 1:2])::MArray{Tuple{2,2,2,2,2,2,2}}).data === ntuple(i->1.0, 128)
        @test ((@MArray Float64[1 for i = 1:2, j = 2:3, k = 3:4, l = 1:2, m = 1:2, n = 1:2, o = 1:2, p = 1:2])::MArray{Tuple{2,2,2,2,2,2,2,2}}).data === ntuple(i->1.0, 256)
        @test (ex = macroexpand(:(@MArray Float64[1 for i = 1:2, j = 2:3, k = 3:4, l = 1:2, m = 1:2, n = 1:2, o = 1:2, p = 1:2, q = 1:2])); isa(ex, Expr) && ex.head == :error)

        @test (ex = macroexpand(:(@MArray [1 2; 3])); isa(ex, Expr) && ex.head == :error)
        @test (ex = macroexpand(:(@MArray Float64[1 2; 3])); isa(ex, Expr) && ex.head == :error)
        @test (ex = macroexpand(:(@MArray fill)); isa(ex, Expr) && ex.head == :error)
        @test (ex = macroexpand(:(@MArray ones)); isa(ex, Expr) && ex.head == :error)
        @test (ex = macroexpand(:(@MArray fill())); isa(ex, Expr) && ex.head == :error)
        @test (ex = macroexpand(:(@MArray ones())); isa(ex, Expr) && ex.head == :error)
        @test (ex = macroexpand(:(@MArray fill(1))); isa(ex, Expr) && ex.head == :error)
        @test (ex = macroexpand(:(@MArray eye(5,6,7,8,9))); isa(ex, Expr) && ex.head == :error)

        @test ((@MArray fill(3.,2,2,1))::MArray{Tuple{2,2,1}, Float64}).data === (3.0, 3.0, 3.0, 3.0)
        @test ((@MArray zeros(2,2,1))::MArray{Tuple{2,2,1}, Float64}).data === (0.0, 0.0, 0.0, 0.0)
        @test ((@MArray ones(2,2,1))::MArray{Tuple{2,2,1}, Float64}).data === (1.0, 1.0, 1.0, 1.0)
        @test ((@MArray eye(2))::MArray{Tuple{2,2}, Float64}).data === (1.0, 0.0, 0.0, 1.0)
        @test ((@MArray eye(2,2))::MArray{Tuple{2,2}, Float64}).data === (1.0, 0.0, 0.0, 1.0)
        @test isa(@MArray(rand(2,2,1)), MArray{Tuple{2,2,1}, Float64})
        @test isa(@MArray(randn(2,2,1)), MArray{Tuple{2,2,1}, Float64})
        @test isa(@MArray(randexp(2,2,1)), MArray{Tuple{2,2,1}, Float64})
        
        @test isa(randn!(@MArray zeros(2,2,1)), MArray{Tuple{2,2,1}, Float64})
        @test isa(randexp!(@MArray zeros(2,2,1)), MArray{Tuple{2,2,1}, Float64})

        @test ((@MArray zeros(Float32, 2, 2, 1))::MArray{Tuple{2,2,1},Float32}).data === (0.0f0, 0.0f0, 0.0f0, 0.0f0)
        @test ((@MArray ones(Float32, 2, 2, 1))::MArray{Tuple{2,2,1},Float32}).data === (1.0f0, 1.0f0, 1.0f0, 1.0f0)
        @test ((@MArray eye(Float32, 2))::MArray{Tuple{2,2}, Float32}).data === (1.0f0, 0.0f0, 0.0f0, 1.0f0)
        @test ((@MArray eye(Float32, 2, 2))::MArray{Tuple{2,2}, Float32}).data === (1.0f0, 0.0f0, 0.0f0, 1.0f0)
        @test isa(@MArray(rand(Float32, 2, 2, 1)), MArray{Tuple{2,2,1}, Float32})
        @test isa(@MArray(randn(Float32, 2, 2, 1)), MArray{Tuple{2,2,1}, Float32})
        @test isa(@MArray(randexp(Float32, 2, 2, 1)), MArray{Tuple{2,2,1}, Float32})

        m = [1 2; 3 4]
        @test MArray{Tuple{2,2}}(m) == @MArray [1 2; 3 4]
    end

    @testset "Methods" begin
        m = @MArray [11 13; 12 14]

        @test isimmutable(m) == false

        @test m[1] === 11
        @test m[2] === 12
        @test m[3] === 13
        @test m[4] === 14

        @test Tuple(m) === (11, 12, 13, 14)

        @test size(m) === (2, 2)
        @test size(typeof(m)) === (2, 2)
        @test size(MArray{Tuple{2,2},Int,2}) === (2, 2)
        @test size(MArray{Tuple{2,2},Int}) === (2, 2)
        @test size(MArray{Tuple{2,2}}) === (2, 2)

        @test size(m, 1) === 2
        @test size(m, 2) === 2
        @test size(typeof(m), 1) === 2
        @test size(typeof(m), 2) === 2

        @test length(m) === 4
    end

    @testset "setindex!" begin
        v = @MArray [1,2,3]
        v[1] = 11
        v[2] = 12
        v[3] = 13
        @test v.data === (11, 12, 13)

        m = @MArray [0 0; 0 0]
        m[1] = 11
        m[2] = 12
        m[3] = 13
        m[4] = 14
        @test m.data === (11, 12, 13, 14)

        @test_throws BoundsError setindex!(v, 4, -1)
    end
end
