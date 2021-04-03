Class {
	#name : #GlorotNormalInitializer,
	#superclass : #VariableNodeInitializer,
	#instVars : [
		'tensorGenerator'
	],
	#category : 'TFVariableSpecificationModel'
}

{ #category : #'Instance Creation' }
GlorotNormalInitializer class >> generatingTensorWith: aRandomTensorGenerator [

	^super new initializeGeneratingTensorWith: aRandomTensorGenerator
]

{ #category : #'Instance Creation' }
GlorotNormalInitializer class >> new [

	^self generatingTensorWith: RandomSeedTensorGenerator new
]

{ #category : #'Instance Creation' }
GlorotNormalInitializer class >> withSeed: anIntegerSeed [

	^self generatingTensorWith: (DeterministicSeedTensorGenerator fixedTo: anIntegerSeed)
]

{ #category : #Applying }
GlorotNormalInitializer >> applyTo: aTFVariable [

	aTFVariable assign: (
		tensorGenerator glorotNormalTensorOn: aTFVariable graph shaped: aTFVariable outputShape)
]

{ #category : #Initialization }
GlorotNormalInitializer >> initializeGeneratingTensorWith: aRandomTensorGenerator [

	tensorGenerator := aRandomTensorGenerator
]