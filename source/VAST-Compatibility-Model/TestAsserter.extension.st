Extension { #name : #TestAsserter }

{ #category : #'*VAST-Compatibility-Model' }
TestAsserter >> assert: firstString isEqualSkippingSeparatorsTo: secondString [

	| firstSanitizedString secondSanitizedString |

	firstSanitizedString := firstString reject: [ :character | character isSeparator ].
	secondSanitizedString := secondString reject: [ :character | character isSeparator ].
	self assert: firstSanitizedString equals: secondSanitizedString
]
