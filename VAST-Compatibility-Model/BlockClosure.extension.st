Extension { #name : #BlockClosure }

{ #category : #'*VAST-Compatibility-Model' }
BlockClosure >> sunitOn: exception do: handlerBlock [
	^self on: exception do: handlerBlock
]
