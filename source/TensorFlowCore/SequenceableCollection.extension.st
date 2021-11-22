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
SequenceableCollection >> inferTensorRank [

	^1 + self first inferTensorRank
]

{ #category : #'*TensorFlowCore' }
SequenceableCollection >> inferTensorShape [

	^self isEmpty
		ifTrue: [TensorShape vectorSized: 0]
		ifFalse: [
			TensorShape withDimensionsSized:
				((Array with: self size) , (self first inferTensorShape dimensionSizes))]
]
