# How to set the current library path

You need to tell the binding where to find the TensorFlow C API library.

Either set the environment variable `LIBTENSORFLOW_PATH` before running Pharo, or execute in a Pharo playground:

```smalltalk
TensorFlowCAPI current useTensorFlowLibraryAt: '/path/to/library/lib/libtensorflow.so'.
```

You can verify the library is correctly loaded and the version is as expected by inspecting:

```smalltalk
TensorFlowCAPI current version
```
