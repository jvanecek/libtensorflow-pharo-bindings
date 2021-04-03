Extension { #name : #Number }

{ #category : #'*TFOperationModel' }
Number >> outputOn: aComputation [

	^ ( self asOperationOn: aComputation ) value firstOutput
]
