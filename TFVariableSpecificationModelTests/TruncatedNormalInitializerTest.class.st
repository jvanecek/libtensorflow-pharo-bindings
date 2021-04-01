Class {
	#name : #TruncatedNormalInitializerTest,
	#superclass : #VariableInitializerTest,
	#category : 'TFVariableSpecificationModelTests'
}

{ #category : #Test }
TruncatedNormalInitializerTest >> createCustomInitializer [

	^TruncatedNormalInitializer centeredOn: 0.3 spreadedBy: 0.9 withSeed: 2
]

{ #category : #Test }
TruncatedNormalInitializerTest >> createDefaultInitializer [

	^TruncatedNormalInitializer withSeed: 1
]

{ #category : #Accessing }
TruncatedNormalInitializerTest >> createInitializerWithRandomSeed [

	^TruncatedNormalInitializer new
]

{ #category : #Test }
TruncatedNormalInitializerTest >> expectedMatrixValues [

	^OrderedCollection new
		add: #(0.006333 -0.024651 0.03156);
		add: #(-0.039442 -0.045493 -0.019958);
		yourself
]

{ #category : #Test }
TruncatedNormalInitializerTest >> expectedScalarValue [

	^0.0063325153
]

{ #category : #Test }
TruncatedNormalInitializerTest >> expectedVectorValues [

	^#(-0.275486 0.131695 -0.44561)
]
