Class {
	#name : #DatasetProvider,
	#superclass : #Object,
	#instVars : [
		'fashionDataset',
		'handwrittenDigitsDataset',
		'shakespeareText'
	],
	#classInstVars : [
		'current'
	],
	#category : 'DatasetProviderModel'
}

{ #category : #'Instance Creation' }
DatasetProvider class >> clearCurrent [

	current := nil
]

{ #category : #'Instance Creation' }
DatasetProvider class >> current [

	current ifNil: [current := super new initialize].
	^current


]

{ #category : #'Instance Creation' }
DatasetProvider class >> new [

	^self current
]

{ #category : #Initialization }
DatasetProvider >> download: aRemoteFileUrl to: aTargetDirectory [

	aTargetDirectory asFileReference exists
		ifFalse: [ PublicResourceDownloader new downloadFileAt: aRemoteFileUrl to: aTargetDirectory ]
]

{ #category : #'Accessing - MNIST' }
DatasetProvider >> fashionDataset [

	fashionDataset ifNil: [self initializeFashionDataset].
	^fashionDataset
]

{ #category : #'Accessing - MNIST' }
DatasetProvider >> fashionDatasetOn: aTensorFlowComputation [

	^(SampleDatasetComputationAware
		on: aTensorFlowComputation
		transformingFeaturesWith: [:features | features reshapeFlattened / 255.0]
		transformingLabelsWith: [:labels | labels]
		applying: [:dataset | dataset inBatchesOf: 32])
			bindSetsFrom: self fashionDataset
]

{ #category : #'Accessing - MNIST' }
DatasetProvider >> handwrittenDigitsDataset [

	handwrittenDigitsDataset ifNil: [self initializeHandwrittenDataset].
	^handwrittenDigitsDataset
]

{ #category : #Initialization }
DatasetProvider >> initializeFashionDataset [

	| baseUrl baseDirectory |

	baseUrl := 'https://storage.googleapis.com/tensorflow/tf-keras-datasets/'.
	baseDirectory := './datasets/fashion-mnist' asFileReference.
	FileSystem disk workingDirectory fileSystem ensureCreateDirectory: baseDirectory.

	OrderedCollection new
		add: 'train-labels-idx1-ubyte.gz';
		add: 'train-images-idx3-ubyte.gz';
		add: 't10k-labels-idx1-ubyte.gz';
		add: 't10k-images-idx3-ubyte.gz';
		do: [:fileName |
			self
				download: ('<1s><2s>' expandMacrosWith: baseUrl with: fileName)
				to: baseDirectory / fileName].

	fashionDataset :=
		SampleDataset new
			bindTrainingSetTo: (
					self
						tensorTyped: TFTensor typeFloat
						fromFileNamed: baseDirectory / 'train-images-idx3-ubyte.gz')
				withLabels: (
					self
						tensorTyped: TFTensor typeInt32
						fromFileNamed: baseDirectory / 'train-labels-idx1-ubyte.gz');
			bindValidationSetTo: (
					self
						tensorTyped: TFTensor typeFloat
						fromFileNamed: baseDirectory / 't10k-images-idx3-ubyte.gz')
				withLabels: (
					self
						tensorTyped: TFTensor typeInt32
						fromFileNamed: baseDirectory / 't10k-labels-idx1-ubyte.gz');
			yourself
]

{ #category : #Initialization }
DatasetProvider >> initializeHandwrittenDataset [

	| baseUrl baseDirectory |

	baseUrl := 'http://yann.lecun.com/exdb/mnist/'.
	baseDirectory := './datasets/mnist-handwritten/' asFileReference.
	FileSystem disk workingDirectory fileSystem ensureCreateDirectory: baseDirectory.

	OrderedCollection new
		add: 'train-labels-idx1-ubyte.gz';
		add: 'train-images-idx3-ubyte.gz';
		add: 't10k-labels-idx1-ubyte.gz';
		add: 't10k-images-idx3-ubyte.gz';
		do: [:fileName |
			self
				download: ('<1s><2s>' expandMacrosWith: baseUrl with: fileName)
				to: baseDirectory / ('<1s>' expandMacrosWith: fileName)].

	handwrittenDigitsDataset :=
		SampleDataset new
			bindTrainingSetTo: (
					self
						tensorTyped: TFTensor typeFloat
						fromFileNamed: baseDirectory / 'train-images-idx3-ubyte.gz')
				withLabels: (
					self
						tensorTyped: TFTensor typeInt32
						fromFileNamed: baseDirectory / 'train-labels-idx1-ubyte.gz');
			bindTestingSetTo: (
					self
						tensorTyped: TFTensor typeFloat
						fromFileNamed: baseDirectory / 't10k-images-idx3-ubyte.gz')
				withLabels: (
					self
						tensorTyped: TFTensor typeInt32
						fromFileNamed: baseDirectory / 't10k-labels-idx1-ubyte.gz');
			yourself
]

{ #category : #Accessing }
DatasetProvider >> shakespeareText [

	shakespeareText ifNil: [
		shakespeareText :=
			self
				download:
					'https://storage.googleapis.com/download.tensorflow.org/data/shakespeare.txt'
				to: './datasets/shakespeare.txt' asFileReference].
	^shakespeareText
]

{ #category : #Accessing }
DatasetProvider >> tensorTyped: aTensorType fromFileNamed: aString [

	| file reader compressed |

	file := aString asFileReference.
	file exists
		ifFalse: [ AssertionFailure signal: ( #'Can''t find <1s>' expandMacrosWith: file asString ) ].
	compressed := file binaryReadStream.
	reader := IdxReader onStream: ( GZipReadStream on: compressed ) upToEnd asByteArray readStream.
	^ TFTensor
		fromNumbers: reader next
		type: aTensorType
		shape: ( TensorShape withDimensionsSized: reader dimensionSizes )
]
