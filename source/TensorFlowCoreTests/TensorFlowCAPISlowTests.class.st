Class {
	#name : #TensorFlowCAPISlowTests,
	#superclass : #TestCase,
	#category : #TensorFlowCoreTests
}

{ #category : #accessing }
TensorFlowCAPISlowTests class >> defaultTimeLimit [

	^ 15 minutes
]

{ #category : #'testing session' }
TensorFlowCAPISlowTests >> assertCreating: anAmount of: aTensorFlowObjectCreator releasesExternalMemoryRepeatingUpTo: timesRepeat [

	| total handles |

	total := 0.
	handles := Set new.
	timesRepeat timesRepeat: [
		total := total + anAmount.
		handles addAll: (
			(1 to: anAmount) collect: [:i |
				2 timesRepeat: [ Smalltalk garbageCollect ].
				aTensorFlowObjectCreator value getHandle getHandle ]).
		handles size < total ifTrue: [
			" Meaning some external addresses where reused, so we're good "
			^self]].
	self 
		assert: handles size < total
		description: 'No external address could be reused, check for some leak'
	
]

{ #category : #'testing graph' }
TensorFlowCAPISlowTests >> testGraphFinalizationReleasesExternalMemory [

	self
		assertCreating: 10
		of: [ TFGraph create useFinalization ]
		releasesExternalMemoryRepeatingUpTo: 20
]

{ #category : #'testing session' }
TensorFlowCAPISlowTests >> testSessionFinalizationReleasesExternalMemory [

	| graph |

	graph := TFGraph create.
	self assertCreating: 20 of: [ TFSession on: graph ] releasesExternalMemoryRepeatingUpTo: 20
]

{ #category : #'testing options' }
TensorFlowCAPISlowTests >> testSessionOptionFinalizationReleasesExternalMemory [

	self assertCreating: 10 of: [ TFSessionOptions create ] releasesExternalMemoryRepeatingUpTo: 20
]

{ #category : #'testing status' }
TensorFlowCAPISlowTests >> testStatusFinalizationReleasesExternalMemory [

	self assertCreating: 11 of: [ TFStatus create ] releasesExternalMemoryRepeatingUpTo: 1
]

{ #category : #'testing tensor' }
TensorFlowCAPISlowTests >> testTensorFinalizationReleasesExternalMemory [

	| template |

	template := {( String new: 10 ).
	( String new: 100 ).
	( String new: 1000 )}.
	self
		assertCreating: 20
		of: [ TFTensor fromStringArray: template ]
		releasesExternalMemoryRepeatingUpTo: 20
]
