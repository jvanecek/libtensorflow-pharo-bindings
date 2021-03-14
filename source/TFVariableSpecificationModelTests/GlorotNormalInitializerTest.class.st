Class {
	#name : #GlorotNormalInitializerTest,
	#superclass : #VariableInitializerTest,
	#category : 'TFVariableSpecificationModelTests'
}

{ #category : #Accessing }
GlorotNormalInitializerTest >> createCustomInitializer [

	^GlorotNormalInitializer withSeed: 2
]

{ #category : #Accessing }
GlorotNormalInitializerTest >> createDefaultInitializer [

	^GlorotNormalInitializer withSeed: 1
]

{ #category : #Accessing }
GlorotNormalInitializerTest >> createInitializerWithRandomSeed [

	^GlorotNormalInitializer new
]

{ #category : #Accessing }
GlorotNormalInitializerTest >> expectedMatrixValues [

	^(OrderedCollection new)
		add: #(0.091062 -0.354482 0.453829);
		add: #(-0.567185 -0.654192 -0.287002);
		yourself
]

{ #category : #Accessing }
GlorotNormalInitializerTest >> expectedScalarValue [

	^0.14398205
]

{ #category : #Accessing }
GlorotNormalInitializerTest >> expectedVectorValues [

	^#(-0.419695287942886 -0.122742906212807 -0.543764114379883)
]
