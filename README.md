# libtensorflow-pharo-bindings

This is a fork of https://github.com/Cuis-Smalltalk/Machine-Learning for Pharo.

You will need a 64 bits Pharo VM in order to run the code. The code has only be tested on Pharo 7.0 on macOS with TensorFlow 1.7.

## Installation

- Install Pharo 64 bit VM and image from the command line : https://pharo.org/download
- Install TensorFlow on your computer.
On MacOS, you can do : 
```brew install tensorflow```
- Use Iceberg to load the code of this repository
- modify ```TensorFlowCAPI class>modulename```to put the path to where Tensorflow libraries are located.
