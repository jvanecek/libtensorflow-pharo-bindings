# How to add as dependency

If you want to include this project as a dependency in your own baseline, add it to your `spec`.

```smalltalk
Metacello new
    githubUser: 'jvanecek' project: 'libtensorflow-pharo-bindings' commitish: 'new-model' path: 'source';
    baseline: 'LibTensorFlowPharoBinding';
    load: #('Development').
```
