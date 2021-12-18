Class {
	#name : #TFString,
	#superclass : #TFStructure,
	#category : #'TensorFlowCore-Structures'
}

{ #category : #finalization }
TFString class >> finalizeResourceData: handle [

	handle isNull ifTrue: [ ^ self ].
	TensorFlowCAPI current deleteString: self
]

{ #category : #'instance creation' }
TFString class >> with: aContent [ 

	^ TensorFlowCAPI current newStringWith: aContent
]

{ #category : #accessing }
TFString >> capacity [ 

	^ TensorFlowCAPI current stringGetCapacityOf: self
]

{ #category : #accessing }
TFString >> content [ 

	^ TensorFlowCAPI current stringGetDataOf: self
]

{ #category : #accessing }
TFString >> size [

	^TensorFlowCAPI current stringGetSizeOf: self
]

{ #category : #accessing }
TFString >> stringType [

	^ TensorFlowCAPI current stringGetTypeOf: self
]
