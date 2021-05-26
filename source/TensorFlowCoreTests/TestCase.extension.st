Extension { #name : #TestCase }

{ #category : #'*TensorFlowCoreTests' }
TestCase >> assert: firstString isEqualSkippingSeparatorsTo: secondString [

	| firstSanitizedString secondSanitizedString |

	firstSanitizedString := firstString reject: [ :character | character isSeparator ].
	secondSanitizedString := secondString reject: [ :character | character isSeparator ].
	self assert: firstSanitizedString equals: secondSanitizedString
]

{ #category : #'*TensorFlowCoreTests' }
TestCase >> executeShould: aBlock inScopeOf: anException withSignalDo: anotherBlock [

	^[
		aBlock value.
		false]
			sunitOn: anException
			do: [:aSignal |
				anotherBlock value: aSignal.
				aSignal sunitExitWith: true]
]

{ #category : #'*TensorFlowCoreTests' }
TestCase >> should: aBlock raise: anException withDescription: aString [

	self
		should: aBlock
		raise: anException
		withSignalDo: [:exception |
			self assert: exception messageText isEqualSkippingSeparatorsTo: aString]
]

{ #category : #'*TensorFlowCoreTests' }
TestCase >> should: aBlock raise: anException withSignalDo: anotherBlock [

	^self
		assert: (self executeShould: aBlock inScopeOf: anException withSignalDo: anotherBlock)
		description: ('Expected exception (<1p>) wasn''t raised' expandMacrosWith: anException)
]
