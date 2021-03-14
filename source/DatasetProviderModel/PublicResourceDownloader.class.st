Class {
	#name : #PublicResourceDownloader,
	#superclass : #Object,
	#category : #DatasetProviderModel
}

{ #category : #accessing }
PublicResourceDownloader >> downloadFileAt: datasetURL to: outputFileName [

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
PublicResourceDownloader >> printHumanReadableSize: aTotalNumber [

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
