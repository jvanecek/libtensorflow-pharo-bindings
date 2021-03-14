Extension { #name : #SequenceableCollection }

{ #category : #'*VAST-Compatibility-Model' }
SequenceableCollection >> beginsWithSubCollection: aSequenceableCollection [

	"Answer whether the receiver begins with @aSequenceableCollection.
	 The comparison is case-sensitive."

	^ self size < aSequenceableCollection size
		ifTrue: [ ^ false ]
		ifFalse: [ ( self indexOfSubCollection: aSequenceableCollection startingAt: 1 ) = 1 ]
]
