Class {
	#name : #RandomSeedTensorGenerator,
	#superclass : #PseudorandomTensorGenerator,
	#category : #TensorFlowOperationRandomModel
}

{ #category : #Accessing }
RandomSeedTensorGenerator >> binomialTensorOn: aComputation shaped: aTensorShape withProbabilityOfSuccess: aProbabilityOfSuccess in: aNumberOfExperiments [

	| rngAlgorithm |

	rngAlgorithm := PhiloxRandom new.
	^aComputation
		newOperationOf: 'StatefulRandomBinomial'
		namePrefixed: 'StatefulRandomBinomial'
		withAll:
			{ rngAlgorithm createInitialStateOn: aComputation.
			rngAlgorithm uniqueIdentifier asInt64Tensor. aTensorShape asInt32Tensor.
			aNumberOfExperiments asFloatTensor. aProbabilityOfSuccess asFloatTensor }
		describedBy: [:description | description atDataTypePut: FloatDataType new]
]

{ #category : #Accessing }
RandomSeedTensorGenerator >> truncatedNormalTensorOn: aComputation shaped: aTensorShape [

	^aComputation
		newOperationOf: 'TruncatedNormal'
		namePrefixed: 'TruncatedNormal'
		withAll: { aTensorShape asInt32Tensor }
		describedBy: [:description | description atDataTypePut: FloatDataType new]
]

{ #category : #Accessing }
RandomSeedTensorGenerator >> uniformTensorOn: aComputation shaped: aTensorShape [

	^aComputation
		newOperationOf: 'RandomUniform'
		namePrefixed: 'RandomUniform'
		withAll: { aTensorShape asInt32Tensor }
		describedBy: [:description | description atDataTypePut: FloatDataType new]
]
