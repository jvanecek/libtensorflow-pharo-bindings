# libtensorflow-pharo-bindings

[![Unit Tests](https://github.com/jvanecek/libtensorflow-pharo-bindings/actions/workflows/build.yml/badge.svg?branch=new-model)](https://github.com/jvanecek/libtensorflow-pharo-bindings/actions?query=workflow%3ABuild)
[![Coverage Status](https://codecov.io/github/jvanecek/libtensorflow-pharo-bindings/coverage.svg?branch=new-model)](https://codecov.io/gh/jvanecek/libtensorflow-pharo-bindings/branch/new-model)
[![Pharo 11](https://img.shields.io/badge/Pharo-11-informational)](https://pharo.org)
[![TF 2.15.0](https://zenodo.org/badge/DOI/10.5281/zenodo.10126399.svg)](https://doi.org/10.5281/zenodo.10126399)

This project is a fork of [PolyMathOrg](https://github.com/PolyMathOrg/libtensorflow-pharo-bindings), a binding of the TensorFlow C++ library for Pharo Smalltalk.

On top of the low-level binding, this repository adds a set of abstraction layers for building and training neural networks in Pharo, including:

- **TensorFlowComputation** – execution context and graph management  
- **Math Operations** – basic and advanced tensor operations  
- **Model / Layers** – sequential and dense layers, etc.  
- **Training** – model update routines and training workflows  
- **Gradient-Based Optimizers** – Adam, RMSProp, and more  
- **Datasets** – input pipelines for CSV, text, random and batch datasets  

The same framework is also available for other Smalltalk dialects: [VA Smalltalk](http://github.com/vast-community-hub/tensorflow-vast/) and [Cuis Smalltalk](https://github.com/jvanecek/Machine-Learning) (which is still in early development).

This project is the result of the undergraduate thesis *"Deep Learning on Dynamically-Typed Object-Oriented Languages"* for the **Computer Science Master at Universidad de Buenos Aires**.

## Quick links

- [**Explore the docs**](docs/Installation.md)
- [Report a defect](https://github.com/jvanecek/libtensorflow-pharo-bindings/issues/new?labels=Type%3A+Defect)
- [Request a feature](https://github.com/jvanecek/libtensorflow-pharo-bindings/issues/new?labels=Type%3A+Feature)

## License

- The code is licensed under [MIT](LICENSE).
- The documentation is licensed under [CC BY-SA 4.0](http://creativecommons.org/licenses/by-sa/4.0/).

## Installation

To load the project in a Pharo image follow these [instructions](docs/Installation.md).

## Contributing

Check the [Contribution Guidelines](CONTRIBUTING.md)
