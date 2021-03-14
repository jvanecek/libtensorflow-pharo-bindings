Extension { #name : #Collection }

{ #category : #'*VAST-Compatibility-Model' }
Collection >> any [

	^ self anyOne
]

{ #category : #'*VAST-Compatibility-Model' }
Collection >> conform: aBlockClosure [

	^ self allSatisfy: aBlockClosure
]
