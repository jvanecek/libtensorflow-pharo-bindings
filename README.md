# libtensorflow-pharo-bindings

[![Build Status](https://github.com/jvanecek/libtensorflow-pharo-bindings/workflows/Build/badge.svg?branch=new-model)](https://github.com/jvanecek/libtensorflow-pharo-bindings/actions?query=workflow%3ABuild)
[![Coverage Status](https://codecov.io/github/jvanecek/libtensorflow-pharo-bindings/coverage.svg?branch=new-model)](https://codecov.io/gh/jvanecek/libtensorflow-pharo-bindings/branch/new-model)

This is a fork of the [PolyMathOrg](https://github.com/PolyMathOrg/libtensorflow-pharo-bindings)'s TensorFlow C++ library binding for Pharo. 

This library is available for [Cuis](https://github.com/Cuis-Smalltalk/Machine-Learning)'s and [VA Smalltalk](http://github.com/vast-community-hub/tensorflow-vast/).

You will need a 64 bits Pharo VM in order to run the code. The code has only been tested in Pharo 7.0 to 9.0 with [TensorFlow 2.3.1](https://github.com/tensorflow/tensorflow/releases/tag/v2.3.1)

## Installation

- Install any Pharo 7.0, 8.0 or 9.0 (64 bit VM and image) from the command line: https://pharo.org/download
- Install the project in Pharo executing the following script:

```Smalltalk
    Metacello new
    	githubUser: 'jvanecek' project: 'libtensorflow-pharo-bindings' commitish: 'new-model' path: 'source';
    	baseline: 'LibTensorFlowPharoBinding';
    	load: #('Development')
```

Alternatively you can use Iceberg to load the code of this repository (See the video [here](https://youtu.be/U6Ttcc1KJUg))

To add the project to your baseline just add this:

```Smalltalk
    spec
    	baseline: 'LibTensorFlowPharoBinding'
    	with: [ spec repository: 'github://jvanecek/libtensorflow-pharo-bindings' ]
```

## Installation of TensorFlow C API 

In Linux you can use the [installation script](scripts/install-tensorflow.sh). For Windows and MacOS check the Tensorflow for C [installation guide](https://www.tensorflow.org/install/lang_c). 


### On MacOS
- Check method ```TensorFlowCAPI>>macModulename``` to put the path to where Tensorflow libraries are located on your computer:
```Smalltalk
TensorFlowCAPI>>macModulename
  ^ '/usr/local/Cellar/libtensorflow/1.12.0/lib/libtensorflow.so'
  ```
  
### On Linux
- Check method ```TensorFlowCAPI>>unixModulename``` to put the path to where Tensorflow libraries are located on your computer:
```Smalltalk
TensorFlowCAPI>>unixModulename
  ^ '/usr/local/lib/libtensorflow.so'
  ```
