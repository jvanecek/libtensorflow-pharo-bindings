Class {
	#name : #MNISTFile,
	#superclass : #Object,
	#instVars : [
		'count',
		'items'
	],
	#category : #LibTensorFlowExamplesApp
}

{ #category : #private }
MNISTFile class >> download: aName [

	| datasetURL outputFileName |
	" I changed the original http://yann.lecun.com/exdb/mnist/, because is constantly unavailable "
	datasetURL := 'https://github.com/jvanecek/datasets/blob/main/mnist-handwritten/' , aName, '?raw=true'.
	outputFileName := self fullDatasetNamed: aName.
	self
		informUserProgressOf: [ | client |

			client := ZnClient new
				url: datasetURL;
				signalProgress: true.

			( client downloadTo: outputFileName )
				ifFalse: [ self
						error:
							( 'Could not download <1s> (<2p>)'
								expandMacrosWith: datasetURL
								with: client response statusLine reason )
					]
			].
	^ outputFileName asFileReference
]

{ #category : #'instance creation' }
MNISTFile class >> fromFile: aString [

	| file filename reader compressed |

	filename := aString , '.gz'.
	file := ( self fullDatasetNamed: filename ) asFileReference.
	file exists
		ifFalse: [ file := self download: filename ].
	compressed := file binaryReadStream.
	reader := IdxReader onStream: ( GZipReadStream on: compressed ) upToEnd asByteArray readStream.
	^ self fromReader: reader
]

{ #category : #'instance creation' }
MNISTFile class >> fromReader: aReader [
	| answer |
	answer := self new.
	^ answer parse: aReader
]

{ #category : #private }
MNISTFile class >> fullDatasetNamed: aName [

	| fullname |

	fullname := 'dataset/' , aName.
	FileSystem disk workingDirectory fileSystem ensureCreateDirectory: 'dataset'.
	^ fullname
]

{ #category : #private }
MNISTFile class >> informUserProgressOf: aBlock [

	UIManager default
		informUserDuring: [ :bar | 
			bar label: 'Downloading MNIST dataset ...'.

			aBlock
				on: HTTPProgress
				do: [ :progress | 
					progress isEmpty
						ifFalse: [ bar current: progress percentage.
							progress total
								ifNotNil: [ :aTotalNumber | 
									| humanReadable |

									humanReadable := self printHumanReadableSize: aTotalNumber.
									bar label: 'Downloading ' , humanReadable , ' of MNIST dataset ... '
									]
							].
					progress resume
					]
			]
]

{ #category : #private }
MNISTFile class >> printHumanReadableSize: aTotalNumber [
	| humanReadable length unit |
	length := ((aTotalNumber decimalDigitLength / 3) truncated) - 1 max: 0.
	humanReadable := (aTotalNumber / (1024 raisedTo: (length min: 3))) rounded.
	length = 0 ifTrue: [ unit := 'bytes' ].
	length = 1 ifTrue: [ unit := 'KB' ].
	length = 2 ifTrue: [ unit := 'MB' ].
	length = 3 ifTrue: [ unit := 'GB' ].
	^ humanReadable printString, ' ', unit
]

{ #category : #accessing }
MNISTFile class >> testName [
	^ self subclassResponsibility 
]

{ #category : #tests }
MNISTFile class >> testSet [
	^self fromFile: self testName
	
]

{ #category : #accessing }
MNISTFile class >> trainName [
	^ self subclassResponsibility 
]

{ #category : #tests }
MNISTFile class >> trainingSet [
	^self fromFile: self trainName
	
]

{ #category : #converting }
MNISTFile >> asTensor [
	^ self subclassResponsibility 
]

{ #category : #accessing }
MNISTFile >> count [
	^ count
]

{ #category : #accessing }
MNISTFile >> items [
	^ items
]

{ #category : #initialization }
MNISTFile >> parse: aReader [
	count := (aReader dimensionSizes) at:1
]
