# How to load LibTensorFlowBinding in a Pharo image

## Using Metacello

1. Download a [Pharo 11 VM and image](https://pharo.org/download)
2. Open your Pharo image
3. Open a Playground
4. Evaluate:

```smalltalk
Metacello new
    githubUser: 'jvanecek' project: 'libtensorflow-pharo-bindings' commitish: 'new-model' path: 'source';
    baseline: 'LibTensorFlowPharoBinding';
    load: #('Development').
```

## Using Iceberg

1. Download [Pharo 11 VM and image](https://pharo.org/download)
2. Open your Pharo image
3. Open Iceberg
4. Click the *Add* repository button
5. Select *Clone from github.com* and enter `jvanecek` as owner name and `libtensorflow-pharo-bindings` as project name
6. Click *Ok*
7. Select the repository in the main Iceberg window
8. Open the contextual menu and select
  *Metacello -> Install baseline of LibTensorFlowBinding ...*
9. Type `Development` and click *Ok*

> After Iceberg cloned a repository, it will be checked-out at the default
> branch (in this case `new-model`). If you want to work on a different
> branch or commit, perform the checkout before the baseline installation step.
