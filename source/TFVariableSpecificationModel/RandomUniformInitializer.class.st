Class {
	#name : #RandomUniformInitializer,
	#superclass : #VariableNodeInitializer,
	#instVars : [
		'mean',
		'standardDeviation',
		'tensorGenerator',
		'minimumValue',
		'maximumValue'
	],
	#category : 'TFVariableSpecificationModel'
}

{ #category : #'Instance Creation' }
RandomUniformInitializer class >> boundedBetween: aMinimumValue and: aMaximumValue withSeed: anIntegerSeed [

	^self
		generatingValuesBetween: aMinimumValue
		and: aMaximumValue
		with: (DeterministicSeedTensorGenerator fixedTo: anIntegerSeed)
]

{ #category : #Accessing }
RandomUniformInitializer class >> defaultMaximumValue [

	^0.05
]

{ #category : #Accessing }
RandomUniformInitializer class >> defaultMinimumValue [

	^-0.05
]

{ #category : #'Instance Creation' }
RandomUniformInitializer class >> generatingValuesBetween: aMinimumValue and: aMaximumValue with: aRandomTensorGenerator [

	^super new
		initializeGeneratingValuesBetween: aMinimumValue
		and: aMaximumValue
		with: aRandomTensorGenerator
]

{ #category : #'Instance Creation' }
RandomUniformInitializer class >> lowerBoundedBy: aMinimumValue withSeed: anIntegerSeed [

	^self
		generatingValuesBetween: aMinimumValue
		and: self defaultMaximumValue
		with: (DeterministicSeedTensorGenerator fixedTo: anIntegerSeed)
]

{ #category : #'Instance Creation' }
RandomUniformInitializer class >> new [

	^self
		generatingValuesBetween: self defaultMinimumValue
		and: self defaultMaximumValue
		with: RandomSeedTensorGenerator new
]

{ #category : #'Instance Creation' }
RandomUniformInitializer class >> upperBoundedBy: aMaximumValue withSeed: anIntegerSeed [

	^self
		generatingValuesBetween: self defaultMinimumValue
		and: aMaximumValue
		with: (DeterministicSeedTensorGenerator fixedTo: anIntegerSeed)
]

{ #category : #'Instance Creation' }
RandomUniformInitializer class >> withSeed: anIntegerSeed [

	^self
		generatingValuesBetween: self defaultMinimumValue
		and: self defaultMaximumValue
		with: (DeterministicSeedTensorGenerator fixedTo: anIntegerSeed)
]

{ #category : #Applying }
RandomUniformInitializer >> applyTo: aTFVariable [

	aTFVariable assign: (
		tensorGenerator
			uniformTensorOn: aTFVariable graph
			shaped: aTFVariable outputShape
			boundedBetween: minimumValue
			and: maximumValue)
]

{ #category : #Initialization }
RandomUniformInitializer >> initializeGeneratingValuesBetween: aMinimumValue and: anMaximumValue with: aRandomTensorGenerator [

	minimumValue := aMinimumValue.
	maximumValue := anMaximumValue.
	tensorGenerator := aRandomTensorGenerator
]