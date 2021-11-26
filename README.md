Bazel for JS/TS/Node - Proof of concept 

# Install dependencies
```
yarn install
```

# Build
## Trasnpile TS files to JS
```
bazel build :ts-transpile
```

## Build HTTP web server
```
bazel build :server
```

## Build tests with Jest
```
bazel build :test
```

# Run
## Run HTTP web-server
```
bazel run :server
```

## Run tests
```
bazel run :test
```