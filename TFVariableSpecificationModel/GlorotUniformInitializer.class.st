Class {
	#name : #GlorotUniformInitializer,
	#superclass : #VariableNodeInitializer,
	#instVars : [
		'tensorGenerator'
	],
	#category : 'TFVariableSpecificationModel'
}

{ #category : #'Instance Creation' }
GlorotUniformInitializer class >> generatingTensorWith: aRandomTensorGenerator [

	^super new initializeGeneratingTensorWith: aRandomTensorGenerator
]

{ #category : #'Instance Creation' }
GlorotUniformInitializer class >> new [

	^self generatingTensorWith: RandomSeedTensorGenerator new
]

{ #category : #'Instance Creation' }
GlorotUniformInitializer class >> withSeed: anIntegerSeed [

	^self generatingTensorWith: (DeterministicSeedTensorGenerator fixedTo: anIntegerSeed)
]

{ #category : #Applying }
GlorotUniformInitializer >> applyTo: aTFVariable [

	aTFVariable assign: (
		tensorGenerator
			glorotUniformTensorOn: aTFVariable graph
			shaped: aTFVariable outputShape)
]

{ #category : #Initialization }
GlorotUniformInitializer >> initializeGeneratingTensorWith: aRandomTensorGenerator [

	tensorGenerator := aRandomTensorGenerator
]
