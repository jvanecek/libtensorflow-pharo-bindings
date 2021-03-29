Class {
	#name : #TFAttrMetadata,
	#superclass : #TFStructure,
	#classVars : [
		'OFFSET_IS_LIST',
		'OFFSET_LIST_SIZE',
		'OFFSET_TOTAL_SIZE',
		'OFFSET_TYPE'
	],
	#category : #TensorFlowCore
}

{ #category : #'field definition' }
TFAttrMetadata class >> fieldsDesc [
	"self rebuildFieldAccessors"

	^ #(byte is_list;
	 int64 list_size;
	 int type;
	 int64 total_size;
	)
]

{ #category : #types }
TFAttrMetadata >> isBoolean [
	^ self type = 3
]

{ #category : #types }
TFAttrMetadata >> isFloat [
	^ self type = 2
]

{ #category : #types }
TFAttrMetadata >> isFunc [
	^ self type = 8
]

{ #category : #types }
TFAttrMetadata >> isInt [
	^ self type = 1
]

{ #category : #'accessing structure variables' }
TFAttrMetadata >> isList [
	^ self is_list = 1
]

{ #category : #types }
TFAttrMetadata >> isPlaceholder [
	^ self type = 7
]

{ #category : #types }
TFAttrMetadata >> isShape [
	^ self type = 5
]

{ #category : #types }
TFAttrMetadata >> isString [
	^ self type = 0
]

{ #category : #types }
TFAttrMetadata >> isTensor [
	^ self type = 6
]

{ #category : #types }
TFAttrMetadata >> isType [
	^ self type = 4
]

{ #category : #'accessing structure variables' }
TFAttrMetadata >> is_list [
	"This method was automatically generated"
	^handle unsignedByteAt: OFFSET_IS_LIST
]

{ #category : #'accessing structure variables' }
TFAttrMetadata >> is_list: anObject [
	"This method was automatically generated"
	handle unsignedByteAt: OFFSET_IS_LIST put: anObject
]

{ #category : #accessing }
TFAttrMetadata >> listSize [

	^ self list_size
]

{ #category : #'accessing structure variables' }
TFAttrMetadata >> list_size [
	"This method was automatically generated"
	^handle signedLongLongAt: OFFSET_LIST_SIZE
]

{ #category : #'accessing structure variables' }
TFAttrMetadata >> list_size: anObject [
	"This method was automatically generated"
	handle signedLongLongAt: OFFSET_LIST_SIZE put: anObject
]

{ #category : #accessing }
TFAttrMetadata >> totalSize [

	^ self total_size
]

{ #category : #'accessing structure variables' }
TFAttrMetadata >> total_size [
	"This method was automatically generated"
	^handle signedLongLongAt: OFFSET_TOTAL_SIZE
]

{ #category : #'accessing structure variables' }
TFAttrMetadata >> total_size: anObject [
	"This method was automatically generated"
	handle signedLongLongAt: OFFSET_TOTAL_SIZE put: anObject
]

{ #category : #'accessing structure variables' }
TFAttrMetadata >> type [
	"This method was automatically generated"
	^handle signedLongAt: OFFSET_TYPE
]

{ #category : #'accessing structure variables' }
TFAttrMetadata >> type: anObject [
	"This method was automatically generated"
	handle signedLongAt: OFFSET_TYPE put: anObject
]
