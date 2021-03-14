"
TF_ImportGraphDefOptions holds options that can be passed to TF_GraphImportGraphDef.
"
Class {
	#name : #TFImportGraphDefOptions,
	#superclass : #FFIExternalObject,
	#category : #TensorFlowCore
}

{ #category : #converting }
TFImportGraphDefOptions class >> asExternalTypeOn: generator [
	^ FFIOpaqueObjectType objectClass: self
]

{ #category : #'instance creation' }
TFImportGraphDefOptions class >> create [
	^ TensorFlowCAPI current newImportGraphDefOptions
]

{ #category : #release }
TFImportGraphDefOptions >> delete [
	self isNull
		ifFalse: [ self library deleteImportGraphDefOptions: self ].
	handle := nil
]

{ #category : #release }
TFImportGraphDefOptions >> library [
	^ TensorFlowCAPI current
]
