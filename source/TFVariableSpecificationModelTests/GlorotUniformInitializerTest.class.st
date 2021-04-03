Class {
	#name : #GlorotUniformInitializerTest,
	#superclass : #VariableInitializerTest,
	#category : 'TFVariableSpecificationModelTests'
}

{ #category : #Accessing }
GlorotUniformInitializerTest >> createCustomInitializer [

	^GlorotUniformInitializer withSeed: 2
]

{ #category : #Accessing }
GlorotUniformInitializerTest >> createDefaultInitializer [

	^GlorotUniformInitializer withSeed: 1
]

{ #category : #Accessing }
GlorotUniformInitializerTest >> createInitializerWithRandomSeed [

	^GlorotUniformInitializer new
]

{ #category : #Accessing }
GlorotUniformInitializerTest >> expectedMatrixValues [

	^(OrderedCollection new)
		add: #(0.829226 -0.087679 0.219727);
		add: #(-0.235307 -0.540726 -0.122034);
		yourself
]

{ #category : #Accessing }
GlorotUniformInitializerTest >> expectedScalarValue [

	^1.3111216
]

{ #category : #Accessing }
GlorotUniformInitializerTest >> expectedVectorValues [

	^#(0.601958 0.409434 0.394356)
]