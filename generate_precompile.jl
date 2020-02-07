using SnoopCompile

@snoopiBot "BinaryBuilder" begin
    using BinaryBuilder
    # Do an actual build
    products = Product[
        ExecutableProduct("hello_world_c", :hello_world_c),
        ExecutableProduct("hello_world_cxx", :hello_world_cxx),
        ExecutableProduct("hello_world_fortran", :hello_world_fortran),
        ExecutableProduct("hello_world_go", :hello_world_go),
        ExecutableProduct("hello_world_rust", :hello_world_rust),
    ]

    # First, do the build, but only output the meta json, since we definitely want that to be fast
    build_tarballs(
        ["--meta-json=/dev/null"],
        "testsuite",
        v"1.0.0",
        # No sources
        DirectorySource[],
        # Build the test suite, install the binaries into our prefix's `bin`
        raw"""
        # Build testsuite
        make -j${nproc} -sC /usr/share/testsuite install
        # Install fake license just to silence the warning
        install_license /usr/share/licenses/MIT
        """,
        [platform_key_abi()],
        products,
        # No dependencies
        Dependency[];
        # We need to be able to build go and rust and whatnot
        compilers=[:c, :go, :rust],
    )

    # Next, actually do a build, since we want that to be fast too.
    build_tarballs(
        ["--verbose", "--debug"],
        "testsuite",
        v"1.0.0",
        # No sources
        DirectorySource[],
        # Build the test suite, install the binaries into our prefix's `bin`
        raw"""
        # Build testsuite
        make -j${nproc} -sC /usr/share/testsuite install
        # Install fake license just to silence the warning
        install_license /usr/share/licenses/MIT
        """,
        [platform_key_abi()],
        products,
        # No dependencies
        Dependency[];
        # We need to be able to build go and rust and whatnot
        compilers=[:c, :go, :rust],
    )
end
