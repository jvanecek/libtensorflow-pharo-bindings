Class {
	#name : #RandomBinomialnitializerTest,
	#superclass : #VariableInitializerTest,
	#category : #TensorFlowOperationRandomModelTests
}

{ #category : #Accessing }
RandomBinomialnitializerTest >> createCustomInitializer [

	^RandomBinomialInitializer withProbabilityOfSuccess: 0.6 in: 10 withSeed: 1
]

{ #category : #Accessing }
RandomBinomialnitializerTest >> createDefaultInitializer [

	^RandomBinomialInitializer withSeed: 1
]

{ #category : #Accessing }
RandomBinomialnitializerTest >> createInitializerWithRandomSeed [

	^RandomBinomialInitializer new
]

{ #category : #Accessing }
RandomBinomialnitializerTest >> expectedMatrixValues [

	^ #( ( 1 0 0 ) ( 1 0 0 )  )
]

{ #category : #Accessing }
RandomBinomialnitializerTest >> expectedScalarValue [
	
	^ 1
]

{ #category : #Accessing }
RandomBinomialnitializerTest >> expectedVectorValues [

	^#(7 7 6)
]
