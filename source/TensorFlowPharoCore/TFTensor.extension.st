Extension { #name : #TFTensor }

{ #category : #'*TensorFlowPharoCore' }
TFTensor class >> asExternalTypeOn: aFFICallout [ 
	^ FFIOpaqueObjectType objectClass: self
]
