Class {
	#name : #DeterministicSeedTensorGenerator,
	#superclass : #PseudorandomTensorGenerator,
	#instVars : [
		'seed'
	],
	#category : #TensorFlowOperationRandomModel
}

{ #category : #'Instance Creation' }
DeterministicSeedTensorGenerator class >> fixedTo: anIntegerSeed [

	^self new initializeFixedTo: anIntegerSeed
]

{ #category : #Accessing }
DeterministicSeedTensorGenerator >> binomialTensorOn: aComputation shaped: aTensorShape withProbabilityOfSuccess: aProbabilityOfSuccess in: aNumberOfExperiments [

	^aComputation
		newOperationOf: 'StatelessRandomBinomial'
		namePrefixed: 'StatelessRandomBinomial'
		withAll:
			{ aTensorShape asInt32Tensor. { seed. 0 } asInt32Tensor.
			aNumberOfExperiments asFloatTensor. aProbabilityOfSuccess asFloatTensor }
		describedBy: [:description | description atDataTypePut: FloatDataType new]
]

{ #category : #Initialization }
DeterministicSeedTensorGenerator >> initializeFixedTo: anIntegerSeed [

	seed := anIntegerSeed
]

{ #category : #Accessing }
DeterministicSeedTensorGenerator >> truncatedNormalTensorOn: aComputation shaped: aTensorShape [

	^aComputation
		newOperationOf: 'StatelessTruncatedNormal'
		namePrefixed: 'StatelessTruncatedNormal'
		withAll: { aTensorShape asInt32Tensor. { seed. 0 } asInt32Tensor }
		describedBy: [:description | description atDataTypePut: FloatDataType new]
]

{ #category : #Accessing }
DeterministicSeedTensorGenerator >> uniformTensorOn: aComputation shaped: aTensorShape [

	^aComputation
		newOperationOf: 'StatelessRandomUniform'
		namePrefixed: 'StatelessRandomUniform'
		withAll: { aTensorShape asInt32Tensor. { seed. 0 } asInt32Tensor }
		describedBy: [:description | description atDataTypePut: FloatDataType new]
]
