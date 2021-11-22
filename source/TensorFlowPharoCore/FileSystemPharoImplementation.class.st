Class {
	#name : #FileSystemPharoImplementation,
	#superclass : #Object,
	#category : #TensorFlowPharoCore
}

{ #category : #'class initialization' }
FileSystemPharoImplementation class >> initialize [

	FileSystemAPI setCurrentToUse: self new
]

{ #category : #accessing }
FileSystemPharoImplementation >> directoryNamed: aDirectoryName [

	| directory |

	directory := aDirectoryName asFileReference.
	FileSystem disk workingDirectory fileSystem ensureCreateDirectory: directory.
	^ directory
]

{ #category : #accessing }
FileSystemPharoImplementation >> downloadFileAt: datasetURL to: outputFileName [

	outputFileName exists
		ifTrue: [ ^ outputFileName asFileReference ].
	UIManager default
		informUserDuring: [ :bar | 
			bar label: 'Downloading MNIST dataset ...'.
			[ ZnClient new
				url: datasetURL;
				signalProgress: true;
				downloadTo: outputFileName
			]
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
			].
	^ outputFileName asFileReference
]

{ #category : #accessing }
FileSystemPharoImplementation >> idxReaderOn: aFileName [

	| file compressed |

	file := aFileName asFileReference.
	file exists
		ifFalse: [ AssertionFailure signal: ( #'Can''t find <1s>' expandMacrosWith: file asString ) ].
	compressed := file binaryReadStream.
	^ IdxReader onStream: ( GZipReadStream on: compressed ) upToEnd asByteArray readStream
]

{ #category : #'private - accessing' }
FileSystemPharoImplementation >> printHumanReadableSize: aTotalNumber [

	| humanReadable length unit |

	length := ( aTotalNumber decimalDigitLength / 3 ) truncated - 1 max: 0.
	humanReadable := ( aTotalNumber / ( 1024 raisedTo: ( length min: 3 ) ) ) rounded.
	length = 0
		ifTrue: [ unit := 'bytes' ].
	length = 1
		ifTrue: [ unit := 'KB' ].
	length = 2
		ifTrue: [ unit := 'MB' ].
	length = 3
		ifTrue: [ unit := 'GB' ].
	^ humanReadable printString , ' ' , unit
]

{ #category : #accessing }
FileSystemPharoImplementation >> readIdxFileNamed: aFileName thenDo: aBlockClosure [

	| reader |

	reader := self idxReaderOn: aFileName.
	aBlockClosure value: reader dimensionSizes value: reader next
]
