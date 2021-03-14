Extension { #name : #Number }

{ #category : #'*TFOperationModel' }
Number >> outputOn: aGraph [

	^(self asOperationOn: aGraph) firstOutput
]
