"Shows how you might create a macro for the autogenerated Jest rule"

load("@npm//jest-cli:index.bzl", "jest", _jest_test = "jest_test")
load("@bazel_skylib//rules:write_file.bzl", "write_file")

def jest_test(name, srcs, deps, jest_config, **kwargs):
    "A macro around the autogenerated jest_test rule"
    templated_args = [
        "--no-cache",
        "--no-watchman",
        "--ci",
        "--colors",
    ]
    templated_args.extend(["--config", "$(rootpath %s)" % jest_config])
    for src in srcs:
        templated_args.extend(["--runTestsByPath", "$(rootpath %s)" % src])

    data = [jest_config] + srcs + deps + ["jest-reporter.js"]
    _jest_test(
        name = name,
        data = data,
        templated_args = templated_args,
        **kwargs
    )

    # Make sure the update command runs with a working directory in the workspace
    # so that any created snapshot files are in the sources, not in the runfiles
    write_file(
        name = "chdir",
        out = "chdir.js",
        content = [
            # cd /path/to/workspace
            "process.chdir(process.env['BUILD_WORKSPACE_DIRECTORY'])",
            # cd subdir/package
            "process.chdir('%s')" % native.package_name() if native.package_name() else "",
        ],
    )

    # This rule is used specifically to update snapshots via `bazel run`
    jest(
        name = "%s.update" % name,
        data = data + ["chdir.js"],
        templated_args = templated_args + [
            "--updateSnapshot",
            "--runInBand",
            "--node_options=--require=$(rootpath chdir.js)",
        ],
        **kwargs
    )
