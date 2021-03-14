Extension { #name : #SequenceableCollection }

{ #category : #'*TensorFlowCore' }
SequenceableCollection >> asBooleanTensor [
	^ TFTensor fromBooleans: self
]

{ #category : #'*TensorFlowCore' }
SequenceableCollection >> asFloatTensor [
	^ TFTensor fromFloats: self
]

{ #category : #'*TensorFlowCore' }
SequenceableCollection >> asInt32Tensor [
	^ TFTensor fromInt32s: self
]

{ #category : #'*TensorFlowCore' }
SequenceableCollection >> asInt64Tensor [
	^ TFTensor fromInt64s: self
]

{ #category : #'*TensorFlowCore' }
SequenceableCollection >> asTensorShape [
	^ TensorShape withDimensionsSized: self
]

{ #category : #'*TensorFlowCore' }
SequenceableCollection class >> streamContents: blockWithArg estimatedSize: estimatedSize [

"Apparently a method coming from Cuis"
"We will rewrite this method later"

	| stream originalContents |
	stream := WriteStream on: (self new: estimatedSize).
	blockWithArg value: stream.
	originalContents := stream originalContents.
	^ stream position = originalContents size
		ifTrue: [ originalContents ]
		ifFalse: [ stream contents ]
]
